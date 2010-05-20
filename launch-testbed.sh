#!/bin/bash

sudo modprobe kvm
sudo modprobe kvm-intel

killall vde_switch

echo "starting switch"
vde_switch -mod 770 -tap0 &

qemu-system-x86_64 -enable-kvm -hda alpha.img -net nic,macaddr=00:00:00:00:00:01 \
	-net vde,vlan=0,sock=/var/run/vde.ctl \
  -kernel /usr/src/build-net-next/arch/x86/boot/bzImage -append "root=/dev/sda console=ttyS0" &

qemu-system-x86_64 -enable-kvm -hda bravo.img -net nic,macaddr=00:00:00:00:00:02 \
	-net vde,vlan=0,sock=/var/run/vde.ctl  \
  -kernel /usr/src/build-net-next/arch/x86/boot/bzImage -append "root=/dev/sda console=ttyS0" &

qemu-system-x86_64 -enable-kvm -hda charlie.img -net nic,macaddr=00:00:00:00:00:03 \
	-net vde,vlan=0,sock=/var/run/vde.ctl  \
  -kernel /usr/src/build-net-next/arch/x86/boot/bzImage -append "root=/dev/sda console=ttyS0"
