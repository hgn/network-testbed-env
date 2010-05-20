#!/bin/bash

mkdir alpha-mount
losetup /dev/loop0 alpha.img
mount /dev/loop0 alpha-mount

mkdir bravo-mount
losetup /dev/loop1 bravo.img
mount /dev/loop1 bravo-mount

mkdir charlie-mount
losetup /dev/loop2 charlie.img
mount /dev/loop2 charlie-mount
