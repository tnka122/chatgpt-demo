defmodule ChatgptDemo.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :role, :string, null: false
      add :content, :text, null: false

      timestamps()
    end
  end
end
