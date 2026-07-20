# pagepp

A fast, zero-runtime-dependency C++17 static site generator. Reads Markdown content with TOML frontmatter, applies a Liquid-compatible template engine, and outputs a complete static HTML site.

Use it for personal websites, project documentation, blogs, academic portfolios, or anything that needs clean static HTML.

**[Read the Documentation](content/documentation/index.md)** for the full reference.

## Requirements

- C++17 compiler (GCC, Clang, or MSVC)
- CMake 3.14+
- Git (for fetching dependencies)

Dependencies (cmark, tomlplusplus) are fetched automatically via CMake FetchContent.

## Building

```sh
cmake -B build
cmake --build build
```

The binary is at `build/pagepp`.

## Usage

### Build the site

```sh
./build/pagepp
```

Generated site is written to `public/`.

### Dev server

```sh
./build/pagepp serve
```

Starts a local server at `http://localhost:8000/` with auto-rebuild on file changes. Watches `content/`, `templates/`, and `assets/` directories. Uses empty `baseurl` so all URLs work at root without editing config.

```sh
./build/pagepp serve --port 3000  # custom port
```

Press `Ctrl+C` to stop.

### CLI options

```
pagepp [options]
pagepp serve [options]

Options:
  --content <dir>    Content directory (default: content)
  --output <dir>     Output directory (default: public)
  --templates <dir>  Templates directory (default: templates)
  --port <port>      Dev server port (default: 8000, serve mode only)
  --help, -h         Show help
```

## Project Structure

```
.
├── CMakeLists.txt
├── src/                    # C++ source
│   ├── main.cpp            # Entry point, CLI parsing
│   ├── site_builder.cpp    # Build orchestration
│   ├── server.cpp          # Dev server with file watching
│   ├── template_engine.cpp # Liquid-like template engine
│   ├── collections.cpp     # Content collection management
│   ├── markdown.cpp        # cmark wrapper
│   ├── frontmatter.cpp     # TOML frontmatter parser
│   ├── config.cpp          # Site config loader
│   └── utils.cpp           # File I/O, string ops, dates
├── content/                # Site content
│   ├── config.toml         # Site configuration
│   ├── index.md            # Home page
│   ├── documentation/      # Documentation section
│   ├── cv.md               # CV page
│   ├── 404.md              # Error page
│   ├── posts/              # Blog posts
│   ├── publications/       # Academic papers
│   ├── talks/              # Conference talks
│   ├── teaching/           # Courses
│   └── software/           # Software projects
├── templates/              # HTML templates
│   ├── layouts/            # Page layouts
│   │   ├── default.html    # Outer HTML shell
│   │   ├── single.html     # Single content page
│   │   ├── archive.html    # Archive/listing page
│   │   ├── splash.html     # Splash landing page
│   │   └── talk.html       # Talk detail page
│   └── includes/           # Reusable partials
│       ├── masthead.html   # Navigation bar
│       ├── footer.html     # Footer with social links
│       ├── sidebar.html    # Author profile sidebar
│       └── ...             # Other partials
└── assets/css/main.css     # Stylesheet
```

## Configuration

`content/config.toml` is the site-wide config.

```toml
title = "Your Name / Site Title"
name = "Your Name"
description = "Your Name's portfolio"
url = "https://example.com"
baseurl = ""
locale = "en-US"

[author]
name = "Your Name"
bio = "Short biography"
email = "you@example.org"
googlescholar = "https://scholar.google.com/citations?user=..."
orcid = "https://orcid.org/..."
pubmed = "https://www.ncbi.nlm.nih.gov/pubmed/?term=..."
github = "username"
gitlab = "username"
codeberg = "username"
forgejo = "https://git.example.com"
sourcehut = "https://git.sr.ht/~you"
matrix = "https://matrix.org"
linkedin = "username"
twitter = "username"
bluesky = "username"
mastodon = "https://mastodon.social/@you"
youtube = "username"
```

## Content Format

Content files use TOML frontmatter between `+++` delimiters followed by Markdown.

```toml
+++
title = "Post Title"
date = "2024-01-15"
permalink = "/posts/2024/01/post-title/"
author_profile = true
tags = ["tag1", "tag2"]
+++

Your markdown content here.
```

### Frontmatter Fields

- `layout` — Template layout: `single`, `archive`, `splash`, `talk`
- `title` — Page title
- `date` — Publication date (`YYYY-MM-DD`)
- `permalink` — Custom URL path
- `author_profile` — Show author sidebar (`true`/`false`)
- `tags` — Array of tags
- `collection` — Collection name (for item pages)
- `category` — Category label shown on publication pages
- `venue` — Publication venue
- `citation` — Recommended citation text
- `paperurl` — Link to paper PDF
- `slidesurl` — Link to slides
- `bibtexurl` — Link to BibTeX file
- `excerpt` — Short description
- `type` — Item type (for talks/teaching)
- `location` — Location (for talks)
- `nav_order` — Position in navigation (lower = earlier)
- `redirect_from` — Array of old URLs to redirect from
- `sitemap` — Include in sitemap (default: `true`)

