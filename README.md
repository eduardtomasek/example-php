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
