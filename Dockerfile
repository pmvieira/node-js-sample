FROM ubuntu
#Packages update
RUN apt-get update

# Install curl
RUN apt-get install -y curl

# Download NPM
RUN curl -sL https://deb.nodesource.com/setup | sudo bash -
# Install NPM
RUN apt-get install -y nodejs

# Copy the source code to the container
COPY . /src
# Install NPM dependencies
RUN cd /src; npm install

# Expose a port
Expose 5000

# What to run when the app starts
CMD ["node", "/src/index.js"]