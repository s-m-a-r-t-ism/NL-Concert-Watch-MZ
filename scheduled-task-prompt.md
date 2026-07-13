Je controleert of er nieuwe concert- of festivaloptredens in Nederland zijn aangekondigd voor een vaste lijst favoriete artiesten van de gebruiker.

STAP 1 — Lees de trackingstate:
Lees het bestand C:\Users\mzijp\MZ_Code\Allerlei\concert-watch-state.json. Dit bevat:
- "artists": de lijst met artiesten om te volgen, ALFABETISCH gesorteerd — houd deze volgorde aan als je de lijst afwerkt en rapporteert, zodat de gebruiker de voortgang kan volgen
- "known_shows": een lijst van eerder gevonden/gerapporteerde optredens (elk met minstens artist, date, venue_or_city, source_url, en optioneel ticketswap_url)
- "last_run": tijdstip van de vorige run (kan null zijn bij de eerste run)

STAP 2 — Zoek nieuwe optredens (HEEL Nederland, alle soorten locaties):
Gebruik WebSearch om voor elke artiest in de lijst (in alfabetische volgorde) te controleren op aangekondigde optredens in Nederland — concerten, clubshows, festivals, maar ook kleine, alternatieve, tijdelijke of ongebruikelijke locaties (bijv. kerken, industriële locaties, buitenpodia, kleine cafépodia, pop-up locaties, boerderijen, campings). Zoek dus NIET alleen naar de grote/bekende venues — de gebruiker wil juist ook de rare/originele/kleine plekken meekrijgen, niet alleen Ziggo Dome/Paradiso/Melkweg-achtige locaties. Gebruik brede zoektermen zoals "<artiest> Nederland 2026 tickets", "<artiest> concert Netherlands", "<artiest> Nederland optreden", site:songkick.com, site:eventim.nl, site:ticketmaster.nl, site:podiuminfo.nl, en algemene zoekopdrachten zonder venue-namen vooraf in te vullen, zodat ook onbekende/kleine podia naar boven komen. Zoek zonder tijdslimiet — ook shows die pas over een jaar of later plaatsvinden.

Werk hierbij bewust LICHT (token-efficiënt), dit is een routinematige wekelijkse check, geen diepgravend onderzoek:
- Spawn GEEN parallelle subagents om de artiestenlijst te verdelen — doorloop de lijst gewoon zelf, artiest voor artiest. Het opsplitsen in meerdere subagents kostte in het verleden meer dan de helft van het tokenbudget voor weinig extra resultaat.
- Doe per artiest in principe 1 brede zoekopdracht. Alleen als die een treffer oplevert, doe je een tweede/derde zoekopdracht om de datum/venue/officiële link te bevestigen (zie STAP 3). Bij "niets gevonden" ga je gewoon door naar de volgende artiest.
- Ga niet op zoek naar en verifieer geen geruchten, "farewell tour"-praatjes, tribute-acts of nepnieuws-achtige claims (bijv. via Facebook-posts of clickbait-sites) — als een bron niet betrouwbaar oogt (geen venue/festival/ticketing-site), sla 'm gewoon over in plaats van 'm actief te ontkrachten.
- Voor artiesten die niet meer bestaan of al jaren niet meer touren (bijv. bekend uit eerdere runs, zoals opgeheven bands) volstaat een enkele snelle controlezoekopdracht; hoef je niet uitgebreid te verifiëren dat er "echt niets" is.

STAP 3 — Zoek de venue-link (BELANGRIJK):
Songkick, Ticketmaster, Bandsintown, setlist.fm e.d. zijn prima om een optreden te ONTDEKKEN, maar het uiteindelijke "source_url" veld moet zoveel mogelijk naar de EIGEN pagina van de venue/het festival zelf linken (bijv. paradiso.nl, afaslive.nl, tivolivredenburg.nl, pinkpop.nl, ziggodome.nl, downtherabbithole.nl, patronaat.nl), niet naar een reseller of aggregator. Doe dus na het vinden van een show altijd een extra zoekopdracht als "<venue naam>.nl <artiest> <datum>" om de officiële eventpagina te vinden. Als er geen specifieke eventpagina op de venue-site bestaat (bijv. omdat de show al langer geleden was, of nog niet individueel gepubliceerd is), gebruik dan de algemene agenda-pagina van de venue zelf in plaats van een reseller-link. Alleen als er echt geen enkele officiële venue/festival-pagina te vinden is, mag je terugvallen op de beste beschikbare aggregator-link.

