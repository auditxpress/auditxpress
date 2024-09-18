#!/usr/bin/env bash

PROGRAM_NAME="Auditxpress"
LOGFILE=~/${PROGRAM_NAME}.log
REPORTFILE=~/${PROGRAM_NAME}_report.dat
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MODULES_DIR=$SCRIPT_DIR/benchmark_linux/modules

set -euo pipefail

privillege=0 # set to true
if [ "$EUID" -ne 0 ]; then
  privillege=1
fi

if [ -f "$REPORTFILE" ]; then
    rm "$REPORTFILE"
else
	touch $REPORTFILE
fi

. $SCRIPT_DIR/benchmark_linux/helper_functions.sh

for module in $(ls $MODULES_DIR/*.sh);do
	source $module
done

