# Beam Me Down — speaker notes

Beat-by-beat notes per slide, not a verbatim script — adlib freely. Slide
numbers/titles match `lib/beam_me_down_talk/slides.ex` exactly, so if you
reorder or edit slides there, update this file's headers to match.

## 1. Beam Me Down / The BEAM Comes Home

Cold open. State the inversion up front: this isn't "beam it up to the
cloud," it's the opposite — bringing compute back down to the hardware
sitting in front of the user. Don't explain the pun yet, just let the title
land; slide 2 pays it off.

## 2. Where BEAM Was Born

The payoff: BEAM's original target was Ericsson phone switches — embedded,
on-device hardware, not a data center. Most of the room probably doesn't
know this. Land it as: server-first was never BEAM's native habitat, it's
the detour. Everything that follows is a correction, not an invention.

## 3. How We Drifted

LiveView Native's framing: BEAM lives on the server, the client is dumb
glass elsewhere. Name it plainly — this isn't a dig, it's the starting
assumption almost everyone inherited.

## 4. The Stated Reason

The justification for that framing: "phones can't handle BEAM — too big,
too bulky, kills the battery." Then the turn: already disproven, mob, last
talk. Keep this short if the room was at the last talk; expand if it's a
mixed/new crowd.

## 5. Even If That Were True...

Concede the point for argument's sake, then pivot: nothing excuses the same
assumption for anything with a wall plug. Laptops, desktops, servers you
already own. This is the thesis statement — say it slowly.

## 6. Why Now

Lead with the compatibility layer flip. The browser won as the delivery
mechanism in the 2000s for two reasons: OSes were fractured (write once,
run anywhere was a real problem), and the delivery model for native apps was
clumsy — ship a binary, hope the user installs it. At the same time, cloud
hosting was cheap and developer labour was expensive, so putting everything
on a server and shipping a thin client made economic sense.

Both of those conditions have almost exactly inverted. Cloud isn't cheap
anymore — every request costs money, and the bills compound with scale.
Developer labour *looks* cheap right now because LLMs are being subsidised
heavily, but the underlying point is that the *work* of achieving
cross-platform compatibility is no longer the bottleneck it was. You can
put the compatibility layer in the framework instead of the browser: either
compile to every platform from one codebase (Compose Multiplatform, Flutter)
or define grouped elements and tune per platform — which is exactly what mob
does. The browser as a compatibility shim is a solution to a problem that's
largely been solved elsewhere, at a cost (no real OS permissions, bundled
runtime, a whole browser engine as overhead) that was always there but easy
to ignore when the alternative was harder.

Then the other three forces, don't rush them: LLMs commoditizing the coding
labor (the work of building this got cheaper), a growing cultural aversion to
being tethered to someone else's server, and — bluntly — somebody pays the
infra bill, and as an indie dev that somebody is you unless you push it onto
the user's machine.

## 7. Desktop's Been Tried Before

Pre-empt the obvious objection: Electron/React already tried "ship the app
to the user." Name the actual failure modes — a bundled browser, no real OS
permission integration — and the one-line answer: a native renderer
sidesteps both, because you're not shipping a browser at all.

## 8. What About Delivery?

Second objection, staged as a question: no server round-trip, so how does
it stay in sync? Pause half a beat before the answer. Hot code upgrade.
Day one. Erlang. 1986. Let that sit — it's the best line in this section.

## 9. Proven vs Vaporware

Don't skip this — it's the credibility beat. Be precise: proven is
hot-swapping *Elixir* code. Unproven is hot-swapping the native NIF/renderer
itself, and it's not the same kind of risk — code-signing invalidation,
AV heuristics that specifically look for self-modifying binaries. Desktop's
looser distribution rules are exactly what makes this question askable at
all; mobile's app-store gate made it moot. Land this as "here's what I
haven't solved," not a hedge.

## 10. rext: mob's Desktop Sibling

Transition into the live segment. Same trick as mob: BEAM owns the view
tree, the native backend just draws it. Say plainly: this talk is running
on it right now.

## 11. Roadmap of the Possible

Section break. Say explicitly: everything from here is more speculative —
things enabled by desktop that aren't fully built yet. Label it as such so
nobody mistakes the next few slides for shipped features.

## 12. Restart Without Losing the User

The idea: a full node restart to pick up a native dependency change (Rust,
Python) that can't be hot-loaded as bytecode. Display node holds the last
frame + a spinner while the logic node restarts underneath it. Name the
lineage honestly: this is sloppy_joe's two-node invariant ("the thing
supervising an edit can never be the thing an edit can take down"), pointed
at whole-process death instead of a bad code edit. Credit that it's
unbuilt — sloppy_joe's own roadmap calls the mobile version of this its
hardest unsolved problem.

## 13. Never Left Broken

Short, connective beat: rollback/last-known-good tracking belongs on the
desktop base node too, same as sloppy_joe already does for mobile. Not a
new idea, just the same one applied consistently.

## 14. Portal

The clustering pitch. Anticipate the skeptical question before it's asked:
why is phone+laptop different from phone+phone (which mob rejected on
privacy/security grounds)? Answer: it's not that desktop is inherently more
trustworthy — phone+laptop is already an overwhelmingly single-owner,
physically-proximate pairing, the same trust model Apple Continuity/Handoff
and KDE Connect already validated. BEAM gives you the general-purpose
version of that, not a vendor's fixed feature list. Land the two concrete
examples back to back: scan a document on the phone, collate into a PDF on
the laptop; scan a barcode on the phone, pull up inventory on the laptop.

## 15. Nerves

One more example, different shape: a headless Nerves board has no screen.
The phone becomes its display/controller over the same clustering idea —
not compute-offload this time, just "the phone already has a screen and you
already carry it around."

## 16. Desktop as a Hub

Closing the roadmap section: once the desktop app exists, hop back to the
phone two ways — a local PWA (already an anticipated extension of rext's
own transport design, not new architecture) or a dev-mode sideload reusing
mob's existing deploy tooling.

## 17. Built for Agents

The icing. mob's BEAM dist + observability already makes it a strong agent
target; rext just proved the same thing works on desktop, live, in this
exact talk (callback to slide 11). Land the consolidation punchline
explicitly: one framework for mobile, one for desktop — no bespoke MCP
server or IDE plugin per toolkit, because BEAM distribution gives every app
built on it the same agent surface for free.

## 18. The BEAM Came Home

Close. Don't add new content — just land the title again now that the
whole argument is behind it. Let it be quiet.
