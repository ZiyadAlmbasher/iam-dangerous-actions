
# Instructions for installing Docker:  

<br />

We can use the following commands to install Docker on Ubuntu based Operating Systems (Linux Mint, Linux Lite, Kubuntu, Zorin OS, etc.):

```bash
sudo apt update

sudo apt install -y docker.io

sudo systemctl enable docker --now

sudo usermod -aG docker $USER

sudo apt-get install ca-certificates curl

sudo install -m 0755 -d /etc/apt/keyrings

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


sudo apt update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
<br />

It is strongly recommended to reboot the system at this point to ensure all changes take effect. After rebooting, we can verify the installation by running:

```
docker --version 
```
<br />
<br />

Back to the main [iam-dangerous-actions page](https://github.com/ZiyadAlmbasher/iam-dangerous-actions).