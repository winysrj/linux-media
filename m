Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60533 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbcGQRHR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 13:07:17 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 07/15] [media] doc-rst: Convert contributors list to ReST
Date: Sun, 17 Jul 2016 14:07:02 -0300
Message-Id: <dee74db3d1c6fccba5738e141d1dff76140d177b.1468775054.git.mchehab@s-opensource.com>
In-Reply-To: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
References: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
References: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The contributors list needs some adjustments to be properly
formatted.

Also, this list has not been updated for a while. So, add a
notice about that.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/dvb-drivers/contributors.rst | 169 ++++++++++++++---------
 Documentation/media/dvb-drivers/index.rst        |   1 +
 2 files changed, 102 insertions(+), 68 deletions(-)

diff --git a/Documentation/media/dvb-drivers/contributors.rst b/Documentation/media/dvb-drivers/contributors.rst
index 731a009723c7..5949753008ae 100644
--- a/Documentation/media/dvb-drivers/contributors.rst
+++ b/Documentation/media/dvb-drivers/contributors.rst
@@ -1,96 +1,129 @@
+Contributors
+============
+
+.. note::
+
+   This documentation is outdated. There are several other DVB contributors
+   that aren't listed below.
+
 Thanks go to the following people for patches and contributions:
 
-Michael Hunold <m.hunold@gmx.de>
-  for the initial saa7146 driver and its recent overhaul
+- Michael Hunold <m.hunold@gmx.de>
 
-Christian Theiss
-  for his work on the initial Linux DVB driver
+  - for the initial saa7146 driver and its recent overhaul
 
-Marcus Metzler <mocm@metzlerbros.de>
-Ralph Metzler <rjkm@metzlerbros.de>
-  for their continuing work on the DVB driver
+- Christian Theiss
 
-Michael Holzt <kju@debian.org>
-  for his contributions to the dvb-net driver
+  - for his work on the initial Linux DVB driver
 
-Diego Picciani <d.picciani@novacomp.it>
-  for CyberLogin for Linux which allows logging onto EON
-  (in case you are wondering where CyberLogin is, EON changed its login
-  procedure and CyberLogin is no longer used.)
+- Marcus Metzler <mocm@metzlerbros.de> and
+  Ralph Metzler <rjkm@metzlerbros.de>
 
-Martin Schaller <martin@smurf.franken.de>
-  for patching the cable card decoder driver
+  - for their continuing work on the DVB driver
 
-Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
-  for various fixes regarding tuning, OSD and CI stuff and his work on VDR
+- Michael Holzt <kju@debian.org>
 
-Steve Brown <sbrown@cortland.com>
-  for his AFC kernel thread
+  - for his contributions to the dvb-net driver
 
-Christoph Martin <martin@uni-mainz.de>
-  for his LIRC infrared handler
+- Diego Picciani <d.picciani@novacomp.it>
 
-Andreas Oberritter <obi@linuxtv.org>
-Dennis Noermann <dennis.noermann@noernet.de>
-Felix Domke <tmbinc@elitedvb.net>
-Florian Schirmer <jolt@tuxbox.org>
-Ronny Strutz <3des@elitedvb.de>
-Wolfram Joost <dbox2@frokaschwei.de>
-...and all the other dbox2 people
-  for many bugfixes in the generic DVB Core, frontend drivers and
-  their work on the dbox2 port of the DVB driver
+  - for CyberLogin for Linux which allows logging onto EON
+    (in case you are wondering where CyberLogin is, EON changed its login
+    procedure and CyberLogin is no longer used.)
 
-Oliver Endriss <o.endriss@gmx.de>
-  for many bugfixes
+- Martin Schaller <martin@smurf.franken.de>
 
-Andrew de Quincey <adq_dvb@lidskialf.net>
-  for the tda1004x frontend driver, and various bugfixes
+  - for patching the cable card decoder driver
 
-Peter Schildmann <peter.schildmann@web.de>
-  for the driver for the Technisat SkyStar2 PCI DVB card
+- Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
 
-Vadim Catana <skystar@moldova.cc>
-Roberto Ragusa <r.ragusa@libero.it>
-Augusto Cardoso <augusto@carhil.net>
-  for all the work for the FlexCopII chipset by B2C2,Inc.
+  - for various fixes regarding tuning, OSD and CI stuff and his work on VDR
 
-Davor Emard <emard@softhome.net>
-  for his work on the budget drivers, the demux code,
-  the module unloading problems, ...
+- Steve Brown <sbrown@cortland.com>
 
-Hans-Frieder Vogt <hfvogt@arcor.de>
-  for his work on calculating and checking the crc's for the
-  TechnoTrend/Hauppauge DEC driver firmware
+  - for his AFC kernel thread
 
