defmodule FoxdashWeb.PageController do
  use FoxdashWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def hello(conn, _params) do
    html(conn, "Hello, World!")
  end
end
