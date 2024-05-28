+++  
title = 'k3s 安装与使用'  
date = 2024-04-12T09:39:39Z  
draft = true  
+++

# 一、安装

## 1、安装

```
curl -sfL https://get.k3s.io | sh -

cat /var/lib/rancher/k3s/server/node-token
curl -sfL https://get.k3s.io | K3S_URL=https://myserver:6443 K3S_TOKEN=XXX sh -
```

> 国内安装：
>
> server:
>
> 	curl -sfL http://rancher-mirror.cnrancher.com/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn sh -
>
> node:
>
> ```
> curl -sfL http://rancher-mirror.cnrancher.com/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn K3S_URL=https://myserver:6443 K3S_TOKEN=mynodetoken sh -
> ```

## 2、 k3s 安装配置 helm

```
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

cp /etc/rancher/k3s/k3s.yaml $HOME/.kube/config
或
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

helm ls
helm repo add aliyuncs https://apphub.aliyuncs.com
helm repo add bitnami https://charts.bitnami.com/bitnami

# vim /root/.config/helm
```

## 3、修改k3s使用本地仓库

```
vim /etc/hosts
192.168.0.242 local.com

scp -r 192.168.0.242:/etc/docker/certs.d/local.com /etc/docker/certs.d/
```

```
vim /etc/rancher/k3s/registries.yaml
mirrors:
  local.com:
    endpoint:
      - "https://local.com"
configs:
  "local.com":
    auth:
      username: admin
      password: qwe
    tls:
      cert_file: /etc/docker/certs.d/local.com/local.com.cert
      key_file: /etc/docker/certs.d/local.com/local.com.key
      ca_file: /etc/docker/certs.d/local.com/ca.crt
```

## 4、k3s 可配置环境变量

