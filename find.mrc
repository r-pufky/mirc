; ftp Find script, v1.0
; load using the /load command
; will initally load on connect
; access menus will be a right click in any window

; adds ftp directories to find
alias addftpdir {
  set %continue $true
  while ( %continue ) {
    getdir
    echo @Find %st Adding %vt $+ %ftpdir $+ %st to FTP directories.
    set %continue $?!="Add another FTP directory?"
  }
  echo @Find %st Updating Files in directories...

  /write -c %files

  set %numdir $lines(%dirdat)
  var %i = 1
  while (%i <= %numdir) {
    set %ftpdir $read(%dirdat, %i)
    echo @Find %st Processsing FTP Directory: %vt $+ %ftpdir $+ %st ...
    $findfile(%ftpdir,*.*,0,write %files $1- ( $+ $file($1-).size $+ ) )
    $finddir(%ftpdir,*.*,0,write %files $1- (DIR) )
    inc %i
    echo @Find %nt Finshed.
  }
  set %filecount $lines(%files)

  echo @Find %nt $+ ==================================== $+
  echo @Find %st $+ Files loaded Successfully! $+ %vt %filecount files loaded.
}

; removes all ftpdirectories from find
alias RemoveAll {
  /restore
  echo @Find %st Removing all FTP directories...
  set %ftpdir c:\
  ;set %removeall $true
  /write -c %dirdat

  echo @Find %st Updating Files in directories...

  /write -c %files

  set %numdir $lines(%dirdat)
  var %i = 1
  while (%i <= %numdir) {
    set %ftpdir $read(%dirdat, %i)
    echo @Find %st Processsing FTP Directory: %vt $+ %ftpdir $+ %st ...
    $findfile(%ftpdir,*.*,0,write %files $1- ( $+ $file($1-).size $+ ) )
    $finddir(%ftpdir,*.*,0,write %files $1- (DIR) )
    inc %i
    echo @Find %nt Finshed.
  }
  set %filecount $lines(%files)

  echo @Find %nt $+ ==================================== $+
  echo @Find %st $+ Files loaded Successfully! $+ %vt %filecount files loaded.
}

; remove ONE directory from find
alias RemoveOne {
  /restore
  var %i = 1
  set %temp $null
  while (%i <= $lines(%dirdat)) {
    set %temp %temp $read(%dirdat, %i) $+ ; $+
    inc %i
  }
  set -n %temp $sdir(%ftpdir,Valid FTP directories to remove are: %temp)
  var %i = 1
  while (%i <= $lines(%dirdat)) {
    if (%temp == $read(%dirdat, %i) ) {
      echo @find %st Removing FTP Directory: %vt $+ %temp $+ %nt Removed!
      set %temp -dl $+ %i $+
      /write %temp %dirdat
      set %i $calc( $lines(%dirdat) + 1 )
    }   
    inc %i
  }

  echo @Find %st Updating Files in directories...

  /write -c %files

  set %numdir $lines(%dirdat)
  var %i = 1
  while (%i <= %numdir) {
    set %ftpdir $read(%dirdat, %i)
    echo @Find %st Processsing FTP Directory: %vt $+ %ftpdir $+ %st ...
    $findfile(%ftpdir,*.*,0,write %files $1- ( $+ $file($1-).size $+ ) )
    $finddir(%ftpdir,*.*,0,write %files $1- (DIR) )
    inc %i
    echo @Find %nt Finshed.
  }
  set %filecount $lines(%files)

  echo @Find %nt $+ ==================================== $+
  echo @Find %st $+ Files loaded Successfully! $+ %vt %filecount files loaded.
}

; updates trigger
alias updatetrig {
  set %trig $?="Enter your Trigger"
  ;check to see if they entered ! or not
  if ( $pos( %trig,! $+ $chr(32) $+,1) != 1 ) { set %trig ! %trig }
  /write -l17 %ini %trig
  echo @find %st Updating Trigger to: %vt $+ %trig $+
}

; updates system color
alias updatest {
  /restore
  set %temp %st
  set %st $?="Enter the new color set for SYSTEM TEXT"
  if ( $pos( %st,,1) != 1 ) { set %st  $+ %st $+ }
  /write -l14 %ini %st
  echo @Find %temp Updated System Text Colors to: %st $+ SYSTEM TEXT $+
}

