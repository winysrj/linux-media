Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41974 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab2KZJHx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Nov 2012 04:07:53 -0500
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
Subject: [PATCHv15 6/7] drm_modes: add videomode helpers
Date: Mon, 26 Nov 2012 10:07:27 +0100
Message-Id: <1353920848-1705-7-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1353920848-1705-1-git-send-email-s.trumtrar@pengutronix.de>
References: <1353920848-1705-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add conversion from videomode to drm_display_mode

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
Tested-by: Thierry Reding <thierry.reding@avionic-design.de>
Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
---
 drivers/gpu/drm/drm_modes.c |   37 +++++++++++++++++++++++++++++++++++++
 include/drm/drmP.h          |    7 +++++++
 2 files changed, 44 insertions(+)

diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
index 59450f3..8263ea1 100644
--- a/drivers/gpu/drm/drm_modes.c
+++ b/drivers/gpu/drm/drm_modes.c
@@ -33,6 +33,7 @@
 #include <linux/list.h>
 #include <linux/list_sort.h>
 #include <linux/export.h>
+#include <linux/videomode.h>
 #include <drm/drmP.h>
 #include <drm/drm_crtc.h>
 
@@ -504,6 +505,42 @@ drm_gtf_mode(struct drm_device *dev, int hdisplay, int vdisplay, int vrefresh,
 }
 EXPORT_SYMBOL(drm_gtf_mode);
 
+#if IS_ENABLED(CONFIG_VIDEOMODE)
+int drm_display_mode_from_videomode(const struct videomode *vm,
+				    struct drm_display_mode *dmode)
+{
+	dmode->hdisplay = vm->hactive;
+	dmode->hsync_start = dmode->hdisplay + vm->hfront_porch;
+	dmode->hsync_end = dmode->hsync_start + vm->hsync_len;
+	dmode->htotal = dmode->hsync_end + vm->hback_porch;
+
+	dmode->vdisplay = vm->vactive;
+	dmode->vsync_start = dmode->vdisplay + vm->vfront_porch;
+	dmode->vsync_end = dmode->vsync_start + vm->vsync_len;
+	dmode->vtotal = dmode->vsync_end + vm->vback_porch;
+
+	dmode->clock = vm->pixelclock / 1000;
+
+	dmode->flags = 0;
+	if (vm->hah)
+		dmode->flags |= DRM_MODE_FLAG_PHSYNC;
+	else
+		dmode->flags |= DRM_MODE_FLAG_NHSYNC;
+	if (vm->vah)
+		dmode->flags |= DRM_MODE_FLAG_PVSYNC;
+	else
+		dmode->flags |= DRM_MODE_FLAG_NVSYNC;
+	if (vm->interlaced)
+		dmode->flags |= DRM_MODE_FLAG_INTERLACE;
+	if (vm->doublescan)
+		dmode->flags |= DRM_MODE_FLAG_DBLSCAN;
+	drm_mode_set_name(dmode);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(drm_display_mode_from_videomode);
+#endif
+
 /**
  * drm_mode_set_name - set the name on a mode
  * @mode: name will be set in this mode
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 3fd8280..2194e97 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -85,6 +85,8 @@ struct module;
 struct drm_file;
 struct drm_device;
 
+struct videomode;
+
 #include <drm/drm_os_linux.h>
 #include <drm/drm_hashtab.h>
 #include <drm/drm_mm.h>
@@ -1454,6 +1456,11 @@ extern struct drm_display_mode *
 drm_mode_create_from_cmdline_mode(struct drm_device *dev,
 				  struct drm_cmdline_mode *cmd);
 
+#if IS_ENABLED(CONFIG_VIDEOMODE)
+extern int drm_display_mode_from_videomode(const struct videomode *vm,
+					   struct drm_display_mode *dmode);
+#endif
+
 /* Modesetting support */
 extern void drm_vblank_pre_modeset(struct drm_device *dev, int crtc);
 extern void drm_vblank_post_modeset(struct drm_device *dev, int crtc);
-- 
1.7.10.4

