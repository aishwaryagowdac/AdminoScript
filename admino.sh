#!/bin/bash

#this is a help function. This will display the commands and its respective arguments to be passed
function show_help {
		echo "Welcome to the Admino system information script 
Please follow the following instructions to use it"

	#These intstructions are used to understand the purpose of each case in the script
	echo "
	- ./admino -h/--help						-->Displays all the allowed commands and arguments
	- ./admino -1 <Interface>					-->Provides IP address of Network Interface
	- ./admino -3							-->Provides a list of users in the system
	- ./admino -4 <groupname>					-->Provides the list of members in the given group
	- ./admino -5 <username> <directory_path>			-->Provides list of files owned by specified user from a particular directory
	- ./admino -6 <directory_path> <Zip_file_name> <Password>	-->Creates and encrypts a zip file for all the files in a directory
	- ./admino -8 							-->lists IPs and number of connections from where system's users have connected
"
} 

#This is the function used to list the users in the system when argument -3 is passed
function show_userlist {
	echo "the list of users of your system are:
$(awk -F: '{print "\t-" $1}' /etc/passwd)" 				#filters out only user list from the /etc/passwd location
}

	

if [ $# -eq 0 ]; then
	echo "ERROR: No argument passed. Refer help instructions" 	#if there is no argument passed, help function will be displayed
	show_help
	exit 0

#condition: if there is only one argument passed then will enter the loop
elif [ $# -eq 1 ]; then
	if [ $1 == "-h" ] || [ $1 == " --help" ]; then 			#if the argument is -h or --help, it calls show_help funtion
		show_help
		exit 0
	
	elif [ $1 == "-8" ]; then
		echo "(Con.#)        (IP Add)"
		echo "$(netstat -ntu | awk '{print $5}' | cut -d: -f1 -s | sort | uniq -c | sort -nk1 -r)"
		exit 0

	elif [ $1 == "-3" ]; then 					#if the argument is -3, it calls show_userlist function
		show_userlist
		exit 0

	else
		echo "ERROR: Invalid argument passed." 			#This will display error and displays help function if the single argument passed is not -8, -h, --help or -3
		show_help
		exit 0
	fi

#condition: if there are 2 arguments passed then will enter the loop
elif [ $# -eq 2 ]; then
	if [ $1 == "-4" ]; then						#enters the loop if 1st argument is -4
		group_info=$(grep "$2" /etc/group) 			#gets group info and stores in group_info
		user_list=$(echo "$group_info" | awk -F: '{print $4}' | sed 's/,/\n/g') #gets just the users of the group stores in user_list
		if [ -n "$user_list" ]; then 				#if the users exist, displays users
			echo "The list of users in the group: '$2'"
			echo "$user_list"
		else							#if users or group does not exist, displays below error
			echo "Group '$2' not found or has no users."
		fi
		exit 0
	
	elif [ $1 == "-1" ]; then 					#enters the loop if 1st argument is -3
		ip_address=$(ifconfig "$2" | grep -oP 'inet\s+\K[^\s]+') #gets interface details and sorts and stores just the IP in ip_address
		echo "Your ip for $2 interface is: $ip_address" 	#displays ip_address
		exit 0

	else 
		echo "ERROR: Invalid argument passed." 			#This will display error and calls help funstion if the 1st argument passed is not -4 or -2
		show_help
		exit 0
	fi

#condition: if there are 3 arguments passed then will enter the loop
elif [ $# -eq 3 ]; then							
	if [ $1 == "-5" ]; then						#enter the loop if 1st argument is -5
		chomod 777 "$3"						#giving full permission for other users to access the directory
		if [ ! -d "$3" ]; then					#will display error message if the 3rd argument id not a directory
			echo "ERROR: The directory '$3' does not exist"
			exit 0
		fi
		file_count=$(find "$3" -type f -user "$2" | wc -l)	#finds directory in the mentioned user and gets the count of files in the directory and stores in file_count
		echo "This user has a total of "$file_count" files"	#displays number of files
		exit 0

	else								#This will display error and calls help funstion if the 1st argument passed is not -5
		echo "ERROR: Invalid argument passed."
		show_help
		exit 0
	fi	

#condition: if there are 4 arguments passed, then will enter the loop
elif [ $# -eq 4 ]; then
	if [ $1 == "-6" ]; then						#Calls show_zipfiles function if 1st argument passed is -6
		chmod 777 "$2"						#giving full permission for other users to acces the directory
		find "$2" -type f -exec zip "$3" {} \;			#filters just the files in the directory and zips it
		openssl enc -aes-256-cbc -salt in "$3" -out "$3" -k "$4" #the zipped file is now encrypted with password
		exit 0

	else 
		echo "ERROR: Invalid argument passed."			#This will display error and calls help function if the 1st argument passed in not -6
		show_help
		exit 0
	fi

else
	echo "ERROR: Invalid number of arguments passed" 		#This will display error if any other invalid number of arguments(ie more than 4) are passed other than mentioned in help function
	show_help
	exit 1
fi


