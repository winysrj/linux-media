Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60557 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbcGQRHR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 13:07:17 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Patrick Boettcher <patrick.boettcher@posteo.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 08/15] [media] doc-rst: Convert dvb-usb to ReST format
Date: Sun, 17 Jul 2016 14:07:03 -0300
Message-Id: <9bb2c55a7985851e8be7f5c635bdfc49ddf3baa0.1468775054.git.mchehab@s-opensource.com>
In-Reply-To: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
References: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
References: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This file is not on any markup language. Convert it to
ReST format.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/dvb-drivers/dvb-usb.rst | 317 +++++++++++++++++++---------
 Documentation/media/dvb-drivers/index.rst   |   1 +
 2 files changed, 221 insertions(+), 97 deletions(-)

diff --git a/Documentation/media/dvb-drivers/dvb-usb.rst b/Documentation/media/dvb-drivers/dvb-usb.rst
index 6f4b12f7b844..eec99cd07a30 100644
--- a/Documentation/media/dvb-drivers/dvb-usb.rst
+++ b/Documentation/media/dvb-drivers/dvb-usb.rst
@@ -1,9 +1,15 @@
-Documentation for dvb-usb-framework module and its devices
-
 Idea behind the dvb-usb-framework
 =================================
 
-In March 2005 I got the new Twinhan USB2.0 DVB-T device. They provided specs and a firmware.
+.. note::
+
+   #) This documentation is outdated. Please check at the DVB wiki
+      at https://linuxtv.org/wiki for more updated info.
+
+   #) **deprecated:** Newer DVB USB drivers should use the dvb-usb-v2 framework.
+
+In March 2005 I got the new Twinhan USB2.0 DVB-T device. They provided specs
+and a firmware.
 
 Quite keen I wanted to put the driver (with some quirks of course) into dibusb.
 After reading some specs and doing some USB snooping, it realized, that the
@@ -40,80 +46,184 @@ TODO: dynamic enabling and disabling of the pid-filter in regard to number of
 feeds requested.
 
 Supported devices
-========================
+-----------------
 
-See the LinuxTV DVB Wiki at www.linuxtv.org for a complete list of
+See the LinuxTV DVB Wiki at https://linuxtv.org for a complete list of
 cards/drivers/firmwares:
-
 https://linuxtv.org/wiki/index.php/DVB_USB
 
 0. History & News:
