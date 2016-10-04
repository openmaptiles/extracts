.PHONY: all

all: create-extracts

create-extracts:
	docker build -t osm2vectortiles/create-extracts .
