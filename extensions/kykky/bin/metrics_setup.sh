#!/bin/sh
BASEDIR=/mnt/us/extensions/kykky

## enable
metric_enable()
{
	mntroot rw
	mv /etc/syslog-ng/syslog-ng.conf $BASEDIR/etc/syslog-ng.conf.bak
	cp $BASEDIR/etc/syslog-ng.conf /etc/syslog-ng/syslog-ng.conf
	mntroot ro
	restart syslog
	touch ./etc/enable
}

## disable
metric_disable()
{
	mntroot rw
	rm -f /etc/syslog-ng/syslog-ng.conf
	cp $BASEDIR/etc/syslog-ng.conf.bak /etc/syslog-ng/syslog-ng.conf
	mntroot ro
	restart syslog
	rm -f ./etc/enable
}


## reset
metric_reset() 
{
	rm -f ./log/*
	usleep 150000
	eips 15 35 "Reset success"
	usleep 1000000
	eips 15 35 "             "
}

## Main
case "$1" in
	"enable" )
		echo "Enable Kykky..."
		metric_enable
	;;
	"disable" )
		echo "Disable Kykky..."
		metric_disable
	;;
	"reset" )
		echo "Cleaning Kykky Data..."
		metric_reset
	;;
	* )
	;;
esac
