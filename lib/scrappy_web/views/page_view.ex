defmodule ScrappyWeb.PageView do
  use ScrappyWeb, :view

  def render("res.json", %{res: res}) do
    res
  end
end
