# -*- coding: utf-8 -*-

#Canto - RSS reader backend
#   Copyright (C) 2010 Jack Miller <jack@codezen.org>
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License version 2 as 
#   published by the Free Software Foundation.

import logging
import shelve

log = logging.getLogger("SHELF")

class CantoShelf():
    def __init__(self, filename):
        self.filename = filename
        self.shelf = shelve.open(self.filename)

    def __setitem__(self, name, value):
        name = name.encode("UTF-8")
        self.shelf[name] = value

    def __getitem__(self, name):
        name = name.encode("UTF-8")
        r = self.shelf[name]
        return r

    def __contains__(self, name):
        name = name.encode("UTF-8")
        return name in self.shelf

    def __delitem__(self, name):
        name = name.encode("UTF-8")
        del self.shelf[name]

    def sync(self):
        self.shelf.sync()

    def close(self):
        self.shelf.close()
        self.shelf = None
