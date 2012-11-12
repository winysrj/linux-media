Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33138 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab2KLPiF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Nov 2012 10:38:05 -0500
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
Subject: [PATCH v8 3/6] fbmon: add videomode helpers
Date: Mon, 12 Nov 2012 16:37:03 +0100
Message-Id: <1352734626-27412-4-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1352734626-27412-1-git-send-email-s.trumtrar@pengutronix.de>
References: <1352734626-27412-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a function to convert from the generic videomode to a fb_videomode.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
---
 drivers/video/fbmon.c |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/fb.h    |    2 ++
 2 files changed, 39 insertions(+)

diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
index cef6557..d46ecef 100644
--- a/drivers/video/fbmon.c
+++ b/drivers/video/fbmon.c
@@ -1373,6 +1373,43 @@ int fb_get_mode(int flags, u32 val, struct fb_var_screeninfo *var, struct fb_inf
 	kfree(timings);
 	return err;
 }
+
+#if IS_ENABLED(CONFIG_VIDEOMODE)
+int videomode_to_fb_videomode(struct videomode *vm, struct fb_videomode *fbmode)
+{
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
+	fbmode->refresh = 60;
+	fbmode->flag = 0;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(videomode_to_fb_videomode);
+#endif
+
+
 #else
 int fb_parse_edid(unsigned char *edid, struct fb_var_screeninfo *var)
 {
diff --git a/include/linux/fb.h b/include/linux/fb.h
index c7a9571..46c665b 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -714,6 +714,8 @@ extern void fb_destroy_modedb(struct fb_videomode *modedb);
 extern int fb_find_mode_cvt(struct fb_videomode *mode, int margins, int rb);
 extern unsigned char *fb_ddc_read(struct i2c_adapter *adapter);
 
+extern int videomode_to_fb_videomode(struct videomode *vm, struct fb_videomode *fbmode);
+
 /* drivers/video/modedb.c */
 #define VESA_MODEDB_SIZE 34
 extern void fb_var_to_videomode(struct fb_videomode *mode,
-- 
1.7.10.4

