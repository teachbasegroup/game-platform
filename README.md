# Cellform Game Platform

Bilingual (EN/DE) game library for teachers running kids' tech and engineering
camps and classes: break games, energizers, focus and team activities — with
rules, tips, and shuffled prompt cards.

- **Live site:** https://game-plattform.netlify.app
- **Plan:** see [PLAN.md](PLAN.md)
- **Design rules:** see DESIGN.md (added in build step 4)

## How it works

One HTML file (`index.html`) built with React, served by Netlify.
Game content lives in Supabase and is edited by the core team —
either in the app's edit mode or the Supabase dashboard. Content
changes are live immediately; code changes deploy automatically
(~1 min) whenever this repository changes.

The database structure (tables, security rules, original content) is
documented in [supabase/setup.sql](supabase/setup.sql) — that file can
rebuild the whole database in a fresh Supabase project if ever needed.

## Maintaining

- **Content** (games, cards, translations): use the app's edit mode. No coding.
- **Features/design**: edit `index.html` directly, following PLAN.md and DESIGN.md.
