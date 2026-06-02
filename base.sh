#!/bin/bash


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

function install(){
	sudo apt install -y restic
}
function restore(){
        SNAPSHOT="${1:-latest}"
        TARGET="./restore/$SNAPSHOT"

        mkdir -p "$TARGET"
        restic "${ARGS[@]}" restore "$SNAPSHOT" --target "$TARGET"
}


