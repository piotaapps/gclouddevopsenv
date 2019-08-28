FROM piotaapps/gcloudnode:latest

RUN useradd -u 1000 -r -g root -m -d /home/gclouduser -s /sbin/nologin -c "gcloud user" gclouduser && \
    chmod 755 /home/gclouduser && \
    chown -R gclouduser:root /opt && \ 
    chown -R gclouduser:root /etc && \
    chown -R gclouduser:root /var/lib 

COPY ./credentials/firebasekey.json /home/gclouduser/firebasekey.json
RUN chmod 750 /home/gclouduser/firebasekey.json

RUN mkdir /source && chown -R gclouduser:root /source

# add any source code here, this folder's contents are excluded from git
VOLUME ["/source"]
ADD ./source /source

USER gclouduser

# Install nvm with node and npm
RUN mkdir /home/gclouduser/nvm 
ENV NVM_DIR /home/gclouduser/nvm
ENV NODE_VERSION v8.10.0
ENV CLOUDSDK_CORE_PROJECT piota-container-apps
ENV NODE_PATH $NVM_DIR/$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/$NODE_VERSION/bin:$PATH

RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash \
    && chmod +x $NVM_DIR/nvm.sh \
    && touch ~/.bash_profile \
    && . $NVM_DIR/nvm.sh \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && npm install npm@latest casperjs @google-cloud/functions-emulator -g

RUN cd ~ && composer require google/cloud \
    && gcloud auth activate-service-account --key-file=/home/gclouduser/firebasekey.json \
    && gcloud config set project piota-container-apps

RUN git config --global credential.'https://source.developers.google.com'.helper gcloud.sh