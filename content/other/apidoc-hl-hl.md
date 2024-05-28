+++
title = ''
date = 2024-04-12T09:39:39Z
draft = true
+++
+++
title = apidoc 相关
date = 2024-04-12T09:39:39Z
draft = true
+++
# apidoc 相关
[https://apidocjs.com/](https://apidocjs.com/)
##### 1、安装 nodejs 
略
##### 2、安装 apidoc
```
npm install apidoc -g
```
##### 3、将 npm bin 目录，写入环境变量
```
echo -e export PATH=$(npm prefix -g)/bin:$PATH >> ~/.bashrc && source ~/.bashrc
```
##### 4、在项目目录创建 apidoc.api
```
cat apidoc.json 
{
name: libvirtapi,
version: 1.0.0,
description: libvirtapi 接口文档,
title: libvirtapi,
url : http://YOUR_IP:8778
}
```
##### 5、请求方法后面写上注释
```
def get(self, scene=None, cluster=None, path=None):
