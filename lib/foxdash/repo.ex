defmodule Foxdash.Repo do
  use Ecto.Repo,
    otp_app: :foxdash,
    adapter: Ecto.Adapters.Postgres
end
