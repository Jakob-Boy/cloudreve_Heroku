FROM alpine:latest

# Add glibc package
COPY ./glibc-2.33-r0.apk /lib/

# Add glibc key
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub

# Install glibc
RUN apk add /lib/glibc-2.33-r0.apk

ADD aria2.conf /root/aria2/aria2.conf
ADD run.sh /root/cloudreve/run.sh

RUN wget -qO cloudreve.tar.gz https://github.com/FuaerCN/Cloudreve-Heroku/releases/download/Cloudreve/cloudreve_linux_amd64.tar.gz \
	&& tar -zxvf cloudreve.tar.gz -C /root/cloudreve \
	&& chmod +x /root/cloudreve/cloudreve /root/cloudreve/run.sh

RUN apk add --no-cache aria2 \
	&& wget -qO /root/aria2/dht.dat https://github.com/P3TERX/aria2.conf/raw/master/dht.dat \
	&& wget -qO /root/aria2/dht6.dat https://github.com/P3TERX/aria2.conf/raw/master/dht6.dat \
	&& touch /root/aria2/aria2.session /root/aria2/aria2.log

CMD /root/cloudreve/run.sh
