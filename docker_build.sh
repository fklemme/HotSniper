#!/bin/bash
set -e

# From https://stackoverflow.com/a/246128/4548698
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$script_dir"

dvd_path="/Software/benchmarks/spec/cpu2006/"
if [ -d "$dvd_path" ]; then
    rsync -r "$dvd_path" cpu2006_dvd
    docker build -t hotsniper .
else
    echo "$dvd_path does not exist!"
fi
