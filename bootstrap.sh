#!/bin/sh
apt update && apt ugrade

keylocation=/root/.ssh/
rm -r $keylocation
ssh-keygen -t rsa -f $keylocation/id_rsa -N 'no passphrase'
cat $keylocation/id_rsa.pub >> $keylocation/authorized_keys

cp /etc/ssh/sshd_config /etc/ssh/sshd_config_backup
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

setenforce 0

