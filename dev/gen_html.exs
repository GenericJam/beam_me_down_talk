# Generates a self-contained HTML fallback presentation.
# Run: mix run dev/gen_html.exs
# Output: presentation.html (all images base64-embedded, no external deps)

slides = BeamMeDownTalk.Slides.all()

image_map = %{
  0  => {"title.png",           "image/png"},
  1  => {"axd301.png",          "image/png"},
  2  => {"dumb_glass.png",      "image/png"},
  3  => {"cant_handle_beam.png","image/png"},
  4  => {"wall_plug.png",       "image/png"},
  5  => {"compat_layer.png",    "image/png"},
  6  => {"bundled_browser.png", "image/png"},
  7  => {"delivery.png",        "image/png"},
  8  => {"delivery.png",        "image/png"},
  9  => {"beam_bridge.png",     "image/png"},
  10 => {"roadmap.jpg",         "image/jpeg"},
  11 => {"two_nodes.png",       "image/png"},
  12 => {"two_nodes.png",       "image/png"},
  13 => {"portal.png",          "image/png"},
  14 => {"nerves.png",          "image/png"},
  15 => {"desktop_hub.png",     "image/png"},
  16 => {"agent_neo.png",       "image/png"},
  17 => {"beam_came_home.png",  "image/png"}
}

priv = :code.priv_dir(:beam_me_down_talk) |> to_string()

# Encode each unique file once
data_uris =
  image_map
  |> Map.values()
  |> Enum.uniq_by(&elem(&1, 0))
  |> Map.new(fn {file, mime} ->
    uri = File.read!(Path.join(priv, file)) |> Base.encode64() |> then(&"data:#{mime};base64,#{&1}")
    {file, uri}
  end)

escape = fn s ->
  s
  |> String.replace("&", "&amp;")
  |> String.replace("<", "&lt;")
  |> String.replace(">", "&gt;")
  |> String.replace("\"", "&quot;")
end

slides_html =
  slides
  |> Enum.with_index()
  |> Enum.map_join("\n", fn {%{title: title, bullets: bullets}, i} ->
    active = if i == 0, do: " active", else: ""

    img =
      case image_map[i] do
        {file, _} -> ~s(<img src="#{data_uris[file]}" class="slide-img">)
        nil -> ""
      end

    bullets_html =
      if bullets == [] do
        ""
      else
        items = Enum.map_join(bullets, "\n", fn b -> "      <li>#{escape.(b)}</li>" end)
        "    <ul>\n#{items}\n    </ul>"
      end

    """
      <div class="slide#{active}">
        <h1>#{escape.(title)}</h1>
        #{img}
        #{bullets_html}
      </div>
    """
  end)

total = length(slides)

html = """
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Beam Me Down</title>
<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

  body {
    background: #1a1b26;
    color: #c0caf5;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    height: 100vh;
    overflow: hidden;
  }

  .deck { width: 100vw; height: 100vh; position: relative; }

  .slide {
    display: none;
    flex-direction: column;
    gap: 28px;
    padding: 56px 80px 80px;
    width: 100%;
    height: 100%;
    overflow-y: auto;
  }
  .slide.active { display: flex; }

  h1 {
    font-size: 3rem;
    font-weight: 700;
    color: #7aa2f7;
    line-height: 1.15;
    flex-shrink: 0;
  }

  .slide-img {
    max-width: 640px;
    max-height: 42vh;
    object-fit: contain;
    border-radius: 8px;
    flex-shrink: 0;
  }

  ul { list-style: none; display: flex; flex-direction: column; gap: 18px; }

  li {
    font-size: 1.55rem;
    color: #a9b1d6;
    padding-left: 1.6rem;
    position: relative;
    line-height: 1.4;
  }
  li::before { content: "•"; position: absolute; left: 0; color: #7aa2f7; }

  .nav {
    position: fixed;
    bottom: 18px;
    left: 18px;
    display: flex;
    gap: 8px;
    align-items: center;
  }
  .nav button {
    background: #414868;
    color: #c0caf5;
    border: none;
    padding: 9px 18px;
    border-radius: 6px;
    font-size: 1rem;
    cursor: pointer;
    transition: background 0.15s;
  }
  .nav button:hover { background: #565f89; }
  #counter { color: #565f89; font-size: 0.9rem; min-width: 54px; text-align: center; }
</style>
</head>
<body>
<div class="deck">
#{slides_html}
</div>

<div class="nav">
  <button onclick="go(-1)">&#8249; Prev</button>
  <span id="counter">1 / #{total}</span>
  <button onclick="go(1)">Next &#8250;</button>
</div>

<script>
  let cur = 0;
  const slides = document.querySelectorAll('.slide');
  const counter = document.getElementById('counter');

  function go(d) {
    slides[cur].classList.remove('active');
    cur = Math.max(0, Math.min(slides.length - 1, cur + d));
    slides[cur].classList.add('active');
    slides[cur].scrollTop = 0;
    counter.textContent = (cur + 1) + ' / ' + slides.length;
  }

  document.addEventListener('keydown', e => {
    if (e.key === 'ArrowRight' || e.key === 'ArrowDown' || e.key === ' ') go(1);
    if (e.key === 'ArrowLeft'  || e.key === 'ArrowUp')                     go(-1);
  });
</script>
</body>
</html>
"""

out = Path.join(File.cwd!(), "presentation.html")
File.write!(out, html)
size_mb = Float.round(byte_size(html) / 1_048_576, 1)
IO.puts("Written #{out} (#{size_mb} MB)")
