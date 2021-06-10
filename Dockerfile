FROM ubuntu:18.04
RUN apt-get update
RUN apt -y install build-essential curl

# INSTALL node 14.x
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN echo " \n\
  deb https://deb.nodesource.com/node_14.x focal main \n\
  deb-src https://deb.nodesource.com/node_14.x focal main \n\
  " >> /etc/apt/sources.list.d/nodesource.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1655A0AB68576280
RUN apt -y install nodejs

# INSTALL yarn
RUN apt -y install gcc g++ make
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get -y update && apt-get -y install yarn

# INSTALL mongo client
RUN echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" \
  | tee /etc/apt/sources.list.d/mongodb-org-4.0.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 68818C72E52529D4
RUN apt update && apt install -y mongodb-org-shell

# Backend API
RUN mkdir -p /app/backend
WORKDIR /app/backend
COPY package.json yarn.lock /app/backend/
RUN yarn install

# Frontend app
WORKDIR /app
COPY package.json yarn.lock /app/
RUN yarn install

COPY . .
# k8s manifest will refer to mongo-db as db
#RUN sed -i'' -e 's/127.0.0.1/mongodb/' .env

ENTRYPOINT /app/entrypoint.sh