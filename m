Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep15.mx.upcmail.net ([62.179.121.35]:54215 "EHLO
	fep15.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbaEDCJy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 May 2014 22:09:54 -0400
From: Jonathan McCrohan <jmccrohan@gmail.com>
To: linux-media@vger.kernel.org,
	pkg-vdr-dvb-devel@lists.alioth.debian.org
Cc: Jonathan McCrohan <jmccrohan@gmail.com>
Subject: [PATCH 6/6] [dvb-apps] dvb-apps: add man pages
Date: Sun,  4 May 2014 02:51:21 +0100
Message-Id: <1399168281-20626-7-git-send-email-jmccrohan@gmail.com>
In-Reply-To: <1399168281-20626-1-git-send-email-jmccrohan@gmail.com>
References: <1399168281-20626-1-git-send-email-jmccrohan@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add man pages written by Uwe Bugla and Tobias Grimm.

Add Makefile written by myself.

Bug-Debian: http://bugs.debian.org/312570

Signed-off-by: Jonathan McCrohan <jmccrohan@gmail.com>
---
 Make.rules            |  1 +
 Makefile              |  1 +
 man/Makefile          | 13 ++++++++
 man/atsc_epg.1        | 35 +++++++++++++++++++++
 man/av7110_loadkeys.1 | 26 ++++++++++++++++
 man/azap.1            | 35 +++++++++++++++++++++
 man/czap.1            | 46 ++++++++++++++++++++++++++++
 man/dib3000-watch.1   | 34 +++++++++++++++++++++
 man/dst_test.1        | 41 +++++++++++++++++++++++++
 man/dvbdate.1         | 38 +++++++++++++++++++++++
 man/dvbnet.1          | 38 +++++++++++++++++++++++
 man/dvbscan.1         | 72 +++++++++++++++++++++++++++++++++++++++++++
 man/dvbtraffic.1      | 26 ++++++++++++++++
 man/femon.1           | 32 +++++++++++++++++++
 man/gnutv.1           | 79 +++++++++++++++++++++++++++++++++++++++++++++++
 man/gotox.1           | 33 ++++++++++++++++++++
 man/lsdvb.1           |  9 ++++++
 man/scan.1            | 85 +++++++++++++++++++++++++++++++++++++++++++++++++++
 man/szap.1            | 57 ++++++++++++++++++++++++++++++++++
 man/tzap.1            | 56 +++++++++++++++++++++++++++++++++
 man/zap.1             | 44 ++++++++++++++++++++++++++
 21 files changed, 801 insertions(+)
 create mode 100644 man/Makefile
 create mode 100644 man/atsc_epg.1
 create mode 100644 man/av7110_loadkeys.1
 create mode 100644 man/azap.1
 create mode 100644 man/czap.1
 create mode 100644 man/dib3000-watch.1
 create mode 100644 man/dst_test.1
 create mode 100644 man/dvbdate.1
 create mode 100644 man/dvbnet.1
 create mode 100644 man/dvbscan.1
 create mode 100644 man/dvbtraffic.1
 create mode 100644 man/femon.1
 create mode 100644 man/gnutv.1
 create mode 100644 man/gotox.1
 create mode 100644 man/lsdvb.1
 create mode 100644 man/scan.1
 create mode 100644 man/szap.1
 create mode 100644 man/tzap.1
 create mode 100644 man/zap.1

diff --git a/Make.rules b/Make.rules
index 0726060..0b017af 100644
--- a/Make.rules
+++ b/Make.rules
@@ -33,6 +33,7 @@ bindir     ?= $(prefix)/bin
 includedir ?= $(prefix)/include
 libdir     ?= $(prefix)/lib
 sharedir   ?= $(prefix)/share
+mandir     ?= $(prefix)/share/man/man1
 
 ifneq ($(DESTDIR),)
 DESTDIR := $(DESTDIR)/
diff --git a/Makefile b/Makefile
index 65a2273..21901ea 100644
--- a/Makefile
+++ b/Makefile
@@ -12,6 +12,7 @@ all clean install:
 	$(MAKE) -C lib $@
 	$(MAKE) -C test $@
 	$(MAKE) -C util $@
+	$(MAKE) -C man $@
 
 update:
 	@echo "Pulling changes & updating from master repository"
diff --git a/man/Makefile b/man/Makefile
new file mode 100644
index 0000000..e4c1e0d
--- /dev/null
+++ b/man/Makefile
@@ -0,0 +1,13 @@
+manpages = *.1
+inst_man = $(manpages)
+
+.PHONY: install
+
+include ../Make.rules
+
+all:
+
+install::
+	@echo installing manpages
+	@mkdir -p $(DESTDIR)$(mandir)
+	@install -m 644 $(inst_man) $(DESTDIR)$(mandir)/
diff --git a/man/atsc_epg.1 b/man/atsc_epg.1
new file mode 100644
index 0000000..1190d8c
--- /dev/null
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
diff --git a/man/av7110_loadkeys.1 b/man/av7110_loadkeys.1
new file mode 100644
index 0000000..94dbfda
--- /dev/null
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
diff --git a/man/azap.1 b/man/azap.1
new file mode 100644
index 0000000..ee85a12
--- /dev/null
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
diff --git a/man/czap.1 b/man/czap.1
new file mode 100644
index 0000000..4af4a4c
--- /dev/null
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
diff --git a/man/dib3000-watch.1 b/man/dib3000-watch.1
new file mode 100644
index 0000000..7cba46e
--- /dev/null
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
+\-d: normally one of /dev/i2c-[0-255]
+.TP
+.B \-a <i2c-address>
+\-a: is 8 for DiB3000M-B and 9, 10, 11 or 12 for DiB3000M-C or DiB3000-P
+.TP
+.B \-o <type>
+\-o: output type (print|csv) (default: print)
+.TP
+.B \-i <seconds>
+\-i: query interval in seconds (default: 0.1)
+.TP
+.B \-h
+print this help text
+.br
+.SH AUTHOR
+Copyright (C) 2005 by Patrick Boettcher <patrick.boettcher@desy.de>
+.PP
+This manual page was written by Uwe Bugla <uwe.bugla@gmx.de>.
diff --git a/man/dst_test.1 b/man/dst_test.1
new file mode 100644
index 0000000..b90cc9d
--- /dev/null
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
diff --git a/man/dvbdate.1 b/man/dvbdate.1
new file mode 100644
index 0000000..cf8d270
--- /dev/null
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
diff --git a/man/dvbnet.1 b/man/dvbnet.1
new file mode 100644
index 0000000..674bb5c
--- /dev/null
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
diff --git a/man/dvbscan.1 b/man/dvbscan.1
new file mode 100644
index 0000000..fc4d163
--- /dev/null
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
+.B \-h
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
+.B \-uk\-ordering
+Use UK DVB-T channel ordering if present.
+.TP
+.B \-timeout <secs>
+Specify filter timeout to use (standard specced values will be used by default)
+.TP
+.B \-filter <filter>
+Specify service filter, a comma separated list of the following tokens:
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
diff --git a/man/dvbtraffic.1 b/man/dvbtraffic.1
new file mode 100644
index 0000000..be49a56
--- /dev/null
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
diff --git a/man/femon.1 b/man/femon.1
new file mode 100644
index 0000000..c723151
--- /dev/null
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
diff --git a/man/gnutv.1 b/man/gnutv.1
new file mode 100644
index 0000000..782dc4c
--- /dev/null
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
+.B \-out decoderabypass
+Output to hardware decoder using audio bypass
+.B \-out dvr
+Output stream to dvr device
+.B \-out null
+Do not output anything
+.B \-out stdout
+Output to stdout
+.B \-out file <filename>
+Output stream to file
+.B \-out udp <address> <port>
+Output stream to address:port using udp
+.B \-out udpif <address> <port> <interface>
+Output stream to address:port using udp forcing the specified interface
+.B \-out rtp <address> <port>
+Output stream to address:port using udp-rtp
+.B \-out rtpif <address> <port> <interface>
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
diff --git a/man/gotox.1 b/man/gotox.1
new file mode 100644
index 0000000..f815c44
--- /dev/null
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
diff --git a/man/lsdvb.1 b/man/lsdvb.1
new file mode 100644
index 0000000..6f288ee
--- /dev/null
+++ b/man/lsdvb.1
@@ -0,0 +1,9 @@
+.TH lsdvb 1 "September February 19, 2013"
+.SH NAME
+lsdvb \- a simple utility to list PCI/PCIe DVB devices
+.SH SYNOPSIS
+.B lsdvb
+.br
+.SH DESCRIPTION
+.B lsdvb
+lists all available PCI/PCIe DVB devices.
diff --git a/man/scan.1 b/man/scan.1
new file mode 100644
index 0000000..6583dcf
--- /dev/null
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
+Conditional Access, (default \-1)
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
+	Vdr version 1.3.x and up implies \-p.
+.TP
+.B \-l
+lnb-type (DVB-S Only) (use \-l help to print types) or
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
diff --git a/man/szap.1 b/man/szap.1
new file mode 100644
index 0000000..d0d761e
--- /dev/null
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
+.B \-l lnb-type (DVB-S Only) (use \-l help to print types) or
+.TP
+.B \-l low[,high[,switch]] in Mhz
+.TP
+.B \-i
+run interactively, allowing you to type in channel names
+.TP
+.B \-p
+add pat and pmt to TS recording (implies \-r) or \-n numbers for zapping
+.br
+.PP
+This manual page was written by Uwe Bugla <uwe.bugla@gmx.de>.
diff --git a/man/tzap.1 b/man/tzap.1
new file mode 100644
index 0000000..5a828c7
--- /dev/null
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
+output filename (use \-o \- for stdout)
+.TP
+.B \-h
+display this help and exit
+.br
+.PP
+This manual page was written by Uwe Bugla <uwe.bugla@gmx.de>.
diff --git a/man/zap.1 b/man/zap.1
new file mode 100644
index 0000000..f97047f
--- /dev/null
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
-- 
1.9.2

