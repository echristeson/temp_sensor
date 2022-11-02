# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
import Config

Application.start(:nerves_bootstrap)

config :temp_sensor, target: Mix.target()

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.

config :nerves, :firmware,
  rootfs_overlay: "rootfs_overlay",
  provisioning: "config/provisioning.conf",
  fwup_conf: "config/#{Mix.target()}/fwup.conf"

config :nerves, source_date_epoch: "1585625975"

config :phoenix, :json_library, Jason

config :mime, :types, %{
  "text/plain" => ["livemd"]
}

config :livebook, :storage, Livebook.Storage.Ets

config :livebook, LivebookWeb.Endpoint,
  pubsub_server: Livebook.PubSub,
  live_view: [signing_salt: "livebook"]

# Enable the embedded runtime which isn't available by default
config :livebook,
  default_runtime: {Livebook.Runtime.Embedded, []},
  authentication_mode: :password,
  token_authentication: false,
  password: System.get_env("LIVEBOOK_PASSWORD", "nerves"),
  cookie: :nerves_livebook_cookie

  config :livebook, LivebookWeb.Endpoint,
    url: [host: "nerves.local"],
    http: [
      port: "80",
      transport_options: [socket_opts: [:inet6]]
    ],
    code_reloader: false,
    server: true,
    secret_key_base: ""


if Mix.target() == :host do
  import_config "host.exs"
else
  import_config "target.exs"
end