; update normal color
alias updatent {
  /restore
  set %nt $?="Enter the new color set for NORMAL TEXT"
  if ( $pos( %nt,,1) != 1 ) { set %nt  $+ %nt $+ }
  /write -l13 %ini %nt
  echo @Find %st Updated Normal Text Colors to: %nt $+ NORMAL TEXT $+
}

; update variable color
alias updatevt {
  /restore
  set %vt $?="Enter the new color set for VARIABLE TEXT"
  if ( $pos( %vt,,1) != 1 ) { set %vt  $+ %vt $+ }
  /write -l15 %ini %vt
  echo @Find %st Updated Variable Text Colors to: %vt $+ VARIABLE TEXT $+
}

; update error color
alias updateet {
  /restore
  set %et $?="Enter the new color set for ERROR TEXT"
  if ( $pos( %et,,1) != 1 ) { set %et  $+ %et $+ }
  /write -l16 %ini %et
  echo @Find %st Updated Variable Text Colors to: %et $+ ERROR TEXT $+
}

; update auto-refresh time
alias updateRT {
  /restore
  set %Reftime $?="Enter time between automatic refreshing (in minutes)" 
  /write -l6 %ini %reftime
  echo @Find %st Refresh Rate is set to ever $+ y $+ %vt %Reftime %st $+ minutes. $+
  /.timer10 off
  /.timer10 1 $calc( 60 * %reftime ) /refresh
}

; update response time
alias updateTD {
  /restore
  set %timedelay $?="Enter the new timedelay in Milliseconds." 
  /write -l3 %ini %timedelay
  echo @Find %st Updated Timedelay to $+ : $+ %vt %timedelay %st $+ Milliseconds. $+
}

; update max return results
alias updateRM {
  /restore
  set %ReturnMax $?="Enter the Maximum amount of results returned to searcher" 
  /write -l2 %ini %ReturnMax
  echo @Find %st Updated Max Return Results to $+ : $+ %vt %ReturnMax %st $+ results. $+
}

; enable / disable auto-refresh
alias enableAR {
  /restore
  if %Refresh {
    set %Refresh $false
    /.timer10 off
    echo @Find %st Automatic Directory refresh has been turned %vt $+ OFF. $+
  }
  else {
    set %Refresh $true
    /.timer10 1 $calc( 60 * %reftime ) /refresh
    echo @Find %st Automatic Directory refresh has been turned %vt $+ ON. $+
  }
  /write -l7 %ini %Refresh
}

; enable / disable logging to file
alias enableLF {
  /restore
  if %logfile {
    set %logfile $false
    echo @Find %st Logging to file has been turned %vt $+ OFF. $+
  }
  else {
    set %logfile $true
    echo @Find %st Logging to file has been turned %vt $+ ON. $+
  }
  /write -l4 %ini %logfile
}

; enable / disable logging to screen
alias enableLS {
  /restore
  if %logscrn {
    set %logscrn $false
    echo @Find %st Logging to screen has been turned %vt $+ OFF. $+
  }
  else {
    set %logscrn $true
    echo @Find %st Logging to screen has been turned %vt $+ ON. $+
  }
  /write -l5 %ini %logscrn
}

; enable / disable find
alias enableF {
  /restore
  if %find {
    set %find $false
    echo @Find %st @find has been %vt $+ DISABLED. $+
  }
  else {
    set %find $true
    echo @Find %st @find has been %vt $+ ENABLED. $+
  }
  /write -l8 %ini %find
}

; reload settings from ini file
alias reloadSet {
  /restore
  echo @find %st Reloading settings from ini file...
  /reset
  /load
}

; restore system to default configuration
alias restoreD {
  /restore
  echo @find %st Restoring Default Values...
  /defaultAll
  /reset
  /refresh
}

; information on @find script
alias info {
  if $?!="@find script, Version 1.0.  This script was created as a replacement for bare bones find scripts.  The features in this script should surpass anything out on mIRC right now.  Please do NOT steal code, just give me credit if you use an idea or code part from this program.  Options are avaliable by right-clicking in any open mIRC window, and are intuitive.  GUI interface (to complement the right click interface) as well as some minor bug fixes coming in v1.1 (about a week or so!).  Many Thanks to Mr_Frog for his help in my problems with this script, as well as msw,FaraosCat, and DoG for their testing it.  Have Fun" == $false {
    echo @find %nt You Suck!
  }
}

