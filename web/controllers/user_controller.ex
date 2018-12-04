defmodule Rumbl.UserController do
    use Rumbl.Web, :controller
    require Logger

    def index(conn, _params) do
        users = Repo.all(Rumbl.User)

        render conn, "index.html", users: users
    end

    def show(conn, %{"id" => id}) do
        Logger.debug fn -> inspect(id) end

        user = Repo.get(Rumbl.User, id)
        Logger.debug fn -> inspect(user) end

        render conn, "show.html", user: user
    end
end