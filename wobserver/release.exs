# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :wobserver,
  assets: "",
  mode: :standalone

case System.get_env("CONNECT_TO") do
  nil ->
    config :wobserver, discovery: :none

  host ->
    config :wobserver, discovery: :dns, discovery_search: host
end

IO.puts("wobserver listening on 0.0.0.0:4001")
