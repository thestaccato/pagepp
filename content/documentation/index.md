+++
title = "Documentation"
nav_order = 10
toc = true
+++
---

## Installation
---

### Prerequisites

- C++17 compiler (GCC 7+, Clang 5+, MSVC 2017+)
- CMake 3.14+
- Git

### Build from Source

```sh
git clone https://github.com/thestaccato/pagepp.git
cd pagepp
cmake -B build
cmake --build build
```

The binary is output to `build/pagepp`.

### Clean Build

```sh
rm -rf build/
cmake -B build
cmake --build build
```

### Verify Installation

```sh
./build/pagepp --help
```

Expected output:

```
pagepp - Static Site Generator

Usage:
  pagepp [options]              Build the site
  pagepp serve [options]        Start dev server with live rebuild

Options:
  --content <dir>    Content directory (default: content)
  --output <dir>     Output directory (default: public)
  --templates <dir>  Templates directory (default: templates)
  --port <port>      Dev server port (default: 8000)
```

# Quick Start
---

### 1. Configure Your Site

Edit `content/config.toml`:

```toml
title = "Jane Doe / Portfolio"
name = "Jane Doe"
description = "Jane Doe's portfolio"
url = "https://janedoe.github.io"
baseurl = ""
locale = "en-US"

[social]
email = "jane@example.com"
github = "janedoe"
googlescholar = "https://scholar.google.com/citations?user=XXXXX"
```

### 2. Edit the Home Page

Edit `content/index.md`:

```toml
+++
title = "Jane Doe"
+++

Welcome to my portfolio. I am an Assistant Professor
of Computer Science at Example University.
```

### 3. Add Content

Create a new publication at `content/publications/my-paper.md`:

```toml
+++
title = "My First Paper"
date = "2024-06-01"
collection = "publications"
category = "Journal Articles"
venue = "Journal of Examples"
citation = "Doe, J. My First Paper. Journal of Examples, 2024."
paperurl = "https://example.com/paper.pdf"
+++

This paper explores...
```

### 4. Build

```sh
./build/pagepp
```

### 5. Preview

Start the dev server with auto-rebuild:

```sh
./build/pagepp serve
```

Open `http://localhost:8000/` in your browser.

# CLI Reference
---

```
pagepp [options]
pagepp serve [options]
```

### Build Mode

```
pagepp [options]
```

- `--content <dir>` — Content directory path (default: `content`)
- `--output <dir>` — Output directory path (default: `public`)
- `--templates <dir>` — Templates directory path (default: `templates`)
- `--help`, `-h` — Show help message

### Dev Server

```
pagepp serve [options]
```

- `--content <dir>` — Content directory path (default: `content`)
- `--output <dir>` — Output directory path (default: `public`)
- `--templates <dir>` — Templates directory path (default: `templates`)
- `--port <port>` — Dev server port (default: `8000`)

The dev server automatically rebuilds the site when files change in `content/`, `templates/`, or `assets/`. It uses empty `baseurl` so all URLs work at root.

### Examples

```sh
# Default build
./build/pagepp

# Custom directories
./build/pagepp --content ./src/content --output ./dist --templates ./tpl

# Dev server on custom port
./build/pagepp serve --port 3000
```


# Configuration Reference
---

The site configuration lives at `content/config.toml`.

### Top-Level Fields

- `title` (string) — Site title, shown in browser tab and header
- `name` (string) — Site owner name
- `description` (string) — Site description for meta tags
- `url` (string) — Site base URL (e.g., `https://example.com`)
- `baseurl` (string) — Base URL path, defaults to `""` (e.g., `/blog` for subdirectory hosting)
- `locale` (string) — Site locale for `lang` attribute, defaults to `"en-US"`

### Social Links

Set any field to show its icon in the footer. Leave empty or omit to hide.

- `email` — Email address
- `googlescholar` — Full URL
- `orcid` — Full URL
- `github` — Username only
- `gitlab` — Username only
- `git` — Full URL
- `codeberg` — Username only
- `forgejo` — Full URL
- `sourcehut` — Full URL
- `matrix` — Full URL
- `linkedin` — Username only
- `bluesky` — Username or handle
- `mastodon` — Full URL
- `fediverse` — Full URL
- `kofi` — Full URL

