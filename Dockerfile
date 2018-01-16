FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install curl -y
RUN apt-get install unzip -y

WORKDIR /install

RUN curl -O https://releases.hashicorp.com/vault/0.9.1/vault_0.9.1_linux_amd64.zip
RUN unzip vault_0.9.1_linux_amd64.zip
RUN mv vault /usr/local/bin

COPY config.json /install/config.json
COPY gcloud-service-account-key.json /install/gcloud-service-account-key.json

EXPOSE 8200

CMD vault server -config=/install/config.json