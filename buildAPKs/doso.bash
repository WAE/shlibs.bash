#!/usr/bin/env bash
# Copyright 2020 (c) all rights reserved by SDRausty; See LICENSE
# File `doso.bash` is currently being developed
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
"$RDR"/scripts/bash/shlibs/trap.bash 146 147 148 "${0##*/} doso.bash"
. "$RDR/scripts/sh/shlibs/inst.sh"
_INST_ "cmake" "cmake" "${0##*/} doso.bash"
_INST_ "make" "make" "${0##*/} doso.bash"
CPUABI="$(getprop ro.product.cpu.abi)"
printf "\\e[1;38;5;113m%s\\n" "Searching for CMakeLists.txt files in ~/$(cut -d"/" -f7-99 <<< "$JDR")/;  Please be patient..."
AMKFS=("$(find "$JDR" -type f -name CMakeLists.txt)")
_DOMAKES_() {
	for FAMK in ${AMKFS[@]}
	do
			printf "%s\\n" "Found ~/$(cut -d"/" -f7-99 <<< "$FAMK")."
			UNUM="$(date +%s)"
			sleep 1
			mkdir -p "$JDR/bin/lib/$CPUABI/$UNUM"
			cp -ar "${FAMK%/*}"/* "$JDR/bin/lib/$CPUABI/$UNUM"
			cd "$JDR/bin/lib/$CPUABI/$UNUM"
			printf "%s\\n" "Building in $(pwd)"
			tree || ls 
			printf "%s\\n" "Beginning cmake and make in ~/$(cut -d"/" -f7-99 <<< "$PWD")/..."
			cmake . || printf "\\e[1;48;5;166m%s\\e[0m\\n" "Signal 42 generated in cmake ${0##*/} doso.bash"
			make || printf "\\e[1;48;5;167m%s\\e[0m\\n" "Signal 44 generated in make ${0##*/} doso.bash"
			find . -type f -name "*.so" -exec mv {} "$JDR/bin/lib/$CPUABI" \; || printf "\\e[1;48;5;168m%s\\e[0m\\n" "Signal 46 generated in find -name *.so ${0##*/} doso.bash"
			printf "%s\\n" "Finished cmake and make in ~/$(cut -d"/" -f7-99 <<< "$PWD")/."
			cd "$JDR"
	done
}
if [[ -z "${AMKFS[@]:-}" ]] # is undefined
then # no files found
	printf "%s\\n" "No CMakeLists.txt files were found; Continuing..."
else # call cmake and make
	_DOMAKES_
fi
# doso.bash EOF