Username-only fields are automatically prefixed with the service URL:
- `github`: `https://github.com/<username>`
- `gitlab`: `https://gitlab.com/<username>`
- `codeberg`: `https://codeberg.org/<username>`
- `linkedin`: `https://www.linkedin.com/in/<username>`
- `bluesky`: `https://bsky.app/profile/<username>`

Full-URL fields (email, googlescholar, orcid, git, forgejo, sourcehut, matrix, mastodon, fediverse, kofi) use the value as-is.

Icons are inline SVGs with `fill="currentColor"` for automatic light/dark theme support. No external font dependencies.

# Content Format
---

All content files use TOML frontmatter between `+++` delimiters, followed by Markdown body content.

```toml
+++
title = "Page Title"
date = "2024-01-15"
permalink = "/custom-url/"
tags = ["tag1", "tag2"]
+++

# Markdown content starts here

This is the body of the page. It supports **bold**, *italic*,
[links](https://example.com), and all standard Markdown syntax.
```

### Frontmatter Parsing

- Delimiter: `+++` (opening and closing)
- Format: TOML (parsed by tomlplusplus)
- All scalar values are flattened to strings for template access
- Arrays are supported for fields like `tags` and `redirect_from`

### Markdown Rendering

Body content is rendered to HTML using cmark with CommonMark-compliant output.

# Sections & Navigation
---

### How Sections Work

A **section** is any subdirectory under `content/` that contains an `index.md` file. Sections are auto-discovered during build and added to the navigation bar.

### Creating a Section

1. Create a directory under `content/`:

```sh
mkdir content/my-section
```

2. Create `content/my-section/index.md`:

```toml
+++
title = "My Section"
nav_order = 5
+++

Welcome to my section. Here are my items:
```

3. Add `.md` files in the directory for collection items
4. Rebuild: `./build/pagepp`

### Navigation Order

The `nav_order` frontmatter field controls position in the navigation bar. Lower values appear first. Sections without `nav_order` default to 999 (appear last).

```toml
+++ 
title = "Publications"
nav_order = 1
+++

+++ 
title = "Talks"
nav_order = 2
+++

+++ 
title = "Blog"
nav_order = 3
+++
```

Results in: Publications | Talks | Blog

### Section Permalink

The section permalink defaults to `/<directory-name>/`. Override with `permalink` in frontmatter:

```toml
+++
title = "My Section"
permalink = "/custom-path/"
+++
```

### Excluded Directories

The following directories are ignored during section discovery:
- Directories starting with `.`
- `files/`
- `images/`

### Standalone Pages

Top-level `.md` files in `content/` (not in subdirectories) are rendered as standalone pages. They use the `single` layout by default unless overridden with `layout` in frontmatter.

Examples:
- `content/cv.md` -> `public/cv/index.html`
- `content/404.md` -> `public/404.html`


# Collections
---

A **collection** is the set of `.md` files within a section directory (excluding `index.md`). Each section's items form a collection named after the directory.

### Posts (`content/posts/`)

Blog posts with date-based permalinks.

```toml
+++
title = "My Blog Post"
date = "2024-03-15"
tags = ["tutorial", "python"]
+++

Post content here...
```

**Permalink pattern:** `/posts/YYYY/MM/slug/`

The slug is derived from the filename (without date prefix). For example, `2024-03-15-my-blog-post.md` generates `/posts/2024/03/my-blog-post/`.

### Publications (`content/publications/`)

Academic papers grouped by category.

```toml
+++
title = "Paper Title"
date = "2024-06-01"
collection = "publications"
category = "Journal Articles"
venue = "Journal Name"
citation = "Author. Title. Journal, 2024."
paperurl = "https://example.com/paper.pdf"
slidesurl = "https://example.com/slides.pdf"
bibtexurl = "https://example.com/paper.bib"
+++

Abstract or summary...
```

**Publication-specific fields:**
- `category` — Category label shown on publication pages (e.g., "Journal Articles")
- `venue` — Journal, conference, or publisher name
- `citation` — Recommended citation string
- `paperurl` — Link to PDF
- `slidesurl` — Link to slides
- `bibtexurl` — Link to BibTeX file

**Permalink pattern:** `/publications/<filename>/`

### Talks (`content/talks/`)

Conference talks and presentations.

