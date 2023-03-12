defmodule ChatgptDemoWeb.ChatLive do
  use ChatgptDemoWeb, :live_view
  alias ChatgptDemo.Repo
  alias ChatgptDemo.Chat.Message

  def mount(_sesstion, _params, socket) do
    messages = Repo.all(Message)

    socket =
      socket
      |> assign(:form, to_form(%{}))
      |> stream(:messages, messages)

    {:ok, socket}
  end

  def handle_event("submit", %{"content" => content}, socket) do
    case insert_message(%{role: :user, content: content}) do
      {:ok, message} ->
        {:noreply, stream_insert(socket, :messages, message)}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  def handle_event("reset", _params, socket) do
    Repo.delete_all(Message)
    {:noreply, push_navigate(socket, to: "/chat")}
  end

  defp insert_message(params) do
    %Message{}
    |> Message.changeset(params)
    |> Repo.insert()
  end
end
