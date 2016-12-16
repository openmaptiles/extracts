FROM node:5
MAINTAINER Lukas Martinelli <me@lukasmartinelli.ch>

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN npm install -g \
      tilelive@5.12.x \
      mapnik@3.5.x \
      mbtiles@0.8.x \
      tilelive-tmsource@0.4.x \
      tilelive-vector@3.9.x \
      tilelive-bridge@2.3.x \
      tilelive-mapnik@0.6.x

RUN apt-get update && apt-get install -y --no-install-recommends \
        sqlite3 \
        bc \
        python \
        python-pip \
    && rm -rf /var/lib/apt/lists/

VOLUME /export
ENV PLANET_MBTILES=/export/planet.mbtiles \
    PATCH_MBTILES=/export/planet_z0-z5.mbtiles

COPY requirements.txt /usr/src/app/requirements.txt
RUN pip install -r requirements.txt
COPY . /usr/src/app/
CMD ["./create-extracts.sh"]
