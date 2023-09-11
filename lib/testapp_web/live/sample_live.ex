defmodule TestappWeb.SampleLive do
  use TestappWeb, :live_view

  alias Testapp.Chats

  def mount(_parmas, _session, socket) do
    room = Chats.list_rooms() |> List.first()

    changeset =
      Chats.change_message(%{
        room_id: room.id,
        user_id: socket.assigns.current_user.id,
        data: ""
      })

    room = Chats.get_room(room.id)

    socket =
      socket
      |> assign(changeset: changeset)
      |> assign(room: room)
      |> assign(page: 1, per_page: 20)
      |> paginate_messages(1)
      |> assign(end_of_timeline?: false)

    {:ok, socket}
  end

  def handle_event("next-page", _, socket) do
    {:noreply, paginate_messages(socket, socket.assigns.page + 1)}
  end

  defp paginate_messages(socket, new_page) when new_page >= 1 do
    %{per_page: per_page, page: cur_page} = socket.assigns

    messages =
      Chats.list_messages(socket.assigns.room.id,
        offset: (new_page - 1) * per_page,
        limit: per_page
      )

    socket =
      if new_page >= cur_page do
        stream(socket, :messages, messages, at: 0, limit: 1000)
      end

    case messages do
      [] ->
        assign(socket, end_of_timeline?: true)

      [_ | _] ->
        socket
        |> assign(end_of_timeline?: false)
        |> assign(:page, new_page)
    end
  end

  def render(assigns) do
    ~H"""
    <%= if !(@end_of_timeline?)  do %>
      <button type="button" phx-click="next-page">Load more</button>
    <% end %>
    <div>
      <div id="messages" phx-update="stream" class="flex flex-col gap-4 pb-14 pl-12 mt-24">
        <div :for={{id, message} <- @streams.messages} id={"message#{id}"}>
          <div class="card bg-yellow-100 w-11/12">
            <%= raw(message.data) %>
            <%= message.inserted_at %>
            <%= message.user.email %>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
