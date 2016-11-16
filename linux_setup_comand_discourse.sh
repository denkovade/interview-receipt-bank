#!/bin/bash

#following raws will install docker which is important for discourse instalation
#yum update

tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF


yum -y install docker-engine
systemctl enable docker.service
systemctl start docker

docker run hello-world
docker run --rm hello-world

##discourse instalation
yum -y install wget git
wget -qO- https://get.docker.com/ | sh
mkdir /var/discourse
git clone https://github.com/discourse/discourse_docker.git /var/discourse
cd /var/discourse

./discourse-setup
#Discourse requires at least 2GB of swap when running with 2GB or less.
#You can create a swapfile if you press ENTER

#Hostname for your Discourse?[discourse.example.com]: 
discourse.interview.com
#Email address for admin account? [me@receiptbank.com]: 
admin@interview.com
#SMTP port [587]:
587
#SMTP server address? [smtp.receiptbank.com]: 
smtp.interview.com
#SMTP user name? [postmaster@discourse.receiptbank.com]: 
postmaster@discourse.interview.com
#SMTP password? []:
smtptest
#Let's Encrypt account email? (ENTER to skip)

#The system asc: Does this look right?
#Hostname: discourse.interview.vom
#hostname: discourse.interview.com
#email: admin@interview.com
#SMTP address:smtp.interview.com
#SMTP port: 587
#SMTP username: postmaster@discourse.interview.com
#SMTP password:smtptest
