# firsttweak
firsttweak is a tweak demo for studying.

#### 1. 安装dpkg与ldid 
````
brew install dpkg ldid
````
#### 2. 安装Theos
````
sudo git clone --recursive https://github.com/theos/theos.git /opt/theos
````

给theos安装目录权限

````
sudo chown $(id -u):$(id -g) /opt/theos

````
配置环境变量

````
vim ~/.bash_profile
````
在.bash_profile文件的末尾加上

````
export THEOS=/opt/theos export PATH=/opt/theos/bin/:$PATH
````

然后执行

````
source ~/.bash_profile
````

#### 3. 开始编写tweak

在终端输入`nic.pl`, 然后选择`iphone/tweak`对应的编号

````
$ nic.pl
NIC 2.0 - New Instance Creator
------------------------------
  [1.] iphone/activator_event
  [2.] iphone/application_modern
  [3.] iphone/application_swift
  [4.] iphone/cydget
  [5.] iphone/flipswitch_switch
  [6.] iphone/framework
  [7.] iphone/ios7_notification_center_widget
  [8.] iphone/library
  [9.] iphone/notification_center_widget
  [10.] iphone/preference_bundle_modern
  [11.] iphone/tool
  [12.] iphone/tool_swift
  [13.] iphone/tweak
  [14.] iphone/xpc_service
Choose a Template (required):
````
选择13， 输入项目名称FirstTweak

````
Choose a Template (required): 13
Project Name (required): FirstTweak
````
Package Name直接回车，Author默认回车，剩下的一直回车即可。

````
Package Name [com.yourcompany.firsttweak]:
Author/Maintainer Name [daye]: daye
[iphone/tweak] MobileSubstrate Bundle filter [com.apple.springboard]:
[iphone/tweak] List of applications to terminate upon installation (space-separated, '-' for none) [SpringBoard]:
Instantiating iphone/tweak in firsttweak/...
Done.
````

#### 4. 安装tweak

将22端口转发到22222

````
iproxy 22222 22
````

回到终端，cd到tweak目录, 连接我们的越狱手机

````
$ make package install
````

如果报错，缺少`THEOS_DEVICE_IP`，在终端输入如下

````
export THEOS_DEVICE_IP=localhost:22222
````

再次执行`make package install`
结果如下：

````
$ make package install
xcrun: error: sh -c '/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild -sdk /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS13.2.sdk -find llvm-dsymutil 2> /dev/null' failed with exit code 17664: (null) (errno=No such file or directory)
xcrun: error: unable to find utility "llvm-dsymutil", not a developer tool or in PATH
> Making all for tweak FirstTweak…
xcrun: error: sh -c '/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild -sdk /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS13.2.sdk -find llvm-dsymutil 2> /dev/null' failed with exit code 17664: (null) (errno=No such file or directory)
xcrun: error: unable to find utility "llvm-dsymutil", not a developer tool or in PATH
xcrun: error: sh -c '/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild -sdk /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS13.2.sdk -find llvm-dsymutil 2> /dev/null' failed with exit code 17664: (null) (errno=No such file or directory)
xcrun: error: unable to find utility "llvm-dsymutil", not a developer tool or in PATH
make[2]: Nothing to be done for `internal-library-compile'.
> Making stage for tweak FirstTweak…
xcrun: error: sh -c '/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild -sdk /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS13.2.sdk -find llvm-dsymutil 2> /dev/null' failed with exit code 17664: (null) (errno=No such file or directory)
xcrun: error: unable to find utility "llvm-dsymutil", not a developer tool or in PATH
dm.pl: building package `com.yourcompany.firsttweak:iphoneos-arm' in `./packages/com.yourcompany.firsttweak_0.0.1-3+debug_iphoneos-arm.deb'
==> Installing…
root@localhost's password:
Selecting previously unselected package com.yourcompany.firsttweak.
(Reading database ... 2140 files and directories currently installed.)
Preparing to unpack /tmp/_theos_install.deb ...
Unpacking com.yourcompany.firsttweak (0.0.1-3+debug) ...
Setting up com.yourcompany.firsttweak (0.0.1-3+debug) ...
install.exec "killall -9 SpringBoard"
root@localhost's password:
````

输入两次密码后，成功安装到手机。