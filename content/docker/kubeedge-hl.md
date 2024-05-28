+++  
title = 'kubeedge'  
date = 2024-04-12T09:39:39Z  
draft = true  
+++

# 一、要求

```
云端环境：

OS: Ubuntu Server 20.04.1 LTS 64bit
Kubernetes: v1.19.8
网络插件：calico v3.16.3
Cloudcore: kubeedge/cloudcore:v1.6.1

边缘环境：
OS: Ubuntu Server 18.04.5 LTS 64bit
EdgeCore: v1.19.3-kubeedge-v1.6.1
docker:

version: 20.10.7
cgroupDriver: systemd
```

# 二、安装k8s

```
略
```

# 三、安装golang

```
wget -O /usr/local/go1.16.4.linux-amd64.tar.gz https://golang.org/dl/go1.16.4.linux-amd64.tar.gz
tar -C /usr/local -zxvf /usr/local/go1.16.4.linux-amd64.tar.gz
echo "export PATH=$PATH:/usr/local/go/bin" |tee >> /etc/profile
source /etc/profile
```

```
git clone -b v1.8.2 --deph 1 https://github.com/kubeedge/kubeedge.git
```

```
curl -LO https://github.com/kubeedge/kubeedge/releases/download/v1.8.2/kubeedge-v1.8.2-linux-amd64.tar.gz
```

```
curl -LO https://github.com/kubeedge/kubeedge/releases/download/v1.8.2/keadm-v1.8.2-linux-amd64.tar.gz
```

```
curl -LO https://github.com/kubeedge/kubeedge/releases/download/v1.8.2/edgesite-v1.8.2-linux-amd64.tar.gz
```

```
keadm init --kube-config=$KUBECONFIG --advertise-address=10.0.0.19
keadm init --kube-config=./config --advertise-address=10.0.0.19
```

```
export https_proxy=http://192.168.0.184:1080
export http_proxy=http://192.168.0.184:1080
export HTTPS_PROXY=http://192.168.0.184:1080
export HTTP_PROXY=http://192.168.0.184:1080
keadm init --kube-config=/root/.kube/config --advertise-address=10.0.0.119 --kubeedge-version=1.8.2
```

```
./keadm init --advertise-address="10.0.0.119"
Kubernetes version verification passed, KubeEdge installation will start...
W1109 10:42:45.450270  168278 warnings.go:70] apiextensions.k8s.io/v1beta1 CustomResourceDefinition is deprecated in v1.16+, unavailable in v1.22+; use apiextensions.k8s.io/v1 CustomResourceDefinition
W1109 10:46:17.975017  168278 warnings.go:70] apiextensions.k8s.io/v1beta1 CustomResourceDefinition is deprecated in v1.16+, unavailable in v1.22+; use apiextensions.k8s.io/v1 CustomResourceDefinition
W1109 10:46:18.762340  168278 warnings.go:70] apiextensions.k8s.io/v1beta1 CustomResourceDefinition is deprecated in v1.16+, unavailable in v1.22+; use apiextensions.k8s.io/v1 CustomResourceDefinition
W1109 10:49:36.682854  168278 warnings.go:70] apiextensions.k8s.io/v1beta1 CustomResourceDefinition is deprecated in v1.16+, unavailable in v1.22+; use apiextensions.k8s.io/v1 CustomResourceDefinition
kubeedge-v1.8.1-linux-amd64.tar.gz checksum: 
checksum_kubeedge-v1.8.1-linux-amd64.tar.gz.txt content: 
[Run as service] start to download service file for cloudcore
[Run as service] success to download service file for cloudcore
kubeedge-v1.8.1-linux-amd64/
kubeedge-v1.8.1-linux-amd64/edge/
kubeedge-v1.8.1-linux-amd64/edge/edgecore
kubeedge-v1.8.1-linux-amd64/cloud/
kubeedge-v1.8.1-linux-amd64/cloud/csidriver/
kubeedge-v1.8.1-linux-amd64/cloud/csidriver/csidriver
kubeedge-v1.8.1-linux-amd64/cloud/admission/
kubeedge-v1.8.1-linux-amd64/cloud/admission/admission
kubeedge-v1.8.1-linux-amd64/cloud/cloudcore/
kubeedge-v1.8.1-linux-amd64/cloud/cloudcore/cloudcore
kubeedge-v1.8.1-linux-amd64/version

KubeEdge cloudcore is running, For logs visit:  /var/log/kubeedge/cloudcore.log
CloudCore started
```

