#!/bin/sh
if [ -e /usr/bin/nload ]; then 
  echo "nload found"
 else
   "yum install -y nload"
fi
#yum -q list installed net-tools &>/dev/null && echo "Installed" || echo "Not installed"
yum list installed |grep net-tools
if [ $? -ne 0 ]; then
 echo 'NET-TOOLS NOT FOUND'
 yum install net-tools -y
else
 echo 'NET-TOOLS FOUND'
fi
 

#echo -e "\n######### sar -u #########\n"
#sar -u

#echo -e "\n######### sar -r #########\n"
#sar -r

echo -e "\n####################################################### CHECK DISK SPACE ######################################################## #########\n"
df -h
echo -e "\n######################################################### CHECK MEMORY  ###################################################################\n"
free -m

#echo -e "\n######### ps -aux #########\n"
#ps -aux

#echo -e "\n######### sar -W #########\n"
#sar -W

#echo -e "\n######### sar -b #########\n"
#sar -b

#echo -e "\n######### iostat #########\n"
#iostat

echo -e "\n############################################################# PORT CHECK  #####################################################################\n"
netstat -tnlp

#echo -e "\n######### nload #########\n"
#nload

echo -e "\n############################################################# LAST REBOOT TIME #################################################################\n"
last reboot

echo -e "\n############################################################## CLEAR RAM #######################################################################\n"
clear_RAM() {
        if [[ $EUID -ne 0 ]]; then
                echo "You must be a root user"
                echo "$ sudo bash $0"
                exit 1
else
echo " "
        # clearing..
        echo " "
        su -c "echo 3 >'/proc/sys/vm/drop_caches' && swapoff -a && swapon -a && printf '\n%s\n' 'Ram-cache and Swap Cleared'" root
fi
}
FREE_RAM=$(declare -f clear_RAM)
alias freeram='sudo bash -c "$FREE_RAM; clear_RAM"'

echo -e "\n########################################################### CREATE SWAP MEMORY ##################################################################\n"
# size of swapfile in megabytes
#swapsize=1024
swapsize=1024

# does the swap file already exist?
grep -q "swap10" /etc/fstab

# if not then create it
if [ $? -ne 0 ]; then
        echo 'swapfile not found. Adding swapfile.'
#        fallocate -l ${swapsize}M /swap10
        dd if=/dev/zero of=/swap10 bs=1M count=${swapsize}
        chmod 600 /swap10
        mkswap /swap10
        swapon /swap10
        echo '/swap10 none swap defaults 0 0' >> /etc/fstab
else
        echo 'swapfile found. No changes made.'
fi

# output results to terminal
cat /proc/swaps
cat /proc/meminfo | grep Swap

exit
