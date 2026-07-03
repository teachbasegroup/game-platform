-- ═══════════════════════════════════════════════════════════════════
-- Migration, July 2026: new age bands + welcome/camp games
--
-- Run ONCE in the SQL Editor of the existing project.
-- 1. Age bands change from 6-8 / 9-12 to 4-6 / 6-10 / 11-14.
-- 2. Existing content remaps: 6-8 → 4-6, 9-12 → 6-10.
-- 3. Eight new games (intro questions, name ball, who's missing,
--    Kelvin Says, Gotcha, Trolls-Wizards-Giants, Ninja, Picnic).
-- ═══════════════════════════════════════════════════════════════════

-- ── New age bands ──
-- Order matters: remove the old rules first, remap the data, and only then
-- install the new rules — a rule can only be added when every row obeys it.

alter table games drop constraint games_age_check;
alter table cards drop constraint cards_age_check;

update cards set age = '4-6'  where age = '6-8';
update cards set age = '6-10' where age = '9-12';
update games set age = '4-6'  where age = '6-8';
update games set age = '6-10' where age = '9-12';

alter table games add constraint games_age_check
  check (age in ('4-6','6-10','11-14','all'));
alter table cards add constraint cards_age_check
  check (age in ('4-6','6-10','11-14','all'));

-- ── New games ──

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
  'Kids sit in a circle. One kid guesses and closes their eyes (or steps outside for a moment).', 'Die Kinder sitzen im Kreis. Ein Kind rät und schließt die Augen (oder geht kurz vor die Tür).', 'While the eyes are closed, silently point at one kid — they hide under the blanket or behind something. Everyone else switches places. Then: who''s missing? The hidden kid guesses next.', 'Während die Augen geschlossen sind, zeig leise auf ein Kind — es versteckt sich unter der Decke oder hinter etwas. Alle anderen tauschen die Plätze. Dann wird geraten: Wer fehlt? Das versteckte Kind rät als Nächstes.', 'Great in the first days — the group learns names fast. Say the missing kid''s name together once it''s solved.', 'Super in den ersten Tagen — die Gruppe lernt Namen schnell. Sagt den Namen des fehlenden Kindes gemeinsam, sobald es gelöst ist.');

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
