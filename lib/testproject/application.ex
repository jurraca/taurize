defmodule Testproject.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      TestprojectWeb.Telemetry,
      # Start the Ecto repository
     # Testproject.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Testproject.PubSub},
      # Start Finch
      {Finch, name: Testproject.Finch},
      # Start the Endpoint (http/https)
      TestprojectWeb.Endpoint
      # Start a worker by calling: Testproject.Worker.start_link(arg)
      # {Testproject.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Testproject.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TestprojectWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
