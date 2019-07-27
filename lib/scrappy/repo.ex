defmodule Scrappy.Repo do
  use Ecto.Repo,
    otp_app: :scrappy,
    adapter: Ecto.Adapters.Postgres

  import Ecto.Query
  alias Scrappy.{Product, Repo}

  def get_all_products() do
    Repo.all(
      from p in Product,
        select: %{asin: p.asin, category: p.category, dimensions: p.dimensions, rank: p.rank}
    )
  end

  def get_product(asin) do
    Repo.one(
      from p in Product,
        select: %{asin: p.asin, category: p.category, dimensions: p.dimensions, rank: p.rank},
        where: p.asin == ^asin
    )
  end
end
