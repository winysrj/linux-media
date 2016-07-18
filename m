Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45827 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbcGRB43 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:29 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 33/36] [media] doc-rst: add documentation for Zoran driver
Date: Sun, 17 Jul 2016 22:56:16 -0300
Message-Id: <7200e689670ce6fa5c0f22db843e82cfcc6b6d2e.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert it to ReST and add to media/v4l-drivers book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/index.rst |   1 +
 Documentation/media/v4l-drivers/zoran.rst | 305 ++++++++++++++++++------------
 2 files changed, 189 insertions(+), 117 deletions(-)

diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index 90224e0231df..4431b089af49 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -40,4 +40,5 @@ License".
 	si476x
 	soc-camera
 	uvcvideo
+	zoran
 	zr364xx
diff --git a/Documentation/media/v4l-drivers/zoran.rst b/Documentation/media/v4l-drivers/zoran.rst
index b5a911fd0602..c3a0f7bc2c7b 100644
--- a/Documentation/media/v4l-drivers/zoran.rst
+++ b/Documentation/media/v4l-drivers/zoran.rst
@@ -1,139 +1,191 @@
-Frequently Asked Questions:
-===========================
-subject: unified zoran driver (zr360x7, zoran, buz, dc10(+), dc30(+), lml33)
+The Zoran driver
+================
+
+unified zoran driver (zr360x7, zoran, buz, dc10(+), dc30(+), lml33)
+
 website: http://mjpeg.sourceforge.net/driver-zoran/
 
