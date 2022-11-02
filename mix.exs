defmodule TempSensor.MixProject do
  use Mix.Project

  @app :temp_sensor
  @version "0.2.0"
  @all_targets [:rpi0, :rpi3a]

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.13",
      archives: [nerves_bootstrap: "~> 1.10"],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host, "phx.server": :host],
      dialyzer: dialyzer()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {TempSensor.Application, []},
      extra_applications: [:logger, :runtime_tools, :inets, :ex_unit]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nerves, "~> 1.9", runtime: false},
      {:shoehorn, "~> 0.9"},
      {:toolshed, "~> 0.2"},
      {:ring_logger, "~> 0.8"},
      {:logger_file_backend, "~> 0.0.12"},
      {:jason, "~>1.2"},
      {:nerves_runtime, "~> 0.13"},
      {:livebook, "~> 0.7"},
      {:plug, "~>  1.12"},
      {:vintage_net, "~> 0.12"},

      # Libraries
      {:input_event, "~> 1.0 or ~> 0.4", targets: @all_targets},
      {:kino, "~> 0.7"},
      {:kino_maplibre, "~> 0.1.0"},
      {:kino_vega_lite, "~> 0.1.1"},
      {:maplibre, "~> 0.1.0"},
      {:nerves_pack, "~> 0.7.0", targets: @all_targets},
      {:nerves_time_zones, "~> 0.2", targets: @all_targets},
      {:phoenix_pubsub, "~> 2.0"},
      {:ramoops_logger, "~> 0.1", targets: @all_targets},
      {:req, "~> 0.3.0"},
      {:vega_lite, "~> 0.1"},
      # {:busybox, "~> 0.1.5", targets: @all_targets},

      # Nerves system dependencies
      {:nerves_system_rpi0, "~> 1.18", runtime: false, targets: :rpi0},
      {:nerves_system_rpi3a, "~> 1.18", runtime: false, targets: :rpi3a},

      # Compile-time only
      {:credo, "~> 1.6", only: :dev, runtime: false},
      {:dialyxir, "~> 1.2.0", only: :dev, runtime: false}
    ]
  end

  def release do
    [
      overwrite: true,
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: [keep: ["Docs"]]
    ]
  end

  defp dialyzer() do
    [
      flags: [:missing_return, :extra_return, :unmatched_returns, :error_handling, :underspecs],
      ignore_warnings: ".dialyzer_ignore.exs"
    ]
  end
end