STAP 4 — Bepaal wat nieuw is:
Vergelijk elke gevonden show met "known_shows" (op basis van artiest + datum + venue). Alles wat niet al in known_shows staat, is "nieuw". Bij de allereerste run (last_run is null) is de hele gevonden lijst per definitie "nieuw" — rapporteer die volledig als startpunt, dat is geen fout.

STAP 5 — Zoek de TicketSwap-link voor elk nieuw gevonden optreden:
Zoek voor elk NIEUW optreden (uit STAP 4) ook de bijbehorende TicketSwap-eventpagina op (bijv. via WebSearch met "<artiest> <venue> <datum> ticketswap" of site:ticketswap.nl), en noteer die URL als "ticketswap_url". TicketSwap-eventpagina's bestaan niet voor elk optreden (met name kleine/net aangekondigde/alternatieve locaties hebben er vaak nog geen) — als je geen exacte match vindt voor de juiste artiest/venue/datum, laat "ticketswap_url" dan gewoon weg bij die show in plaats van te gokken of een verkeerde/algemene link te gebruiken.

STAP 6 — Rapporteer aan de gebruiker:
Stuur ALTIJD een kort chatbericht naar de gebruiker (dit is de enige afgesproken manier van rapporteren — GEEN e-mail versturen, geen Gmail-concepten aanmaken):
- Als er nieuwe optredens zijn: noem per nieuw optreden de artiest, datum, venue/stad, de bron-URL, en (indien gevonden) de TicketSwap-link. Groepeer alfabetisch op artiest, zodat duidelijk is hoever de lijst is doorlopen.
- Als er niets nieuws is: stuur alleen een kort berichtje zoals "Geen nieuwe optredens deze week voor je gevolgde artiesten." (herhaal niet de volledige lijst van bekende shows).

STAP 7 — Werk de state bij:
Schrijf C:\Users\mzijp\MZ_Code\Allerlei\concert-watch-state.json opnieuw weg met:
- dezelfde "artists" lijst, alfabetisch gesorteerd (tenzij de gebruiker later een update geeft)
- "known_shows" aangevuld met alle nieuw gevonden shows, elk met artist, date, venue_or_city, source_url, en ticketswap_url indien gevonden in STAP 5 (verwijder geen oude shows, ook niet als het optreden al is geweest — dat voorkomt dubbele meldingen)
- "last_run" op de huidige datum/tijd

STAP 8 — Publiceer de bijgewerkte state naar GitHub:
Commit en push het bijgewerkte concert-watch-state.json naar de GitHub-repo (https://github.com/s-m-a-r-t-ism/NL-Concert-Watch-MZ.git), zodat de website concerts.smartism.art (gehost via GitHub Pages vanuit deze repo) automatisch up-to-date blijft. Deze routine draait op meerdere machines (werk en privé) tegen dezelfde repo — dat is de bedoeling, dus haal eerst de laatste stand op om conflicten te voorkomen. Voer uit vanuit C:\Users\mzijp\MZ_Code\Allerlei:
- git add concert-watch-state.json
- git commit -m "Update concert-watch-state.json - <datum van vandaag>" (sla deze stap over als er niets gewijzigd is)
- git pull --rebase origin main
- git push origin main

Artiestenlijst (55 stuks, alfabetisch): Aphex Twin, Arcade Fire, Arctic Monkeys, Big Thief, Billie Eilish, Blood Red Shoes, Blur, Bob Dylan, Bombay Bicycle Club, Bon Iver, Brian Eno, Bryan Ferry, Car Seat Headrest, Daniela Pes, David Byrne, Depeche Mode, Editors, Feist, Goldband, Hang Youth, HMLTD, IDLES, Insecure Men, Interpol, Jamie XX, Joan Baez, Joni Mitchell, Kate Bush, Lana del Rey, LCD Soundsystem, Lisa O'Neill, Mumford & Sons, Muse, Nick Cave and the Bad Seeds, Nicolas Jaar, Nine Inch Nails, Oasis, Paul McCartney, PJ Harvey, Portishead, Queens of the Stone Age, Radiohead, Roxy Music, Son Lux, Talk Talk, Talking Heads, The Cure, The National, The Psychotic Monks, The Smiths, The Strokes, Tom Waits, TVAM, Weval, Yeah Yeah Yeahs, Young Fathers.

Belangrijk: verstuur GEEN e-mails en maak geen Gmail-concepten — de gebruiker heeft expliciet gekozen voor alleen een chatbericht in Claude. Een eventuele losse website voor deze meldingen komt later, nu nog niet bouwen.
