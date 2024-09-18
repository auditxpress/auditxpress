#!/usr/bin/env bash


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
