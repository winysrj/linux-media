Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46222 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767764Ab2KONP1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Nov 2012 08:15:27 -0500
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: devicetree-discuss@lists.ozlabs.org
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	"Rob Herring" <robherring2@gmail.com>, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	"Thierry Reding" <thierry.reding@avionic-design.de>,
	"Guennady Liakhovetski" <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	"Tomi Valkeinen" <tomi.valkeinen@ti.com>,
	"Stephen Warren" <swarren@wwwdotorg.org>, kernel@pengutronix.de
Subject: [PATCH v11 3/6] fbmon: add videomode helpers
Date: Thu, 15 Nov 2012 14:15:09 +0100
Message-Id: <1352985312-18178-4-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1352985312-18178-1-git-send-email-s.trumtrar@pengutronix.de>
References: <1352985312-18178-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a function to convert from the generic videomode to a fb_videomode.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
Tested-by: Thierry Reding <thierry.reding@avionic-design.de>
Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/video/fbmon.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fb.h    |    6 ++++++
 2 files changed, 52 insertions(+)

diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
index cef6557..247e079 100644
--- a/drivers/video/fbmon.c
+++ b/drivers/video/fbmon.c
@@ -31,6 +31,7 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <video/edid.h>
+#include <linux/videomode.h>
 #ifdef CONFIG_PPC_OF
 #include <asm/prom.h>
 #include <asm/pci-bridge.h>
@@ -1373,6 +1374,51 @@ int fb_get_mode(int flags, u32 val, struct fb_var_screeninfo *var, struct fb_inf
 	kfree(timings);
 	return err;
 }
+
+#if IS_ENABLED(CONFIG_VIDEOMODE)
+int fb_videomode_from_videomode(struct videomode *vm,
+				struct fb_videomode *fbmode)
+{
+	unsigned int htotal, vtotal;
+
+	fbmode->xres = vm->hactive;
+	fbmode->left_margin = vm->hback_porch;
+	fbmode->right_margin = vm->hfront_porch;
+	fbmode->hsync_len = vm->hsync_len;
+
+	fbmode->yres = vm->vactive;
+	fbmode->upper_margin = vm->vback_porch;
+	fbmode->lower_margin = vm->vfront_porch;
+	fbmode->vsync_len = vm->vsync_len;
+
+	fbmode->pixclock = KHZ2PICOS(vm->pixelclock / 1000);
+
+	fbmode->sync = 0;
+	fbmode->vmode = 0;
+	if (vm->hah)
+		fbmode->sync |= FB_SYNC_HOR_HIGH_ACT;
+	if (vm->vah)
+		fbmode->sync |= FB_SYNC_VERT_HIGH_ACT;
+	if (vm->interlaced)
+		fbmode->vmode |= FB_VMODE_INTERLACED;
+	if (vm->doublescan)
+		fbmode->vmode |= FB_VMODE_DOUBLE;
+	if (vm->de)
+		fbmode->sync |= FB_SYNC_DATA_ENABLE_HIGH_ACT;
+	fbmode->flag = 0;
+
+	htotal = vm->hactive + vm->hfront_porch + vm->hback_porch +
+		 vm->hsync_len;
+	vtotal = vm->vactive + vm->vfront_porch + vm->vback_porch +
+		 vm->vsync_len;
+	fbmode->refresh = (vm->pixelclock * 1000) / (htotal * vtotal);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fb_videomode_from_videomode);
+#endif
+
+
 #else
 int fb_parse_edid(unsigned char *edid, struct fb_var_screeninfo *var)
 {
diff --git a/include/linux/fb.h b/include/linux/fb.h
index c7a9571..4024136 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -14,6 +14,7 @@
 #include <linux/backlight.h>
 #include <linux/slab.h>
 #include <asm/io.h>
+#include <linux/videomode.h>
 
 struct vm_area_struct;
 struct fb_info;
@@ -714,6 +715,11 @@ extern void fb_destroy_modedb(struct fb_videomode *modedb);
 extern int fb_find_mode_cvt(struct fb_videomode *mode, int margins, int rb);
 extern unsigned char *fb_ddc_read(struct i2c_adapter *adapter);
 
+#if IS_ENABLED(CONFIG_VIDEOMODE)
+extern int fb_videomode_from_videomode(struct videomode *vm,
+				       struct fb_videomode *fbmode);
+#endif
+
 /* drivers/video/modedb.c */
 #define VESA_MODEDB_SIZE 34
 extern void fb_var_to_videomode(struct fb_videomode *mode,
-- 
1.7.10.4