| Environment Variable            | Description                                                  |
| ------------------------------- | ------------------------------------------------------------ |
| `INSTALL_K3S_SKIP_DOWNLOAD`     | 如果设置为 "true "将不会下载 K3s 的哈希值或二进制。          |
| `INSTALL_K3S_SYMLINK`           | 默认情况下，如果路径中不存在命令，将为 kubectl、crictl 和 ctr 二进制文件创建符号链接。如果设置为'skip'将不会创建符号链接，而'force'将覆盖。 |
| `INSTALL_K3S_SKIP_ENABLE`       | 如果设置为 "true"，将不启用或启动 K3s 服务。                 |
| `INSTALL_K3S_SKIP_START`        | 如果设置为 "true "将不会启动 K3s 服务。                      |
| `INSTALL_K3S_VERSION`           | 从 Github 下载 K3s 的版本。如果没有指定，将尝试从"stable"频道下载。 |
| `INSTALL_K3S_BIN_DIR`           | 安装 K3s 二进制文件、链接和卸载脚本的目录，或者使用`/usr/local/bin`作为默认目录。 |
| `INSTALL_K3S_BIN_DIR_READ_ONLY` | 如果设置为 true 将不会把文件写入`INSTALL_K3S_BIN_DIR`，强制设置`INSTALL_K3S_SKIP_DOWNLOAD=true`。 |
| `INSTALL_K3S_SYSTEMD_DIR`       | 安装 systemd 服务和环境文件的目录，或者使用`/etc/systemd/system`作为默认目录。 |
| `INSTALL_K3S_EXEC`              | 带有标志的命令，用于在服务中启动 K3s。如果未指定命令，并且设置了`K3S_URL`，它将默认为“agent”。如果未设置`K3S_URL`，它将默认为“server”。要获得帮助，请参考[此示例。](https://docs.rancher.cn/docs/k3s/installation/install-options/how-to-flags/_index#示例-b-install_k3s_exec) |
| `INSTALL_K3S_NAME`              | 要创建的 systemd 服务名称，如果以服务器方式运行 k3s，则默认为'k3s'；如果以 agent 方式运行 k3s，则默认为'k3s-agent'。如果指定了服务名，则服务名将以'k3s-'为前缀。 |
| `INSTALL_K3S_TYPE`              | 要创建的 systemd 服务类型，如果没有指定，将从 K3s exec 命令中默认。 |
| `INSTALL_K3S_CHANNEL_URL`       | 用于获取 K3s 下载网址的频道 URL。默认为https://update.k3s.io/v1-release/channels 。 |
| `INSTALL_K3S_CHANNEL`           | 用于获取 K3s 下载 URL 的通道。默认值为 "stable"。选项包括：`stable`, `latest`, `testing`。 |

# 二、集群安装

## 1、下载 install 脚本

```
curl -sfL https://get.k3s.io -o install.sh
```

## 2、准备 k3s、离线镜像

```
略
```

## 3、server 安装

```
vim install.sh
...
INSTALL_K3S_SKIP_DOWNLOAD=true
INSTALL_K3S_EXEC="--docker"
cp k3s /usr/local/bin/
mkdir -p /var/lib/rancher/k3s/agent/images/
cp k3s-airgap-images-amd64.tar /var/lib/rancher/k3s/agent/images/
...
```

```
./install.sh
```

## 4、agent 安装

```
从 server 获取 token

cat /var/lib/rancher/k3s/server/node-token 
K10bc4ac5219e3d43898a2fd70eba5160ef3c38cd6485eeb3c60c6ac1aa80a14f63::server:d1a22f5300bf09bcab32632de490309a
```

```
vim install.sh
...
export K3S_URL="https://node1:6443"
export K3S_TOKEN="K10bc4ac5219e3d43898a2fd70eba5160ef3c38cd6485eeb3c60c6ac1aa80a14f63::server:d1a22f5300bf09bcab32632de490309a"
INSTALL_K3S_SKIP_DOWNLOAD=true
INSTALL_K3S_EXEC="--docker"
cp k3s /usr/local/bin/
mkdir -p /var/lib/rancher/k3s/agent/images/
cp k3s-airgap-images-amd64.tar /var/lib/rancher/k3s/agent/images/
...
```

```
./install.sh
```

# 三、使用

## 1、k3s 二进制文件启动

```
k3s server &
# Kubeconfig is written to /etc/rancher/k3s/k3s.yaml
k3s kubectl get node

# On a different node run the below. NODE_TOKEN comes from /var/lib/rancher/k3s/server/node-token
# on your server
k3s agent --server https://myserver:6443 --token ${NODE_TOKEN}
```

## 2、常用命令

> crictl: CRI 的 CLI 工具
>
> ctr: containerd 本身的 CLI 工具

```
k3s kubectl get nodes
k3s kubectl get all -A

crictl ps
crictl images
crictl pull rancher/rancher-agent:v2.4.8

# 清理未使用镜像
crictl rmi --prune

ctr images ls
ctr c ls
ctr image import busybox.tar

# 镜像标记tag
ctr -n k8s.io i tag hub.dream.io/hello:latest hub.dream.io/hello:second

# 删除镜像
ctr -n k8s.io i rm hub.dream.io/hello:latest

# 拉取镜像
ctr -n k8s.io i pull -k hub.dream.io/hello:latest

# 推送镜像
ctr -n k8s.io i push -k hub.dream.io/hello:latest

# 导出镜像
ctr -n k8s.io i export hello.tar hub.dream.io/hello:latest

# 导入镜像
ctr -n k8s.io i import hello.tar 

# 不支持 build,commit 镜像

# 查看容器相关操作
ctr c 

# 运行容器
  ctr -n k8s.io run --null-io --net-host -d \
    --env PASSWORD=$drone_password \
    --mount type=bind,src=/etc,dst=/host-etc,options=rbind:rw \
    --mount type=bind,src=/root/.kube,dst=/root/.kube,options=rbind:rw \
    $image sysreport bash /sysreport/run.sh
  1. --null-io: 将容器内标准输出重定向到/dev/null
  2. --net-host: 主机网络
  3. -d: 当task执行后就进行下一步shell命令,如没有选项,则会等待用户输入,并定向到容器内
  
# K3s worker 节点的角色默认为none
kubectl label node ${node} node-role.kubernetes.io/worker=worker
```

# 四、其他

## 1、ctr 访问 k3s crictl 资源

```
ctr -a "/run/k3s/containerd/containerd.sock" -namespace k8s.io i ls
```

### 2、使用 kubectl / helm 从外部访问集群

> 将 /etc/rancher/k3s/k3s.yaml 复制到集群外部的计算机上的~/.kube/config。然后用 K3s 服务器的 IP 或名称替换 "localhost"。

```
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
kubectl get pods --all-namespaces
helm ls --all-namespaces
```

```
kubectl --kubeconfig /etc/rancher/k3s/k3s.yaml get pods --all-namespaces
helm --kubeconfig /etc/rancher/k3s/k3s.yaml ls --all-namespaces
```

## 3、curl 请求 kubernetes api

```
kubectl get secrets
kubectl describe secrets default-token-l28jq
curl --insecure https://192.168.163.121:6443/api --header "Authorization: bearer $token"
```

## 4、k3s-killall.sh

> 要停止所有的 k3s 容器并重置容器的状态，可以使用k3s-killall.sh脚本。
>
> killall 脚本清理容器、k3s 目录和网络组件，同时也删除了 iptables 链和所有相关规则。集群数据不会被删除。

## 5、k3s-uninstall.sh

> 全部删除完，包括配置和数据。

## 6、设置私有仓库

##### 1）k3s

```
cat >> /etc/rancher/k3s/registries.yaml <<EOF
mirrors:
  "192.168.0.10:3000":
    endpoint:
      - "http://192.168.0.10:3000"
EOF
systemctl restart k3s

cat /var/lib/rancher/k3s/agent/etc/containerd/config.toml
...
[plugins.cri.registry.mirrors]

[plugins.cri.registry.mirrors."192.168.0.10:3000"]
  endpoint = ["http://192.168.0.10:3000"]

[plugins.cri.registry.mirrors."rancher.ksd.top:5000"]
  endpoint = ["192.168.0.10:3000"]
...
```

##### 2)、docker

```
cat /etc/docker/daemon.json
{
 "registry-mirrors":     ["https://docker.mirrors.ustc.edu.cn/"],
 "insecure-registries":  ["192.168.0.90:3000"]
}
```

##### 3)、containerd

```
containerd config default > /etc/containerd/config.toml 

cat /etc/containerd/config.toml 
[plugins.cri.registry.mirrors]

[plugins.cri.registry.mirrors."192.168.0.10:3000"]
  endpoint = ["http://192.168.0.10:3000"]

systemctl restart containerd.service
```

# 五、k3s证书有效期

[https://kingsd.top/2022/04/07/k3s-custom-ca/](https://kingsd.top/2022/04/07/k3s-custom-ca/)

##### 1、创建100年有效期CA证书

```
mkdir -p /var/lib/rancher/k3s/server/tls
cd /var/lib/rancher/k3s/server/tls
openssl genrsa -out client-ca.key 2048
openssl genrsa -out server-ca.key 2048
openssl genrsa -out request-header-ca.key 2048
openssl req -x509 -new -nodes -key client-ca.key -sha256 -days 36500 -out client-ca.crt -addext keyUsage=critical,digitalSignature,keyEncipherment,keyCertSign -subj '/CN=k3s-client-ca'
openssl req -x509 -new -nodes -key server-ca.key -sha256 -days 36500 -out server-ca.crt -addext keyUsage=critical,digitalSignature,keyEncipherment,keyCertSign -subj '/CN=k3s-server-ca'
openssl req -x509 -new -nodes -key request-header-ca.key -sha256 -days 36500 -out request-header-ca.crt -addext keyUsage=critical,digitalSignature,keyEncipherment,keyCertSign -subj '/CN=k3s-request-header-ca'
```

##### 2、使用自签名CA证书启动k3s

> 因为已经在 /var/lib/rancher/k3s/server/tls 创建了CA证书，所以当启动k3s时，将使用已创建的CA颁发证书。
>
> 直接安装k3s

```
curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=v1.21  sh -
```

##### 3、查看证书有效期

```
cd /var/lib/rancher/k3s/server/tls

for i in `ls /var/lib/rancher/k3s/server/tls/*.crt`; do echo $i; openssl x509 -enddate -noout -in $i; done
/var/lib/rancher/k3s/server/tls/client-admin.crt
notAfter=Apr  7 02:50:31 2023 GMT
/var/lib/rancher/k3s/server/tls/client-auth-proxy.crt
notAfter=Apr  7 02:50:31 2023 GMT
/var/lib/rancher/k3s/server/tls/client-ca.crt
notAfter=Mar 14 02:49:24 2122 GMT
/var/lib/rancher/k3s/server/tls/client-controller.crt
notAfter=Apr  7 02:50:31 2023 GMT
/var/lib/rancher/k3s/server/tls/client-k3s-cloud-controller.crt
notAfter=Apr  7 02:50:31 2023 GMT
/var/lib/rancher/k3s/server/tls/client-k3s-controller.crt
notAfter=Apr  7 02:50:31 2023 GMT
/var/lib/rancher/k3s/server/tls/client-kube-apiserver.crt
notAfter=Apr  7 02:50:31 2023 GMT
/var/lib/rancher/k3s/server/tls/client-kube-proxy.crt
notAfter=Apr  7 02:50:31 2023 GMT
/var/lib/rancher/k3s/server/tls/client-scheduler.crt
notAfter=Apr  7 02:50:31 2023 GMT
/var/lib/rancher/k3s/server/tls/request-header-ca.crt
notAfter=Mar 14 02:49:24 2122 GMT
/var/lib/rancher/k3s/server/tls/server-ca.crt
notAfter=Mar 14 02:49:24 2122 GMT
/var/lib/rancher/k3s/server/tls/serving-kube-apiserver.crt
notAfter=Apr  7 02:50:31 2023 GMT
```

```
kubectl get secret -n kube-system k3s-serving -o jsonpath='{.data.tls\.crt}' | base64 -d | openssl x509 -noout -text | grep Not
            Not Before: Apr  7 02:49:24 2022 GMT
            Not After : Apr  7 02:50:31 2023 GMT
```

> 从结果可以看到，CA证书的有效期已经变成100年，其他客户端证书的有效期依然是1年

##### 4、模拟证书过期，轮换证书

> 将服务器时间调整为50年后

```
~# timedatectl set-ntp no
~# date -s 20720407
Thu Apr  7 00:00:00 CST 2072
~# date
Thu Apr  7 00:00:00 CST 2072
```

> 重启k3s，触发证书轮换

```
service k3s restart
```

> 证书轮换后，再次 查询证书的有效期

```
for i in `ls /var/lib/rancher/k3s/server/tls/*.crt`; do echo $i; openssl x509 -enddate -noout -in $i; done

/var/lib/rancher/k3s/server/tls/client-admin.crt
notAfter=Apr  6 16:00:41 2073 GMT
/var/lib/rancher/k3s/server/tls/client-auth-proxy.crt
notAfter=Apr  6 16:00:41 2073 GMT
/var/lib/rancher/k3s/server/tls/client-ca.crt
notAfter=Mar 14 02:49:24 2122 GMT
/var/lib/rancher/k3s/server/tls/client-controller.crt
notAfter=Apr  6 16:00:41 2073 GMT
/var/lib/rancher/k3s/server/tls/client-k3s-cloud-controller.crt
notAfter=Apr  6 16:00:41 2073 GMT
/var/lib/rancher/k3s/server/tls/client-k3s-controller.crt
notAfter=Apr  6 16:00:41 2073 GMT
/var/lib/rancher/k3s/server/tls/client-kube-apiserver.crt
notAfter=Apr  6 16:00:41 2073 GMT
/var/lib/rancher/k3s/server/tls/client-kube-proxy.crt
notAfter=Apr  6 16:00:41 2073 GMT
/var/lib/rancher/k3s/server/tls/client-scheduler.crt
notAfter=Apr  6 16:00:41 2073 GMT
/var/lib/rancher/k3s/server/tls/request-header-ca.crt
notAfter=Mar 14 02:49:24 2122 GMT
/var/lib/rancher/k3s/server/tls/server-ca.crt
notAfter=Mar 14 02:49:24 2122 GMT
/var/lib/rancher/k3s/server/tls/serving-kube-apiserver.crt
notAfter=Apr  6 16:00:41 2073 GMT
```

```
kubectl get secret -n kube-system k3s-serving -o jsonpath='{.data.tls\.crt}' | base64 -d | openssl x509 -noout -text | grep Not
            Not Before: Apr  7 02:49:24 2022 GMT
            Not After : Apr  6 16:01:11 2073 GMT
```

```
kubectl get nodes
NAME    STATUS   ROLES                  AGE   VERSION
dev-1   Ready    control-plane,master   50y   v1.21.11+k3s1
```

> k3s 服务重启后，会自动轮换k3s证书。从以上结果可以看到k3s的证书已经更新到2073年，已经突破了k3s默认生成CA的10年有限期，证明自签名的CA已经生效，客户端证书是由自签名CA颁发

##### 5、后记

> 通过使用自签名CA的形式来延长CA证书的有效期，其他客户端证书有效期依然为1年，因此还需要在证书已经过期或剩余的时间不足90天时重启k3s来触发客户端证书轮换。

# 六、FAQ

> error: failed to run Kubelet: failed to create kubelet: misconfiguration: **kubelet cgroup driver: "cgroupfs" is different from docker cgroup driver: "systemd"**

>"Failed to run kubelet" err="failed to run Kubelet: misconfiguration: kubelet cgroup driver: \"cgroupfs\" is different from docker cgroup driver: \"systemd\""

```
vim /etc/systemd/system/docker.service.d/docker-options.conf
...
--exec-opt native.cgroupdriver=cgroupfs
...
```

或

```
vim /etc/docker/daemon.json 
{
    "exec-opts": ["native.cgroupdriver=cgroupfs"]
}
```

> {"exec-opts": ["native.cgroupdriver=systemd"]}
