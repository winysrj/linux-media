Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41229 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaKURuW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Nov 2014 12:50:22 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] MAINTAINERS: Update mchehab's addresses
Date: Fri, 21 Nov 2014 15:50:11 -0200
Message-Id: <1416592211-22287-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm using the new Open Source Group address for my upstream work.
While the other email is still valid, it is better for me to receive
patches via the new address.

So, replace it everywhere inside MAINTAINERS.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 MAINTAINERS | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5af7cb642c41..629c5b127292 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1827,7 +1827,7 @@ F:	include/net/ax25.h
 F:	net/ax25/
 
 AZ6007 DVB DRIVER
-M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
@@ -2196,7 +2196,7 @@ F:	Documentation/filesystems/btrfs.txt
 F:	fs/btrfs/
 
 BTTV VIDEO4LINUX DRIVER
-M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
@@ -2717,7 +2717,7 @@ F:	drivers/media/common/cx2341x*
 F:	include/media/cx2341x*
 
 CX88 VIDEO4LINUX DRIVER
-M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
@@ -3386,7 +3386,7 @@ F:	fs/ecryptfs/
 EDAC-CORE
 M:	Doug Thompson <dougthompson@xmission.com>
 M:	Borislav Petkov <bp@alien8.de>
-M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
 S:	Supported
@@ -3435,7 +3435,7 @@ S:	Maintained
 F:	drivers/edac/e7xxx_edac.c
 
 EDAC-GHES
-M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
 S:	Maintained
@@ -3463,21 +3463,21 @@ S:	Maintained
 F:	drivers/edac/i5000_edac.c
 
 EDAC-I5400
-M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
 S:	Maintained
 F:	drivers/edac/i5400_edac.c
 
 EDAC-I7300
-M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
 S:	Maintained
 F:	drivers/edac/i7300_edac.c
 
 EDAC-I7CORE
-M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
 S:	Maintained
@@ -3520,7 +3520,7 @@ S:	Maintained
 F:	drivers/edac/r82600_edac.c
 
 EDAC-SBRIDGE
-M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
 S:	Maintained
@@ -3580,7 +3580,7 @@ S:	Maintained
 F:	drivers/net/ethernet/ibm/ehea/
 
 EM28XX VIDEO4LINUX DRIVER
-M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
@@ -5941,7 +5941,7 @@ S:	Maintained
 F:	drivers/media/radio/radio-maxiradio*
 
 MEDIA INPUT INFRASTRUCTURE (V4L/DVB)
-M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 P:	LinuxTV.org Project
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
@@ -7970,7 +7970,7 @@ S:	Odd Fixes
 F:	drivers/media/i2c/saa6588*
 
 SAA7134 VIDEO4LINUX DRIVER
-M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
@@ -8428,7 +8428,7 @@ S:	Maintained
 F:	drivers/media/radio/si4713/radio-usb-si4713.c
 
 SIANO DVB DRIVER
-M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
@@ -9117,7 +9117,7 @@ S:	Maintained
 F:	drivers/media/i2c/tda9840*
 
 TEA5761 TUNER DRIVER
-M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
@@ -9125,7 +9125,7 @@ S:	Odd fixes
 F:	drivers/media/tuners/tea5761.*
 
 TEA5767 TUNER DRIVER
-M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
@@ -9437,7 +9437,7 @@ F:	include/linux/shmem_fs.h
 F:	mm/shmem.c
 
 TM6000 VIDEO4LINUX DRIVER
-M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
@@ -10264,7 +10264,7 @@ S:	Maintained
 F:	arch/x86/kernel/cpu/mcheck/*
 
 XC2028/3028 TUNER DRIVER
-M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
-- 
1.9.3

