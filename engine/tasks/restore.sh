#! /bin/bash

set -e

if [[ /var/backup/sites/.modified -nt /engine/public/sites/.modified ]]; then
	echo "$(date)- waiting for file write to finish in order to restore"
	inotifywait_events="modify,attrib,move,create,delete"
	while inotifywait -r -t 10 -e $inotifywait_events /var/backup/sites/
	do	
		sleep 1  
	done
	
	rsync -av --delete /var/backup/sites/ /engine/public/sites/
	echo "$(date)- restore complete"
fi
