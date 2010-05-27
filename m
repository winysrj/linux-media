Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:37626 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab0E0LR0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 07:17:26 -0400
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, m-karicheri2@ti.com,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 1/3] OMAP_VOUT:Build FIX: Rebased against latest DSS2 changes
Date: Thu, 27 May 2010 16:47:07 +0530
Message-Id: <1274959029-5866-2-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

Changes -
	- Kconfig option dependancy changed to ARCH_OMAP2/3 from
	ARCH_OMAP24XX/34XX
	- There are some moments of function from omap_dss_device
	to omap_dss_driver. Incorporated changes for the same.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/omap/Kconfig     |    2 +-
 drivers/media/video/omap/omap_vout.c |   35 ++++++++++++++++++---------------
 2 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/media/video/omap/Kconfig b/drivers/media/video/omap/Kconfig
index 97c5394..c1d1933 100644
--- a/drivers/media/video/omap/Kconfig
+++ b/drivers/media/video/omap/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_OMAP2_VOUT
 	tristate "OMAP2/OMAP3 V4L2-Display driver"
-	depends on ARCH_OMAP24XX || ARCH_OMAP34XX
+	depends on ARCH_OMAP2 || ARCH_OMAP3
 	select VIDEOBUF_GEN
 	select VIDEOBUF_DMA_SG
 	select OMAP2_DSS
diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 4c0ab49..08b2fb8 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -38,6 +38,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/irq.h>
 #include <linux/videodev2.h>
+#include <linux/slab.h>
 
 #include <media/videobuf-dma-sg.h>
 #include <media/v4l2-device.h>
@@ -2489,7 +2490,7 @@ static int omap_vout_remove(struct platform_device *pdev)
 
 	for (k = 0; k < vid_dev->num_displays; k++) {
 		if (vid_dev->displays[k]->state != OMAP_DSS_DISPLAY_DISABLED)
-			vid_dev->displays[k]->disable(vid_dev->displays[k]);
+			vid_dev->displays[k]->driver->disable(vid_dev->displays[k]);
 
 		omap_dss_put_device(vid_dev->displays[k]);
 	}
@@ -2546,7 +2547,9 @@ static int __init omap_vout_probe(struct platform_device *pdev)
 			def_display = NULL;
 		}
 		if (def_display) {
-			ret = def_display->enable(def_display);
+			struct omap_dss_driver *dssdrv = def_display->driver;
+
+			ret = dssdrv->enable(def_display);
 			if (ret) {
 				/* Here we are not considering a error
 				 *  as display may be enabled by frame
@@ -2560,21 +2563,21 @@ static int __init omap_vout_probe(struct platform_device *pdev)
 			if (def_display->caps &
 					OMAP_DSS_DISPLAY_CAP_MANUAL_UPDATE) {
 #ifdef CONFIG_FB_OMAP2_FORCE_AUTO_UPDATE
-				if (def_display->enable_te)
-					def_display->enable_te(def_display, 1);
-				if (def_display->set_update_mode)
-					def_display->set_update_mode(def_display,
+				if (dssdrv->enable_te)
+					dssdrv->enable_te(def_display, 1);
+				if (dssdrv->set_update_mode)
+					dssdrv->set_update_mode(def_display,
 							OMAP_DSS_UPDATE_AUTO);
 #else	/* MANUAL_UPDATE */
-				if (def_display->enable_te)
-					def_display->enable_te(def_display, 0);
-				if (def_display->set_update_mode)
-					def_display->set_update_mode(def_display,
+				if (dssdrv->enable_te)
+					dssdrv->enable_te(def_display, 0);
+				if (dssdrv->set_update_mode)
+					dssdrv->set_update_mode(def_display,
 							OMAP_DSS_UPDATE_MANUAL);
 #endif
 			} else {
-				if (def_display->set_update_mode)
-					def_display->set_update_mode(def_display,
+				if (dssdrv->set_update_mode)
+					dssdrv->set_update_mode(def_display,
 							OMAP_DSS_UPDATE_AUTO);
 			}
 		}
@@ -2593,8 +2596,8 @@ static int __init omap_vout_probe(struct platform_device *pdev)
 	for (i = 0; i < vid_dev->num_displays; i++) {
 		struct omap_dss_device *display = vid_dev->displays[i];
 
-		if (display->update)
-			display->update(display, 0, 0,
+		if (display->driver->update)
+			display->driver->update(display, 0, 0,
 					display->panel.timings.x_res,
 					display->panel.timings.y_res);
 	}
@@ -2609,8 +2612,8 @@ probe_err1:
 		if (ovl->manager && ovl->manager->device)
 			def_display = ovl->manager->device;
 
-		if (def_display)
-			def_display->disable(def_display);
+		if (def_display && def_display->driver)
+			def_display->driver->disable(def_display);
 	}
 probe_err0:
 	kfree(vid_dev);
-- 
1.6.2.4

