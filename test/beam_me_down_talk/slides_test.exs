defmodule BeamMeDownTalk.SlidesTest do
  use ExUnit.Case, async: true

  alias BeamMeDownTalk.Slides

  test "every slide has a non-empty title and a list of string bullets" do
    for slide <- Slides.all() do
      assert is_binary(slide.title)
      assert slide.title != ""
      assert is_list(slide.bullets)
      assert Enum.all?(slide.bullets, &is_binary/1)
    end
  end

  test "opens on the title slide and closes on the callback slide" do
    slides = Slides.all()
    assert List.first(slides).title == "Beam Me Down"
    assert List.last(slides).title == "The BEAM Came Home"
  end
end
