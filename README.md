# Egg Plugin Store

Official plugin registry for **Egg Code Editor**.

## Structure

```
egg-plugin-store/
├── index.json          # plugin registry (fetched by Egg)
├── sources/            # plugin sources (edit here)
│   ├── themes/<id>/    # manifest.json + theme/compose.json
│   └── grammars/<id>/  # manifest.json + grammar/*.meta.json
└── plugins/            # compiled .egg files (served via raw)
```

## Adding a plugin

1. Copy `sources/themes/_template/` (or `sources/grammars/_template/`)
2. Rename folder to plugin id
3. Edit `manifest.json` and `theme/compose.json`
4. Run `./build.sh` (Linux/Mac) or `build.bat` (Windows) — regenerates `plugins/*.egg` and `index.json`
5. Commit both `sources/` and `plugins/` + `index.json`

## Hosting

- `index.json` served at: `https://raw.githubusercontent.com/kLinQin/egg-plugin-store/main/index.json`
- Plugins at: `https://raw.githubusercontent.com/kLinQin/egg-plugin-store/main/plugins/<id>.egg`

## License

MIT.
