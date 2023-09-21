FROM node:lts

USER root 
# install nginx for reverse proxy to run 2 endpoints with single open port (HF Space restriction)
# https://huggingface.co/spaces/radames/nginx-gradio-reverse-proxy/blob/main/Dockerfile

RUN apt-get -y update && apt-get -y install nginx git curl unzip

RUN mkdir -p /var/cache/nginx \
             /var/log/nginx \
             /var/lib/nginx
RUN touch /var/run/nginx.pid

# create new user to avoid running as root
RUN useradd -m -u 1001 user

RUN chown -R user:user /var/cache/nginx \
                       /var/log/nginx \
                       /var/lib/nginx \
                       /var/run/nginx.pid
USER user 

ENV HOME=/home/user \
	PATH=/home/user/.local/bin:$PATH


WORKDIR $HOME/app

COPY --chown=user . $HOME/app

WORKDIR $HOME/app/openv0_server

RUN npm install

WORKDIR $HOME/app/openv0_vitereact

RUN npm install

COPY --chown=user nginx.conf /etc/nginx/sites-available/default

RUN chmod +x /home/user/app/run.sh

CMD /home/user/app/run.sh