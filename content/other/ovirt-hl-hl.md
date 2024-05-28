+++
title = ''
date = 2024-04-12T09:39:39Z
draft = true
+++
+++
title = Ovirt 相关
date = 2024-04-12T09:39:39Z
draft = true
+++
# Ovirt 相关
## 一、介绍
> oVirt是一个开源服务，是部署在操作系统（CentOS、Red Hat Enterprise Linux）上的桌面虚拟化平台。
##### 1、oVirt-engine
> 虚拟机允许你配置你的网络，存储，节点还有镜像，虚拟机也提供了命令行工具ovirt-engine-cli和很实用的API（ovirt-engine-api），包含了python包装器，这个wrapper可以允许开发者整合功能到第三方的shell脚本中管理。
##### 2、VDSM
> 这个虚拟桌面和服务管理守护进程运行在oVirt的管理节点上，允许oVirt远程的部署，开始，停止monitor端的机器。
##### 3、oVirt-node
> 虚拟节点仅是一个运行在虚拟机上的操作系统，他也可以把一个标准发行版的linux转换成一个节点，这个节点可以通过 ovirt-engine管理，通过VDSM和其他依赖安装。
##### 4、dwh and reports
> 对于ovirt-engine，报告和数据仓库的这个组件是可选择的，并且是分别分装和开发的。
##### 5、基本概念
* 数据中心：数据中心是所有物理资源和逻辑资源的最大容器单位，它是所有虚拟机，存储，和网络的集合。
* 集群： 一个集群指的是物理主机的集合，在这里，主机可以看做是虚拟机的资源池。在同一个集群中的主机共享相同的网络和存储架构，而且集群中的虚拟机可以在属于该集群的不同的主机之间迁移。
* 逻辑网络：逻辑网络是物理网络在逻辑上的表示，它把网络负载根据管理流量，主机流量，存储流量和虚拟机的流量分组，从而更好的实现网络的管理和流量的分离。
* 主机：主机就是物理上的服务器，虚拟机在主机上运行。一个主机可以运行一个或者多个虚拟机，正如上面提到的，是主机组成了集群。在一个集群中的虚拟机可以在不同的主机间迁移。
* 存储池：存储池是一个逻辑上的概念，包含同一种存储类型的仓库，比如 iSCSI，Fibre Channel，NFS，或者 POSIX。每一种存储池都可以包含几个同类型的存储域，用来存储虚拟机镜像，ISO 文件，或者是用来导入/导出存储域。
* 虚拟机：虚拟机就像实际的机器一样，有自己的硬件(CPU，内存等)，包含操作系统和一系列应用软件。 EayunOS 系统中的虚拟机有两种: 虚拟桌面和虚拟服务器。多个同样的虚拟机能同时快速的在一个池里面创建。注意，虚拟机的创建，管理，删除等操作只能被超级用户和授予相关权限的用户执行。
* 模板：模板是一种虚拟机模型，这种模型预先定义了虚拟机的很多内容，比如操作系统等。通过模板，可以在简单的一个操作中以最快的方式创建大量的虚拟机。
* 虚拟机池：虚拟机池是指一组相同的虚拟机的集合。对一些特定的目的，虚拟机池很有用。比如不同部门虚拟机使用的划分，一个池给市场部门用，另一个池给研发部门用，等等。
* 快照：快照是指某一个时间点虚拟机操作系统的所有内容的一个状态。快照有很多用途，比如在升级虚拟机或者修改虚拟机内容的时候，可以建立一个快照，当升级完系统出问题的时候，可以用快照恢复到之前的状态。
* 用户类型：系统支持不同级别的管理员和用户权限。系统管理员管理物力资源，比如数据中心，主机，存储资源等。是系统管理员建立的虚拟机池和虚拟机，用户具有访问这些虚拟机的能力。
* 事件和监控：报警，警告和其它关于系统的通知可以帮助系统管理员更好的了解整个系统的性能和资源的状态。
* 报表：从基于 JasperReports 的报表模块，或是数据库产生需要的报表。用户也可以使用任何支持 SQL 语句的查询工具查询包含主机，虚拟机和存储等的监控数据。
## 二、系统要求
| 资源              | 最小要求       |
| ----------------- | -------------- |
| CPU               | 2核            |
| Memory            | >4GB           |
| Hard Disk         | >25G           |
| Network Interface | >1张 ， >1Gbps |
## 三、安装
[install ovirt](https://www.ovirt.org/documentation/install-guide/chap-Installing_oVirt.html)
##### 1、安装ovirt-engine相关软件
```
yum -y install http://resources.ovirt.org/pub/yum-repo/ovirt-release43.rpm
yum -y update
yum -y install nfs-utils ovirt-engine
```
##### 2、配置ovirt-engine
```
engine-setup
```
##### 3、连接到管理员界面
> 在浏览器输入地址，https://your-manager-fqdn/ovirt-engine，第一次登陆用户名admin。
```
# vim /etc/ovirt-engine/engine.conf.d/99-custom-sso-setup.conf
SSO_ALTERNATE_ENGINE_FQDNS=alias1.example.com alias2.example.com
admin@internal
http://myovirt:80/ovirt-engine
https://myovirt:443/ovirt-engine
```
##### 4、添加存储
```
systemctl start rpcbind
systemctl enable rpcbind
mkdir /iso /data /import_export
chown -R vdsm:kvm /iso 
chown -R vdsm:kvm /data
chown -R vdsm:kvm /import_export
在exports中添加相关内容
vim /etc/exports
vim /etc/exports.d/ovirt-engine-iso-domain.exports
/iso            *(rw,sync,no_subtree_check,all_squash,anonuid=36,anongid=36)
/data           *(rw,sync,no_subtree_check,all_squash,anonuid=36,anongid=36)
/import_export  *(rw,sync,no_subtree_check,all_squash,anonuid=36,anongid=36)
systemctl restart rpcbind
systemctl restart nfs
exportfs -r
service ovirt-engine restart
```
##### 5、上传iso镜像
```
engine-iso-uploader -i iso upload /root/cirros-0.3.4-x86_64-disk.iso
```
##### 6、查看ovirt-engine日志
```
tailf /var/log/ovirt-engine/engine.log
```
##### 7、ovirt node
> 安装完oVirt Engine服务后，就可以安装节点主机来运行虚拟机了。在oVirt架构中，你可以使用 oVirt Node, Fedora 或者 CentOS 做为节点主机的操作系统。
> centos7 node 修改hosts文件engine加进去
##### 8、使用virsh list
```
virsh list
vdsm@ovirt
shibboleth
hosted-engine --help
```
## 四、ovirt编译
#### （一）、使用rpm方式编译
```
wget http://resources.ovirt.org/pub/ovirt-4.1/rpm/el7Workstation/SRPMS/ovirt-engine-4.1.4.2-1.el7.centos.src.rpm
//axel -n 4 http://resources.ovirt.org/pub/ovirt-4.1/rpm/el7Workstation/SRPMS/ovirt-engine-4.1.4.2-1.el7.centos.src.rpm
rpm -i ovirt-engine-4.1.4.2-1.el7.centos.src.rpm
vim ~/rpmbuild/SPECS/ovirt-engine.spec
rpm -ql ovirt-engine |grep jar
yum -y install rpm-build
rpmbuild -ba ~/rpmbuild/SPECS/ovirt-engine.spec //根据 spec 文件同时构建二进制 RPM 和源代码 RPM 
//rpm -U
```
> Building locales requires more than 10240 available file descriptors, currently 1024
```
ulimit -n 10240
```
> [ERROR] OutOfMemoryError: Increase heap size or lower gwt.jjs.maxThreads
```
cd /root/rpmbuild/SOURCES
tar -zxvf ovirt-engine-4.1.4.2.tar.gz
vim frontend/webadmin/modules/pom.xml
<gwt.jvmArgs>-Xms8g -Xmx8g -XX:MaxDirectMemorySize=4096m</gwt.jvmArgs>  //Two JVM options are often used to tune JVM heap size: -Xmx for maximum heap size, and -Xms for initial heap size.
<gwt-plugin.extraJvmArgs>
-Dgwt.jjs.permutationWorkerFactory=com.google.gwt.dev.ThreadedPermutationWorkerFactory 
-Dgwt.jjs.maxThreads=1 
-Djava.io.tmpdir=${project.build.directory}/tmp 
-Djava.util.prefs.systemRoot=${project.build.directory}/tmp 
-Djava.util.prefs.userRoot=${project.build.directory}/tmp 
-Djava.util.logging.config.class=org.ovirt.engine.ui.gwtextension.JavaLoggingConfig 
${gwt.jvmArgs}
</gwt-plugin.extraJvmArgs>
rm -rf ovirt-engine-4.1.4.2.tar.gz
tar -zcvf ovirt-engine-4.1.4.2.tar.gz *
rpmbuild -ba ~/rpmbuild/SPECS/ovirt-engine.spec //重新编译 
```
#### （二）、搭建环境并使用build方式编译
#####  一、安装构建环境
###### 1、安装snapshot库
```
yum -y install http://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm
```
###### 2、安装编译依赖包
```
yum -y install mailcap openssl m2crypto python-psycopg2 python-cheetah python-daemon libxml2-python unzip ovirt-host-deploy ovirt-setup-lib git maven postgresql-server java-1.8.0-openjdk-devel wget python-pip
```
###### 3、检查 JDK
使用“alternatives”命令验证javac是否已经指向已安装的Jdk1.8路径。
```
alternatives --display javac
```
如果javac没有指向正确的目录，那么可以使用以下命令进行设置。
```
alternatives --set javac /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.141-1.b16.el7_3.x86_64/bin/javac
```
###### 4.检查 maven	
验证Maven的环境变量已经设置成功
```
mvn -version
```
Maven 设置
设置 ~/.m2/ directory 库。
将下列内容拷贝到配置settings文件中。
```
cat > ~/.m2/settings.xml <<EOT
<settings xmlns=http://maven.apache.org/POM/4.0.0
xmlns:xsi=http://www.w3.org/2001/XMLSchema-instance
