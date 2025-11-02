FROM python:3.13.7-trixie

SHELL ["/bin/bash", "--login", "-c"]

# Install NVM, Node
RUN apt-get update && apt-get install -y jq && \
cd /root && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash \
&& export NVM_DIR="$HOME/.nvm" \
&& [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" \
&& nvm install v22.18.0 \
&& nvm use v22.18.0 \
&& npm install -g npm@11.6.0


# Setting global environment variables 
ENV NVM_DIR="/root/.nvm"
ENV NODE_VERSION="v22.18.0"
ENV PATH="/root/.nvm/versions/node/v22.18.0/bin:$PATH"
ENV AWS_REGION="us-east-1"


# Install the AWS CLI v2 
RUN cd /root/ && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
&& unzip awscliv2.zip && cd aws && ./install \
&& cd /root && rm -rf aws awscliv2.zip 


# Install iam-lens and iam-collect 
RUN cd /root && npm install -g @cloud-copilot/iam-collect \
&& cd /root && npm install -g @cloud-copilot/iam-lens && iam-collect init


# git clone the iam-dangerous-actions repo & copy necessary files to /root
RUN cd /root && git clone https://github.com/ZiyadAlmbasher/iam-dangerous-actions \
&& cd /root/iam-dangerous-actions \
&& cp /root/iam-dangerous-actions/scripts/* /root/ \
&& cp -rf /root/iam-dangerous-actions/lists/* /root/ 