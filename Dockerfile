FROM ubuntu:26.04 AS builder
WORKDIR /work
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates libssl-dev build-essential python3-dev wget openssl curl bash  \
    && rm -rf /var/lib/apt/lists/* \
    && curl -O https://www.python.org/ftp/python/3.13.16/Python-3.13.16.tgz \
    && tar xzvf Python-3.13.16.tgz \
    && cd Python-3.13.16 \
    && ./configure \
    && make -s -j 4 \
    && cd .. \
    && rm ./Python-3.13.16.tgz


RUN curl -fsSL https://x.ai/cli/install.sh | bash

#SET UP NODE REPO IN APT
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash -
#INSTALL NSOLID
RUN apt-get install -y nsolid
RUN nsolid -v
RUN npm install selenium-webdriver

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable

ENTRYPOINT ["bash", "-c", "grok", "--yolo"]
#ENTRYPOINT ["bash"]