```
cp ./kubeedge/build/tools/cloudcore.service /etc/systemd/system/cloudcore.service 
cp ./kubeedge-v1.8.2-linux-amd64/cloud/cloudcore/cloudcore /etc/kubeedge/cloudcore
systemctl daemon-reload 
systemctl enable cloudcore 
systemctl start cloudcore
```

# cloudcore

```
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
```

```
cp docker/* /usr/bin/
cp containerd.service /lib/systemd/system/
cp docker.service /lib/systemd/system/
cp docker.socket /lib/systemd/system/	
echo "docker:x:998:" >> /etc/group

systemctl daemon-reload
systemctl enable docker
systemctl start docker
```

```
mkdir -p /etc/kubeedge
cp -r cloudcore/crds /etc/kubeedge/
cp cloudcore/cloudcore /etc/kubeedge/
cp cloudcore/kubeedge-v1.8.2-linux-amd64.tar.gz /etc/kubeedge/
cp cloudcore/keadm /usr/bin
cp cloudcore/cloudcore.service /etc/systemd/system/

mkdir/root/.kube/
cp /etc/rancher/k3s/k3s.yaml /root/.kube/config
sed -i "s/127.0.0.1/10.0.0.122/g" /root/.kube/config

keadm init --kube-config=/root/.kube/config --advertise-address=10.0.0.122 --kubeedge-version=1.8.2

systemctl daemon-reload 
systemctl enable cloudcore 
systemctl start cloudcore
```

```
keadm gettoken
```

# edge

```
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
```

```
#apt-add-repository ppa:mosquitto-dev/mosquitto-ppa && apt install -y mosquitto
```

```
apt-get install -y --allow-change-held-packages --allow-downgrades mosquitto
```

```
dpkg -i edgecore/mosquitto/*.deb
```

```
mkdir -p /etc/kubeedge
cp edgecore/keadm /usr/local/bin/
cp edgecore/edgecore /etc/kubeedge/
cp edgecore/edgecore.service /etc/kubeedge/
cp edgecore/kubeedge-v1.8.2-linux-amd64.tar.gz /etc/kubeedge/

keadm join --cloudcore-ipport=10.0.0.122:10000 --edgenode-name=node2 --kubeedge-version=1.8.2 --token=2db9d4278daa18a1708e74899d2e85ba202d00f7ec72d3b7eea3056275b4281a.eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MzcwNjQ3MTB9.gsndb_AAlp809SustU1nk0aQZIDrjRVzB09ZeMDuRkc
```

```
kubeedge-v1.8.2-linux-amd64.tar.gz checksum: 
checksum_kubeedge-v1.8.2-linux-amd64.tar.gz.txt content: 
[Run as service] start to download service file for edgecore
[Run as service] success to download service file for edgecore
kubeedge-v1.8.2-linux-amd64/
kubeedge-v1.8.2-linux-amd64/edge/
kubeedge-v1.8.2-linux-amd64/edge/edgecore
kubeedge-v1.8.2-linux-amd64/cloud/
kubeedge-v1.8.2-linux-amd64/cloud/csidriver/
kubeedge-v1.8.2-linux-amd64/cloud/csidriver/csidriver
kubeedge-v1.8.2-linux-amd64/cloud/admission/
kubeedge-v1.8.2-linux-amd64/cloud/admission/admission
kubeedge-v1.8.2-linux-amd64/cloud/cloudcore/
kubeedge-v1.8.2-linux-amd64/cloud/cloudcore/cloudcore
kubeedge-v1.8.2-linux-amd64/version

KubeEdge edgecore is running, For logs visit: journalctl -u edgecore.service -b
```

开启使用kubectl logs

master执行

```
cp kubeedge/build/tools/certgen.sh /etc/kubeedge/ 
cd /etc/kubeedge/ 
/etc/kubeedge/certgen.sh stream 

export CLOUDCOREIPS="10.0.0.119" 

iptables -t nat -A OUTPUT -p tcp --dport 10350 -j DNAT --to $CLOUDCOREIPS:10003 

```

```
vi /etc/kubeedge/config/edgecore.yaml

edgeStream:
  enable: true
  handshakeTimeout: 30
  readDeadline: 15
  server: 10.0.0.119:10004
  tlsTunnelCAFile: /etc/kubeedge/ca/rootCA.crt
  tlsTunnelCertFile: /etc/kubeedge/certs/server.crt
  tlsTunnelPrivateKeyFile: /etc/kubeedge/certs/server.key
  writeDeadline: 15
```

