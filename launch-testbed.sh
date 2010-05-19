#!/bin/bash

sudo modprobe kvm
sudo modprobe kvm-intel

echo "starting switch"
vde_switch -mod 770 -tap0 &

qemu-system-x86_64 -enable-kvm -hda debian-1.img -net nic,macaddr=00:00:00:00:00:01 \
	-net vde,vlan=0,sock=/var/run/vde.ctl \
        -kernel /usr/src/build-net-next/arch/x86/boot/bzImage -append "root=/dev/sda console=ttyS0" &
echo $$

# to avoid trashing
sleep 7

qemu-system-x86_64 -enable-kvm -hda debian-2.img -net nic,macaddr=00:00:00:00:00:02 \
	-net vde,vlan=0,sock=/var/run/vde.ctl  \
        -kernel /usr/src/build-net-next/arch/x86/boot/bzImage -append "root=/dev/sda console=ttyS0"
