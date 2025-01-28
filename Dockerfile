# Base image for Node.js and Typst
FROM node:18-alpine AS node
FROM ghcr.io/typst/typst:latest

# Copy Node.js installation
COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin

# Install necessary tools
RUN apk add --no-cache fontconfig wget unzip

# Download and install Latin Modern fonts
RUN wget https://www.gust.org.pl/projects/e-foundry/latin-modern/download/lm2.004otf.zip && \
    mkdir -p /usr/share/fonts/lmodern && \
    unzip lm2.004otf.zip -d /usr/share/fonts/lmodern && \
    rm lm2.004otf.zip && \
    fc-cache -fv

# Set environment variables
ENV XDG_DATA_HOME=/root/.local/share

WORKDIR /root/

# Copy project files
COPY package*.json /root/
COPY tsconfig.json /root/
COPY src /root/src
COPY packages ${XDG_DATA_HOME}/typst/packages

# Install dependencies and build the project
RUN npm install -g typescript
RUN npm install
RUN npm run build

# Set the entry point
ENTRYPOINT [ "node", "/root/index.js" ]