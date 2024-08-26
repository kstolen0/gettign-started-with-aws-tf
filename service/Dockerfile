FROM node:18-alpine3.16 AS base
FROM base AS build
WORKDIR /build

COPY package*.json ./
RUN npm ci

COPY main.js .
COPY public ./public

FROM base AS run
WORKDIR /app

COPY --from=build /build/node_modules ./node_modules
COPY --from=build /build/package.json .
COPY --from=build /build/main.js .
COPY --from=build /build/public ./public

CMD ["node", "main.js"]


