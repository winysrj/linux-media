Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55095 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801Ab3AYJCf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 04:02:35 -0500
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: devicetree-discuss@lists.ozlabs.org, Dave Airlie <airlied@linux.ie>
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
Subject: [PATCH v17 7/7] drm_modes: add of_videomode helpers
Date: Fri, 25 Jan 2013 10:01:55 +0100
Message-Id: <1359104515-8907-8-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1359104515-8907-1-git-send-email-s.trumtrar@pengutronix.de>
References: <1359104515-8907-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add helper to get drm_display_mode from devicetree.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
Tested-by: Thierry Reding <thierry.reding@avionic-design.de>
Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Afzal Mohammed <Afzal@ti.com>
Tested-by: Rob Clark <robclark@gmail.com>
Tested-by: Leela Krishna Amudala <leelakrishna.a@gmail.com>
---
 drivers/gpu/drm/drm_modes.c |   33 +++++++++++++++++++++++++++++++++
 include/drm/drmP.h          |    4 ++++
 2 files changed, 37 insertions(+)

diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
index 9f3f20b..04fa6f1 100644
--- a/drivers/gpu/drm/drm_modes.c
+++ b/drivers/gpu/drm/drm_modes.c
@@ -35,6 +35,7 @@
 #include <linux/export.h>
 #include <drm/drmP.h>
 #include <drm/drm_crtc.h>
+#include <video/of_videomode.h>
 #include <video/videomode.h>
 
 /**
@@ -541,6 +542,38 @@ int drm_display_mode_from_videomode(const struct videomode *vm,
 EXPORT_SYMBOL_GPL(drm_display_mode_from_videomode);
 #endif
 
+#if IS_ENABLED(CONFIG_OF_VIDEOMODE)
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
+int of_get_drm_display_mode(struct device_node *np,
+			    struct drm_display_mode *dmode, int index)
+{
+	struct videomode vm;
+	int ret;
+
+	ret = of_get_videomode(np, &vm, index);
+	if (ret)
+		return ret;
+
+	drm_display_mode_from_videomode(&vm, dmode);
+
+	pr_debug("%s: got %dx%d display mode from %s\n",
+		of_node_full_name(np), vm.hactive, vm.vactive, np->name);
+	drm_mode_debug_printmodeline(dmode);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(of_get_drm_display_mode);
+#endif
+
 /**
  * drm_mode_set_name - set the name on a mode
  * @mode: name will be set in this mode
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index d5c06ff..fcc9d23 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -85,6 +85,7 @@ struct module;
 struct drm_file;
 struct drm_device;
 
+struct device_node;
 struct videomode;
 
 #include <drm/drm_os_linux.h>
@@ -1460,6 +1461,9 @@ drm_mode_create_from_cmdline_mode(struct drm_device *dev,
 
 extern int drm_display_mode_from_videomode(const struct videomode *vm,
 					   struct drm_display_mode *dmode);
+extern int of_get_drm_display_mode(struct device_node *np,
+				   struct drm_display_mode *dmode,
+				   int index);
 
 /* Modesetting support */
 extern void drm_vblank_pre_modeset(struct drm_device *dev, int crtc);
-- 
1.7.10.4