-  2005-06-30 - added support for WideView WT-220U (Thanks to Steve Chang)
-  2005-05-30 - added basic isochronous support to the dvb-usb-framework
-	       added support for Conexant Hybrid reference design and Nebula DigiTV USB
-  2005-04-17 - all dibusb devices ported to make use of the dvb-usb-framework
-  2005-04-02 - re-enabled and improved remote control code.
-  2005-03-31 - ported the Yakumo/Hama/Typhoon DVB-T USB2.0 device to dvb-usb.
-  2005-03-30 - first commit of the dvb-usb-module based on the dibusb-source. First device is a new driver for the
-	       TwinhanDTV Alpha / MagicBox II USB2.0-only DVB-T device.
-
-  (change from dvb-dibusb to dvb-usb)
-  2005-03-28 - added support for the AVerMedia AverTV DVB-T USB2.0 device (Thanks to Glen Harris and Jiun-Kuei Jung, AVerMedia)
-  2005-03-14 - added support for the Typhoon/Yakumo/HAMA DVB-T mobile USB2.0
-  2005-02-11 - added support for the KWorld/ADSTech Instant DVB-T USB2.0. Thanks a lot to Joachim von Caron
-  2005-02-02 - added support for the Hauppauge Win-TV Nova-T USB2
-  2005-01-31 - distorted streaming is gone for USB1.1 devices
-  2005-01-13 - moved the mirrored pid_filter_table back to dvb-dibusb
-	     - first almost working version for HanfTek UMT-010
-	     - found out, that Yakumo/HAMA/Typhoon are predecessors of the HanfTek UMT-010
-  2005-01-10 - refactoring completed, now everything is very delightful
-	     - tuner quirks for some weird devices (Artec T1 AN2235 device has sometimes a
-	       Panasonic Tuner assembled). Tunerprobing implemented. Thanks a lot to Gunnar Wittich.
-  2004-12-29 - after several days of struggling around bug of no returning URBs fixed.
-  2004-12-26 - refactored the dibusb-driver, splitted into separate files
-	     - i2c-probing enabled
-  2004-12-06 - possibility for demod i2c-address probing
-	     - new usb IDs (Compro, Artec)
-  2004-11-23 - merged changes from DiB3000MC_ver2.1
-	     - revised the debugging
-	     - possibility to deliver the complete TS for USB2.0
-  2004-11-21 - first working version of the dib3000mc/p frontend driver.
-  2004-11-12 - added additional remote control keys. Thanks to Uwe Hanke.
-  2004-11-07 - added remote control support. Thanks to David Matthews.
-  2004-11-05 - added support for a new devices (Grandtec/Avermedia/Artec)
-	     - merged my changes (for dib3000mb/dibusb) to the FE_REFACTORING, because it became HEAD
-	     - moved transfer control (pid filter, fifo control) from usb driver to frontend, it seems
-	       better settled there (added xfer_ops-struct)
-	     - created a common files for frontends (mc/p/mb)
-  2004-09-28 - added support for a new device (Unknown, vendor ID is Hyper-Paltek)
-  2004-09-20 - added support for a new device (Compro DVB-U2000), thanks
-	       to Amaury Demol for reporting
-	     - changed usb TS transfer method (several urbs, stopping transfer
-	       before setting a new pid)
-  2004-09-13 - added support for a new device (Artec T1 USB TVBOX), thanks
-	       to Christian Motschke for reporting
-  2004-09-05 - released the dibusb device and dib3000mb-frontend driver
-
-  (old news for vp7041.c)
-  2004-07-15 - found out, by accident, that the device has a TUA6010XS for
-	       PLL
-  2004-07-12 - figured out, that the driver should also work with the
-	       CTS Portable (Chinese Television System)
-  2004-07-08 - firmware-extraction-2.422-problem solved, driver is now working
-	       properly with firmware extracted from 2.422
-	     - #if for 2.6.4 (dvb), compile issue
-	     - changed firmware handling, see vp7041.txt sec 1.1
-  2004-07-02 - some tuner modifications, v0.1, cleanups, first public
-  2004-06-28 - now using the dvb_dmx_swfilter_packets, everything
-	       runs fine now
-  2004-06-27 - able to watch and switching channels (pre-alpha)
-	     - no section filtering yet
-  2004-06-06 - first TS received, but kernel oops :/
-  2004-05-14 - firmware loader is working
-  2004-05-11 - start writing the driver
-
-1. How to use?
-1.1. Firmware
+
+  2005-06-30
+
+  - added support for WideView WT-220U (Thanks to Steve Chang)
+
+  2005-05-30
+
+  - added basic isochronous support to the dvb-usb-framework
+  - added support for Conexant Hybrid reference design and Nebula
+	       DigiTV USB
+
+  2005-04-17
+
+  - all dibusb devices ported to make use of the dvb-usb-framework
+
+  2005-04-02
+
+  - re-enabled and improved remote control code.
+
+  2005-03-31
+
+  - ported the Yakumo/Hama/Typhoon DVB-T USB2.0 device to dvb-usb.
+
+  2005-03-30
+
+  - first commit of the dvb-usb-module based on the dibusb-source.
+    First device is a new driver for the
+    TwinhanDTV Alpha / MagicBox II USB2.0-only DVB-T device.
+  - (change from dvb-dibusb to dvb-usb)
+
+  2005-03-28
+
+  - added support for the AVerMedia AverTV DVB-T USB2.0 device
+    (Thanks to Glen Harris and Jiun-Kuei Jung, AVerMedia)
+
+  2005-03-14
+
+  - added support for the Typhoon/Yakumo/HAMA DVB-T mobile USB2.0
+
+  2005-02-11
+
+  - added support for the KWorld/ADSTech Instant DVB-T USB2.0.
+    Thanks a lot to Joachim von Caron
+
+  2005-02-02
+  - added support for the Hauppauge Win-TV Nova-T USB2
+
+  2005-01-31
+  - distorted streaming is gone for USB1.1 devices
+
+  2005-01-13
+
+  - moved the mirrored pid_filter_table back to dvb-dibusb
+    first almost working version for HanfTek UMT-010
+    found out, that Yakumo/HAMA/Typhoon are predecessors of the HanfTek UMT-010
+
+  2005-01-10
+
+  - refactoring completed, now everything is very delightful
+
+  - tuner quirks for some weird devices (Artec T1 AN2235 device has sometimes a
+    Panasonic Tuner assembled). Tunerprobing implemented.
+    Thanks a lot to Gunnar Wittich.
+
+  2004-12-29
+
+  - after several days of struggling around bug of no returning URBs fixed.
+
+  2004-12-26
+
+  - refactored the dibusb-driver, splitted into separate files
+  - i2c-probing enabled
+
+  2004-12-06
+
+  - possibility for demod i2c-address probing
+  - new usb IDs (Compro, Artec)
+
+  2004-11-23
+
+  - merged changes from DiB3000MC_ver2.1
+  - revised the debugging
+  - possibility to deliver the complete TS for USB2.0
+
+  2004-11-21
+
+  - first working version of the dib3000mc/p frontend driver.
+
+  2004-11-12
+
+  - added additional remote control keys. Thanks to Uwe Hanke.
+
+  2004-11-07
+
+  - added remote control support. Thanks to David Matthews.
+
+  2004-11-05
+
+  - added support for a new devices (Grandtec/Avermedia/Artec)
+  - merged my changes (for dib3000mb/dibusb) to the FE_REFACTORING, because it became HEAD
+  - moved transfer control (pid filter, fifo control) from usb driver to frontend, it seems
+    better settled there (added xfer_ops-struct)
+  - created a common files for frontends (mc/p/mb)
+
+  2004-09-28
+
+  - added support for a new device (Unknown, vendor ID is Hyper-Paltek)
+
+  2004-09-20
+
+  - added support for a new device (Compro DVB-U2000), thanks
+    to Amaury Demol for reporting
+  - changed usb TS transfer method (several urbs, stopping transfer
+    before setting a new pid)
+
+  2004-09-13
+
+  - added support for a new device (Artec T1 USB TVBOX), thanks
+    to Christian Motschke for reporting
+
+  2004-09-05
+
+  - released the dibusb device and dib3000mb-frontend driver
+    (old news for vp7041.c)
+
+  2004-07-15
+
+  - found out, by accident, that the device has a TUA6010XS for PLL
+
+  2004-07-12
+
+  - figured out, that the driver should also work with the
+    CTS Portable (Chinese Television System)
+
+  2004-07-08
+
+  - firmware-extraction-2.422-problem solved, driver is now working
+    properly with firmware extracted from 2.422
+  - #if for 2.6.4 (dvb), compile issue
+  - changed firmware handling, see vp7041.txt sec 1.1
+
+  2004-07-02
+
+  - some tuner modifications, v0.1, cleanups, first public
+
+  2004-06-28
+
+  - now using the dvb_dmx_swfilter_packets, everything runs fine now
+
+  2004-06-27
+
+  - able to watch and switching channels (pre-alpha)
+  - no section filtering yet
+
+  2004-06-06
+
+  - first TS received, but kernel oops :/
+
+  2004-05-14
+
+  - firmware loader is working
+
+  2004-05-11
+
+  - start writing the driver
+
+How to use?
+-----------
+
+Firmware
+~~~~~~~~
 
 Most of the USB drivers need to download a firmware to the device before start
 working.
