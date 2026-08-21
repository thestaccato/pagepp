+++
permalink = "/"
title = "PagePP - A Suckless Static Site Generator"
+++
---
PagePP is a C++17 static site generator. It reads Markdown content with TOML frontmatter, processes it through a Liquid-compatible template engine, and outputs a complete static HTML site. No runtime dependencies, no JavaScript, no network required at build time.

Use it for personal websites, project documentation, blogs, academic portfolios, or anything that needs clean static HTML.

# Why PagePP?
---

**Zero runtime dependencies.** No Ruby, no Node.js, no Python required to run the binary. A single C++ executable handles everything. Build once, run anywhere.

**Zero JavaScript.** The generated site contains no JavaScript whatsoever. No analytics trackers, no comment widgets, no font loaders, no framework hydration. Pure HTML and CSS.

**Instant builds.** Near-instantaneous — typically milliseconds for a full site rebuild. No cold starts, no gem installs, no npm install.

**TOML over YAML.** TOML is unambiguous and designed for configuration. Frontmatter uses `+++` delimiters instead of fragile `---`.

**Single config file.** One `content/config.toml`. No split config across multiple files and formats.

**Full content control.** You write the content, pagepp renders it. No surprise generated pages, no auto-archived listings you didn't ask for.

**Auto-derived navigation.** Sections discovered from directory structure. Order with `nav_order` in frontmatter. No navigation YAML file to maintain.

**Portable deployment.** Outputs a static `public/` directory. Upload anywhere — GitHub Pages, Netlify, any static host.

**Same template syntax as Jekyll.** Liquid-compatible templates: `{% if %}`, `{% for %}`, `{{ variable }}` all work as expected.

**Offline builds.** Dependencies (cmark, tomlplusplus) are fetched once via CMake and cached. Subsequent builds work fully offline.

**Privacy-first.** No third-party scripts, no CDN requests, no telemetry. Your visitors are not tracked.

**Minimal attack surface.** Zero JavaScript, only static HTML/CSS. No XSS through plugins, no supply chain attacks, no outdated jQuery vulnerabilities.

**Fastest possible page loads.** No JavaScript to parse, compile, and execute. Lighthouse scores are perfect by default. Your content loads immediately on any device.

**Works everywhere.** Plain HTML and CSS. Every browser, every screen reader, every text-only browser, every low-bandwidth connection.

**Built-in academic support.** Publications with citation metadata, talks with slides, teaching with course info, social links for Google Scholar, ORCID, PubMed. Optional — ignore it if you don't need it.

### Key Features

- **Zero runtime deps** — Single-pass C++ build, no runtime dependencies
- **TOML frontmatter** — Uses `+++` delimiters with TOML (not YAML)
- **Liquid-compatible templates** — Variables, filters, conditionals, loops, includes, layout inheritance
- **Responsive design** — Mobile-friendly with dark mode support
- **Auto-generated** — Sitemap, Atom feed, and redirects handled automatically
- **Zero config** — Sections auto-discovered from directory structure
- **Dev server** — `pagepp serve` with auto-rebuild on file changes

### Dependencies

You need a C++17 compiler (GCC, Clang, or MSVC), CMake 3.14+, and Git. Two libraries (cmark and tomlplusplus) are fetched automatically at build time via CMake FetchContent — no manual installation required.

### Quick Links

- **[Documentation](/documentation/)** — Full installation, configuration, and reference guide
- **[GitHub](https://github.com/thestaccato/pagepp)** — Source code and issue tracker
