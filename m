Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59319 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751975Ab0BNSXw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Feb 2010 13:23:52 -0500
Subject: alevt-dvb now part of the dvb-apps - some critical remarks /
 enhancements
From: Chicken Shack <chicken.shack@gmx.de>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Francesco Lavra <francescolavra@interfree.it>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-YFe0wR2wzfb27/q0UXfv"
Date: Sun, 14 Feb 2010 19:22:53 +0100
Message-ID: <1266171773.17110.25.camel@brian.bconsult.de>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-YFe0wR2wzfb27/q0UXfv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi everybody,
Hello Manu,

now that Francesco's proposal is reality I want to add some necessary
things as I do not want or appreciate an implementation of alevt-dvb
in a kind of half-way-down-the-line-style.

Either this is done correctly (100 %) or this should not be done at all.

I provide some patchset as outline attachment to improve:

1. alevt.patch: - Changes in Changelog, README and TODO
		  a nasty superfluous error message in vbi.c is being
		  wiped out

2. alevt.png:   wasn't part of the implemetation patch,
		please apply manually in the main directory of alevt

3. apps_manpages.patch: in one of my creative moments I wrote a
			whole bunch of manpages for the dvb-apps suite.
			In case of Debianization of the package
			the lintian tool requires 1 manpage per binary.
			Mandatory!
4. apps_zapcycles.patch: one of my apps needs a shorter timeout for szap
			to function correctly

5. dvb-apps.lintian-overrides: These are program errors that
				lintian finds during testing
				the validity of the package.


A. I'd appreciate to apply 1. - 3.
B. Applying 4. is not necessary, but would ease my personal hosting
C. 5. should be eliminated by an experienced software hacker

5. looks like this:

dvb-apps: sharedobject-in-library-directory-missing-soname
usr/lib/libucsi.so
dvb-apps: sharedobject-in-library-directory-missing-soname
usr/lib/libdvbapi.so
dvb-apps: sharedobject-in-library-directory-missing-soname
usr/lib/libdvben50221.so
dvb-apps: sharedobject-in-library-directory-missing-soname
usr/lib/libdvbsec.so
dvb-apps: sharedobject-in-library-directory-missing-soname
usr/lib/libdvbcfg.so
dvb-apps: sharedobject-in-library-directory-missing-soname
usr/lib/libesg.so


D. As I stated several times, the major problem of that program is NOT
where it is hosted, but furthermore the problem that it does not
know how to deal with a channel change in DVB mode when the transponder
is being changed by the external player application.....
Just as reminder.......

P. S.: Wouldn't it be a good idea to imply a dependency checker into the
dvb-apps package?
It's a bit unhandy to tell the people via readme to go to /utils/alevt
and type make, if the dependencies are fulfilled.

Guess that can be automatized?

Cheers

CS


--=-YFe0wR2wzfb27/q0UXfv
Content-Disposition: attachment; filename="alevt.patch"
Content-Type: text/x-patch; name="alevt.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

--- a/util/alevt/ChangeLog
+++ b/util/alevt/ChangeLog
@@ -1,11 +1,11 @@
-Thu Feb 11 22:05:00 MET 2010	(1.7.0)
+Sat Feb 14 15:10:00 MET 2010	(1.7.0)
 
     - redesigned version:
     - outfile, new starting methods, libzvbi implementation
     - lots of bug fixes, all patches available in the Internet applied
-    - extensive code cleanup
+    - intensive code cleanup
 
-Mon Dec  3 03:11:07 MET 2007	(1.6.2)
+Mon Dec 3 03:11:07 MET 2007	(1.6.2)
 
     - compilation fixes for newer gcc
     - makefile tweaks (man vs share/man, /usr/X11R6 vs /usr, etc)
--- a/util/alevt/README
+++ b/util/alevt/README
@@ -13,7 +13,7 @@
 3. lots of cruft which is completely outdated or obsolete for other reasons
 
 To handle all that in one big effort I decided to redesign the program
-completely, enlarging its capabilities for DVB-S at the same time.
+completely, enlarging its DVB capabilities at the same time.
 
 So here are the changes:
 
@@ -22,8 +22,7 @@
 
 2. Erasure of old outdated integers, functions, parameters:
 
