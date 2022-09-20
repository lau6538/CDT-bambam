#!/bin/bash

# Bamboozle (bambam)
# Logan Upchurch

if [ "$EUID" -ne 0 ]; then
	echo "This script only works as root"
	exit
fi

clear

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

clear
printf "*********************\n"
printf "***** BAMBOOZLE *****\n"
printf "*********************\n\n\n"

printf "Enter selection:\n\n"

OPTIONS=("Hide a specific process" "Hide random processes" "Quit")

select opt in "${OPTIONS[@]}"
do
	case $opt in
		"Hide a specific process")
			printf "1"
			;;
		"Hide random processes")
			printf "2"
			;;
		"Quit")
			break
			;;
		*)
			clear
			printf "*********************\n"
			printf "***** BAMBOOZLE *****\n"
			printf "*********************\n\n\n"
			
			printf "Enter selection:\n\n"
			printf "1) Hide a specific process\n"
			printf "2) Hide random processes\n"
			printf "3) Quit\n"
			printf "Invalid option\n"
			;;
	esac
done

clear
	

