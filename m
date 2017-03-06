Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:38670 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754026AbdCFO6v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 09:58:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 08/15] atmel-isi: move out of soc_camera to atmel
Date: Mon,  6 Mar 2017 15:56:09 +0100
Message-Id: <20170306145616.38485-9-hverkuil@xs4all.nl>
In-Reply-To: <20170306145616.38485-1-hverkuil@xs4all.nl>
References: <20170306145616.38485-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Move this out of the soc_camera directory into the atmel directory
where it belongs.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/Makefile                          |  1 +
 drivers/media/platform/atmel/Kconfig                     | 11 ++++++++++-
 drivers/media/platform/atmel/Makefile                    |  1 +
 drivers/media/platform/{soc_camera => atmel}/atmel-isi.c |  0
 drivers/media/platform/{soc_camera => atmel}/atmel-isi.h |  0
 drivers/media/platform/soc_camera/Kconfig                | 10 ----------
 drivers/media/platform/soc_camera/Makefile               |  1 -
 7 files changed, 12 insertions(+), 12 deletions(-)
 rename drivers/media/platform/{soc_camera => atmel}/atmel-isi.c (100%)
 rename drivers/media/platform/{soc_camera => atmel}/atmel-isi.h (100%)

diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 8959f6e6692a..c491731f5909 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -63,6 +63,7 @@ obj-$(CONFIG_VIDEO_XILINX)		+= xilinx/
 obj-$(CONFIG_VIDEO_RCAR_VIN)		+= rcar-vin/
 
 obj-$(CONFIG_VIDEO_ATMEL_ISC)		+= atmel/
+obj-$(CONFIG_VIDEO_ATMEL_ISI)		+= atmel/
 
 ccflags-y += -I$(srctree)/drivers/media/i2c
 
diff --git a/drivers/media/platform/atmel/Kconfig b/drivers/media/platform/atmel/Kconfig
index 867dca22a473..9bd0f19b127f 100644
--- a/drivers/media/platform/atmel/Kconfig
+++ b/drivers/media/platform/atmel/Kconfig
@@ -6,4 +6,13 @@ config VIDEO_ATMEL_ISC
 	select REGMAP_MMIO
 	help
 	   This module makes the ATMEL Image Sensor Controller available
-	   as a v4l2 device.
\ No newline at end of file
+	   as a v4l2 device.
+
+config VIDEO_ATMEL_ISI
+	tristate "ATMEL Image Sensor Interface (ISI) support"
+	depends on VIDEO_V4L2 && OF && HAS_DMA
+	depends on ARCH_AT91 || COMPILE_TEST
+	select VIDEOBUF2_DMA_CONTIG
+	---help---
+	  This module makes the ATMEL Image Sensor Interface available
+	  as a v4l2 device.
diff --git a/drivers/media/platform/atmel/Makefile b/drivers/media/platform/atmel/Makefile
index 9d7c999d434d..27000d099a5e 100644
--- a/drivers/media/platform/atmel/Makefile
+++ b/drivers/media/platform/atmel/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_VIDEO_ATMEL_ISC) += atmel-isc.o
+obj-$(CONFIG_VIDEO_ATMEL_ISI) += atmel-isi.o
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/atmel/atmel-isi.c
similarity index 100%
rename from drivers/media/platform/soc_camera/atmel-isi.c
rename to drivers/media/platform/atmel/atmel-isi.c
diff --git a/drivers/media/platform/soc_camera/atmel-isi.h b/drivers/media/platform/atmel/atmel-isi.h
similarity index 100%
rename from drivers/media/platform/soc_camera/atmel-isi.h
rename to drivers/media/platform/atmel/atmel-isi.h
diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
index a37ec91b026e..0c581aa1b18a 100644
--- a/drivers/media/platform/soc_camera/Kconfig
+++ b/drivers/media/platform/soc_camera/Kconfig
@@ -26,13 +26,3 @@ config VIDEO_SH_MOBILE_CEU
 	select SOC_CAMERA_SCALE_CROP
 	---help---
 	  This is a v4l2 driver for the SuperH Mobile CEU Interface
-
-config VIDEO_ATMEL_ISI
-	tristate "ATMEL Image Sensor Interface (ISI) support"
-	depends on VIDEO_V4L2 && OF && HAS_DMA
-	depends on ARCH_AT91 || COMPILE_TEST
-	select VIDEOBUF2_DMA_CONTIG
-	---help---
-	  This module makes the ATMEL Image Sensor Interface available
-	  as a v4l2 device.
-
diff --git a/drivers/media/platform/soc_camera/Makefile b/drivers/media/platform/soc_camera/Makefile
index 7633a0f2f66f..07a451e8b228 100644
--- a/drivers/media/platform/soc_camera/Makefile
+++ b/drivers/media/platform/soc_camera/Makefile
@@ -6,5 +6,4 @@ obj-$(CONFIG_SOC_CAMERA_SCALE_CROP)	+= soc_scale_crop.o
 obj-$(CONFIG_SOC_CAMERA_PLATFORM)	+= soc_camera_platform.o
 
 # soc-camera host drivers have to be linked after camera drivers
-obj-$(CONFIG_VIDEO_ATMEL_ISI)		+= atmel-isi.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
-- 
2.11.0
