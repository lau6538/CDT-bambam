So, you want to discombobulate your targets with Bamboozle?

Bambam simply hides processes by bind mounting /proc/[PID] to empty folders.
It must be run locally as root to function.
The empty folders are bam#, and the script will show that they are located either in /tmp or in /usr/bin.

Command line usage: ./bambam.sh

This script prompts the user with four options:
1) Hide a specific process
 - Self-explanatory.
 - Prompts the user for the PID of the process they want to hide. ps -ef in command line will help.
2) Hide random processes
 - From the list of processes, randomly hides approximately 50% that are listed.
3) Hide all processes for a specific user
 - Hides the processes running on a specific user.
 - Prompts the user for the user name whose processes they want to hide.
4) Hide all processes
 - Self-explanatory.
5) Unhide all hidden processes
 - Self-explanatory. Undo your shenanigans.

Sorry, but no vault speed increase is included with this script.

