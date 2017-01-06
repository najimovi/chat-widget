#!/bin/sh

# NOTES
# - based on https://gist.github.com/stevemao/280ef22ee861323993a0
# - must first generate a token for conventional-github-releaser to work and add it to ENV VAR (https://github.com/conventional-changelog/conventional-github-releaser#setup-token-for-cli)
# - I also had to do 'npm adduser' once
# - must add "conventional-changelog" and "conventional-changelog-cli" as dependencies I think
# - should use something like https://github.com/iarna/in-publish? it seems simpler to just have a script that we run and gets this steps done without using prepublish and stuff...

# TODO
# - remove auto detection of patch/minor/major/version release, force to enter manually?
# - fix existing CHANGELOG.md to remove the title in the middle of it
# - no tengo que crear branches nuevos para la version que usemos por nuestro gitflow? me parece que tengo que quitar/modificar varias cosas de la version actual







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

a script which we can run locally, to complete these tasks
- bump version in package.json (with the option to choose patch/minor/major)
- update the CHANGELOG.md, commit it
- npm publish
- generate the corresponding GitHub release
