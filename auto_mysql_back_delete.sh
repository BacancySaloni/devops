#!/bin/bash
export PATH=/bin:/usr/bin:/usr/local/bin
TODAY=`date +"%d%b%Y"`
DB_BACKUP_PATH='/home/bacancy/Documents/shellscripts/dbbackup'
MYSQL_HOST='localhost'
MYSQL_PORT='3306'
MYSQL_USER='bacancy'
DATABASE_NAME=test1
BACKUP_RETAIN_DAYS=15   ## Number of days to keep local backup copy
mkdir -p ${DB_BACKUP_PATH}
#echo "Backup started for database - $DATABASE_NAME"
mysqldump  --defaults-file=/home/bacancy/.my.cnf  -h localhost -P 3306 -u bacancy  ${DATABASE_NAME} > ${DB_BACKUP_PATH}/${DATABASE_NAME}-${TODAY}.sql
if [ $? -eq 0 ]; then
  echo "Database backup successfully completed"  
  find ${DB_BACKUP_PATH} -type f -mtime +$BACKUP_RETAIN_DAYS -delete
else
  echo "Error found during backup"
  exit 1
fi