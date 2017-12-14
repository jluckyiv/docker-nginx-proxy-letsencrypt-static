# Creating a static site with Docker and Let's Encrypt
This repo leverages Docker and two related projects:

  - [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy)
  - [jrcs/letsencrypt-nginx-proxy-companion](https://github.com/jrcs/letsencrypt-nginx-proxy-companion)

The combination makes creating a secure static site trivial.

## Step 1, nginx-proxy and Let’s Encrypt
I created a shell script to start the Nginx proxy and the Let's Encrypt automation. Running this script on the Docker host is all that’s needed to get everything up and running. I'm figuring out how to turn the shell scripts into a `docker.compose.yml` file. Just run `./start.sh` to spin them up.

Use `./stop.sh` to stop the containers and remove them, because you can’t add the `--rm` flag with a `--restart` flag.

## Step 2, Set up a static site
Each site will be in its own folder. Name the folder with the site’s domain. Almost done. Really.

The only customization necessary is copying the static assets and setting two environment variables.

### Copy the static assets
Put all your static assets in `web`. This folder will be mounted as a volume, which means modifying its contents will not require a rebuild of the Docker image.

### Create a `.env` file
Copy the `sample.env` file to `.env`. Replace the dummy values for `EMAIL` and `VIRTUAL_HOST`.

### The `Dockerfile` and `docker-compose.yml` file
The `Dockerfile` and `docker-compose.yml` files need no modification.

It’s unnecessary to expose port 443 because the `nginx-proxy` is taking care of that for us. Spin up the static site with `docker-compose up`. The `nginx-proxy` container automatically serves the page. The `letsencrypt-companion` container automatically creates a certificate and renews it. Incredible.
