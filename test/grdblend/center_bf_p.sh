#!/usr/bin/env bash
# Shows bug in grdblend when cutting across input grids
# The bottom region should equal the inset box on top.
# This is for the native float format. Pixel registration.
ps=center_bf_p.ps
gmt grdmath -R-2/0/-2/0 -I1 -r X Y ADD = LL.grd=bf
gmt grdmath -R0/2/-2/0  -I1 -r X Y ADD = LR.grd=bf
gmt grdmath -R-2/0/0/2  -I1 -r X Y ADD = UL.grd=bf
gmt grdmath -R0/2/0/2   -I1 -r X Y ADD = UR.grd=bf
gmt grdblend -R-1/1/-1/1 -I1 -r LL.grd=bf LR.grd=bf UL.grd=bf UR.grd=bf -GCM.nc
gmt grdblend -R-2/2/-2/2 -I1 -r LL.grd=bf LR.grd=bf UL.grd=bf UR.grd=bf -Gall.nc
gmt makecpt -Cjet -T-4/4 > t.cpt
gmt grdimage CM.nc -Ct.cpt -JX4i -P -Bafg2 -K -Xc > $ps
gmt grd2xyz CM.nc | gmt pstext -RCM.nc -JX4i -O -K -F+f16p+jCM >> $ps
gmt grdimage all.nc -Ct.cpt -JX4i -P -Bafg2 -BWsNE+t"Pixel native binary bf" -O -K -Y4.5i >> $ps
gmt grdinfo CM.nc -Ib | gmt psxy -Rall.nc -JX4i -W4p -O -K -A >> $ps
gmt grd2xyz all.nc | gmt pstext -Rall.nc -JX4i -O -F+f16p+jCM  >> $ps
