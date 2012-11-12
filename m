Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33169 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab2KLPiQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Nov 2012 10:38:16 -0500
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
Subject: [PATCH v8 6/6] drm_modes: add of_videomode helpers
Date: Mon, 12 Nov 2012 16:37:06 +0100
Message-Id: <1352734626-27412-7-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1352734626-27412-1-git-send-email-s.trumtrar@pengutronix.de>
References: <1352734626-27412-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add helper to get drm_display_mode from devicetree.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
---
 drivers/gpu/drm/drm_modes.c |   41 +++++++++++++++++++++++++++++++++++++++++
 include/drm/drmP.h          |    5 +++++
 2 files changed, 46 insertions(+)

diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
index 049624d..c77da59 100644
--- a/drivers/gpu/drm/drm_modes.c
+++ b/drivers/gpu/drm/drm_modes.c
@@ -35,6 +35,7 @@
 #include <linux/export.h>
 #include <drm/drmP.h>
 #include <drm/drm_crtc.h>
+#include <linux/of.h>
 #include <linux/videomode.h>
 
 /**
@@ -540,6 +541,46 @@ int videomode_to_display_mode(struct videomode *vm, struct drm_display_mode *dmo
 EXPORT_SYMBOL_GPL(videomode_to_display_mode);
 #endif
 
+#if IS_ENABLED(CONFIG_OF_VIDEOMODE)
+static void dump_drm_displaymode(struct drm_display_mode *m)
+{
+	pr_debug("drm_displaymode = %d %d %d %d %d %d %d %d %d\n",
+		 m->hdisplay, m->hsync_start, m->hsync_end, m->htotal,
+		 m->vdisplay, m->vsync_start, m->vsync_end, m->vtotal,
+		 m->clock);
+}
+
+/**
+ * of_get_drm_display_mode - get a drm_display_mode from devicetree
+ * @np: device_node with the timing specification
+ * @dmode: will be set to the return value
+ * @index: index into the list of display timings in devicetree
+ * 
+ * This function is expensive and should only be used, if only one mode is to be
+ * read from DT. To get multiple modes start with of_get_display_timings and
+ * work with that instead.
+ */
+int of_get_drm_display_mode(struct device_node *np, struct drm_display_mode *dmode,
+			int index)
+{
+	struct videomode vm;
+	int ret;
+
+	ret = of_get_videomode(np, &vm, index);
+	if (ret)
+		return ret;
+
+	videomode_to_display_mode(&vm, dmode);
+
+	pr_info("%s: got %dx%d display mode from %s\n", __func__, vm.hactive,
+		vm.vactive, np->name);
+	dump_drm_displaymode(dmode);
+
+	return 0;
+
+}
+EXPORT_SYMBOL_GPL(of_get_drm_display_mode);
+#endif
 /**
  * drm_mode_set_name - set the name on a mode
  * @mode: name will be set in this mode
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index e9fa1e3..4f9c44e 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -56,6 +56,7 @@
 #include <linux/cdev.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/of.h>
 #include <linux/videomode.h>
 #if defined(__alpha__) || defined(__powerpc__)
 #include <asm/pgtable.h>	/* For pte_wrprotect */
@@ -1457,6 +1458,10 @@ drm_mode_create_from_cmdline_mode(struct drm_device *dev,
 
 extern int videomode_to_display_mode(struct videomode *vm,
 				     struct drm_display_mode *dmode);
+extern int of_get_drm_display_mode(struct device_node *np,
+				   struct drm_display_mode *dmode,
+				   int index);
+
 /* Modesetting support */
 extern void drm_vblank_pre_modeset(struct drm_device *dev, int crtc);
 extern void drm_vblank_post_modeset(struct drm_device *dev, int crtc);
-- 
1.7.10.4

