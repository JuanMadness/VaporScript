#!/bin/bash
#steamcmd +login user +app_update $line +quit

#parameter
########
vaporVersion=18-07-25
vaporFolder=vapor
vaporGameList=$vaporFolder/vaporGameList.tmp
vaporAddGameList=$vaporFolder/vaporAddGameList.txt
vaporConfig=$vaporFolder/vapor.conf
vaporLog=$vaporFolder/vapor.log

steamLib=.
steamcmdPath=
user=spoker14
userPw=
sleepTime=12h

#functions
#######

function log {
	printf "%-30s%s\n" "$(date)" "$1" >> $vaporLog
	printf "%-30s%s\n" "$(date)" "$1"
}

function closedScript {
	log "Check https://github.com/JuanMadness/VaporScript for updates!"
	log "Closed VaporScript $vaporVersion"
	exit
}

function loadConfig {
	log "Loading config..."
	log "FEATURE NOT IMPLEMENTED :("
}

#main
#####
trap closedScript EXIT SIGINT

echo "vaporScript"
log "vaporScript $vaporVersion"

mkdir -p $vaporFolder
touch $vaporGameList
touch $vaporConfig
touch $vaporLog
touch $vaporAddGameList

while [ true ]
do
	loadConfig

	log "Starting update check..."
	cmd="steamcmd +login $user"
	echo "" > $vaporGameList

	grep -rnw 'appid' $steamLib/*.acf | grep -Eo '[0-9]{2,10}' | while read line
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
	log "Update check done!"

	log "Waiting $sleepTime..."
	sleep $sleepTime
done
exit