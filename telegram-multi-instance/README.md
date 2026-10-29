# tgm — Run Multiple Telegram Desktop Instances on Linux

Open **as many Telegram accounts as you want, side by side**, each in its own isolated window with its own login. One command to start, stop, list and monitor them.

```bash
tgm start 1 2 3      # open three accounts
tgm start 1-10       # open ten
tgm stop 2           # close one
tgm stop             # close everything
```

Tested on Ubuntu 22.04 / 24.04. Works on any Linux distro with the official Telegram Desktop binary.

---

## How it works

Telegram Desktop allows only one running copy per data folder. Two official flags get around that:

| Flag | What it does |
|---|---|
| `-many` | allows several instances to run at the same time |
| `-workdir <dir>` | gives each instance its own folder (login, chats, cache) |

`tgm` is a small wrapper around those flags. Instance `N` always uses `~/telegram-instances/tgN`, so every account keeps its login between restarts.

## Install

```bash
git clone https://github.com/YOUR_USERNAME/telegram-multi-instance.git
cd telegram-multi-instance
./install.sh
```

The installer downloads the **official** Telegram Desktop from telegram.org into `~/.local/opt/Telegram` and installs `tgm` into `~/.local/bin`. No `sudo` needed.

If `tgm` is not found afterwards, add the folder to your PATH:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
```

> **Snap / Flatpak users:** those builds are sandboxed and can't use custom work folders. The installer puts the official binary next to them, so you don't need to remove anything.

## Usage

| Command | Description |
|---|---|
| `tgm start 1 2 3` | start specific instances |
| `tgm start 2-5` | start a range |
| `tgm start all` | start `TG_COUNT` instances (default 10) |
| `tgm stop 2` | stop one |
| `tgm stop` | stop all |
| `tgm restart 1 2` | stop then start |
| `tgm list` | list instances and whether they run |
| `tgm status` | RAM used by each instance + free system RAM |
| `tgm shortcut 1-10` | add "Telegram 1…10" to your app menu |
| `tgm remove 4` | permanently delete an instance and its login (asks first) |

**First launch of each instance:** log in with that account's phone number (or QR code from a phone where you're already logged in). After that it stays logged in.

**Tip:** all windows are titled "Telegram". Open each one's *Settings* once to see which account it is, or use `tgm shortcut` so each has its own launcher.

## Configuration

Set environment variables, or put them in `~/.config/tgm.conf`:

```bash
TG_DATA="$HOME/telegram-instances"   # where profiles are stored
TG_COUNT=10                          # what "all" means
TG_MAX_RUNNING=10                    # safety limit
TG_DELAY=2                           # seconds between launches
TG_BIN=/path/to/Telegram             # only if auto-detection fails
```

## How many can I run?

Each instance uses roughly **150–300 MB RAM**. 10 instances ≈ 2–3 GB. Check live usage with `tgm status`.

## Troubleshooting

| Problem | Fix |
|---|---|
| `tgm: command not found` | add `~/.local/bin` to PATH (see Install) |
| `Telegram not found` | run `./install.sh` or set `TG_BIN` |
| Second window just focuses the first | you launched without `-many`; always use `tgm start` |
| Instance asks to log in again | you moved or deleted its folder in `TG_DATA` |
| Window doesn't appear | run the binary in a terminal to see errors: `~/.local/opt/Telegram/Telegram -many -workdir ~/telegram-instances/tg1` |
| Download fails during install | re-run `./install.sh` (it retries); check your connection |

## Backup & migrate

Everything lives in one folder. Copy `~/telegram-instances` to another PC and your accounts come with you.

## Uninstall

```bash
./install.sh --uninstall      # removes the program, keeps your accounts
rm -rf ~/telegram-instances   # also deletes all logins
```

## Responsible use

Use this for legitimate purposes, like separating work and personal accounts. Don't use multiple accounts for spam, scams, or abusing Telegram's service. Telegram may limit or ban accounts that do. This project is not affiliated with Telegram.

## Contributing

Issues and pull requests are welcome. Keep the script POSIX-friendly bash and run `bash -n bin/tgm` before submitting.

## License

MIT, see [LICENSE](LICENSE).
