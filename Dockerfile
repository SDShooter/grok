FROM ubuntu:26.04
WORKDIR /work
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Ensure cargo and rustup are in the PATH
ENV PATH="/root/.grok/bin:/usr/local/bin:/root/.cargo/bin:${PATH}"

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

#INSTALL RUST AND SETUP MUSL TARGET
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
RUN rustup target add x86_64-unknown-linux-musl

# NodeSource setup_24.x provides the nodejs package (node and npm).
RUN apt-get update \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*
RUN node -v
RUN npm -v
RUN npm install selenium-webdriver chromdriver gechodriver


COPY ./test/chrome.js /work/test/chrome.js
COPY ./test/chrome-mocha.js /work/test/chrome-mocha.js

RUN node /work/test/chrome.js

ENTRYPOINT ["grok", "--yolo"]
#ENTRYPOINT ["bash"]