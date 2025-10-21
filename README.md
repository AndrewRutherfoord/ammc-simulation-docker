# AMMC Simulation Docker

A Docker-based simulation environment for [AMM Converter (AMMC)](https://www.ammconverter.eu/) software, providing a containerized setup for running the simulator and decoder to build services around the AMMC software.

## Overview

This project uses Docker Compose to run two services:
- **sim**: Runs the AMMC simulator (ammc-sim) to generate transponder passings
- **decoder**: Runs the AMMC AMB decoder and websocket interface on port 9000

Both services communicate over a custom bridge network (`10.10.0.0/16`) to provide static IPs for the services.

## Prerequisites

- Docker Engine installed
- Docker Compose V2+

## Quick Start

1. Clone the repository:
```bash
git clone https://github.com/AndrewRutherfoord/ammc-simulation-docker.git
cd ammc-simulation-docker
```

2. Start the simulation:
```bash
docker compose up
```

3. Access the AMMC decoder websocket
```
ws://localhost:9000
```

4. Stop the simulation:
```bash
docker compose down
```

## Configuration

The simulation can be customized using environment variables. Create a `.env` file in the project root or set variables directly. You can refer to the example `.env.example` file for guidance. Without creating the `.env` file, default values will be used.

To see a variable reference see the AMMC Simulator Docs: https://www.ammconverter.eu/docs/simulator/usage/

## License

This project is for testing and simulation purposes. The AMM Converter software is proprietary and subject to its own licensing terms.

## Resources

- [AMM Converter Official Website](https://www.ammconverter.eu/)

