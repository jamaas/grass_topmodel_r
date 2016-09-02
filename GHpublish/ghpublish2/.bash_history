g.list type=raster
g.list type=raster
g.copy raster=GHsm_5m@six_ind_walks, GHrast
g.copy raster=GHsm_5m@six_ind_walks,GHrast
g.copy
g.copy raster=GHsm_5m,GHrast
g.list type=raster
g.list type=vector
r.in.gdal input=/home/jamaas/research/ra1188uea/Enigma/GH-Publish-GRASS/GHrast.asc output=GHrast
r.in.gdal input=/home/jamaas/research/ra1188uea/Enigma/GH-Publish-GRASS/GHrast.asc output=GHrast -o
g.list type=raster
g.remove raster =GHrast
g.remove raster=GHrast
g.remove
g.remove type=raster name=GHrast@ghpublish2
g.remove -f type=raster name=GHrast@ghpublish2
g.list type=raster
r.in.gdal input=GHrast.asc output=GHsm_5m -o
r.in.gdal input=GHrast output=GHsm_5m -o
r.in.gdal input=./GHrast.asc output=GHsm_5m -o
g.remove -f type=raster name=GHsm_5m@ghpublish2
r.in.gdal input=./GHrast.asc output=GHsm_5m -o
v.in.ogr input=/home/jamaas/research/ra1188uea/Enigma/GH-Publish-GRASS/GHvect.shp layer=GHvect output=GHvect
v.in.ogr input=/home/jamaas/research/ra1188uea/Enigma/GH-Publish-GRASS/GHvect.shp layer=GHvect output=GHvect -o
ls
ls *.bsh
cp GH_GRASS.bsh GH_GRASS2.bsh 
cp GH_GRASS.bsh GH_GRASS1.bsh 
rm GH_GRASS.bsh
e GH_GRASS2.bsh 
bash GH_GRASS2.bsh
bash GH_GRASS2.bsh
exit
ls
bash GH_GRASS2.bsh 
ls
ls
cd GHpublish/
ls
ls -al
cd ghpublish2/
ls
cd ..
pwd
cd ~/research/ra1188uea/Enigma/GH-Publish-GRASS/
ls
ls -al
git remote -v
ls -lt
exit
ls *.bsh
bash GH_GRASS2.bsh 
cd graphs_\&_stats/
ls
e GH_grph_stats.R
cd ..
git remote -v
cd ~/research/ra1188uea/Enigma/GH-Publish-GRASS/
git remote -v
git remote -v
git add -A
git commit -m 'removed unnecessary files and emacs backups'
git push remotegrass master
exit
