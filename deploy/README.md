# Deploy the application to production

## Requirements
- Docker & Docker Compose
- HTTPS reverse proxy

This application won't work if not using HTTPS so a reverse proxy is mandatory.

## Installation
On your server, create a directory to deploy the application and copy both the `docker-compose.yaml` and `env.sh`.

### Set up the deployment parameters
Make `env.sh` executable with :
```
chmod u+x env.sh
```

Then, run it :
```
./env.sh
```

This will create the .env file containing secrets for the application.

You can remove it :
```
rm env.sh
```

You can also fine tune the parameters, for example by changing the port which will be bind on the host to access the application with `APP_PORT`.

### Starting the application
Now, start the application with :
```
docker compose up -d
```

Note : This may take a while the first time (two minutes or more) as it needs to apply the database migrations.

You can now setup your reverse proxy to start using the application.

## Usage
The value of `AUTH_SECRET` in the .env file is the one to be used to log into the app when "Login with Secret".
