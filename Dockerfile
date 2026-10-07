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

#SET UP NODE REPO IN APT - HERE SO WE UPDATE FIRST
# NodeSource setup_24.x provides the nodejs package (node and npm).
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash -

RUN apt-get update \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

#INSTALL Grok client
RUN curl -fsSL https://x.ai/cli/install.sh | bash

#INSTALL RUST AND SETUP MUSL TARGET
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
RUN rustup target add x86_64-unknown-linux-musl wasm32-unknown-unknown 
RUN cargo install wasm-bindgen-cli --version 0.2.129 --locked    

# INSTALL Selenium with browserdrivers and other node packages..Is there a confirmation somewhere?  A disallow?
RUN npm install selenium-webdriver chromedriver geckodriver

ENTRYPOINT ["grok", "--yolo"]
#ENTRYPOINT ["bash"]