const fs = require('fs')
const path = require('path')
const pckg = require('../package.json')

const script = path.resolve(__dirname, '../bin/nbcompile.sh')
let contents = fs.readFileSync(script).toString()
contents = contents.replace(/\[version\]/g, pckg.version)
fs.writeFileSync(script, contents)
