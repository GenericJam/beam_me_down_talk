# Beam Me Down

The talk deck *is* the app. This is a slide deck for a talk on why BEAM
belongs on-device — mobile (mob) and now desktop (rext) — built as a single
[rext](https://github.com/GenericJam/rext) window. Slide state (which slide
you're on) lives on the BEAM; a [Compose
Multiplatform](https://www.jetbrains.com/lp/compose-multiplatform/) renderer
just draws whatever tree it's handed, over the same socket transport rext
uses for any app. Nothing about the deck is renderer-specific — it's an
ordinary `Rext.Window`.

The point isn't just "here's a slide viewer" — it's that the deck can be
driven two ways at once, indistinguishably to the window itself: on-screen
Prev/Next buttons, and a connected `mix rext.connect` session calling
`BeamMeDownTalk.SlidesWindow.next/0` live. That's the thing the talk is
actually about, demonstrated by the mechanism it's demonstrated *in*.

## Requires sibling checkouts

This project depends on `rext` and `rext_dev` via **local path**, not Hex —
they're a fast-moving prototype not yet published. Clone all three into the
same parent directory:

```bash
git clone https://github.com/GenericJam/rext.git
git clone https://github.com/GenericJam/rext_dev.git
git clone https://github.com/GenericJam/beam_me_down_talk.git
```

so you end up with:

```
some-parent-dir/
├── rext/
├── rext_dev/
└── beam_me_down_talk/
```

## Run it

Requires Elixir/Erlang (see `rext`'s own README for toolchain notes) and a
JDK for the Compose renderer (Gradle resolves its own toolchain — no manual
JDK pinning needed).

```bash
cd beam_me_down_talk
mix deps.get

# terminal 1 — boot the deck as a named, distributed node
elixir --name talk@127.0.0.1 --cookie rext_secret -S mix run --no-halt dev/demo.exs

# terminal 2 — the render backend (cross-platform: macOS + Linux verified)
cd ../rext/native/compose
REXT_PORT=8137 REXT_WINDOW=main ./gradlew run
```

## Drive it live

```bash
mix rext.connect
```

drops you into the running node directly (`iex --remsh`). From there:

```elixir
BeamMeDownTalk.SlidesWindow.next()      # advance a slide
BeamMeDownTalk.SlidesWindow.prev()      # go back
BeamMeDownTalk.SlidesWindow.goto(10)    # jump straight to slide 11 (0-indexed)
```

Same effect as clicking the on-screen buttons — the window doesn't know or
care which path an event came from.

## Editing the talk

All slide content lives in `lib/beam_me_down_talk/slides.ex` as plain data
(`%{title:, bullets:}` maps). Rendering logic lives in
`lib/beam_me_down_talk/slides_window.ex` and doesn't need to change to edit
wording — just edit the list.

## Tests

```bash
mix test
```

Headless — no renderer needed. Covers slide content shape, next/prev/goto
navigation and clamping at the deck's bounds, the rendered tree reflecting
the current slide, and the dist-drivable API.

## License

MIT
