#!/bin/bash

PRO=dnsmgr

ARGS=(
	"-r" "rclone:cos:backup-1359314811/$PRO"
	"--password-file" "$HOME/.restic/password"
)
is_running=false
if [ $(sudo docker compose ps -q | wc -l) -gt 0 ];then
	is_running=true
fi

function dockdown(){
	if $is_running ;then
                sudo docker compose down
        fi
}
function dockup(){
	if $is_running ;then
                sudo docker compose up -d
        fi
}

function backup()
{
	dockdown
	mkdir -p data/sql
	sudo docker compose up db -d
	sleep 3
	sudo docker compose exec db mysqldump -h localhost -uroot -p123456 --single-transaction --routines --events --all-databases  > ./data/sql/all-mysql.sql
	restic ${ARGS[@]} backup ./data/conf ./data/web ./data/sql
	sudo docker compose down
	dockup
}

function restore(){
	mkdir -p ./restore/latest
	restic ${ARGS[@]} restore latest --target ./restore/latest	
}

function snapshots(){
	restic ${ARGS[@]} snapshots
}

function init(){
	restic ${ARGS[@]} init
}


"$1"
