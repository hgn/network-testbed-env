#!/bin/bash

dd if=/dev/zero of=diskimage.img bs=1M count=600
losetup /dev/loop0 diskimage.img
mke2fs /dev/loop0
mkdir mounted
mount /dev/loop0 mounted
debootstrap sid mounted/ http://ftp.us.debian.org/debian/
chown pfeifer diskimage.img

umount mounted
losetup -d /dev/loop0

