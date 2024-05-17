"""
# **********************************************************************
#       This is maass_plotter.sage
#       Copyright (c) 2024 David Lowry-Duda <david@lowryduda.com>
#       All Rights Reserved.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see
#                 <http://www.gnu.org/licenses/>.
# **********************************************************************
"""
from io import BytesIO as IO
from matplotlib.backends.backend_agg import FigureCanvasAgg
from base64 import b64encode
from urllib.parse import quote
import subprocess


from lpkbessel import besselk_dp
from maass_evaluator import maassform


DtoH = lambda x: (-CDF.0*x + 1)/(x - CDF.0)


def make_single_plot(R, symmetry, coeffs):
    """
    Given a spectral parameter R, a symmetry (0 or 1), and a list of
    coefficients (50 are used if available), this produces a single plot.
    """
    fcc = maassform(R, symmetry, coeffs)
    P = complex_plot(
            lambda z: +Infinity if abs(z) >= 0.99 else fcc(DtoH(z)),
            (-1, 1), (-1, 1),
            plot_points=300, aspect_ratio=1, figsize=[2.2, 2.2],
            # TODO extra options?
            cmap='matplotlib')
    P.axes(False)
    return P


def make_plot_for_lmfdb_by_record(record):
    """
    For example, record could be a cursor ranging across db.maass_rigor.
    We require that record have dictionary-type access for keys
        - "maass_label"
        - "coefficients"
        - "symmetry"
        - "spectral_parameter"
    """
    label = record['maass_label']
    R = record['spectral_parameter']
    symmetry = record['symmetry']
    coeffs = record['coefficients'][:50]

    oldname = f"{label}.plot.white.png"
    newname = f"{label}.plot.png"

    P = make_single_plot(R, symmetry, coeffs)
    P.save(f"{label}.plot.white.png", figsize=[2.2, 2.2], axes=False,
            transparent=True)
    make_transparent_version(oldname, newname)
    with open(newname, "rb") as pngfile:
        data = pngfile.read()
        b64data = b64encode(data)
    return "data:image/png;base64," + quote(b64data)


def make_plot_for_lmfdb_by_label(label):
    from lmfdb import db
    record = db.maass_rigor.lucky(query={'maass_label': label})
    make_plot_for_lmfdb_by_record(record)



def make_transparent_version(oldname, newname):
    # Requires imagemagick
    subprocess.run(
        ['convert', oldname, '-fuzz', '3%', '-transparent', 'white', newname]
    )


# TODO remove when done
# Below is mocking data for testing.
# I remove this when everything functions.

R = 12.9827317296260657613548775278
symmetry = 0
coeffs = [1,
 1.64351344560035367390427086548,
 0.420551381883206072903263382234,
 1.70113644586919928411975832696,
 0.447213595499957939281834733746,
 0.691181850690915491341100532616,
 -0.377964473009227227214516536234,
 1.15232717598656033402301570008,
 -0.823136535196071452739639971446,
 0.73500155725945869522252727443,
 -0.672501128518829987400368643509,
 0.715415283082266032844945528497,
 0.198111881653547898515185080591,
 -0.621189693349916916963509016354,
 0.188076295584464460237356138062,
 0.192728761595425261922937286623,
 -1.21609403303096993967926724371,
 -1.35283596315967176578104069743,
 1.7977998708891506290069193287,
 0.760771346393184183536612806889,
 -0.158953481426788254051296779919,
 -1.10526464690215634985041491702,
 0.0419781909901593553258692784929,
 0.484612786242759350114801265381,
 0.2,
 0.325599541230805117744695525486,
 -0.766722589238525329465471572118,
 -0.642969140279741706863231937071,
 -1.53042074452220173081941152178,
 0.309105920591799404464279828381,
 -1.80163626427756747623838762053,
 -0.835574864950594186428459073337,
 -0.282821278916645685895127656571,
 -1.99866689440080083740153828774,
 -0.169030850945703315501923665473,
 -1.40026755994860591368875549051,
 0.31681460014830585473237749836,
 2.95470826030490922492021578091,
 0.0833162255969015372924995652723,
 0.515336379565262438947530483106,
 0.386262111251425420013442349259,
 -0.261242183949934251555150246645,
 -1.12951502643569838344102238272,
 -1.1440161796116176564123174191,
 -0.368117849492412790140784301278,
 0.0689917213142714765247748308388,
 0.295791719180783126638277517602,
 0.0810523470175750251007930873456,
 0.142857142857142857142857142857,
 0.328702689120070734780854173096]
label="0.0.0.0.1"

record = {}
record["maass_label"] = label
record["spectral_parameter"] = R
record["coefficients"] = coeffs
record["symmetry"] = symmetry

from base64 import b64decode

label = record['maass_label']
R = record['spectral_parameter']
symmetry = record['symmetry']
coeffs = record['coefficients'][:50]

oldname = f"{label}.plot.white.png"
newname = f"{label}.plot.png"

P = make_single_plot(R, symmetry, coeffs)
P.save(f"{label}.plot.white.png", figsize=[2.2, 2.2], axes=False,
        transparent=True)
make_transparent_version(oldname, newname)
with open(newname, "rb") as pngfile:
    data = pngfile.read()
    b64data = b64encode(data)

im = Image.open(IO(b64decode(b64data)))
im.save("test.png", "PNG")
