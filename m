Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2361 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab3LLM04 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Dec 2013 07:26:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	David Cohen <dacohen@gmail.com>
Subject: [RFCv2 PATCH 2/2] omap24xx/tcm825x: move to staging for future removal.
Date: Thu, 12 Dec 2013 13:26:33 +0100
Message-Id: <1386851193-3845-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1386851193-3845-1-git-send-email-hverkuil@xs4all.nl>
References: <1386851193-3845-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The omap24xx driver and the tcm825x sensor driver are the only two
remaining drivers to still use the old deprecated v4l2-int-device API.

Nobody maintains these drivers anymore. But unfortunately the v4l2-int-device
API is used by out-of-tree drivers (MXC platform). This is a very bad situation
since as long as this deprecated API stays in the kernel there is no reason for
those out-of-tree drivers to convert.

This patch moves v4l2-int-device and the two drivers that depend on it to
staging in preparation for their removal.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: David Cohen <dacohen@gmail.com>
---
 drivers/media/i2c/Kconfig                          |  8 -----
 drivers/media/i2c/Makefile                         |  1 -
 drivers/media/platform/Kconfig                     |  7 -----
 drivers/media/platform/Makefile                    |  3 --
 drivers/media/v4l2-core/Kconfig                    | 11 -------
 drivers/media/v4l2-core/Makefile                   |  1 -
 drivers/staging/media/Kconfig                      |  2 ++
 drivers/staging/media/Makefile                     |  2 ++
 drivers/staging/media/omap24xx/Kconfig             | 35 ++++++++++++++++++++++
 drivers/staging/media/omap24xx/Makefile            |  5 ++++
 .../media/omap24xx}/omap24xxcam-dma.c              |  0
 .../media/omap24xx}/omap24xxcam.c                  |  0
 .../media/omap24xx}/omap24xxcam.h                  |  2 +-
 .../i2c => staging/media/omap24xx}/tcm825x.c       |  2 +-
 .../i2c => staging/media/omap24xx}/tcm825x.h       |  2 +-
 .../media/omap24xx}/v4l2-int-device.c              |  2 +-
 .../staging/media/omap24xx}/v4l2-int-device.h      |  0
 17 files changed, 48 insertions(+), 35 deletions(-)
 create mode 100644 drivers/staging/media/omap24xx/Kconfig
 create mode 100644 drivers/staging/media/omap24xx/Makefile
 rename drivers/{media/platform => staging/media/omap24xx}/omap24xxcam-dma.c (100%)
 rename drivers/{media/platform => staging/media/omap24xx}/omap24xxcam.c (100%)
 rename drivers/{media/platform => staging/media/omap24xx}/omap24xxcam.h (99%)
 rename drivers/{media/i2c => staging/media/omap24xx}/tcm825x.c (99%)
 rename drivers/{media/i2c => staging/media/omap24xx}/tcm825x.h (99%)
 rename drivers/{media/v4l2-core => staging/media/omap24xx}/v4l2-int-device.c (99%)
 rename {include/media => drivers/staging/media/omap24xx}/v4l2-int-device.h (100%)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 842654d..997cd66 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -555,14 +555,6 @@ config VIDEO_MT9V032
 	  This is a Video4Linux2 sensor-level driver for the Micron
 	  MT9V032 752x480 CMOS sensor.
 
-config VIDEO_TCM825X
-	tristate "TCM825x camera sensor support"
-	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_INT_DEVICE
-	depends on MEDIA_CAMERA_SUPPORT
-	---help---
-	  This is a driver for the Toshiba TCM825x VGA camera sensor.
-	  It is used for example in Nokia N800.
-
 config VIDEO_SR030PC30
 	tristate "Siliconfile SR030PC30 sensor support"
 	depends on I2C && VIDEO_V4L2
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index e03f177..abd25e3 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -57,7 +57,6 @@ obj-$(CONFIG_VIDEO_UPD64083) += upd64083.o
 obj-$(CONFIG_VIDEO_OV7640) += ov7640.o
 obj-$(CONFIG_VIDEO_OV7670) += ov7670.o
 obj-$(CONFIG_VIDEO_OV9650) += ov9650.o
-obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
 obj-$(CONFIG_VIDEO_MT9M032) += mt9m032.o
 obj-$(CONFIG_VIDEO_MT9P031) += mt9p031.o
 obj-$(CONFIG_VIDEO_MT9T001) += mt9t001.o
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 7f6ea65..b2a4403 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -91,13 +91,6 @@ config VIDEO_M32R_AR_M64278
 	  To compile this driver as a module, choose M here: the
 	  module will be called arv.
 
