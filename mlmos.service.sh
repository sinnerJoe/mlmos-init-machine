#!/bin/sh
host="white-carrot"
#set hostname $host
#dhclient

git clone https://github.com/wildProgrammer/mlmos-init-machine.git
cd mlmos-init-machine

settings="vms/$host/settings.conf"

if [[ $(stat $settings) ]]; then
    
    if [ ! -x "$settings" ]; then
        chmod +x $settings
    fi

    eval $(cat $settings)
    echo "Muncitorii antrenati din Vaslui va actualizeaza sistemul..."    
    if [ $actualizare == "true" ]; then
        echo "apt update && apt upgrade"
    fi; 



    if [ ! -z ${interface+x} ]; then
	echo "Viorica Dancila va configureaza interfetele pe retea"
        inter_file="/etc/network/interfaces"
        cp $inter_file /etc/network/interfaces_backup
        echo "auto lo" > $inter_file
        echo "iface lo inet loopback" >> $inter_file
        echo "iface $interface inet static" >> $inter_file
        spaces='  '
	properties=(address netmask gateway)
        for i in ${properties[@]}; do
	 if [ ! -z ${!i+x} ]; then
            echo "$spaces $i ${!i}" >> $inter_file
         fi;
        done
        if [ ! -z ${nameservers+x} ]; then
            echo "$spaces dns-nameservers ${nameservers[@]}" >> $inter_file
        fi;

        systemctl restart ifup@$interface

    fi;

    echo "Dragnea monteaza partitiile"
    for i in ${mountpoints[@]}; do
        device=$(echo $i | cut -f1 -d '=')
        folder=$(echo $i | cut -f2 -d '=')
        mkdir $folder
        mount /dev/$device $folder
    done;

    echo "Instalam pachetele de mancare de pe serverul PSD-ului"
    for i in ${to_install[@]}; do
       echo "Se instaleaza $i..."
       $(apt install -y $i)
    done;
fi;
echo "rulam fisierul bootstrap.sh"
bash ./bootstrap.sh >> /var/log/system-bootstrap.log 2>&1
echo "configurare finasata"