; Sets up the directorys and Variables to use.
alias setFind {
  ; Set directory variables
  set %dir $mircdir $+ Find\ $+
  set %ini %dir $+ ini.dat $+
  set %dirdat %dir $+ dirdat.dat $+
  set %files %dir $+ files.dat $+
  set %findtmp1 %dir $+ data1.tmp $+
  set %findtmp2 %dir $+ data2.tmp $+
  set %log $mircdir $+ logs\ $+ Find.log
  set %corrupt $false

  ; setup directories and default values if any
  if ($exists(%dir) == $false) { /.mkdir %dir }
  if ($exists(%ini) == $false) { /.copy find.mrc %ini | write -c %ini }
  if ($exists(%dirdat) == $false) { /.copy %ini %dirdat }
  if ($exists(%findtmp1) == $false) { /.copy %ini %findtmp1 }
  if ($exists(%files) == $false) { /.copy %ini %files }
  if ($exists(%findtmp2) == $false) { /.copy %ini %findtmp2 }
  if ($exists(%log) == $false) { /.copy %ini %log }

  ; format for ini
  ; read     ident        write
  ; 0         version     1
  ; 1         Returns max 2
  ; 2         timedelay   3
  ; 3         log to file 4
  ; 4         log to scn. 5
  ; 5        Refresh time 6
  ; 6      Refresh on/off 7
  ; 7      Find on/off    8
  ; 8      Searchtimestot 9 
  ; 9      Searchtimesref 10
  ;10  firststart time    11
  ;11  last refresh time  12
  ;12  Normal text color  13  
  ;13  System working txt 14
  ;14  Variable text      15
  ;15  error message text 16
  ;16  trig               17

  if ( $lines( %ini ) < 17 ) {
    if ( $lines( %ini ) != 0 ) { set %corrupt true }
    defaultAll    
  }

  reset

  window -da @Find 
  echo @Find %nt $+ @Find Script $+ %vt %version
  echo @Find %nt $+ ---------------------------- $+
  if %corrupt { 
    echo @Find %et $+ ini file was corrupted.  Deleting and remaking with defualt settings.
  }
  echo @Find %st Loading...
}

; load / reload the FTP
alias load {
  /restore
  /stats

  if ( $lines(%dirdat) == 0 )  { 
    echo @Find %et FTP directories not set!
    set %continue $true
    while ( %continue ) {
      getdir
      echo @Find %st Adding %vt $+ %ftpdir $+ %st to FTP directories.
      set %continue $?!="Add another FTP directory?"
    }
  }

  set %numdir $lines(%dirdat)

  var %i = 1
  /write -c %findtmp1
  while (%i <= %numdir) {
    if $exists($read(%dirdat, %i)) {
      echo @Find %st Checking FTP Directory: %vt $+ $read( %dirdat, %i) $+ %nt exists!
      /write %findtmp1 $read(%dirdat, %i)
    }
    else {
      echo @Find %sw Checking FTP Directory: %vr $+ $read( %dirdat, %i) $+ %et Does Not Exist!, removing from list.
    } 
    inc %i
  }

  /write -c %dirdat
  /filter -ff %findtmp1 %dirdat *

  echo @Find %nt FTP directories OK!

  ; get trig
  if ( %trig == NONE ) {
    echo @Find %et Trigger ID not found!
    set %trig $?="Enter your Trigger"
    ;check to see if they entered ! or not
    if ( $pos( %trig,! $+ $chr(32) $+,1) != 1 ) { set %trig ! %trig }
    /write -l17 %ini %trig
  }

  echo @Find %st Trigger set to: %vt $+ %trig $+

  echo @Find %st Updating Files in directories...

  /write -c %files

  set %numdir $lines(%dirdat)
  var %i = 1
  while (%i <= %numdir) {
    set %ftpdir $read(%dirdat, %i)
    echo @Find %st Processsing FTP Directory: %vt $+ %ftpdir $+ %st ...
    $findfile(%ftpdir,*.*,0,write %files $1- ( $+ $file($1-).size $+ ) )
    $finddir(%ftpdir,*.*,0,write %files $1- (DIR) )
    inc %i
    echo @Find %nt Finshed.
  }

  ;start auto refresh timer
  if %Refresh {
    /.timer10 1 $calc( 60 * %reftime ) /refresh
  }

  set %filecount $lines(%files)

  echo @Find %nt $+ ==================================== $+
  echo @Find %st $+ Files loaded Successfully! $+ %vt %filecount files loaded.
  echo @Find %nt $+ Ready for searching on $asctime($ctime) $+
}

