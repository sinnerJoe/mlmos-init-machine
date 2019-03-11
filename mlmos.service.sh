#!/bin/sh
host="white-carrot"
# set hostname $host
# dhclient
apt install -y git

git clone https://github.com/wildProgrammer/mlmos-init-machine.git
cd mlmos-init-machine

settings="vms/$host/settings.conf"

if [[ $(stat $settings) ]]; then
    
    if [ ! -x "$settings" ]; then
        chmod +x $settings
    fi

    eval $(cat $settings)
    
    if [ $actualizare == "true" ]; then
        echo "apt update && apt upgrade"
    fi; 



    if [ ! -z ${interface+x} ]; then
        inter_file="/etc/network/interfaces"
        cp $inter_file /etc/network/interfaces_backup
        echo "auto lo" > $inter_file
        echo "iface lo inet loopback" >> $inter_file
        echo "iface $interface inet static" >> $inter_file
        spaces='  '
        for i in (address netmask gateway); do
         if [ ! -z ${!i+x} ]; then
            echo "$spaces $i ${!i}" >> $inter_file
         fi;
        done
        if [ ! -z ${nameservers+x} ]; then
            echo "$spaces dns-nameservers ${nameservers[@]}" >> $inter_file
        fi;

        systemctl restart ifup@$interface

    fi;


    for i in ${mountpoints[@]}; do
        device=$(echo $i | cut -f1 -d '=')
        folder=$(echo $i | cut -f2 -d '=')
        mkdir $folder
        mount /dev/$device $folder
    done;


    for i in ${to_install[@]}; do
        apt install -y $i
    done;
fi;

bash ./bootstrap.sh >> /var/log/system-bootstrap.log 2>&1