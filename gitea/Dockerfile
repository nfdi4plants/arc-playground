FROM gitea/gitea:latest

COPY app.ini /data/gitea/conf/app.ini
COPY gitea.db /data/gitea/gitea.db

RUN mkdir -p /git/adm /lfs                 \
 && git init --bare   /git/adm/arc-a.git   \
 && git init --bare   /git/adm/arc-b.git   \
 && git init --bare   /git/adm/arc-c.git   \
 && chown -R git.git /git /lfs

