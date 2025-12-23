# KYKKY
Know your kindle, Know Yourself---a kindle plugin to record your reading statistics 

一个统计你阅读时长的Kindle插件。

> This plugin is based on [totoptlp](http://tieba.baidu.com/home/main?un=totoptlp&ie=utf-8&fr=pb&ie=utf-8)的作品[让Kindle实现阅读时间统计](http://tieba.baidu.com/p/4077881510) 

原理与原始插件保持相同，依然是读取系统日志，不过我加了更多功能，提供了一个gtk应用，可以更优雅的查看阅读统计！

毕竟新一点的系统应该打不开. awz2 格式的Kindlet了嘛...

# 功能

统计和显示今天和总共的阅读时长，并且可以显示当天和本周的阅读时长分布，甚至还有月视图！

效果见下方的截图。

# 兼容性
在我自己的Kindle Oasis上测试可用，系统版本5.16.2.1.1

界面布局可能没有适配其他分辨率的kindle型号，请自行测试。

对于固件版本高于 5.16.3 的Kindle,我提供了Kindle HF的二进制，但不保证绝对可用（我没有测试用的设备）。

本插件需要安装fbink，新版本的越狱应当会自动安装。

相近的系统版本应当都可用，请自行测试，如果不起作用，只有禁用插件并删除即可，没有副作用。

# 安装
1. 给你的Kindle越狱 [中文](https://kindlefere.com/post/410.html) & [English](http://www.mobileread.com/forums/showthread.php?t=275877)
2. 安装 KUAL[中文](https://kindlefere.com/post/311.html)
3. 到Release页面，下载本仓库的zip压缩包，然后把插件（extensions）目录复制到kindle的数据目录，确保插件目录内存在kykky目录。
4. 点击“开启阅读统计”，可能需要重启，插件内数据可能不会及时刷新，耐心等待即可。
5. 以下步骤用于安装主程序的二进制文件（适用于0.2版本）
6. 前往 https://github.com/TQHYG/kindle-reading-gtk/releases 界面，根据 Release 界面上的说明下载
   + 固件版本低于 5.16.3 请下载 kindle-reading-gtk_pw2 ，这个版本是armel
   + 固件版本高于 5.16.3 请下载 kindle-reading-gtk_hf ，这个版本是armhf
7. 将下载下来的文件重命名成 kindle-reading-gtk ，注意文件名不要有后缀
8. 把下载下来的文件放到插件目录下的bin目录中（ extensions/kykky/bin/ ）

最终的目录结构应该看起来像这样：

+ Kindle驱动器
  + extensions
    + kykky
      + bin
        + kindle-reading-gtk
        + metrics_setup.sh
        + metrics.sh
      + config.xml
      + etc
        + syslog-ng.conf
        + syslog-ng.conf.bak
      + log
      + menu.json

# TODO
~~也许可以把它做成gtk应用，提供更完整的月统计视图（遥遥无期）~~

没想到真的把gtk应用做出来了，离谱。

所以暂时没有Todo？大家有想实现的功能就提出issue吧，我**不一定**会实现（**？**）

# 截图

<img src="https://github.com/TQHYG/kykky/raw/master/screenshots/screenshot1.png" height="500px">

<img src="https://github.com/TQHYG/kykky/raw/master/screenshots/screenshot2.png" height="500px">

<img src="https://github.com/TQHYG/kykky/raw/master/screenshots/screenshot3.png" height="500px">

<img src="https://github.com/TQHYG/kykky/raw/master/screenshots/screenshot4.png" height="500px">


# ACKNOWLEDGEMENT
This plugin is based on [totoptlp](http://tieba.baidu.com/home/main?un=totoptlp&ie=utf-8&fr=pb&ie=utf-8)的作品[让Kindle实现阅读时间统计](http://tieba.baidu.com/p/4077881510)