@@ -123,7 +233,8 @@ you need for your device:
 
 https://linuxtv.org/wiki/index.php/DVB_USB
 
-1.2. Compiling
+Compiling
+~~~~~~~~~
 
 Since the driver is in the linux kernel, activating the driver in
 your favorite config-environment should sufficient. I recommend
@@ -132,7 +243,8 @@ to compile the driver as module. Hotplug does the rest.
 If you use dvb-kernel enter the build-2.6 directory run 'make' and 'insmod.sh
 load' afterwards.
 
-1.3. Loading the drivers
+Loading the drivers
+~~~~~~~~~~~~~~~~~~~
 
 Hotplug is able to load the driver, when it is needed (because you plugged
 in the device).
@@ -142,13 +254,18 @@ from within the dvb-kernel cvs repository.
 
 first have a look, which debug level are available:
 
-modinfo dvb-usb
-modinfo dvb-usb-vp7045
-etc.
+.. code-block:: none
 
-modprobe dvb-usb debug=<level>
-modprobe dvb-usb-vp7045 debug=<level>
-etc.
+	# modinfo dvb-usb
+	# modinfo dvb-usb-vp7045
+
+	etc.
+
+.. code-block:: none
+
+	modprobe dvb-usb debug=<level>
+	modprobe dvb-usb-vp7045 debug=<level>
+	etc.
 
 should do the trick.
 
