@echo off
REM Build all .egg plugins + regenerate index.json (Windows)
cd /d "%~dp0"
if not exist plugins mkdir plugins

for /d %%D in (sources\themes\*) do (
    echo building theme: %%~nxD
    pushd "%%D"
    jar -cMf "..\..\plugins\theme-%%~nxD.egg" .
    popd
)

for /d %%D in (sources\grammars\*) do (
    echo building grammar: %%~nxD
    pushd "%%D"
    jar -cMf "..\..\plugins\grammar-%%~nxD.egg" .
    popd
)

node build-index.js
echo Done.
