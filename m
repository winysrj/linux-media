Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39469 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520Ab2IXPg7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 11:36:59 -0400
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: devicetree-discuss@lists.ozlabs.org
Cc: Rob Herring <robherring2@gmail.com>, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	kernel@pengutronix.de, linux-media@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [PATCH 2/2] video: add generic videomode description
Date: Mon, 24 Sep 2012 17:35:24 +0200
Message-Id: <1348500924-8551-3-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1348500924-8551-1-git-send-email-s.trumtrar@pengutronix.de>
References: <1348500924-8551-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Backend-independent videomode. At the moment this is not very different
from fb_mode or drm_mode.
It is supposed to be a generic description of videomodes and conversion
step to the desired backend video mode representation.
At the moment, only really makes sense when used with of_display

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
---
 drivers/video/Makefile    |    1 +
 drivers/video/videomode.c |  146 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/videomode.h |   38 ++++++++++++
 3 files changed, 185 insertions(+)
 create mode 100644 drivers/video/videomode.c
 create mode 100644 include/linux/videomode.h

diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index ee8dafb..6a02fe0 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -170,3 +170,4 @@ obj-$(CONFIG_FB_VIRTUAL)          += vfb.o
 
 #video output switch sysfs driver
 obj-$(CONFIG_VIDEO_OUTPUT_CONTROL) += output.o
+obj-y				   += videomode.o
diff --git a/drivers/video/videomode.c b/drivers/video/videomode.c
new file mode 100644
index 0000000..b118d00
--- /dev/null
+++ b/drivers/video/videomode.c
@@ -0,0 +1,146 @@
+/*
+ * generic videomode helper
+ *
+ * Copyright (c) 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>, Pengutronix
+ *
+ * This file is released under the GPLv2
+ */
+#include <linux/of.h>
+#include <linux/fb.h>
+#include <linux/slab.h>
+#include <drm/drm_mode.h>
+#include <linux/display.h>
+#include <linux/videomode.h>
+
+struct videomode *videomode_from_display(struct display *disp, int index)
+{
+	struct videomode *vm;
+	struct signal_timing *st;
+
+	vm = kmalloc(sizeof(struct videomode *), GFP_KERNEL);
+
+	if (!vm)
+		return NULL;
+
+	st = display_get_timing(disp, index);
+
+	vm->pixelclock = signal_timing_get_value(&st->pixelclock, 0);
+	vm->hactive = signal_timing_get_value(&st->hactive, 0);
+	vm->hfront_porch = signal_timing_get_value(&st->hfront_porch, 0);
+	vm->hback_porch = signal_timing_get_value(&st->hback_porch, 0);
+	vm->hsync_len = signal_timing_get_value(&st->hsync_len, 0);
+
+	vm->vactive = signal_timing_get_value(&st->vactive, 0);
+	vm->vfront_porch = signal_timing_get_value(&st->vfront_porch, 0);
+	vm->vback_porch = signal_timing_get_value(&st->vback_porch, 0);
+	vm->vsync_len = signal_timing_get_value(&st->vsync_len, 0);
+
+	vm->vah = disp->vsync_pol_active_high;
+	vm->hah = disp->hsync_pol_active_high;
+
+	return vm;
+}
+
+#if defined(CONFIG_DRM)
+int videomode_to_display_mode(struct videomode *vm, struct drm_display_mode *dmode)
+{
+	memset(dmode, 0, sizeof(*dmode));
+
+	dmode->hdisplay = vm->hactive;
+	dmode->hsync_start = dmode->hdisplay + vm->hfront_porch;
+	dmode->hsync_end = dmode->hsync_start + vm->hsync_len;
+	dmode->htotal = dmode->hsync_end + vm->hback_porch;
+
+	dmode->vdisplay = vm->vactive;
+	dmode->vsync_start = dmode->vdisplay + vm->vfront_porch;
+	dmode->vsync_end = dmode->vsync_start + vm->vsync_len;
+	dmode->vtotal = dmode->vtotal + vm->vback_porch;
+
+	dmode->clock = vm->pixelclock / 1000;
+
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
+EXPORT_SYMBOL_GPL(videomode_to_display_mode);
+#else
+int videomode_to_displaymode(struct videomode *vm, struct drm_display_mode *dmode)
+{
+	return 0;
+}
+#endif
+
+int videomode_to_fb_videomode(struct videomode *vm, struct fb_videomode *fbmode)
+{
+	memset(fbmode, 0, sizeof(*fbmode));
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
+	fbmode->pixclock = KHZ2PICOS(vm->pixelclock) / 1000;
+
+	if (vm->hah)
+		fbmode->sync |= FB_SYNC_HOR_HIGH_ACT;
+	if (vm->vah)
+		fbmode->sync |= FB_SYNC_VERT_HIGH_ACT;
+	if (vm->interlaced)
+		fbmode->vmode |= FB_VMODE_INTERLACED;
+	if (vm->doublescan)
+		fbmode->vmode |= FB_VMODE_DOUBLE;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(videomode_to_fb_videomode);
+
+int of_get_display_mode(struct device_node *np, struct drm_display_mode *dmode, int index)
+{
+	struct videomode *vm;
+	struct display *disp;
+
+	disp = of_get_display(np);
+
+	if (!disp) {
+		pr_err("%s: no display specified\n", __func__);
+		return -EINVAL;
+	}
+
+	if (index == OF_DEFAULT_TIMING)
+		index = disp->default_timing;
+
+	vm = videomode_from_display(disp, index);
+
+	if (!vm) {
+		pr_err("%s: could not get videomode %d\n", __func__, index);
+		return -EINVAL;
+	}
+
+	videomode_to_display_mode(vm, dmode);
+
+	pr_info("%s: got %dx%d display mode from %s\n", __func__, vm->hactive, vm->vactive, np->name);
+
+	display_release(disp);
+	kfree(vm);
+
+	return 0;
+
+}
+EXPORT_SYMBOL_GPL(of_get_display_mode);
diff --git a/include/linux/videomode.h b/include/linux/videomode.h
new file mode 100644
index 0000000..100c88b
--- /dev/null
+++ b/include/linux/videomode.h
@@ -0,0 +1,38 @@
+/*
+ * Copyright 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>
+ *
+ * generic videomode description
+ *
+ * This file is released under the GPLv2
+ */
+
+#ifndef __LINUX_VIDEOMODE_H
+#define __LINUX_VIDEOMODE_H
+
+#include <drm/drmP.h>
+
+struct videomode {
+	u32 pixelclock;
+	u32 refreshrate;
+
+	u32 hactive;
+	u32 hfront_porch;
+	u32 hback_porch;
+	u32 hsync_len;
+
+	u32 vactive;
+	u32 vfront_porch;
+	u32 vback_porch;
+	u32 vsync_len;
+
+	bool hah;
+	bool vah;
+	bool interlaced;
+	bool doublescan;
+
+};
+
+int videomode_to_display_mode(struct videomode *vm, struct drm_display_mode *dmode);
+int videomode_to_fb_videomode(struct videomode *vm, struct fb_videomode *fbmode);
+int of_get_display_mode(struct device_node *np, struct drm_display_mode *dmode, int index);
+#endif /* __LINUX_VIDEOMODE_H */
-- 
1.7.10.4

