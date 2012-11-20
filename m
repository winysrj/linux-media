Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39085 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab2KTP4G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Nov 2012 10:56:06 -0500
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
	"Stephen Warren" <swarren@wwwdotorg.org>, kernel@pengutronix.de,
	"Florian Tobias Schandinat" <FlorianSchandinat@gmx.de>,
	"David Airlie" <airlied@linux.ie>
Subject: [PATCH v12 4/6] fbmon: add of_videomode helpers
Date: Tue, 20 Nov 2012 16:54:54 +0100
Message-Id: <1353426896-6045-5-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1353426896-6045-1-git-send-email-s.trumtrar@pengutronix.de>
References: <1353426896-6045-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add helper to get fb_videomode from devicetree.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
Tested-by: Thierry Reding <thierry.reding@avionic-design.de>
Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/video/fbmon.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 include/linux/fb.h    |    7 +++++++
 2 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
index c1939a6..16c353c 100644
--- a/drivers/video/fbmon.c
+++ b/drivers/video/fbmon.c
@@ -31,7 +31,7 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <video/edid.h>
-#include <linux/videomode.h>
+#include <linux/of_videomode.h>
 #ifdef CONFIG_PPC_OF
 #include <asm/prom.h>
 #include <asm/pci-bridge.h>
@@ -1418,6 +1418,46 @@ int fb_videomode_from_videomode(const struct videomode *vm,
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
+int of_get_fb_videomode(const struct device_node *np, struct fb_videomode *fb,
+			unsigned int index)
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
index 920cbe3..41b5e49 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -15,6 +15,8 @@
 #include <linux/slab.h>
 #include <asm/io.h>
 #include <linux/videomode.h>
+#include <linux/of.h>
+#include <linux/of_videomode.h>
 
 struct vm_area_struct;
 struct fb_info;
@@ -715,6 +717,11 @@ extern void fb_destroy_modedb(struct fb_videomode *modedb);
 extern int fb_find_mode_cvt(struct fb_videomode *mode, int margins, int rb);
 extern unsigned char *fb_ddc_read(struct i2c_adapter *adapter);
 
+#if IS_ENABLED(CONFIG_OF_VIDEOMODE)
+extern int of_get_fb_videomode(const struct device_node *np,
+			       struct fb_videomode *fb,
+			       unsigned int index);
+#endif
 #if IS_ENABLED(CONFIG_VIDEOMODE)
 extern int fb_videomode_from_videomode(const struct videomode *vm,
 				       struct fb_videomode *fbmode);
-- 
1.7.10.4