-- bell, big_buf, debug, display, editor, erc, fine_tune, newbttv,
-- oldbttv
+- bell, big_buf, debug, display, editor, erc, fine_tune, newbttv, oldbttv.
 
 3. Coding style cleanups (no superfluous comments, not more than
    80 characters per column, no uncommented code.
@@ -52,20 +51,24 @@
    make install" there is an uninstaller now to revert the installation:
    "make uninstall".
 
-ENJOY IT!
+External dependencies to run that program:
 
-Uwe Bugla, February 11th, 2010.
+AleVT needs some some system libraries to be installed in your system.
+- libc6 (>= 2.3.6)
+- libpng12 (>= 1.2.13)
+- libx11 (>= 1.3.3)
+- libzvbi0 (>= 0.2.11)
+- zlib (>= 1.1.4)
 
-External dependencies
+ENJOY IT!
 
-AleVT needs some system libraries to be installed in your system.
-They are zlib, libX11, libpng and libzvbi.
+Uwe Bugla, February 14th, 2010.
 
 Credits go to:
 - Andreas Rottmann from debian.org for compiler fixes and
   other kinds of investigation.
 - Francesco Lavra for supplying a kernel patch to avoid kernel demux
-  incompatibilities with kernels >= 2.6.32
+  incompatibilities with kernels 2.6.32-rc1 - 2.6.33-rc7
 - Andy Walls for helpful investigation in kernelspace
 - Edgar Toernig for providing the source version 1.6.2 and doing all the
   development for the basic versions
--- a/util/alevt/TODO
+++ b/util/alevt/TODO
@@ -1,12 +1,18 @@
-Hi, these are issues that I unfortunately cannot resolve myself:
+These are issues that I unfortunately cannot resolve myself:
 
-1. graphical menu written in GKT2, to be used in general connection with
+1. Most important: for usage without script and outfile option:
+    DVB monitoring demon helping the program to rewrite the PAT
+    (Program Allocation Table) when the external player software
+    has chosen a channel which is part of a new transponder.
+    At the moment alevt hangs when the transponder is changed by an
+    external player software.
+    It then can only be stopped via "killall -9 alevt".
+    Or you switch it off before every channel change.
+
+2. Graphical menu written in GKT2, to be used in general connection with
     the outfile (-o) option.
 
-2. for usage without script and outfile option:
-    DVB monitoring demon helping the program to rewrite the PAT when the
-    external player software has chosen a channel which is part of a
-    new transponder.
-    At the moment alevt hangs when the transponder is changed.
+3. New BDF fonts for slightly bigger windows.
+    Those BDF fonts need to be edited so that they can be transformed by bdf2xbm.
 
-Uwe Bugla, February 11th, 2010.
+Uwe Bugla, February 14th, 2010.
--- a/util/alevt/vbi.c
+++ b/util/alevt/vbi.c
@@ -706,10 +706,6 @@
 			}
 		j = i + 5;
 		i = j + (((tbl[i+3] << 8) | tbl[i+4]) & 0x0fff);
