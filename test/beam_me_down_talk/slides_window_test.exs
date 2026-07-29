defmodule BeamMeDownTalk.SlidesWindowTest do
  use ExUnit.Case, async: true

  alias BeamMeDownTalk.SlidesWindow
  alias BeamMeDownTalk.Slides
  alias Rext.Window

  # No bridge started: the window runs headless — same as rext's own
  # Window tests, and exactly how a connected agent inspects state with no
  # native renderer attached.

  test "mounts on the first slide" do
    {:ok, pid} = Window.start_link(SlidesWindow, %{}, id: "t1", name: :slides_t1)
    info = Window.inspect(pid)

    assert info.assigns.index == 0
    assert length(info.assigns.slides) == length(Slides.all())
    assert info.tree.type == :column
  end

  test "next/prev navigate and clamp at the deck's bounds" do
    {:ok, pid} = Window.start_link(SlidesWindow, %{}, id: "t2", name: :slides_t2)
    total = length(Window.get_socket(pid).assigns.slides)

    :ok = Window.dispatch(pid, "click", %{"tag" => "prev"})
    assert Window.get_socket(pid).assigns.index == 0

    for _ <- 1..(total + 5), do: Window.dispatch(pid, "click", %{"tag" => "next"})
    assert Window.get_socket(pid).assigns.index == total - 1

    :ok = Window.dispatch(pid, "click", %{"tag" => "prev"})
    assert Window.get_socket(pid).assigns.index == total - 2
  end

  test "goto jumps directly and clamps out-of-range indices" do
    {:ok, pid} = Window.start_link(SlidesWindow, %{}, id: "t3", name: :slides_t3)
    total = length(Window.get_socket(pid).assigns.slides)

    :ok = Window.dispatch(pid, "goto", %{"index" => 5})
    assert Window.get_socket(pid).assigns.index == 5

    :ok = Window.dispatch(pid, "goto", %{"index" => total + 50})
    assert Window.get_socket(pid).assigns.index == total - 1

    :ok = Window.dispatch(pid, "goto", %{"index" => -50})
    assert Window.get_socket(pid).assigns.index == 0
  end

  test "the rendered tree's title node reflects the current slide" do
    {:ok, pid} = Window.start_link(SlidesWindow, %{}, id: "t4", name: :slides_t4)
    :ok = Window.dispatch(pid, "goto", %{"index" => 1})

    slide = Enum.at(Slides.all(), 1)
    tree = Window.inspect(pid).tree
    [title_node | _rest] = tree.children

    assert title_node.props.text == slide.title
  end

  test "next/0, prev/0, goto/1 drive the registered main window over dispatch/3" do
    {:ok, _pid} = Window.start_link(SlidesWindow, %{}, id: "main")

    :ok = SlidesWindow.next()
    assert Window.get_socket(Window.via("main")).assigns.index == 1

    :ok = SlidesWindow.goto(4)
    assert Window.get_socket(Window.via("main")).assigns.index == 4

    :ok = SlidesWindow.prev()
    assert Window.get_socket(Window.via("main")).assigns.index == 3
  end
end
