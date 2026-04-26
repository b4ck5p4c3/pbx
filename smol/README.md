# Smol

Smol – is an Asterisk termination proxy for BKSP PBX. It handles all
the hassle of NAT, TLS and SRTP, serving you an inequisite plain
endpoint to connect your persnickety SIP client to.

> [!IMPORTANT]
> Smol is a B4CKSP4CE-specific project and is not intended for general use.

## Introduction

Following documentation considers a few assumptions:

1. Local IP of your Smol instance is `192.0.2.1`
2. SIP client will be configured with username `100` and password `100`
3. Your BKSP PBX credentials are all set to `1234` (username, password, extension)

## Installation

> [!NOTE]
> Note that Smol overrides its configuration from environment variables, on a first launch.
If you want to change the configuration, update `.env` file, destroy the existing container and create it again.

```shell
# Clone the repository
git clone https://github.com/b4ck5p4c3/pbx.git

# Make a copy of the configuration template
cd pbx/smol
cp .env.example .env

# Adjust the configuration in .env file according to your environment
nano .env

# Build and run the Smol container
docker compose up -d
```

## Vendor-specific configuration

Check the [guides section](./guides) for vendor specific guides on deployment.