@@ -160,16 +277,19 @@ At this point you should be able to start a dvb-capable application. I'm use
 (t|s)zap, mplayer and dvbscan to test the basics. VDR-xine provides the
 long-term test scenario.
 
-2. Known problems and bugs
+Known problems and bugs
+-----------------------
 
 - Don't remove the USB device while running an DVB application, your system
   will go crazy or die most likely.
 
-2.1. Adding support for devices
+Adding support for devices
+~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 TODO
 
-2.2. USB1.1 Bandwidth limitation
+USB1.1 Bandwidth limitation
+~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 A lot of the currently supported devices are USB1.1 and thus they have a
 maximum bandwidth of about 5-6 MBit/s when connected to a USB2.0 hub.
@@ -185,48 +305,51 @@ definitely. All dvb-usb-devices I was using (Twinhan, Kworld, DiBcom) are
 working like charm now with VDR. Sometimes I even was able to record a channel
 and watch another one.
 
-2.3. Comments
+Comments
+~~~~~~~~
 
 Patches, comments and suggestions are very very welcome.
 
 3. Acknowledgements
+-------------------
+
    Amaury Demol (Amaury.Demol@parrot.com) and Francois Kanounnikoff from DiBcom for
-    providing specs, code and help, on which the dvb-dibusb, dib3000mb and
-    dib3000mc are based.
+   providing specs, code and help, on which the dvb-dibusb, dib3000mb and
+   dib3000mc are based.
 
    David Matthews for identifying a new device type (Artec T1 with AN2235)
-    and for extending dibusb with remote control event handling. Thank you.
+   and for extending dibusb with remote control event handling. Thank you.
 
    Alex Woods for frequently answering question about usb and dvb
-    stuff, a big thank you.
+   stuff, a big thank you.
 
    Bernd Wagner for helping with huge bug reports and discussions.
 
    Gunnar Wittich and Joachim von Caron for their trust for providing
-    root-shells on their machines to implement support for new devices.
+   root-shells on their machines to implement support for new devices.
 
    Allan Third and Michael Hutchinson for their help to write the Nebula
-    digitv-driver.
+   digitv-driver.
 
    Glen Harris for bringing up, that there is a new dibusb-device and Jiun-Kuei
-    Jung from AVerMedia who kindly provided a special firmware to get the device
-    up and running in Linux.
+   Jung from AVerMedia who kindly provided a special firmware to get the device
+   up and running in Linux.
 
    Jennifer Chen, Jeff and Jack from Twinhan for kindly supporting by
-	writing the vp7045-driver.
+   writing the vp7045-driver.
 
    Steve Chang from WideView for providing information for new devices and
-	firmware files.
+   firmware files.
 
    Michael Paxton for submitting remote control keymaps.
 
    Some guys on the linux-dvb mailing list for encouraging me.
 
    Peter Schildmann >peter.schildmann-nospam-at-web.de< for his
-    user-level firmware loader, which saves a lot of time
-    (when writing the vp7041 driver)
+   user-level firmware loader, which saves a lot of time
+   (when writing the vp7041 driver)
 
    Ulf Hermenau for helping me out with traditional chinese.
 
    André Smoktun and Christian Frömmel for supporting me with
-    hardware and listening to my problems very patiently.
+   hardware and listening to my problems very patiently.
diff --git a/Documentation/media/dvb-drivers/index.rst b/Documentation/media/dvb-drivers/index.rst
index fa553263e5cf..2ec80b9e70b5 100644
--- a/Documentation/media/dvb-drivers/index.rst
+++ b/Documentation/media/dvb-drivers/index.rst
@@ -23,4 +23,5 @@ License".
 	bt8xx
 	cards
 	ci
+	dvb-usb
 	contributors
-- 
2.7.4

