#!/bin/sh
apt update && apt ugrade

keylocation=/root/.ssh/
rm -r $keylocation
ssh-keygen -t rsa -f $keylocation/id_rsa -N 'no passphrase'
cat $keylocation/id_rsa.pub >> 
