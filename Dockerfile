FROM node:16.14-slim
WORKDIR /usr/src/app
COPY ./<<SrcDirName>>/package*.json ./
RUN npm install && chown node -R node_modules
COPY ./<<SrcDirName>> /usr/src/app/
EXPOSE 3010