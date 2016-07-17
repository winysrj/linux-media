Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60548 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbcGQRHQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 13:07:16 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 12/15] [media] doc-rst: Convert technisat document to ReST
Date: Sun, 17 Jul 2016 14:07:07 -0300
Message-Id: <63dd837ec0d5ec0a5bf315ac8be71fc69c6d94f6.1468775054.git.mchehab@s-opensource.com>
In-Reply-To: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
References: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
In-Reply-To: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
References: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This document need some changes to be properly parsed by
Sphinx.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/dvb-drivers/index.rst     |   1 +
 Documentation/media/dvb-drivers/technisat.rst | 148 +++++++++++++++-----------
 2 files changed, 85 insertions(+), 64 deletions(-)

diff --git a/Documentation/media/dvb-drivers/index.rst b/Documentation/media/dvb-drivers/index.rst
index 0574c2e7e0ff..7db298f3c6ce 100644
--- a/Documentation/media/dvb-drivers/index.rst
+++ b/Documentation/media/dvb-drivers/index.rst
@@ -27,4 +27,5 @@ License".
 	faq
 	lmedm04
 	opera-firmware
+	technisat
 	contributors
diff --git a/Documentation/media/dvb-drivers/technisat.rst b/Documentation/media/dvb-drivers/technisat.rst
index f0cc4f2d8365..f80f4ecc1560 100644
--- a/Documentation/media/dvb-drivers/technisat.rst
+++ b/Documentation/media/dvb-drivers/technisat.rst
@@ -1,78 +1,98 @@
 How to set up the Technisat/B2C2 Flexcop devices
 ================================================
 
-1) Find out what device you have
-================================
+.. note::
+
+   This documentation is outdated.
+
+Author: Uwe Bugla <uwe.bugla@gmx.de> August 2009
+
+Find out what device you have
+-----------------------------
 
 Important Notice: The driver does NOT support Technisat USB 2 devices!
 
 First start your linux box with a shipped kernel:
-lspci -vvv for a PCI device (lsusb -vvv for an USB device) will show you for example:
-02:0b.0 Network controller: Techsan Electronics Co Ltd B2C2 FlexCopII DVB chip /
- Technisat SkyStar2 DVB card (rev 02)
 
-dmesg | grep frontend may show you for example:
-DVB: registering frontend 0 (Conexant CX24123/CX24109)...
+.. code-block:: none
 
-2) Kernel compilation:
-======================
+	lspci -vvv for a PCI device (lsusb -vvv for an USB device) will show you for example:
+	02:0b.0 Network controller: Techsan Electronics Co Ltd B2C2 FlexCopII DVB chip /
+	Technisat SkyStar2 DVB card (rev 02)
+
+	dmesg | grep frontend may show you for example:
+	DVB: registering frontend 0 (Conexant CX24123/CX24109)...
+
+Kernel compilation:
+-------------------
 
 If the Flexcop / Technisat is the only DVB / TV / Radio device in your box
- get rid of unnecessary modules and check this one:
-"Multimedia support" => "Customise analog and hybrid tuner modules to build"
+get rid of unnecessary modules and check this one:
+
+``Multimedia support`` => ``Customise analog and hybrid tuner modules to build``
+
 In this directory uncheck every driver which is activated there
- (except "Simple tuner support" for ATSC 3rd generation only -> see case 9 please).
+(except ``Simple tuner support`` for ATSC 3rd generation only -> see case 9 please).
 
 Then please activate:
