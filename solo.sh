# This script installs a Rust server with custom mods, starting from a blank Ubuntu server.

# Stop the script if any command ends with an error.
set -e
cd

# Install Ubuntu packages.
sudo apt update
sudo add-apt-repository multiverse
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y lib32gcc1 steamcmd emacs unzip

# Delete any old Rust server installation. Start fresh every time.
rm -rf rustserver
mkdir -p rustserver

# Install a Vanilla (un-modded) Rust server.
steamcmd +login anonymous +force_install_dir ~/rustserver/ +app_update 258550 +quit

# Launch the Rust server.
cd rustserver/
./RustDedicated \
    -batchmode \
    -server.port 28015 \
    -server.maxplayers 64 \
    -server.hostname "Rustopolis | Solo Only" \
    -server.description "Solo only. No groups or teamwork allowed. Vanilla. Next wipe Jan 6. No BP wipe." \
    -server.url "https://rustgovernment.com" \
    -server.headerimage "https://rustnews201451270.files.wordpress.com/2020/10/evening-shot.png" \
    -server.identity "server1" \
    -rcon.port 28016 \
    -rcon.password "sxZU8U67" \
    -rcon.web 1 \
    -server.level "Procedural Map" \
    -server.seed 2837 \
    -server.worldsize 4000 \
    ;
