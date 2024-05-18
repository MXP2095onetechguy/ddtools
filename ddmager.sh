#!/bin/bash
# DDMager.

# shellcheck disable=SC2086

# default vars
block_size="64K"
conversion="sync,noerror"
ddflags="bs=$block_size conv=$conversion"

# Function to display usage instructions
function usage {
    echo "Usage: ddmager [-w] <disk_image> <image_file>"
    echo "  -w        Write the image file to the output disk"
    exit 1
}

# Check if the number of arguments is at least 2
if [ $# -lt 2 ]; then
    usage
fi

write_disk=0

# Check if the -w flag is provided
if [ "$1" == "-w" ]; then
    write_disk=1
    shift # Remove the -w flag from the argument list
fi

# Check if there are exactly two positional arguments
if [ $# -ne 2 ]; then
    usage
fi

disk_image="$1"
image_file="$2"

# Check if the disk image and image file exist
if [ ! -e "$disk_image" ]; then
    echo "Error: Disk image '$disk_image' does not exist."
    exit 1
fi

if [ ! -e "$image_file" ]; then
    echo "Error: Image file '$image_file' does not exist."
    exit 1
fi

if [ $write_disk -eq 0 ]; then
    # Read the input image into a bz2'd file
    dd if="$disk_image" $ddflags status=progress | bzip2 -9 > "$image_file"
    echo "Image '$disk_image' has been compressed to '$image_file.bz2'."
else
    # Write back to the output disk from the bz2'd image file
    bunzip2 -c "$image_file" | dd of="$disk_image" $ddflags status=progress
    echo "Image '$image_file.bz2' has been written to '$disk_image'."
fi