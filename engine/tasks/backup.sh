#! /bin/bash

set -e

# ensure the target location is stable
inotifywait_events="modify,attrib,move,create,delete"
while inotifywait -r -t 10 -e $inotifywait_events /var/backup/sites/
do	
	sleep 1  
done

if [[ /var/backup/sites/.modified -nt /engine/public/sites/.modified ]]; then
	echo "$(date)- SKIPPING BACKUP - backup data is newer"
	exit 0
fi

rsync -a --delete /engine/public/sites/ /var/backup/sites/

# keep track of what has been modified
touch /var/backup/sites/.modified /engine/public/sites/.modified

echo "$(date)- backup successful"