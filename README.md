# AdminoScript
The objective of this lab is to create a bash script with improved linux security functions. 
These functions will provide different types of security-related information, which may be extremely useful for a Linux System Administrator. 
In Linux systems, there is a huge amount of system information available that sometimes makes harder to find specific information related to an incident. For that reason, it is very important to know how to appropriately filter that massive amount of data to only what is needed. This capacity is essential to obtain only the pieces of information that are relevant for your cyberescurity objectives.

The Funstions that I have implemented are as follows:
   1. ./admino -h/--help						                               -->Displays all the allowed commands and arguments
	 2. ./admino -1 <Interface>					                             -->Provides IP address of Network Interface
	 3. ./admino -3							                                     -->Provides a list of users in the system
	 4. ./admino -4 <groupname>					                             -->Provides the list of members in the given group
	 5. ./admino -5 <username> <directory_path>			                 -->Provides list of files owned by specified user from a particular directory
	 6. ./admino -6 <directory_path> <Zip_file_name> <Password>	     -->Creates and encrypts a zip file for all the files in a directory
	 7. ./admino -8 							                                   -->lists IPs and number of connections from where system's users have connected
