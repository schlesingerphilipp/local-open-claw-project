FROM mcr.microsoft.com/devcontainers/python:3.14
WORKDIR /home/vscode/workspace

# opencode
RUN sudo apt update
RUN sudo apt install nodejs npm -y
RUN sudo apt install docker-cli docker-compose -y
RUN npm i -g opencode-ai
RUN sudo apt-get install -y curl unzip xdg-utils fonts-noto-cjk libxshmfence-dev
RUN npx --yes playwright install-deps chromium
RUN npm install -D @playwright/test typescript