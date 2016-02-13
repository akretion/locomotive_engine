#! /bin/bash

set -e

# ensure the target location is stable
inotifywait_events="modify,attrib,move,create,delete"
while inotifywait -r -t 10 -e $inotifywait_events /var/backup/sites/
do	
	sleep 1  
done

if [[ /var/backup/db/.modified -nt /data/db/.modified ]]; then
	echo "$(date)- SKIPPING BACKUP - backup data is newer"
	exit 0
fi

mongodump -o /var/backup/db/

# keep track of what has been modified
touch /var/backup/db/.modified /data/db/.modified

echo "$(date)- backup successful"