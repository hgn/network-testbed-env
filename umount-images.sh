#!/bin/bash

umount alpha-mount
rm -r alpha-mount
losetup -d /dev/loop0 

umount bravo-mount
rm -r bravo-mount
losetup -d /dev/loop1

umount charlie-mount
rm -r charlie-mount
losetup -d /dev/loop2
