defmodule Scrappy.Repo.Migrations.Products do
  use Ecto.Migration

  def change do
    create table("products", primary_key: false) do
      add :asin, :string, size: 10, primary_key: true
      add :category, :string
      add :rank, :string
      add :dimensions, :string
    end
  end
end
