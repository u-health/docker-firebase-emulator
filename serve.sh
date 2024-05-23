#!/bin/bash
set -eo pipefail

# Function to print error messages and exit
error_exit() {
    echo "$1" 1>&2
    exit 1
}

# Sanity checks
[[ -z "${DATA_DIRECTORY}" ]] && echo "DATA_DIRECTORY environment variable missing, will not import data to firebase"
[[ -n "${DATA_EXPORT}" ]] && [[ -z "${DATA_DIRECTORY}" ]] && echo "DATA_EXPORT environment variable is set, but DATA_DIRECTORY is missing, will not export data on exit"

# Start Firebase emulators
emulator_cmd="firebase emulators:start"
[[ -n "${DATA_DIRECTORY}" ]] && emulator_cmd+=" --import=./${DATA_DIRECTORY}/export"
[[ -n "${DATA_EXPORT}" ]] && emulator_cmd+=" --export-on-exit"
$emulator_cmd &
firebase_pid=$!

cleanup() {
    echo "Stopping services..."
    # Gracefully stop background processes
    echo "Terminating background services..."
    if [[ -n "$firebase_pid" ]]; then
        kill -SIGTERM "$firebase_pid" || echo "Failed to terminate Firebase process"
        wait "$firebase_pid" 2>/dev/null
    fi
}

trap cleanup INT TERM SIGTERM SIGINT

wait