```toml
+++
title = "Talk Title"
date = "2024-09-10"
collection = "talks"
type = "Talk"
venue = "Conference Name"
location = "City, Country"
slidesurl = "https://example.com/slides.pdf"
+++

Talk description...
```

**Talk-specific fields:**
- `type` — "Talk", "Tutorial", "Keynote", etc.
- `venue` — Conference or event name
- `location` — Physical location
- `slidesurl` — Link to slides

**Permalink pattern:** `/talks/<filename>/`

### Teaching (`content/teaching/`)

Courses and teaching experience.

```toml
+++
title = "CS 101: Introduction to Programming"
date = "2024-01-10"
collection = "teaching"
type = "Seminar"
venue = "University Name"
+++

Course description...
```

**Teaching-specific fields:**
- `type` — "Seminar", "Lecture", "Workshop", etc.
- `venue` — Institution name

**Permalink pattern:** `/teaching/<filename>/`

### Custom Collections

Any section directory becomes a collection. Create `content/software/` with an `index.md` and add `.md` files to build a custom collection.

### Sorting

Items within a collection are sorted by date in descending order (newest first) in archive listings and the sitemap/feed.

### Permalink Generation

Posts use the pattern `/posts/YYYY/MM/slug/` (e.g., `/posts/2024/03/my-post/`). All other collections use `/<collection>/<filename>/` (e.g., `/publications/my-paper/`). Override any permalink with the `permalink` frontmatter field.

# Frontmatter Reference
---

Complete list of supported frontmatter fields.

### Universal Fields

These fields work on all content types:

- `layout` (string) — Template layout: `single`, `archive`, `splash`, `talk`
- `title` (string) — Page title
- `date` (string) — Date in `YYYY-MM-DD` format
- `permalink` (string) — Custom URL path (overrides auto-generation)
- `tags` (array) — List of tags for taxonomy display
- `excerpt` (string) — Short description for listings and feed
- `nav_order` (int) — Section position in navigation (lower = earlier, section index.md only)
- `redirect_from` (array) — List of old URLs to redirect from
- `sitemap` (bool) — Include in sitemap (default: `true`)
- `read_time` (bool) — Show estimated reading time
- `share` (bool) — Show share buttons

### Publication Fields

- `collection` (string) — Set to `"publications"`
- `category` (string) — Category label shown on publication pages
- `venue` (string) — Journal, conference, or publisher name
- `citation` (string) — Recommended citation text
- `paperurl` (string) — URL to paper PDF
- `slidesurl` (string) — URL to slides
- `bibtexurl` (string) — URL to BibTeX file

### Talk Fields

- `collection` (string) — Set to `"talks"`
- `type` (string) — "Talk", "Tutorial", "Keynote", etc.
- `venue` (string) — Conference or event name
- `location` (string) — Physical location
- `slidesurl` (string) — URL to slides

### Teaching Fields

- `collection` (string) — Set to `"teaching"`
- `type` (string) — "Seminar", "Lecture", "Workshop", etc.
- `venue` (string) — Institution name

### Redirects

Create redirects from old URLs to a new page:

```toml
+++
title = "New Page Title"
permalink = "/new-url/"
redirect_from = ["/old-url/", "/another-old-url/"]
+++
```

Redirects are implemented as HTML meta refresh pages at the old URL paths.

# Template Engine
---

pagepp implements a Liquid-compatible template engine. Templates are HTML files with embedded template tags.

### Syntax

- **Variables:** `{{ expression }}`
- **Tags:** `{% tag %}`
- **Comments:** Not supported (use HTML comments `<!-- -->`)

### Variable Resolution

Variables use dot-path notation:

```liquid
{{ site.title }}          <!-- Resolves site.title from context -->
{{ page.title }}          <!-- Resolves page.title -->
{{ social.email }}        <!-- Resolves social.email -->
```

Variables can also be resolved without dots:

```liquid
{{ title }}               <!-- Looks up "title" directly -->
```

### Literals

```liquid
{{ "hello" }}             <!-- String literal -->
{{ 'hello' }}             <!-- Single-quoted string literal -->
{{ true }}                <!-- Boolean literal -->
{{ false }}               <!-- Boolean literal -->
{{ nil }}                 <!-- Null/empty -->
```

