defmodule ChatgptDemo.Repo do
  use Ecto.Repo,
    otp_app: :chatgpt_demo,
    adapter: Ecto.Adapters.SQLite3
end
