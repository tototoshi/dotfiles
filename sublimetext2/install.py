#!/usr/bin/env python
import os
import shutil
import logging

logging.basicConfig(
                    format="%(asctime)s %(levelname)s %(message)s",
                    level=logging.DEBUG,
                    datefmt="%Y-%m-%d %H:%M:%S"
                    )

cwd = os.path.dirname(__file__)
home = os.getenv('HOME')
install_dir = os.path.join(home, 'Library', 'Application Support', 'Sublime Text 2', 'Packages', 'User')

for f in os.listdir(os.path.join(cwd, '.')):
	dest = os.path.join(install_dir, f)
	shutil.copyfile(f, dest)
	logging.info("Copied %s to %s" % (f, dest))