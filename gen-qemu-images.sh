#!/bin/bash

# required debootstrap package
#   aptitude install debootstrap


export LC_ALL=C
export LANGUAGE=C
export LANG=C
export LC_MESSAGES=C

dd if=/dev/zero of=raw.img bs=1M count=600
losetup /dev/loop0 raw.img
mke2fs /dev/loop0

mkdir raw-mount
mount /dev/loop0 raw-mount

debootstrap sid raw-mount/ http://ftp.de.debian.org/debian/

# install software for every image
chroot raw-mount aptitude -y install tcpdump zsh vim-full debian-keyring

cp data/vimrc raw-mount/root/.vimrc
cp data/zshrc raw-mount/root/.zshrc

chown pfeifer raw.img


# now close every ressource 
umount raw-mount
losetup -d /dev/loop0
rm -r raw-mount

# rename and clone raw images
mv raw.img alpha.img
cp alpha.img bravo.img
cp alpha.img charlie.img


# setup phase, image specific
losetup /dev/loop0 alpha.img
losetup /dev/loop1 bravo.img
losetup /dev/loop2 charlie.img

mkdir alpha-mount
mkdir bravo-mount
mkdir charlie-mount

mount /dev/loop0 alpha-mount
mount /dev/loop1 bravo-mount
mount /dev/loop2 charlie-mount

# write configuration

# hostname
echo "alpha"   > alpha-mount/etc/etc/hostname
echo "bravo"   > bravo-mount/etc/etc/hostname
echo "charlie" > charlie-mount/etc/etc/hostname

# ip setup
(
cat <<EOF
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
	address 192.168.100.1
	netmask 255.255.255.0
	network 192.168.100.0
	broadcast 192.168.100.255
EOF
) > alpha-mount/etc/network/interfaces/
chroot alpha-mount /etc/init.d/networking restart


(
cat <<EOF
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
	address 192.168.100.2
	netmask 255.255.255.0
	network 192.168.100.0
	broadcast 192.168.100.255
EOF
) > bravo-mount/etc/network/interfaces/
chroot bravo-mount /etc/init.d/networking restart


(
cat <<EOF
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
	address 192.168.100.3
	netmask 255.255.255.0
	network 192.168.100.0
	broadcast 192.168.100.255
EOF
) > charlie-mount/etc/network/interfaces/
chroot charlie-mount /etc/init.d/networking restart


# cleanup
umount alpha-mount
umount bravo-mount
umount charlie-mount

losetup -d /dev/loop0
losetup -d /dev/loop1
losetup -d /dev/loop2

rm -r alpha-mount
rm -r bravo-mount
rm -r charlie-mount
