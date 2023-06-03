defmodule ChatgptDemoWeb.ChatLive do
  use ChatgptDemoWeb, :live_view
  alias ChatgptDemo.Repo
  alias ChatgptDemo.Chat.Message
  require Logger

  def mount(_sesstion, _params, socket) do
    messages = Repo.all(Message)

    socket =
      socket
      |> assign(:form, to_form(%{}))
      |> assign(:submittable?, true)
      |> stream(:messages, messages)

    {:ok, socket}
  end

  def handle_event("submit", %{"content" => content}, socket) do
    case insert_message(%{role: :user, content: content}) do
      {:ok, message} ->
        send(self(), :chat_completion)

        socket =
          socket
          |> assign(:submittable?, false)
          |> stream_insert(:messages, message)

        {:noreply, socket}

      {:error, changeset} ->
        Logger.error(inspect(changeset))
        {:noreply, socket}
    end
  end

  def handle_event("reset", _params, socket) do
    Repo.delete_all(Message)
    {:noreply, push_navigate(socket, to: "/chat")}
  end

  def handle_info(:chat_completion, socket) do
    with(
      {:ok, chatgpt_reply} <- get_chatgpt_reply(),
      {:ok, message} <- insert_message(%{role: :assistant, content: chatgpt_reply})
    ) do
      socket =
        socket
        |> assign(:submittable?, true)
        |> stream_insert(:messages, message)

      {:noreply, socket}
    else
      err ->
        Logger.error(inspect(err))
        {:noreply, assign(socket, :submittable?, true)}
    end
  end

  defp insert_message(params) do
    %Message{}
    |> Message.changeset(params)
    |> Repo.insert()
  end

  defp get_chatgpt_reply() do
    messages =
      Message
      |> Repo.all()
      |> Enum.map(fn msg -> %{role: msg.role, content: msg.content} end)
      |> List.insert_at(0, init_chatgpt_prompt())

    case OpenAI.chat_completion(model: "gpt-3.5-turbo", messages: messages) do
      {:ok, res} ->
        Logger.debug(res)
        %{"message" => %{"content" => content}} = hd(res.choices)
        {:ok, content}

      err ->
        {:error, err}
    end
  end

  defp init_chatgpt_prompt() do
    %{
      role: :system,
      content: """
      あなたはお嬢様としてロールプレイを行います。お嬢様になりきってください。一人称は「わたくし」です。語尾に「ですわ」と付くことが多いです。
      """
    }
  end
end
