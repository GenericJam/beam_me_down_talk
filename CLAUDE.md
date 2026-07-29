# beam_me_down_talk — Agent Instructions

Talk deck for "Beam Me Down" (BEAM-on-desktop) built as a single
[rext](../rext) window. **Read `../rext/CLAUDE.md` first** — it carries the
shared knowledge (transport architecture, quality-gate conventions, the
ExSlop "don't write this slop" list). This file covers only what's specific
to the deck.

## What this is, and isn't

This is a presentation vehicle, not a framework. It exists to demonstrate,
live, that a rext window's state lives on the BEAM and can be driven two
indistinguishable ways: on-screen buttons, or a connected `mix rext.connect`
session calling `BeamMeDownTalk.SlidesWindow.next/0`. That dual-drive
property *is* the point of the talk — don't add anything that would make the
two paths diverge (e.g. client-side-only slide state).

Explicitly out of scope for this repo: the "Portal" phone↔desktop clustering
demo discussed for the same talk lives in a **separate** app, deliberately,
so a Portal hiccup on stage can't take down the deck the rest of the talk
depends on. Don't merge them.

## Sibling checkout requirement

`mix.exs` depends on `rext` and `rext_dev` via **local path** (`../rext`,
`../rext_dev`), not Hex — they're fast-moving prototypes, not yet published.
This repo is unbuildable on its own; it must be cloned alongside its two
siblings in the same parent directory:

```
some-parent-dir/
├── rext/
├── rext_dev/
└── beam_me_down_talk/
```

If `mix deps.get`/`mix compile` fails with a path-dependency error, this is
almost certainly why — check the sibling checkouts exist before debugging
anything else.

## Toolchain

No machine-specific paths are pinned here (unlike `rext`'s own CLAUDE.md,
which documents a specific cross-user macOS mise setup that doesn't apply
elsewhere). Just ensure `elixir`/`mix` are on `PATH` for whatever toolchain
manager this machine uses, and a JDK for the Compose renderer — Gradle
resolves its own toolchain, no manual JDK version pinning needed.

## Running it

Two terminals, deliberately not `mix rext.run` — that task's renderer
auto-launch (`RextDev.Boot`) only knows how to find/build the macOS SwiftUI
renderer, not Compose, so it would silently run headless here. Boot and
render backend are launched by hand instead (see `dev/demo.exs`):

```bash
# terminal 1 — the deck, as a named distributed node
elixir --name talk@127.0.0.1 --cookie rext_secret -S mix run --no-halt dev/demo.exs

# terminal 2 — the render backend (macOS + Linux verified; see rext/PLAN.md)
cd ../rext/native/compose && REXT_PORT=8137 REXT_WINDOW=main REXT_ICON=../../../beam_me_down_talk/priv/icon.png ./gradlew run
```

`REXT_ICON` is generic, optional support in `rext`'s shared renderer
(`native/compose/src/main/kotlin/Main.kt` — `loadIcon`/`setDockIcon`), not
talk-specific: any rext app can point it at its own image. On macOS, plain
AWT `Frame.setIconImage` (what Compose's `Window(icon=)` sets) only reaches
the title bar — the Dock icon needs `java.awt.Taskbar.setIconImage`
explicitly, which `setDockIcon` does. If a future icon-related bug only
reproduces on macOS, check that split first.

`mix rext.connect` (from `rext_dev`) still works normally for driving it —
that task doesn't touch the renderer at all, it's a plain `iex --remsh` into
the running node.

## Structure

- `lib/beam_me_down_talk/slides.ex` — the talk content, plain data
  (`%{title:, bullets:}`). Edit wording here; nothing else needs to change.
- `lib/beam_me_down_talk/slides_window.ex` — the `Rext.Window`. `render/1`
  walks the current slide into column/row/text/button nodes (no new render
  backend node types needed — column/row/text/button already cover a slide
  deck). `next/0`, `prev/0`, `goto/1` are the dist-drivable API, routed
  through the same `Rext.Window.dispatch/3` path as the on-screen buttons —
  don't reach for `:sys.replace_state` or similar to bypass that path; it's
  the thing keeping the two drive methods identical.

## Testing

```bash
mix test
```

Headless, no renderer needed — mirrors `rext`'s own `Rext.WindowTest` style
(start the window directly, dispatch events, assert on `Window.get_socket/1`
and `Window.inspect/1`). Covers slide content shape, next/prev/goto
navigation and clamping at the deck's bounds, the rendered tree reflecting
the current slide, and the `next/0`/`prev/0`/`goto/1` wrappers.

## Quality gates

```bash
mix format --check-formatted
mix compile --warnings-as-errors
mix test
```

This repo doesn't carry `rext`'s full Credo/ExSlop setup (it's a talk deck,
not a shipped library) — format + warnings-as-errors + tests is the bar here.

## Keep this file up to date

If you change how the deck boots, add a render node type, or hit a
Linux-specific gotcha verifying the Compose renderer there, fix it here in
the same commit.
