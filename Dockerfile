FROM crystallang/crystal:0.27.2

# Getting Depedencies
RUN apt-get update \
        && apt-get install -y git libc6-dev libevent-dev libpcre2-dev libpng-dev libssl-dev libyaml-dev zlib1g-dev curl wget
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN apt-get update && apt-get install -y yarn tmux

RUN set -ex \
        && wget -q https://github.com/DarthSim/overmind/releases/download/v2.0.0/overmind-v2.0.0-linux-amd64.gz \
        && gunzip overmind-v2.0.0-linux-amd64.gz \
        && chmod +x overmind-v2.0.0-linux-amd64 \
        && mv overmind-v2.0.0-linux-amd64 /usr/local/bin/overmind

# Cloning the Lucky repo and building Lucky
RUN set -ex \
        && git clone https://github.com/luckyframework/lucky_cli \
        && cd lucky_cli \
        && git checkout v0.12.0 \
        && shards install \
        && crystal build src/lucky.cr --release --no-debug \
        && mv lucky /usr/local/bin/lucky \
        && cd .. \
        && rm -r lucky_cli