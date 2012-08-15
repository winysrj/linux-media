Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928Ab2HONsZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 09:48:25 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7FDmPEO011276
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 15 Aug 2012 09:48:25 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 07/12] [media] move parallel port/isa video drivers to drivers/media/parport/
Date: Wed, 15 Aug 2012 10:48:15 -0300
Message-Id: <1345038500-28734-8-git-send-email-mchehab@redhat.com>
In-Reply-To: <1345038500-28734-1-git-send-email-mchehab@redhat.com>
References: <502AC079.50902@gmail.com>
 <1345038500-28734-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We should keep just the I2C drivers under drivers/media/video, and
then rename it to drivers/media/i2c.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/Kconfig                      |  1 +
 drivers/media/Makefile                     |  8 ++--
 drivers/media/parport/Kconfig              | 47 +++++++++++++++++++++++
 drivers/media/parport/Makefile             |  4 ++
 drivers/media/{video => parport}/bw-qcam.c |  0
 drivers/media/{video => parport}/c-qcam.c  |  0
 drivers/media/{video => parport}/pms.c     |  0
 drivers/media/{video => parport}/w9966.c   |  0
 drivers/media/video/Kconfig                | 61 ------------------------------
 drivers/media/video/Makefile               |  4 --
 10 files changed, 56 insertions(+), 69 deletions(-)
 create mode 100644 drivers/media/parport/Kconfig
 create mode 100644 drivers/media/parport/Makefile
 rename drivers/media/{video => parport}/bw-qcam.c (100%)
 rename drivers/media/{video => parport}/c-qcam.c (100%)
 rename drivers/media/{video => parport}/pms.c (100%)
 rename drivers/media/{video => parport}/w9966.c (100%)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 7970c24..c6d8658 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -164,6 +164,7 @@ source "drivers/media/dvb-core/Kconfig"
 source "drivers/media/pci/Kconfig"
 source "drivers/media/usb/Kconfig"
 source "drivers/media/mmc/Kconfig"
+source "drivers/media/parport/Kconfig"
 
 comment "Supported FireWire (IEEE 1394) Adapters"
 	depends on DVB_CORE && FIREWIRE
diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index 3265a9a..360c44d 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -8,8 +8,8 @@ ifeq ($(CONFIG_MEDIA_CONTROLLER),y)
   obj-$(CONFIG_MEDIA_SUPPORT) += media.o
 endif
 
-obj-y += v4l2-core/ tuners/ common/ rc/ video/
+obj-y += tuners/ common/ rc/ video/
+obj-y += pci/ usb/ mmc/ firewire/ parport/
 
-obj-$(CONFIG_VIDEO_DEV) += radio/
-obj-$(CONFIG_DVB_CORE)  += dvb-core/ pci/ dvb-frontends/ usb/ mmc/
-obj-$(CONFIG_DVB_FIREDTV) += firewire/
+obj-$(CONFIG_VIDEO_DEV) += radio/ v4l2-core/
+obj-$(CONFIG_DVB_CORE)  += dvb-core/ dvb-frontends/
diff --git a/drivers/media/parport/Kconfig b/drivers/media/parport/Kconfig
new file mode 100644
index 0000000..48138fe
--- /dev/null
+++ b/drivers/media/parport/Kconfig
@@ -0,0 +1,47 @@
+menu "V4L ISA and parallel port devices"
+	visible if (ISA || PARPORT) && MEDIA_CAMERA_SUPPORT
+
+config VIDEO_BWQCAM
+	tristate "Quickcam BW Video For Linux"
+	depends on PARPORT && VIDEO_V4L2
+	help
+	  Say Y have if you the black and white version of the QuickCam
+	  camera. See the next option for the color version.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called bw-qcam.
+
+config VIDEO_CQCAM
+	tristate "QuickCam Colour Video For Linux"
+	depends on PARPORT && VIDEO_V4L2
+	help
+	  This is the video4linux driver for the colour version of the
+	  Connectix QuickCam.  If you have one of these cameras, say Y here,
+	  otherwise say N.  This driver does not work with the original
+	  monochrome QuickCam, QuickCam VC or QuickClip.  It is also available
+	  as a module (c-qcam).
+	  Read <file:Documentation/video4linux/CQcam.txt> for more information.
+
+config VIDEO_PMS
+	tristate "Mediavision Pro Movie Studio Video For Linux"
+	depends on ISA && VIDEO_V4L2
+	help
+	  Say Y if you have the ISA Mediavision Pro Movie Studio
+	  capture card.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called pms.
+
+config VIDEO_W9966
+	tristate "W9966CF Webcam (FlyCam Supra and others) Video For Linux"
+	depends on PARPORT_1284 && PARPORT && VIDEO_V4L2
+	help
+	  Video4linux driver for Winbond's w9966 based Webcams.
+	  Currently tested with the LifeView FlyCam Supra.
+	  If you have one of these cameras, say Y here
+	  otherwise say N.
+	  This driver is also available as a module (w9966).
+
+	  Check out <file:Documentation/video4linux/w9966.txt> for more
+	  information.
+endmenu
diff --git a/drivers/media/parport/Makefile b/drivers/media/parport/Makefile
new file mode 100644
index 0000000..4eea06d
--- /dev/null
+++ b/drivers/media/parport/Makefile
@@ -0,0 +1,4 @@
+obj-$(CONFIG_VIDEO_CQCAM) += c-qcam.o
+obj-$(CONFIG_VIDEO_BWQCAM) += bw-qcam.o
+obj-$(CONFIG_VIDEO_W9966) += w9966.o
+obj-$(CONFIG_VIDEO_PMS) += pms.o
diff --git a/drivers/media/video/bw-qcam.c b/drivers/media/parport/bw-qcam.c
similarity index 100%
rename from drivers/media/video/bw-qcam.c
rename to drivers/media/parport/bw-qcam.c
diff --git a/drivers/media/video/c-qcam.c b/drivers/media/parport/c-qcam.c
similarity index 100%
rename from drivers/media/video/c-qcam.c
rename to drivers/media/parport/c-qcam.c
diff --git a/drivers/media/video/pms.c b/drivers/media/parport/pms.c
similarity index 100%
rename from drivers/media/video/pms.c
rename to drivers/media/parport/pms.c
diff --git a/drivers/media/video/w9966.c b/drivers/media/parport/w9966.c
similarity index 100%
rename from drivers/media/video/w9966.c
rename to drivers/media/parport/w9966.c
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index d545d93..f9703a0 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -606,67 +606,6 @@ config VIDEO_VIVI
 	  In doubt, say N.
 
 #
