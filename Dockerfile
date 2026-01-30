FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y proot bash curl tar coreutils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -d /home/container container
USER container
ENV HOME=/home/container
WORKDIR /home/container


CMD ["/bin/bash", "/entrypoint.sh"]
