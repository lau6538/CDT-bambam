#!/bin/bash

# Bamboozle (bambam)
# Logan Upchurch

# quit if not run as root
if [ "$EUID" -ne 0 ]; then
	echo "This script only works as root"
	exit -1
fi

# make test empty folder in /tmp
DIR="/tmp/bam"
mkdir -p $DIR

# if it can't, make test empty folder in /usr/bin
if [ $? -ne 0 ]; then
	DIR="/usr/bin/bam"
	mkdir -p $DIR
	
	# if it can't, quit
	if [ $? -ne 0 ]; then
		echo "Script failed"
		exit -2
	fi
	
	rmdir $DIR 2> /dev/null
fi

# remove test folder
rmdir $DIR 2> /dev/null

clear
printf "*********************\n"
printf "***** BAMBOOZLE *****\n"
printf "*********************\n\n"

printf "The empty directory is: $DIR\n\n"

printf "Enter selection:\n"

OPTIONS=("Hide a specific process" "Hide random processes" "Quit")

select opt in "${OPTIONS[@]}"
do
	case $opt in
		"Hide a specific process")
			clear
			printf "Enter the PID of the process you want to hide\n"
			printf "(If you're unsure, do ps -ef)\n"
			read pid
			
			mkdir -p ${DIR}${pid}
			mount -o bind ${DIR}${pid} /proc/$pid
			
			if [ $? -ne 0 ]; then
				printf "Mount failed. Press any key to return to menu\n"
				read -n 1 -s
			else
				printf "Success. Press any key to return to menu\n"
				read -n 1 -s
			fi
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
			printf "*********************\n\n"
			
			printf "The empty directory is: $DIR\n\n"
			
			printf "Enter selection:\n"
			printf "1) Hide a specific process\n"
			printf "2) Hide random processes\n"
			printf "3) Quit\n"
			printf "Invalid option\n"
			;;
	esac
done

clear
	

