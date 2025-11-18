# AMMC Simulation Docker

A Docker Compose-based environment for running the AMMC simulator and decoder in containers ([AMM Converter Official Website](https://www.ammconverter.eu/)). The repository provides a base compose file with the decoder and simulator, and optional compose files that add database containers for all of the databases supported by AMMC:
- Postgres
- MongoDB
- MariaDB

## Overview

This project uses Docker Compose to run at minimum two services:
- `sim`: Runs the AMMC simulator (`ammc-sim`) to generate transponder passings
- `ammc-amb`: Runs the AMMC AMB decoder (`ammc-amb`). The decoder connects to the simulator to receive passings like it would for a real decoder. In the default setup, the decoder exposes a websocket/API interface on port `9000` of the host.

Optional database services are provided as separate compose fragments:
- `docker-compose.postgres.yaml` — PostgreSQL service
- `docker-compose.mongo.yaml` — MongoDB service
- `docker-compose.mariadb.yaml` — MariaDB/MySQL service

All services are attached to a custom bridge network (`10.10.0.0/16`) with static IPs so the `decoder` and `sim` can reliably communicate.

## Prerequisites

- Docker Engine installed. Alternatively use podman. Podman has the same command line syntax as Docker and is free.
- Docker Compose V2+. Alternatively use podman-componse

## Quick start

1. Clone the repository and change into it:

```bash
git clone https://github.com/AndrewRutherfoord/ammc-simulation-docker.git
cd ammc-simulation-docker
```

2. Create a `.env` file based on the provided example:

```bash
cp .env.example .env
```

3. Run the default setup (simulator + decoder) using the base compose file:

```bash
docker compose up -d
```

4. Open the decoder interface (websocket/API) at:

```
ws://localhost:9000
```

5. Stop and remove containers:

```bash
docker compose down
```

## Using simulation with MyLaps X2 configuration

The Ammc-x2 contains simulation mode embedded inside the main executable. There is no need to start simulator separately.
Just use `-m` command line param like this:

    docker run --init ammc ./ammc-x2 user password host -m -w 9000

## Using optional database compose files

The repo splits optional DB services into separate compose files so you only enable the DB you need. Combine them with the base file using `-f` in the desired order.

### PostgreSQL

```bash
docker compose -f docker-compose.yaml -f docker-compose.postgres.yaml up -d
```

### MongoDB

```bash
docker compose -f docker-compose.yaml -f docker-compose.mongo.yaml up -d
```

### MariaDB/MySQL

```bash
docker compose -f docker-compose.yaml -f docker-compose.mariadb.yaml up -d
```

### Notes:

- Compose file order matters: later files override or extend earlier ones.
- The DB fragments add a container at `10.10.0.4` and make the `decoder` depend on the DB healthy state where appropriate.
- Changes to the command in the base compose file will be overridden by those in the DB fragments. So if you need to modify the decoder command when using a DB fragment, do so in that fragment file.

## Environment variables

Configure behavior via a `.env` file (see `.env.example`). Important variables used by the compose files include:

- Simulator variables: `SIM_PASSING_DELAY`, `SIM_DECODER_ID`, `SIM_HITS`, `SIM_PASSING_NUMBERS`, `SIM_STRENGTH`, `SIM_TRANSPONDER`, `SIM_STARTUP_DELAY`, `SIM_SHUTDOWN_DELAY`
- Database variables: `DB_NAME`, `DB_USER`, `DB_PASSWORD`

The `docker-compose.*.yaml` fragments set the DB container IP to `10.10.0.4` by default; the `decoder` uses these connection values to populate its `--db` argument. See `.env.example` for a ready-to-edit sample.

## Development & useful commands

- View logs:

```bash
docker compose logs -f
docker compose logs -f ammc-amb
```

## Disclaimer 

This repository is for testing and simulation purposes only. For production use or deployment of the AMMC or databases in this repository, please refer to the official of the given software providers. The authors of this repository are not responsible for any issues arising from the use of this software in production environments.

## License

This project is for testing and simulation purposes. The AMM Converter software is proprietary and subject to its own licensing terms.

## Resources

- [AMM Converter Official Website](https://www.ammconverter.eu/)

