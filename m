Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab2IOVRR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 17:17:17 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8FLHGmX025634
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 15 Sep 2012 17:17:16 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] MAINTAINERS: fix the path for the media drivers that got renamed
Date: Sat, 15 Sep 2012 18:17:13 -0300
Message-Id: <1347743833-32689-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1347743833-32689-1-git-send-email-mchehab@redhat.com>
References: <1347743833-32689-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the media tree path renaming, several drivers change their
location. Update MAINTAINERS accordingly.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 MAINTAINERS | 43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ada8f05..0750c24 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1073,7 +1073,7 @@ L:	linux-media@vger.kernel.org
 S:	Maintained
 F:	arch/arm/plat-s5p/dev-fimc*
 F:	arch/arm/plat-samsung/include/plat/*fimc*
-F:	drivers/media/video/s5p-fimc/
+F:	drivers/media/platform/s5p-fimc/
 
 ARM/SAMSUNG S5P SERIES Multi Format Codec (MFC) SUPPORT
 M:	Kyungmin Park <kyungmin.park@samsung.com>
@@ -1083,7 +1083,7 @@ L:	linux-arm-kernel@lists.infradead.org
 L:	linux-media@vger.kernel.org
 S:	Maintained
 F:	arch/arm/plat-s5p/dev-mfc.c
-F:	drivers/media/video/s5p-mfc/
+F:	drivers/media/platform/s5p-mfc/
 
 ARM/SAMSUNG S5P SERIES TV SUBSYSTEM SUPPORT
 M:	Kyungmin Park <kyungmin.park@samsung.com>
@@ -1091,7 +1091,7 @@ M:	Tomasz Stanislawski <t.stanislaws@samsung.com>
 L:	linux-arm-kernel@lists.infradead.org
 L:	linux-media@vger.kernel.org
 S:	Maintained
-F:	drivers/media/video/s5p-tv/
+F:	drivers/media/platform/s5p-tv/
 
 ARM/SHMOBILE ARM ARCHITECTURE
 M:	Paul Mundt <lethal@linux-sh.org>
@@ -1357,7 +1357,7 @@ ATMEL ISI DRIVER
 M:	Josh Wu <josh.wu@atmel.com>
 L:	linux-media@vger.kernel.org
 S:	Supported
-F:	drivers/media/video/atmel-isi.c
+F:	drivers/media/platform/atmel-isi.c
 F:	include/media/atmel-isi.h
 
 ATMEL LCDFB DRIVER
@@ -1695,7 +1695,7 @@ W:	http://linuxtv.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 S:	Maintained
 F:	Documentation/video4linux/bttv/
-F:	drivers/media/video/bt8xx/bttv*
+F:	drivers/media/pci/bt8xx/bttv*
 
 C-MEDIA CMI8788 DRIVER
 M:	Clemens Ladisch <clemens@ladisch.de>
@@ -1725,7 +1725,7 @@ L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 S:	Maintained
 F:	Documentation/video4linux/cafe_ccic
-F:	drivers/media/video/marvell-ccic/
+F:	drivers/media/platform/marvell-ccic/
 
 CAIF NETWORK LAYER
 M:	Sjur Braendeland <sjur.brandeland@stericsson.com>
@@ -2114,7 +2114,7 @@ W:	http://linuxtv.org
 W:	http://www.ivtvdriver.org/index.php/Cx18
 S:	Maintained
 F:	Documentation/video4linux/cx18.txt
-F:	drivers/media/video/cx18/
+F:	drivers/media/pci/cx18/
 
 CXGB3 ETHERNET DRIVER (CXGB3)
 M:	Divy Le Ray <divy@chelsio.com>
@@ -3007,7 +3007,7 @@ M:	Kyungmin Park <kyungmin.park@samsung.com>
 M:	Heungjun Kim <riverful.kim@samsung.com>
 L:	linux-media@vger.kernel.org
 S:	Maintained
-F:	drivers/media/video/m5mols/
+F:	drivers/media/i2c/m5mols/
 F:	include/media/m5mols.h
 
 FUJITSU TABLET EXTRAS
@@ -3865,7 +3865,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 W:	http://www.ivtvdriver.org
 S:	Maintained
 F:	Documentation/video4linux/*.ivtv
-F:	drivers/media/video/ivtv/
+F:	drivers/media/pci/ivtv/
 F:	include/linux/ivtv*
 
 JC42.4 TEMPERATURE SENSOR DRIVER
@@ -4561,7 +4561,7 @@ MOTION EYE VAIO PICTUREBOOK CAMERA DRIVER
 W:	http://popies.net/meye/
 S:	Orphan
 F:	Documentation/video4linux/meye.txt
-F:	drivers/media/video/meye.*
+F:	drivers/media/pci/meye/
 F:	include/linux/meye.h
 
 MOTOROLA IMX MMC/SD HOST CONTROLLER INTERFACE DRIVER
@@ -4964,7 +4964,7 @@ OMAP IMAGE SIGNAL PROCESSOR (ISP)
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 L:	linux-media@vger.kernel.org
 S:	Maintained
-F:	drivers/media/video/omap3isp/*
+F:	drivers/media/platform/omap3isp/
 
 OMAP USB SUPPORT
 M:	Felipe Balbi <balbi@ti.com>
@@ -5005,7 +5005,7 @@ M:	Jonathan Corbet <corbet@lwn.net>
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 S:	Maintained
-F:	drivers/media/video/ov7670.c
+F:	drivers/media/i2c/ov7670.c
 
 ONENAND FLASH DRIVER
 M:	Kyungmin Park <kyungmin.park@samsung.com>
@@ -5898,9 +5898,9 @@ L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 W:	http://www.mihu.de/linux/saa7146
 S:	Maintained
-F:	drivers/media/common/saa7146*
-F:	drivers/media/video/*7146*
-F:	include/media/*7146*
+F:	drivers/media/common/saa7146/
+F:	drivers/media/pci/saa7146/
+F:	include/media/saa7146*
 
 SAMSUNG LAPTOP DRIVER
 M:	Corentin Chary <corentincj@iksaif.net>
@@ -6349,8 +6349,9 @@ M:	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 S:	Maintained
-F:	include/media/v4l2*
-F:	drivers/media/video/v4l2*
+F:	include/media/soc*
+F:	drivers/media/i2c/soc_camera/
+F:	drivers/media/platform/soc_camera/
 
 SOEKRIS NET48XX LED SUPPORT
 M:	Chris Boot <bootc@bootc.net>
@@ -7130,7 +7131,6 @@ S:	Maintained
 F:	Documentation/usb/ehci.txt
 F:	drivers/usb/host/ehci*
 
-
 USB GADGET/PERIPHERAL SUBSYSTEM
 M:	Felipe Balbi <balbi@ti.com>
 L:	linux-usb@vger.kernel.org
@@ -7337,7 +7337,6 @@ W:	http://www.ideasonboard.org/uvc/
 S:	Maintained
 F:	drivers/media/usb/uvc/
 
-
 USB WIRELESS RNDIS DRIVER (rndis_wlan)
 M:	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
 L:	linux-wireless@vger.kernel.org
@@ -7365,7 +7364,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 W:	http://royale.zerezo.com/zr364xx/
 S:	Maintained
 F:	Documentation/video4linux/zr364xx.txt
-F:	drivers/media/usb/zr364xx.c
+F:	drivers/media/usb/zr364xx/
 
 USER-MODE LINUX (UML)
 M:	Jeff Dike <jdike@addtoit.com>
@@ -7423,7 +7422,7 @@ M:	Marek Szyprowski <m.szyprowski@samsung.com>
 M:	Kyungmin Park <kyungmin.park@samsung.com>
 L:	linux-media@vger.kernel.org
 S:	Maintained
-F:	drivers/media/video/videobuf2-*
+F:	drivers/media/v4l2-core/videobuf2-*
 F:	include/media/videobuf2-*
 
 VIRTIO CONSOLE DRIVER
@@ -7825,7 +7824,7 @@ L:	linux-media@vger.kernel.org
 W:	http://mjpeg.sourceforge.net/driver-zoran/
 T:	Mercurial http://linuxtv.org/hg/v4l-dvb
 S:	Odd Fixes
-F:	drivers/media/video/zoran/
+F:	drivers/media/pci/zoran/
 
 ZS DECSTATION Z85C30 SERIAL DRIVER
 M:	"Maciej W. Rozycki" <macro@linux-mips.org>
-- 
1.7.11.4

