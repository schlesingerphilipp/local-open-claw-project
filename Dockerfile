FROM ghcr.io/openclaw/openclaw:latest
USER root
RUN mkdir -p /var/lib/apt/lists/partial && \
    apt clean && \
    apt update
RUN apt install nodejs npm -y
RUN apt install docker.io docker-compose -y
RUN npm i -g opencode-ai
USER node