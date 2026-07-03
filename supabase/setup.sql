-- ═══════════════════════════════════════════════════════════════════
-- TeachBase Game Library — Supabase setup
--
-- Run this ONCE in a fresh Supabase project:
-- Dashboard → SQL Editor → New query → paste everything → Run.
-- It creates the three content tables, the security rules, and
-- inserts all content that used to live inside index.html.
-- ═══════════════════════════════════════════════════════════════════

-- ── Tables ──
-- Every visible text exists twice: *_en and *_de.

create table categories (
  id         text primary key,          -- slug, e.g. 'energizer'
  sort_order int  not null,
  color      text not null check (color in ('red','blue','yellow','green','purple')),
  title_en   text not null,
  title_de   text not null,
  desc_en    text,
  desc_de    text
);

create table games (
  id           text primary key,        -- slug, e.g. 'human-robot'
  category_id  text not null references categories(id),
  sort_order   int  not null default 0,
  type         text not null check (type in ('deck','activity')),
  status       text not null default 'draft' check (status in ('draft','published')),
  title_en     text not null,
  title_de     text not null,
  subtitle_en  text,
  subtitle_de  text,
  size_en      text,                    -- group size, e.g. '3–15'
  size_de      text,
  time_en      text,                    -- duration, e.g. '5–10 min'
  time_de      text,
  materials_en text,
  materials_de text,
  age          text check (age in ('6-8','9-12','all')),  -- activities only; decks set age per card
  tags         text[] not null default '{}',
  setup_en     text,
  setup_de     text,
  how_en       text,
  how_de       text,
  tip_en       text,
  tip_de       text
);

create table cards (
  id         bigint generated always as identity primary key,
  game_id    text not null references games(id),
  sort_order int  not null default 0,
  status     text not null default 'draft' check (status in ('draft','published')),
  age        text not null default 'all' check (age in ('6-8','9-12','all')),
  text_en    text not null,
  text_de    text not null,
  hint_en    text,
  hint_de    text
);

-- ── Access grants ──
-- Newer Supabase projects grant no table access by default. The roles need
-- table-level access first; the row rules (RLS) below then narrow it down.

grant usage on schema public to anon, authenticated;
grant select on categories, games, cards to anon;
grant select, insert, update, delete on categories, games, cards to authenticated;
grant usage, select on all sequences in schema public to authenticated;

-- ── Security (Row Level Security) ──
-- Anonymous visitors: read-only, published rows only.
-- Logged-in team members: full access (used by the edit mode, build step 5).

alter table categories enable row level security;
alter table games      enable row level security;
alter table cards      enable row level security;

create policy "anon reads categories"      on categories for select to anon using (true);
create policy "anon reads published games" on games      for select to anon using (status = 'published');
create policy "anon reads published cards" on cards      for select to anon using (status = 'published');

create policy "team full access categories" on categories for all to authenticated using (true) with check (true);
create policy "team full access games"      on games      for all to authenticated using (true) with check (true);
create policy "team full access cards"      on cards      for all to authenticated using (true) with check (true);

-- ── Seed: all existing content ──

insert into categories (id, sort_order, color, title_en, title_de, desc_en, desc_de) values
  ('prompt', 1, 'yellow', 'Q&A / Prompt Games', 'Frage- & Kartenspiele', 'Draw a card, read it aloud.', 'Karte ziehen, laut vorlesen.');

