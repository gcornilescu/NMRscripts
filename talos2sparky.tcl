#!/bin/sh
# The next line restarts using nmrWish \
exec nmrWish "$0" -- "$@"

# G.C. 2012

set auto_path "[split $env(TCLPATH) :] $auto_path"
set ARGV      [concat $argv0 $argv]
set ARGC      [llength $ARGV]

if {$argc != 1} \
   {
    puts stderr "usage: talos2sparky talos.tab"
    exit
   }

set inFile [lindex $argv 0]
set inFileID [open $inFile r]

set assList ""

puts "     Assignment         w1         w2 \n"

gdbInit
gdbCreate dBase -name ASS

set tab [gdbRead table -in $inFile -name CS -verb]
set entry [gdbFirst $tab]

while {$entry} \
   {
    set resID		[gdbGet $entry RESID]
    set resName($resID)	[gdbGet $entry RESNAME]
    set atName		[gdbGet $entry ATOMNAME]
    set shift($resID,$atName) [gdbGet $entry SHIFT]

    if {[lsearch $assList $resID] < 0} \
       {
        append assList "$resID "
       }

    set entry [gdbNext $entry]
   }

foreach i $assList \
   {
    set ass "N-H"
    set assall $resName($i)$i$ass

    if {[info exists shift($i,HN)] == 1} \
       {
        puts [format "%15s %10.3f %10.3f" $assall $shift($i,HN) $shift($i,N)]
       }
   }

exit
