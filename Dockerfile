FROM google/cloud-sdk
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN apt-get update && apt-get install -y \
    -q --no-install-recommends \
    git \
    ssh \
    apt-utils \
    curl \
    php-cli \
    php-mbstring \
    unzip \
    vim \
    sudo \
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


RUN useradd -u 1000 -r -g root -m -d /gclouduser -s /sbin/nologin -c "App user" gclouduser && \
    chmod 755 /gclouduser && \
    chown -R gclouduser:root /opt && \ 
    chown -R gclouduser:root /etc && \
    chown -R gclouduser:root /var/lib 

COPY ./credentials/firebasekey.json /gclouduser/firebasekey.json
RUN chmod 750 /gclouduser/firebasekey.json

USER gclouduser

RUN cd ~ && composer require google/cloud \
    && gcloud auth activate-service-account --key-file=/gclouduser/firebasekey.json \
    && gcloud config set project piota-slack-bot

RUN git config --global credential.'https://source.developers.google.com'.helper gcloud.sh