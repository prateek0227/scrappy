# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :scrappy,
  ecto_repos: [Scrappy.Repo]

# Configures the endpoint
config :scrappy, ScrappyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "WW/mNtUt5YmDFxfO/e5ruOejr4P/mvYAV3nXvqWdQlDXLUfY6POhxvjgU5+Zlw4k",
  render_errors: [view: ScrappyWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Scrappy.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
