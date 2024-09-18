#!/usr/bin/env bash


# Define color variables
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

# Reset color
NC='\033[0m'  # No Color


Log() {
    if [ -n "${LOGFILE}" ]; then
        DATETIME=$(date "+%Y-%m-%d %H:%M:%S")
        echo "${DATETIME} $1" >> "${LOGFILE}"
    fi
}

Report() {
	if [ -n "${REPORTFILE}" ];then
		echo $1 >> ${REPORTFILE}
	fi
}

Suggestion() {
	Report $1
}
