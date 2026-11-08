# docker-cliproxy

Ready-to-run Docker images for [cliproxy-rs](https://github.com/vayungodara/cliproxy-rs), for amd64 and arm64.
They use the official release binaries on top of the [LinuxServer.io](https://www.linuxserver.io/) Ubuntu base, so there's nothing to compile.

## Usage

```sh
docker compose up -d
```

Use the [`docker-compose.yml`](docker-compose.yml) in this repo, or just:

```sh
docker run -d --name cliproxy -p 8317:8317 -v ./data:/data ghcr.io/leonardoiz/cliproxy-rs:latest
```

Everything lives in `/data`, as in the [upstream image](https://github.com/vayungodara/cliproxy-rs/blob/master/docs/INSTALL.md#docker).
If there's no `data/config.yaml`, the first start creates one from [`root/defaults/config.yaml`](root/defaults/config.yaml)
and fills in random keys, which are also saved to `data/keys.env`:

- `CLIPROXY_CLIENT_KEY` is the API key your tools use.
- `CLIPROXY_MANAGEMENT_KEY` is the dashboard password. The server stores it hashed, so don't lose `keys.env`.

The dashboard is at `http://localhost:8317/management.html`. Sign in there and connect your accounts.

To use your own config, copy [`root/defaults/config.yaml`](root/defaults/config.yaml) to `data/config.yaml`, set your keys and start the container.

`PUID`, `PGID` and `TZ` work as in any LinuxServer image.

## Updates

A GitHub Action checks for new upstream releases every 6 hours and publishes them as `latest`, `X.Y` and `X.Y.Z`.
