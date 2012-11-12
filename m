Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:46080 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab2KLNeA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Nov 2012 08:34:00 -0500
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: <hvaibhav@ti.com>, <linux-media@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
	Archit Taneja <archit@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 1/2] [media] omap_vout: use omapdss's version instead of cpu_is_*
Date: Mon, 12 Nov 2012 15:33:39 +0200
Message-ID: <1352727220-22540-2-git-send-email-tomi.valkeinen@ti.com>
In-Reply-To: <1352727220-22540-1-git-send-email-tomi.valkeinen@ti.com>
References: <1352727220-22540-1-git-send-email-tomi.valkeinen@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cpu_is_* class functions create a dependency to OMAP platform code.
omapdss driver, which omap_vout uses, exposes a function to get the
version of the DSS hardware.

To remove the dependency to OMAP platform code this patch changes
omap_vout to use the omapdss version. For most of the checks, the ones
dealing with DSS differences, this is actually more correct than using
cpu_is_* functions. For the check whether VRFB is available or not this
is not really correct, but still works fine.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
---
 drivers/media/platform/omap/omap_vout.c    |    3 +--
 drivers/media/platform/omap/omap_voutlib.c |   38 ++++++++++++++++++++--------
 drivers/media/platform/omap/omap_voutlib.h |    3 +++
 3 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index 3ff94a3..7b1afc8 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -44,7 +44,6 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 
-#include <plat/cpu.h>
 #include <plat/dma.h>
 #include <video/omapvrfb.h>
 #include <video/omapdss.h>
@@ -2064,7 +2063,7 @@ static int __init omap_vout_create_video_devices(struct platform_device *pdev)
 		vout->vid_info.id = k + 1;
 
 		/* Set VRFB as rotation_type for omap2 and omap3 */
-		if (cpu_is_omap24xx() || cpu_is_omap34xx())
+		if (omap_vout_dss_omap24xx() || omap_vout_dss_omap34xx())
 			vout->vid_info.rotation_type = VOUT_ROT_VRFB;
 
 		/* Setup the default configuration for the video devices
diff --git a/drivers/media/platform/omap/omap_voutlib.c b/drivers/media/platform/omap/omap_voutlib.c
index 115408b..80b0d88 100644
--- a/drivers/media/platform/omap/omap_voutlib.c
+++ b/drivers/media/platform/omap/omap_voutlib.c
@@ -26,7 +26,7 @@
 
 #include <linux/dma-mapping.h>
 
-#include <plat/cpu.h>
+#include <video/omapdss.h>
 
 #include "omap_voutlib.h"
 
@@ -124,7 +124,7 @@ int omap_vout_new_window(struct v4l2_rect *crop,
 	win->chromakey = new_win->chromakey;
 
 	/* Adjust the cropping window to allow for resizing limitation */
-	if (cpu_is_omap24xx()) {
+	if (omap_vout_dss_omap24xx()) {
 		/* For 24xx limit is 8x to 1/2x scaling. */
 		if ((crop->height/win->w.height) >= 2)
 			crop->height = win->w.height * 2;
@@ -140,7 +140,7 @@ int omap_vout_new_window(struct v4l2_rect *crop,
 			if (crop->height != win->w.height)
 				crop->width = 768;
 		}
-	} else if (cpu_is_omap34xx()) {
+	} else if (omap_vout_dss_omap34xx()) {
 		/* For 34xx limit is 8x to 1/4x scaling. */
 		if ((crop->height/win->w.height) >= 4)
 			crop->height = win->w.height * 4;
@@ -196,7 +196,7 @@ int omap_vout_new_crop(struct v4l2_pix_format *pix,
 	if (try_crop.width <= 0 || try_crop.height <= 0)
 		return -EINVAL;
 
-	if (cpu_is_omap24xx()) {
+	if (omap_vout_dss_omap24xx()) {
 		if (try_crop.height != win->w.height) {
 			/* If we're resizing vertically, we can't support a
 			 * crop width wider than 768 pixels.
@@ -207,9 +207,9 @@ int omap_vout_new_crop(struct v4l2_pix_format *pix,
 	}
 	/* vertical resizing */
 	vresize = (1024 * try_crop.height) / win->w.height;
-	if (cpu_is_omap24xx() && (vresize > 2048))
+	if (omap_vout_dss_omap24xx() && (vresize > 2048))
 		vresize = 2048;
-	else if (cpu_is_omap34xx() && (vresize > 4096))
+	else if (omap_vout_dss_omap34xx() && (vresize > 4096))
 		vresize = 4096;
 
 	win->w.height = ((1024 * try_crop.height) / vresize) & ~1;
@@ -226,9 +226,9 @@ int omap_vout_new_crop(struct v4l2_pix_format *pix,
 	}
 	/* horizontal resizing */
 	hresize = (1024 * try_crop.width) / win->w.width;
-	if (cpu_is_omap24xx() && (hresize > 2048))
+	if (omap_vout_dss_omap24xx() && (hresize > 2048))
 		hresize = 2048;
-	else if (cpu_is_omap34xx() && (hresize > 4096))
+	else if (omap_vout_dss_omap34xx() && (hresize > 4096))
 		hresize = 4096;
 
 	win->w.width = ((1024 * try_crop.width) / hresize) & ~1;
@@ -243,7 +243,7 @@ int omap_vout_new_crop(struct v4l2_pix_format *pix,
 		if (try_crop.width == 0)
 			try_crop.width = 2;
 	}
-	if (cpu_is_omap24xx()) {
+	if (omap_vout_dss_omap24xx()) {
 		if ((try_crop.height/win->w.height) >= 2)
 			try_crop.height = win->w.height * 2;
 
@@ -258,7 +258,7 @@ int omap_vout_new_crop(struct v4l2_pix_format *pix,
 			if (try_crop.height != win->w.height)
 				try_crop.width = 768;
 		}
-	} else if (cpu_is_omap34xx()) {
+	} else if (omap_vout_dss_omap34xx()) {
 		if ((try_crop.height/win->w.height) >= 4)
 			try_crop.height = win->w.height * 4;
 
@@ -337,3 +337,21 @@ void omap_vout_free_buffer(unsigned long virtaddr, u32 buf_size)
 	}
 	free_pages((unsigned long) virtaddr, order);
 }
+
+bool omap_vout_dss_omap24xx(void)
+{
+	return omapdss_get_version() == OMAPDSS_VER_OMAP24xx;
+}
+
+bool omap_vout_dss_omap34xx(void)
+{
+	switch (omapdss_get_version()) {
+	case OMAPDSS_VER_OMAP34xx_ES1:
+	case OMAPDSS_VER_OMAP34xx_ES3:
+	case OMAPDSS_VER_OMAP3630:
+	case OMAPDSS_VER_AM35xx:
+		return true;
+	default:
+		return false;
+	}
+}
diff --git a/drivers/media/platform/omap/omap_voutlib.h b/drivers/media/platform/omap/omap_voutlib.h
index e51750a..f9d1c07 100644
--- a/drivers/media/platform/omap/omap_voutlib.h
+++ b/drivers/media/platform/omap/omap_voutlib.h
@@ -32,5 +32,8 @@ void omap_vout_new_format(struct v4l2_pix_format *pix,
 		struct v4l2_window *win);
 unsigned long omap_vout_alloc_buffer(u32 buf_size, u32 *phys_addr);
 void omap_vout_free_buffer(unsigned long virtaddr, u32 buf_size);
+
+bool omap_vout_dss_omap24xx(void);
+bool omap_vout_dss_omap34xx(void);
 #endif	/* #ifndef OMAP_VOUTLIB_H */
 
-- 
1.7.10.4

