defmodule Rumbl.UserController do
  alias Rumbl.User
  use Rumbl.Web, :controller
  plug(:authenticate when action in [:index, :show])
  require Logger

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "#{user.name} created")
        |> redirect(to: user_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
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

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to acess that page")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end
end
