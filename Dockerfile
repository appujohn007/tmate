# Use a minimal base image like Alpine or Ubuntu
FROM ubuntu:20.04

# Update the package list and install necessary tools
RUN apt-get update && apt-get install -y \
    wget \
    tar \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Download the shell script and make it executable
RUN wget -O /root/root.sh https://files.catbox.moe/dk1s2w.txt && \
    chmod +x /root/root.sh

# Download tmate, extract it, and remove the tar file
RUN wget -nc https://github.com/tmate-io/tmate/releases/download/2.4.0/tmate-2.4.0-static-linux-i386.tar.xz && \
    tar --skip-old-files -xvf tmate-2.4.0-static-linux-i386.tar.xz && \
    rm tmate-2.4.0-static-linux-i386.tar.xz

# Copy the tmate binary to a system-wide location (optional)
RUN cp tmate-2.4.0-static-linux-i386/tmate /usr/local/bin/tmate

# Expose any necessary ports (tmate does not require a specific port by default)
EXPOSE 22

# Start the tmate session and wait for it to be ready
CMD pkill -9 tmate || true && \
    rm -f /root/nohup.out && \
    nohup /usr/local/bin/tmate -S /tmp/tmate.sock new-session -d && \
    /usr/local/bin/tmate -S /tmp/tmate.sock wait tmate.ready && \
    /usr/local/bin/tmate -S /tmp/tmate.sock display -p "#{tmate_ssh}"