```
vi /etc/kubeedge/edgecore.service
Environment="CHECK_EDGECORE_ENVIRONMENT=false"
```

# 四、example

> 云边协同计数器demo
> 在中心云部署Web管理应用和控制后台应用。通过中心云部署应用到边缘计算节点，包含计数应用和伪计数设备。
>
> 通过浏览器登录Web，启动计数，控制后台应用将请求转发到相应边缘计算节点的计数应用中，计数应用收到请求调用伪计数设备进行计数并将结果输出到计数应用的容器日志中。
>
> Web管理应用也可点击停止计数，即将停止请求发送到边缘计算平台的计数应用中，计数应用停止调用伪计数设备，停止计数。

```
vim /etc/sysctl.conf
net.ipv4.ip_forward=1

systemctl restart network
sysctl net.ipv4.ip_forward
```

```
cd examples/kubeedge-counter-demo/crds

#创建device model
kubectl create -f kubeedge-counter-model.yaml

#创建model
vim kubeedge-counter-instance.yaml
- key: 'kubernetes.io/hostname'
  values:
    - edge0 # 边缘节点名称
        
kubectl create -f examples/kubeedge-counter-demo/crds/kubeedge-counter-instance.yaml
```

```
cloud

cd samples/kubeedge-counter-demo/web-controller-app

vim main.go
beego.Run(":8089")

make all
make docker

vim kubeedge-web-controller-app.yaml
nodeName: node1

kubectl create -f examples/kubeedge-counter-demo/crds/kubeedge-web-controller-app.yaml
```

```
edge

cd examples/kubeedge-counter-demo/counter-mapper

vim Makefile
GOARCH=amd64 go build -o pi-counter-app main.go
make all
make docker

kubectl apply -f examples/kubeedge-counter-demo/crds/kubeedge-pi-counter-app.yaml

docker save kubeedge/kubeedge-pi-counter:v1.0.0 > kubeedge-pi-counter_v1.0.0_images_amd64.tar
scp kubeedge-pi-counter_v1.0.0_images_amd64.tar node2:/root/
docker load -i kubeedge-pi-counter_v1.0.0_images_amd64.tar
docker logs -f counter-container-id
```

```
http://192.168.0.127:8089
```

```
ctr -n=k8s.io c ls
```

# 五、重新编译，跳过校验检查

```
vim kubeedge/keadm/cmd/keadm/app/cmd/util/common.go
        if _, err = os.Stat(filePath); err == nil {
                fmt.Printf("Expected or Default KubeEdge version %v is already downloaded and will checksum for it. \n", version)
        /*      if success, _ := checkSum(filename, checksumFilename, version, options.TarballPath); !success {
                        fmt.Printf("%v in your path checksum failed and do you want to delete this file and try to download again? \n", filename)
                        for {
                                confirm, err := askForconfirm()
                                if err != nil {
                                        fmt.Println(err.Error())
                                        continue
                                }
                                if confirm {
                                        cmdStr := fmt.Sprintf("cd %s && rm -f %s", options.TarballPath, filename)
                                        if err := NewCommand(cmdStr).Exec(); err != nil {
                                                return err
                                        }
                                        fmt.Printf("%v have been deleted and will try to download again\n", filename)
                                        if err := retryDownload(filename, checksumFilename, version, options.TarballPath); err != nil {
                                                return err
                                        }
                                } else {
                                        fmt.Println("failed to checksum and will continue to install.")
                                }
                                break
                        }
                } else {
                        fmt.Println("Expected or Default KubeEdge version", version, "is already downloaded")
                }*/
        } else if !os.IsNotExist(err) {
                return err
        } else {
                if err := retryDownload(filename, checksumFilename, version, options.TarballPath); err != nil {
                        return err
                }
        }
```

```
vim kubeedge/keadm/cmd/keadm/app/cmd/util/rpminstaller.go

        //      "yum -y install epel-release",
        //      "yum -y install mosquitto",
```

```
make all WHAT=keadm
```

```
go build -o /opt/_output/local/bin/edgesite-agent -gcflags= -ldflags
```

```
CGO_ENABLED=1 GO111MODULE=off go build -v -o /usr/local/bin/edgecore -ldflags="${GO_LDFLAGS} -w -s -extldflags -static" \
```

```
./cloudcore  --version
KubeEdge v1.9.1-1+aedc2e42be2203
```

```
vim hack/lib/golang.sh
goldflags="${GOLDFLAGS=-s -w -extldflags -static -buildid=} $(kubeedge::version::ldflags)"
```

```
git describe --tags
```