-config VIDEO_OMAP2
-	tristate "OMAP2 Camera Capture Interface driver"
-	depends on VIDEO_DEV && ARCH_OMAP2 && VIDEO_V4L2_INT_DEVICE
-	select VIDEOBUF_DMA_SG
-	---help---
-	  This is a v4l2 driver for the TI OMAP2 camera capture interface
-
 config VIDEO_OMAP3
 	tristate "OMAP 3 Camera support"
 	depends on OMAP_IOVMM && VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 1348ba1..e5269da 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -2,8 +2,6 @@
 # Makefile for the video capture/playback device drivers.
 #
 
-omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
-
 obj-$(CONFIG_VIDEO_VINO) += indycam.o
 obj-$(CONFIG_VIDEO_VINO) += vino.o
 
@@ -14,7 +12,6 @@ obj-$(CONFIG_VIDEO_VIA_CAMERA) += via-camera.o
 obj-$(CONFIG_VIDEO_CAFE_CCIC) += marvell-ccic/
 obj-$(CONFIG_VIDEO_MMP_CAMERA) += marvell-ccic/
 
-obj-$(CONFIG_VIDEO_OMAP2)		+= omap2cam.o
 obj-$(CONFIG_VIDEO_OMAP3)	+= omap3isp/
 
 obj-$(CONFIG_VIDEO_VIU) += fsl-viu.o
diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index 8c05565..2189bfb 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -83,14 +83,3 @@ config VIDEOBUF2_DMA_SG
 	#depends on HAS_DMA
 	select VIDEOBUF2_CORE
 	select VIDEOBUF2_MEMOPS
-
-config VIDEO_V4L2_INT_DEVICE
-	tristate "V4L2 int device (DEPRECATED)"
-	depends on VIDEO_V4L2
-	---help---
-	  An early framework for a hardware-independent interface for
-	  image sensors and bridges etc. Currently used by omap24xxcam and
-	  tcm825x drivers that should be converted to V4L2 subdev.
-
-	  Do not use for new developments.
-
diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index 1a85eee..c6ae7ba 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -15,7 +15,6 @@ ifeq ($(CONFIG_OF),y)
 endif
 
 obj-$(CONFIG_VIDEO_V4L2) += videodev.o
-obj-$(CONFIG_VIDEO_V4L2_INT_DEVICE) += v4l2-int-device.o
 obj-$(CONFIG_VIDEO_V4L2) += v4l2-common.o
 obj-$(CONFIG_VIDEO_V4L2) += v4l2-dv-timings.o
 
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 6a20217..22b0c9d 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -33,6 +33,8 @@ source "drivers/staging/media/go7007/Kconfig"
 
 source "drivers/staging/media/msi3101/Kconfig"
 
+source "drivers/staging/media/omap24xx/Kconfig"
+
 source "drivers/staging/media/sn9c102/Kconfig"
 
 source "drivers/staging/media/solo6x10/Kconfig"
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 2a15451..bedc62a 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -9,3 +9,5 @@ obj-$(CONFIG_USB_MSI3101)	+= msi3101/
 obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
 obj-$(CONFIG_USB_SN9C102)       += sn9c102/
