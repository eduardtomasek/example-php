# Podrobný komentář k docker-compose.yml

Níže je kompletní obsah `docker-compose.yml` a podrobné vysvětlení jednotlivých sekcí a klíčových řádků.

## Kompletní docker-compose.yml

```yaml
version: "3.8"

services:
  php-app:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: test-php-app
    ports:
      - "8080:80"
    volumes:
      # Bind mount pro live reload - excluduje vendor složku
      - .:/var/www/html:cached
      # Exclude vendor - nechá vendor z Docker image
      - /var/www/html/vendor
    environment:
      - APACHE_DOCUMENT_ROOT=/var/www/html
      - COMPOSER_ALLOW_SUPERUSER=1
    # Pro development - automatický restart při změnách v compose souboru
    restart: unless-stopped

  # Development helper - composer service pro správu balíčků
  composer:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: composer-helper
    volumes:
      - .:/var/www/html:cached
      - /var/www/html/vendor
    working_dir: /var/www/html
    command: composer install --no-dev --optimize-autoloader
    profiles:
      - tools # Spustí se pouze s --profile tools


  # Volitelný: file watcher pro pokročilejší live reload
  # file-watcher:
  #   image: node:18-alpine
  #   container_name: file-watcher
  #   volumes:
  #     - .:/app
  #   working_dir: /app
  #   command: sh -c "npm install -g nodemon && nodemon --watch . --ext php,css,js --exec 'echo File changed at $(date)'"
```

## Vysvětlení jednotlivých sekcí

### version: '3.8'

Určuje verzi syntaxe docker-compose. Verze 3.8 je vhodná pro moderní Docker a podporuje většinu funkcí potřebných pro vývoj i produkci.

### services

Blok, ve kterém jsou definovány jednotlivé služby (kontejnery), které budou spuštěny.

#### php-app

Hlavní služba s PHP a Apachem.

- **build:**
  - `context: .` – Kontext build procesu, tedy aktuální složka projektu.
  - `dockerfile: Dockerfile` – Určuje, že se použije Dockerfile v rootu projektu.
- **container_name:**
  - Vlastní název kontejneru pro snazší správu (např. v příkazech `docker ps`, `docker restart` atd.).
- **ports:**
  - `8080:80` – Mapuje port 8080 na hostiteli na port 80 v kontejneru (kde běží Apache). Díky tomu je aplikace dostupná na `http://localhost:8080`.
- **volumes:**
  - `.:/var/www/html:cached` – Bind mount, který mapuje celý projekt z hostitele do kontejneru. Díky tomu se změny v kódu ihned projeví v běžícím kontejneru (live reload). Příznak `:cached` zlepšuje výkon na Mac/Windows, protože preferuje rychlost čtení z hosta.
  - `/var/www/html/vendor` – Tento zápis způsobí, že složka `vendor` zůstane ta z Docker image, ne z hosta. To je důležité, protože závislosti instalované v kontejneru se nemíchají s těmi na hostu a nedochází ke konfliktům.
- **environment:**
  - `APACHE_DOCUMENT_ROOT=/var/www/html` – Nastaví root adresář pro Apache.
  - `COMPOSER_ALLOW_SUPERUSER=1` – Umožní Composeru běžet jako root (což je v Dockeru běžné a bezpečné).
- **restart:**
  - `unless-stopped` – Kontejner se automaticky restartuje, pokud spadne nebo při změně compose souboru, dokud ho ručně nezastavíte.

#### composer

Pomocná služba pro správu PHP balíčků přes Composer. Spouští se pouze na vyžádání (profile `tools`).

- **build:**
  - Stejné nastavení jako u hlavní aplikace.
- **container_name:**
  - Vlastní název kontejneru pro Composer.
- **volumes:**
  - `.:/var/www/html:cached` – Sdílí kód s hostem pro aktuální závislosti.
  - `/var/www/html/vendor` – Vendor zůstává z image, ne z hosta.
- **working_dir:**
  - Nastaví pracovní adresář pro Composer.
- **command:**
  - `composer install --no-dev --optimize-autoloader` – Spustí Composer instalaci závislostí při startu kontejneru.
- **profiles:**
  - `tools` – Služba se spustí pouze pokud zadáte `--profile tools` (užitečné pro vývojové nástroje, aby neběžely zbytečně stále).

#### file-watcher (volitelné, zakomentováno)

Služba pro sledování změn v souborech (např. pro automatický reload nebo notifikace).

- **image:**
  - `node:18-alpine` – Použije Node.js image s Alpine Linuxem (lehký image).
- **container_name:**
  - Vlastní název kontejneru.
- **volumes:**
  - `.:/app` – Sdílí celý projekt do `/app` v kontejneru.
