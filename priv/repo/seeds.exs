# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Testapp.Repo.insert!(%Testapp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Testapp.Accounts
alias Testapp.Chats

{:ok, user_1} =
  Accounts.register_user(%{
    email: "test@test.com",
    password: "test@test.com"
  })

{:ok, room} = Chats.create_room(%{name: "random"})

Enum.map(100..1, fn i ->
  Process.sleep(1000)

  Chats.create_message(%{
    data: "#{i} message",
    user_id: user_1.id,
    room_id: room.id
  })
end)
