#!/usr/bin/env python
#this is script which install gitlab
#Example: python setup.py install
#-*- coding: utf-8 -*
 
 
import os
import sys
from setuptools import setup


setup(
    scripts = [
        'scripts/myscript.sh'
    ]
)
 

if(__name__ == "__main__"):
    main()