insert into games (id, category_id, sort_order, type, status, title_en, title_de, subtitle_en, subtitle_de,
  size_en, size_de, time_en, time_de, materials_en, materials_de, age, tags,
  setup_en, setup_de, how_en, how_de, tip_en, tip_de) values
  ('would-you-rather', 'prompt', 1, 'deck', 'published', 'Would You Rather', 'Würdest du lieber …', 'Engineering Edition', 'Engineering-Edition',
  'any', 'beliebig', '2–10 min', '2–10 Min', 'nothing', 'nichts', null, array['break', 'waiting', 'trickle-in', 'cooldown']::text[],
  'Nothing to prepare. Decide how kids vote: move to the two sides of the room, raise hands, or shout.', 'Nichts vorzubereiten. Entscheide, wie abgestimmt wird: auf zwei Seiten des Raums stellen, Hand heben oder rufen.', 'Read the prompt aloud. Kids choose A or B. Ask 1–2 kids WHY. Keep it fast — about one prompt per minute.', 'Lies die Frage laut vor. Die Kinder wählen A oder B. Frag 1–2 Kinder nach dem WARUM. Halt das Tempo hoch — etwa eine Frage pro Minute.', 'If it gets rowdy, switch to silent vote — eyes closed, raise hands. Works great post-lunch.', 'Wenn es zu wild wird: stille Abstimmung — Augen zu, Hand heben. Funktioniert super nach dem Mittagessen.');

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('would-you-rather', 1, 'published', '6-8', 'Have a robot dog that only barks in music
— or —
A cat that glows in the dark', 'Einen Roboterhund haben, der nur in Musik bellt
— oder —
Eine Katze, die im Dunkeln leuchtet', null, null);

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('would-you-rather', 2, 'published', '6-8', 'Have shoes that make you jump super high
— or —
Gloves that make you super strong', 'Schuhe haben, mit denen du super hoch springen kannst
— oder —
Handschuhe, die dich super stark machen', null, null);

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('would-you-rather', 3, 'published', '6-8', 'Live in a treehouse with a slide to the ground
— or —
Live underwater in a bubble house', 'In einem Baumhaus mit Rutsche bis zum Boden wohnen
— oder —
Unter Wasser in einem Blasenhaus wohnen', null, null);

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('would-you-rather', 4, 'published', '6-8', 'Have a backpack that never runs out of snacks
— or —
A pencil that draws things that become real', 'Einen Rucksack haben, in dem die Snacks nie ausgehen
— oder —
Einen Stift, dessen Zeichnungen echt werden', null, null);

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('would-you-rather', 5, 'published', '9-12', 'Be able to fly but only 20cm off the ground
— or —
Be invisible but only when nobody is looking', 'Fliegen können, aber nur 20 cm über dem Boden
— oder —
Unsichtbar sein, aber nur wenn niemand hinschaut', null, null);

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('would-you-rather', 6, 'published', '9-12', 'Have a 3D printer that takes 1 week per print
— or —
A printer that prints money but only 1 cent at a time', 'Einen 3D-Drucker haben, der 1 Woche pro Druck braucht
— oder —
Einen Drucker, der Geld druckt, aber nur 1 Cent auf einmal', null, null);

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('would-you-rather', 7, 'published', '9-12', 'Know every programming language but forget how to write by hand
— or —
Write beautifully but never use a computer again', 'Jede Programmiersprache können, aber das Schreiben mit der Hand vergessen
— oder —
Wunderschön schreiben, aber nie wieder einen Computer benutzen', null, null);

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('would-you-rather', 8, 'published', '9-12', 'Have a time machine that only goes 5 minutes into the future
— or —
A teleporter that only works to places you''ve already been', 'Eine Zeitmaschine haben, die nur 5 Minuten in die Zukunft reist
— oder —
Einen Teleporter, der nur zu Orten funktioniert, an denen du schon warst', null, null);

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('would-you-rather', 9, 'published', 'all', 'Build anything but it falls apart after one day
— or —
Build only one thing ever but it lasts forever', 'Alles bauen können, aber es zerfällt nach einem Tag
— oder —
Nur ein einziges Ding bauen dürfen, aber es hält für immer', null, null);

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('would-you-rather', 10, 'published', 'all', 'Have a robot that does your homework but sometimes gets it wrong
— or —
Do all homework yourself but finish in half the time', 'Einen Roboter haben, der deine Hausaufgaben macht, aber manchmal Fehler einbaut
— oder —
Alle Hausaufgaben selbst machen, aber in der halben Zeit fertig sein', null, null);

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('would-you-rather', 11, 'published', 'all', 'Invent something that makes people laugh every day
— or —
Invent something that saves one person''s life once', 'Etwas erfinden, das Menschen jeden Tag zum Lachen bringt
— oder —
Etwas erfinden, das einmal einem Menschen das Leben rettet', null, null);

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('would-you-rather', 12, 'published', 'all', 'Have a bike that drives itself but only at walking speed
— or —
A skateboard that goes super fast but you can''t steer it', 'Ein Fahrrad haben, das von selbst fährt, aber nur im Schritttempo
— oder —
Ein Skateboard, das super schnell fährt, aber nicht lenkbar ist', null, null);

insert into games (id, category_id, sort_order, type, status, title_en, title_de, subtitle_en, subtitle_de,
  size_en, size_de, time_en, time_de, materials_en, materials_de, age, tags,
  setup_en, setup_de, how_en, how_de, tip_en, tip_de) values
  ('what-am-i', 'prompt', 2, 'deck', 'published', 'What Am I?', 'Was bin ich?', 'Engineering Edition', 'Engineering-Edition',
  '3–15', '3–15', '5–10 min', '5–10 Min', 'nothing', 'nichts', null, array['break', 'waiting', 'team builder']::text[],
  'Draw a card and keep the answer secret. For younger kids, announce the category (machines and inventions).', 'Zieh eine Karte und halte die Antwort geheim. Bei jüngeren Kindern: Sag die Kategorie an (Maschinen und Erfindungen).', 'Kids ask yes/no questions to guess what you are. Maximum 20 questions. Whoever guesses correctly picks the next round.', 'Die Kinder stellen Ja/Nein-Fragen, um zu erraten, was du bist. Maximal 20 Fragen. Wer richtig rät, wählt die nächste Runde.', 'Engineering twist — only allow machines and inventions.', 'Engineering-Variante — nur Maschinen und Erfindungen erlaubt.');

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('what-am-i', 1, 'published', '6-8', 'A traffic light', 'Eine Ampel', 'I have three colors and I tell you when to stop', 'Ich habe drei Farben und sage dir, wann du stehen bleiben musst');

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('what-am-i', 2, 'published', '6-8', 'A bridge', 'Eine Brücke', 'I help you cross something you can''t walk through', 'Ich helfe dir, etwas zu überqueren, durch das du nicht gehen kannst');

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('what-am-i', 3, 'published', '9-12', 'An algorithm', 'Ein Algorithmus', 'I''m a set of steps that solves a problem the same way every time', 'Ich bin eine Folge von Schritten, die ein Problem jedes Mal gleich löst');

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('what-am-i', 4, 'published', '9-12', 'A gear', 'Ein Zahnrad', 'I have teeth but I don''t eat. I spin to make other things move', 'Ich habe Zähne, aber ich esse nicht. Ich drehe mich, damit andere Dinge sich bewegen');

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('what-am-i', 5, 'published', 'all', 'Wi-Fi', 'WLAN', 'You can''t see, touch, or hear me — but you get very upset when I''m gone', 'Du kannst mich nicht sehen, anfassen oder hören — aber du bist sehr sauer, wenn ich weg bin');

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('what-am-i', 6, 'published', 'all', 'A battery', 'Eine Batterie', 'I store something invisible and share it when you need me, but I get tired', 'Ich speichere etwas Unsichtbares und teile es, wenn du mich brauchst — aber ich werde müde');

insert into games (id, category_id, sort_order, type, status, title_en, title_de, subtitle_en, subtitle_de,
  size_en, size_de, time_en, time_de, materials_en, materials_de, age, tags,
  setup_en, setup_de, how_en, how_de, tip_en, tip_de) values
  ('open-questions', 'prompt', 3, 'deck', 'published', 'Open Questions', 'Offene Fragen', null, null,
  'any', 'beliebig', '3–10 min', '3–10 Min', 'nothing', 'nichts', null, array['break', 'get-to-know', 'cooldown', 'waiting']::text[],
  'Nothing to prepare. Sit in a circle if you can.', 'Nichts vorzubereiten. Wenn möglich, setzt euch in einen Kreis.', 'Draw a card, read the question aloud. Everyone answers — around the circle or popcorn style. No wrong answers. Follow up with "why?" to keep it going.', 'Zieh eine Karte und lies die Frage vor. Alle antworten — reihum oder kreuz und quer. Es gibt keine falschen Antworten. Hak mit einem "Warum?" nach.', 'Great for quieter moments. Let kids take their time — silence is ok.', 'Super für ruhigere Momente. Lass den Kindern Zeit — Stille ist okay.');

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('open-questions', 1, 'published', 'all', 'What object would you like to be for 24 hours and why?', 'Welcher Gegenstand wärst du gern für 24 Stunden — und warum?', null, null);

insert into categories (id, sort_order, color, title_en, title_de, desc_en, desc_de) values
  ('energizer', 2, 'red', 'Energizers', 'Energizer', 'Wake up, get moving.', 'Aufwachen, in Bewegung kommen.');

insert into games (id, category_id, sort_order, type, status, title_en, title_de, subtitle_en, subtitle_de,
  size_en, size_de, time_en, time_de, materials_en, materials_de, age, tags,
  setup_en, setup_de, how_en, how_de, tip_en, tip_de) values
  ('human-robot', 'energizer', 1, 'activity', 'published', 'Human Robot', 'Mensch-Roboter', null, null,
  'pairs', 'Paare', '3–5 min', '3–5 Min', 'nothing', 'nichts', 'all', array['in-class', 'energy burn', 'team builder']::text[],
  'Kids pair up. Set up a simple obstacle or a target to navigate to.', 'Die Kinder bilden Paare. Bau ein kleines Hindernis auf oder wähle ein Ziel, das angesteuert wird.', 'One kid is the "programmer", the other is the "robot". The programmer gives movement commands: forward 3 steps, turn left, pick up. The robot follows ONLY exact commands — nothing more, nothing less. Swap roles after 2 minutes.', 'Ein Kind ist Programmierer:in, das andere der Roboter. Es gibt Bewegungsbefehle: drei Schritte vor, links drehen, aufheben. Der Roboter befolgt NUR exakte Befehle — nicht mehr, nicht weniger. Nach 2 Minuten werden die Rollen getauscht.', 'Directly teaches programming logic. "The robot did the wrong thing" — "No, your code had a bug!"', 'Vermittelt direkt Programmierlogik. "Der Roboter hat das Falsche gemacht" — "Nein, dein Code hatte einen Bug!"');

insert into categories (id, sort_order, color, title_en, title_de, desc_en, desc_de) values
  ('focus', 3, 'blue', 'Calm-down / Focus', 'Ruhe & Fokus', 'Reset attention, create quiet.', 'Aufmerksamkeit zurückholen, Ruhe schaffen.');

insert into games (id, category_id, sort_order, type, status, title_en, title_de, subtitle_en, subtitle_de,
  size_en, size_de, time_en, time_de, materials_en, materials_de, age, tags,
  setup_en, setup_de, how_en, how_de, tip_en, tip_de) values
  ('silent-countdown', 'focus', 1, 'activity', 'published', 'Silent Countdown', 'Stiller Countdown', null, null,
  '4+', '4+', '2–3 min', '2–3 Min', 'nothing', 'nichts', 'all', array['focus reset', 'transition', 'cooldown']::text[],
  'The group stands or sits so everyone can hear each other. Nothing else to prepare.', 'Die Gruppe steht oder sitzt so, dass alle einander hören. Sonst nichts vorzubereiten.', 'The group counts to 20 — one person at a time, no set order, no signals. If two people speak at the same time, restart from 1. Eyes closed makes it harder. Track the group''s best score across camp days.', 'Die Gruppe zählt bis 20 — immer nur eine Person, keine feste Reihenfolge, keine Zeichen. Sprechen zwei gleichzeitig, geht es zurück auf 1. Mit geschlossenen Augen wird es schwieriger. Haltet den Gruppenrekord über die Camp-Tage fest.', 'Perfect post-lunch reset. Gets quiet fast. Kids love beating their record.', 'Perfekter Reset nach dem Mittagessen. Wird schnell leise. Kinder lieben es, ihren Rekord zu knacken.');

insert into games (id, category_id, sort_order, type, status, title_en, title_de, subtitle_en, subtitle_de,
  size_en, size_de, time_en, time_de, materials_en, materials_de, age, tags,
  setup_en, setup_de, how_en, how_de, tip_en, tip_de) values
  ('clap-pattern', 'focus', 2, 'activity', 'published', 'Clap Pattern', 'Klatsch-Muster', null, null,
  'any', 'beliebig', '1–2 min', '1–2 Min', 'nothing', 'nichts', 'all', array['focus reset', 'transition']::text[],
  'Nothing to prepare.', 'Nichts vorzubereiten.', 'Clap a rhythm pattern. The group repeats it. Each round gets more complex. Double use as your attention signal: you clap a pattern, kids stop what they''re doing and repeat it back.', 'Klatsche einen Rhythmus vor. Die Gruppe wiederholt ihn. Jede Runde wird komplexer. Doppelnutzen als Aufmerksamkeitssignal: Du klatschst ein Muster, die Kinder stoppen und klatschen es zurück.', 'Establish this Day 1 as YOUR signal. By Day 3 you never need to raise your voice.', 'Etabliere das an Tag 1 als DEIN Signal. Ab Tag 3 musst du nie wieder laut werden.');

insert into categories (id, sort_order, color, title_en, title_de, desc_en, desc_de) values
  ('team', 4, 'green', 'Team / Cooperation', 'Team & Kooperation', 'Communication, trust, working together.', 'Kommunikation, Vertrauen, Zusammenarbeit.');

insert into games (id, category_id, sort_order, type, status, title_en, title_de, subtitle_en, subtitle_de,
  size_en, size_de, time_en, time_de, materials_en, materials_de, age, tags,
  setup_en, setup_de, how_en, how_de, tip_en, tip_de) values
  ('storytelling-chain', 'team', 1, 'activity', 'published', 'Storytelling Chain', 'Geschichten-Kette', null, null,
  '3+', '3+', '3–8 min', '3–8 Min', 'nothing', 'nichts', 'all', array['break', 'waiting', 'cooldown']::text[],
  'Sit in a circle. Agree on the starting sentence.', 'Setzt euch in einen Kreis. Einigt euch auf den Startsatz.', 'Start with: "I built a robot that…". The next kid adds one sentence. Keep going around the circle. Engineering version: each addition must include a technical element — a sensor, a material, a mechanism.', 'Beginne mit: "Ich habe einen Roboter gebaut, der …". Das nächste Kind ergänzt einen Satz, immer weiter im Kreis. Engineering-Version: Jede Ergänzung braucht ein technisches Element — einen Sensor, ein Material, einen Mechanismus.', 'Shy kids can pass once but they''re next after. Dominant kids get a strict one-sentence limit.', 'Schüchterne Kinder dürfen einmal passen, sind danach aber dran. Dominante Kinder bekommen ein striktes Ein-Satz-Limit.');

insert into categories (id, sort_order, color, title_en, title_de, desc_en, desc_de) values
  ('gettoknow', 5, 'purple', 'Get-to-know', 'Kennenlernen', 'First encounters, learning names.', 'Erstes Kennenlernen, Namen lernen.');
