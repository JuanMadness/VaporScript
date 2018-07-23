#!/bin/bash
#steamcmd +login spoker14 +app_update $line +quit

vaporFolder=Vapor
vaporGameList=$vaporFolder/VaporGameList.tmp

echo VaporScript 18-07-23

mkdir -p $vaporFolder
touch $vaporGameList

while [ true ]
do
	cmd="steamcmd +login spoker14"
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

	sleep 1h
done
exit