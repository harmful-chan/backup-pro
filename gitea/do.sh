#!/bin/bash

PRO=gitea
ARGS=(
	"-o" "s3.bucket-lookup=dns" 
	"-o" "s3.region=ap-guangzhou" 
	"-r" "s3:https://cos.ap-guangzhou.myqcloud.com/backup-1359314811/$PRO"
)

set -a
source ../.env
set +a
source ../base.sh

function backup()
{
	dockdown
        mkdir -p data/sql
        sudo docker compose up db -d
        sleep 3
        sudo docker compose exec db mysqldump -h localhost \
	       -uroot -pgitea --single-transaction --routines \
	       --events --all-databases  > ./data/sql/all-mysql.sql
        restic ${ARGS[@]} backup ./data/gitea ./data/sql
        sudo docker compose down
	dockup
}


"$1" "$2"
