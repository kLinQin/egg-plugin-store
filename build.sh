#!/bin/bash
# Build all .egg plugins + regenerate index.json
set -e
cd "$(dirname "$0")"

RAW="https://raw.githubusercontent.com/kLinQin/egg-plugin-store/main"
mkdir -p plugins

# Themes
for src in sources/themes/*/; do
  [ -d "$src" ] || continue
  id=$(basename "$src")
  rm -f "plugins/theme-$id.egg"
  (cd "$src" && jar -cMf "../../../plugins/theme-$id.egg" .)
  echo "built: theme-$id.egg"
done

# Grammars
for src in sources/grammars/*/; do
  [ -d "$src" ] || continue
  id=$(basename "$src")
  # Download grammar if not exists
  if [ -f "$src/grammar/.source-url" ] && [ ! -f "$src/grammar/$id.tmLanguage.json" ]; then
    url=$(cat "$src/grammar/.source-url")
    echo "downloading grammar: $id"
    curl -sSL "$url" -o "$src/grammar/$id.tmLanguage.json"
  fi
  rm -f "plugins/grammar-$id.egg"
  (cd "$src" && jar -cMf "../../../plugins/grammar-$id.egg" .)
  echo "built: grammar-$id.egg"
done

# Regenerate index.json via node (or python)
node -e '
const fs = require("fs");
const path = require("path");
const base = "sources";
const plugins = [];
const raw = "https://raw.githubusercontent.com/kLinQin/egg-plugin-store/main";

for (const type of ["themes", "grammars"]) {
  const dir = path.join(base, type);
  if (!fs.existsSync(dir)) continue;
  for (const id of fs.readdirSync(dir)) {
    const src = path.join(dir, id);
    const manifestPath = path.join(src, "manifest.json");
    if (!fs.existsSync(manifestPath)) continue;
    const manifest = JSON.parse(fs.readFileSync(manifestPath, "utf-8"));
    const eggName = (type === "themes" ? "theme-" : "grammar-") + id + ".egg";
    const eggPath = path.join("plugins", eggName);
    if (!fs.existsSync(eggPath)) continue;
    const size = fs.statSync(eggPath).size;
    plugins.push({
      id: manifest.id,
      name: manifest.name,
      description: manifest.description || "",
      version: manifest.version || "1.0.0",
      author: manifest.author?.displayName || "Unknown",
      type: type === "themes" ? "theme" : "grammar",
      url: raw + "/plugins/" + eggName,
      size,
      updated: new Date().toISOString().slice(0, 10)
    });
  }
}

const index = {
  version: 1,
  updated: new Date().toISOString(),
  plugins
};
fs.writeFileSync("index.json", JSON.stringify(index, null, 2));
console.log("index.json: " + plugins.length + " plugins");
'
