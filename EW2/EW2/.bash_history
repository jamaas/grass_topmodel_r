g.copy rast="GHrast@PERMANENT,EW2rast@EW2"
g.copy rast=GHrast@PERMANENT,EW2rast
g.copy vect=GHvect@PERMANENT,EW2vect
exit
v.in.ogr input=/home/jamaas/research/ra1188uea/Enigma/Enigma-Area2-Publish-GRASS/GHvect.shp layer=GHvect output=GHvect --overwrite
g.copy vect=GHvect@EW2,EW2vect
exit
g.rename raster=GHrast@PERMANENT,EW2rast
g.rename raster=GHrast@PERMANENT,EW2rast@PERMANENT
g.remove GHrast
g.remove GHvect
g.remove GHvect@EW2
g.remove vector=GHvect@EW2
g.remove -f type=vector name=GHvect
exit
ls
cd ..
exit
ls
cd ..
ls *.bsh
bash EW2
bash EW2_GRASS.bsh
e EW2_GRASS.bsh
r.in.gdal input=./EW2rast.asc output=EW2sm_5m -o --overwrite
ls *.asc
cp GHrast.asc EW2rast.asc
r.in.gdal input=./EW2rast.asc output=EW2sm_5m -o --overwrite
ls *.shp
cp GHvect.shp EW2vect.shp
v.in.ogr input=EW2vect.shp layer=EW2vect output=EW2walk -o --overwrite
v.in.ogr input=EW2vect.shp layer=EW2vect output=EW2walk -o --overwrite
bash EW2_GRASS.bsh
bash EW2_GRASS.bsh
exit
exit
ls *.bsh
rm GH_GRASS.bsh 
e calculate_area_ratios.bsh 
bash EW2_GRASS.bsh
bash EW2_GRASS.bsh
bash EW2_GRASS.bsh
bash EW2_GRASS.bsh
bash EW2_GRASS.bsh
ls -al
bash EW2_GRASS.bsh
ls *.bsh
e EW2_GRASS.bsh
e postprocess.R 
bash EW2_GRASS.bsh
touch *.*
bash EW2_GRASS.bsh
exit
