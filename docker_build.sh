#!/bin/bash

dvd_path="/Software/benchmarks/spec/cpu2006"
if [ -d "$dvd_path" ]; then
    cp -r "$dvd_path" cpu2006_dvd
    docker build -t hotsniper .
    rm -rf cpu2006_dvd
else
    echo "$dvd_path does not exist!"
fi