## Sections

Each subdirectory under `content/` with an `index.md` becomes a navigation section. Child `.md` files are collection items.

### Adding a Section

1. Create `content/your-section/`
2. Add `index.md` with frontmatter:

```toml
+++
title = "Your Section"
nav_order = 5
author_profile = true
+++

Section description and links to items.
```

3. Add `.md` files in the directory for collection items
4. Rebuild with `./build/pagepp`

Sections are auto-discovered and added to the navigation bar, ordered by `nav_order`.

### Standalone Pages

Top-level `.md` files in `content/` (e.g., `cv.md`, `404.md`) render as standalone pages.

## Collections

### Posts

`content/posts/*.md` — Blog posts with date-based permalinks (`/posts/YYYY/MM/slug/`).

```toml
+++
title = "My Post"
date = "2024-03-15"
author_profile = true
tags = ["blog", "tutorial"]
+++
```

### Publications

`content/publications/*.md` — Academic papers grouped by category.

```toml
+++
title = "Paper Title"
date = "2024-06-01"
collection = "publications"
category = "Journal Articles"
venue = "Journal Name"
citation = "Author. Title. Journal, 2024."
paperurl = "https://example.com/paper.pdf"
author_profile = true
+++
```

### Talks

`content/talks/*.md` — Conference talks and presentations.

```toml
+++
title = "Talk Title"
date = "2024-09-10"
collection = "talks"
type = "Talk"
venue = "Conference Name"
location = "City, Country"
author_profile = true
+++
```

### Teaching

`content/teaching/*.md` — Courses and teaching experience.

```toml
+++
title = "Course Name"
date = "2024-01-10"
collection = "teaching"
type = "Seminar"
venue = "University Name"
author_profile = true
+++
```

## Templates

Templates use Liquid-compatible syntax.

### Variables

```liquid
{{ page.title }}
{{ site.name }}
{{ author.email }}
```

### Filters

```liquid
{{ value | upcase }}
{{ value | truncatewords: 10 }}
{{ value | default: "fallback" }}
{{ value | date_to_string }}
```

Available filters: `markdownify`, `strip_html`, `strip_newlines`, `escape_once`, `size`, `upcase`, `downcase`, `capitalize`, `trim`, `truncatewords(N)`, `default("val")`, `prepend("str")`, `append("str")`, `date_to_string`, `date_to_xmlschema`, `jsonify`, `slugify`, `remove("str")`, `slice(start, len)`.

### Blocks

```liquid
{% if condition %}...{% elsif condition %}...{% else %}...{% endif %}
{% for item in collection %}{{ forloop.index }}: {{ item.title }}{% endfor %}
{% include "filename" %}
{% assign var = value %}
```

### Forloop Variables

- `forloop.index` — 1-based index
- `forloop.index0` — 0-based index
- `forloop.first` — `true` if first iteration
- `forloop.last` — `true` if last iteration
- `forloop.length` — Total items

### Layouts

Layouts wrap content via `{{ content }}`:

```html
<!-- layouts/default.html -->
<html>
  <body>
    {% include "masthead.html" %}
    {{ content }}
    {% include "footer.html" %}
  </body>
</html>
```

Set layout in frontmatter: `layout = "single"`.

## Social Links

Social icons in the footer are controlled by fields in `[author]` in `config.toml`. Set a field to show its icon, leave empty or remove to hide.

Supported: `email`, `googlescholar`, `orcid`, `pubmed`, `github`, `gitlab`, `git`, `codeberg`, `forgejo`, `sourcehut`, `matrix`, `linkedin`, `twitter`, `bluesky`, `mastodon`, `youtube`.

Icons are loaded from Font Awesome 7.3.0 and Academicons via CDN.

## Static Assets

- Place files in `content/files/` and `content/images/` — copied to output as-is
- `assets/` directory is copied to output
- CSS is at `assets/css/main.css`

## Deployment

### GitHub Pages

The repository includes `.github/workflows/ci.yml` for automatic deployment:

1. Push to a GitHub repository
2. Go to Settings > Pages
3. Set source to "GitHub Actions"
4. Push to `main` — the site deploys automatically

### Any Static Host

```sh
./build/pagepp
```

Upload the contents of `public/` to your hosting provider.

### Docker

Build and run the dev server:

```sh
docker build -t pagepp .
docker run -p 8000:8000 -v "$(pwd)/content:/site/content" -v "$(pwd)/templates:/site/templates" pagepp
```

Mount your `content/` and `templates/` volumes for live editing. Open `http://localhost:8000/`.

To generate a static build instead:

```sh
docker run -v "$(pwd)/public:/site/public" pagepp build
```

## License

pagepp is licensed under the [MIT-License](LICENSE).
