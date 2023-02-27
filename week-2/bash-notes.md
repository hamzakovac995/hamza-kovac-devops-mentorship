# Commands used

### ssh remoteuser@remotehost -p 2022
**ssh** - ssh connection to remote host \
**remoteuser** - user on remote host \
**remotehost** - hostname or ip address of remote host \
**-p 2022** - port on remote host configured for ssh connection

### ls
**ls** - lists files and directories in a plain format without displaying much information \
**la** - lists of all files/directories (include hide files/directories)

### more
**more** is a command to view (but not modify) the contents of a text file \
**more --** is a command used to indicate that there are no more arguments, that is, that all previous arguments have ended and only standard input is now being processed

### grep
**grep** command in Linux is a powerful tool for searching text in files or piped input. It stands for "global regular expression print"\
grep millionth data.txt

### find
**find** command is a powerful tool in Linux used to search for files and directories in a specified location based on various criteria \
find . -type f -size 1033c ! -executable 
find / -type f -user bandit7 -group bandit6 -size 33c
find . -type f | xargs file

### strings 
**strings** command actually useful to extract printable characters from binary files \
strings data.txt | grep ===

### sort 
**sort** command is used to sort a file, arranging the records in a particular order. \
sort data.txt | uniq -c
