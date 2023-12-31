defmodule Testapp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      TestappWeb.Telemetry,
      # Start the Ecto repository
      Testapp.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Testapp.PubSub},
      # Start Finch
      {Finch, name: Testapp.Finch},
      # Start the Endpoint (http/https)
      TestappWeb.Endpoint
      # Start a worker by calling: Testapp.Worker.start_link(arg)
      # {Testapp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Testapp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TestappWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
