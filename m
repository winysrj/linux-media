Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59538 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbcGRSar (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 14:30:47 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 02/18] [media] doc-rst: add documentation for bttv driver
Date: Mon, 18 Jul 2016 15:30:24 -0300
Message-Id: <3f3edfd6d52070da27617170608d58e9da10b485.1468865380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468865380.git.mchehab@s-opensource.com>
References: <cover.1468865380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468865380.git.mchehab@s-opensource.com>
References: <cover.1468865380.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert it to ReST and add it to media/v4l-drivers book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/bttv.rst  | 156 ++++++++++++++++++------------
 Documentation/media/v4l-drivers/index.rst |   1 +
 2 files changed, 96 insertions(+), 61 deletions(-)

diff --git a/Documentation/media/v4l-drivers/bttv.rst b/Documentation/media/v4l-drivers/bttv.rst
index d7d956835e38..611e8d529f16 100644
--- a/Documentation/media/v4l-drivers/bttv.rst
+++ b/Documentation/media/v4l-drivers/bttv.rst
@@ -1,11 +1,13 @@
 The bttv driver
 ===============
 
-
 Release notes for bttv
 ----------------------
 
 You'll need at least these config options for bttv:
+
+.. code-block:: none
+
 	CONFIG_I2C=m
 	CONFIG_I2C_ALGOBIT=m
 	CONFIG_VIDEO_DEV=m
@@ -26,6 +28,9 @@ cards is in CARDLIST.bttv
 
 If bttv takes very long to load (happens sometimes with the cheap
 cards which have no tuner), try adding this to your modules.conf:
+
+.. code-block:: none
+
 	options i2c-algo-bit bit_test=1
 
 For the WinTV/PVR you need one firmware file from the driver CD:
@@ -44,10 +49,12 @@ Autodetecting cards
 bttv uses the PCI Subsystem ID to autodetect the card type.  lspci lists
 the Subsystem ID in the second line, looks like this:
 
-00:0a.0 Multimedia video controller: Brooktree Corporation Bt878 (rev 02)
-	Subsystem: Hauppauge computer works Inc. WinTV/GO
-	Flags: bus master, medium devsel, latency 32, IRQ 5
-	Memory at e2000000 (32-bit, prefetchable) [size=4K]
+.. code-block:: none
+
+	00:0a.0 Multimedia video controller: Brooktree Corporation Bt878 (rev 02)
+		Subsystem: Hauppauge computer works Inc. WinTV/GO
+		Flags: bus master, medium devsel, latency 32, IRQ 5
+		Memory at e2000000 (32-bit, prefetchable) [size=4K]
 
 only bt878-based cards can have a subsystem ID (which does not mean
 that every card really has one).  bt848 cards can't have a Subsystem
@@ -66,7 +73,7 @@ If you have some knowledge and spare time, please try to fix this
 yourself (patches very welcome of course...)  You know: The linux
 slogan is "Do it yourself".
 
-There is a mailing list: linux-media@vger.kernel.org
+There is a mailing list at
 http://vger.kernel.org/vger-lists.html#linux-media
 
 If you have trouble with some specific TV card, try to ask there
@@ -91,7 +98,7 @@ This list tends to be outdated because it is updated manually ...
 
 bttv.o
 
-::
+.. code-block:: none
 
 	the bt848/878 (grabber chip) driver
 
@@ -159,7 +166,7 @@ bttv.o
 
 tuner.o
 
-::
+.. code-block:: none
 
 	The tuner driver.  You need this unless you want to use only
 	with a camera or external tuner ...
@@ -173,7 +180,7 @@ tuner.o
 
 tvaudio.o
 
-::
+.. code-block:: none
 
 	new, experimental module which is supported to provide a single
 	driver for all simple i2c audio control chips (tda/tea*).
@@ -224,8 +231,7 @@ tvaudio.o
 
 msp3400.o
 
-::
-
+.. code-block:: none
 
 	The driver for the msp34xx sound processor chips. If you have a
 	stereo card, you probably want to insmod this one.
@@ -246,7 +252,7 @@ msp3400.o
 
 tea6300.o - OBSOLETE (use tvaudio instead)
 
-::
+.. code-block:: none
 
 	The driver for the tea6300 fader chip.  If you have a stereo
 	card and the msp3400.o doesn't work, you might want to try this
@@ -258,7 +264,7 @@ tea6300.o - OBSOLETE (use tvaudio instead)
 
 tda8425.o - OBSOLETE (use tvaudio instead)
 
