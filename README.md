<p align="center">
  <img src="assets/logo.svg" alt="Abrigo Vivo logo" width="120">
</p>

<h1 align="center">Abrigo Vivo</h1>

<p align="center">
  A smart bat house that uses plant scents to bring fruit- and nectar-eating bats back to recovering forest,<br>
  and counts every bat that goes in or out.<br>
  <em>FIRST LEGO League 2026 Innovation Project · Mata de Santa Genebra, Campinas (SP), Brazil</em>
</p>

<p align="center">
  <a href="https://playergeek181.github.io/abrigo-vivo/"><b>Live site</b></a> ·
  <a href="https://playergeek181.github.io/abrigo-vivo/site/abrigo-vivo.html">Project page</a> ·
  <a href="https://playergeek181.github.io/abrigo-vivo/3d/">3D animation</a>
</p>

---

## What's here

| Page | File | What it shows |
|---|---|---|
| Home | `index.html` | Logo and links to the two pages below |
| Project site | `site/abrigo-vivo.html` | Problem, bats, research question, counting system, energy budget, next steps (in Portuguese) |
| 3D animation | `3d/index.html` | One night at the bat house: bats leave and return, the IR barrier counts them, the camera takes photos, LoRa sends data |

**Prototype in one paragraph:** a Raspberry Pi Zero 2 W reads a double infrared beam at the entrance, which tells whether each bat is going in or out. A NoIR camera with 940 nm LEDs photographs the roost, and a BME280 measures temperature and humidity. Every 30 minutes a LoRa radio (RFM95W, 915 MHz) sends a summary to a receiver with internet access. Power comes from a 12.8 V 20 Ah LiFePO4 battery: about 23 Wh per day, roughly 9 days of autonomy, swapped weekly. There is no solar panel because the forest canopy is closed.

## Quick start (Linux / macOS)

```bash
git clone https://github.com/Playergeek181/abrigo-vivo.git
cd abrigo-vivo
chmod +x install.sh
./install.sh --run
```

Then open **http://localhost:8123**. Press **Ctrl + C** in the terminal to stop.

### What `install.sh` does

1. Installs **Python 3** and **curl** if they're missing, using `apt`, `dnf`, `pacman`, `zypper` or Homebrew. It may ask for your password (sudo).
2. Makes sure the **Three.js 0.160.0** files are in `3d/lib/`, and downloads them if not. After that the 3D page works offline.
3. Checks the pages exist, and with `--run` starts a local web server.

To use another port, run `PORT=8200 ./install.sh --run`.

### Windows

Run `install.sh` from **Git Bash** or **WSL**, or do it by hand: install Python 3 from https://www.python.org/downloads/ (tick *"Add python.exe to PATH"*), then in the project folder run:

```powershell
py -m http.server 8123
```

and open http://localhost:8123.

> **Why a server?** The 3D page loads JavaScript modules, and browsers block those on `file://` pages. Opening `3d/index.html` by double-clicking gives a blank page. The project site (`site/abrigo-vivo.html`) works either way.

## Publishing on GitHub Pages

1. On https://github.com/new, create a repository called `abrigo-vivo`. Make it **public**, because Pages on free accounts needs a public repository, and don't add a README.
2. In the project folder:
   ```bash
   git init -b main
   git add .
   git commit -m "Abrigo Vivo site, 3D animation and logo"
   git remote add origin https://github.com/Playergeek181/abrigo-vivo.git
   git push -u origin main
   ```
3. On GitHub: **Settings → Pages → Build and deployment**, set *Source: Deploy from a branch*, *Branch: `main`*, folder *`/ (root)`*, and click **Save**.
4. After a minute or two the site is live at `https://playergeek181.github.io/abrigo-vivo/`.

The empty `.nojekyll` file tells GitHub to serve the files as they are. `.gitignore` keeps the WhatsApp voice note and the local `.impeccable/` reviews out of the repository.

## Using the 3D animation

| Action | How |
|---|---|
| Rotate / zoom / pan | Drag / scroll wheel / right-drag |
| Pause or resume | **Pausar** button or **Space** |
| Speed | **0,5×** to **4×** |
| Camera views | **Geral, Interior, Eletrônica, Entrada, Bateria, Rede LoRa** |
| Labels on or off | **Rótulos** checkbox or **L** |
| Pull the parts apart | **Explodir** slider |

## Troubleshooting

| Problem | Fix |
|---|---|
| 3D page is blank | You opened the file directly. Use `./install.sh --run` and http://localhost:8123. |
| `Address already in use` | Port 8123 is taken: `PORT=8200 ./install.sh --run`. |
| `Permission denied` running the script | `chmod +x install.sh`, or run `bash install.sh`. |
| "Não foi possível iniciar o 3D" | WebGL is off. Turn on hardware acceleration in the browser, or update the browser or try another one. |
| Changes don't show up | Hard reload: **Ctrl + Shift + R** (Mac: **Cmd + Shift + R**). |

To show it on a phone on the same Wi-Fi, run `python3 -m http.server 8123 --bind 0.0.0.0` and open `http://<your-computer-IP>:8123` on the phone.

## Project structure

```
.
├── index.html               home page (GitHub Pages entry)
├── assets/logo.svg          logo and favicon
├── site/abrigo-vivo.html    project site
├── 3d/index.html            3D animation
├── 3d/lib/                  Three.js 0.160.0 (local copy)
├── abrigo-vivo-ilustracao.svg  cutaway illustration
├── install.sh               installer and local server
├── .nojekyll                serve files as-is on GitHub Pages
└── .gitignore
```

## Credits

Three.js © three.js authors, MIT License.