+obj-$(CONFIG_VIDEO_OMAP2)       += omap24xx/
+obj-$(CONFIG_VIDEO_TCM825X)     += omap24xx/
diff --git a/drivers/staging/media/omap24xx/Kconfig b/drivers/staging/media/omap24xx/Kconfig
new file mode 100644
index 0000000..82e569a
--- /dev/null
+++ b/drivers/staging/media/omap24xx/Kconfig
@@ -0,0 +1,35 @@
+config VIDEO_V4L2_INT_DEVICE
+       tristate
+
+config VIDEO_OMAP2
+	tristate "OMAP2 Camera Capture Interface driver (DEPRECATED)"
+	depends on VIDEO_DEV && ARCH_OMAP2
+	select VIDEOBUF_DMA_SG
+	select VIDEO_V4L2_INT_DEVICE
+	---help---
+	  This is a v4l2 driver for the TI OMAP2 camera capture interface
+
+	  It uses the deprecated int-device API. Since this driver is no
+	  longer actively maintained and nobody is interested in converting
+	  it to the subdev API, this driver will be removed soon.
+
+	  If you do want to keep this driver in the kernel, and are willing
+	  to convert it to the subdev API, then please contact the linux-media
+	  mailinglist.
+
+config VIDEO_TCM825X
+	tristate "TCM825x camera sensor support (DEPRECATED)"
+	depends on I2C && VIDEO_V4L2
+	depends on MEDIA_CAMERA_SUPPORT
+	select VIDEO_V4L2_INT_DEVICE
+	---help---
+	  This is a driver for the Toshiba TCM825x VGA camera sensor.
+	  It is used for example in Nokia N800.
+
+	  It uses the deprecated int-device API. Since this driver is no
+	  longer actively maintained and nobody is interested in converting
+	  it to the subdev API, this driver will be removed soon.
+
+	  If you do want to keep this driver in the kernel, and are willing
+	  to convert it to the subdev API, then please contact the linux-media
+	  mailinglist.
diff --git a/drivers/staging/media/omap24xx/Makefile b/drivers/staging/media/omap24xx/Makefile
new file mode 100644
index 0000000..c2e7175
--- /dev/null
+++ b/drivers/staging/media/omap24xx/Makefile
@@ -0,0 +1,5 @@
+omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
+
+obj-$(CONFIG_VIDEO_OMAP2)   += omap2cam.o
+obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
+obj-$(CONFIG_VIDEO_V4L2_INT_DEVICE) += v4l2-int-device.o
diff --git a/drivers/media/platform/omap24xxcam-dma.c b/drivers/staging/media/omap24xx/omap24xxcam-dma.c
similarity index 100%
rename from drivers/media/platform/omap24xxcam-dma.c
rename to drivers/staging/media/omap24xx/omap24xxcam-dma.c
diff --git a/drivers/media/platform/omap24xxcam.c b/drivers/staging/media/omap24xx/omap24xxcam.c
similarity index 100%
rename from drivers/media/platform/omap24xxcam.c
rename to drivers/staging/media/omap24xx/omap24xxcam.c
diff --git a/drivers/media/platform/omap24xxcam.h b/drivers/staging/media/omap24xx/omap24xxcam.h
similarity index 99%
rename from drivers/media/platform/omap24xxcam.h
rename to drivers/staging/media/omap24xx/omap24xxcam.h
index 7f6f791..233bb40 100644
--- a/drivers/media/platform/omap24xxcam.h
+++ b/drivers/staging/media/omap24xx/omap24xxcam.h
@@ -28,8 +28,8 @@
 #define OMAP24XXCAM_H
 
 #include <media/videobuf-dma-sg.h>
-#include <media/v4l2-int-device.h>
 #include <media/v4l2-device.h>
+#include "v4l2-int-device.h"
 
 /*
  *
diff --git a/drivers/media/i2c/tcm825x.c b/drivers/staging/media/omap24xx/tcm825x.c
similarity index 99%
rename from drivers/media/i2c/tcm825x.c
rename to drivers/staging/media/omap24xx/tcm825x.c
index 9252529..b1ae8e9 100644
--- a/drivers/media/i2c/tcm825x.c
+++ b/drivers/staging/media/omap24xx/tcm825x.c
@@ -28,7 +28,7 @@
 
 #include <linux/i2c.h>
 #include <linux/module.h>
-#include <media/v4l2-int-device.h>
+#include "v4l2-int-device.h"
 
 #include "tcm825x.h"
 
diff --git a/drivers/media/i2c/tcm825x.h b/drivers/staging/media/omap24xx/tcm825x.h
similarity index 99%
rename from drivers/media/i2c/tcm825x.h
rename to drivers/staging/media/omap24xx/tcm825x.h
index 8ebab95..e2d1bcd 100644
--- a/drivers/media/i2c/tcm825x.h
+++ b/drivers/staging/media/omap24xx/tcm825x.h
@@ -17,7 +17,7 @@
 
 #include <linux/videodev2.h>
 
-#include <media/v4l2-int-device.h>
+#include "v4l2-int-device.h"
 
 #define TCM825X_NAME "tcm825x"
 
diff --git a/drivers/media/v4l2-core/v4l2-int-device.c b/drivers/staging/media/omap24xx/v4l2-int-device.c
similarity index 99%
rename from drivers/media/v4l2-core/v4l2-int-device.c
rename to drivers/staging/media/omap24xx/v4l2-int-device.c
index f447349..427a890 100644
--- a/drivers/media/v4l2-core/v4l2-int-device.c
+++ b/drivers/staging/media/omap24xx/v4l2-int-device.c
@@ -28,7 +28,7 @@
 #include <linux/string.h>
 #include <linux/module.h>
 
-#include <media/v4l2-int-device.h>
+#include "v4l2-int-device.h"
 
 static DEFINE_MUTEX(mutex);
 static LIST_HEAD(int_list);
diff --git a/include/media/v4l2-int-device.h b/drivers/staging/media/omap24xx/v4l2-int-device.h
similarity index 100%
rename from include/media/v4l2-int-device.h
rename to drivers/staging/media/omap24xx/v4l2-int-device.h
-- 
1.8.4.3