-::
+.. code-block:: none
 
 	The driver for the tda8425 fader chip.  This driver used to be
 	part of bttv.c, so if your sound used to work but does not
@@ -269,7 +275,7 @@ tda8425.o - OBSOLETE (use tvaudio instead)
 
 tda985x.o - OBSOLETE (use tvaudio instead)
 
-::
+.. code-block:: none
 
 	The driver for the tda9850/55 audio chips.
 
@@ -444,6 +450,8 @@ Sound will work only, if the correct entry is used (for video it often
 makes no difference).  The bttv driver prints a line to the kernel
 log, telling which card type is used.  Like this one:
 
+.. code-block:: none
+
 	bttv0: model: BT848(Hauppauge old) [autodetected]
 
 You should verify this is correct.  If it isn't, you have to pass the
@@ -489,19 +497,21 @@ As mentioned above, there is a array which holds the required
 information for each known board.  You basically have to create a new
 line for your board.  The important fields are these two:
 
-struct tvcard
-{
-	[ ... ]
-	u32 gpiomask;
-	u32 audiomux[6]; /* Tuner, Radio, external, internal, mute, stereo */
-};
+.. code-block:: c
+
+	struct tvcard
+	{
+		[ ... ]
+		u32 gpiomask;
+		u32 audiomux[6]; /* Tuner, Radio, external, internal, mute, stereo */
+	};
 
 gpiomask specifies which pins are used to control the audio mux chip.
 The corresponding bits in the output enable register
 (BT848_GPIO_OUT_EN) will be set as these pins must be driven by the
 bt848 chip.
 
-The audiomux[] array holds the data values for the different inputs
+The audiomux\[\] array holds the data values for the different inputs
 (i.e. which pins must be high/low for tuner/mute/...).  This will be
 written to the data register (BT848_GPIO_DATA) to switch the audio
 mux.
@@ -512,11 +522,11 @@ the audiomux array.  If you have Windows and the drivers four your
 card installed, you might to check out if you can read these registers
 values used by the windows driver.  A tool to do this is available
 from ftp://telepresence.dmem.strath.ac.uk/pub/bt848/winutil, but it
-does'nt work with bt878 boards according to some reports I received.
+doesn't work with bt878 boards according to some reports I received.
 Another one with bt878 support is available from
 http://btwincap.sourceforge.net/Files/btspy2.00.zip
 
-You might also dig around in the *.ini files of the Windows applications.
+You might also dig around in the \*.ini files of the Windows applications.
 You can have a look at the board to see which of the gpio pins are
 connected at all and then start trial-and-error ...
 
@@ -524,22 +534,26 @@ connected at all and then start trial-and-error ...
 Starting with release 0.7.41 bttv has a number of insmod options to
 make the gpio debugging easier:
 
-bttv_gpio=0/1		enable/disable gpio debug messages
-gpiomask=n		set the gpiomask value
-audiomux=i,j,...	set the values of the audiomux array
-audioall=a		set the values of the audiomux array (one
-			value for all array elements, useful to check
-			out which effect the particular value has).
+.. code-block:: none
+
+	bttv_gpio=0/1		enable/disable gpio debug messages
+	gpiomask=n		set the gpiomask value
+	audiomux=i,j,...	set the values of the audiomux array
+	audioall=a		set the values of the audiomux array (one
+				value for all array elements, useful to check
+				out which effect the particular value has).
 
 The messages printed with bttv_gpio=1 look like this:
 
+.. code-block:: none
+
 	bttv0: gpio: en=00000027, out=00000024 in=00ffffd8 [audio: off]
 
-en  =	output _en_able register (BT848_GPIO_OUT_EN)
-out =	_out_put bits of the data register (BT848_GPIO_DATA),
-	i.e. BT848_GPIO_DATA & BT848_GPIO_OUT_EN
-in  = 	_in_put bits of the data register,
-	i.e. BT848_GPIO_DATA & ~BT848_GPIO_OUT_EN
+	en  =	output _en_able register (BT848_GPIO_OUT_EN)
+	out =	_out_put bits of the data register (BT848_GPIO_DATA),
+		i.e. BT848_GPIO_DATA & BT848_GPIO_OUT_EN
+	in  = 	_in_put bits of the data register,
+		i.e. BT848_GPIO_DATA & ~BT848_GPIO_OUT_EN
 
 
 
@@ -549,19 +563,21 @@ Other elements of the tvcards array
 If you are trying to make a new card work you might find it useful to
 know what the other elements in the tvcards array are good for:
 
