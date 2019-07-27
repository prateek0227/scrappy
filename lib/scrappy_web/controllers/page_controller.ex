defmodule ScrappyWeb.PageController do
  use ScrappyWeb, :controller

  alias Scrappy.{Product, Repo}
  @rank_id "SalesRank"
  @rank_regex ~r/#(?<rank>[0-9]{1,3}(,[0-9]{3})*) in (?<category>.+) \(\)/

  def index(conn, _params) do
    render(conn, "app.html")
  end

  def get_products(conn, _params) do
    products = Repo.get_all_products()
    render(conn, "res.json", res: products)
  end

  def search_product_by_asin(conn, %{"asin" => asin}) do
    res =
      case Repo.get_product(asin) do
        nil -> fetch_details(asin)
        _ -> %{}
      end

    render(conn, "res.json", res: res)
  end

  defp fetch_details(asin) do
    case HTTPoison.get("https://www.amazon.com/dp/#{asin}") do
      {:ok, %HTTPoison.Response{status_code: 200, headers: headers, body: html}} ->
        params = get_params(asin, html, headers)

        {:ok, product} = Repo.insert(Product.changeset(%Product{}, params))
        product

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        %{error: "Invalid ASIN"}

      _err ->
        %{error: "Something went Wrong. Please Try Again"}
    end
  end

  defp get_params(asin, html, headers) do
    html = decode_html(headers, html)
    category = get_category(html)
    dimensions = get_dimensions(html)
    rank = get_rank(html)
    %{asin: asin, category: category, dimensions: dimensions, rank: rank}
  end

  # This is being done to decode the gzip encoded content returned by amazon
  defp decode_html(headers, html) do
    gzip? =
      Enum.any?(headers, fn {name, value} ->
        # Headers are case-insensitive so we compare their lower case form.
        :hackney_bstr.to_lower(name) == "content-encoding" &&
          :hackney_bstr.to_lower(value) == "gzip"
      end)

    if gzip?, do: :zlib.gunzip(html), else: html
  end

  defp get_category(html) do
    Floki.find(html, "a[class=\"a-link-normal a-color-tertiary\"]")
    |> Enum.map(fn {_, _, [text]} -> String.trim(text) end)
    |> Enum.join(" > ")
  end

  defp get_rank(html) do
    map =
      html
      |> Floki.find("##{@rank_id}")
      |> Floki.find("td.value")
      |> Floki.text(deep: false)
      |> String.trim()
      |> (&Regex.named_captures(@rank_regex, &1)).()

    case map do
      nil ->
        ""

      _ ->
        "##{map["rank"]} in #{map["category"]}"
    end
  end

  defp get_dimensions(html) do
    html
    |> Floki.find(".size-weight")
    |> Floki.find(".value")
    |> case do
      # if there is no size-weight class on the page then check for a-size-base
      [] -> Floki.find(html, "td.a-size-base")
      node -> node
    end
    |> Enum.filter(fn {_, _, list} ->
      hd(list) |> is_binary() && String.contains?(hd(list), "inches")
    end)
    |> Floki.text()
    |> String.trim()
  end
end
