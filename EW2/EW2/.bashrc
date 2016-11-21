test -r ~/.alias && . ~/.alias
PS1='GRASS 7.0.5 (EW2):\w > '
grass_prompt() {
	LOCATION="`g.gisenv get=GISDBASE,LOCATION_NAME,MAPSET separator='/'`"
	if test -d "$LOCATION/grid3/G3D_MASK" && test -f "$LOCATION/cell/MASK" ; then
		echo [2D and 3D raster MASKs present]
	elif test -f "$LOCATION/cell/MASK" ; then
		echo [Raster MASK present]
	elif test -d "$LOCATION/grid3/G3D_MASK" ; then
		echo [3D raster MASK present]
	fi
}
PROMPT_COMMAND=grass_prompt
##alias e=emacs

e () {
  /usr/bin/emacs "$@" &
}


PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '
export GRASS_GNUPLOT="gnuplot -persist"
export GRASS_PYTHON=python
export GRASS_PAGER=pager
export GRASS_HTML_BROWSER=xdg-open
export GRASS_ADDON_BASE=/home/jamaas/.grass7/addons
export GRASS_PROJSHARE=/usr/share/proj
export GRASS_VERSION=7.0.5
export PATH="/usr/lib/grass70/bin:/usr/lib/grass70/scripts:/home/jamaas/.grass7/addons/bin:/home/jamaas/.grass7/addons/scripts:/usr/local/texlive/2015/texmf-dist/doc/man:/usr/local/texlive/2015/texmf-dist/doc/info:/usr/local/texlive/2015/bin/x86_64-linux:/usr/local/texlive/2015/texmf-dist/doc/man:/usr/local/texlive/2015/texmf-dist/doc/info:/usr/local/texlive/2015/bin/x86_64-linux:/home/jamaas/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/lib/jvm/java-8-oracle/bin:/usr/lib/jvm/java-8-oracle/db/bin:/usr/lib/jvm/java-8-oracle/jre/bin:/home/jamaas/.rvm/bin:/opt/adb:/opt/OpenBUGS312/bin:/usr/local/stata:/home/jamaas/.rvm/bin"
export HOME="/home/jamaas"