-video_inputs    - # of video inputs the card has
-audio_inputs    - historical cruft, not used any more.
-tuner           - which input is the tuner
-svhs            - which input is svhs (all others are labeled composite)
-muxsel          - video mux, input->registervalue mapping
-pll             - same as pll= insmod option
-tuner_type      - same as tuner= insmod option
-*_modulename    - hint whenever some card needs this or that audio
-		  module loaded to work properly.
-has_radio	- whenever this TV card has a radio tuner.
-no_msp34xx	- "1" disables loading of msp3400.o module
-no_tda9875	- "1" disables loading of tda9875.o module
-needs_tvaudio	- set to "1" to load tvaudio.o module
+.. code-block:: none
+
+	video_inputs    - # of video inputs the card has
+	audio_inputs    - historical cruft, not used any more.
+	tuner           - which input is the tuner
+	svhs            - which input is svhs (all others are labeled composite)
+	muxsel          - video mux, input->registervalue mapping
+	pll             - same as pll= insmod option
+	tuner_type      - same as tuner= insmod option
+	*_modulename    - hint whenever some card needs this or that audio
+			module loaded to work properly.
+	has_radio	- whenever this TV card has a radio tuner.
+	no_msp34xx	- "1" disables loading of msp3400.o module
+	no_tda9875	- "1" disables loading of tda9875.o module
+	needs_tvaudio	- set to "1" to load tvaudio.o module
 
 If some config item is specified both from the tvcards array and as
 insmod option, the insmod option takes precedence.
@@ -740,10 +756,12 @@ Identifying:
      - LR137      = Flyvideo DV2000/DV3000 (SAA7130/SAA7134 + IEEE1394)
      - LR138 Rev.C= Flyvideo 2000 (SAA7130)
      - LR138 Flyvideo 3000 (SAA7134) w/Stereo TV
+
 	- These exist in variations w/FM and w/Remote sometimes denoted
 	  by suffixes "FM" and "R".
 
   #) You have a laptop (miniPCI card):
+
       - Product    = FlyTV Platinum Mini
       - Model/Chip = LR212/saa7135
 
@@ -911,14 +929,14 @@ is wrong. If it doesn't work, send me email.
 
 
 - No Thanks to Leadtek they refused to answer any questions about their
-hardware. The driver was written by visual inspection of the card. If you
-use this driver, send an email insult to them, and tell them you won't
-continue buying their hardware unless they support Linux.
+  hardware. The driver was written by visual inspection of the card. If you
+  use this driver, send an email insult to them, and tell them you won't
+  continue buying their hardware unless they support Linux.
 
 - Little thanks to Princeton Technology Corp (http://www.princeton.com.tw)
-who make the audio attenuator. Their publicly available data-sheet available
-on their web site doesn't include the chip programming information! Hidden
-on their server are the full data-sheets, but don't ask how I found it.
+  who make the audio attenuator. Their publicly available data-sheet available
+  on their web site doesn't include the chip programming information! Hidden
+  on their server are the full data-sheets, but don't ask how I found it.
 
 To use the driver I use the following options, the tuner and pll settings might
 be different in your country
@@ -953,7 +971,7 @@ Provideo
    MediaForte TV-Vision PV951,
    Yoko PV951,
    Vivanco Tuner Card PCI Art.-Nr.: 68404,
-  ) now named PV-951T
+   ) now named PV-951T
 
 - Surveillance Series:
 
@@ -1009,7 +1027,7 @@ AVerMedia
 PCB      PCI-ID      Model-Name      Eeprom  Tuner  Sound    Country
 ======== =========== =============== ======= ====== ======== =======================
 M101.C   ISA !
-M108-B      Bt848                     --     FR1236		 US   [#f2]_,[#f3]_
+M108-B      Bt848                     --     FR1236		 US   [#f2]_, [#f3]_
 M1A8-A      Bt848    AVer TV-Phone           FM1216  --
 M168-T   1461:0003   AVerTV Studio   48:17   FM1216 TDA9840T  D    [#f1]_ w/FM w/Remote
 M168-U   1461:0004   TVCapture98     40:11   FI1216   --      D    w/Remote
@@ -1060,7 +1078,7 @@ Models:
 - Video Highway Xtreme (aka "VHX") (Bt848, FM w/ TEA5757)
 
 IXMicro (former: IMS=Integrated Micro Solutions)
-~~~~~~~
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 Models:
 
@@ -1138,8 +1156,10 @@ Models:
 
 - MTV878
        Package comes with different contents:
+
            a) pcb "MTV878" (CARD=75)
-           b) Pixelview Rev. 4_
+           b) Pixelview Rev. 4\_
+
 - MTV878R w/Remote Control
 - MTV878F w/Remote Control w/FM radio
 
