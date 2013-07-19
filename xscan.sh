#!/bin/bash

# Zum Scannen in einen pat_nr Pat.ordner. Basierend auf patordner.sh
# Speedpoint GmbH (MR,FW), Stand: Februar 2012, Version 2

# Bitte anpassen:    ###########################################################
#
ip="192.168.0.20"                    # IP des WinPC (Rexserver!)
port="6666"                          # Port fuer Rexserver
batch="c:\\david\startscan.bat"      # Batchdatei am WinPC, "c:\\" beachten!!
#
################################################################################

# Und los...

# Welcher Patient ist gerade augerufen?
serverpfad=$DAV_HOME/trpword/pat_nr
pfad=`echo $1 | awk '{printf("%08.f\n",$1)}' \
              | awk -F '' '{printf("%d/%d/%d/%d/%d/%d/%d/%d",$1,$2,$3,$4,$5,$6,$7,$8)}'`
fullpfad=$serverpfad/$2/$pfad
mkdir -p -m 0777 "$fullpfad" > "/dev/null" 2>&1  

# Leeres Zwischenziel fuer gescantes PDF anlegen:
link="/home/david/trpword/Patient"
if [ ! -d $link ]; then
   mkdir $link
fi
rm -f $link/* 2>>/dev/null

if [ ! -d $link ]; then
   kdialog --sorry "Pat.ordner konnte nicht angelegt werden, bitte Speedpoint anrufen."
   exit 1
fi

#Batchscan am Windowsrechner starten:
echo "DAVCMD start /min $batch" | netcat $ip $port >/dev/null

# Dokumentennamen erfragen:
docnam=`kdialog --inputbox "Bitte einen Dokumentennamen eingeben:"`
if [ $? = 1 ]; then
   rm -f $link/*
   kdialog --error "ABBRUCH, Dokument wurde nicht gespeichert."
   exit 1
fi

# PDF speichern:
docpdf=`echo $docnam | sed 's/ /_/g'`
cp -pf $link/*.pdf $fullpfad/$docpdf.pdf
rm -f $link/*

exit 0
