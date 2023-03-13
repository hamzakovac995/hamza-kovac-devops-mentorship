#!/bin/bash
# iterating through multiple directories
for file in /var/log/*.log /etc/hamza_kovac
do
if [ -d "$file" ]
then
echo "$file is a directory"
elif [ -f "$file" ]
then
echo "$file is a file"
else
echo "$file doesn't exist"
fi
done
