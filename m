Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40361 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab3AULIz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jan 2013 06:08:55 -0500
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: devicetree-discuss@lists.ozlabs.org,
	David Airlie <airlied@linux.ie>
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	"Rob Herring" <robherring2@gmail.com>, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	"Thierry Reding" <thierry.reding@avionic-design.de>,
	"Guennady Liakhovetski" <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	"Tomi Valkeinen" <tomi.valkeinen@ti.com>,
	"Stephen Warren" <swarren@wwwdotorg.org>,
	"Florian Tobias Schandinat" <FlorianSchandinat@gmx.de>,
	"Rob Clark" <robdclark@gmail.com>,
	"Leela Krishna Amudala" <leelakrishna.a@gmail.com>,
	"Mohammed, Afzal" <afzal@ti.com>, kernel@pengutronix.de
Subject: [PATCH v16 RESEND 5/7] fbmon: add of_videomode helpers
Date: Mon, 21 Jan 2013 12:08:00 +0100
Message-Id: <1358766482-6275-6-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1358766482-6275-1-git-send-email-s.trumtrar@pengutronix.de>
References: <1358766482-6275-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add helper to get fb_videomode from devicetree.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
Tested-by: Thierry Reding <thierry.reding@avionic-design.de>
Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Afzal Mohammed <Afzal@ti.com>
---
 drivers/video/fbmon.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/fb.h    |    4 ++++
 2 files changed, 46 insertions(+)

diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
index 17ce135..94ad0f7 100644
--- a/drivers/video/fbmon.c
+++ b/drivers/video/fbmon.c
@@ -31,6 +31,7 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <video/edid.h>
+#include <video/of_videomode.h>
 #include <video/videomode.h>
 #ifdef CONFIG_PPC_OF
 #include <asm/prom.h>
@@ -1425,6 +1426,47 @@ int fb_videomode_from_videomode(const struct videomode *vm,
 EXPORT_SYMBOL_GPL(fb_videomode_from_videomode);
 #endif
 
+#if IS_ENABLED(CONFIG_OF_VIDEOMODE)
+static inline void dump_fb_videomode(const struct fb_videomode *m)
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
+ * read from DT. To get multiple modes start with of_get_display_timings ond
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
+	fb_videomode_from_videomode(&vm, fb);
+
+	pr_debug("%s: got %dx%d display mode from %s\n",
+		of_node_full_name(np), vm.hactive, vm.vactive, np->name);
+	dump_fb_videomode(fb);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(of_get_fb_videomode);
+#endif
+
 #else
 int fb_parse_edid(unsigned char *edid, struct fb_var_screeninfo *var)
 {
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 100a176..58b9860 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -20,6 +20,7 @@ struct fb_info;
 struct device;
 struct file;
 struct videomode;
+struct device_node;
 
 /* Definitions below are used in the parsed monitor specs */
 #define FB_DPMS_ACTIVE_OFF	1
@@ -715,6 +716,9 @@ extern void fb_destroy_modedb(struct fb_videomode *modedb);
 extern int fb_find_mode_cvt(struct fb_videomode *mode, int margins, int rb);
 extern unsigned char *fb_ddc_read(struct i2c_adapter *adapter);
 
+extern int of_get_fb_videomode(struct device_node *np,
+			       struct fb_videomode *fb,
+			       int index);
 extern int fb_videomode_from_videomode(const struct videomode *vm,
 				       struct fb_videomode *fbmode);
 
-- 
1.7.10.4

