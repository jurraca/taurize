defmodule Testproject.Repo do
  use Ecto.Repo,
    otp_app: :testproject,
    adapter: Ecto.Adapters.Postgres
end
