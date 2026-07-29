defmodule BeamMeDownTalk.Slides do
  @moduledoc """
  The talk content. Each slide is `%{title:, bullets:}` — empty bullets means a
  title-only slide (section break / cold open / close). Edit freely; the
  renderer in `SlidesWindow` just walks this list.
  """

  @spec all() :: [%{title: String.t(), bullets: [String.t()]}]
  def all do
    [
      %{title: "Beam Me Down", bullets: ["The BEAM Comes Home"]},
      %{
        title: "Where BEAM Was Born",
        bullets: [
          "Ericsson phone switches",
          "Embedded, on-device hardware",
          "Not a data center"
        ]
      },
      %{
        title: "How We Drifted",
        bullets: [
          "LiveView Native's framing",
          "BEAM lives on the server",
          "The client is dumb glass, elsewhere"
        ]
      },
      %{
        title: "The Stated Reason",
        bullets: [
          "\"Phones can't handle BEAM\"",
          "Too big. Too bulky. Kills the battery.",
          "Already disproven — mob, last talk"
        ]
      },
      %{
        title: "Even If That Were True...",
        bullets: [
          "Nothing excuses it for anything with a wall plug",
          "Laptops. Desktops. Servers you already own."
        ]
      },
      %{
        title: "Why Now",
        bullets: [
          "The browser was the compatibility layer. Now the framework is.",
          "LLMs commoditize the coding labor",
          "Growing aversion to being tethered",
          "Someone pays the infra bill — why you?"
        ]
      },
      %{
        title: "Desktop's Been Tried Before",
        bullets: [
          "Electron / React — ship the app to the user",
          "But: bundled browser, no real OS permissions",
          "A native renderer sidesteps both"
        ]
      },
      %{
        title: "Won't It Go Stale?",
        bullets: [
          "No server round-trip — so no sync?",
          "Hot code upgrade.",
          "Day one. Erlang. 1986."
        ]
      },
      %{
        title: "The Honest Limit",
        bullets: [
          "Proven: hot-swapping Elixir code",
          "Unproven: hot-swapping the native NIF itself",
          "Different risk: code signing, AV heuristics",
          "Desktop's looser rules make this askable — mobile never had to"
        ]
      },
      %{
        title: "rext: mob's Desktop Sibling",
        bullets: [
          "Same trick: BEAM owns the view tree",
          "Native backend just draws it",
          "This talk is the proof"
        ]
      },
      %{
        title: "Live",
        bullets: [
          "This deck IS the app",
          "Connect over dist. Drive it. No rebuild."
        ]
      },
      %{title: "Roadmap of the Possible", bullets: []},
      %{
        title: "Restart Without Losing the User",
        bullets: [
          "Full node restart to pick up a new native dep (Rust/Python)",
          "Display node holds the last frame + a spinner",
          "sloppy_joe's invariant — pointed at whole-process death, not just bad code"
        ]
      },
      %{
        title: "Never Left Broken",
        bullets: [
          "Track known-good builds",
          "Rollback belongs on the desktop base node too"
        ]
      },
      %{
        title: "Portal",
        bullets: [
          "Clustering, but for devices you actually own",
          "Phone + laptop: already a validated pairing (Continuity, KDE Connect)",
          "BEAM gives you the general-purpose version",
          "Scan on the phone → collate on the laptop",
          "Scan a barcode → pull up inventory"
        ]
      },
      %{
        title: "Nerves",
        bullets: [
          "Headless embedded boards, no screen",
          "Phone becomes the display / controller"
        ]
      },
      %{
        title: "Desktop as a Hub",
        bullets: [
          "Hop back to the phone: local PWA",
          "Or: dev-mode sideload, same mob tooling"
        ]
      },
      %{
        title: "Built for Agents",
        bullets: [
          "BEAM dist + observability = mob's agent harness",
          "rext just proved the same thing on desktop — live, in this talk",
          "One framework for mobile. One for desktop.",
          "No bespoke MCP server per toolkit."
        ]
      },
      %{title: "The BEAM Came Home", bullets: []}
    ]
  end
end
