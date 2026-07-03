-- ═══════════════════════════════════════════════════════════════════
-- Cellform Game Library — Supabase setup
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
  age          text check (age in ('4-6','6-10','11-14','all')),  -- activities only; decks set age per card
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
  age        text not null default 'all' check (age in ('4-6','6-10','11-14','all')),
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
  'Nothing to prepare. Decide how kids vote: first option arm up, second option arm down — or, more active, the group lines up in the middle and steps to one side for the first option, to the other for the second.', 'Nichts vorzubereiten. Entscheide, wie abgestimmt wird: erste Option Arm hoch, zweite Option Arm runter — oder aktiver: Die Gruppe stellt sich in einer Linie in der Mitte auf und macht einen Schritt zur einen Seite für die erste Option, zur anderen für die zweite.', 'Read the prompt aloud. Kids vote. Ask 1–2 kids WHY.', 'Lies die Frage laut vor. Die Kinder stimmen ab. Frag 1–2 Kinder nach dem WARUM.', 'If it gets rowdy, switch to silent vote — eyes closed, raise hands. Works great post-lunch.', 'Wenn es zu wild wird: stille Abstimmung — Augen zu, Hand heben. Funktioniert super nach dem Mittagessen.');

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('would-you-rather', 1, 'published', '4-6', 'Have a robot dog that only barks in music
— or —
A cat that glows in the dark', 'Einen Roboterhund haben, der nur in Musik bellt
— oder —
Eine Katze, die im Dunkeln leuchtet', null, null);

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('would-you-rather', 2, 'published', '4-6', 'Have shoes that make you jump super high
— or —
Gloves that make you super strong', 'Schuhe haben, mit denen du super hoch springen kannst
— oder —
Handschuhe, die dich super stark machen', null, null);

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('would-you-rather', 3, 'published', '4-6', 'Live in a treehouse with a slide to the ground
— or —
Live underwater in a bubble house', 'In einem Baumhaus mit Rutsche bis zum Boden wohnen
— oder —
Unter Wasser in einem Blasenhaus wohnen', null, null);

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('would-you-rather', 4, 'published', '4-6', 'Have a backpack that never runs out of snacks
— or —
A pencil that draws things that become real', 'Einen Rucksack haben, in dem die Snacks nie ausgehen
— oder —
Einen Stift, dessen Zeichnungen echt werden', null, null);

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('would-you-rather', 5, 'published', '6-10', 'Be able to fly but only 20cm off the ground
— or —
Be invisible but only when nobody is looking', 'Fliegen können, aber nur 20 cm über dem Boden
— oder —
Unsichtbar sein, aber nur wenn niemand hinschaut', null, null);

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('would-you-rather', 6, 'published', '6-10', 'Have a 3D printer that takes 1 week per print
— or —
A printer that prints money but only 1 cent at a time', 'Einen 3D-Drucker haben, der 1 Woche pro Druck braucht
— oder —
Einen Drucker, der Geld druckt, aber nur 1 Cent auf einmal', null, null);

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('would-you-rather', 7, 'published', '6-10', 'Know every programming language but forget how to write by hand
— or —
Write beautifully but never use a computer again', 'Jede Programmiersprache können, aber das Schreiben mit der Hand vergessen
— oder —
Wunderschön schreiben, aber nie wieder einen Computer benutzen', null, null);

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('would-you-rather', 8, 'published', '6-10', 'Have a time machine that only goes 5 minutes into the future
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
  'Draw a card and keep the answer secret. For younger kids, announce the category (machines and inventions).', 'Zieh eine Karte und halte die Antwort geheim. Bei jüngeren Kindern: Sag die Kategorie an (Maschinen und Erfindungen).', 'Kids ask yes/no questions to guess what you are. If the group gets stuck, read the hint on the card. Whoever guesses correctly picks the next round.', 'Die Kinder stellen Ja/Nein-Fragen, um zu erraten, was du bist. Wenn die Gruppe feststeckt, lies den Hinweis auf der Karte vor. Wer richtig rät, wählt die nächste Runde.', 'Engineering twist — only allow machines and inventions.', 'Engineering-Variante — nur Maschinen und Erfindungen erlaubt.');

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('what-am-i', 1, 'published', '4-6', 'A traffic light', 'Eine Ampel', 'I have three colors and I tell you when to stop', 'Ich habe drei Farben und sage dir, wann du stehen bleiben musst');

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('what-am-i', 2, 'published', '4-6', 'A bridge', 'Eine Brücke', 'I help you cross something you can''t walk through', 'Ich helfe dir, etwas zu überqueren, durch das du nicht gehen kannst');

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('what-am-i', 3, 'published', '6-10', 'An algorithm', 'Ein Algorithmus', 'I''m a set of steps that solves a problem the same way every time', 'Ich bin eine Folge von Schritten, die ein Problem jedes Mal gleich löst');

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('what-am-i', 4, 'published', '6-10', 'A gear', 'Ein Zahnrad', 'I have teeth but I don''t eat. I spin to make other things move', 'Ich habe Zähne, aber ich esse nicht. Ich drehe mich, damit andere Dinge sich bewegen');

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

-- ── Welcome & camp games (added July 2026) ──

insert into games (id, category_id, sort_order, type, status, title_en, title_de, subtitle_en, subtitle_de,
  size_en, size_de, time_en, time_de, materials_en, materials_de, age, tags,
  setup_en, setup_de, how_en, how_de, tip_en, tip_de) values
  ('intro-questions', 'gettoknow', 1, 'deck', 'published', 'Intro Questions', 'Kennenlernfragen', null, null,
  'any', 'beliebig', '5–10 min', '5–10 Min', 'nothing', 'nichts', null, array['get-to-know', 'trickle-in', 'waiting']::text[],
  'Sit in a circle if you can. Works anywhere — carpet, tables, waiting in line.', 'Wenn möglich, setzt euch in einen Kreis. Funktioniert überall — Teppich, Tische, in der Warteschlange.', 'Draw a card and read the question aloud. Everyone answers, around the circle or popcorn style. Keep answers short — one sentence is plenty. Ask a "why?" when something is interesting.', 'Zieh eine Karte und lies die Frage vor. Alle antworten — reihum oder kreuz und quer. Kurze Antworten reichen — ein Satz genügt. Hak mit einem "Warum?" nach, wenn etwas spannend ist.', 'Answer first yourself — it shows how it works and makes it safe to share.', 'Antworte zuerst selbst — das zeigt, wie es geht, und macht Mut zum Teilen.');

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('intro-questions', 1, 'published', '4-6', 'What''s your favorite pizza topping?', 'Was ist dein Lieblingsbelag auf der Pizza?', null, null);

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('intro-questions', 2, 'published', '4-6', 'What''s your favorite piece of technology at home?', 'Was ist dein liebstes technisches Gerät zu Hause?', null, null);

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('intro-questions', 3, 'published', 'all', 'If you could have one superpower, what would it be — and what would you build with it?', 'Wenn du eine Superkraft haben könntest, welche wäre es — und was würdest du damit bauen?', null, null);

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('intro-questions', 4, 'published', '6-10', 'What''s the best invention of all time — and why?', 'Was ist die beste Erfindung aller Zeiten — und warum?', null, null);

insert into cards (game_id, sort_order, status, age, text_en, text_de, hint_en, hint_de) values
  ('intro-questions', 5, 'published', '6-10', 'Vibe check: if you were a machine today, which one would you be?', 'Vibe-Check: Wenn du heute eine Maschine wärst, welche wärst du?', null, null);

insert into games (id, category_id, sort_order, type, status, title_en, title_de, subtitle_en, subtitle_de,
  size_en, size_de, time_en, time_de, materials_en, materials_de, age, tags,
  setup_en, setup_de, how_en, how_de, tip_en, tip_de) values
  ('name-ball', 'gettoknow', 2, 'activity', 'published', 'Name Ball', 'Namensball', null, null,
  '5+', '5+', '5–10 min', '5–10 Min', 'a soft ball', 'ein weicher Ball', '4-6', array['get-to-know', 'team builder']::text[],
  'Stand in a circle. One soft ball. Everyone says their name once around before the first throw.', 'Stellt euch in einen Kreis. Ein weicher Ball. Bevor der erste Wurf kommt, sagen alle einmal reihum ihren Namen.', 'Say a kid''s name, then throw them the ball. They say another name and throw on. Everyone should get the ball at least once. Faster each round.', 'Sag den Namen eines Kindes und wirf ihm dann den Ball zu. Es sagt den nächsten Namen und wirft weiter. Alle sollen den Ball mindestens einmal bekommen. Jede Runde etwas schneller.', 'Day-one classic. Later in the week: reverse the order, or add a second ball.', 'Der Klassiker für Tag 1. Später in der Woche: Reihenfolge umdrehen oder einen zweiten Ball dazunehmen.');

insert into games (id, category_id, sort_order, type, status, title_en, title_de, subtitle_en, subtitle_de,
  size_en, size_de, time_en, time_de, materials_en, materials_de, age, tags,
  setup_en, setup_de, how_en, how_de, tip_en, tip_de) values
  ('who-is-missing', 'gettoknow', 3, 'activity', 'published', 'Who''s Missing?', 'Wer fehlt?', null, null,
  '6+', '6+', '5–10 min', '5–10 Min', 'a blanket (optional)', 'eine Decke (optional)', '4-6', array['get-to-know', 'focus reset']::text[],
  'Kids sit in a circle so everyone can see everyone. Have the blanket ready if you use one.', 'Die Kinder sitzen im Kreis, sodass alle einander sehen. Leg die Decke bereit, falls du eine verwendest.', 'One kid closes their eyes or leaves the room for a moment. Quietly pick one kid to hide — under the blanket or out of sight. The others swap seats so the gap gives nothing away. Now: who is missing? Once solved, the hidden kid comes back and guesses next.', 'Ein Kind schließt die Augen oder geht kurz vor die Tür. Wähl leise ein Kind aus, das sich versteckt — unter der Decke oder außer Sicht. Die anderen tauschen die Plätze, damit die Lücke nichts verrät. Dann: Wer fehlt? Ist es gelöst, kommt das versteckte Kind zurück und rät als Nächstes.', 'Great in the first days — the group learns names fast. Say the missing kid''s name together once it''s solved.', 'Super in den ersten Tagen — die Gruppe lernt Namen schnell. Sagt den Namen des fehlenden Kindes gemeinsam, sobald es gelöst ist.');

insert into games (id, category_id, sort_order, type, status, title_en, title_de, subtitle_en, subtitle_de,
  size_en, size_de, time_en, time_de, materials_en, materials_de, age, tags,
  setup_en, setup_de, how_en, how_de, tip_en, tip_de) values
  ('kelvin-says', 'energizer', 2, 'activity', 'published', 'Kelvin Says', 'Kelvin sagt', null, null,
  'any', 'beliebig', '5–10 min', '5–10 Min', 'nothing', 'nichts', '4-6', array['energy burn', 'in-class', 'transition']::text[],
  'Everyone stands where they can see you.', 'Alle stehen so, dass sie dich sehen können.', 'Give commands: jump, spin, touch the floor, beep like a robot. Kids only follow when the command starts with "Kelvin says". Whoever follows a command without it does three jumping jacks and rejoins — nobody is out.', 'Gib Befehle: springen, drehen, den Boden berühren, wie ein Roboter piepen. Die Kinder folgen nur, wenn der Befehl mit "Kelvin sagt" beginnt. Wer trotzdem mitmacht, macht drei Hampelmänner und ist wieder dabei — niemand fliegt raus.', 'Robot commands make it an engineering game: compute, recharge, error sound. Let a kid be Kelvin after a few rounds.', 'Roboterbefehle machen es zum Engineering-Spiel: rechnen, aufladen, Fehlergeräusch. Lass nach ein paar Runden ein Kind Kelvin sein.');

insert into games (id, category_id, sort_order, type, status, title_en, title_de, subtitle_en, subtitle_de,
  size_en, size_de, time_en, time_de, materials_en, materials_de, age, tags,
  setup_en, setup_de, how_en, how_de, tip_en, tip_de) values
  ('gotcha', 'energizer', 3, 'activity', 'published', 'Gotcha!', 'Gotcha!', null, null,
  '4+', '4+', '3–5 min', '3–5 Min', 'nothing', 'nichts', '6-10', array['break', 'in-class', 'focus reset']::text[],
  'Circle, standing or sitting. Hold your left hand open, palm up, toward your left neighbor. Rest your right index finger on the open palm to your right.', 'Kreis, im Stehen oder Sitzen. Halte deine linke Hand offen nach links, Handfläche nach oben. Dein rechter Zeigefinger liegt auf der offenen Handfläche rechts von dir.', 'Tell a story or count down. On the trigger word ("Gotcha!" — or your word of the day) everyone tries to catch the finger on their palm while pulling their own finger away. Play best of five.', 'Erzähl eine Geschichte oder zähl runter. Beim Signalwort ("Gotcha!" — oder eurem Wort des Tages) versuchen alle, den Finger auf ihrer Handfläche zu fangen und gleichzeitig den eigenen Finger wegzuziehen. Spielt Best of Five.', 'Use the engineering word of the day as the trigger — sneak it into sentences to build tension.', 'Nimm das Engineering-Wort des Tages als Signal — bau es überraschend in Sätze ein, das macht die Spannung.');

insert into games (id, category_id, sort_order, type, status, title_en, title_de, subtitle_en, subtitle_de,
  size_en, size_de, time_en, time_de, materials_en, materials_de, age, tags,
  setup_en, setup_de, how_en, how_de, tip_en, tip_de) values
  ('trolls-wizards-giants', 'energizer', 4, 'activity', 'published', 'Trolls, Wizards, Giants', 'Trolle, Zauberer, Riesen', null, null,
  'two teams, 8+', 'zwei Teams, 8+', '10–15 min', '10–15 Min', 'big space', 'viel Platz', '6-10', array['energy burn', 'team builder']::text[],
  'Big space (gym or outdoors). Two teams, each with a safe zone at their end. Practice the three poses: trolls crouch and growl, wizards throw spells, giants stretch tall and stomp.', 'Viel Platz (Turnsaal oder draußen). Zwei Teams, jedes mit einer Schutzzone an seinem Ende. Übt die drei Posen: Trolle kauern und knurren, Zauberer werfen Zaubersprüche, Riesen machen sich groß und stampfen.', 'Rock-paper-scissors with your whole body: each team secretly picks a character, lines up at the middle, and on "three" shows its pose. Wizards beat giants, giants beat trolls, trolls beat wizards. The winning team chases; whoever is tagged before reaching the safe zone switches teams. Tie: pick again.', 'Schere-Stein-Papier mit dem ganzen Körper: Jedes Team wählt heimlich eine Figur, stellt sich in der Mitte auf und zeigt auf "drei" seine Pose. Zauberer schlagen Riesen, Riesen schlagen Trolle, Trolle schlagen Zauberer. Das Gewinnerteam jagt; wer vor der Schutzzone gefangen wird, wechselt das Team. Unentschieden: neu wählen.', 'Mark the safe zones clearly and keep the running lanes free — this game gets fast.', 'Markiere die Schutzzonen deutlich und halte die Laufwege frei — das Spiel wird schnell.');

insert into games (id, category_id, sort_order, type, status, title_en, title_de, subtitle_en, subtitle_de,
  size_en, size_de, time_en, time_de, materials_en, materials_de, age, tags,
  setup_en, setup_de, how_en, how_de, tip_en, tip_de) values
  ('ninja', 'energizer', 5, 'activity', 'published', 'Ninja', 'Ninja', null, null,
  '4–10', '4–10', '5–10 min', '5–10 Min', 'nothing', 'nichts', '6-10', array['break', 'energy burn']::text[],
  'Stand in a circle, one arm''s length apart. Everyone bows, shouts "Ninja!" and freezes in a ninja pose.', 'Stellt euch im Kreis auf, eine Armlänge Abstand. Alle verbeugen sich, rufen "Ninja!" und erstarren in einer Ninja-Pose.', 'Take turns. On your turn: ONE swift movement to strike at a neighbor''s hand. They may dodge with ONE movement, then freeze again. If your hand is hit, it goes behind your back; both hands hit — you''re out. Last ninja wins.', 'Der Reihe nach: Wer dran ist, macht EINE schnelle Bewegung, um die Hand eines Nachbarkindes zu treffen. Es darf mit EINER Bewegung ausweichen und erstarrt dann wieder. Getroffene Hand kommt hinter den Rücken; beide Hände getroffen — ausgeschieden. Der letzte Ninja gewinnt.', 'Strict one-movement rule — demo it in slow motion first. Depends a lot on group dynamics; skip it with groups that play too rough.', 'Strenge Ein-Bewegung-Regel — zeig es zuerst in Zeitlupe. Hängt stark von der Gruppendynamik ab; bei zu wilden Gruppen lieber auslassen.');

insert into games (id, category_id, sort_order, type, status, title_en, title_de, subtitle_en, subtitle_de,
  size_en, size_de, time_en, time_de, materials_en, materials_de, age, tags,
  setup_en, setup_de, how_en, how_de, tip_en, tip_de) values
  ('im-going-to-a-picnic', 'focus', 3, 'activity', 'published', 'I''m Going to a Picnic', 'Ich gehe auf ein Picknick', null, null,
  '4–12', '4–12', '5–10 min', '5–10 Min', 'nothing', 'nichts', '6-10', array['waiting', 'cooldown', 'focus reset', 'in-class']::text[],
  'Sit in a circle. No preparation.', 'Setzt euch in einen Kreis. Keine Vorbereitung.', 'The first kid says: "I''m going to a picnic and I''m bringing an apple." The next repeats everything and adds one item. Keep going around — the list grows and grows. If someone gets stuck, the group may help with silent miming.', 'Das erste Kind sagt: "Ich gehe auf ein Picknick und nehme einen Apfel mit." Das nächste wiederholt alles und ergänzt eine Sache. Immer weiter im Kreis — die Liste wächst und wächst. Wer feststeckt, dem darf die Gruppe stumm pantomimisch helfen.', 'Engineering version: pack a toolbox instead — "I''m packing my toolbox and taking a wrench."', 'Engineering-Version: Packt stattdessen einen Werkzeugkasten — "Ich packe meinen Werkzeugkasten und nehme einen Schraubenschlüssel mit."');
