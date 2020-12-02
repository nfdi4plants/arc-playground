FROM gitea/gitea:latest

COPY app.ini /data/gitea/conf/app.ini
COPY gitea.db /data/gitea/gitea.db

RUN git init --bare   /data/git/repositories/adm/arc-a.git   \
 && chown -Rv git.git /data/git/repositories/adm/arc-a.git   \
 && git init --bare   /data/git/repositories/adm/arc-b.git   \
 && chown -Rv git.git /data/git/repositories/adm/arc-b.git   \
 && git init --bare   /data/git/repositories/adm/arc-c.git   \
 && chown -Rv git.git /data/git/repositories/adm/arc-c.git

EXPOSE 3000