#!/bin/bash
# Checking for the input file
if [[ $1 == "" ]]; then
    echo "Please, provide an Ubuntu Touch boot.img file."
    echo "Example:"
    echo "./bootconverter.sh boot.img"
    exit 1
fi

# Checking for abootimg
if [[ $(which abootimg) == "" ]]; then
   echo "Please, install the abootimg package."
   exit 1
fi


# Setting up temp folder and filenames
FILENAME=$(echo "$1" | cut -f 1 -d '.')
OUTFILE="droidian-$FILENAME.img"
DIR=$PWD
TEMP=$(mktemp -d)
cp $1 $TEMP
cd $TEMP

# Extracting bootimage
abootimg -x $1
echo ""

# Making the change
sed '/^cmdline/ s: systempart=/dev/disk/by-partlabel/system::' -i bootimg.cfg

# Creating new bootimage
abootimg --create $OUTFILE -f bootimg.cfg -k zImage -r initrd.img
echo ""

# Putting the new bootimage back
mv $OUTFILE $DIR
echo "Droidian boot image created as $OUTFILE"
exit 0
