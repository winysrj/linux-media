Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39285 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932755Ab2JaJ3O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Oct 2012 05:29:14 -0400
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
Subject: [PATCH v7 6/8] fbmon: add of_videomode helpers
Date: Wed, 31 Oct 2012 10:28:06 +0100
Message-Id: <1351675689-26814-7-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1351675689-26814-1-git-send-email-s.trumtrar@pengutronix.de>
References: <1351675689-26814-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add helper to get fb_videomode from devicetree.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
---
 drivers/video/fbmon.c |   40 ++++++++++++++++++++++++++++++++++++++++
 include/linux/fb.h    |    3 +++
 2 files changed, 43 insertions(+)

diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
index b9e6ab3..871aa76 100644
--- a/drivers/video/fbmon.c
+++ b/drivers/video/fbmon.c
@@ -1408,6 +1408,46 @@ int videomode_to_fb_videomode(struct videomode *vm, struct fb_videomode *fbmode)
 EXPORT_SYMBOL_GPL(videomode_to_fb_videomode);
 #endif
 
+#if IS_ENABLED(CONFIG_OF_VIDEOMODE)
+static void dump_fb_videomode(struct fb_videomode *m)
+{
+	pr_debug("fb_videomode = %ux%u@%uHz (%ukHz) %u %u %u %u %u %u %u %u %u\n",
+		 m->xres, m->yres, m->refresh, m->pixclock, m->left_margin,
+		 m->right_margin, m->upper_margin, m->lower_margin,
+		 m->hsync_len, m->vsync_len, m->sync, m->vmode, m->flag);
+}
+
+/**
+ * of_get_fb_videomode - get a fb_videomode from devicetree
+ * @np: device_node with the timing specification
+ * @fb: will be set to the return value
+ * @index: index into the list of display timings in devicetree
+ *
+ * DESCRIPTION:
+ * This function is expensive and should only be used, if only one mode is to be
+ * read from DT. To get multiple modes start with of_get_display_timing_list ond
+ * work with that instead.
+ */
+int of_get_fb_videomode(struct device_node *np, struct fb_videomode *fb,
+			int index)
+{
+	struct videomode vm;
+	int ret;
+
+	ret = of_get_videomode(np, &vm, index);
+	if (ret)
+		return ret;
+
+	videomode_to_fb_videomode(&vm, fb);
+
+	pr_info("%s: got %dx%d display mode from %s\n", __func__, vm.hactive,
+		vm.vactive, np->name);
+	dump_fb_videomode(fb);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(of_get_fb_videomode);
+#endif
 
 #else
 int fb_parse_edid(unsigned char *edid, struct fb_var_screeninfo *var)
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 46c665b..9892fd6 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -14,6 +14,8 @@
 #include <linux/backlight.h>
 #include <linux/slab.h>
 #include <asm/io.h>
+#include <linux/of.h>
+#include <linux/of_videomode.h>
 
 struct vm_area_struct;
 struct fb_info;
@@ -714,6 +716,7 @@ extern void fb_destroy_modedb(struct fb_videomode *modedb);
 extern int fb_find_mode_cvt(struct fb_videomode *mode, int margins, int rb);
 extern unsigned char *fb_ddc_read(struct i2c_adapter *adapter);
 
+extern int of_get_fb_videomode(struct device_node *np, struct fb_videomode *fb, int index);
 extern int videomode_to_fb_videomode(struct videomode *vm, struct fb_videomode *fbmode);
 
 /* drivers/video/modedb.c */
-- 
1.7.10.4

