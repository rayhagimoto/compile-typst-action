# Typst Docker Image
# FROM ghcr.io/typst/typst:latest
FROM node:14

# Copying necessary files
COPY package*.json ./
COPY tsconfig.json ./ 
COPY src ./src 

# # Installing Nodejs
# RUN sudo apt-get update 
# RUN sudo apt-get -y install curl gnupg
# RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
# RUN sudo apt-get -y install nodejs 

RUN apk add typst

# Compiling typescript
RUN npm install
RUN npm install -g typescript

RUN npm run build

RUN ["chmod", "+x", "dist/index.js"]
RUN ls 
RUN cd dist && ls
ENTRYPOINT [ "node", "/dist/index.js" ]