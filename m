Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40338 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab3AULIq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jan 2013 06:08:46 -0500
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
Subject: [PATCH v16 RESEND 6/7] drm_modes: add videomode helpers
Date: Mon, 21 Jan 2013 12:08:01 +0100
Message-Id: <1358766482-6275-7-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1358766482-6275-1-git-send-email-s.trumtrar@pengutronix.de>
References: <1358766482-6275-1-git-send-email-s.trumtrar@pengutronix.de>
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
Tested-by: Afzal Mohammed <Afzal@ti.com>
---
 drivers/gpu/drm/drm_modes.c |   37 +++++++++++++++++++++++++++++++++++++
 include/drm/drmP.h          |    5 +++++
 2 files changed, 42 insertions(+)

diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
index 59450f3..184a22d 100644
--- a/drivers/gpu/drm/drm_modes.c
+++ b/drivers/gpu/drm/drm_modes.c
@@ -35,6 +35,7 @@
 #include <linux/export.h>
 #include <drm/drmP.h>
 #include <drm/drm_crtc.h>
+#include <video/videomode.h>
 
 /**
  * drm_mode_debug_printmodeline - debug print a mode
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
+	if (vm->dmt_flags & VESA_DMT_HSYNC_HIGH)
+		dmode->flags |= DRM_MODE_FLAG_PHSYNC;
+	else if (vm->dmt_flags & VESA_DMT_HSYNC_LOW)
+		dmode->flags |= DRM_MODE_FLAG_NHSYNC;
+	if (vm->dmt_flags & VESA_DMT_VSYNC_HIGH)
+		dmode->flags |= DRM_MODE_FLAG_PVSYNC;
+	else if (vm->dmt_flags & VESA_DMT_VSYNC_LOW)
+		dmode->flags |= DRM_MODE_FLAG_NVSYNC;
+	if (vm->data_flags & DISPLAY_FLAGS_INTERLACED)
+		dmode->flags |= DRM_MODE_FLAG_INTERLACE;
+	if (vm->data_flags & DISPLAY_FLAGS_DOUBLESCAN)
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
index 3fd8280..5fbb0fe 100644
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
@@ -1454,6 +1456,9 @@ extern struct drm_display_mode *
 drm_mode_create_from_cmdline_mode(struct drm_device *dev,
 				  struct drm_cmdline_mode *cmd);
 
+extern int drm_display_mode_from_videomode(const struct videomode *vm,
+					   struct drm_display_mode *dmode);
+
 /* Modesetting support */
 extern void drm_vblank_pre_modeset(struct drm_device *dev, int crtc);
 extern void drm_vblank_post_modeset(struct drm_device *dev, int crtc);
-- 
1.7.10.4