# Layouts
---

### Layout Inheritance

Templates use a layout chain:

```
default.html  (outer shell: <!doctype html>, <head>, <body>, masthead, footer)
  └── {{ content }} is replaced by the inner layout output
        ├── single.html    (article view with metadata, citation)
        ├── archive.html   (listing view with title)
        ├── splash.html    (hero image or plain content)
        └── talk.html      (talk detail)
```

### Setting a Layout

Set the layout in frontmatter:

```toml
+++
layout = "single"
title = "My Page"
+++
```

Default layout per context:
- Section index pages: `archive`
- Collection items: `single`
- Standalone pages: `single`

### Layout Files

#### `default.html`

The outer HTML shell. Contains `<head>`, masthead, `{{ content }}`, and footer.

```html
<!doctype html>
<html lang="{{ site.locale | slice: 0,2 }}">
  <head>
    {% include head.html %}
  </head>
  <body>
    {% include masthead.html %}
    {{ content }}
    <div class="page__footer">
      <footer>
        {% include footer.html %}
      </footer>
    </div>
  </body>
</html>
```

#### `single.html`

Renders a single content page with title, date, and metadata.

```html
<div id="main" role="main">
  <article class="page">
    <div class="page__inner-wrap">
      <header>
        <h1 class="page__title">{{ page.title }}</h1>
      </header>
      <section class="page__content">
        {{ content }}
      </section>
    </div>
  </article>
</div>
```

#### `archive.html`

Renders a section index page with title and content.

```html
<div id="main" role="main">
  <div class="archive">
    <h1 class="page__title">{{ page.title }}</h1>
    {{ content }}
  </div>
</div>
```

#### `splash.html`

Renders a splash/hero page. Supports optional overlay image.

```html
{% if page.header.overlay_image %}
  <div class="page__hero" style="background-image: url('{{ page.header.overlay_image }}');">
    <div class="page__hero-overlay"></div>
    <div class="page__hero-content">
      {{ content }}
    </div>
  </div>
{% else %}
  {{ content }}
{% endif %}
```

### Includes

Includes are loaded from `templates/includes/` via `{% include "filename" %}`.

- `head.html` — `<head>` contents (meta, title, CSS links)
- `masthead.html` — Top navigation bar
- `footer.html` — Footer with social links and copyright
- `read-time.html` — Estimated reading time
- `page__taxonomy.html` — Tags display

# Filters Reference
---

Filters are applied to variables using the pipe `|` syntax. Multiple filters can be chained.

**Arguments use parentheses**, not colons:

```liquid
{{ value | truncatewords(10) }}
{{ value | default("fallback") }}
{{ value | slice(0, 5) }}
{{ value | remove("<p>") }}
```

Unquoted arguments are resolved as variables:

```liquid
{{ page.excerpt | default(site.description) }}
{{ site.locale | slice(0, 2) }}
```

### String Filters

- `upcase` — `{{ val | upcase }}` — Convert to uppercase
- `downcase` — `{{ val | downcase }}` — Convert to lowercase
- `capitalize` — `{{ val | capitalize }}` — Capitalize first letter
- `trim` — `{{ val | trim }}` — Remove leading/trailing whitespace
- `strip_html` — `{{ val | strip_html }}` — Remove HTML tags
- `strip_newlines` — `{{ val | strip_newlines }}` — Remove newline characters
- `escape_once` — `{{ val | escape_once }}` — Escape HTML entities
- `slugify` — `{{ val | slugify }}` — Convert to URL-safe slug
- `jsonify` — `{{ val | jsonify }}` — Wrap in JSON quotes with escaping

### Transformation Filters

- `markdownify` — `{{ val | markdownify }}` — Render Markdown to HTML
- `truncatewords` — `{{ val | truncatewords(10) }}` — Truncate to N words with ellipsis
- `default` — `{{ val | default("fallback") }}` — Return fallback if empty
- `prepend` — `{{ val | prepend("prefix") }}` — Add string before value
- `append` — `{{ val | append("suffix") }}` — Add string after value
- `remove` — `{{ val | remove("str") }}` — Remove all occurrences of substring
- `slice` — `{{ val | slice(0, 5) }}` — Extract substring (start, length). Negative start counts from end
- `divided_by` — `{{ val | divided_by(5) }}` — Integer division
- `abs` — `{{ val | abs }}` — Absolute value of integer

