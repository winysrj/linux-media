Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59135 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753262AbZB1SWj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Feb 2009 13:22:39 -0500
Content-Type: multipart/mixed; boundary="========GMX100321235845356283372"
Date: Sat, 28 Feb 2009 19:22:36 +0100
From: sinter.salt@gmx.de
Message-ID: <20090228182236.100320@gmx.net>
MIME-Version: 1.0
Subject: Vote please: DVB developers opinion is wanted!
To: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--========GMX100321235845356283372
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Hi,

I would like to know if anyone of you has any objections against the following patch:
It remove two obsolete text files in /Documentation/dvb.

1. They do not contain any technical information that is making sense.
2. The correct place for mentioning a developer's or contributor's name is a file header, but not a text file in case we're talking about a driver file, not a documentation text file.
3. These two files are NEVER administered or maintained, that is why they are not only useless but furthermore completely out of date.

--- a/Documentation/dvb/contributors.txt	2008-12-25 00:26:37.000000000 +0100
+++ b/Documentation/dvb/contributors.txt	1970-01-01 01:00:00.000000000 +0100
@@ -1,96 +0,0 @@
-Thanks go to the following people for patches and contributions:
-
-Michael Hunold <m.hunold@gmx.de>
-  for the initial saa7146 driver and it's recent overhaul
-
-Christian Theiss
-  for his work on the initial Linux DVB driver
-
-Marcus Metzler <mocm@metzlerbros.de>
-Ralph Metzler <rjkm@metzlerbros.de>
-  for their continuing work on the DVB driver
-
-Michael Holzt <kju@debian.org>
-  for his contributions to the dvb-net driver
-
-Diego Picciani <d.picciani@novacomp.it>
-  for CyberLogin for Linux which allows logging onto EON
-  (in case you are wondering where CyberLogin is, EON changed its login
-  procedure and CyberLogin is no longer used.)
-
-Martin Schaller <martin@smurf.franken.de>
-  for patching the cable card decoder driver
-
-Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
-  for various fixes regarding tuning, OSD and CI stuff and his work on VDR
-
-Steve Brown <sbrown@cortland.com>
-  for his AFC kernel thread
-
-Christoph Martin <martin@uni-mainz.de>
-  for his LIRC infrared handler
-
-Andreas Oberritter <obi@linuxtv.org>
-Dennis Noermann <dennis.noermann@noernet.de>
-Felix Domke <tmbinc@elitedvb.net>
-Florian Schirmer <jolt@tuxbox.org>
-Ronny Strutz <3des@elitedvb.de>
-Wolfram Joost <dbox2@frokaschwei.de>
-...and all the other dbox2 people
-  for many bugfixes in the generic DVB Core, frontend drivers and
-  their work on the dbox2 port of the DVB driver
-
-Oliver Endriss <o.endriss@gmx.de>
-  for many bugfixes
-
-Andrew de Quincey <adq_dvb@lidskialf.net>
-  for the tda1004x frontend driver, and various bugfixes
-
-Peter Schildmann <peter.schildmann@web.de>
-  for the driver for the Technisat SkyStar2 PCI DVB card
-
-Vadim Catana <skystar@moldova.cc>
-Roberto Ragusa <r.ragusa@libero.it>
-Augusto Cardoso <augusto@carhil.net>
-  for all the work for the FlexCopII chipset by B2C2,Inc.
-
-Davor Emard <emard@softhome.net>
-  for his work on the budget drivers, the demux code,
-  the module unloading problems, ...
-
-Hans-Frieder Vogt <hfvogt@arcor.de>
-  for his work on calculating and checking the crc's for the
-  TechnoTrend/Hauppauge DEC driver firmware
-
-Michael Dreher <michael@5dot1.de>
-Andreas 'randy' Weinberger
-  for the support of the Fujitsu-Siemens Activy budget DVB-S
-
-Kenneth Aafløy <ke-aa@frisurf.no>
-  for adding support for Typhoon DVB-S budget card
-
-Ernst Peinlich <e.peinlich@inode.at>
-  for tuning/DiSEqC support for the DEC 3000-s
-
-Peter Beutner <p.beutner@gmx.net>
-  for the IR code for the ttusb-dec driver
-
-Wilson Michaels <wilsonmichaels@earthlink.net>
-  for the lgdt330x frontend driver, and various bugfixes
-
-Michael Krufky <mkrufky@m1k.net>
-  for maintaining v4l/dvb inter-tree dependencies
-
-Taylor Jacob <rtjacob@earthlink.net>
-  for the nxt2002 frontend driver
-
-Jean-Francois Thibert <jeanfrancois@sagetv.com>
-  for the nxt2004 frontend driver
-
-Kirk Lapray <kirk.lapray@gmail.com>
-  for the or51211 and or51132 frontend drivers, and
-  for merging the nxt2002 and nxt2004 modules into a
-  single nxt200x frontend driver.
-
-(If you think you should be in this list, but you are not, drop a
- line to the DVB mailing list)
--- a/Documentation/dvb/readme.txt	2008-12-25 00:26:37.000000000 +0100
+++ b/Documentation/dvb/readme.txt	1970-01-01 01:00:00.000000000 +0100
@@ -1,62 +0,0 @@
-Linux Digital Video Broadcast (DVB) subsystem
-=============================================
-
-The main development site and CVS repository for these
-drivers is http://linuxtv.org/.
-
-The developer mailing list linux-dvb is also hosted there,
-see http://linuxtv.org/lists.php. Please check
-the archive http://linuxtv.org/pipermail/linux-dvb/
-and the Wiki http://linuxtv.org/wiki/
-before asking newbie questions on the list.
-
-API documentation, utilities and test/example programs
-are available as part of the old driver package for Linux 2.4
-(linuxtv-dvb-1.0.x.tar.gz), or from CVS (module DVB).
-We plan to split this into separate packages, but it's not
-been done yet.
-
-http://linuxtv.org/downloads/
-
-What's inside this directory:
-
-"avermedia.txt"
-contains detailed information about the
-Avermedia DVB-T cards. See also "bt8xx.txt".
-
-"bt8xx.txt"
-contains detailed information about the
-various bt8xx based "budget" DVB cards.
-
-"cards.txt"
-contains a list of supported hardware.
-
-"ci.txt"
-contains detailed information about the
-CI module as part from TwinHan cards and Clones.
-
-"contributors.txt"
-is the who-is-who of DVB development.
-
-"faq.txt"
-contains frequently asked questions and their answers.
-
-"get_dvb_firmware"
-script to download and extract firmware for those devices
-that require it.
-
-"ttusb-dec.txt"
-contains detailed information about the
-TT DEC2000/DEC3000 USB DVB hardware.
-
-"udev.txt"
-how to get DVB and udev up and running.
-
-"README.dvb-usb"
-contains detailed information about the DVB USB cards.
-
-"README.flexcop"
-contains detailed information about the
-Technisat- and Flexcop B2C2 drivers.
-
-Good luck and have fun!

