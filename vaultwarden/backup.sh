#!/bin/bash

ARGS=(
	"-r" "rclone:cos:backup-1359314811/vaultwarden"
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
	restic ${ARGS[@]} backup ./data
	dockup
}

function restore(){
	mkdir -p ./restore/latest
	restic ${ARGS[@]} restore latest --target ./restore/latest	
}

function snapshots(){
	restic ${ARGS[@]} snapshots
}


"$1"
