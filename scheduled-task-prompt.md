Je controleert of er nieuwe concert- of festivaloptredens in Nederland zijn aangekondigd voor een vaste lijst favoriete artiesten van de gebruiker.

STAP 1 — Lees de trackingstate:
Lees het bestand C:\Users\mzijp\MZ_Code\Allerlei\concert-watch-state.json. Dit bevat:
- "artists": de lijst met artiesten om te volgen, ALFABETISCH gesorteerd — houd deze volgorde aan als je de lijst afwerkt en rapporteert, zodat de gebruiker de voortgang kan volgen
- "known_shows": een lijst van eerder gevonden/gerapporteerde optredens (elk met minstens artist, date, venue_or_city, source_url)
- "last_run": tijdstip van de vorige run (kan null zijn bij de eerste run)

STAP 2 — Zoek nieuwe optredens (HEEL Nederland, alle soorten locaties):
Gebruik WebSearch om voor elke artiest in de lijst (in alfabetische volgorde) te controleren op aangekondigde optredens in Nederland — concerten, clubshows, festivals, maar ook kleine, alternatieve, tijdelijke of ongebruikelijke locaties (bijv. kerken, industriële locaties, buitenpodia, kleine cafépodia, pop-up locaties, boerderijen, campings). Zoek dus NIET alleen naar de grote/bekende venues — de gebruiker wil juist ook de rare/originele/kleine plekken meekrijgen, niet alleen Ziggo Dome/Paradiso/Melkweg-achtige locaties. Gebruik brede zoektermen zoals "<artiest> Nederland 2026 tickets", "<artiest> concert Netherlands", "<artiest> Nederland optreden", site:songkick.com, site:eventim.nl, site:ticketmaster.nl, site:podiuminfo.nl, en algemene zoekopdrachten zonder venue-namen vooraf in te vullen, zodat ook onbekende/kleine podia naar boven komen. Zoek zonder tijdslimiet — ook shows die pas over een jaar of later plaatsvinden. Het is prima als dit meerdere zoekopdrachten kost.

STAP 3 — Bepaal wat nieuw is:
Vergelijk elke gevonden show met "known_shows" (op basis van artiest + datum + venue). Alles wat niet al in known_shows staat, is "nieuw". Bij de allereerste run (last_run is null) is de hele gevonden lijst per definitie "nieuw" — rapporteer die volledig als startpunt, dat is geen fout.

STAP 4 — Rapporteer aan de gebruiker:
Stuur ALTIJD een kort chatbericht naar de gebruiker (dit is de enige afgesproken manier van rapporteren — GEEN e-mail versturen, geen Gmail-concepten aanmaken):
- Als er nieuwe optredens zijn: noem per nieuw optreden de artiest, datum, venue/stad, en de bron-URL. Groepeer alfabetisch op artiest, zodat duidelijk is hoever de lijst is doorlopen.
- Als er niets nieuws is: stuur alleen een kort berichtje zoals "Geen nieuwe optredens deze week voor je gevolgde artiesten." (herhaal niet de volledige lijst van bekende shows).

STAP 5 — Werk de state bij:
Schrijf C:\Users\mzijp\MZ_Code\Allerlei\concert-watch-state.json opnieuw weg met:
- dezelfde "artists" lijst, alfabetisch gesorteerd (tenzij de gebruiker later een update geeft)
- "known_shows" aangevuld met alle nieuw gevonden shows (verwijder geen oude shows, ook niet als het optreden al is geweest — dat voorkomt dubbele meldingen)
- "last_run" op de huidige datum/tijd

Artiestenlijst (55 stuks, alfabetisch): Aphex Twin, Arcade Fire, Arctic Monkeys, Big Thief, Billie Eilish, Blood Red Shoes, Blur, Bob Dylan, Bombay Bicycle Club, Bon Iver, Brian Eno, Bryan Ferry, Car Seat Headrest, Daniela Pes, David Byrne, Depeche Mode, Editors, Feist, Goldband, Hang Youth, HMLTD, IDLES, Insecure Men, Interpol, Jamie XX, Joan Baez, Joni Mitchell, Kate Bush, Lana del Rey, LCD Soundsystem, Lisa O'Neill, Mumford & Sons, Muse, Nick Cave and the Bad Seeds, Nicolas Jaar, Nine Inch Nails, Oasis, Paul McCartney, PJ Harvey, Portishead, Queens of the Stone Age, Radiohead, Roxy Music, Son Lux, Talk Talk, Talking Heads, The Cure, The National, The Psychotic Monks, The Smiths, The Strokes, Tom Waits, TVAM, Weval, Yeah Yeah Yeahs, Young Fathers.

Belangrijk: verstuur GEEN e-mails en maak geen Gmail-concepten — de gebruiker heeft expliciet gekozen voor alleen een chatbericht in Claude. Een eventuele losse website voor deze meldingen komt later, nu nog niet bouwen.
