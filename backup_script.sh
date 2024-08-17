#!/bin/bash
BACKUP_FILE="/home/ubuntu/mydatabase.dump"
DATABASE_NAME="mydatabase"
PG_USER="postgres"
pg_dump -h localhost -U $PG_USER -d $DATABASE_NAME -f $BACKUP_FILE
