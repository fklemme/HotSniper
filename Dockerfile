FROM ubuntu:16.04
ARG DEBIAN_FRONTEND=noninteractive

# Install old GCC version and set up links
RUN apt-get update && apt-get install -y g++ g++-4.8 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 100 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 100

# Install Sniper
RUN apt-get update && apt-get install -y \
    git wget make python \
    zlib1g-dev libbz2-dev libboost-dev libsqlite3-dev
RUN git clone https://github.com/anujpathania/HotSniper.git
WORKDIR /HotSniper/HotSniper
# From https://software.intel.com/en-us/articles/pin-a-binary-instrumentation-tool-downloads
RUN wget https://software.intel.com/sites/landingpage/pintool/downloads/pin-2.14-71313-gcc.4.4.7-linux.tar.gz
RUN tar -xf pin-2.14-71313-gcc.4.4.7-linux.tar.gz && \
    mv pin-2.14-71313-gcc.4.4.7-linux pin_kit && \
    rm pin-2.14-71313-gcc.4.4.7-linux.tar.gz
RUN make -j 8

# Install PARSEC (and other) Benchmark
RUN apt-get update && apt-get install -y \
    gfortran m4 xsltproc libx11-dev libxext-dev libxt-dev libxmu-dev libxi-dev \
    pkg-config gettext
RUN tar -xf benchmarks.tar.gz
WORKDIR /HotSniper/HotSniper/benchmarks
RUN make -j 8
# Install Hotspot
WORKDIR /HotSniper/HotSniper/hotspot
RUN make -j 8

# Test PARSEC Multi-Program Execution Simulation
WORKDIR /HotSniper/HotSniper/benchmarks
CMD ./run-sniper -n 64 -c gainestown --benchmarks=parsec-blackscholes-test-1,parsec-bodytrack-test-1 --no-roi --sim-end=last
