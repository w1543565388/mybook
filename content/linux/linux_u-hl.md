+++  
title = 'Linux U盘占用'  
date = 2024-04-12T09:39:39Z  
draft = true  
+++

##### 强制解除U盘占用
```
multipath -ll

/etc/multipath.conf

blacklist {
        devnode "^sd[a-z]"
}

systemctl restart multipathd.service
```