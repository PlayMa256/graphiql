#!/bin/bash

set -e
set -o pipefail

if [ ! -d "node_modules/.bin" ]; then
  echo "Be sure to run \`npm install\` before building GraphiQL."
  exit 1
fi

rm -rf dist/ && mkdir -p dist/
babel src --ignore __tests__ --out-dir dist/
echo "Bundling graphiql-custom-headers.js..."
browserify -g browserify-shim -s GraphiQL dist/index.js > graphiql-custom-headers.js
echo "Bundling graphiql-custom-headers.min.js..."
browserify -g browserify-shim -t uglifyify -s GraphiQL dist/index.js 2> /dev/null | uglifyjs -c > graphiql-custom-headers.min.js 2> /dev/null
echo "Bundling graphiql-custom-headers.css..."
postcss --no-map --use autoprefixer -d dist/ css/*.css
cat dist/*.css > graphiql-custom-headers.css
echo "Done"
