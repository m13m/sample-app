defmodule Testapp.UserAuthLive do
  import Phoenix.Component
  alias Testapp.Accounts

  def on_mount(:user, _params, %{"user_token" => user_token} = _session, socket) do
    socket =
      socket
      |> assign(:current_user, Accounts.get_user_by_session_token(user_token))

    {:cont, socket}
  end
end