@@ -1311,13 +1331,16 @@ Models:
 - TT-DVB-Sat
    - revisions 1.1, 1.3, 1.5, 1.6 and 2.1
    - This card is sold as OEM from:
+
 	- Siemens DVB-s Card
 	- Hauppauge WinTV DVB-S
 	- Technisat SkyStar 1 DVB
 	- Galaxis DVB Sat
+
    - Now this card is called TT-PCline Premium Family
    - TT-Budget (saa7146, bsru6-701a)
-    This card is sold as OEM from:
+     This card is sold as OEM from:
+
 	- Hauppauge WinTV Nova
 	- Satelco Standard PCI (DVB-S)
    - TT-DVB-C PCI
@@ -1566,7 +1589,7 @@ AVEC Intercapture (bt848, tea6320)
 NoBrand
 ~~~~~~~
 
-TV Excel = Australian Name for "PV-BT878P+ 8E" or "878TV Rev.3_"
+TV Excel = Australian Name for "PV-BT878P+ 8E" or "878TV Rev.3\_"
 
 Mach www.machspeed.com
 ~~~~~~~~~~~~~~~~~~~~~~
@@ -1621,9 +1644,11 @@ Models:
 - TV Tuner  -  HBY-33A-RAFFLES  Brooktree Bt848KPF + Philips
 - TV Tuner MG9910  -  HBY33A-TVO  CEI + Philips SAA7110 + OKI M548262 + ST STV8438CV
 - Primetime TV (ISA)
+
   - acquired by Singapore Technologies
   - now operating as Chartered Semiconductor Manufacturing
   - Manufacturer of video cards is listed as:
+
     - Cogent Electronics Industries [CEI]
 
 AITech
@@ -1646,7 +1671,8 @@ www.ids-imaging.de
 Models:
 
 - Falcon Series (capture only)
- In USA: http://www.theimagingsource.com/
+
+In USA: http://www.theimagingsource.com/
 - DFG/LC1
 
 www.sknet-web.co.jp
@@ -1681,10 +1707,12 @@ Models:
 
 - DST Card/DST-IP (bt878, twinhan asic) VP-1020
   - Sold as:
+
     - KWorld DVBS Satellite TV-Card
     - Powercolor DSTV Satellite Tuner Card
     - Prolink Pixelview DTV2000
     - Provideo PV-911 Digital Satellite TV Tuner Card With Common Interface ?
+
 - DST-CI Card (DVB Satellite) VP-1030
 - DCT Card (DVB cable)
 
@@ -1756,7 +1784,7 @@ Arowana
 
 TV-Karte / Poso Power TV (?) = Zoltrix VP-8482 (?)
 
-iTVC15 boards:
+iTVC15 boards
 ~~~~~~~~~~~~~
 
 kuroutoshikou.com ITVC15
@@ -1796,8 +1824,10 @@ Chips used at bttv devices
   - Hauppauge Win/TV pci (version 405):
 
     - Microchip 24LC02B or Philips 8582E2Y:
+
        - 256 Byte EEPROM with configuration information
        - I2C 0xa0-0xa1, (24LC02B also responds to 0xa2-0xaf)
+
     - Philips SAA5246AGP/E: Videotext decoder chip, I2C 0x22-0x23
 
     - TDA9800: sound decoder
@@ -1827,8 +1857,11 @@ Chips used at bttv devices
 
 Specs
 -----
+
 Philips		http://www.Semiconductors.COM/pip/
+
 Conexant	http://www.conexant.com/
+
 Micronas	http://www.micronas.com/en/home/index.html
 
 Thanks
@@ -1873,6 +1906,7 @@ Gerd Hoffmann
   Radio card (ITT sound processor)
 
 bigfoot <bigfoot@net-way.net>
+
 Ragnar Hojland Espinosa <ragnar@macula.net>
   ConferenceTV card
 
diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index 8a026455b09c..6cb19b24271e 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -22,6 +22,7 @@ License".
 	fourcc
 	v4l-with-ir
 	cardlist
+	bttv
 	cafe_ccic
 	cpia2
 	cx18
-- 
2.7.4


