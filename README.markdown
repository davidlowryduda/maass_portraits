
# Portrait code for Maass Forms #

This is code used for producing images of Maass forms. Several examples of how
this code works and how to use it to produce images of Maass forms can be found
in the sagemath notebook [Maass
Experiments.ipynb](./notebook/Maass%20Experiments.ipynb).

This repository contains four other files of interest.

- [lpkbessel.spyx](./lpkbessel.spyx), a cython file for sage that includes
  fast, double precision routines to compute K-Bessel functions. These are
  mostly taken from Fredrik Strömberg.
- [maass_evaluator.spyx](./maass_evaluator.spyx), a cython file for sage that
  has rudimentary logic to quickly compute approximations to Maass forms. There
  is nothing particularly special here &mdash; we don't use modularity or
  anything clever. But the math functions are in C or cython, and cython seems
  capable of doing loop-speedup-magic without extra work on my part.
- a [Makefile](./Makefile) that knows how to compile the two cython files above
  on linux systems. Type `make usage` or just `make` to see a brief message on
  what compilation options are available. In practice, you'll want to type
  `make compile` and then your sage will try to compile the two cython files
  above into `.so` files that can be used for plotting.

  I don't know anything about sage or cython on Windows, but presumably this
  either just works or is easy to modify.
- [maass_plotter.sage](./maass_plotter.sage), which contains the plotting logic
  used to produce Maass form plots in the LMFDB.


# Licensing #

```
      This is code for producing images of Maass forms.
      Copyright (c) 2024 David Lowry-Duda <david@lowryduda.com>
      All Rights Reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see
                <http://www.gnu.org/licenses/>.
```

All of the code here is available under GPLv3+. See the LICENSE file for more.

This directory includes code written by Fredrik Strömberg, also available under
GPL. Each sourcefile includes relevant licensing information.
