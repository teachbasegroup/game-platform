# Project Log

Plain-language diary of this project — what changed and why, newest first.
One entry per work session. Update this with every substantial change.

---

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

**Next:** Supabase database (content moves out of the code), then the in-app
edit mode for the team, then a DeepL auto-translate button for new content.
