#!/bin/sh

cat <<-EOF > /root/cloudreve/conf.ini
[System]
; 运行模式
Mode = master
; 监听端口
Listen = :${PORT}
; 是否开启 Debug
Debug = false
SessionSecret = DwueqsOCChydmVIgTFtXNsqGNh3iUVOVyjdyBHPTppjG7FP1SiQYBOSZdOf35Pm7
HashIDSalt = LzCgoB9pLdHYwsPQJ46AIDtLfkZ4KbtprcI8cxoKnwj58kFctbc9q3CmTUdXsCFP
[Redis]
Server = ${REDIS_URL##*@}
Password = ${REDIS_URL:9:65}
DB = 0
[Database]
; 数据库类型，目前支持 sqlite | mysql
Type = mysql
; 数据库地址
Host = $Host
; MySQL 端口
Port = $Port
; 用户名
User = $User
; 密码
Password = $Password
; 数据库名称
Name = $Name
; 数据表前缀
TablePrefix = cd
EOF

trackerlist=`wget -qO- https://trackerslist.com/all.txt |awk NF|sed ":a;N;s/\n/,/g;ta"`
sed -i '$a bt-tracker='${trackerlist} /root/aria2/aria2.conf
nohup aria2c --conf-path=/root/aria2/aria2.conf  &

/root/cloudreve/cloudreve -c /root/cloudreve/conf.ini
