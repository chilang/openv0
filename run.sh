#!/bin/bash

service nginx start
cd /home/user/app/openv0_server && node index.js &
cd /home/user/app/openv0_vitereact && npm run dev
# mk demo flash-fill --api-port 5555 --frontend-port 8000 --api-url https://atlasfutures-meerkat-demo.hf.space