#!/bin/bash
BASEDIR=/mnt/us/extensions/kykky
TOTAL=0
YESTERDAY=0
TODAY=0
WEEK=0
MONTH=0
TODAYTIME=`date +%s -d 00:00`
YESTERDAYTIME=$((TODAYTIME-24*60*60))
WEEKTIME=$((TODAYTIME-((`date +%w`+6)%7)*24*60*60)) #星期一零点
MONTHTIME=$((TODAYTIME-(`date +%e` -1)*24*60*60)) #本月1号零点

#定义周阅读时间数组
i=1
while [ $i -le 7 ]; do
    eval "WDAY_$i=0"
    i=$((i+1))
done

mkfifo -m 777 tpipe
cat $BASEDIR/log/metrics_reader_* |
awk 'BEGIN{FS=","}{print $2,$7}' > tpipe

while read ENDTIME DURATION
do
	DURATION=$((DURATION/1000))
	STARTTIME=$((ENDTIME-DURATION))
	TOTAL=$((TOTAL+DURATION))
	#①...... □ □ □ □ □ □ □ □ □ □ 00:00 ......  today +=  0
	#②...... □ □ □ □ □ 00:00 ■ ■ ■ ■ ■ ......  today +=  5
	#③...... 00:00 ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ......  today += 10	
	if [[ $STARTTIME -gt $TODAYTIME ]]; then  #③
		TODAY=$((TODAY+DURATION))
		#今天开始今天结束
	else #今天之前开始
		if [[ $ENDTIME -gt $TODAYTIME ]]; then           #②
			TODAY=$((TODAY+ENDTIME-TODAYTIME))
			YESTERDAY=$((YESTERDAY+TODAYTIME-STARTTIME))
			#昨天开始今天结束
		fi
		if [[ $STARTTIME -gt $YESTERDAYTIME ]] ; then  #③
			if [[ $ENDTIME -lt $TODAYTIME ]]; then
				YESTERDAY=$((YESTERDAY+DURATION))
			fi
		else
			if [[ $ENDTIME -gt $YESTERDAYTIME ]]; then           #②
				YESTERDAYT=$((YESTERDAY+ENDTIME-YESTERDAYTIME))
			fi
		fi 

	fi
	if [[ $STARTTIME -gt $WEEKTIME ]]; then  #③
		WEEK=$((WEEK+DURATION))
	else
		if [[ $ENDTIME -gt $WEEKTIME ]]; then           #②
			WEEK=$((WEEK+ENDTIME-WEEKTIME))
		fi
	fi
	if [[ $STARTTIME -gt $MONTHTIME ]]; then  #③
		MONTH=$((MONTH+DURATION))
	else
		if [[ $ENDTIME -gt $MONTHTIME ]]; then           #②
			MONTH=$((MONTH+ENDTIME-MONTHTIME))
		fi
	fi
	
	#循环计算周时长
	if [ $ENDTIME -ge $WEEKTIME ]; then
        WINDEX=`date -d @$((ENDTIME/1)) +%u`
        
        eval "OLD_WDAY_VAL=\$WDAY_$WINDEX"
        eval "WDAY_$WINDEX=\$((OLD_WDAY_VAL + DURATION))"
    fi

done < tpipe

rm -f tpipe

today_result=`printf "今日时长 :%4dH %02dm %02ds" $((TODAY/3600)) $((TODAY%3600/60)) $((TODAY%60))`
yesterday_result=`printf "昨天时长 :%4dH %02dm %02ds" $((YESTERDAY/3600)) $((YESTERDAY%3600/60)) $((YESTERDAY%60))`
week_result=`printf "本周时长 :%4dH %02dm %02ds" $((WEEK/3600)) $((WEEK%3600/60)) $((WEEK%60))`
month_result=`printf "本月时长 :%4dH %02dm %02ds" $((MONTH/3600)) $((MONTH%3600/60)) $((MONTH%60))`
total_result=`printf "总计阅读 :%4dH %02dm %02ds" $((TOTAL/3600)) $((TOTAL%3600/60)) $((TOTAL%60))`

# 周统计
MAX_S=1
i=1
while [ $i -le 7 ]; do
    eval "S=\$WDAY_$i"
    if [ "${S:-0}" -gt "$MAX_S" ]; then MAX_S=$S; fi
    i=$((i+1))
done

i=1
while [ $i -le 7 ]; do
    eval "S=\$WDAY_$i"
    if [ -z "$S" ]; then S=0; fi

    case $i in
        1) NAM="周一";; 2) NAM="周二";; 3) NAM="周三";; 4) NAM="周四";;
        5) NAM="周五";; 6) NAM="周六";; 7) NAM="周日";; 
    esac
    case $i in 
        1) VN="LINE_MON";; 2) VN="LINE_TUE";; 3) VN="LINE_WED";;
        4) VN="LINE_THU";; 5) VN="LINE_FRI";; 6) VN="LINE_SAT";;
        7) VN="LINE_SUN";;
    esac

    PREFIX=`printf "%s %3dH %02dm  " "$NAM" $((S/3600)) $((S%3600/60))`

    BAR_LEN=$(( S * 40 / MAX_S ))
    
    BAR=""
    j=0
    while [ $j -lt $BAR_LEN ]; do
        BAR="${BAR} "
        j=$((j+1))
    done

    eval "$VN=\"$PREFIX$BAR\""
    
    i=$((i+1))
done

#最终输出
fbink -qm -t regular=/usr/java/lib/fonts/STHeitiMedium.ttf,top=640,size=10 \
"===================" \
"$today_result" \
"$yesterday_result" \
"$week_result" \
"$month_result" \
"===================" \
"$total_result" \
"  " \
"===========本周统计==========="

fbink -q -C WHITE -B GRAY1 -t regular=/usr/java/lib/fonts/STHeitiMedium.ttf,top=1030,left=180,size=10 \
"$LINE_MON" \
"$LINE_TUE" \
"$LINE_WED" \
"$LINE_THU" \
"$LINE_FRI" \
"$LINE_SAT" \
"$LINE_SUN"


echo $total_result,$today_result,`date` >>$BASEDIR/log/debug_total_today.log

