FROM mhart/alpine-node:14.16.1

# backend
RUN mkdir -p /app/backend
WORKDIR /app/backend
COPY package.json yarn.lock /app/backend/
RUN yarn install

# frontend
WORKDIR /app
COPY package.json yarn.lock /app/
RUN yarn install

COPY . .
# k8s will refer to mongo as db
RUN sed -i'' -e 's/127.0.0.1/104.148.245.241/' .env

ENTRYPOINT /app/entrypoint.sh