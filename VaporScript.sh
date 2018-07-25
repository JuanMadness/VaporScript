#!/bin/bash
#steamcmd +login user +app_update $line +quit

#parameter
########

vaporFolder=vapor
vaporGameList=$vaporFolder/vaporGameList.tmp
vaporConfig=$vaporFolder/vapor.conf
vaporLog=$vaporFolder/vapor.log
user=spoker14
userPw=
sleepTime=6h

#functions
#######

function loadConfig {
	echo nothing
}



#main
#####

echo vaporScript 18-07-25

mkdir -p $vaporFolder
touch $vaporGameList
touch $vaporConfig
touch $vaporLog

while [ true ]
do
	cmd="steamcmd +login $user"
	echo "" > $vaporGameList

	grep -rnw 'appid' *.acf | grep -Eo '[0-9]{2,10}' | while read line
	do
		echo " $line" >> $vaporGameList
	done 

	while read -r line
	do

		if [[ $line =~ ^[0-9]+$ ]]
		then
   			cmd="$cmd +app_update $line"
		else
    			continue
		fi
	
	done < $vaporGameList

	cmd="$cmd +quit"

	#echo $cmd
	$cmd

	echo "" > $vaporGameList
	echo "#####DONE#####"

	sleep $sleepTime
done
exit