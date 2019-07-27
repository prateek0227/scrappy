defmodule Scrappy.Product do
  use Ecto.Schema
  alias Scrappy.Product
  import Ecto.Changeset

  @derive {Jason.Encoder, except: [:__meta__, :__struct__]}
  @primary_key false
  schema "products" do
    field :asin, :string, size: 10, primayr_key: true
    field :category, :string
    field :rank, :string
    field :dimensions, :string
  end

  def changeset(%Product{} = product, params \\ %{}) do
    product
    |> cast(params, [:asin, :category, :rank, :dimensions])
  end
end
