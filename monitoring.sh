#!/bin/bash

getip=$(hostname -I)
getmac=$(ip link show | awk '$1 == "link/ether" {print $2}')
getsudo=$(cat /var/log/sudo/sudo.log | grep 'COMMAND' | wc -l | awk '{$2="cmd"; print $0}')
getlastboot=$(who -b | awk '$1 == "system" {print $3 " " $4}')
getcpuph=$(grep "physical id" /proc/cpuinfo | uniq | wc -l)
getvcpu=$(grep "^process" /proc/cpuinfo | wc -l)
gettcp=$(cat /proc/net/tcp | wc -l)
getload=$(top -bn1 | grep "^%Cpu" | cut -c -9 | xargs | awk '{printf("%.1f%%", $1 + $3)}')
getdiskuse=$(df -BM -t ext4 --total | grep 'total' | awk '{print"%d/%.1Gb (%d%%)", $3, $2 / 1024, $5}')
getmemuse=$(free -m | grep 'Mem:' | awk '{printf"%d/%dMB (%.2f%%)", $3, $2, $3 * 100 / $2}')

lvm_v=$(lsblk | grep "lvm" | wc -l)
lvm_f=$(if [ lvm_v -eq 0 ]; then echo no;else echo yes; fi)

wall "  #Architecture: $(uname -a)
        #CPU physical: $getcpuph
        #vCPU: $getvcpu
        #Memory Usage: $getmemuse
        #Disk Usage: $getdiskuse
        #CPU load: $getload
        #Last boot: $getlastboot
        #LVM use: $lvm_f
        #Connexions TCP: $gettcp ESTABLISHED
        #Use log: $(users | wc -l)
        #Network: IP $$getip ($getmac)
        #Sudo: $getsudo "