Best regards

Uwe

-- 
Computer Bild Tarifsieger! GMX FreeDSL - Telefonanschluss + DSL
für nur 17,95 ¿/mtl.!* http://dsl.gmx.de/?ac=OM.AD.PD003K11308T4569a

--========GMX100321235845356283372
Content-Type: text/x-diff; charset="iso-8859-15"; name="docuwipe.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="docuwipe.patch"

--- a/Documentation/dvb/contributors.txt	2008-12-25 00:26:37.000000000 +0100
+++ b/Documentation/dvb/contributors.txt	1970-01-01 01:00:00.000000000 +0100
@@ -1,96 +0,0 @@
-Thanks go to the following people for patches and contributions:
-
-Michael Hunold <m.hunold@gmx.de>
-  for the initial saa7146 driver and it's recent overhaul
-
-Christian Theiss
-  for his work on the initial Linux DVB driver
-
-Marcus Metzler <mocm@metzlerbros.de>
-Ralph Metzler <rjkm@metzlerbros.de>
-  for their continuing work on the DVB driver
-
-Michael Holzt <kju@debian.org>
-  for his contributions to the dvb-net driver
-
-Diego Picciani <d.picciani@novacomp.it>
-  for CyberLogin for Linux which allows logging onto EON
-  (in case you are wondering where CyberLogin is, EON changed its login
-  procedure and CyberLogin is no longer used.)
-
-Martin Schaller <martin@smurf.franken.de>
-  for patching the cable card decoder driver
-
-Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
-  for various fixes regarding tuning, OSD and CI stuff and his work on VDR
-
-Steve Brown <sbrown@cortland.com>
-  for his AFC kernel thread
-
-Christoph Martin <martin@uni-mainz.de>
-  for his LIRC infrared handler
-
-Andreas Oberritter <obi@linuxtv.org>
-Dennis Noermann <dennis.noermann@noernet.de>
-Felix Domke <tmbinc@elitedvb.net>
-Florian Schirmer <jolt@tuxbox.org>
-Ronny Strutz <3des@elitedvb.de>
-Wolfram Joost <dbox2@frokaschwei.de>
-...and all the other dbox2 people
-  for many bugfixes in the generic DVB Core, frontend drivers and
-  their work on the dbox2 port of the DVB driver
-
-Oliver Endriss <o.endriss@gmx.de>
-  for many bugfixes
-
-Andrew de Quincey <adq_dvb@lidskialf.net>
-  for the tda1004x frontend driver, and various bugfixes
-
-Peter Schildmann <peter.schildmann@web.de>
-  for the driver for the Technisat SkyStar2 PCI DVB card
-
-Vadim Catana <skystar@moldova.cc>
-Roberto Ragusa <r.ragusa@libero.it>
-Augusto Cardoso <augusto@carhil.net>
-  for all the work for the FlexCopII chipset by B2C2,Inc.
-
-Davor Emard <emard@softhome.net>
-  for his work on the budget drivers, the demux code,
-  the module unloading problems, ...
-
-Hans-Frieder Vogt <hfvogt@arcor.de>
-  for his work on calculating and checking the crc's for the
-  TechnoTrend/Hauppauge DEC driver firmware
-
-Michael Dreher <michael@5dot1.de>
-Andreas 'randy' Weinberger
-  for the support of the Fujitsu-Siemens Activy budget DVB-S
-
-Kenneth AaflÃ¸y <ke-aa@frisurf.no>
-  for adding support for Typhoon DVB-S budget card
-
-Ernst Peinlich <e.peinlich@inode.at>
-  for tuning/DiSEqC support for the DEC 3000-s
-
-Peter Beutner <p.beutner@gmx.net>
-  for the IR code for the ttusb-dec driver
-
-Wilson Michaels <wilsonmichaels@earthlink.net>
-  for the lgdt330x frontend driver, and various bugfixes
-
-Michael Krufky <mkrufky@m1k.net>
-  for maintaining v4l/dvb inter-tree dependencies
-
-Taylor Jacob <rtjacob@earthlink.net>
-  for the nxt2002 frontend driver
-
-Jean-Francois Thibert <jeanfrancois@sagetv.com>
-  for the nxt2004 frontend driver
-
-Kirk Lapray <kirk.lapray@gmail.com>
-  for the or51211 and or51132 frontend drivers, and
-  for merging the nxt2002 and nxt2004 modules into a
-  single nxt200x frontend driver.
-
-(If you think you should be in this list, but you are not, drop a
- line to the DVB mailing list)
--- a/Documentation/dvb/readme.txt	2008-12-25 00:26:37.000000000 +0100
+++ b/Documentation/dvb/readme.txt	1970-01-01 01:00:00.000000000 +0100
@@ -1,62 +0,0 @@
-Linux Digital Video Broadcast (DVB) subsystem
-=============================================
-
-The main development site and CVS repository for these
-drivers is http://linuxtv.org/.
-
-The developer mailing list linux-dvb is also hosted there,
-see http://linuxtv.org/lists.php. Please check
-the archive http://linuxtv.org/pipermail/linux-dvb/
-and the Wiki http://linuxtv.org/wiki/
-before asking newbie questions on the list.
-
-API documentation, utilities and test/example programs
-are available as part of the old driver package for Linux 2.4
-(linuxtv-dvb-1.0.x.tar.gz), or from CVS (module DVB).
-We plan to split this into separate packages, but it's not
-been done yet.
-
-http://linuxtv.org/downloads/
-
-What's inside this directory:
-
-"avermedia.txt"
-contains detailed information about the
-Avermedia DVB-T cards. See also "bt8xx.txt".
-
-"bt8xx.txt"
-contains detailed information about the
-various bt8xx based "budget" DVB cards.
-
-"cards.txt"
-contains a list of supported hardware.
-
-"ci.txt"
-contains detailed information about the
-CI module as part from TwinHan cards and Clones.
-
-"contributors.txt"
-is the who-is-who of DVB development.
-
-"faq.txt"
-contains frequently asked questions and their answers.
-
-"get_dvb_firmware"
-script to download and extract firmware for those devices
-that require it.
-
-"ttusb-dec.txt"
-contains detailed information about the
-TT DEC2000/DEC3000 USB DVB hardware.
-
-"udev.txt"
-how to get DVB and udev up and running.
-
-"README.dvb-usb"
-contains detailed information about the DVB USB cards.
-
-"README.flexcop"
-contains detailed information about the
-Technisat- and Flexcop B2C2 drivers.
-
-Good luck and have fun!

--========GMX100321235845356283372--
