+++  
title = '嵌套虚拟化'  
date = 2024-04-12T09:39:39Z  
draft = true  
+++

##### 1、查看内核版本
```
[root@kvm ~]# uname -r
3.10.0-327.el7.x86_64
```
##### 2、查看netsted引导参数，默认不开启，需要重新加载模块，并修改它的引导参数
```
[root@kvm ~]# cat /sys/module/kvm_intel/parameters/nested   
N
```
##### 3、移除kvm_intel模块，移除前先关闭所有虚拟机，不然会报错
```
[root@kvm ~]# rmmod kvm_intel

或

modprobe -r kvm_intel
```
##### 4、重新加载并开启nested功能
[root@kvm ~]# modprobe kvm_intel nested=1
##### 5、再次查看netsted引导参数
```
[root@kvm ~]# cat /sys/module/kvm_intel/parameters/nested   
Y
```
##### 6、以上开启nested的方式在重启的时候失效，如果需要永久生效可以通过如下方式：
```
[root@kvm ~]# echo "options kvm-intel nested=1" >> /etc/modprobe.d/kvm_intel.conf 
```