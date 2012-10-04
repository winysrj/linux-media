Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51963 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab2JDR7r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 13:59:47 -0400
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: devicetree-discuss@lists.ozlabs.org
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	Rob Herring <robherring2@gmail.com>,
	<linux-fbdev@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	<linux-media@vger.kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 2/2 v6] of: add generic videomode description
Date: Thu,  4 Oct 2012 19:59:20 +0200
Message-Id: <1349373560-11128-3-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de>
References: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Get videomode from devicetree in a format appropriate for the
backend. drm_display_mode and fb_videomode are supported atm.
Uses the display signal timings from of_display_timings

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
---
 drivers/of/Kconfig           |    5 +
 drivers/of/Makefile          |    1 +
 drivers/of/of_videomode.c    |  212 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/of_videomode.h |   41 ++++++++
 4 files changed, 259 insertions(+)
 create mode 100644 drivers/of/of_videomode.c
 create mode 100644 include/linux/of_videomode.h

diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index 646deb0..74282e2 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -88,4 +88,9 @@ config OF_DISPLAY_TIMINGS
 	help
 	  helper to parse display timings from the devicetree
 
+config OF_VIDEOMODE
+	def_bool y
+	help
+	  helper to get videomodes from the devicetree
+
 endmenu # OF
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index c8e9603..09d556f 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_OF_PCI)	+= of_pci.o
 obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
 obj-$(CONFIG_OF_MTD)	+= of_mtd.o
 obj-$(CONFIG_OF_DISPLAY_TIMINGS) += of_display_timings.o
+obj-$(CONFIG_OF_VIDEOMODE) += of_videomode.o
diff --git a/drivers/of/of_videomode.c b/drivers/of/of_videomode.c
new file mode 100644
index 0000000..76ac16e
--- /dev/null
+++ b/drivers/of/of_videomode.c
@@ -0,0 +1,212 @@
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
+#include <linux/of_display_timings.h>
+#include <linux/of_videomode.h>
+
+void dump_fb_videomode(struct fb_videomode *m)
+{
+        pr_debug("fb_videomode = %d %d %d %d %d %d %d %d %d %d %d %d %d\n",
+                m->refresh, m->xres, m->yres, m->pixclock, m->left_margin,
+                m->right_margin, m->upper_margin, m->lower_margin,
+                m->hsync_len, m->vsync_len, m->sync, m->vmode, m->flag);
+}
+
+void dump_drm_displaymode(struct drm_display_mode *m)
+{
+        pr_debug("drm_displaymode = %d %d %d %d %d %d %d %d %d\n",
+                m->hdisplay, m->hsync_start, m->hsync_end, m->htotal,
+                m->vdisplay, m->vsync_start, m->vsync_end, m->vtotal,
+                m->clock);
+}
+
+int videomode_from_timing(struct display_timings *disp, struct videomode *vm,
+			int index)
+{
+	struct signal_timing *st = NULL;
+
+	if (!vm)
+		return -EINVAL;
+
+	st = display_timings_get(disp, index);
+
+	if (!st) {
+		pr_err("%s: no signal timings found\n", __func__);
+		return -EINVAL;
+	}
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
+	vm->vah = st->vsync_pol_active_high;
+	vm->hah = st->hsync_pol_active_high;
+	vm->interlaced = st->interlaced;
+	vm->doublescan = st->doublescan;
+
+	return 0;
+}
+
+int of_get_videomode(struct device_node *np, struct videomode *vm, int index)
+{
+	struct display_timings *disp;
+	int ret = 0;
+
+	disp = of_get_display_timing_list(np);
+
+	if (!disp) {
+		pr_err("%s: no timings specified\n", __func__);
+		return -EINVAL;
+	}
+
+	if (index == OF_DEFAULT_TIMING)
+		index = disp->default_timing;
+
+	ret = videomode_from_timing(disp, vm, index);
+
+	if (ret)
+		return ret;
+
+	display_timings_release(disp);
+
+	if (!vm) {
+		pr_err("%s: could not get videomode %d\n", __func__, index);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(of_get_videomode);
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
+	dmode->vtotal = dmode->vsync_end + vm->vback_porch;
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
+
+int of_get_drm_display_mode(struct device_node *np, struct drm_display_mode *dmode,
+			int index)
+{
+	struct videomode vm;
+	int ret;
+
+	ret = of_get_videomode(np, &vm, index);
+
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
+#else
+int videomode_to_display_mode(struct videomode *vm, struct drm_display_mode *dmode)
+{
+	return 0;
+}
+
+int of_get_drm_display_mode(struct device_node *np, struct drm_display_mode *dmode,
+			int index)
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
+EXPORT_SYMBOL_GPL(of_get_drm_display_mode);
diff --git a/include/linux/of_videomode.h b/include/linux/of_videomode.h
new file mode 100644
index 0000000..96efe01
--- /dev/null
+++ b/include/linux/of_videomode.h
@@ -0,0 +1,41 @@
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
+int of_get_videomode(struct device_node *np, struct videomode *vm, int index);
+int of_get_drm_display_mode(struct device_node *np, struct drm_display_mode *dmode,
+			int index);
+int of_get_fb_videomode(struct device_node *np, struct fb_videomode *fb, int index);
+#endif /* __LINUX_VIDEOMODE_H */
-- 
1.7.10.4

