ARG ELIXIR_VERSION=1.11.2
ARG ERLANG_VERSION=23.0.4
ARG ALPINE_VERSION=3.12.0

# Builder container
FROM hexpm/elixir:${ELIXIR_VERSION}-erlang-${ERLANG_VERSION}-alpine-${ALPINE_VERSION} as builder

ENV MIX_ENV=prod

RUN apk --no-cache add make gcc musl-dev git
RUN mix local.hex --force && mix local.rebar --force
RUN mkdir /build
ADD ./src /build
WORKDIR /build

RUN mix deps.clean --all && mix deps.get --only prod
RUN mix release device_service --overwrite

# Release container
FROM nerveshub/runtime:alpine-${ALPINE_VERSION}

ENV MIX_ENV=prod

EXPOSE 80
WORKDIR /app

COPY --from=builder /build/_build/$MIX_ENV/rel/device_service/ ./

CMD ["/app/bin/device_service", "start"]
