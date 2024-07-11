#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys

def print_odd_number(n):
    print(str(n)+" is an odd number")
    
def print_even_number(n):
    print(str(n)+" is an even number")

if __name__ == "__main__":
    # Check if the correct number of arguments are provided
    if len(sys.argv) != 2:
        print("Usage: python script.py arg1")
        sys.exit(1)

    # Extract command-line arguments
    n = int(sys.argv[1])
    
    if n%2==0:
        print_even_number(n)
    else:
        print_odd_number(n)
    
    sys.exit(0)
    
    