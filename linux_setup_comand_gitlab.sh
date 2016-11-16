#!/bin/bash

#following raws gitlab
#yum update

yum install -y curl policycoreutils openssh-server openssh-clients
systemctl enable sshd & systemctl start sshd
yum install -y postfix
systemctl enable postfix & systemctl start postfix
firewall-cmd --permanent --add-service=http
#systemctl reload firewalld
curl -s https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash
yum install -y gitlab-ce-8.11.11-ce.0.el7.x86_64
gitlab-ctl reconfigure

#vim /etc/gitlab/gitlab.rb
# external_url 'http://localhost'

sed -i 's/"http://localhost"/"https://gitlab.receiptbank.com"/g' /etc/gitlab/gitlab.rb
mkdir -p /etc/gitlab/ssl
chmod 700 /etc/gitlab/ssl

yum install -y epel-release
yum install -y nginx

openssl genrsa -des3 -out /etc/gitlab/ssl/gitlab.receiptbank.com.key 2048
openssl req -new -key /etc/gitlab/ssl/gitlab.receiptbank.com.key -out /etc/gitlab/ssl/gitlab.receiptbank.com.csr
openssl req -nodes -newkey rsa:2048 -keyout gitlab.receiptbank.com.key -out gitlab.receiptbank.com.csr

#expect try with this //openssl nonectaractive
#Country Name (2 letter code) [XX]:BG
#State or Province Name (full name) []:Bulgaria
#Locality Name (eg, city) [Default City]:Sofia
#Organization Name (eg, company) [Default Company Ltd]:Receiptbank
#Organizational Unit Name (eg, section) []:bank
#Common Name (eg, your name or your server's hostname) []:gitlab.receiptbank.com
#Email Address []:admin@receiptbank.com

#Please enter the following 'extra' attributes
#to be sent with your certificate request
#A challenge password []:devops
#An optional company name []:  


cp -v /etc/gitlab/ssl/gitlab.receiptbank.com.{key,original}
openssl rsa -in /etc/gitlab/ssl/gitlab.receiptbank.com.original -out /etc/gitlab/ssl/gitlab.receiptbank.com.key
rm -v /etc/gitlab/ssl/gitlab.receiptbank.com.original

openssl x509 -req -days 1460 -in /etc/gitlab/ssl/gitlab.receiptbank.com.csr -signkey /etc/gitlab/ssl/gitlab.receiptbank.com.key -out /etc/gitlab/ssl/gitlab.receiptbank.com.crt
rm -v /etc/gitlab/ssl/gitlab.receiptbank.com.csr
chmod 600 /etc/gitlab/ssl/gitlab.receiptbank.com.*


cp gitlab.key gitlab.crt /etc/gitlab/ssl/

mkdir /etc/nginx/sites-{available,enabled}
vim /etc/nginx/nginx.conf # replace include /etc/nginx/conf.d/*.conf; with /etc/nginx/sites-enabled/*;
usermod -a -G git nginx 
chmod g+rx /home/git/

#or replace the default nginx user with git and group root in /etc/nginx/nginx.conf:
vim /etc/nginx/nginx.conf
#user nginx;
#user git root;