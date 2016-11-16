#!/bin/bash

yum install -y epel-release & yum update
yum install -y vim git ansible nginx

git clone https://github.com/jamielinux/ansible-discourse
cd ansible-discourse
cp vars_example.yml group_vars/all/main.yml
vim group_vars/all/main.yml



sed -i -- 's/discourse.example.com/discourse.interview.com/g' /opt/ansible-discourse/group_vars/all/main.yml
sed -i -- 's/hello@example.com/admin@interview.com/g' /opt/ansible-discourse/group_vars/all/main.yml
#postgres_password:            "12345678"
bash /opt/ansible-discourse/deploy-local.sh
yum install postgresql-server postgresql-contrib libselinux-python

##
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
