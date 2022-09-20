#!/bin/bash

# Bamboozle (bambam)
# Logan Upchurch

# make empty folder in /tmp
printf "Making empty directory /tmp/bam\n"
mkdir -p /tmp/bam

# if it can't, make empty folder in /usr/bin
if [ $? -ne 0 ]; then
	printf "Failed. Making empty directory /usr/bin/bam\n"
	mkdir -p /usr/bin/bam
fi

printf "Success. Press any key to continue\n"
read -n 1 -s



