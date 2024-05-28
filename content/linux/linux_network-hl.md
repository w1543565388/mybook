+++  
title = 'linux 网络配置'  
date = 2024-04-12T09:39:39Z  
draft = true  
+++

# 一、netplan

```
vim /etc/netplan/01-netcfg.yaml 

network:
  ethernets:
    enp1s0:
      dhcp4: no
      addresses: [192.168.0.84/24]
      nameservers:
        addresses: [8.8.8.8]
      routes:
      - to: default
        via: 192.168.0.1
```

```
netplan try
netplan apply
netplan --debug apply
netplan -d apply
networkctl status
```

```
network:
    version: 2
    renderer: networkd
#    renderer: NetworkManager
    ethernets:
        enp0s3:
            dhcp4: no
    #        dhcp6: no
        enp4s0:
            dhcp4: true
```

```
bonds:
    bond0:
        dhcp4: yes
        interfaces:
            - enp3s0
            - enp4s0
        parameters:
            mode: active-backup
            primary: enp3s0
```

```
bridges:
    br0:
        dhcp4: yes
        interfaces:
            - enp3s0         
```

```
vlans:
    vdev:
        id: 101
        link: net1
        addresses:
            - 10.0.1.10/24
    vprod:
        id: 102
        link: net2
        addresses:
            - 10.0.2.10/24
    vtest:
        id: 103
        link: net3
        addresses:
            - 10.0.3.10/24
    vmgmt:
        id: 104
        link: net4
        addresses:
            - 10.0.4.10/24
```

# 二、network

```
vim /etc/network/interfaces

auto enp10s0
iface enp10s0 inet static
address 192.168.1.162
netmask 255.255.255.0
gateway 192.168.1.100
dns-nameservers 1.0.0.1,1.1.1.1

systemctl restart networking
```

```
vim /etc/sysconfig/network-scripts/ifcfg-ens33

TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=static
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=ens33
DEVICE=ens33
ONBOOT=yes
IPADDR=192.168.1.22
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
DNS1=114.114.114.114

systemctl restart network
```

# 三、NetworkManager

```
nmcli
nmtui
```

```
cat /etc/NetworkManager/system-connections/eth1

[connection]
id=eth1
uuid=31b84fda-dc81-4871-a5e3-da34a74d8cc3
type=ethernet
interface-name=eth1
permissions=
timestamp=1701162383

[ethernet]
mac-address-blacklist=

[ipv4]
address1=192.168.0.75/24,192.168.0.1
dns=8.8.8.8;114.114.114.114;
dns-search=
method=manual

[ipv6]
addr-gen-mode=stable-privacy
dns-search=
ip6-privacy=0
method=auto
```

# 四、systemd-networkd

> .network 文件，为匹配的设备提供一个网络配置
> .netdev 文件，为匹配的环境创建一个虚拟网络设备
> .link 文件，当网络设备出现时，udev 将查找第一个匹配的.link文件

> [Match] 
> Host= 主机名
> Virtualization= 检查是否运行于虚拟机中
>
> [NetDev] 
> Name= 接口名称。必须提供
> Kind= 例如：bridge, bond, vlan, veth, sit，等等。必须提供

```
cat 100-bind.network
[Match]
Name=eth0

[Network]
Bridge=br0

cat 100-br0.netdev
[NetDev]
Name=br0
Kind=bridge

cat 100-br0.network
[Match]
Name=br0

[Network]
Address=192.168.0.21/24
Gateway=192.168.0.1
DNS=114.114.114.114
```

```
/etc/systemd/network/MyDhcp.network
[DHCPv4]
UseHostname=false
```

```
/etc/systemd/network/MyDhcp.network
[Match]
Name=en*

[Network]
DHCP=ipv4
```

```
/etc/systemd/network/10-dhcp.network
[Match]
Name=enp*
[Network]
DHCP=yes

静态网络可以配置成
/etc/systemd/network/20-static.network
[Match]
Name=enp0s3
[Network]
Address=192.168.0.22/24
Gateway=192.168.0.1
DNS=192.168.0.1
```

```
systemctl restart systemd-networkd
```

##### mac地址冲突

> persistent
> random
> none

```
vim /lib/systemd/network/99-default.link
[Match]
OriginalName=*

[Link]
NamePolicy=keep kernel database onboard slot path
AlternativeNamesPolicy=database onboard slot path
MACAddressPolicy=persistent
```

# 五、网络扫描

```
apt install -y nmap
```

```
 nmap -sP 192.168.0.0/24
 nmap -sS 192.168.0.0/24
```

