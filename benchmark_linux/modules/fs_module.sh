#!/usr/bin/env bash
set -euo pipefail

Report "Checking non-needed filesystem kernel modules"
modules_to_check=(
    "cramfs"
    "freevxfs"
    "hfs"
    "hfsplus"
    "jffs2"
    "squashfs"
    "udf"
    "usb-storage"
)

is_module_loaded() {
    local module=$1
    if lsmod | grep -q "^$module "; then
        return 0
    else
        return 1
    fi
}

is_any_found=false
found=0
for module in "${modules_to_check[@]}"; do
    if is_module_loaded "$module";then
		is_any_found=true
		found=$((found + 1))
		report "$module found"
	fi
done

if $is_any_found;then
	Report "Found:$found"
	Suggestion "remove above modules, if you dont have usecases"
else
	Report "Found:$found"
fi

