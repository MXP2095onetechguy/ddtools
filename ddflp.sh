#!/bin/bash
# DDFlp.

block_size="1024"
count="1440"
type="2"

function usage {
    echo "Usage: ddflp [-d] [-2] <floppy_disk_image>"
    echo "  -d        Make the dd'd floppy image an MS-DOS filesystem"
    echo "  -2        Make the floppy image 2880k"
    exit 1
}

if [ $# -lt 1 ]; then
    usage
fi

dosify=0

if [ "$1" = "-d" ]; then
	dosify=1
	shift;
fi

dd bs=$block_size count=$(($count * $type)) if=/dev/zero of=$1;

if [ $dosify -ne 0 ]; then
    mkfs.msdos "$1";
fi
