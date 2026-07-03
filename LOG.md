# Project Log

Plain-language diary of this project — what changed and why, newest first.
One entry per work session. Update this with every substantial change.

---

## 2026-07-03 (later) — Edit mode

- The app now has a built-in **edit mode**: a quiet "edit" link in the footer
  leads to a team sign-in (Supabase Auth, email + password). Signed in, the
  team can add and edit games, manage a deck's cards (add / edit / delete /
  publish), flip anything between **draft** and **published**, and delete
  games. Drafts show with a dashed badge and stay invisible to teachers.
- Team accounts are created in the Supabase dashboard (Authentication →
  Users). **Public sign-ups must stay disabled** there — the database rules
  give every signed-in account full write access, so who gets an account is
  the entire access control.
- New games get their web address (slug) generated from the English title;
  new games and cards start as drafts on purpose.
- Verified headless: visitor flow unchanged (deck player click-through),
  login form appears, wrong password shows the proper bilingual error.
  Authenticated write flows tested live after the first team account existed.

---

## 2026-07-03 — Content moves to the database (Supabase)

- All game content now lives in **Supabase** instead of inside the code:
  three tables (`categories` → `games` → `cards`), every text in EN and DE,
  each game/card with a **draft/published** status so half-finished content
  stays invisible to teachers.
- Security via database rules (RLS): anonymous visitors can only *read
  published* rows; changing anything requires a team login (the basis for
  the edit mode, next step).
- `supabase/setup.sql` holds the whole database — structure, security rules,
  and all content migrated out of `index.html`. Running it once in a fresh
  Supabase project rebuilds everything.
- The app fetches content on load and shows proper loading/error states.
  Verified in a headless browser against a simulated database: home,
  category, deck player, and the error screen all render correctly.
- Detours worth remembering: newer Supabase projects grant no table access
  by default (fixed with explicit grants, now part of setup.sql), and the SQL
  editor was briefly pointed at a wrong/empty second project — if table counts
  ever look wrong, check the project ID in the browser address bar first.
- Wired the project URL + anon key into `index.html`, click-tested the real
  app against the real database, deployed. The site now runs on Supabase:
  content edits in the dashboard are live on next page load.
- Added `HOW-IT-WORKS.md` — the whole setup in plain language for the team.
  (Deeper technical companion lives as a Claude artifact, "Under the hood".)

## 2026-07-02 (evening) — Bilingual app, structured instructions, design rules

- Every text in the app now exists in **English and German** (du-form). Language
  toggle in the header, German is the default, choice is remembered per device.
  Decided against browser auto-translate: it breaks React apps mid-click and the
  quality is uncontrollable — stored, correctable translations instead.
- Game instructions restructured from one text blob into three labeled sections:
  **Setup / How to play / Tip** (Vorbereitung / So geht's / Tipp).
- Fixed: the reshuffle button only jumped back to card 1 instead of actually
  reshuffling the deck.
- Cards now scale up on larger screens so they stay readable when projected
  over a beamer.
- Design system locked in: tokens (`COLOR`, `FONT`, `TYPE`) at the top of
  `index.html` and rules in `DESIGN.md`. Favicon added, copy pass done.
- Internally the content is shaped exactly like the planned database tables,
  so the upcoming migration is a straight copy.

## 2026-07-02 (afternoon) — Repo, hosting, go-live

- Created the GitHub organization **teachbasegroup** (owns the code; people join
  with their own accounts — no shared logins).
- Repo `game-platform` created and pushed; site connected to **Netlify**:
  every change to the repo deploys automatically to
  **https://game-plattform.netlify.app** (~1 min).
- Made the repo **public** (Netlify's free tier doesn't build private
  organization repos). Before that, scrubbed all organisation and personal
  references and rewrote git history so none of it was ever published —
  brand is now **TeachBase**. Rule going forward: nothing in this repo links
  to real people or organisations.
- Verified live on phone and laptop.

## 2026-07-01/02 — Planning

- Decided scope: the game library only. The teaching simulator is a separate
  project. A kids-contribution mode was considered and cut.
- Requirements: maintainable by non-coders (edit mode is committed scope, not
  optional), bilingual EN/DE, works on phone and on laptop + beamer.
- Stack chosen: single-file React app · Supabase (content database, spreadsheet-
  like dashboard) · GitHub (code + history) · Netlify (hosting + auto-deploy).
- Data model drafted: categories → games → cards, all text EN+DE, with a
  draft/published status. Security: database rules (RLS) — public can only read
  published rows; writing requires a team login.
- Full plan in [PLAN.md](PLAN.md), design rules in [DESIGN.md](DESIGN.md).

---

**Next:** paste Supabase credentials + run setup.sql (see 2026-07-03 entry),
then the in-app edit mode for the team, then a DeepL auto-translate button
for new content.
