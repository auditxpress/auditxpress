#!/bin/bash
set -euo pipefail

Report "=== filesystem Partition configuration audits"



check_partition() {
    local mount_point=$1
    if mount | grep -q "on $mount_point type"; then
        Report "PASS: $mount_point is configured as a separate partition."
    else
        Report "FAIL: $mount_point is not a separate partition. Please configure it in /etc/fstab."
    fi
}

check_mount_options() {
    local mount_point=$1
    shift
    local options=("$@") 
    local missing_options=()

    for option in "${options[@]}"; do
        if mount | grep "$mount_point" | grep -q "$option"; then
            Report "PASS: Mount option '$option' is set for $mount_point."
        else
            Report "FAIL: Mount option '$option' is missing on $mount_point."
            missing_options+=("$option")
        fi
    done

    if [ ${#missing_options[@]} -gt 0 ]; then
        Report "ERROR: The following required options are missing for $mount_point: ${missing_options[*]}"
    fi
}

declare -A partitions=(
    ["/tmp"]="nodev nosuid noexec"
    ["/dev/shm"]="nodev nosuid noexec"
    ["/home"]="nodev"
    ["/var"]="nodev nosuid"
    ["/var/tmp"]="nodev nosuid noexec"
    ["/var/log"]="nodev nosuid noexec"
    ["/var/log/audit"]="nodev nosuid noexec"
)
 
for mount_point in "${!partitions[@]}"; do

    check_partition "$mount_point"
	options=(${partitions[$mount_point]})
    if ! mount | grep -q "on $mount_point type"; then
        Suggestion "setup $mount_point with options $options"
        continue
    fi

    check_mount_options "$mount_point"

done





