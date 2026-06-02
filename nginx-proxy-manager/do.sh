#!/bin/bash

PRO=nginx-proxy-manager
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
	restic ${ARGS[@]} backup ./data ./letsencrypt
	dockup
}


"$1" "$2"