### Size Filter

- `size` — `{{ val | size }}` — Return string length as string

### Date Filters

- `date_to_string` — `{{ val | date_to_string }}` — Format as "Month DD, YYYY"
- `date_to_xmlschema` — `{{ val | date_to_xmlschema }}` — Format as ISO 8601

### Filter Chaining

```liquid
{{ page.title | upcase | prepend("TITLE: ") }}
{{ page.date | date_to_string }}
{{ social.email | truncatewords(20) | default("No email available.") }}
{{ post.title | strip_html | downcase | slugify }}
```


# Tags Reference
---

### Conditional Tags

#### `{% if %}` / `{% elsif %}` / `{% else %}` / `{% endif %}`

```liquid
{% if page.read_time == "true" %}
  <span class="read-time">Estimated read time</span>
{% endif %}
```

```liquid
{% if page.venue and page.date %}
  Published in {{ page.venue }}, {{ page.date }}
{% elsif page.date %}
  Published: {{ page.date }}
{% else %}
  No date available
{% endif %}
```

**Supported operators:**
- `==` — Equality
- `!=` — Inequality
- `contains` — String containment
- Truthy/falsy — Non-empty, non-"false", non-"nil", non-"0" values are truthy

**Combining conditions:**
- `and` / `or` are not supported as operators
- Use nested `{% if %}` blocks for complex logic
- Simple truthiness checks work: `{% if page.venue %}`

#### Truthiness Rules

Any non-empty string and `"true"` are truthy. The values `"false"`, `"nil"`, `"null"`, `"0"`, and empty string `""` are falsy.

### Loop Tags

#### `{% for item in collection %}` / `{% endfor %}`

```liquid
{% for post in site.posts.items %}
  <li>{{ post.title }}</li>
{% endfor %}
```

**Forloop variables:**

- `forloop.index` (int) — 1-based current index
- `forloop.index0` (int) — 0-based current index
- `forloop.first` (bool) — `true` on first iteration
- `forloop.last` (bool) — `true` on last iteration
- `forloop.length` (int) — Total number of items

```liquid
{% for item in site.publications.items %}
  {{ forloop.index }}. {{ item.title }}
  {% if forloop.last %}Last item{% endif %}
{% endfor %}
```

### Include Tag

#### `{% include "filename" %}`

Loads and renders a template from `templates/includes/`.

```liquid
{% include "masthead.html" %}
{% include "read-time.html" %}
```

If the file is not found, outputs: `[Include not found: filename]`

### Assign Tag

#### `{% assign var = expression %}`

Sets a variable in the current scope.

```liquid
{% assign greeting = "Hello" %}
{{ greeting }} {{ page.title }}
```


# Static Assets
---

### Content Directories

- `content/files/` — Copied to `public/files/` as-is
- `content/images/` — Copied to `public/images/` as-is

### Assets Directory

The `assets/` directory at the project root is copied to `public/assets/` as-is. This includes:

- `assets/css/main.css` — Main stylesheet
- `assets/icons/` — Inline SVG icons
- Any JavaScript files
- Any other static resources

### CSS Customization

Edit `assets/css/main.css` to customize the site's appearance. Key CSS variables:

```css
:root {
  --global-base-color: #2f7f93;
  --global-bg-color: #fff;
  --global-footer-bg-color: #f2f3f3;
  --global-border-color: #e8e8e8;
  --global-link-color: #52adc8;
  --global-text-color: #333;
  --global-text-color-light: #7a8288;
}
```

Dark mode is supported via `@media (prefers-color-scheme: dark)`.

# Generated Output
---

The build produces a complete static site in the output directory (`public/` by default).

### File Structure

```
public/
├── index.html                    # Home page
├── 404.html                      # Error page
├── sitemap.xml                   # XML sitemap
├── feed.xml                      # Atom feed
├── assets/                       # CSS, JS, images, icons
│   ├── css/main.css
│   └── icons/                    # Inline SVG icons
├── files/                        # Static files from content/files/
├── images/                       # Images from content/images/
├── <section>/                    # Section index pages
│   └── index.html
├── <collection>/<item>/          # Individual item pages
│   └── index.html
└── <redirect>/                   # Redirect pages
    └── index.html
```

