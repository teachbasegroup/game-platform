# TeachBase Game Platform — Project Plan

*Written July 2026 · revised after scope corrections*

## Goal

Turn the game library prototype into a hosted, bilingual (EN/DE) game platform
that the core team can maintain **without coding** — including a built-in edit mode.

The Teaching Simulator is a **separate project** with its own folder, repo, and plan.
Nothing in this document covers it.

**Definition of done:** a teacher on a phone gets from the URL to a shuffled game card
in under 30 seconds, in German and in English — and the same card, projected over a
beamer from a laptop, is readable from the back of the room.

## Users

| Who | Situation | Needs |
|---|---|---|
| Teacher | Phone, loud room, mid-camp | Find a fitting game fast; clear instructions; shuffle cards |
| Teacher (presenting) | Laptop + beamer, group watching the screen | Large, room-readable cards; comfortable at desktop size |
| Admin (core team) | Desk, keyboard | Add/edit games and cards in the app's edit mode; fix typos; manage translations |

## Folder structure

```
~/Projects/
  game-platform/             ← this project = one GitHub repo
    index.html               ← the app
    PLAN.md                  ← this document
    DESIGN.md                ← design rules (written in step 4)
    README.md                ← what this is + how to maintain it
  teaching-simulator/        ← later: its own repo and its own plan
```

Organisational documents stay on the local machine, outside the repo.
Code lives in `~/Projects`. The duplicate copies in Downloads can be deleted.

## Stack and why

- **App:** single HTML file, React via CDN (as now) — easy to reason about, easy to vibe-code later.
- **Content:** **Supabase** (free hosted database). Content changes are live instantly, no deploy.
- **Code:** **GitHub** — version history, nothing is ever irreversibly broken; also what
  Claude edits when the team vibe-codes new features.
- **Hosting:** **Netlify** — serves the app at a real URL; redeploys automatically on every
  GitHub change (~1 min).

```
Team edits content →  Supabase ─┐
                                ├→ what teachers see at the URL
Claude edits code  →  GitHub → Netlify
```

## Order of work — why deploy before restructuring

Deploying is not publishing: the URL is unknown to everyone, it's a workbench, and it stays
the same URL through every later step. Deploy-first (a "walking skeleton") because:

1. **One variable at a time.** The pipeline is proven with an app we know works. When a
   later step breaks something, there is exactly one suspect: the change we just made —
   not the hosting setup.
2. **From step 2 onward, the real URL is the only truth.** Once the app loads content from
   Supabase over the network, opening the file directly from disk behaves differently than
   the hosted version. We need the deployed environment to test against *during* the build.
3. Nothing is thrown away — the deployed app is the one we keep editing, not a disposable copy.

## German / languages

- NOT browser Google Translate (it crashes React apps mid-click).
- Built-in EN/DE toggle; every text field exists twice in the database.
- Claude translates all existing content once during the build; team corrects wording anytime.
- New content: DeepL auto-translate button in the edit mode (step 6), until then copy-paste
  from deepl.com.

## Data model (draft — confirm at session start)

- `categories`: title EN/DE, description EN/DE, color, sort order
- `games`: → category, title EN/DE, type (deck | activity), setup EN/DE, how-to-play EN/DE,
  tip EN/DE, group size, duration, materials, ages, tags, status
- `cards`: → game, text EN/DE, hint EN/DE, age range, status

`status` (draft | published) exists so the team can save half-finished games in the edit
mode without teachers seeing them.

## Security & privacy

- Content is public to read — only rows with `status = published` are visible.
- The database key inside the app code is public by nature; the real lock is Supabase
  **Row Level Security**: anonymous visitors read published rows only, writes require
  a team login (edit mode).
- No personal data stored. GDPR footprint ≈ zero.
- Backups: Supabase daily automatic.

## Design rules

Keep the existing editorial look and systematize it:

- Georgia serif for content, Courier mono for labels. No new fonts.
- Color only carries meaning (categories, ages) — never decoration. No gradients, no emoji-as-icons.
- Spacing in multiples of 8px; one 5-step type scale; one button style, one card style.
- Layout scales from phone width to a beamer-projected laptop screen; the card view gets a
  large presentation size readable across a room.
- Copy: calm, warm, short sentences, no exclamation marks. German uses *du*.
- Details: favicon, page title, loading + empty states, thumb-sized tap targets.
- These rules go into a `DESIGN.md` in the repo so future vibe-coding preserves the style.

**Reference:** sessionlab.com/library — card/filter/metadata structure for an activity library.

## Build plan

| Step | What | Time |
|---|---|---|
| 0 | Accounts: GitHub, Netlify, Supabase | ✓ done |
| 1 | Folder structure + GitHub repo + first Netlify deploy → live URL | ✓ done |
| 2 | Supabase tables per data model, migrate all content, app reads from DB | 1–1.5 h |
| 3 | EN/DE toggle + translate all existing content | ✓ done (in code; moves to DB in step 2) |
| 4 | Instructions layout (Setup / How to play / Tip), reshuffle bug, design tokens, beamer-friendly card size, DESIGN.md | ✓ done |
| 5 | **Edit mode (committed):** team login, add/edit games & cards, draft → publish | 1.5–2 h |
| 6 | *If time:* DeepL auto-translate button in the edit mode | 30 min |

Remaining scope: steps 2, 5, 6 (~2.5–3 h; needs the Supabase login in the browser).
Until the edit mode exists, the Supabase dashboard covers content editing.

Known content gaps (fill anytime once live): "Open Questions" has 1 card,
"Get-to-know" category is empty.

## Later / parking lot

- DeepL button (if step 6 didn't happen)
- Printable card sheets (a static predecessor exists locally)
- Teaching Simulator → separate project, own plan
