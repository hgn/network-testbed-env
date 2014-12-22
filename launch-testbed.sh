#!/bin/bash

sudo modprobe kvm
sudo modprobe kvm-intel

killall vde_switch

clear

echo "starting switch"
vde_switch -mod 770 -tap 0 &

qemu-system-x86_64 -enable-kvm -net nic,macaddr=00:00:00:00:00:01 \
	-net vde,vlan=0,sock=/var/run/vde.ctl  \
  -kernel /usr/src/build-net-next/arch/x86/boot/bzImage -append "root=/dev/sda console=ttyS0" charlie.img &

sleep 5s
wait
exit

qemu-system-x86_64 -enable-kvm -net nic,macaddr=00:00:00:00:00:02 \
	-net vde,vlan=0,sock=/var/run/vde.ctl \
  -kernel /usr/src/build-net-next/arch/x86/boot/bzImage -append "root=/dev/sda console=ttyS0" bravo.img &

wait

# qemu-system-x86_64 -enable-kvm -hda charlie.img -net nic,macaddr=00:00:00:00:00:03 \
# 	-net vde,vlan=0,sock=/var/run/vde.ctl vga=791  \
#   -kernel /usr/src/build-net-next/arch/x86/boot/bzImage -append "root=/dev/sda console=ttyS0"
