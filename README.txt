Last revised 21/11/2016 by JAM at UEA

doi = {10.5281/zenodo.61376}

This is a working group of files that was developed by Dr. Jim Maas at the
University of East Anglia to tackle a specific problem.  We needed select and
use a hydrological model, of which there are many to choose from, to predict
overland and subsurface water movement on six specific small areas of land, in
the United Kingdom.  Logically these water flows would be dependent on the
topography of the area, the soil type, and also the precipitation.  After a
review of the many combinations that are currently available, as of August 2016,
we settled on the combination of Geographic Resources Analysis Support System
(GRASS) GIS system, combined with a hydrolgical model called Topmodel and then
did data manipulation and statistical analysis using the R programme.

Each of these programmes are open-source and thus freely available.  In this
project we have opted to use the Linux operating system, however each of these
programmes are available for others.

The working example here draws very heavily on an example that was publicly
posted previously by Huidae Cho, who also wrote the GRASS module that performs
Topmodel functions specifically.  The website is located at
"https://idea.isnew.info/r.topmodel.html".  The script was then modified and
updated by Dr. Roy Sanderson at the University of Newcastle, UK whereupon I took
over and made a few adjustments to tie it all together.

This software comes with no guarantees whatsoever however I can be contacted with
questions at jamaas@uea.ac.uk.
