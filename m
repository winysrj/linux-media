Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:22435 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932970AbcIFJMG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2016 05:12:06 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Jiri Kosina <trivial@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v6 13/14] media: platform: pxa_camera: move pxa_camera out of soc_camera
Date: Tue,  6 Sep 2016 11:04:23 +0200
Message-Id: <1473152664-5077-13-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1473152664-5077-1-git-send-email-robert.jarzmik@free.fr>
References: <1473152664-5077-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the conversion to a v4l2 standalone device is finished, move
pxa_camera one directory up and finish severing any dependency to
soc_camera.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/platform/Kconfig                       | 8 ++++++++
 drivers/media/platform/Makefile                      | 1 +
 drivers/media/platform/{soc_camera => }/pxa_camera.c | 0
 drivers/media/platform/soc_camera/Kconfig            | 8 --------
 drivers/media/platform/soc_camera/Makefile           | 1 -
 5 files changed, 9 insertions(+), 9 deletions(-)
 rename drivers/media/platform/{soc_camera => }/pxa_camera.c (100%)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 46f14ddeee65..09ad0659e1f8 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -91,6 +91,14 @@ config VIDEO_OMAP3_DEBUG
 	---help---
 	  Enable debug messages on OMAP 3 camera controller driver.
 
+config VIDEO_PXA27x
+	tristate "PXA27x Quick Capture Interface driver"
+	depends on VIDEO_DEV && PXA27x && HAS_DMA
+	select VIDEOBUF2_DMA_SG
+	select SG_SPLIT
+	---help---
+	  This is a v4l2 driver for the PXA27x Quick Capture Interface
+
 config VIDEO_S3C_CAMIF
 	tristate "Samsung S3C24XX/S3C64XX SoC Camera Interface driver"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 536d1d8ef022..44baff208452 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_VIDEO_CAFE_CCIC) += marvell-ccic/
 obj-$(CONFIG_VIDEO_MMP_CAMERA) += marvell-ccic/
 
 obj-$(CONFIG_VIDEO_OMAP3)	+= omap3isp/
+obj-$(CONFIG_VIDEO_PXA27x)	+= pxa_camera.o soc_camera/soc_mediabus.o
 
 obj-$(CONFIG_VIDEO_VIU) += fsl-viu.o
 
diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/pxa_camera.c
similarity index 100%
rename from drivers/media/platform/soc_camera/pxa_camera.c
rename to drivers/media/platform/pxa_camera.c
diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
index 6b87b3a9d546..8b046dc49392 100644
--- a/drivers/media/platform/soc_camera/Kconfig
+++ b/drivers/media/platform/soc_camera/Kconfig
@@ -17,14 +17,6 @@ config SOC_CAMERA_PLATFORM
 	help
 	  This is a generic SoC camera platform driver, useful for testing
 
-config VIDEO_PXA27x
-	tristate "PXA27x Quick Capture Interface driver"
-	depends on VIDEO_DEV && PXA27x && HAS_DMA
-	select VIDEOBUF2_DMA_SG
-	select SG_SPLIT
-	---help---
-	  This is a v4l2 driver for the PXA27x Quick Capture Interface
-
 config VIDEO_RCAR_VIN_OLD
 	tristate "R-Car Video Input (VIN) support (DEPRECATED)"
 	depends on VIDEO_DEV && SOC_CAMERA
diff --git a/drivers/media/platform/soc_camera/Makefile b/drivers/media/platform/soc_camera/Makefile
index ee8f9a4ae2a4..e189870a333d 100644
--- a/drivers/media/platform/soc_camera/Makefile
+++ b/drivers/media/platform/soc_camera/Makefile
@@ -7,6 +7,5 @@ obj-$(CONFIG_SOC_CAMERA_PLATFORM)	+= soc_camera_platform.o
 
 # soc-camera host drivers have to be linked after camera drivers
 obj-$(CONFIG_VIDEO_ATMEL_ISI)		+= atmel-isi.o
-obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
 obj-$(CONFIG_VIDEO_RCAR_VIN_OLD)	+= rcar_vin.o
-- 
2.1.4

