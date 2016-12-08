#!/usr/bin/env python
"""Generate jobs for rendering tiles in pyramid and list format in JSON format

Usage:
  add_hash.py <csv_file>
  add_hash.py (-h | --help)
  add_hash.py --version

Options:
  -h --help                     Show this screen.
  --version                     Show version.
"""

import shutil
import csv
import os.path
import hashlib
from docopt import docopt


if __name__ == '__main__':
    args = docopt(__doc__, version='0.1')
    with open(args['<csv_file>'], "r") as file_handle:
        for line in file_handle:
            coords = line.split(',')[-4:]
            min_lon = float(coords[0])
            min_lat = float(coords[1])
            max_lon = float(coords[2])
            max_lat = float(coords[3])
            identifier = 'openmaptiles_{}_{}_{}_{}'.format(min_lon, min_lat, max_lon, max_lat)
            m = hashlib.md5()
            m.update(identifier)
            id = m.hexdigest()
            print(line.strip() + ',' + id)
