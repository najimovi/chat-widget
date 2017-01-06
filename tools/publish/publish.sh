#!/bin/sh

# based on https://gist.github.com/stevemao/280ef22ee861323993a0

# npm publish with goodies
# prerequisites:
# `npm install -g trash conventional-recommended-bump conventional-changelog conventional-github-releaser conventional-commits-detector json`
# `np` with optional argument `patch`/`minor`/`major`/`<version>`
# defaults to conventional-recommended-bump
# and optional argument preset `angular`/ `jquery` ...
# defaults to conventional-commits-detector
# np() {
    travis status --no-interactive &&         # borrar node_modules
    trash node_modules &>/dev/null;
    git pull --rebase &&                      # traer lo ultimo, instalar dependencies
    npm install &&                            # y correr tests
    npm test &&
    cp package.json _package.json &&          # hace copia de backup del package.json, por?
    preset=`conventional-commits-detector` && # ccd returns commit message type, eg: angular
    echo $preset &&
    bump=`conventional-recommended-bump -p angular` &&  # recommend bump type based on commit messages
    echo ${1:-$bump} &&
    npm --no-git-tag-version version ${1:-$bump} &>/dev/null &&
    conventional-changelog -i CHANGELOG.md -s -p ${2:-$preset} &&
    git add CHANGELOG.md &&
    version=`cat package.json | json version` &&
    git commit -m"docs(CHANGELOG): $version" &&
    mv -f _package.json package.json &&
    npm version ${1:-$bump} -m "chore(release): %s" &&
    git push --follow-tags &&
    conventional-github-releaser -p ${2:-$preset} &&
    npm publish
# }
