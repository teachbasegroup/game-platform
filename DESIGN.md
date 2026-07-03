# Design Rules

Read this before changing any UI. The look is **editorial handbook**: a well-typeset
teacher's field guide, friendly through warm copy and meaningful color — never through
decoration. All tokens live at the top of `index.html` (`COLOR`, `FONT`, `TYPE`).
Build new UI from them; do not invent new values.

## Typography

- **Georgia (serif)** for all content text. **Courier (mono)** for labels, metadata,
  and small-caps captions. No other fonts, ever.
- Type scale (px): 11 label · 13 meta · 15 body · 20 h2 · 24 h1. No other sizes.
  Exception: the game card scales fluidly (`clamp`) so it stays readable when
  projected over a beamer.

## Color

- Black on white. Five accent colors, and **color only carries meaning**:
  category identity, age ranges. If a color would be decorative, use black/gray.
- No gradients. No shadows. No emoji as icons. The pixel squares in header/footer
  are the only ornament.

## Layout & spacing

- All spacing in multiples of 8px.
- One content column, max-width 640, left-aligned.
- Thin borders (1–2px), 2–4px corner radius, 4px color-coded top/left bars.
- Tap targets at least 40px tall — teachers use phones with one hand.
- Must work from phone width up to a beamer-projected laptop screen.

## Components

One button style (`Btn`), one tile style (`.tile`), one label style (`label`),
one instruction block (`Instructions`: Setup / How to play / Tip). New screens are
assembled from these. If a new component is unavoidable, it follows the same rules.

## Voice

- Calm, warm, short sentences. No exclamation marks. Address a tired teacher at
  1pm in a hot room.
- Every string exists in EN and DE. German uses **du**, natural spoken Austrian
  German over stiff textbook phrasing.
- Empty states are friendly and plain: "No games yet." — never "Oops!"

## Identity

- Brand is **Cellform** (working title until the team settles the name). No organisation names, no locations, no personal names
  anywhere in code, content, commits, or docs. This repo is public.
