#!/bin/bash

cat > /var/www/html/index.html <<EOF
<html lang="en">
<body bgcolor="${COLOR:-gray}">
  <h1>${TITLE:-Welocme}</h1>
  ${BODY:-Please use TITLE/COLOR/BODY env vars}
  <hr>
  Copiralyt: 2024.
</body>
</html>
EOF

exec nginx -g "daemon off;"