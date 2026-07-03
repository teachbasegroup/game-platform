# How the game platform works — in plain language

A guide for the team, no coding knowledge assumed. The technical documents
([PLAN.md](PLAN.md), [DESIGN.md](DESIGN.md), [LOG.md](LOG.md)) say *what* and
*when*; this one explains *how it all fits together* and *why*.

## The one-sentence version

The platform is made of two halves: the **content** (every game, card, and
translation) lives in a database the team edits like a spreadsheet, while the
**code** (how the site looks and behaves) lives in one file that Claude edits
when someone describes a change.

That split is the most important idea in the project. Fixing a typo or adding
a game touches only the database and is live in seconds. Nobody on the team
ever needs to touch code.

## Four services, one job each

| Piece | Job |
|---|---|
| **The app** (`index.html`) | One file of code: layout, buttons, card shuffling, language toggle. Contains no game content — on every visit it asks the database for the current content. |
| **GitHub** (the archive) | Keeps the code and every version of it that ever existed. Any previous version can be restored — nothing is ever irreversibly lost. Public, which is why nothing in it refers to real people or organisations. |
| **Netlify** (the publisher) | Watches GitHub. Whenever the code changes, it automatically publishes the new version to the live site, about a minute later. |
| **Supabase** (the filing cabinet) | The database with all content, in English and German, each row marked draft or published. Edits show up on the live site on the next page load. |

```
team edits content ──▸ Supabase ─────────────┐
                                             ├──▸ the live site
Claude edits code ──▸ GitHub ──▸ Netlify ────┘
```

Two paths, one destination. The content path (top) is instant; the code path
(bottom) takes about a minute.

## What is in the database

Three connected tables — three drawers, where each item points into the next:

- **categories** — the colored tiles on the home screen: title, description, color, order.
- **games** — each belongs to one category; carries the instructions (Setup / How to play / Tip), group size, duration, materials, tags.
- **cards** — the individual prompts inside a deck game, each with an age range.

Every visible text exists **twice** — an English column and a German column.
The language toggle simply picks which column to show.

Every game and card has a status: **draft** (invisible to teachers — safe for
half-finished ideas) or **published**.

In the Supabase dashboard, the **Table Editor** shows these tables as
spreadsheets — the team's editing tool until the app has its own edit mode.

## What SQL is, and what setup.sql does

SQL is the language databases understand — nothing more. A SQL command is a
written instruction to the filing cabinet: *"create a drawer called games"*,
*"put this card into it"*. The SQL Editor in Supabase is the letterbox where
such instructions are dropped.

[`supabase/setup.sql`](supabase/setup.sql) is one long letter containing the
**entire cabinet**: the structure of the three tables, the security rules, and
the original content. Run once in an empty Supabase project, it rebuilds the
whole database — our insurance policy.

## Who may do what

The database distinguishes exactly two kinds of people:

- **Visitors** (anyone opening the site) may *read published content* — nothing
  else. No drafts, no changes.
- **The team** (logged in) may read and change everything.

Two layers enforce this, both in setup.sql. **Grants** decide which tables a
role may open at all (new Supabase projects start with everything locked).
**Row rules** (RLS) then decide which rows inside an open table are visible —
for visitors, only the published ones.

The app carries a so-called **anon key** — a visitor badge baked into the code.
It looks secret but is not: it only opens what the rules allow visitors anyway.
That is why it can safely sit in a public repository.

## Glossary

- **frontend / backend** — what you see and tap (our app) / what stores and protects data behind it (Supabase).
- **repository (repo)** — a folder whose entire history GitHub remembers.
- **push / deploy** — sending code changes to GitHub / Netlify publishing them. Here, a push triggers a deploy automatically.
- **database / table / row** — the filing cabinet / one drawer / one item. One game = one row in the games table.
- **SQL** — the instruction language of databases. Needed for setup and repairs only.
- **anon key** — the public visitor badge in the app; database rules limit what it opens.
- **RLS (row level security)** — the database's house rules: who may see or change which rows.
- **draft / published** — the visibility switch on every game and card.
- **seed** — the starting content poured into a fresh database (the bottom half of setup.sql).
