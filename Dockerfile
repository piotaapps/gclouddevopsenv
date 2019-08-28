FROM piotaapps/gcloudnode:latest

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION v8.10.0
ENV NODE_PATH $NVM_DIR/$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/$NODE_VERSION/bin:$PATH

RUN touch ~/.bash_profile \
    && . $NVM_DIR/nvm.sh \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && npm install npm@latest casperjs @google-cloud/functions-emulator -g

RUN useradd -u 1000 -r -g root -m -d /gclouduser -s /sbin/nologin -c "gcloud user" gclouduser && \
    chmod 755 /gclouduser && \
    chown -R gclouduser:root /opt && \ 
    chown -R gclouduser:root /etc && \
    chown -R gclouduser:root /var/lib 

COPY ./credentials/firebasekey.json /gclouduser/firebasekey.json
RUN chmod 750 /gclouduser/firebasekey.json

RUN mkdir /source && chown -R gclouduser:root /source

USER gclouduser

RUN cd ~ && composer require google/cloud \
    && gcloud auth activate-service-account --key-file=/gclouduser/firebasekey.json \
    && gcloud config set project piota-container-apps

RUN git config --global credential.'https://source.developers.google.com'.helper gcloud.sh