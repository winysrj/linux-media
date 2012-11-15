Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46246 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767785Ab2KONPf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Nov 2012 08:15:35 -0500
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
Subject: [PATCH v11 5/6] drm_modes: add videomode helpers
Date: Thu, 15 Nov 2012 14:15:11 +0100
Message-Id: <1352985312-18178-6-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1352985312-18178-1-git-send-email-s.trumtrar@pengutronix.de>
References: <1352985312-18178-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add conversion from videomode to drm_display_mode

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
Tested-by: Thierry Reding <thierry.reding@avionic-design.de>
Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/gpu/drm/drm_modes.c |   37 +++++++++++++++++++++++++++++++++++++
 include/drm/drmP.h          |    6 ++++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
index 59450f3..23d951a0 100644
--- a/drivers/gpu/drm/drm_modes.c
+++ b/drivers/gpu/drm/drm_modes.c
@@ -35,6 +35,7 @@
 #include <linux/export.h>
 #include <drm/drmP.h>
 #include <drm/drm_crtc.h>
+#include <linux/videomode.h>
 
 /**
  * drm_mode_debug_printmodeline - debug print a mode
@@ -504,6 +505,42 @@ drm_gtf_mode(struct drm_device *dev, int hdisplay, int vdisplay, int vrefresh,
 }
 EXPORT_SYMBOL(drm_gtf_mode);
 
+#if IS_ENABLED(CONFIG_VIDEOMODE)
+int drm_display_mode_from_videomode(struct videomode *vm,
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
index 3fd8280..341049c 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -56,6 +56,7 @@
 #include <linux/cdev.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/videomode.h>
 #if defined(__alpha__) || defined(__powerpc__)
 #include <asm/pgtable.h>	/* For pte_wrprotect */
 #endif
@@ -1454,6 +1455,11 @@ extern struct drm_display_mode *
 drm_mode_create_from_cmdline_mode(struct drm_device *dev,
 				  struct drm_cmdline_mode *cmd);
 
+#if IS_ENABLED(CONFIG_VIDEOMODE)
+extern int drm_display_mode_from_videomode(struct videomode *vm,
+					   struct drm_display_mode *dmode);
+#endif
+
 /* Modesetting support */
 extern void drm_vblank_pre_modeset(struct drm_device *dev, int crtc);
 extern void drm_vblank_post_modeset(struct drm_device *dev, int crtc);
-- 
1.7.10.4

