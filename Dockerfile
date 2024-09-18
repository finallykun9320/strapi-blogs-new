FROM node:18
# Installing libvips-dev for sharp Compatibility
RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev nasm bash vips-dev git

# ARG NODE_ENV=development
ENV NODE_ENV=development

WORKDIR /opt/app
RUN mkdir -p /opt/app/public/uploads

# Copy package.json and install dependencies
COPY package.json ./
COPY package-lock.json ./
RUN npm install -g node-gyp
RUN npm config set fetch-retry-maxtimeout 600000 -g && npm install

# Set PATH to include node_modules binaries
ENV PATH /opt/app/node_modules/.bin:$PATH

# Copy all files and set permissions
COPY . /opt/app
RUN chown -R node:node /opt/app

# Use non-root user
USER node

# Build the application
RUN ["npm", "run", "build"]

# Expose the port and start the application
EXPOSE 1337
CMD ["npm", "run", "develop"]