-2a) Main module part:
-"Multimedia support" => "DVB/ATSC adapters"
- => "Technisat/B2C2 FlexcopII(b) and FlexCopIII adapters"
-
-a.) => "Technisat/B2C2 Air/Sky/Cable2PC PCI" (PCI card) or
-b.) => "Technisat/B2C2 Air/Sky/Cable2PC USB" (USB 1.1 adapter)
- and for troubleshooting purposes:
-c.) => "Enable debug for the B2C2 FlexCop drivers"
-
-2b) Frontend / Tuner / Demodulator module part:
-"Multimedia support" => "DVB/ATSC adapters"
- => "Customise the frontend modules to build" "Customise DVB frontends" =>
-
-1.) SkyStar DVB-S Revision 2.3:
-a.) => "Zarlink VP310/MT312/ZL10313 based"
-b.) => "Generic I2C PLL based tuners"
-
-2.) SkyStar DVB-S Revision 2.6:
-a.) => "ST STV0299 based"
-b.) => "Generic I2C PLL based tuners"
-
-3.) SkyStar DVB-S Revision 2.7:
-a.) => "Samsung S5H1420 based"
-b.) => "Integrant ITD1000 Zero IF tuner for DVB-S/DSS"
-c.) => "ISL6421 SEC controller"
-
-4.) SkyStar DVB-S Revision 2.8:
-a.) => "Conexant CX24123 based"
-b.) => "Conexant CX24113/CX24128 tuner for DVB-S/DSS"
-c.) => "ISL6421 SEC controller"
-
-5.) AirStar DVB-T card:
-a.) => "Zarlink MT352 based"
-b.) => "Generic I2C PLL based tuners"
-
-6.) CableStar DVB-C card:
-a.) => "ST STV0297 based"
-b.) => "Generic I2C PLL based tuners"
-
-7.) AirStar ATSC card 1st generation:
-a.) => "Broadcom BCM3510"
-
-8.) AirStar ATSC card 2nd generation:
-a.) => "NxtWave Communications NXT2002/NXT2004 based"
-b.) => "Generic I2C PLL based tuners"
-
-9.) AirStar ATSC card 3rd generation:
-a.) => "LG Electronics LGDT3302/LGDT3303 based"
-b.) "Multimedia support" => "Customise analog and hybrid tuner modules to build"
- => "Simple tuner support"
-
-Author: Uwe Bugla <uwe.bugla@gmx.de> August 2009
+
+- Main module part:
+
+  ``Multimedia support`` => ``DVB/ATSC adapters`` => ``Technisat/B2C2 FlexcopII(b) and FlexCopIII adapters``
+
+  #) => ``Technisat/B2C2 Air/Sky/Cable2PC PCI`` (PCI card) or
+  #) => ``Technisat/B2C2 Air/Sky/Cable2PC USB`` (USB 1.1 adapter)
+     and for troubleshooting purposes:
+  #) => ``Enable debug for the B2C2 FlexCop drivers``
+
+- Frontend / Tuner / Demodulator module part:
+
+  ``Multimedia support`` => ``DVB/ATSC adapters``
+   => ``Customise the frontend modules to build`` ``Customise DVB frontends`` =>
+
+  - SkyStar DVB-S Revision 2.3:
+
+    #) => ``Zarlink VP310/MT312/ZL10313 based``
+    #) => ``Generic I2C PLL based tuners``
+
+  - SkyStar DVB-S Revision 2.6:
+
+    #) => ``ST STV0299 based``
+    #) => ``Generic I2C PLL based tuners``
+
+  - SkyStar DVB-S Revision 2.7:
+
+    #) => ``Samsung S5H1420 based``
+    #) => ``Integrant ITD1000 Zero IF tuner for DVB-S/DSS``
+    #) => ``ISL6421 SEC controller``
+
+  - SkyStar DVB-S Revision 2.8:
+
+    #) => ``Conexant CX24123 based``
+    #) => ``Conexant CX24113/CX24128 tuner for DVB-S/DSS``
+    #) => ``ISL6421 SEC controller``
+
+  - AirStar DVB-T card:
+
+    #) => ``Zarlink MT352 based``
+    #) => ``Generic I2C PLL based tuners``
+
+  - CableStar DVB-C card:
+
+    #) => ``ST STV0297 based``
+    #) => ``Generic I2C PLL based tuners``
+
+  - AirStar ATSC card 1st generation:
+
+    #) => ``Broadcom BCM3510``
+
+  - AirStar ATSC card 2nd generation:
+
+    #) => ``NxtWave Communications NXT2002/NXT2004 based``
+    #) => ``Generic I2C PLL based tuners``
+
+  - AirStar ATSC card 3rd generation:
+
+    #) => ``LG Electronics LGDT3302/LGDT3303 based``
+    #) ``Multimedia support`` => ``Customise analog and hybrid tuner modules to build`` => ``Simple tuner support``
+
-- 
2.7.4

