#!/bin/sh
DEFAULT_STROAGE_PATH=~/Documents/

showUsage()
{
	echo "Usage: $0 content filename [storage path]"
	echo "# example"
	echo "$0 hello_world note.txt /home/<user>/Desktop"
	exit 0
}

log_and_mv()
{
	# show info
	echo "Your filename:$filename"  
	echo "Your stroage path:$storage_path"

	# do 
	echo -e "$content" > "$filename"
	mv "$filename" "$storage_path" && echo "mv is successful" || echo "mv is fail"
}

# 
# MAIN
#

# variable
content=$1
filename=$2
storage_path=$3
[ -z "$storage_path" ] && storage_path=$DEFAULT_STROAGE_PATH	# Assign default path

# Check $content & $filename is null or not
[ -z "$content" ] || [  -z "$filename"  ] && showUsage 

# main task
log_and_mv


