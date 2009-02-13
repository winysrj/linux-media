Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:44574 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbZBMUyO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2009 15:54:14 -0500
From: Dominic Curran <dcurran@ti.com>
To: "linux-omap" <linux-omap@vger.kernel.org>
Subject: [OMAPZOOM][PATCH v2 3/3] LV8093: Add support to zoom2 board file.
Date: Fri, 13 Feb 2009 14:54:08 -0600
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902131454.08858.dcurran@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dominic Curran <dcurran@ti.com>
Subject: [OMAPZOOM][PATCH v2 3/3] LV8093: Add support to zoom2 board file.

Add support for the LV8093 to the OMAP3430 Zoom2 board file.
The LV8093 is the lens driver for the Sony IMX046 camera.

Signed-off-by: Kraig Proehl <kraig.proehl@hp.com>
Signed-off-by: Dominic Curran <dcurran@ti.com>
---
 arch/arm/configs/omap_zoom2_defconfig |    1 +
 arch/arm/mach-omap2/board-zoom2.c     |   28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

Index: omapzoom04/arch/arm/configs/omap_zoom2_defconfig
===================================================================
--- omapzoom04.orig/arch/arm/configs/omap_zoom2_defconfig
+++ omapzoom04/arch/arm/configs/omap_zoom2_defconfig
@@ -995,6 +995,7 @@ CONFIG_VIDEO_CAPTURE_DRIVERS=y
 # CONFIG_VIDEO_DW9710 is not set
 # CONFIG_VIDEO_OV3640 is not set
 CONFIG_VIDEO_IMX046=y
+CONFIG_VIDEO_LV8093=y
 # CONFIG_VIDEO_SAA711X is not set
 # CONFIG_VIDEO_SAA717X is not set
 # CONFIG_VIDEO_TVP5150 is not set
Index: omapzoom04/arch/arm/mach-omap2/board-zoom2.c
===================================================================
--- omapzoom04.orig/arch/arm/mach-omap2/board-zoom2.c
+++ omapzoom04/arch/arm/mach-omap2/board-zoom2.c
@@ -75,6 +75,10 @@
 #endif
 #endif
 
+#if defined(CONFIG_VIDEO_LV8093) || defined(CONFIG_VIDEO_LV8093_MODULE)
+#include <../drivers/media/video/lv8093.h>
+#endif
+
 #ifdef CONFIG_TOUCHSCREEN_SYNAPTICS
 #define OMAP_SYNAPTICS_GPIO		163
 #endif
@@ -326,6 +330,24 @@ static struct twl4030_keypad_data ldp_kp
 	.irq		= TWL4030_MODIRQ_KEYPAD,
 };
 
+#if defined(CONFIG_VIDEO_LV8093) || defined(CONFIG_VIDEO_LV8093_MODULE)
+static int lv8093_lens_set_prv_data(void *priv)
+{
+	struct omap34xxcam_hw_config *hwc = priv;
+
+	hwc->dev_index = 2;
+	hwc->dev_minor = 5;
+	hwc->dev_type = OMAP34XXCAM_SLAVE_LENS;
+	hwc->interface_type = ISP_CSIA;
+	return 0;
+}
+
+static struct lv8093_platform_data zoom2_lv8093_platform_data = {
+	.power_set      = NULL,
+	.priv_data_set  = lv8093_lens_set_prv_data,
+};
+#endif
+
 #if defined(CONFIG_VIDEO_IMX046) || defined(CONFIG_VIDEO_IMX046_MODULE)
 
 static struct omap34xxcam_sensor_config imx046_hwc = {
@@ -716,6 +738,12 @@ static struct i2c_board_info __initdata 
 		.platform_data = &zoom2_imx046_platform_data,
 	},
 #endif
+#if defined(CONFIG_VIDEO_LV8093) || defined(CONFIG_VIDEO_LV8093_MODULE)
+	{
+		I2C_BOARD_INFO(LV8093_NAME,  LV8093_AF_I2C_ADDR),
+		.platform_data = &zoom2_lv8093_platform_data,
+	},
+#endif
 };
 
 static int __init omap_i2c_init(void)
