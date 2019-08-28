# Introduction

This project provides an Ubuntu based development environment for Google Firebase and Google Cloud based development. See <https://hub.docker.com/r/google/cloud-sdk/>

# Steps

1. install gcloud tools on your desktop / docker host system.  See <https://cloud.google.com/sdk/gcloud/> if you need to set these tools up.

1. run the following to create a service account file:

`gcloud iam service-accounts keys create ./credentials/firebasekey.json --iam-account ACCOUNTEMAIL` where `ACCOUNTEMAIL` is one of;

firebase-adminsdk-uba9w@piota-slack-bot.iam.gserviceaccount.com OR
firebase-adminsdk-g4n7d@piota-container-apps.iam.gserviceaccount.com

1. build the `piotaapps/gcloudnode` image from the `piotaapps/gcloudnode` project.


1. run `docker-compose up --build`

# Building for Kubernetes (experimental)

1. run `kompose convert` to generate the kubernets yaml files. This should create three files;

* gclouddevops-claim0-persistentvolumeclaim.yaml
* gclouddevops-deployment.yaml
* gclouddevops-service.yaml

1. if _creating_ a new cluster run `kubectl create --filename=gclouddevops-claim0-persistentvolumeclaim.yaml,gclouddevops-service.yaml, gclouddevops-service.yaml --record=true`

1. if updating an existing cluster, replace _create_ with _apply_
