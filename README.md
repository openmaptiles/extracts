# MBTiles Extracts from OpenMapTiles

The **create-extracts** component is responsible for cutting out specific country and
city extracts as specified in the `extracts.csv` CSV file from a planet scale MBTiles file.

It is made especially for cutting out vector tiles from the latest OSM2VectorTiles planet dump but can be adapted
to support other MBTiles formats.

## Usage

### Submit new Extract

You can modify the `extracts.csv` directly in GitHub and create a PR.

### Download Planet MBTiles

Download the entire planet and put it into `data`.

```bash
wget -O ./data/planet.mbtiles https://osm2vectortiles-downloads.os.zhdk.cloud.switch.ch/v2.0/planet_2016-06-20_3d4cb571d3d0d828d230aac185281e97_z0-z14.mbtiles
```

### Python

You can use the `create_extracts.py` Python script yourself to generate an extract and optionally upload it to S3.

```bash
# Create extracts limited by a bounding box specified in the CSV file
python create_extracts.py bbox planet.mbtiles extracts.csv
```

### Docker

To use **create-extracts** inside the Docker Compose workflow you need to have
a **full** `planet.mbtiles` ready in the `data` folder.

**create-extracts** will use `tilelive-copy` to cut out extracts for countries and cities.
To produce the extracts for all cities and countries this can take up to several days.
The results will be first be stored in the `data` folder and then uploaded
to a S3 if configured.

```
docker-compose run create-extracts
```
