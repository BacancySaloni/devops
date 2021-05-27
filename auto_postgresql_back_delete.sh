#!/bin/bash
export PATH=/bin:/usr/bin:/usr/local/bin
TODAY=`date +"%d%b%Y"`
DB_BACKUP_PATH='/home/bacancy/Documents/pgdbbackup'
PGSQL_HOST='localhost'
PGSQL_PORT='5432'
PGSQL_USER='bacancy'
PGSQL_PASSWD='bacancy'
DATABASE_NAME=mytestdb
BACKUP_RETAIN_DAYS=15   ## Number of days to keep local backup copy
mkdir -p ${DB_BACKUP_PATH}
#echo "Backup started for database - $DATABASE_NAME"
PGPASSWORD=${PGSQL_PASSWD}  pg_dump -h ${PGSQL_HOST} -p ${PGSQL_PORT} -U ${PGSQL_USER} ${DATABASE_NAME} > ${DB_BACKUP_PATH}/${DATABASE_NAME}-${TODAY}.sql
if [ $? -eq 0 ]; then
  echo "Database backup successfully completed"  
  find ${DB_BACKUP_PATH} -type f -mtime +$BACKUP_RETAIN_DAYS -delete
else
  echo "Error found during backup"
  exit 1
fi