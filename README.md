## 概述

该项目基于 debian-slim 轻量级 docker 镜像构建，部署了Arm交叉编译相关的工具：
- arm-gnu-toolchain
- cmake
- make

## 使用方法

建议使用前先拉取镜像到本地，镜像拉取命令：
- [Docker Hub](https://hub.docker.com/r/chishin/arm-gnu-toolchain-docker)：`docker push chishin/arm-gnu-toolchain-docker`
- [Github Package](https://github.com/xiaoxinpro/arm-gnu-toolchain-docker/pkgs/container/arm-gnu-toolchain-docker): `docker pull ghcr.io/xiaoxinpro/arm-gnu-toolchain-docker`

### 1.docker直接运行

使用`docker run --rm --privileged -v $(pwd):/build chishin/arm-gnu-toolchain-docker ` 开头，后面添加`arm-none-eabi-xxx`或`make`或`cmake` 等命令

#### 示例：

获取arm-gnu-toolchain中GCC版本
```
docker run --rm --privileged -v $(pwd):/code chishin/arm-gnu-toolchain-docker arm-none-eabi-gcc -v
```

进入代码目录后，使用 make 编译代码：
```
docker run --rm --privileged -v $(pwd):/code chishin/arm-gnu-toolchain-docker make all
```

### 2.创建快捷命令运行

创建一个文件，文件名随意，这里以 `arm-gnu-toolchain` 为例。
```
vi arm-gnu-toolchain
```

在文件中添加以下内容：
```
#!/bin/bash
docker run --rm --privileged -v \$(pwd):/code chishin/arm-gnu-toolchain-docker "\$@"
```

保存文件后为文件添加执行权限
```
chmod ugo+x arm-gnu-toolchain
```

将文件移动到 `/usr/bin` 目录下
```
mv arm-gnu-toolchain /usr/bin/arm-gnu-toolchain
```

#### 使用方法

使用`arm-gnu-toolchain ` 开头，后面添加`arm-none-eabi-xxx`或`make`或`cmake`等命令

#### 示例：

获取arm-gnu-toolchain中GCC版本
```
arm-gnu-toolchain arm-none-eabi-gcc -v
```

进入代码目录后，使用 make 编译代码：
```
arm-gnu-toolchain make all
```

#### 卸载快捷命令
```
sudo rm -f /usr/bin/arm-gnu-toolchain
```