; restores Find Window
alias restore {
  /window -da @Find
}

; gets an ftpdir
alias getdir {
  set -n %ftpdir $sdir(%ftpdir,FTP directory to use)
  if (%ftpdir == $null) { set %ftpdir $mircdir $+ download\ $+ }
  /write %dirdat %ftpdir
}

; refreshes FTP server
alias refresh { 
  /restore
  echo @Find %st Refreshing FTP settings...
  load
}

; reloads all variables from ini file
alias reset {
  set %version $read( %ini, 1)
  set %ReturnMax $read( %ini, 2)
  set %timedelay $read( %ini, 3)
  set %logfile $read( %ini, 4)
  set %logscrn $read( %ini, 5)
  set %Reftime $read( %ini, 6)
  set %Refresh $read( %ini, 7)
  set %Find    $read( %ini, 8)
  set %searchtimestot $read( %ini, 9)
  set %searchtimesref $read( %ini, 10)
  set %FirstStart $read( %ini, 11)
  set %Lastreftime $read( %ini, 12)
  set %nt $read( %ini, 13)
  set %st $read( %ini, 14)
  set %vt $read( %ini, 15)
  set %et $read( %ini, 16)
  set %trig $read( %ini, 17)
}

;resets every value to defualt value (i.e. fresh install)
alias defaultAll {
  /write -c %ini 4,1v1.0
  /write %ini 10
  /write %ini 2000
  /write %ini $true
  /write %ini $true
  /write %ini 60
  /write %ini $true
  /write %ini $true
  /write %ini 0
  /write %ini 0
  /write %ini $ctime
  /write %ini 0
  /write %ini 8,1
  /write %ini 9,1
  /write %ini 11,1
  /write %ini 4,1
  /write %ini NONE
  set %ftpdir c:\
  set %removeall $false
  set %filecount $null
  var %i = 1
}  

;shows Status for Find script
alias stats {
  /restore
  echo @find %nt $+ ===================================== $+
  echo @find %nt $+ @Find stats $+
  echo @find %nt $+ ===================================== $+
  echo @find %nt $+ @find Version: $+ %vt %version 
  if %logfile { echo @find %nt $+ Logging to file is $+ %vt ON.
  }
  else { echo @find %nt $+ Logging to file is $+ %vt OFF. }
  if %logscrn { echo @find %nt $+ Logging to screen is $+ %vt ON.
  }
  else { echo @find %nt $+ Logging to screen is $+ %vt OFF. }
  if %Refresh { echo @find %nt $+ Auto-Refresh FTP directories is $+ %vt ON.
  }
  else { echo @find %nt $+ Auto-Refresh FTP directories is $+ %vt OFF. }
  if %find { echo @find %nt $+ @Find is $+ %vt Active.
  }
  else { echo @find %nt $+ @Find is $+ %vt Disabled. }
  echo @find %nt $+ Max Return Results on Find is $+ %vt %ReturnMax
  echo @find %nt $+ Time-delay between results display is $+ %vt %timedelay %nt $+ Millisceonds. $+
  echo @find %nt $+ Time between Auto-refresh is $+ %vt %reftime %nt $+ minutes. $+
  echo @find %nt $+ Normal color text is: $+ %nt NORMAL COLOR
  echo @find %nt $+ System color text is: $+ %st SYSTEM COLOR
  echo @find %nt $+ Variable color text is: $+ %vt VARIBALE COLOR
  echo @find %nt $+ Error color text is: $+ %et ERROR COLOR
  echo @find %nt $+ Your current trigger is: $+ %vt %trig
  var %i = 1
  set %temp $null
  while (%i <= $lines(%dirdat)) {
    set %temp %temp  $read(%dirdat, %i) $+ ; $+
    inc %i
  }
  echo @find %nt $+ Current directories are: $+ %vt %temp
  echo @find %nt $+ You have been searched a total of $+ %vt %searchtimestot %nt $+ times. $+
  echo @find %nt $+ You have been searched $+ %vt %searchtimesref %nt $+ times since your last Directory refresh. $+
  echo @find %nt $+ Find last reset on: $+ %vt $asctime(%FirstStart)
  echo @find %nt $+ Last Refresh was on: $+ %vt $asctime(%Lastreftime)
  echo @find %nt $+ Your Average Search Rate Since last Refresh is: $+ %vt $calc( %searchtimesref / (($ctime - %lastreftime)/60) ) %nt $+ searches / minute. $+
  echo @find %nt $+ Your Average Search Rate Overall is: $+ %vt $calc( %searchtimestot / (($ctime - %FirstStart)/60) ) %nt $+ searches / minute. $+
  set %Lastreftime $ctime
  set %searchtimesref 0
  /write -l12 %ini %lastreftime
  /write -l10 %ini %searchtimesref
  set %refreshtemp $false
  echo @find %nt $+ ===================================== $+
}

