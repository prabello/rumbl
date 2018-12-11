defmodule Rumbl.UserController do
  alias Rumbl.User
  use Rumbl.Web, :controller
  require Logger

  def create(conn, %{"user" => user_params}) do
    {:ok, user} =
      User.changeset(%User{}, user_params)
      |> Repo.insert()

    conn
    |> put_flash(:info, "#{user.name} created")
    |> redirect(to: user_path(conn, :index))
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def index(conn, _params) do
    users = Repo.all(User)

    render(conn, "index.html", users: users)
  end

  def show(conn, %{"id" => id}) do
    Logger.debug(fn -> inspect(id) end)

    user = Repo.get(User, id)
    Logger.debug(fn -> inspect(user) end)

    render(conn, "show.html", user: user)
  end
end
