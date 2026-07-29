defmodule BeamMeDownTalk.SlidesWindow do
  @moduledoc """
  The whole talk, as one window. Assigns hold the slide list + current index;
  `render/1` just walks the current slide into a column of text nodes plus a
  prev/next nav row.

  Navigable two ways, on purpose — both end up calling the same
  `handle_event/3`, so on-stage clicking and a connected `mix rext.connect`
  session driving `next/0`/`prev/0` are indistinguishable to the window:

    * on-screen Prev / Next buttons
    * `BeamMeDownTalk.SlidesWindow.next/0` (or `.prev/0`, `.goto/1`) from a
      connected IEx session — the live "state lives on the BEAM" demo moment
  """

  use Rext.Window

  alias BeamMeDownTalk.Slides

  @impl true
  def mount(_params, socket) do
    slides = Slides.all()
    {:ok, socket |> Rext.Socket.assign(:slides, slides) |> Rext.Socket.assign(:index, 0)}
  end

  @impl true
  def render(assigns) do
    slide = Enum.at(assigns.slides, assigns.index)
    total = length(assigns.slides)

    extra =
      case assigns.index do
        0 -> [title_image_node()]
        1 -> [slide_image_node("axd301.png", 300)]
        2 -> [slide_image_node("dumb_glass.png", 600)]
        3 -> [slide_image_node("cant_handle_beam.png", 600)]
        4 -> [slide_image_node("wall_plug.png", 600)]
        5 -> [slide_image_node("compat_layer.png", 600)]
        6 -> [slide_image_node("bundled_browser.png", 600)]
        7 -> [slide_image_node("delivery.png", 600)]
        8 -> [slide_image_node("delivery.png", 600)]
        _ -> []
      end

    %{
      type: :column,
      props: %{gap: :space_lg, padding: :space_xl, background: :background},
      children: [title_node(slide)] ++ extra ++ bullet_nodes(slide) ++ [nav_row(assigns.index, total)]
    }
  end

  @impl true
  def handle_event("click", %{"tag" => "next"}, socket), do: {:noreply, step(socket, 1)}
  def handle_event("click", %{"tag" => "prev"}, socket), do: {:noreply, step(socket, -1)}

  def handle_event("goto", %{"index" => index}, socket) do
    total = length(socket.assigns.slides)
    clamped = index |> max(0) |> min(total - 1)
    {:noreply, Rext.Socket.assign(socket, :index, clamped)}
  end

  # ── Dist-drivable API — same dispatch/3 path as the on-screen buttons ──────

  @doc "Advance to the next slide. Callable live from a connected IEx session."
  @spec next() :: :ok
  def next, do: Rext.Window.dispatch(Rext.Window.via("main"), "click", %{"tag" => "next"})

  @doc "Go back to the previous slide."
  @spec prev() :: :ok
  def prev, do: Rext.Window.dispatch(Rext.Window.via("main"), "click", %{"tag" => "prev"})

  @doc "Jump straight to a 0-indexed slide — for cueing a specific demo beat."
  @spec goto(non_neg_integer()) :: :ok
  def goto(index), do: Rext.Window.dispatch(Rext.Window.via("main"), "goto", %{"index" => index})

  # ── Internals ───────────────────────────────────────────────────────────────

  defp step(socket, delta) do
    total = length(socket.assigns.slides)

    Rext.Socket.update(socket, :index, fn i ->
      i |> Kernel.+(delta) |> max(0) |> min(total - 1)
    end)
  end

  defp title_image_node do
    slide_image_node("title.png", 600)
  end

  defp slide_image_node(filename, width) do
    path = :code.priv_dir(:beam_me_down_talk) |> Path.join(filename) |> to_string()
    %{type: :image, props: %{src: path, width: width}, children: []}
  end

  defp title_node(%{title: title}) do
    %{type: :text, props: %{text: title, size: 40, color: :primary}, children: []}
  end

  defp bullet_nodes(%{bullets: bullets}) do
    Enum.map(bullets, fn bullet ->
      %{
        type: :text,
        props: %{text: "•  " <> bullet, size: 22, color: :on_background},
        children: []
      }
    end)
  end

  defp nav_row(index, total) do
    %{
      type: :row,
      props: %{gap: :space_md},
      children: [
        %{
          type: :button,
          props: %{label: "‹ Prev", on_click: :prev, color: :surface},
          children: []
        },
        %{
          type: :text,
          props: %{text: "#{index + 1} / #{total}", size: 14, color: :muted},
          children: []
        },
        %{
          type: :button,
          props: %{label: "Next ›", on_click: :next, color: :surface},
          children: []
        }
      ]
    }
  end
end
