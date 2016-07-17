Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60543 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbcGQRHQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 13:07:16 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 10/15] [media] doc-rst: Convert lmedm04 to rst format
Date: Sun, 17 Jul 2016 14:07:05 -0300
Message-Id: <683ac0ea8ee1b511d54d719f508ad22a9a2b0063.1468775054.git.mchehab@s-opensource.com>
In-Reply-To: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
References: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
In-Reply-To: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
References: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This file was missing a name for the index, and weren't
using any markup language. Make it looks better and
convert to ReST.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/dvb-drivers/index.rst   |  1 +
 Documentation/media/dvb-drivers/lmedm04.rst | 72 +++++++++++++++++++----------
 2 files changed, 49 insertions(+), 24 deletions(-)

diff --git a/Documentation/media/dvb-drivers/index.rst b/Documentation/media/dvb-drivers/index.rst
index 12e0d4b16baa..06463c5f2ce6 100644
--- a/Documentation/media/dvb-drivers/index.rst
+++ b/Documentation/media/dvb-drivers/index.rst
@@ -25,4 +25,5 @@ License".
 	ci
 	dvb-usb
 	faq
+	lmedm04
 	contributors
diff --git a/Documentation/media/dvb-drivers/lmedm04.rst b/Documentation/media/dvb-drivers/lmedm04.rst
index f4b720a14675..e8913d4481a0 100644
--- a/Documentation/media/dvb-drivers/lmedm04.rst
+++ b/Documentation/media/dvb-drivers/lmedm04.rst
@@ -1,7 +1,10 @@
+Firmware files for lmedm04 cards
+================================
+
 To extract firmware for the DM04/QQBOX you need to copy the
 following file(s) to this directory.
 
-for DM04+/QQBOX LME2510C (Sharp 7395 Tuner)
+For DM04+/QQBOX LME2510C (Sharp 7395 Tuner)
 -------------------------------------------
 
 The Sharp 7395 driver can be found in windows/system32/drivers
@@ -9,38 +12,43 @@ The Sharp 7395 driver can be found in windows/system32/drivers
 US2A0D.sys (dated 17 Mar 2009)
 
 
-and run
-./get_dvb_firmware lme2510c_s7395
+and run:
 
-	will produce
-	dvb-usb-lme2510c-s7395.fw
+.. code-block:: none
+
+	scripts/get_dvb_firmware lme2510c_s7395
+
+will produce dvb-usb-lme2510c-s7395.fw
 
 An alternative but older firmware can be found on the driver
 disk DVB-S_EN_3.5A in BDADriver/driver
 
 LMEBDA_DVBS7395C.sys (dated 18 Jan 2008)
 
-and run
-./get_dvb_firmware lme2510c_s7395_old
+and run:
 
-	will produce
-	dvb-usb-lme2510c-s7395.fw
+.. code-block:: none
 
---------------------------------------------------------------------
+	./get_dvb_firmware lme2510c_s7395_old
+
+will produce dvb-usb-lme2510c-s7395.fw
 
 The LG firmware can be found on the driver
 disk DM04+_5.1A[LG] in BDADriver/driver
 
-for DM04 LME2510 (LG Tuner)
+For DM04 LME2510 (LG Tuner)
 ---------------------------
 
 LMEBDA_DVBS.sys (dated 13 Nov 2007)
 
-and run
-./get_dvb_firmware lme2510_lg
+and run:
 
-	will produce
-	dvb-usb-lme2510-lg.fw
+
+.. code-block:: none
+
+	./get_dvb_firmware lme2510_lg
+
+will produce dvb-usb-lme2510-lg.fw
 
 
 Other LG firmware can be extracted manually from US280D.sys
@@ -48,34 +56,50 @@ only found in windows/system32/drivers
 
 dd if=US280D.sys ibs=1 skip=42360 count=3924 of=dvb-usb-lme2510-lg.fw
 
-for DM04 LME2510C (LG Tuner)
----------------------------
+For DM04 LME2510C (LG Tuner)
+----------------------------
 
-dd if=US280D.sys ibs=1 skip=35200 count=3850 of=dvb-usb-lme2510c-lg.fw
+.. code-block:: none
+
+	dd if=US280D.sys ibs=1 skip=35200 count=3850 of=dvb-usb-lme2510c-lg.fw
 
----------------------------------------------------------------------
 
 The Sharp 0194 tuner driver can be found in windows/system32/drivers
 
 US290D.sys (dated 09 Apr 2009)
 
 For LME2510
-dd if=US290D.sys ibs=1 skip=36856 count=3976 of=dvb-usb-lme2510-s0194.fw
+-----------
+
+.. code-block:: none
+
+	dd if=US290D.sys ibs=1 skip=36856 count=3976 of=dvb-usb-lme2510-s0194.fw
 
 
 For LME2510C
-dd if=US290D.sys ibs=1 skip=33152 count=3697 of=dvb-usb-lme2510c-s0194.fw
+------------
+
+
+.. code-block:: none
+
+	dd if=US290D.sys ibs=1 skip=33152 count=3697 of=dvb-usb-lme2510c-s0194.fw
 
----------------------------------------------------------------------
 
 The m88rs2000 tuner driver can be found in windows/system32/drivers
 
 US2B0D.sys (dated 29 Jun 2010)
 
-dd if=US2B0D.sys ibs=1 skip=34432 count=3871 of=dvb-usb-lme2510c-rs2000.fw
+
+.. code-block:: none
+
+	dd if=US2B0D.sys ibs=1 skip=34432 count=3871 of=dvb-usb-lme2510c-rs2000.fw
 
 We need to modify id of rs2000 firmware or it will warm boot id 3344:1120.
 
-echo -ne \\xF0\\x22 | dd conv=notrunc bs=1 count=2 seek=266 of=dvb-usb-lme2510c-rs2000.fw
+
+.. code-block:: none
+
+
+	echo -ne \\xF0\\x22 | dd conv=notrunc bs=1 count=2 seek=266 of=dvb-usb-lme2510c-rs2000.fw
 
 Copy the firmware file(s) to /lib/firmware
-- 
2.7.4

