defmodule ChatgptDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ChatgptDemoWeb.Telemetry,
      # Start the Ecto repository
      ChatgptDemo.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: ChatgptDemo.PubSub},
      # Start Finch
      {Finch, name: ChatgptDemo.Finch},
      # Start the Endpoint (http/https)
      ChatgptDemoWeb.Endpoint
      # Start a worker by calling: ChatgptDemo.Worker.start_link(arg)
      # {ChatgptDemo.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ChatgptDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ChatgptDemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