-Michael Dreher <michael@5dot1.de>
-Andreas 'randy' Weinberger
-  for the support of the Fujitsu-Siemens Activy budget DVB-S
+- Christoph Martin <martin@uni-mainz.de>
 
-Kenneth Aafløy <ke-aa@frisurf.no>
-  for adding support for Typhoon DVB-S budget card
+  - for his LIRC infrared handler
 
-Ernst Peinlich <e.peinlich@inode.at>
-  for tuning/DiSEqC support for the DEC 3000-s
+- Andreas Oberritter <obi@linuxtv.org>,
+  Dennis Noermann <dennis.noermann@noernet.de>,
+  Felix Domke <tmbinc@elitedvb.net>,
+  Florian Schirmer <jolt@tuxbox.org>,
+  Ronny Strutz <3des@elitedvb.de>,
+  Wolfram Joost <dbox2@frokaschwei.de>
+  and all the other dbox2 people
 
-Peter Beutner <p.beutner@gmx.net>
-  for the IR code for the ttusb-dec driver
+  - for many bugfixes in the generic DVB Core, frontend drivers and
+    their work on the dbox2 port of the DVB driver
 
-Wilson Michaels <wilsonmichaels@earthlink.net>
-  for the lgdt330x frontend driver, and various bugfixes
+- Oliver Endriss <o.endriss@gmx.de>
 
-Michael Krufky <mkrufky@linuxtv.org>
-  for maintaining v4l/dvb inter-tree dependencies
+  - for many bugfixes
 
-Taylor Jacob <rtjacob@earthlink.net>
-  for the nxt2002 frontend driver
+- Andrew de Quincey <adq_dvb@lidskialf.net>
 
-Jean-Francois Thibert <jeanfrancois@sagetv.com>
-  for the nxt2004 frontend driver
+  - for the tda1004x frontend driver, and various bugfixes
 
-Kirk Lapray <kirk.lapray@gmail.com>
-  for the or51211 and or51132 frontend drivers, and
-  for merging the nxt2002 and nxt2004 modules into a
-  single nxt200x frontend driver.
+- Peter Schildmann <peter.schildmann@web.de>
+
+  - for the driver for the Technisat SkyStar2 PCI DVB card
+
+- Vadim Catana <skystar@moldova.cc>,
+  Roberto Ragusa <r.ragusa@libero.it> and
+  Augusto Cardoso <augusto@carhil.net>
+
+  - for all the work for the FlexCopII chipset by B2C2,Inc.
+
+- Davor Emard <emard@softhome.net>
+
+  - for his work on the budget drivers, the demux code,
+    the module unloading problems, ...
+
+- Hans-Frieder Vogt <hfvogt@arcor.de>
+
+  - for his work on calculating and checking the crc's for the
+    TechnoTrend/Hauppauge DEC driver firmware
+
+- Michael Dreher <michael@5dot1.de> and
+  Andreas 'randy' Weinberger
+
+  - for the support of the Fujitsu-Siemens Activy budget DVB-S
+
+- Kenneth Aafløy <ke-aa@frisurf.no>
+
+  - for adding support for Typhoon DVB-S budget card
+
+- Ernst Peinlich <e.peinlich@inode.at>
+
+  - for tuning/DiSEqC support for the DEC 3000-s
+
+- Peter Beutner <p.beutner@gmx.net>
+
+  - for the IR code for the ttusb-dec driver
+
+- Wilson Michaels <wilsonmichaels@earthlink.net>
+
+  - for the lgdt330x frontend driver, and various bugfixes
+
+- Michael Krufky <mkrufky@linuxtv.org>
+
+  - for maintaining v4l/dvb inter-tree dependencies
+
+- Taylor Jacob <rtjacob@earthlink.net>
+
+  - for the nxt2002 frontend driver
+
+- Jean-Francois Thibert <jeanfrancois@sagetv.com>
+
+  - for the nxt2004 frontend driver
+
+- Kirk Lapray <kirk.lapray@gmail.com>
+
+  - for the or51211 and or51132 frontend drivers, and
+    for merging the nxt2002 and nxt2004 modules into a
+    single nxt200x frontend driver.
 
 (If you think you should be in this list, but you are not, drop a
- line to the DVB mailing list)
+line to the DVB mailing list)
diff --git a/Documentation/media/dvb-drivers/index.rst b/Documentation/media/dvb-drivers/index.rst
index c8e5a742e351..fa553263e5cf 100644
--- a/Documentation/media/dvb-drivers/index.rst
+++ b/Documentation/media/dvb-drivers/index.rst
@@ -23,3 +23,4 @@ License".
 	bt8xx
 	cards
 	ci
+	contributors
-- 
2.7.4

