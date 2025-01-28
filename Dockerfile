
FROM node:18-alpine AS node
# Typst Docker Image
FROM ghcr.io/typst/typst:latest

# Copying NodeJS installation
COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin

# Set environment variables
ENV XDG_DATA_HOME=/root/.local/share

WORKDIR /root/

# Copying necessary files
COPY package*.json /root/
COPY tsconfig.json /root/
COPY src /root/src 
COPY packages ${XDG_DATA_HOME}/packages

# Compiling typescript
RUN npm install -g typescript
RUN npm install

RUN npm run build

ENTRYPOINT [ "node", "/root/dist/index.js" ]

