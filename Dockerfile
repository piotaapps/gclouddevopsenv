FROM google/cloud-sdk
RUN apt-get update && apt-get install -y \
    -q --no-install-recommends \
    git \
    ssh \
    apt-utils \
    curl \
    vim \
    build-essential \
    libssl-dev \
    phantomjs \
&& rm -rf /var/lib/apt/lists/*

# nvm
RUN mkdir /usr/local/nvm 
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION v8.10.0

# Install nvm with node and npm
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash \
    && chmod +x $NVM_DIR/nvm.sh \
    && touch ~/.bash_profile \
    && . $NVM_DIR/nvm.sh \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && npm install casperjs -g

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/v$NODE_VERSION/bin:$PATH