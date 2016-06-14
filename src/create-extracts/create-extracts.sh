#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

readonly CITIES_TSV=${CITIES_TSV:-"city_extracts.tsv"}
readonly COUNTRIES_TSV=${COUNTRIES_TSV:-"country_extracts.tsv"}
readonly WORLD_MBTILES=${WORLD_MBTILES:-"world.mbtiles"}
readonly EXTRACT_DIR=$(dirname "$WORLD_MBTILES")
readonly PATCH_SRC="$EXTRACT_DIR/world_z0-z5.mbtiles"


<<<<<<< HEAD
function update_metadata_entry() {
    local extract_file="$1"
    local name="$2"
    local value="$3"
    local stmt="UPDATE metadata SET VALUE='$value' WHERE name = '$name';"
    sqlite3 "$extract_file" "$stmt"
}

function insert_metadata_entry() {
    local extract_file="$1"
    local name="$2"
    local value="$3"
    local stmt="INSERT OR IGNORE INTO metadata VALUES('$name','$value');"
    sqlite3 "$extract_file" "$stmt"
}

function update_metadata() {
    local extract_file="$1"
    local extract_bounds="$2"
    local extract_center="$3"
    local min_zoom="$4"
    local max_zoom="$5"
    local attribution='<a href="http://www.openstreetmap.org/about/" target="_blank">&copy; OpenStreetMap contributors</a>'
    local filesize="$(wc -c $extract_file)"

    insert_metadata_entry "$extract_file" "type" "baselayer"
    insert_metadata_entry "$extract_file" "attribution" "$attribution"
    insert_metadata_entry "$extract_file" "version" "$VERSION"
    update_metadata_entry "$extract_file" "minzoom" "$min_zoom"
    update_metadata_entry "$extract_file" "maxzoom" "$max_zoom"
    update_metadata_entry "$extract_file" "name" "osm2vectortiles"
    update_metadata_entry "$extract_file" "id" "osm2vectortiles"
    update_metadata_entry "$extract_file" "description" "Extract from osm2vectortiles.org"
    update_metadata_entry "$extract_file" "bounds" "$extract_bounds"
    update_metadata_entry "$extract_file" "center" "$extract_center"
    update_metadata_entry "$extract_file" "basename" "${extract_file##*/}"
    update_metadata_entry "$extract_file" "filesize" "$filesize"
}

function create_extracts_from_tsv() {
    local tsv_filename="$1"
}

function create_extracts() {
    #create_lower_zoomlevel_extract "world_z0-z5.mbtiles" 0 5
    #create_lower_zoomlevel_extract "world_z0-z8.mbtiles" 0 8

    while IFS=$'\t' read extract country city top left bottom right; do
        if [[ "$extract" != 'extract' ]]; then
            create_extract "${extract}.mbtiles" "$left" "$bottom" "$right" "$top"
        fi
    done < "$CITIES_TSV"


    while IFS=$'\t' read extract country top left bottom right; do
        if [[ "$extract" != 'extract' ]]; then
            create_extract "${extract}.mbtiles" "$left" "$bottom" "$right" "$top"
        fi
    done < "$COUNTRIES_TSV"
}

=======
>>>>>>> 7d20815... Start rewriting extract generation in Python
function main() {
    if [ ! -f "$WORLD_MBTILES" ]; then
        echo "$WORLD_MBTILES not found."
        exit 10
    fi

    local upload_flag='--upload'
    if [ -z "${S3_ACCESS_KEY}" ]; then
        upload_flag=''
        echo 'Skip upload since no S3_ACCESS_KEY was found.'
    fi

    # Generate patch sources first but do not upload them
    python -u create_extracts.py zoom-level "$WORLD_MBTILES" \
        --max-zoom=5 --target-dir="$EXTRACT_DIR"
    python -u create_extracts.py zoom-level "$WORLD_MBTILES" \
        --max-zoom=8 --target-dir="$EXTRACT_DIR"

    python -u create_extracts.py bbox "$WORLD_MBTILES" "$CITIES_TSV" \
        --patch-from="$PATCH_SRC" --target-dir="$EXTRACT_DIR" $upload_flag
    python -u create_extracts.py bbox "$WORLD_MBTILES" "$COUNTRIES_TSV" \
        --patch-from="$PATCH_SRC" --target-dir="$EXTRACT_DIR" $upload_flag
}

main
