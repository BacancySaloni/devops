#!/bin/bash
MyUSER="username"                     # USERNAME
MyPASS="StrnogPassword"        # PASSWORD
MyHOST="1.1.1.1"

# Linux bin paths, change this if it can't be autodetected via which command
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
CHOWN="$(which chown)"
CHMOD="$(which chmod)"
GZIP="$(which gzip)"
MAIL="email@gmail.com"
MAILER="$(which mail)"
STATUSFILE="/tmp/statusfile.$NOW"
#STATUSFILEmail="/tmp/statusfilemail"

# Backup Dest directory, change this if you have someother location
DEST="/mnt/Backup/DBbackup"

# Get data in dd-mm-yyyy format
NOW="$(date +"%d-%m-%Y")"

# Main directory where backup will be stored
MBD="$DEST/$NOW"

# Get hostname
#HOST="$(hostname)"
#HOST="localhost"
# File to store current backup file
FILE=""
#SIZE="$(du -sh "$MBD/$db-$(date +"%H-%M").gz" | cut -f1)"
# Store list of databases
DBS=""

# DO NOT BACKUP these databases
IGGY="mysql information_schema performance_schema tmp innodb"
[ ! -d $MBD ] && mkdir -p $MBD || :

# Only root can access it!
$CHOWN 0.0 -R $DEST
$CHMOD 0605 $DEST

#  Get all database list first
DBS="$($MYSQL -u $MyUSER -p$MyPASS -h $MyHOST -Bse 'show databases')"

for db in $DBS
do
    skipdb=-1
    if [ "$IGGY" != "" ];
    then
        for i in $IGGY
        do
            [ "$db" == "$i" ] && skipdb=1 || :
        done
    fi

    if [ "$skipdb" == "-1" ] ; then
        FILE="$MBD/$db-$(date +"%H-%M").gz"
       # do all inone job in pipe,
        # connect to mysql using mysqldump for select mysql database
        # and pipe it out to gz file in backup dir :)
        $MYSQLDUMP --routines --skip-lock-tables -h $MyHOST -u $MyUSER -p$MyPASS $db | $GZIP -9 > $FILE | `find /mnt/Backup/DBbackup/* -type d -mtime +7 -exec rm -rf {} \;`
    fi
    if [ "$?" -eq "0" ]
 then
   SIZE="$(du -sh "$MBD/$db-$(date +"%H-%M").gz" | cut -f1)"
   echo "$db backup is OK with size $SIZE" >> $STATUSFILE
 else
   echo "##### WARNING: #####  $db backup failed" >> $STATUSFILE
  fi
done
#tail -n +4 $STATUSFILE > $STATUSFILEmail 
$MAILER -s "Backup report for $NOW " -- $MAIL < $STATUSFILE
#rm $STATUSFILE
#rm $STATUSFILEmail
