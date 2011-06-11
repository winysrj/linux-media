Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:54673 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055Ab1FKRrF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 13:47:05 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, Kassey Lee <ygli@marvell.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, Daniel Drake <dsd@laptop.org>
Subject: [PATCH 1/8] marvell-cam: Move cafe-ccic into its own directory
Date: Sat, 11 Jun 2011 11:46:42 -0600
Message-Id: <1307814409-46282-2-git-send-email-corbet@lwn.net>
In-Reply-To: <1307814409-46282-1-git-send-email-corbet@lwn.net>
References: <1307814409-46282-1-git-send-email-corbet@lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This driver will soon become a family of drivers, so let's give it its own
place to live.  This move requires putting ov7670.h into include/media, but
there are no code changes.

Cc: Daniel Drake <dsd@laptop.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/Kconfig                        |   11 ++---------
 drivers/media/video/Makefile                       |    2 +-
 drivers/media/video/marvell-ccic/Kconfig           |    9 +++++++++
 drivers/media/video/marvell-ccic/Makefile          |    1 +
 .../video/{ => marvell-ccic}/cafe_ccic-regs.h      |    0
 drivers/media/video/{ => marvell-ccic}/cafe_ccic.c |    2 +-
 drivers/media/video/ov7670.c                       |    3 +--
 {drivers/media/video => include/media}/ov7670.h    |    0
 8 files changed, 15 insertions(+), 13 deletions(-)
 create mode 100644 drivers/media/video/marvell-ccic/Kconfig
 create mode 100644 drivers/media/video/marvell-ccic/Makefile
 rename drivers/media/video/{ => marvell-ccic}/cafe_ccic-regs.h (100%)
 rename drivers/media/video/{ => marvell-ccic}/cafe_ccic.c (99%)
 rename {drivers/media/video => include/media}/ov7670.h (100%)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index bb53de7..4847c2c 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -707,6 +707,8 @@ source "drivers/media/video/cx18/Kconfig"
 
 source "drivers/media/video/saa7164/Kconfig"
 
+source "drivers/media/video/marvell-ccic/Kconfig"
+
 config VIDEO_M32R_AR
 	tristate "AR devices"
 	depends on M32R && VIDEO_V4L2
@@ -726,15 +728,6 @@ config VIDEO_M32R_AR_M64278
 	  To compile this driver as a module, choose M here: the
 	  module will be called arv.
 
-config VIDEO_CAFE_CCIC
-	tristate "Marvell 88ALP01 (Cafe) CMOS Camera Controller support"
-	depends on PCI && I2C && VIDEO_V4L2
-	select VIDEO_OV7670
-	---help---
-	  This is a video4linux2 driver for the Marvell 88ALP01 integrated
-	  CMOS camera controller.  This is the controller found on first-
-	  generation OLPC systems.
-
 config VIDEO_SR030PC30
 	tristate "SR030PC30 VGA camera sensor support"
 	depends on I2C && VIDEO_V4L2
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index f0fecd6..42b6a7a 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -127,7 +127,7 @@ obj-$(CONFIG_VIDEO_M32R_AR_M64278) += arv.o
 
 obj-$(CONFIG_VIDEO_CX2341X) += cx2341x.o
 
-obj-$(CONFIG_VIDEO_CAFE_CCIC) += cafe_ccic.o
+obj-$(CONFIG_VIDEO_CAFE_CCIC) += marvell-ccic/
 
 obj-$(CONFIG_VIDEO_VIA_CAMERA) += via-camera.o
 
diff --git a/drivers/media/video/marvell-ccic/Kconfig b/drivers/media/video/marvell-ccic/Kconfig
new file mode 100644
index 0000000..80136a8
--- /dev/null
+++ b/drivers/media/video/marvell-ccic/Kconfig
@@ -0,0 +1,9 @@
+config VIDEO_CAFE_CCIC
+	tristate "Marvell 88ALP01 (Cafe) CMOS Camera Controller support"
+	depends on PCI && I2C && VIDEO_V4L2
+	select VIDEO_OV7670
+	---help---
+	  This is a video4linux2 driver for the Marvell 88ALP01 integrated
+	  CMOS camera controller.  This is the controller found on first-
+	  generation OLPC systems.
+
diff --git a/drivers/media/video/marvell-ccic/Makefile b/drivers/media/video/marvell-ccic/Makefile
new file mode 100644
index 0000000..1234725
--- /dev/null
+++ b/drivers/media/video/marvell-ccic/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_VIDEO_CAFE_CCIC) += cafe_ccic.o
diff --git a/drivers/media/video/cafe_ccic-regs.h b/drivers/media/video/marvell-ccic/cafe_ccic-regs.h
similarity index 100%
rename from drivers/media/video/cafe_ccic-regs.h
rename to drivers/media/video/marvell-ccic/cafe_ccic-regs.h
diff --git a/drivers/media/video/cafe_ccic.c b/drivers/media/video/marvell-ccic/cafe_ccic.c
similarity index 99%
rename from drivers/media/video/cafe_ccic.c
rename to drivers/media/video/marvell-ccic/cafe_ccic.c
index 6647033..809964b 100644
--- a/drivers/media/video/cafe_ccic.c
+++ b/drivers/media/video/marvell-ccic/cafe_ccic.c
@@ -36,6 +36,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/ov7670.h>
 #include <linux/device.h>
 #include <linux/wait.h>
 #include <linux/list.h>
@@ -47,7 +48,6 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
-#include "ov7670.h"
 #include "cafe_ccic-regs.h"
 
 #define CAFE_VERSION 0x000002
diff --git a/drivers/media/video/ov7670.c b/drivers/media/video/ov7670.c
index d4e7c11..8aa0585 100644
--- a/drivers/media/video/ov7670.c
+++ b/drivers/media/video/ov7670.c
@@ -19,8 +19,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-mediabus.h>
-
-#include "ov7670.h"
+#include <media/ov7670.h>
 
 MODULE_AUTHOR("Jonathan Corbet <corbet@lwn.net>");
 MODULE_DESCRIPTION("A low-level driver for OmniVision ov7670 sensors");
diff --git a/drivers/media/video/ov7670.h b/include/media/ov7670.h
similarity index 100%
rename from drivers/media/video/ov7670.h
rename to include/media/ov7670.h
-- 
1.7.5.4

