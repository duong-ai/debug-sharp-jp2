1. Note your path/to/debug-sharp-jp2 to this repo
2. `docker build -t 'debug-sharp-jp2' .`
3. `docker run -v path/to/debug-sharp-jp2:/home/node/app --rm -it debug-sharp-jp2 /bin/sh`
4. `cd /home/node/app`
5. `npm start`
