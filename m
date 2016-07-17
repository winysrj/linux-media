Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60565 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbcGQRHZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 13:07:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 05/15] [media] doc-rst: convert cards to rst format
Date: Sun, 17 Jul 2016 14:07:00 -0300
Message-Id: <986fd9a9ed36645ed87c531f71286d286159430f.1468775054.git.mchehab@s-opensource.com>
In-Reply-To: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
References: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
In-Reply-To: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
References: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This file is using a markup-like language, but it is not quite
ReST. Convert it, and add a note pointing to the Wiki page with
the known supported hardware devices.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/dvb-drivers/cards.rst | 71 ++++++++++++++++++++-----------
 Documentation/media/dvb-drivers/index.rst |  1 +
 2 files changed, 47 insertions(+), 25 deletions(-)

diff --git a/Documentation/media/dvb-drivers/cards.rst b/Documentation/media/dvb-drivers/cards.rst
index 97709e9a3076..177cbeb2b561 100644
--- a/Documentation/media/dvb-drivers/cards.rst
+++ b/Documentation/media/dvb-drivers/cards.rst
@@ -1,23 +1,36 @@
 Hardware supported by the linuxtv.org DVB drivers
 =================================================
 
-  Generally, the DVB hardware manufacturers frequently change the
-  frontends (i.e. tuner / demodulator units) used, usually without
-  changing the product name, revision number or specs. Some cards
-  are also available in versions with different frontends for
-  DVB-S/DVB-C/DVB-T. Thus the frontend drivers are listed separately.
+.. note::
 
-  Note 1: There is no guarantee that every frontend driver works
-  out of the box with every card, because of different wiring.
+   This documentation is outdated. Please check at the DVB wiki
+   at https://linuxtv.org/wiki for more updated info.
 
-  Note 2: The demodulator chips can be used with a variety of
-  tuner/PLL chips, and not all combinations are supported. Often
-  the demodulator and tuner/PLL chip are inside a metal box for
-  shielding, and the whole metal box has its own part number.
+   Please look at
+   https://linuxtv.org/wiki/index.php/Hardware_Device_Information
+   for an updated list of supported cards.
 
+Generally, the DVB hardware manufacturers frequently change the
+frontends (i.e. tuner / demodulator units) used, usually without
+changing the product name, revision number or specs. Some cards
+are also available in versions with different frontends for
+DVB-S/DVB-C/DVB-T. Thus the frontend drivers are listed separately.
+
+.. note::
+
+  #) There is no guarantee that every frontend driver works
+     out of the box with every card, because of different wiring.
+
+  #) The demodulator chips can be used with a variety of
+     tuner/PLL chips, and not all combinations are supported. Often
+     the demodulator and tuner/PLL chip are inside a metal box for
+     shielding, and the whole metal box has its own part number.
+
+
+- Frontends drivers:
 
-o Frontends drivers:
   - dvb_dummy_fe: for testing...
+
   DVB-S:
    - ves1x93		: Alps BSRV2 (ves1893 demodulator) and dbox2 (ves1993)
    - cx24110		: Conexant HM1221/HM1811 (cx24110 or cx24106 demod, cx24108 PLL)
@@ -26,21 +39,23 @@ o Frontends drivers:
    - stv0299		: Alps BSRU6 (tsa5059 PLL), LG TDQB-S00x (tsa5059 PLL),
 			  LG TDQF-S001F (sl1935 PLL), Philips SU1278 (tua6100 PLL),
 			  Philips SU1278SH (tsa5059 PLL), Samsung TBMU24112IMB, Technisat Sky2Pc with bios Rev. 2.6
+
   DVB-C:
    - ves1820		: various (ves1820 demodulator, sp5659c or spXXXX PLL)
    - at76c651		: Atmel AT76c651(B) with DAT7021 PLL
+
   DVB-T:
    - alps_tdlb7		: Alps TDLB7 (sp8870 demodulator, sp5659 PLL)
    - alps_tdmb7		: Alps TDMB7 (cx22700 demodulator)
    - grundig_29504-401	: Grundig 29504-401 (LSI L64781 demodulator), tsa5060 PLL
    - tda1004x		: Philips tda10045h (td1344 or tdm1316l PLL)