-		if (!progp) {
-			error("SDT: service_id 0x%x not in PAT\n", k);
-			continue;
-		}
          while (j < i) {
             switch (tbl[j]) {
                case 0x48: // service descriptor

--=-YFe0wR2wzfb27/q0UXfv
Content-Type: image/png; name="alevt.png"
Content-Disposition: attachment; filename="alevt.png"
Content-Transfer-Encoding: base64

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


--=-YFe0wR2wzfb27/q0UXfv
Content-Disposition: attachment; filename="apps_manpages.patch"
Content-Type: text/x-patch; name="apps_manpages.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

--- a/Make.rules
+++ b/Make.rules
@@ -33,6 +33,7 @@
 includedir ?= $(prefix)/include
 libdir     ?= $(prefix)/lib
 sharedir   ?= $(prefix)/share
+mandir     ?= $(prefix)/share/man/man1
 
 ifneq ($(DESTDIR),)
 DESTDIR := $(DESTDIR)/
@@ -64,6 +65,11 @@
 	mkdir -p $(DESTDIR)$(bindir)
 	install -m 755 $(inst_bin) $(DESTDIR)$(bindir)/
 endif
+ifneq ($(inst_man),)
+	@echo installing manpages
+	@mkdir -p $(DESTDIR)$(mandir)
+	@install -m 755 $(inst_man) $(DESTDIR)$(mandir)/
+endif
 else
 %.o: %.c
 	@echo CC $@
@@ -99,6 +105,11 @@
 	@mkdir -p $(DESTDIR)$(bindir)
 	@install -m 755 $(inst_bin) $(DESTDIR)$(bindir)/
 endif
+ifneq ($(inst_man),)
+	@echo installing manpages
+	@mkdir -p $(DESTDIR)$(mandir)
+	@install -m 755 $(inst_man) $(DESTDIR)$(mandir)/
+endif
 endif
 
 -include $(prerequisites)
--- a/Makefile
+++ b/Makefile
@@ -6,6 +6,7 @@
 	$(MAKE) -C lib $@
 	$(MAKE) -C test $@
 	$(MAKE) -C util $@
+	$(MAKE) -C man $@
 
 update:
 	@echo "Pulling changes & updating from master repository"
--- a/man/Makefile
+++ b/man/Makefile
@@ -0,0 +1,14 @@
+manpages = *.1
+inst_man = $(manpages)
+
+.PHONY: all
+all: $(manpages)
+$(manpages): atsc_epg.1 av7110_loadkeys.1 azap.1 czap.1 dib3000-watch.1 \
+dst_test.1 dvbdate.1 dvbnet.1 dvbscan.1 dvbtraffic.1 femon.1 gnutv.1 gotox.1 \
+scan.1 szap.1 tzap.1 zap.1
+include ../Make.rules
+
+install::
+	@echo installing manpages
+	@mkdir -p $(DESTDIR)$(mandir)
+	@install -m 644 *.1 $(DESTDIR)$(mandir)/
--- a/man/atsc_epg.1
+++ b/man/atsc_epg.1
@@ -0,0 +1,35 @@
+.TH atsc_epg 1 "February 14, 2010"
+.SH NAME
+atsc_epg \- an electronic program guide using ATSC devices.
+.SH SYNOPSIS
+.B atsc_epg
+.RI [ options ]
+.br
+.SH DESCRIPTION
+This manual page documents briefly the
+.B atsc_epg
+commands.
+.PP
+\fBatsc_epg\fP is an electronic program guide for ATSC devices.
+.SH OPTIONS
+.TP
+.B \-a
+adapter index to use, (default 0)
+.TP
+.B \-f
+tuning frequency
+.TP
+.B \-h
+print this help text
+.TP
+.B \-p
+period in hours, (default 12)
+.TP
+.B \-m
+modulation ATSC vsb_8|vsb_16 (default vsb_8)
+.TP
+.B \-t
+enable ETT to receive program details, if available
+.br
+.PP
+This manual page was written by Uwe Bugla <uwe.bugla@gmx.de>.
--- a/man/av7110_loadkeys.1
+++ b/man/av7110_loadkeys.1
@@ -0,0 +1,26 @@
+.TH av7110_loadkeys 1 "February 14, 2010"
+.SH NAME
+av7110_loadkeys \- a program to load keymaps.
+.SH SYNOPSIS
+.B av7110_loadkeys
+.RI [ options ] keymap_filename.(rc5|rcmm
+.br
+.SH DESCRIPTION
+This manual page documents briefly the
+.B av7110_loadkeys
+commands.
+.PP
+\fBav7110_loadkeys\fP is a program to load keymaps.
+.SH OPTIONS
+.TP
+.B \-i
+invert
+.TP
+.B \-a
+address <num>
+.TP
+.B \-h
+print this help text
+.br
+.PP
+This manual page was written by Uwe Bugla <uwe.bugla@gmx.de>.
--- a/man/azap.1
+++ b/man/azap.1
@@ -0,0 +1,35 @@
+.TH azap 1 "February 14, 2010"
+.SH NAME
+azap \- a program to process channels.conf files.
+.SH SYNOPSIS
+.B azap
+.RI [ options ] <channel name>
+.br
+.SH DESCRIPTION
+This manual page documents briefly the
+.B azap
+commands.
+.PP
+\fBazap\fP is a program to process a channels.conf file.
+.SH OPTIONS
+.TP
+.B \-a adapter_num
+use given adapter (default 0)
+.TP
+.B \-f frontend_id
+use given frontend (default 0)
+.TP
+.B \-d demux_id
+use given demux (default 0)
+.TP
+.B \-c conf_file
+read channels list from 'file'
+.TP
+.B \-r
+set up /dev/dvb/adapterX/dvr0 for TS recording
+.TP
+.B \-h
+print this help text
+.br
+.PP
+This manual page was written by Uwe Bugla <uwe.bugla@gmx.de>.
--- a/man/czap.1
+++ b/man/czap.1
@@ -0,0 +1,46 @@
+.TH czap 1 "February 14, 2010"
+.SH NAME
+czap \- a program to process channels.conf files.
+.SH SYNOPSIS
+.B czap
+.RI [ options ] <channel name>
+.br
+.SH DESCRIPTION
+This manual page documents briefly the
+.B czap
+commands.
+.PP
+\fBczap\fP is a program to process a channels.conf file.
+.SH OPTIONS <channel name>
+.TP
+.B \-a adapter_num
+use given adapter (default 0)
+.TP
+.B \-f frontend_id
+use given frontend (default 0)
+.TP
+.B \-d demux_id
+use given demux (default 0)
+.TP
+.B \-c conf_file
+read channels list from 'file'
+.TP
+.B \-H
+produce human readable output
+.TP
+.B \-n channel_num
+use given channel number
+.TP
+.B \-x
+exit after tuning
+.TP
+.B \-c conf_file -l
+list channel names in channels.conf file
+.B \-r
+set up /dev/dvb/adapterX/dvr0 for TS recording
+.TP
+.B \-h
+print this help text
+.br
+.PP
+This manual page was written by Uwe Bugla <uwe.bugla@gmx.de>.
--- a/man/dib3000-watch.1
+++ b/man/dib3000-watch.1
@@ -0,0 +1,34 @@
+.TH dib3000-watch 1 "February 14, 2010"
+.SH NAME
+dib3000-watch \- a program to check DVB cards.
+.SH SYNOPSIS
+.B dib3000-watch
+.RI [ options ] <channel name>
+.br
+.SH DESCRIPTION
+This manual page documents briefly the
+.B dib3000-watch
+commands.
+.PP
+\fBdib3000-watch\fP is a program to check DVB cards.
+.SH OPTIONS
+.TP
+.B \-d <i2c-device>
+-d: normally one of /dev/i2c-[0-255]
+.TP
+.B \-a <i2c-address>
+-a: is 8 for DiB3000M-B and 9, 10, 11 or 12 for DiB3000M-C or DiB3000-P
+.TP
+.B \-o <type>
+-o: output type (print|csv) (default: print)
+.TP
+.B \-i <seconds>
+-i: query interval in seconds (default: 0.1)
+.TP
+.B \-h
+print this help text
+.br
+.SH AUTHOR
+Copyright (C) 2005 by Patrick Boettcher <patrick.boettcher@desy.de>
+.PP
+This manual page was written by Uwe Bugla <uwe.bugla@gmx.de>.
--- a/man/dst_test.1
+++ b/man/dst_test.1
@@ -0,0 +1,41 @@
+.TH dst_test 1 "February 14, 2010"
+.SH NAME
+dst_test \- a Twinhan DST and clones test utility.
+.SH SYNOPSIS
+.B dst_test
+.RI [ options ]
+.br
+.SH DESCRIPTION
+This manual page documents briefly the
+.B dst_test
+commands.
+.PP
+\fBdst_test\fP is a Twinhan DST and clones test utility.
+.SH OPTIONS
+.TP
+.B \-c
+capabilities
+.TP
+.B \-i
+info
+.TP
+.B \-r
+reset
+.TP
+.B \-p
+pid
+.TP
+.B \-g
+get descr
+.TP
+.B \-s
+set_descr
+.TP
+.B \-a
+app_info
+.TP
+.B \-t
+session test
+.br
+.PP
+This manual page was written by Uwe Bugla <uwe.bugla@gmx.de>.
--- a/man/dvbdate.1
+++ b/man/dvbdate.1
@@ -0,0 +1,38 @@
+.TH dvbdate 1 "February 14, 2010"
+.SH NAME
+dvbdate \- a program to show the actual time.
+.SH SYNOPSIS
+.B dvbdate
+.RI [ options ]
+.br
+.SH DESCRIPTION
+This manual page documents briefly the
+.B dvbdate
+commands.
+.PP
+\fBdvbdate\fP is a program to show the actual time.
+.SH OPTIONS
+.TP
+.B \-a --adapter
+adapter to use, default: 0
+.TP
+.B \-p --print
+print current time, received time and delta
+.TP
+.B \-s --set
+set the system clock to received time
+.TP
+.B \-f --force
+force the setting of the clock
+.TP
+.B \-q --quiet
+be silent
+.TP
+.B \-h --help
+display this message
+.TP
+.B \-t --timeout n
+max seconds to wait, default: 25
+.br
+.PP
+This manual page was written by Uwe Bugla <uwe.bugla@gmx.de>.
--- a/man/dvbnet.1
+++ b/man/dvbnet.1
@@ -0,0 +1,38 @@
+.TH dvbnet 1 "February 14, 2009"
+.SH NAME
+dvbnet \- a DVB Network Interface Manager.
+.SH SYNOPSIS
+.B dvbnet
+.RI [ options ]
+.br
+.SH DESCRIPTION
+This manual page documents briefly the
+.B dvbnet
+commands.
+.PP
+\fBdvbnet\fP is a DVB Network Interface Manager.
+.SH OPTIONS
+.TP
+.B \-a AD
+Adapter card (default 0)
+.TP
+.B \-n DD
+Demux (default 0)
+.TP
+.B \-p PID
+Add interface listening on PID
+.TP
+.B \-d NUM
+Remove interface NUM
+.TP
+.B \-l
+List currently available interfaces
+.TP
+.B \-U
+use ULE framing (default: MPE)
+.TP
+.B \-v
+Print current version
+.br
+.PP
+This manual page was written by Uwe Bugla <uwe.bugla@gmx.de>.
--- a/man/dvbscan.1
+++ b/man/dvbscan.1
@@ -0,0 +1,72 @@
+.TH dvbscan 1 "February 14, 2009"
+.SH NAME
+dvbscan \- a program to produce DVB-T channels.conf files.
+.SH SYNOPSIS
+.B dvbscan
+.RI [ options ] <initial scan file>
+.br
+.SH DESCRIPTION
+This manual page documents briefly the
+.B dvbscan
+commands.
+.PP
+\fBdvbscan\fP is a program to produce DVB-T channels.conf files.
+.SH OPTIONS
+.TP
+.B \ -h
+print this help text
+.TP
+.B \-adapter <id>
+adapter to use (default 0)
+.TP
+.B \-frontend <id>
+frontend to use (default 0)
+.TP
+.B \-demux <id>
+demux to use (default 0)
+.TP
+.B \-secfile <filename>
+Optional sec.conf file
+.TP
+.B \-secid <secid>
+ID of the SEC configuration to use, one of:
+	* UNIVERSAL (default) - Europe, 10800 to 11800 MHz and 11600 to 12700 Mhz,\
+	  Dual LO, loband 9750, hiband 10600 MHz
+	* DBS - Expressvu, North America, 12200 to 12700 MHz, Single LO, 11250 MHz
+	* STANDARD - 10945 to 11450 Mhz, Single LO, 10000 Mhz
+	* ENHANCED - Astra, 10700 to 11700 MHz, Single LO, 9750 MHz
+	* C-BAND - Big Dish, 3700 to 4200 MHz, Single LO, 5150 Mhz
+	* C-MULTI - Big Dish - Multipoint LNBf, 3700 to 4200 MHz, Dual LO, H:5150MHz, V:5750MHz
+	* One of the sec definitions from the secfile if supplied
+.TP
+.B \-satpos <position>
+Specify DISEQC switch position for DVB-S
+.TP
+.B \-inversion <on|off|auto>
+Specify inversion (default: auto)
+.TP
+.B \-uk-ordering
+Use UK DVB-T channel ordering if present.
+.TP
+.B \-timeout <secs>
+Specify filter timeout to use (standard specced values will be used by default)
+.TP
+.B \-filter <filter>
+Specify service filter, a comma seperated list of the following tokens:
+If no filter is supplied, all services will be output
+	* tv - Output TV channels
+	* radio - Output radio channels
+	* other - Output other channels
+	* encrypted - Output encrypted channels
+.TP
+.B \-out raw <filename>|-
+Output in raw format to <filename> or stdout
+.B \-out channels <filename>|-
+Output in channels.conf format to <filename> or stdout
+.B \-out vdr12 <filename>|-
+Output in vdr 1.2.x format to <filename> or stdout
+.B \-out vdr13 <filename>|-
+Output in vdr 1.3.x format to <filename> or stdout
+.br
+.PP
+This manual page was written by Uwe Bugla <uwe.bugla@gmx.de>.
--- a/man/dvbtraffic.1
+++ b/man/dvbtraffic.1
@@ -0,0 +1,26 @@
+.TH dvbtraffic 1 "February 14, 2010"
+.SH NAME
+dvbtraffic \- a program to show satellite traffic.
+.SH SYNOPSIS
+.B dvbtraffic
+.RI [ options ]
+.br
+.SH DESCRIPTION
+This manual page documents briefly the
+.B dvbtraffic
+commands.
+.PP
+\fBdvbtraffic\fP is a program to show satellite traffic.
+.SH OPTIONS
+.TP
+.B \-a N
+use dvb adapter N
+.TP
+.B \-d N
+use demux N
+.TP
+.B \-h
+display this help
+.br
+.PP
+This manual page was written by Uwe Bugla <uwe.bugla@gmx.de>.
--- a/man/femon.1
+++ b/man/femon.1
@@ -0,0 +1,32 @@
+.TH femon 1 "February 14, 2010"
+.SH NAME
+femon \- a program to monitor DVB frontend signal input.
+.SH SYNOPSIS
+.B femon
+.RI [ options ]
+.br
+.SH DESCRIPTION
+This manual page documents briefly the
+.B femon
+commands.
+.PP
+\fBfemon\fP is a program to monitor DVB frontend signal input.
+.SH OPTIONS
+.TP
+.B \-h
+print this help text
+.TP
+.B \-H
+human readable output
+.TP
+.B \-a number
+use given adapter (default 0)
+.TP
+.B \-f number
+use given frontend (default 0)
+.TP
+.B \-c number
+samples to take (default 0 = infinite)
+.br
+.PP
+This manual page was written by Uwe Bugla <uwe.bugla@gmx.de>.
--- a/man/gnutv.1
+++ b/man/gnutv.1
@@ -0,0 +1,79 @@
+.TH gnutv 1 "February 14, 2010"
+.SH NAME
+gnutv \- a digital tv utility.
+.SH SYNOPSIS
+.B gnutv
+.RI [ options ] <channel name>
+.br
+.SH DESCRIPTION
+This manual page documents briefly the
+.B gnutv
+commands.
+.PP
+\fBgnutv\fP is a digital tv utility.
+.SH OPTIONS
+.TP
+.B \-adapter <id>
+adapter to use (default 0)
+.TP
+.B \-frontend <id>
+frontend to use (default 0)
+.TP
+.B \-demux <id>
+demux to use (default 0)
+.TP
+.B \-caslotnum <id>
+ca slot number to use (default 0)
+.TP
+.B \-channels <filename>
+channels.conf file
+.TP
+.B \-secfile <filename>
+Optional sec.conf file
+.TP
+.B \-secid <secid>
+ID of the SEC configuration to use, one of:
+	* UNIVERSAL (default) - Europe, 10800 to 11800 MHz and 11600 to 12700 Mhz,\
+	  Dual LO, loband 9750, hiband 10600 MHz
+	* DBS - Expressvu, North America, 12200 to 12700 MHz, Single LO, 11250 MHz
+	* STANDARD - 10945 to 11450 Mhz, Single LO, 10000 Mhz
+	* ENHANCED - Astra, 10700 to 11700 MHz, Single LO, 9750 MHz
+	* C-BAND - Big Dish, 3700 to 4200 MHz, Single LO, 5150 Mhz
+	* C-MULTI - Big Dish - Multipoint LNBf, 3700 to 4200 MHz, Dual LO, H:5150MHz, V:5750MHz
+	* One of the sec definitions from the secfile if supplied
+.TP
+.B \-out decoder
+Output to hardware decoder (default)
+.TP
+.B -out decoderabypass
+Output to hardware decoder using audio bypass
+.B -out dvr
+Output stream to dvr device
+.B -out null
+Do not output anything
+.B -out stdout
+Output to stdout
+.B -out file <filename>
+Output stream to file
+.B -out udp <address> <port>
+Output stream to address:port using udp
+.B -out udpif <address> <port> <interface>
+Output stream to address:port using udp forcing the specified interface
+.B -out rtp <address> <port>
+Output stream to address:port using udp-rtp
+.B -out rtpif <address> <port> <interface>
+Output stream to address:port using udp-rtp forcing the specified interface
+.TP
+.B \-timeout <secs>
+Number of seconds to output channel for (0=>exit immediately after successful tuning, default is to output forever)
+.TP
+.B \-cammenu
+Show the CAM menu
+.TP
+.B \-nomoveca
+Do not attempt to move CA descriptors from stream to programme level
+.B \-h
+print this help text
+.br
+.PP
+This manual page was written by Uwe Bugla <uwe.bugla@gmx.de>.
--- a/man/gotox.1
+++ b/man/gotox.1
@@ -0,0 +1,33 @@
+.TH gotox 1 "February 14, 2010"
+.SH NAME
+gotox \- a program to operate a rotor of a satellite dish.
+.SH SYNOPSIS
+.B gotox
+.RI [ options ]
+.br
+.SH DESCRIPTION
+This manual page documents briefly the
+.B gotox
+commands.
+.PP
+\fBgotox \fP is a program to operate a rotor set to tune a satellite dish.
+.SH OPTIONS
+.TP
+.B \-h
+print this help text
+.TP
+.B \-d degrees
+Goto the specified angle. Positive value for East rotation,
+negative value for West rotation on Northern Hemisphere (default 0)
+.TP
+.B \-a number
+use given adapter (default 0)
+.TP
+.B \-f number
+use given frontend (default 0)
+.TP
+.B \-t seconds
+leave power on to rotor for at least specified seconds of time (default 30)
+.br
+.PP
+This manual page was written by Uwe Bugla <uwe.bugla@gmx.de>.
--- a/man/scan.1
+++ b/man/scan.1
@@ -0,0 +1,85 @@
+.TH scan 1 "February 14, 2010"
+.SH NAME
+scan \- a program to produce channel.conf files.
+.SH SYNOPSIS
+.B scan
+.RI [ options ]
+.br
+.SH DESCRIPTION
+This manual page documents briefly the
+.B scan
+commands.
+.PP
+\fBscan\fP is a program to produce channels.conf files.
+.SH OPTIONS
+.TP
+.B \-c	[initial-tuning-data-file]
+scan on currently tuned transponder only
+.TP
+.B \-v
+verbose (repeat for more)
+.TP
+.B \-q
+quiet (repeat for less)
+.TP
+.B \-a N
+use DVB /dev/dvb/adapterN/
+.TP
+.B \-f N
+use DVB /dev/dvb/adapter?/frontendN
+.TP
+.B \-d N
+use DVB /dev/dvb/adapter?/demuxN
+.TP
+.B \-s N
+use DiSEqC switch position N (DVB-S only)
+.TP
+.B \-i N
+spectral inversion setting (0: off, 1: on, 2: auto [default])
+.TP
+.B \-n
+evaluate NIT-other for full network scan (slow!)
+.TP
+.B \-5
+multiply all filter timeouts by factor 5 for non-DVB-compliant section repitition rates
+.TP
+.B \-o fmt
+output format: 'zap' (default), 'vdr' or 'pids' (default with -c)
+.TP
+.B \-x N
+Conditional Access, (default -1)
+	N=0 gets only FTA channels
+	N=-1 gets all channels
+	N=xxx sets ca field in vdr output to :xxx:
+.TP
+.B \-t N
+Service select, Combined bitfield parameter.
+1 = TV, 2 = Radio, 4 = Other, (default 7)
+.TP
+.B \-p
+for vdr output format: dump provider name
+.TP
+.B \-e N
+	VDR version, default 3 for VDR-1.3.x and newer value 2 sets NIT and TID to zero
+	Vdr version 1.3.x and up implies -p.
+.TP
+.B \-l
+lnb-type (DVB-S Only) (use -l help to print types) or
+.TP
+.B \-l
+low[,high[,switch]] in Mhz
+.TP
+.B \-u
+UK DVB-T Freeview channel numbering for VDR
+.TP
+.B \-P
+do not use ATSC PSIP tables for scanning (but only PAT and PMT) (applies for ATSC only)
+.TP
+.B \-A N
+check for ATSC 1=Terrestrial [default], 2=Cable or 3=both
+.TP
+.B \-U
+Uniquely name unknown services
+.br
+.PP
+This manual page was written by Uwe Bugla <uwe.bugla@gmx.de>.
--- a/man/szap.1
+++ b/man/szap.1
@@ -0,0 +1,57 @@
+.TH szap 1 "February 14, 2010"
+.SH NAME
+szap \- a program to process channels.conf files.
+.SH SYNOPSIS
+.B szap
+.RI [ options ]
+.br
+.SH DESCRIPTION
+This manual page documents briefly the
+.B szap
+commands.
+.PP
+\fBszap\fP is a program to process a channels.conf file.
+.SH OPTIONS
+.TP
+.B \-n channel-number | channel_name
+zap to channel via number or full name (case insensitive)
+.TP
+.B \-q
+list known channels
+.TP
+.B \-a number
+use given adapter (default 0)
+.TP
+.B \-f number
+use given frontend (default 0)
+.TP
+.B \-d number
+use given demux (default 0)
+.TP
+.B \-c file
+read channels list from 'file'
+.TP
+.B \-b
+enable Audio Bypass (default no)
+.TP
+.B \-x
+exit after tuning
+.TP
+.B \-H
+human readable output
+.TP
+.B \-r
+set up /dev/dvb/adapterX/dvr0 for TS recording
+.TP
+.B \-l lnb-type (DVB-S Only) (use -l help to print types) or
+.TP
+.B \-l low[,high[,switch]] in Mhz
+.TP
+.B \-i
+run interactively, allowing you to type in channel names
+.TP
+.B \-p
+add pat and pmt to TS recording (implies -r) or -n numbers for zapping
+.br
+.PP
+This manual page was written by Uwe Bugla <uwe.bugla@gmx.de>.
--- a/man/tzap.1
+++ b/man/tzap.1
@@ -0,0 +1,56 @@
+.TH tzap 1 "February 14, 2010"
+.SH NAME
+tzap \- a program to process channels.conf files.
+.SH SYNOPSIS
+.B tzap
+.RI [ options ] <channel_name>
+.br
+.SH DESCRIPTION
+This manual page documents briefly the
+.B tzap
+commands.
+.PP
+\fBtzap\fP is a program to process channels.conf files.
+.SH OPTIONS
+.TP
+.B \-a number
+use given adapter (default 0)
+.TP
+.B \-f number
+use given frontend (default 0)
+.TP
+.B \-d number
+use given demux (default 0)
+.TP
+.B \-c file
+read channels list from 'file'
+.TP
+.B \-x
+exit after tuning
+.TP
+.B \-H
+human readable output
+.TP
+.B \-r
+set up /dev/dvb/adapterX/dvr0 for TS recording
+.TP
+.B \-s
+only print summary
+.TP
+.B \-S
+run silently (no output)
+.TP
+.B \-F
+set up frontend only, don't touch demux
+.TP
+.B \-t number
+timeout (seconds)
+.TP
+.B \-o file
+output filename (use -o - for stdout)
+.TP
+.B \-h
+display this help and exit
+.br
+.PP
+This manual page was written by Uwe Bugla <uwe.bugla@gmx.de>.
--- a/man/zap.1
+++ b/man/zap.1
@@ -0,0 +1,44 @@
+.TH zap 1 "February 14, 2010"
+.SH NAME
+zap \- a program to process channels.conf files.
+.SH SYNOPSIS
+.B zap
+.RI [ options ] <channel name>
+.br
+.SH DESCRIPTION
+This manual page documents briefly the
+.B zap
+commands.
+.PP
+\fBzap\fP is a program to process a channels.conf file.
+.SH OPTIONS
+.TP
+.B \-adapter <id>
+adapter to use (default 0)
+.TP
+.B \-frontend <id>
+frontend to use (default 0)
+.TP
+.B \-demux <id>
+demux to use (default 0)
+.TP
+.B \-caslotnum <id>
+ca slot number to use (default 0)
+.TP
+.B \-channels <filename>
+channels.conf file
+.TP
+.B \-secfile <filename>
+Optional sec.conf file
+.TP
+.B \-secid <secid>
+ID of the SEC configuration to use
+.TP
+.B \-nomoveca
+Do not attempt to move CA descriptors from stream to program level
+.TP
+.B \-h
+print this help text
+.br
+.PP
+This manual page was written by Uwe Bugla <uwe.bugla@gmx.de>.

--=-YFe0wR2wzfb27/q0UXfv
Content-Disposition: attachment; filename="apps_zapcycles.patch"
Content-Type: text/x-patch; name="apps_zapcycles.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

--- a/util/szap/szap.c
+++ b/util/szap/szap.c
@@ -201,7 +201,7 @@
 	 printf("FE_HAS_LOCK");
       printf("\n");

-      if (exit_after_tuning && ((status & FE_HAS_LOCK) || (++timeout >= 10)))
+      if (exit_after_tuning && ((status & FE_HAS_LOCK) && (++timeout == 5)))
          break;

       usleep(1000000);

--=-YFe0wR2wzfb27/q0UXfv
Content-Disposition: attachment; filename="dvb-apps.lintian-overrides"
Content-Type: text/plain; name="dvb-apps.lintian-overrides"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

dvb-apps: sharedobject-in-library-directory-missing-soname usr/lib/libucsi.so
dvb-apps: sharedobject-in-library-directory-missing-soname usr/lib/libdvbapi.so
dvb-apps: sharedobject-in-library-directory-missing-soname usr/lib/libdvben50221.so
dvb-apps: sharedobject-in-library-directory-missing-soname usr/lib/libdvbsec.so
dvb-apps: sharedobject-in-library-directory-missing-soname usr/lib/libdvbcfg.so
dvb-apps: sharedobject-in-library-directory-missing-soname usr/lib/libesg.so

--=-YFe0wR2wzfb27/q0UXfv--

