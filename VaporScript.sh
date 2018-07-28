#!/bin/bash
#steamcmd +login user +app_update $line +quit

#parameter
########
vaporVersion=18-07-28
vaporFolder=vapor
vaporGameList=$vaporFolder/vaporGameList.tmp
vaporAddGameList=$vaporFolder/vaporAddGameList.txt
vaporConfig=$vaporFolder/vapor.conf
vaporLog=$vaporFolder/vapor.log

steamLib=.
steamcmdPath=
user=anonymous
userPw=""
sleepTime=12h
loopMode=false

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
	
	user=$(grep -oP '(?<=user=)\w+' $vaporConfig)
	echo $user
	if [ $user -eq " " ]
	then
		user=anonymous
	fi

	userPw=$(grep -oP '(?<=userPw=)\w+' $vaporConfig)

	sleepTime=$(grep -oP '(?<=sleepTime=)\w+' $vaporConfig)

	loopMode=$(grep -oP '(?<=loopMode=)\w+' $vaporConfig)
	if [ $loopMode -ne "true" || $loopMode -ne "false" ]
	then
		loopMode=false
	fi
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

while true
do
	#loadConfig

	log "Starting update check..."
	cmd="steamcmd +login $user $userPw"
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

	if $loopMode 
	then
		log "Waiting $sleepTime..."
		sleep $sleepTime
	else
		exit 0
	fi
done
exit 0