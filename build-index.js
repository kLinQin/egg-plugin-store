const fs = require("fs");
const path = require("path");
const base = "sources";
const plugins = [];
const raw = "https://raw.githubusercontent.com/kLinQin/egg-plugin-store/main";

for (const type of ["themes", "grammars", "iconpacks"]) {
  const dir = path.join(base, type);
  if (!fs.existsSync(dir)) continue;
  for (const id of fs.readdirSync(dir)) {
    const src = path.join(dir, id);
    const manifestPath = path.join(src, "manifest.json");
    if (!fs.existsSync(manifestPath)) continue;
    const manifest = JSON.parse(fs.readFileSync(manifestPath, "utf-8"));
    const eggName = (type === "themes" ? "theme-" : type === "grammars" ? "grammar-" : "iconpack-") + id + ".egg";
    const eggPath = path.join("plugins", eggName);
    if (!fs.existsSync(eggPath)) continue;
    plugins.push({
      id: manifest.id,
      name: manifest.name,
      description: manifest.description || "",
      version: manifest.version || "1.0.0",
      author: manifest.author?.displayName || "Unknown",
      type: type === "themes" ? "theme" : type === "grammars" ? "grammar" : "iconpack",
      url: raw + "/plugins/" + eggName,
      size: fs.statSync(eggPath).size,
      updated: new Date().toISOString().slice(0, 10)
    });
  }
}

const index = { version: 1, updated: new Date().toISOString(), plugins };
fs.writeFileSync("index.json", JSON.stringify(index, null, 2));
console.log("index.json: " + plugins.length + " plugins");
