import Config

# Use shoehorn to start the main application. See the shoehorn
# docs for separating out critical OTP applications such as those
# involved with firmware updates.

config :shoehorn,
  init: [:nerves_runtime, :nerves_pack],
  app: Mix.Project.config()[:app]

config :logger,
  backends: [
    {LoggerFileBackend, :info_log},
    {LoggerFileBackend, :error_log},
    RingLogger,
    RamoopsLogger
  ],
  level: :info

config :logger, :info_log,
  path: "/root/info.log",
  level: :info

config :logger, :error_log,
  path: "/root/error.log",
  level: :error

config :nerves, :erlinit, shutdown_report: "/data/last_shutdown.txt"

config :nerves_runtime, :kernel, use_system_registry: false

config :nerves, :erlinit, shutdown_report: "/data/last_shutdown.txt"

config :nerves, rpi_v2_ack: true

keys =
  [
    Path.join([System.user_home!(), ".ssh", "id_rsa.pub"]),
    Path.join([System.user_home!(), ".ssh", "id_nerves_ecdsa.pub"])
  ]
  |> Enum.filter(&File.exists?/1)

if keys == [],
  do:
    Mix.raise("""
    No SSH public keys found in ~/.ssh. An ssh authorized key is needed to
    log into the Nerves device and update firmware on it using ssh.
    See your project's config.exs for this error message.
    """)

config :nerves_ssh,
  authorized_keys: Enum.map(keys, &File.read!/1)

config :vintage_net,
  regulatory_domain: "US",
  config: [
    {"usb0", %{type: VintageNetDirect}},
    {"wlan0", %{type: VintageNetWifi}}
  ],
  additional_name_servers: [{127, 0, 0, 53}]

config :mdns_lite,
  instance_name: "Nerves",
  dns_bridge_enabled: true,
  dns_bridge_port: 53,
  dns_bridge_recursive: false,
  hosts: [:hostname, "temp_sensor"],
  ttl: 120,
  services: [
    %{
      name: "SSH Remote Login Protocol",
      protocol: "ssh",
      transport: "tcp",
      port: 22
    },
    %{protocol: "sftp-ssh", transport: "tcp", port: 22},
    %{
      name: "Web Server",
      protocol: "http",
      transport: "tcp",
      port: 80
    },
    %{
      name: "Erlang Port Mapper Daemon",
      protocol: "epmd",
      transport: "tcp",
      port: 4369
    }
  ]
