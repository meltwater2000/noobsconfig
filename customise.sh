#!/bin/sh

#Get the location of the OS images
imagefolder=`sed -n "s/.*\"imagefolder\".*:.*\"\(.*\)\".*/\1/p" <os_config.json`

#Get the OS flavour installed
flavour=`sed -n "s/.*\"flavour\".*:.*\"\(.*\)\".*/\1/p" <os_config.json |sed "s/ \+/_/g"`

#Get the list of partition names used
partLabels=`sed -n "s/.*\"label\".*:.*\"\(.*\)\".*/\1/p" <$imagefolder/partitions.json`

#Get the number of partitions used.
numparts=`echo $partLabels |wc -w`

custom_part() {
	#parameters
	# $1 = srcfolder eg /mnt/os/xxxxx
	# $2 = Part dev eg /dev/mmcblk0p5
	# $3 = imagename eg Flavour_label
    local arg_srcfolder=$1
    local arg_imagename=$3
    local arg_dstfolder=/tmp/custom

    mkdir -p arg_dstfolder
    mount $2 arg_dstfolder

    #Create a custom file name from the flavour and partition names
    local tarfile=$arg_imagename.tar
    #Does the custom file exist?
    if [ -e $arg_srcfolder/$tarfile ]; then
        #Copy custom file to the SD card partition root
        cp $arg_srcfolder/$tarfile $arg_dstfolder
        #Untar the custom file
        cd $arg_dstfolder; tar -xvf $tarfile
    fi

    #Now check for a compressed custom file.
    local xzfile=$arg_imagename.tar.xz
    #Does the custom file exist?
    if [ -e $arg_srcfolder/$xzfile ]; then
        #Copy custom file to the SD card partition root
        cp $arg_srcfolder/$xzfile $arg_dstfolder
        #decompress & Untar the custom file
        cd $arg_dstfolder
        xz -dc $gzfile | tar x 
    fi

    umount arg_dstfolder
fi	
}

get_label()
{
    local part=$1
    local label
    if [ $numparts -eq 1 ]; then
        label=$partLabels
    else
        label=`echo $partLabels|sed -n "s/\(.*\) \(.*\)/\$part/p"`
    fi
    return $label
}

# 1st partition
if [ $numparts -gt 0 ]; then
    #Get the first partition name
    label1=get_label 1
    #Create a custom file name from the flavour and partition names
    part1Label=$flavour"_"$label1
    #Customise partition 1
    custom_part "$imagefolder" "$part1" "$part1Label" 
fi

#2nd Partition
if [ $numparts -gt 1 ]; then
    #Get the second partition name
    label2=get_label 2
    #Create a custom file name from the flavour and partition names
    part2Label=$flavour"_"$label2
    #Customise partition 2
    custom_part "$imagefolder" "$part2" "$part2Label" 
fi

cd /mnt
sync