; on connect auto start the script
on *:connect: {
  /setfind
  /load
}

; on search for files
on *:text:@find*:*: {
  if %find {
    set %findstr $2-      

    ;
    if %logscrn { echo @Find %nt $+ ( $+ $asctime($ctime) $+ ) $+ %vt $nick %nt $+ is searching for: $+ %vt %findstr }

    /write -c %findtmp1
    /filter -ff %files %findtmp1 * $+ %findstr $+ *

    set %numresults $lines(%findtmp1)
    set %loopmax $null

    if ( %numresults != 0 ) {
      ; check to see if the results were over the max number of results allowed
      /write -c %findtmp2
      if ( %numresults > %ReturnMax ) {
        /notice $nick $nick - Search found %numresults files for 4,0 $+ %findstr  $+ - showing %ReturnMax / %numresults ( $+ 4,0 %trig  $+ )
        set %numr %ReturnMax
        /write -a %findtmp2 %nt $+ Showing $+ %vt %ReturnMax %nt $+ of %numresults results, with a $+ %vt %timedelay %nt $+ ms delay. $+
      }
      else {
        /notice $nick $nick - Search found %numresults files for 4,0 $+ %findstr  $+ - showing %numresults / %numresults ( $+ 4,0 %trig  $+ )
        set %numr %numresults
        /write -a %findtmp2 %nt $+ Showing $+ %vt %numresults %nt $+ of %numresults results, with a $+ %vt %timedelay %nt $+ ms delay. $+
      }

      set %temp 0- $+ %numr $+
      echo %temp
      /filter -ffr %temp %findtmp1 %findtmp2 
      /write -a %findtmp2 %nt $+ Type ( $+ %vt %trig %nt $+ ) in channel to access FTP $+

      set %loopmax $lines(%findtmp2)
      /write -c %findtmp1
      var %i = 1
      while ( %i <= %loopmax ) {
        set %temp $read(%findtmp2, %i)
        /write -a %findtmp1 %st %temp
        inc %i
      }

      /msg $nick %nt $+ @Find Script %version $+ %vt (File size in bytes)
      /.play $nick %findtmp1 %timedelay
    }
    else { /notice $nick Sorry, search Did not Find Any Results for %findstr $+ , try different search words. $+ }

    inc %searchtimestot
    inc %searchtimesref

    /write -l9 %ini %searchtimestot
    /write -l10 %ini %searchtimesref

    set %temp $calc( %loopmax - 2 )
    if %temp < 0 { set %temp 0 }
    if %logscrn { echo @Find %nt $+ ( $+ $asctime($ctime) $+ ) Found: $+ %vt %numresults %nt $+ results for search: $+ %vt %findstr %nt $+ - showing $+ %vt %temp %nt $+ results. }
    if %logfile {
      /write -a $mircdir $+ logs\ $+ Find.log ( $+ $asctime($ctime) $+ ) $nick is searching for: %findstr
      /write -a $mircdir $+ logs\ $+ Find.log ( $+ $asctime($ctime) $+ ) Found: %numresults results for search: %findstr - showing %temp results.
    }
  }
}

menu * {
  @Find
  .Restore Window:/restore
  .Refresh Server:/refresh
  .Add FTP directory:/addftpdir
  .Remove ONE FTP dir.:/RemoveOne
  .Remove ALL FTP dir.:/RemoveAll
  .Settings
  ..Trigger:/UpdateTrig
  ..System color:/updateST
  ..Variable color:/updateVT
  ..Normal color:/updateNT
  ..Error color:/updateET
  ..Auto Refresh time:/updateRT
  ..Response Time:/updateTD
  ..Max Return Results:/updateRM
  .Enable / Disable
  ..Auto Refresh:/enableAR
  ..Logging to file:/enableLF
  ..Logging to Screen:/enableLS
  ..Find:/enableF
  .Stats:/stats
  .Reload Settings from ini:/reloadSet
  .Restore Defualts:/restoreD
  .Information:/info
}
