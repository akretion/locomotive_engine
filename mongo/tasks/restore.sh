#! /bin/bash

set -e

if [[ /var/backup/db/.modified -nt /data/db/.modified ]]; then
	echo "$(date)- waiting for file write to finish in order to restore"
	inotifywait_events="modify,attrib,move,create,delete"
	while inotifywait -r -t 10 -e $inotifywait_events /var/backup/db/ ; do	
		sleep 1  
	done

	mongorestore /var/backup/db/

	echo "$(date)- successfully restored"
	touch /data/db/.modified
fi
