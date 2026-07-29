defmodule BeamMeDownTalk.Application do
  use Application

  @impl true
  def start(_type, _args) do
    Supervisor.start_link([], strategy: :one_for_one, name: BeamMeDownTalk.Supervisor)
  end
end

defmodule BeamMeDownTalk do
  use Rext.App

  @impl true
  def windows do
    [{BeamMeDownTalk.SlidesWindow, id: "main", title: "Beam Me Down", size: {1000, 700}}]
  end
end
