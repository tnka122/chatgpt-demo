defmodule ChatgptDemo.Chat.Message do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :content, :string
    field :role, Ecto.Enum, values: [:system, :user, :assistant]

    timestamps()
  end

  @doc false
  def changeset(message, attrs \\ %{}) do
    message
    |> cast(attrs, [:role, :content])
    |> validate_required([:role, :content])
    |> validate_inclusion(:role, [:system, :user, :assistant])
  end
end
