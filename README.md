# Creating a static site with Docker and Let's Encrypt
This repo leverages Docker and two related projects:

- [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy)
- [jrcs/letsencrypt-nginx-proxy-companion](https://github.com/jrcs/letsencrypt-nginx-proxy-companion)

The `nginx-proxy` project automates [Nginx](http://nginx.org/en/docs/) setup as
a reverse proxy for websites. When the `nginx-proxy` container is started, it
will automatically create an Nginx configuration file and reverse proxy for any
container with an exposed port and create a reverse proxy for it.

The `lets-encrypt-nginx-proxy-companion` container will automatically configure
a [Let's Encrypt](https://letsencrypt.org) certificate to secure the sites
served. Other than providing the site's domain and an email address, there is no
configuration required.

This repo provides a few scripts and `docker-compose.yml` files. Deploying a
secure website requires cloning the repo, providing your email address and a
domain for each site to be served, and starting the containers. Everything else
is automated. After they're up and running, copy your static assets to the `web`
folder of each `site`.

The repo includes scripts to start, stop, and take down all the containers.

You can run a web application as well. See the instructions at the end of this
README.

## Requirements
This repo requires a server properly configured with Git and
[Docker](https://docs.docker.com/get-started/), with ports 80 and 443 open. It
also requires a domain name with properly configured DNS.

## Step 1. Clone the repo
Clone this repo into a `webserver` folder on your server and `cd` into it.

```sh
git clone https://github.com/jluckyiv/docker-nginx-proxy-letsencrypt-static webserver
cd webserver
```

## Step 2. Customize with your domain and email
Each `./site/site*` folder represents a website. Rename or copy the `site`
folders for each site you want to serve. For example, if you're serving
three sites, you might do this:

```sh
mv site/site1 first.example.com
cp -r site/site2 second.example.com
mv site/site2 anotherexample.com
```

Each `site` folder contains a `sample.env` file. Copy each of those to a real
`.env` file. To prevent inadvertent publication of any secrets, the `.gitignore`
file for this repo ignores `.env`.

In each `.env` file, customize the `VIRTUAL_HOST` variable with your domain and
the `EMAIL` variable with your email.

The `docker-compose.yml` files need no modification. It’s unnecessary to expose
port 443 on individual sites because `nginx-proxy` is exposing ports 80 and 443.

## Step 3 Start the servers
Go to the root `webserver` folder and execute the following scripts. You might
need to `chmod +x *.sh` before you do.

```
./proxy_up.sh # starts nginx-proxy and letsencrypt-companion containers
./sites_up.sh # starts all website containers
```

That's it. Your websites are up and in a few seconds, each will have a Let's
Encrypt certificate.

## Test it
Go to Qualys's [SSL Labs](https://www.ssllabs.com/ssltest) site and test your domain's security: A+

## Copy static assets
Now that your sites are up and running, copy your static assets into the `web`
folder of the appropriate site. The `web` folders are mounted as volumes, so
changes within the `web` folder are served without restarting or rebuilding the
site container.

## Custom web applications
This scaffold can serve any web app, as long as it meets a few requirements.

1. The site must be inside a subfolder of `/.sites/`.
2. The site must have a `docker-compose.yml` file in its root folder.
3. The `docker-compose.yml` file must `expose` a port (any port).
4. The `docker-compose.yml` file must include `network_mode: bridge`.
5. The `environment` block in `docker-compose.yml` must set three variables:
   - `VIRTUAL_HOST`
   - `LETSENCRYPT_HOST`
   - `LETSENCRYPT_EMAIL`
   The two `*HOST` variables should have the same value.