- **working_dir:**
  - Nastaví pracovní adresář.
- **command:**
  - Instalace nodemon a spuštění watcheru na změny PHP, CSS, JS souborů.

---

# Docker PHP Test App

Jednoduchá PHP aplikace pro testování Docker setupu.

## Struktura projektu

```
project/
├── composer.json          # Composer konfigurace
├── docker-compose.yml     # Docker setup
├── index.php             # Hlavní aplikace (všechny stránky)
├── assets/
│   ├── style.css         # CSS styly
│   └── script.js         # JavaScript
└── README.md            # Tento soubor
```

## Spuštění

1. **Lokálně s PHP built-in serverem:**

   ```bash
   php -S localhost:8000
   ```

2. **S Dockerem:**
   ```bash
   docker-compose up -d
   ```
   Aplikace bude dostupná na `http://localhost:8080`

## Funkcionalita

- **Hlavní stránka** (`/` nebo `?route=home`): Zobrazí tlačítko "Click Me"
- **Stránka s časem** (`?route=time`): Zobrazí aktuální datum a čas
- **404 stránka**: Pro neexistující routes

## Features

- ✅ Jednoduchý routing system
- ✅ Moderní CSS s gradienty a animacemi
- ✅ Responsive design
- ✅ Composer ready
- ✅ Docker ready
- ✅ Vše v jednom PHP souboru (kromě assets)

## 🔧 Manuální restart kontejneru

**⚠️ POZOR: Po změně composer.json vždy použijte `make rebuild`!**

### Rychlé příkazy s Makefile:

```bash
make help           # Zobrazí všechny dostupné příkazy
make restart        # Rychlý restart PHP služby
make rebuild        # DŮLEŽITÉ: Pro změny v composer.json
make hard-restart   # Úplný restart s down/up
make logs           # Sledovat logy
make shell          # Vstoupit do kontejneru
```

### Ruční Docker příkazy:

**Základní restart:**

```bash
docker-compose restart php-app    # Pouze PHP služba
docker-compose restart            # Všechny služby
docker restart test-php-app       # Přímo kontejner
```

**Rebuild pro změny v Dockerfile/composer.json:**

```bash
docker-compose down
docker-compose up -d --build --no-cache
```

**Tvrdý restart (odstraní a vytvoří znovu):**

```bash
docker-compose down    # Zastaví a odstraní
docker-compose up -d   # Vytvoří a spustí znovu
```

**Debug a monitoring:**

```bash
docker-compose logs -f php-app    # Sledovat logy
docker exec -it test-php-app bash # Vstoupit do kontejneru
docker stats test-php-app         # Statistiky výkonu
docker ps                         # Status kontejnerů
```

## 🎯 Kdy použít jaký restart?

| Situace                   | Příkaz                       | Rychlost       |
| ------------------------- | ---------------------------- | -------------- |
| **Změna PHP/CSS/JS**      | _Není potřeba_ - live reload | ⚡ Okamžitě    |
| **Změna v compose.yml**   | `make restart`               | 🚀 ~3 sekundy  |
| **Změna v composer.json** | `make rebuild`               | 🏗️ ~60+ sekund |
| **Problém s kontejnerem** | `make hard-restart`          | 🔄 ~10 sekund  |
| **Změna v Dockerfile**    | `make rebuild`               | 🏗️ ~60+ sekund |

## 💡 Development workflow

1. **Spuštění:**

   ```bash
   make up    # nebo docker-compose up -d
   ```

2. **Vývoj:**

   - Editujte soubory → změny se projeví okamžitě
   - Sledujte logy: `make logs`

3. **Restart jen když:**
   - Změníte `docker-compose.yml`
   - Kontejner "zkolabuje"
   - Potřebujete vyčistit cache

## Funkcionalita

- **Hlavní stránka** (`/` nebo `?route=home`): Zobrazí tlačítko "Click Me"
- **Stránka s časem** (`?route=time`): Zobrazí aktuální datum a čas
- **404 stránka**: Pro neexistující routes

## Features

- ✅ **Live reload** - změny bez restartu
- ✅ Jednoduchý routing system
- ✅ Moderní CSS s gradienty a animacemi
- ✅ Responsive design
- ✅ Composer ready
- ✅ Docker ready
- ✅ Vše v jednom PHP souboru (kromě assets)

## 🛠️ Užitečné příkazy

```bash
# Rychlý přehled
./dev-commands.sh          # Zobrazí všechny dostupné příkazy

# Development
make watch                 # Spustí s logy (Ctrl+C pro stop)
make test-connection       # Otestuje jestli app běží

# Cleanup
make clean                 # Vyčistí vše (kontejnery, volumes)
docker system prune        # Vyčistí Docker cache
```