-1. What cards are supported
-1.1 What the TV decoder can do an what not
-1.2 What the TV encoder can do an what not
-2. How do I get this damn thing to work
-3. What mainboard should I use (or why doesn't my card work)
-4. Programming interface
-5. Applications
-6. Concerning buffer sizes, quality, output size etc.
-7. It hangs/crashes/fails/whatevers! Help!
-8. Maintainers/Contacting
-9. License
 
-===========================
+Frequently Asked Questions
+--------------------------
 
-1. What cards are supported
+What cards are supported
+------------------------
 
 Iomega Buz, Linux Media Labs LML33/LML33R10, Pinnacle/Miro
 DC10/DC10+/DC30/DC30+ and related boards (available under various names).
 
-Iomega Buz:
+Iomega Buz
+~~~~~~~~~~
+
 * Zoran zr36067 PCI controller
 * Zoran zr36060 MJPEG codec
 * Philips saa7111 TV decoder
 * Philips saa7185 TV encoder
+
 Drivers to use: videodev, i2c-core, i2c-algo-bit,
-		videocodec, saa7111, saa7185, zr36060, zr36067
+videocodec, saa7111, saa7185, zr36060, zr36067
+
 Inputs/outputs: Composite and S-video
+
 Norms: PAL, SECAM (720x576 @ 25 fps), NTSC (720x480 @ 29.97 fps)
+
 Card number: 7
 
-AverMedia 6 Eyes AVS6EYES:
+AverMedia 6 Eyes AVS6EYES
+~~~~~~~~~~~~~~~~~~~~~~~~~
+
 * Zoran zr36067 PCI controller
 * Zoran zr36060 MJPEG codec
 * Samsung ks0127 TV decoder
 * Conexant bt866  TV encoder
+
 Drivers to use: videodev, i2c-core, i2c-algo-bit,
-		videocodec, ks0127, bt866, zr36060, zr36067
-Inputs/outputs: Six physical inputs. 1-6 are composite,
-		1-2, 3-4, 5-6 doubles as S-video,
-		1-3 triples as component.
-		One composite output.
+videocodec, ks0127, bt866, zr36060, zr36067
+
+Inputs/outputs:
+	Six physical inputs. 1-6 are composite,
+	1-2, 3-4, 5-6 doubles as S-video,
+	1-3 triples as component.
+	One composite output.
+
 Norms: PAL, SECAM (720x576 @ 25 fps), NTSC (720x480 @ 29.97 fps)
+
 Card number: 8
-Not autodetected, card=8 is necessary.
 
-Linux Media Labs LML33:
+.. note::
+
+   Not autodetected, card=8 is necessary.
+
+Linux Media Labs LML33
+~~~~~~~~~~~~~~~~~~~~~~
+
 * Zoran zr36067 PCI controller
 * Zoran zr36060 MJPEG codec
 * Brooktree bt819 TV decoder
 * Brooktree bt856 TV encoder
+
 Drivers to use: videodev, i2c-core, i2c-algo-bit,
-		videocodec, bt819, bt856, zr36060, zr36067
+videocodec, bt819, bt856, zr36060, zr36067
+
 Inputs/outputs: Composite and S-video
+
 Norms: PAL (720x576 @ 25 fps), NTSC (720x480 @ 29.97 fps)
+
 Card number: 5
 
-Linux Media Labs LML33R10:
+Linux Media Labs LML33R10
+~~~~~~~~~~~~~~~~~~~~~~~~~
+
 * Zoran zr36067 PCI controller
 * Zoran zr36060 MJPEG codec
 * Philips saa7114 TV decoder
 * Analog Devices adv7170 TV encoder
+
 Drivers to use: videodev, i2c-core, i2c-algo-bit,
-		videocodec, saa7114, adv7170, zr36060, zr36067
+videocodec, saa7114, adv7170, zr36060, zr36067
+
 Inputs/outputs: Composite and S-video
+
 Norms: PAL (720x576 @ 25 fps), NTSC (720x480 @ 29.97 fps)
+
 Card number: 6
 
-Pinnacle/Miro DC10(new):
+Pinnacle/Miro DC10(new)
+~~~~~~~~~~~~~~~~~~~~~~~
+
 * Zoran zr36057 PCI controller
 * Zoran zr36060 MJPEG codec
 * Philips saa7110a TV decoder
 * Analog Devices adv7176 TV encoder
+
 Drivers to use: videodev, i2c-core, i2c-algo-bit,
-		videocodec, saa7110, adv7175, zr36060, zr36067
+videocodec, saa7110, adv7175, zr36060, zr36067
+
 Inputs/outputs: Composite, S-video and Internal
+
 Norms: PAL, SECAM (768x576 @ 25 fps), NTSC (640x480 @ 29.97 fps)
+
 Card number: 1
 
-Pinnacle/Miro DC10+:
+Pinnacle/Miro DC10+
+~~~~~~~~~~~~~~~~~~~
+
 * Zoran zr36067 PCI controller
 * Zoran zr36060 MJPEG codec
 * Philips saa7110a TV decoder
 * Analog Devices adv7176 TV encoder
+
 Drivers to use: videodev, i2c-core, i2c-algo-bit,
-		videocodec, sa7110, adv7175, zr36060, zr36067
+videocodec, sa7110, adv7175, zr36060, zr36067
+
 Inputs/outputs: Composite, S-video and Internal
+
 Norms: PAL, SECAM (768x576 @ 25 fps), NTSC (640x480 @ 29.97 fps)
+
 Card number: 2
 
-Pinnacle/Miro DC10(old): *
+Pinnacle/Miro DC10(old)
+~~~~~~~~~~~~~~~~~~~~~~~
+
 * Zoran zr36057 PCI controller
 * Zoran zr36050 MJPEG codec
 * Zoran zr36016 Video Front End or Fuji md0211 Video Front End (clone?)
 * Micronas vpx3220a TV decoder
-* mse3000 TV encoder or Analog Devices adv7176 TV encoder *
+* mse3000 TV encoder or Analog Devices adv7176 TV encoder
+
 Drivers to use: videodev, i2c-core, i2c-algo-bit,
-		videocodec, vpx3220, mse3000/adv7175, zr36050, zr36016, zr36067
+videocodec, vpx3220, mse3000/adv7175, zr36050, zr36016, zr36067
+
 Inputs/outputs: Composite, S-video and Internal
+
 Norms: PAL, SECAM (768x576 @ 25 fps), NTSC (640x480 @ 29.97 fps)
+
 Card number: 0
 
-Pinnacle/Miro DC30: *
+Pinnacle/Miro DC30
+~~~~~~~~~~~~~~~~~~
+
 * Zoran zr36057 PCI controller
 * Zoran zr36050 MJPEG codec
 * Zoran zr36016 Video Front End
 * Micronas vpx3225d/vpx3220a/vpx3216b TV decoder
 * Analog Devices adv7176 TV encoder
+
 Drivers to use: videodev, i2c-core, i2c-algo-bit,
-		videocodec, vpx3220/vpx3224, adv7175, zr36050, zr36016, zr36067
+videocodec, vpx3220/vpx3224, adv7175, zr36050, zr36016, zr36067
+
 Inputs/outputs: Composite, S-video and Internal
+
 Norms: PAL, SECAM (768x576 @ 25 fps), NTSC (640x480 @ 29.97 fps)
+
 Card number: 3
 
-Pinnacle/Miro DC30+: *
+Pinnacle/Miro DC30+
+~~~~~~~~~~~~~~~~~~~
+
 * Zoran zr36067 PCI controller
 * Zoran zr36050 MJPEG codec
 * Zoran zr36016 Video Front End
 * Micronas vpx3225d/vpx3220a/vpx3216b TV decoder
 * Analog Devices adv7176 TV encoder
+
 Drivers to use: videodev, i2c-core, i2c-algo-bit,
-		videocodec, vpx3220/vpx3224, adv7175, zr36050, zr36015, zr36067
+videocodec, vpx3220/vpx3224, adv7175, zr36050, zr36015, zr36067
+
 Inputs/outputs: Composite, S-video and Internal
+
 Norms: PAL, SECAM (768x576 @ 25 fps), NTSC (640x480 @ 29.97 fps)
+
 Card number: 4
 
-Note: No module for the mse3000 is available yet
-Note: No module for the vpx3224 is available yet
+.. note::
 
-===========================
+   #) No module for the mse3000 is available yet
+   #) No module for the vpx3224 is available yet
 
 1.1 What the TV decoder can do an what not
+------------------------------------------
 
 The best know TV standards are NTSC/PAL/SECAM. but for decoding a frame that
 information is not enough. There are several formats of the TV standards.
@@ -187,32 +239,44 @@ to split coma and luma instead of a Delay line.
 But I did not defiantly find out what NTSC Comb is.
 
 Philips saa7111 TV decoder
-was introduced in 1997, is used in the BUZ and
-can handle: PAL B/G/H/I, PAL N, PAL M, NTSC M, NTSC N, NTSC 4.43 and SECAM
+~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+- was introduced in 1997, is used in the BUZ and
+- can handle: PAL B/G/H/I, PAL N, PAL M, NTSC M, NTSC N, NTSC 4.43 and SECAM
 
 Philips saa7110a TV decoder
-was introduced in 1995, is used in the Pinnacle/Miro DC10(new), DC10+ and
-can handle: PAL B/G, NTSC M and SECAM
+~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+- was introduced in 1995, is used in the Pinnacle/Miro DC10(new), DC10+ and
+- can handle: PAL B/G, NTSC M and SECAM
 
 Philips saa7114 TV decoder
-was introduced in 2000, is used in the LML33R10 and
-can handle: PAL B/G/D/H/I/N, PAL N, PAL M, NTSC M, NTSC 4.43 and SECAM
+~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+- was introduced in 2000, is used in the LML33R10 and
+- can handle: PAL B/G/D/H/I/N, PAL N, PAL M, NTSC M, NTSC 4.43 and SECAM
 
 Brooktree bt819 TV decoder
-was introduced in 1996, and is used in the LML33 and
-can handle: PAL B/D/G/H/I, NTSC M
+~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+- was introduced in 1996, and is used in the LML33 and
+- can handle: PAL B/D/G/H/I, NTSC M
 
 Micronas vpx3220a TV decoder
-was introduced in 1996, is used in the DC30 and DC30+ and
-can handle: PAL B/G/H/I, PAL N, PAL M, NTSC M, NTSC 44, PAL 60, SECAM,NTSC Comb
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+- was introduced in 1996, is used in the DC30 and DC30+ and
+- can handle: PAL B/G/H/I, PAL N, PAL M, NTSC M, NTSC 44, PAL 60, SECAM,NTSC Comb
 
 Samsung ks0127 TV decoder
-is used in the AVS6EYES card and
-can handle: NTSC-M/N/44, PAL-M/N/B/G/H/I/D/K/L and SECAM
+~~~~~~~~~~~~~~~~~~~~~~~~~
 
-===========================
+- is used in the AVS6EYES card and
+- can handle: NTSC-M/N/44, PAL-M/N/B/G/H/I/D/K/L and SECAM
 
-1.2 What the TV encoder can do an what not
+
+What the TV encoder can do an what not
+--------------------------------------
 
 The TV encoder are doing the "same" as the decoder, but in the oder direction.
 You feed them digital data and the generate a Composite or SVHS signal.
@@ -220,36 +284,47 @@ For information about the colorsystems and TV norm take a look in the
 TV decoder section.
 
 Philips saa7185 TV Encoder
-was introduced in 1996, is used in the BUZ
-can generate: PAL B/G, NTSC M
+~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+- was introduced in 1996, is used in the BUZ
+- can generate: PAL B/G, NTSC M
 
 Brooktree bt856 TV Encoder
-was introduced in 1994, is used in the LML33
-can generate: PAL B/D/G/H/I/N, PAL M, NTSC M, PAL-N (Argentina)
+~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+- was introduced in 1994, is used in the LML33
+- can generate: PAL B/D/G/H/I/N, PAL M, NTSC M, PAL-N (Argentina)
 
 Analog Devices adv7170 TV Encoder
-was introduced in 2000, is used in the LML300R10
-can generate: PAL B/D/G/H/I/N, PAL M, NTSC M, PAL 60
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+- was introduced in 2000, is used in the LML300R10
+- can generate: PAL B/D/G/H/I/N, PAL M, NTSC M, PAL 60
 
 Analog Devices adv7175 TV Encoder
-was introduced in 1996, is used in the DC10, DC10+, DC10 old, DC30, DC30+
-can generate: PAL B/D/G/H/I/N, PAL M, NTSC M
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+- was introduced in 1996, is used in the DC10, DC10+, DC10 old, DC30, DC30+
+- can generate: PAL B/D/G/H/I/N, PAL M, NTSC M
 
 ITT mse3000 TV encoder
-was introduced in 1991, is used in the DC10 old
-can generate: PAL , NTSC , SECAM
+~~~~~~~~~~~~~~~~~~~~~~
+
+- was introduced in 1991, is used in the DC10 old
+- can generate: PAL , NTSC , SECAM
 
 Conexant bt866 TV encoder
-is used in AVS6EYES, and
-can generate: NTSC/PAL, PAL­M, PAL­N
+~~~~~~~~~~~~~~~~~~~~~~~~~
+
+- is used in AVS6EYES, and
+- can generate: NTSC/PAL, PAL­M, PAL­N
 
 The adv717x, should be able to produce PAL N. But you find nothing PAL N
 specific in the registers. Seem that you have to reuse a other standard
 to generate PAL N, maybe it would work if you use the PAL M settings.
 
-==========================
-
-2. How do I get this damn thing to work
+How do I get this damn thing to work
+------------------------------------
 
 Load zr36067.o. If it can't autodetect your card, use the card=X insmod
 option with X being the card number as given in the previous section.
@@ -268,9 +343,9 @@ XF86Config-4 when you use X by default, or to run 'v4l-conf -c <device>' in
 one of your startup scripts (normally rc.local) if you don't use X. Both
 make sure that the modules are loaded on startup, under the root account.
 
-===========================
+What mainboard should I use (or why doesn't my card work)
+---------------------------------------------------------
 
-3. What mainboard should I use (or why doesn't my card work)
 
 <insert lousy disclaimer here>. In short: good=SiS/Intel, bad=VIA.
 
@@ -278,31 +353,31 @@ Experience tells us that people with a Buz, on average, have more problems
 than users with a DC10+/LML33. Also, it tells us that people owning a VIA-
 based mainboard (ktXXX, MVP3) have more problems than users with a mainboard
 based on a different chipset. Here's some notes from Andrew Stevens:
---
+
 Here's my experience of using LML33 and Buz on various motherboards:
 
-VIA MVP3
-	Forget it. Pointless. Doesn't work.
-Intel 430FX (Pentium 200)
-	LML33 perfect, Buz tolerable (3 or 4 frames dropped per movie)
-Intel 440BX (early stepping)
-	LML33 tolerable. Buz starting to get annoying (6-10 frames/hour)
-Intel 440BX (late stepping)
-	Buz tolerable, LML3 almost perfect (occasional single frame drops)
-SiS735
-	LML33 perfect, Buz tolerable.
-VIA KT133(*)
-	LML33 starting to get annoying, Buz poor enough that I have up.
+- VIA MVP3
+	- Forget it. Pointless. Doesn't work.
+- Intel 430FX (Pentium 200)
+	- LML33 perfect, Buz tolerable (3 or 4 frames dropped per movie)
+- Intel 440BX (early stepping)
+	- LML33 tolerable. Buz starting to get annoying (6-10 frames/hour)
+- Intel 440BX (late stepping)
+	- Buz tolerable, LML3 almost perfect (occasional single frame drops)
+- SiS735
+	- LML33 perfect, Buz tolerable.
+- VIA KT133(*)
+	- LML33 starting to get annoying, Buz poor enough that I have up.
+
+- Both 440BX boards were dual CPU versions.
 
-Both 440BX boards were dual CPU versions.
---
 Bernhard Praschinger later added:
---
-AMD 751
-	Buz perfect-tolerable
-AMD 760
-	Buz perfect-tolerable
---
+
+- AMD 751
+	- Buz perfect-tolerable
+- AMD 760
+	- Buz perfect-tolerable
+
 In general, people on the user mailinglist won't give you much of a chance
 if you have a VIA-based motherboard. They may be cheap, but sometimes, you'd
 rather want to spend some more money on better boards. In general, VIA
@@ -317,9 +392,8 @@ the quality/buffersize during capture (see 'Concerning buffer sizes, quality,
 output size etc.'). If it hangs, there's little we can do as of now. Check
 your IRQs and make sure the card has its own interrupts.
 
-===========================
-
-4. Programming interface
+Programming interface
+---------------------
 
 This driver conforms to video4linux2. Support for V4L1 and for the custom
 zoran ioctls has been removed in kernel 2.6.38.
@@ -337,35 +411,39 @@ Additional notes for software developers:
    settings of a variety of TV capture cards which may work in ITU or
    square pixel format.
 
-===========================
-
-5. Applications
+Applications
+------------
 
 Applications known to work with this driver:
 
 TV viewing:
+
 * xawtv
 * kwintv
 * probably any TV application that supports video4linux or video4linux2.
 
 MJPEG capture/playback:
+
 * mjpegtools/lavtools (or Linux Video Studio)
 * gstreamer
 * mplayer
 
 General raw capture:
+
 * xawtv
 * gstreamer
 * probably any application that supports video4linux or video4linux2
 
 Video editing:
+
 * Cinelerra
 * MainActor
 * mjpegtools (or Linux Video Studio)
 
-===========================
 
-6. Concerning buffer sizes, quality, output size etc.
+Concerning buffer sizes, quality, output size etc.
+--------------------------------------------------
+
 
 The zr36060 can do 1:2 JPEG compression. This is really the theoretical
 maximum that the chipset can reach. The driver can, however, limit compression
@@ -448,9 +526,8 @@ If you experience timeouts, lowering the quality/buffersize or using
 'low_bitrate=1 as insmod option for zr36060.o might actually help, as is
 proven by the Buz.
 
-===========================
-
-7. It hangs/crashes/fails/whatevers! Help!
+It hangs/crashes/fails/whatevers! Help!
+---------------------------------------
 
 Make sure that the card has its own interrupts (see /proc/interrupts), check
 the output of dmesg at high verbosity (load zr36067.o with debug=2,
@@ -467,9 +544,8 @@ the kernel version, driver version, glibc version, gcc version and any other
 information that might possibly be of interest. Also provide the dmesg output
 at high verbosity. See 'Contacting' on how to contact the developers.
 
-===========================
-
-8. Maintainers/Contacting
+Maintainers/Contacting
+----------------------
 
 The driver is currently maintained by Laurent Pinchart and Ronald Bultje
 (<laurent.pinchart@skynet.be> and <rbultje@ronald.bitfreak.net>). For bug
@@ -487,11 +563,10 @@ Previous maintainers/developers of this driver include Serguei Miridonov
 <mirsev@cicese.mx>, Wolfgang Scherr <scherr@net4you.net>, Dave Perks
 <dperks@ibm.net> and Rainer Johanni <Rainer@Johanni.de>.
 
-===========================
+Driver's License
+----------------
 
-9. License
-
-This driver is distributed under the terms of the General Public License.
+    This driver is distributed under the terms of the General Public License.
 
     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
@@ -503,8 +578,4 @@ This driver is distributed under the terms of the General Public License.
     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
     GNU General Public License for more details.
 
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-
 See http://www.gnu.org/ for more information.
-- 
2.7.4

