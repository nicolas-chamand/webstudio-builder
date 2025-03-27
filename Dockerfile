FROM node:23.10.0-alpine3.21

# ENV DEPLOYMENT_ENVIRONMENT=production
# ENV DEPLOYMENT_URL=

WORKDIR /app

COPY ./app /app

RUN apk add openssl

RUN npm install -g corepack@latest --force \
  && corepack enable \
  && corepack --version \
  && corepack prepare pnpm@9.14.4 --activate

RUN pnpm install && pnpm build

CMD sh -c "pnpm migrations migrate && pnpm dev"
