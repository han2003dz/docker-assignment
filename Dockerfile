# Base stage
FROM node:18 AS base

RUN npm install -g pnpm

# All dependencies stage
FROM base AS all-deps

WORKDIR /app

COPY package*.json /app

RUN pnpm install

# Production dependencies stage
FROM base AS prod-deps

WORKDIR /app

COPY --from=all-deps /app/node_modules /app/node_modules

COPY . .

RUN pnpm run build

# Release stage
FROM base AS release

WORKDIR /app

COPY --from=prod-deps /app/build /app/build
COPY --from=prod-deps /app/node_modules /app/node_modules
COPY .env /app

ENV NODE_ENV=production

CMD [ "node", "bin/server.ts" ]


#docker build --tag node-docker .
# docker build (để build 1 source code thành 1 image)
# --tag đặt tên image = node-docker
#docker run -p port:port -d node-docker