-   - nxt6000 		: Alps TDME7 (MITEL SP5659 PLL), Alps TDED4 (TI ALP510 PLL),
-			  Comtech DVBT-6k07 (SP5730 PLL)
-			  (NxtWave Communications NXT6000 demodulator)
+   - nxt6000 		: Alps TDME7 (MITEL SP5659 PLL), Alps TDED4 (TI ALP510 PLL), Comtech DVBT-6k07 (SP5730 PLL), (NxtWave Communications NXT6000 demodulator)
    - sp887x		: Microtune 7202D
    - dib3000mb	: DiBcom 3000-MB demodulator
+
   DVB-S/C/T:
    - dst		: TwinHan DST Frontend
+
   ATSC:
    - nxt200x		: Nxtwave NXT2002 & NXT2004
    - or51211		: or51211 based (pcHDTV HD2000 card)
@@ -49,10 +64,10 @@ o Frontends drivers:
    - lgdt330x		: LG Electronics DT3302 & DT3303
 
 
-o Cards based on the Phillips saa7146 multimedia PCI bridge chip:
+- Cards based on the Phillips saa7146 multimedia PCI bridge chip:
+
   - TI AV7110 based cards (i.e. with hardware MPEG decoder):
-    - Siemens/Technotrend/Hauppauge PCI DVB card revision 1.1, 1.3, 1.5, 1.6, 2.1
-      (aka Hauppauge Nexus)
+    - Siemens/Technotrend/Hauppauge PCI DVB card revision 1.1, 1.3, 1.5, 1.6, 2.1 (aka Hauppauge Nexus)
   - "budget" cards (i.e. without hardware MPEG decoder):
     - Technotrend Budget / Hauppauge WinTV-Nova PCI Cards
     - SATELCO Multimedia PCI
@@ -60,10 +75,12 @@ o Cards based on the Phillips saa7146 multimedia PCI bridge chip:
     - Typhoon DVB-S budget
     - Fujitsu-Siemens Activy DVB-S budget card
 
-o Cards based on the B2C2 Inc. FlexCopII/IIb/III:
+- Cards based on the B2C2 Inc. FlexCopII/IIb/III:
+
   - Technisat SkyStar2 PCI DVB card revision 2.3, 2.6B, 2.6C
 
-o Cards based on the Conexant Bt8xx PCI bridge:
+- Cards based on the Conexant Bt8xx PCI bridge:
+
   - Pinnacle PCTV Sat DVB
   - Nebula Electronics DigiTV
   - TwinHan DST
@@ -73,11 +90,13 @@ o Cards based on the Conexant Bt8xx PCI bridge:
   - DViCO FusionHDTV DVB-T Lite
   - DViCO FusionHDTV5 Lite
 
-o Technotrend / Hauppauge DVB USB devices:
+- Technotrend / Hauppauge DVB USB devices:
+
   - Nova USB
   - DEC 2000-T, 3000-S, 2540-T
 
-o DiBcom DVB-T USB based devices:
+- DiBcom DVB-T USB based devices:
+
   - Twinhan VisionPlus VisionDTV USB-Ter DVB-T Device
   - HAMA DVB-T USB device
   - CTS Portable (Chinese Television System)
@@ -92,9 +111,10 @@ o DiBcom DVB-T USB based devices:
   - Yakumo DVB-T mobile USB2.0
   - DiBcom USB2.0 DVB-T reference device (non-public)
 
-o Experimental support for the analog module of the Siemens DVB-C PCI card
+- Experimental support for the analog module of the Siemens DVB-C PCI card
+
+- Cards based on the Conexant cx2388x PCI bridge:
 
-o Cards based on the Conexant cx2388x PCI bridge:
   - ADS Tech Instant TV DVB-T PCI
   - ATI HDTV Wonder
   - digitalnow DNTV Live! DVB-T
@@ -109,7 +129,8 @@ o Cards based on the Conexant cx2388x PCI bridge:
   - TerraTec Cinergy 1400 DVB-T
   - WinFast DTV1000-T
 
-o Cards based on the Phillips saa7134 PCI bridge:
+- Cards based on the Phillips saa7134 PCI bridge:
+
   - Medion 7134
   - Pinnacle PCTV 300i DVB-T + PAL
   - LifeView FlyDVB-T DUO
diff --git a/Documentation/media/dvb-drivers/index.rst b/Documentation/media/dvb-drivers/index.rst
index bcc29c70a7cc..b5b39d637a17 100644
--- a/Documentation/media/dvb-drivers/index.rst
+++ b/Documentation/media/dvb-drivers/index.rst
@@ -21,3 +21,4 @@ License".
 	intro
 	avermedia
 	bt8xx
+	cards
-- 
2.7.4

