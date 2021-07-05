#=======================================================================
#
#	University College Dublin
#	COMP20200 - UNIX Programming
#
#	Assignment 3: 	BASH script
#	Project:	assign3_19351611.sh
#	Author:      	Cian O'Mahoney
#	Student Number:	19351611
#	Email:		cian.omahoney@ucdconnect.ie
#	Date:        	26/4/2021
#	Version:     	1.0
#	
#	Description: 	> BASH script to duplicate directory structure
#			  from source directory to destination directory,
#			  copying only files of type '.png'.
#			  These '.png' files are then convert to '.jpg' 
#			  files in the destination directory.
#			> The source directory is not changed.
#			> If the destination directory does not exist
#			  before execution, it will be created.
#			> If the destination directory already exist,
#			  new '.png' files will be copied in and
#			  any existing '.png' files with the same names
#			  will be replaced.
#	
#	Arguments:	1: <SOURCE DIRECTORY>
#			2: <DESTINATION DIRECTORY>
#
#=======================================================================

#! /bin/bash


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DECLARING VARIABLES:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

PROGRAM=$(basename $0)
SOURCE=$1
DESTINATION=$2
OLD_TYPE=".png"
NEW_TYPE=".jpg"


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TESTING ARGUMENTS:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# If user does not provide correct number of arguments:
if [ ! $# -eq 2 ]; then
	echo "Correct usage: $PROGRAM <source directory> <destination directory>."
	exit -1
fi

# If source directory does not already exist:
if [ ! -d $SOURCE ]; then
	echo "The source directory '$SOURCE' does not exist!"
	exit -1
fi

# If destination directory does not alreay exist, make it:
if [ ! -d $DESTINATION ]; then
	mkdir $DESTINATION
fi

# If unable to write to destination directory:
if [ ! -w $DESTINATION ]; then
	echo "Unable to write to destination directory '$DESTINATION'."
	exit -1
fi



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# FUNCTION: 	copyAndConvert
# ARGUMENTS:	1: <Source directory>
# DESCRIPTION:	Function to copy directories and '.png' files from source
#		to destination directory.
#		Recursively calls itself to access subdirectories.
#		Converts '.png' files to '.jpg' files.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function copyAndConvert 
{
	# Step through contents of passed directory:
	for file in $( ls $1 )
	do
		# If file is a directory:
		if [ -d $1/$file ]; then
			# Remove source directory from path to copy:
			DIR=$DESTINATION/${1#$SOURCE}/$file

			# If directory to copy does not already exist
			# in destination directory, make it:
			if [ ! -d $DIR ]; then
				mkdir $DIR
			fi

			# Recursively call copyAndConvert to enter subdirectory found:
			copyAndConvert $1/$file

		# If is a file:
 		elif [ -f $1/$file ]; then
			# If file is of type '.png', convert and copy to destination:
			if [[ $file == *.png ]]; then
				convert $1/$file $DESTINATION/${1#$SOURCE}/${file/$OLD_TYPE/$NEW_TYPE}
			fi
		fi		
	done
} # End of function 'copyAndConvert'.



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CALL FUNCTION
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
copyAndConvert $SOURCE

# If return value of function is not zero, an error has occured:
if [ ! $? -eq 0 ]; then
	echo "copyAndConvert(): An error occured!"
	exit -1
fi

# Otherwise, exit normally:
exit 0
