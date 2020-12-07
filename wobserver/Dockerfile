ARG ELIXIR_VERSION=1.11.2
ARG ERLANG_VERSION=23.0.4
ARG ALPINE_VERSION=3.12.0
ARG NODE_VERSION=14.4.0

# Fetch elixir deps
FROM hexpm/elixir:${ELIXIR_VERSION}-erlang-${ERLANG_VERSION}-alpine-${ALPINE_VERSION} as deps

ENV MIX_ENV=prod

RUN apk --no-cache add make gcc musl-dev git
RUN mix local.hex --force && mix local.rebar --force
RUN mkdir /build
ADD ./upstream /build
WORKDIR /build

RUN mix deps.clean --all && mix deps.get --only prod

# Build web assets
FROM node:${NODE_VERSION} as assets
WORKDIR /build
ADD ./npm-shrinkwrap.json /build/npm-shrinkwrap.json
ADD ./upstream/gulpfile.js /build/gulpfile.js
ADD ./upstream/package.json /build/package.json
ADD ./upstream/src /build/src
COPY --from=deps /build/deps deps
RUN npm install && node_modules/.bin/gulp deploy

# Build elixir release
FROM hexpm/elixir:${ELIXIR_VERSION}-erlang-${ERLANG_VERSION}-alpine-${ALPINE_VERSION} as builder

ENV MIX_ENV=prod

RUN apk --no-cache add make gcc musl-dev git
RUN mix local.hex --force && mix local.rebar --force
RUN mkdir /build
ADD ./upstream /build

WORKDIR /build
ADD ./mix_tasks_assets.ex /build/lib/mix_tasks_assets.ex
ADD ./release.exs /build/config/release.exs
COPY --from=deps /build/deps deps
COPY --from=assets /build/assets assets
RUN mix assets && test -e ./lib/wobserver/assets.ex
RUN mix release

# Runtime container
FROM nerveshub/runtime:alpine-${ALPINE_VERSION}

ENV MIX_ENV=prod

EXPOSE 4001
WORKDIR /app

COPY --from=builder /build/_build/$MIX_ENV/rel/wobserver/ ./

CMD ["/app/bin/wobserver", "start"]
