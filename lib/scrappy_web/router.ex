defmodule ScrappyWeb.Router do
  use ScrappyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ScrappyWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", ScrappyWeb do
    pipe_through :api

    get "/getSavedProducts", PageController, :get_products
    post "/searchProduct/:asin", PageController, :search_product_by_asin
  end
end