### Sitemap

`sitemap.xml` includes:
- All collection items
- All section index pages
- All standalone pages with permalinks

### Atom Feed

`feed.xml` includes entries from:
- Posts (newest first)
- Publications (newest first)
- Talks (newest first)

Each entry includes title, URL, date, and excerpt.

# Deployment
---

### GitHub Pages

**Option A: CI/CD (recommended)**

The repository includes `.github/workflows/ci.yml` which automatically builds and deploys on every push to `main`:

1. Push to a GitHub repository
2. Go to Settings > Pages
3. Set source to "GitHub Actions"
4. Push to `main` — the site deploys automatically

**Option B: Manual**

1. Push to a GitHub repository
2. Go to Settings > Pages
3. Set source to "Deploy from a branch"
4. Select the branch and `/ (root)` or `/docs` folder
5. The `public/` directory contents should be at the deployment root

### Netlify

Create `netlify.toml`:

```toml
[build]
  command = "cmake -B build && cmake --build build && ./build/pagepp"
  publish = "public"
```

### Any Static Host

1. Build the site: `./build/pagepp`
2. Upload the contents of `public/` to your hosting provider

### Custom Domain

Set `url` in `content/config.toml` to your domain:

```toml
url = "https://yourdomain.com"
```

# Customization Guide
---

### Changing the Color Scheme

Edit CSS variables in `assets/css/main.css`:

```css
:root {
  --global-base-color: #your-brand-color;
  --global-link-color: #your-link-color;
  --global-link-color-hover: #your-hover-color;
}
```

### Adding a New Section

1. Create `content/your-section/`
2. Create `content/your-section/index.md` with frontmatter
3. Add `.md` items to the directory
4. Rebuild

### Modifying the Navigation

Navigation is auto-generated from sections. Control order with `nav_order` in each section's `index.md`.

To customize the navigation HTML, edit `templates/includes/masthead.html`.

### Adding Custom Layouts

1. Create `templates/layouts/my-layout.html`
2. Use `{{ content }}` for the content insertion point
3. Set `layout = "my-layout"` in frontmatter

### Adding Custom Includes

1. Create `templates/includes/my-include.html`
2. Use `{% include "my-include.html" %}` in any template

### Modifying the Footer

Edit `templates/includes/footer.html` to change:
- Social links
- Copyright text
- Footer layout

### Adding Custom Icons

1. Place your SVG file in `assets/icons/`
2. Ensure it has `fill="currentColor"` for theme support
3. Add a corresponding config key in `config.toml`
4. Add the icon block to `templates/includes/footer.html`

# Troubleshooting
---

### Build Fails

**Problem:** CMake configuration fails

**Solution:** Ensure CMake 3.14+ and a C++17 compiler are installed:

```sh
cmake --version
g++ --version  # or clang++ --version
```

### Missing Content

**Problem:** Pages not appearing in output

**Checklist:**
- File has `.md` extension
- Frontmatter is between `+++` delimiters
- File is in the correct directory
- For sections: directory has an `index.md`

### Navigation Not Updating

**Problem:** New section doesn't appear in nav

**Solution:** Rebuild after adding the section:

```sh
./build/pagepp
```

Sections are discovered from the directory structure at build time.

### Template Errors

**Problem:** `Include not found: filename`

**Solution:** Ensure the include file exists in `templates/includes/`. The filename is case-sensitive.

### Empty Pages

**Problem:** Page renders but content is missing

**Checklist:**
- Body content comes after the closing `+++`
- There's a blank line between `+++` and the body
- Content is valid Markdown

### Redirects Not Working

**Problem:** `redirect_from` URLs don't redirect

**Checklist:**
- `redirect_from` is an array: `["/old-url/"]`
- URLs start with `/`
- Rebuild after adding redirects

### CSS Not Loading

**Problem:** Styles appear broken

**Checklist:**
- `assets/css/main.css` exists
- `assets/` directory is at the project root (same level as `content/` and `templates/`)
- Rebuild to copy assets to output

### Feed/Sitemap Issues

**Problem:** `feed.xml` or `sitemap.xml` missing or empty

**Solution:** These are generated during build. Ensure `url` is set in `content/config.toml` and that content files exist.
