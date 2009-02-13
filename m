Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:38044 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbZBMUyN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2009 15:54:13 -0500
From: Dominic Curran <dcurran@ti.com>
To: "linux-omap" <linux-omap@vger.kernel.org>
Subject: [OMAPZOOM][PATCH v2 2/3] LV8093: Add to Kconfig.
Date: Fri, 13 Feb 2009 14:54:07 -0600
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902131454.07202.dcurran@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dominic Curran <dcurran@ti.com>
Subject: [OMAPZOOM][PATCH v2 2/3] LV8093: Add to Kconfig.

Add LV8093 support to Kconfig and Makefile.

Signed-off-by: Kraig Proehl <kraig.proehl@hp.com>
Signed-off-by: Dominic Curran <dcurran@ti.com>
---
 drivers/media/video/Kconfig  |    6 ++++++
 drivers/media/video/Makefile |    1 +
 2 files changed, 7 insertions(+)

Index: omapzoom04/drivers/media/video/Kconfig
===================================================================
--- omapzoom04.orig/drivers/media/video/Kconfig
+++ omapzoom04/drivers/media/video/Kconfig
@@ -341,6 +341,12 @@ config VIDEO_IMX046
 	  This is a Video4Linux2 sensor-level driver for the Sony
 	  IMX046 camera.
 
+config VIDEO_LV8093
+	tristate "Piezo Actuator Lens driver for LV8093"
+	depends on I2C && VIDEO_V4L2
+	---help---
+	  This is a Video4Linux2 lens driver for the Sanyo LV8093.
+
 config VIDEO_SAA7110
 	tristate "Philips SAA7110 video decoder"
 	depends on VIDEO_V4L1 && I2C
Index: omapzoom04/drivers/media/video/Makefile
===================================================================
--- omapzoom04.orig/drivers/media/video/Makefile
+++ omapzoom04/drivers/media/video/Makefile
@@ -116,6 +116,7 @@ obj-$(CONFIG_VIDEO_MT9P012)	+= mt9p012.o
 obj-$(CONFIG_VIDEO_DW9710) += dw9710.o
 obj-$(CONFIG_VIDEO_OV3640)     += ov3640.o
 obj-$(CONFIG_VIDEO_IMX046)     += imx046.o
+obj-$(CONFIG_VIDEO_LV8093)     += lv8093.o
 
 obj-$(CONFIG_USB_DABUSB)        += dabusb.o
 obj-$(CONFIG_USB_OV511)         += ov511.o
