#!/bin/bash

losetup /dev/loop0 diskimage.img
mount /dev/loop0 mounted

