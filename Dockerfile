FROM --platform=$TARGETPLATFORM debian:11.11-slim

MAINTAINER chishin <pro@xxgzs.org>

ARG TARGETPLATFORM
ARG ARM_TOOLCHAIN_PATH=gcc-arm-none-eabi
ARG ARM_VERSION=13.3.rel1
ARG TOOLS_PATH=/tools

# Configure the target platform env: ARM_ARCH
ENV ARM_ARCH=${TARGETPLATFORM:-linux/amd64} \
    ARM_ARCH=${ARM_ARCH#linux/}

# Install basic programs
RUN echo "ARM_ARCH = $ARM_ARCH" && echo "TARGETPLATFORM = $TARGETPLATFORM" && \
    apt-get update && \
    apt-get install -y  wget curl make cmake xz-utils && \
    mkdir ${TOOLS_PATH}

# Set working directory
WORKDIR ${TOOLS_PATH}

# Install Arm GNU Toolchain
# https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads
RUN mkdir ${ARM_TOOLCHAIN_PATH} && \
    curl -L -o gcc-arm.tar.xz "https://developer.arm.com/-/media/Files/downloads/gnu/${ARM_VERSION}/binrel/arm-gnu-toolchain-${ARM_VERSION}-${ARM_ARCH}-arm-none-eabi.tar.xz" && \
    tar -xvf gcc-arm.tar.xz --strip-components=1 -C ${ARM_TOOLCHAIN_PATH} && \
    rm gcc-arm.tar.xz

ENV PATH="${TOOLS_PATH}/${ARM_TOOLCHAIN_PATH}/bin:${PATH}"

# Change working directory
WORKDIR /code

CMD make -v && arm-none-eabi-gcc -v
