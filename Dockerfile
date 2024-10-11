FROM alpine:3.20

MAINTAINER chishin <pro@xxgzs.org>

ARG ARM_TOOLCHAIN_PATH=gcc-arm-none-eabi
ARG ARM_VERSION=13.3.rel1
ARG ARM_ARCH=x86_64
ARG TOOLS_PATH=/tools
RUN mkdir ${TOOLS_PATH}
WORKDIR ${TOOLS_PATH}

# Install basic programs and custom glibc
ARG GLIBC_VERSION=2.35-r1
ARG GLIBC_APK_NAME=glibc-${GLIBC_VERSION}.apk 
ARG GLIBC_APK_DOWNLOAD_URL=https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/${GLIBC_APK_NAME}
RUN apk --no-cache add ca-certificates wget curl make cmake stlink \
	&& wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
	&& wget ${GLIBC_APK_DOWNLOAD_URL} \
	&& apk add ${GLIBC_APK_NAME} \
	&& rm ${GLIBC_APK_NAME}

# Install Arm GNU Toolchain
# https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads
RUN mkdir ${ARM_TOOLCHAIN_PATH}
RUN curl -L -o gcc-arm.tar.xz "https://developer.arm.com/-/media/Files/downloads/gnu/${ARM_VERSION}/binrel/arm-gnu-toolchain-${ARM_VERSION}-${ARM_ARCH}-arm-none-eabi.tar.xz"
RUN tar xf gcc-arm.tar.xz --strip-components=1 -C ${ARM_TOOLCHAIN_PATH}
RUN rm gcc-arm.tar.xz

ENV PATH="${ARM_TOOLCHAIN_PATH}/bin:${PATH}"

# Change workdir
WORKDIR /build
