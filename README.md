# Chromium Kiosk Wrapper

A snap for running Chromium in kiosk mode on Ubuntu Core, suitable for digital signage and dedicated display applications.

## Features

- Runs Chromium in full-screen kiosk mode
- Configurable URL via snap configuration
- Auto-restart on crash
- Wayland-only display support (for Ubuntu Core 24+)
- Uses the `chromium` snap via content interface for smaller size and easier updates

## Building

```bash
snapcraft
```

## Installation

```bash
# Install the chromium snap (required for content interface)
sudo snap install chromium

# Install your built snap
sudo snap install --dangerous chromium-kiosk-wrapper_*.snap

# Connect the content interface
sudo snap connect chromium-kiosk-wrapper:chromium-browser chromium:chromium-browser

# Connect additional interfaces for full functionality
sudo snap connect chromium-kiosk-wrapper:wayland
sudo snap connect chromium-kiosk-wrapper:opengl
sudo snap connect chromium-kiosk-wrapper:audio-playback
sudo snap connect chromium-kiosk-wrapper:camera
sudo snap connect chromium-kiosk-wrapper:removable-media
```

## Configuration

Configure the URL, additional Chromium flags, and debug mode:

```bash
# Set the URL to display (default: http://localhost)
sudo snap set chromium-kiosk-wrapper url="https://your-dashboard.example.com"

# Set additional Chromium flags (optional)
sudo snap set chromium-kiosk-wrapper flags="--disable-web-security --allow-running-insecure-content"

# Enable remote debugging on port 9222 (default: false)
sudo snap set chromium-kiosk-wrapper debug=true
```

The service will automatically restart when configuration changes.

When `debug=true`, Chromium's remote debugging port (9222) will be accessible at `http://<device-ip>:9222` for use with Chrome DevTools.

## Usage on Ubuntu Core

On Ubuntu Core, the snap will automatically start on boot as a daemon. The snap uses Wayland for display (required for Ubuntu Core 24+):

### Wayland (required for Ubuntu Core 24+)

```bash
# The snap provides a Wayland slot for compositor integration
# Configure your compositor (e.g., mir-kiosk) to use this snap
```

## Logs

```bash
# View service logs
sudo snap logs chromium-kiosk-wrapper

# Follow logs in real-time
sudo snap logs -f chromium-kiosk-wrapper
```

## Development

### Project Structure

```
.
├── snap/
│   ├── snapcraft.yaml      # Snap definition
│   └── hooks/
│       ├── install         # Set defaults on install
│       └── configure       # Handle config changes
├── scripts/
│   └── chromium-kiosk-launcher  # Main launcher script
└── overlay/                # Additional files (if needed)
```

### Customization

Edit `scripts/chromium-kiosk-launcher` to modify Chromium launch flags or behavior.

## License

MIT