-# ISA & parallel port drivers configuration
-#	All devices here are webcam or grabber devices
-#
-
-menuconfig V4L_ISA_PARPORT_DRIVERS
-	bool "V4L ISA and parallel port devices"
-	depends on ISA || PARPORT
-	depends on MEDIA_CAMERA_SUPPORT
-	default n
-	---help---
-	  Say Y here to enable support for these ISA and parallel port drivers.
-
-if V4L_ISA_PARPORT_DRIVERS
-
-config VIDEO_BWQCAM
-	tristate "Quickcam BW Video For Linux"
-	depends on PARPORT && VIDEO_V4L2
-	help
-	  Say Y have if you the black and white version of the QuickCam
-	  camera. See the next option for the color version.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called bw-qcam.
-
-config VIDEO_CQCAM
-	tristate "QuickCam Colour Video For Linux"
-	depends on PARPORT && VIDEO_V4L2
-	help
-	  This is the video4linux driver for the colour version of the
-	  Connectix QuickCam.  If you have one of these cameras, say Y here,
-	  otherwise say N.  This driver does not work with the original
-	  monochrome QuickCam, QuickCam VC or QuickClip.  It is also available
-	  as a module (c-qcam).
-	  Read <file:Documentation/video4linux/CQcam.txt> for more information.
-
-config VIDEO_PMS
-	tristate "Mediavision Pro Movie Studio Video For Linux"
-	depends on ISA && VIDEO_V4L2
-	help
-	  Say Y if you have the ISA Mediavision Pro Movie Studio
-	  capture card.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called pms.
-
-config VIDEO_W9966
-	tristate "W9966CF Webcam (FlyCam Supra and others) Video For Linux"
-	depends on PARPORT_1284 && PARPORT && VIDEO_V4L2
-	help
-	  Video4linux driver for Winbond's w9966 based Webcams.
-	  Currently tested with the LifeView FlyCam Supra.
-	  If you have one of these cameras, say Y here
-	  otherwise say N.
-	  This driver is also available as a module (w9966).
-
-	  Check out <file:Documentation/video4linux/w9966.txt> for more
-	  information.
-
-endif # V4L_ISA_PARPORT_DRIVERS
-
-#
 # Platform drivers
 #	All drivers here are currently for webcam support
 
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index f212af3..a0c6692 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -87,10 +87,6 @@ obj-$(CONFIG_SOC_CAMERA_TW9910)		+= tw9910.o
 
 # And now the v4l2 drivers:
 
-obj-$(CONFIG_VIDEO_CQCAM) += c-qcam.o
-obj-$(CONFIG_VIDEO_BWQCAM) += bw-qcam.o
-obj-$(CONFIG_VIDEO_W9966) += w9966.o
-obj-$(CONFIG_VIDEO_PMS) += pms.o
 obj-$(CONFIG_VIDEO_VINO) += vino.o
 obj-$(CONFIG_VIDEO_TIMBERDALE)	+= timblogiw.o
 
-- 
1.7.11.2

