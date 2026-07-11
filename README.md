# NL Concert Watch

Wekelijkse routine die controleert of favoriete artiesten optreden in Nederland.

## Bestanden

- `concert-watch-state.json` — de gevolgde artiestenlijst, alle al-gemelde optredens (`known_shows`), en het tijdstip van de laatste run. Wordt elke week bijgewerkt door de scheduled task.

## Scheduled task opnieuw instellen (bijv. op een andere machine/thuis)

Deze GitHub-repo bevat alleen de data, niet de scheduled task zelf — die staat lokaal in de Claude-app (`~/.claude/scheduled-tasks/`) en moet apart aangemaakt worden op elke machine waar je 'm wil laten draaien.

Maak in Claude Code (of de Claude-app) een scheduled task aan met:

- **Schema:** elke zondagavond 21:00 — cron `0 21 * * 0`
- **Prompt:** zie `scheduled-task-prompt.md` in deze repo — kopieer de inhoud 1-op-1 als prompt voor de nieuwe scheduled task. Pas het pad naar `concert-watch-state.json` aan als de repo op een andere locatie staat dan `C:\Users\mzijp\MZ_Code\Allerlei\`.

## Rapportage

De routine stuurt alleen een chatbericht in Claude (geen e-mail/Gmail-concepten) met nieuwe optredens sinds de vorige run, of een kort berichtje als er niets nieuws is.
