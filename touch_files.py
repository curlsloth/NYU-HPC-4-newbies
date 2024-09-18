#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jul 30 05:11:34 2024

@author: andrewchang
"""

import os
import sys
import time
from concurrent.futures import ProcessPoolExecutor

def touch_access_only(path):
    # Get the current time for access time
    current_time = time.time()
    # Get the current access and modification times
    stat = os.stat(path)
    access_time = current_time
    modification_time = stat.st_mtime
    # Update only the access time
    os.utime(path, (access_time, modification_time))

def get_all_files(root_folder):
    # Collect all file paths
    file_paths = []
    for dirpath, dirnames, filenames in os.walk(root_folder):
        for filename in filenames:
            file_path = os.path.join(dirpath, filename)
            file_paths.append(file_path)
    return file_paths

def main(root_folder):
    # Get a list of all files
    file_paths = get_all_files(root_folder)

    # Use ProcessPoolExecutor to touch files in parallel
    with ProcessPoolExecutor() as executor:
        executor.map(touch_access_only, file_paths)

# Example usage
if __name__ == "__main__":
    root_folder = sys.argv[1]
    main(root_folder)




