Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44952 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbbCPXvw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 19:51:52 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH] drm: rcar-du: Implement write-back support
Date: Tue, 17 Mar 2015 01:51:54 +0200
Message-Id: <1426549914-27920-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The R-Car DU supports writing back the display unit output to memory.
Add support for that feature using a V4L2 device.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/gpu/drm/rcar-du/Makefile        |   3 +-
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c  |  47 +-
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h  |   7 +
 drivers/gpu/drm/rcar-du/rcar_du_drv.c   |   8 +
 drivers/gpu/drm/rcar-du/rcar_du_drv.h   |   4 +
 drivers/gpu/drm/rcar-du/rcar_du_kms.c   |   8 +-
 drivers/gpu/drm/rcar-du/rcar_du_kms.h   |   5 +
 drivers/gpu/drm/rcar-du/rcar_du_regs.h  |   4 +
 drivers/gpu/drm/rcar-du/rcar_du_wback.c | 792 ++++++++++++++++++++++++++++++++
 drivers/gpu/drm/rcar-du/rcar_du_wback.h | 102 ++++
 10 files changed, 969 insertions(+), 11 deletions(-)
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_wback.c
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_wback.h

Hello,

This is (to my knowledge) the first attempt to use V4L2 as a capture API for
the write-back feature or a DRM/KMS device.

Overall the implementation isn't very intrusive and keeps the V4L2 API
implementation pretty much in a single source file. I'm quite happy with the
architecture, let's now see how the cross-subsystem review will affect that
mood :-)

diff --git a/drivers/gpu/drm/rcar-du/Makefile b/drivers/gpu/drm/rcar-du/Makefile
index 05de1c4097af..65050435cbb9 100644
--- a/drivers/gpu/drm/rcar-du/Makefile
+++ b/drivers/gpu/drm/rcar-du/Makefile
@@ -5,7 +5,8 @@ rcar-du-drm-y := rcar_du_crtc.o \
 		 rcar_du_kms.o \
 		 rcar_du_lvdscon.o \
 		 rcar_du_plane.o \
-		 rcar_du_vgacon.o
+		 rcar_du_vgacon.o \
+		 rcar_du_wback.o
 
 rcar-du-drm-$(CONFIG_DRM_RCAR_HDMI)	+= rcar_du_hdmicon.o \
 					   rcar_du_hdmienc.o
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
index 9e72133bb64b..479f14886ec1 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
@@ -28,6 +28,7 @@
 #include "rcar_du_kms.h"
 #include "rcar_du_plane.h"
 #include "rcar_du_regs.h"
+#include "rcar_du_wback.h"
 
 static u32 rcar_du_crtc_read(struct rcar_du_crtc *rcrtc, u32 reg)
 {
@@ -68,7 +69,7 @@ static void rcar_du_crtc_clr_set(struct rcar_du_crtc *rcrtc, u32 reg,
 	rcar_du_write(rcdu, rcrtc->mmio_offset + reg, (value & ~clr) | set);
 }
 
-static int rcar_du_crtc_get(struct rcar_du_crtc *rcrtc)
+int rcar_du_crtc_get(struct rcar_du_crtc *rcrtc)
 {
 	int ret;
 
@@ -93,7 +94,7 @@ error_clock:
 	return ret;
 }
 
-static void rcar_du_crtc_put(struct rcar_du_crtc *rcrtc)
+void rcar_du_crtc_put(struct rcar_du_crtc *rcrtc)
 {
 	rcar_du_group_put(rcrtc->group);
 
@@ -173,6 +174,13 @@ static void rcar_du_crtc_set_display_timing(struct rcar_du_crtc *rcrtc)
 
 	rcar_du_crtc_write(rcrtc, DESR,  mode->htotal - mode->hsync_start);
 	rcar_du_crtc_write(rcrtc, DEWR,  mode->hdisplay);
+
+	/* Program the raster interrupt offset (used by the writeback state
+	 * machine) to generate an interrupt as far as possible from the start
+	 * of vertical blanking.
+	 */
+	rcar_du_crtc_write(rcrtc, RINTOFSR,
+			   max(mode->crtc_vdisplay - mode->crtc_vtotal / 2, 1));
 }
 
 void rcar_du_crtc_route_output(struct drm_crtc *crtc,
@@ -511,9 +519,17 @@ static const struct drm_crtc_helper_funcs crtc_helper_funcs = {
 	.atomic_flush = rcar_du_crtc_atomic_flush,
 };
 
+static void rcar_du_crtc_destroy(struct drm_crtc *crtc)
+{
+	struct rcar_du_crtc *rcrtc = to_rcar_crtc(crtc);
+
+	rcar_du_wback_cleanup_crtc(rcrtc);
+	drm_crtc_cleanup(crtc);
+}
+
 static const struct drm_crtc_funcs crtc_funcs = {
 	.reset = drm_atomic_helper_crtc_reset,
-	.destroy = drm_crtc_cleanup,
+	.destroy = rcar_du_crtc_destroy,
 	.set_config = drm_atomic_helper_set_config,
 	.page_flip = drm_atomic_helper_page_flip,
 	.atomic_duplicate_state = drm_atomic_helper_crtc_duplicate_state,
@@ -527,19 +543,20 @@ static const struct drm_crtc_funcs crtc_funcs = {
 static irqreturn_t rcar_du_crtc_irq(int irq, void *arg)
 {
 	struct rcar_du_crtc *rcrtc = arg;
-	irqreturn_t ret = IRQ_NONE;
 	u32 status;
 
 	status = rcar_du_crtc_read(rcrtc, DSSR);
+
+	rcar_du_wback_irq(&rcrtc->wback, status);
+
 	rcar_du_crtc_write(rcrtc, DSRCR, status & DSRCR_MASK);
 
 	if (status & DSSR_FRM) {
 		drm_handle_vblank(rcrtc->crtc.dev, rcrtc->index);
 		rcar_du_crtc_finish_page_flip(rcrtc);
-		ret = IRQ_HANDLED;
 	}
 
-	return ret;
+	return status & (DSSR_FRM | DSSR_RINT) ? IRQ_HANDLED : IRQ_NONE;
 }
 
 /* -----------------------------------------------------------------------------
@@ -626,9 +643,27 @@ int rcar_du_crtc_create(struct rcar_du_group *rgrp, unsigned int index)
 		return ret;
 	}
 
+	ret = rcar_du_wback_init_crtc(rcrtc);
+	if (ret < 0) {
+		dev_err(rcdu->dev,
+			"write-back initialization failed for CRTC %u\n",
+			index);
+		return ret;
+	}
+
 	return 0;
 }
 
+void rcar_du_crtc_enable_rint(struct rcar_du_crtc *rcrtc, bool enable)
+{
+	if (enable) {
+		rcar_du_crtc_write(rcrtc, DSRCR, DSRCR_RICL);
+		rcar_du_crtc_set(rcrtc, DIER, DIER_RIE);
+	} else {
+		rcar_du_crtc_clr(rcrtc, DIER, DIER_RIE);
+	}
+}
+
 void rcar_du_crtc_enable_vblank(struct rcar_du_crtc *rcrtc, bool enable)
 {
 	if (enable) {
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
index 5d9aa9b33769..84ee5e3eb2d2 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
@@ -20,6 +20,8 @@
 #include <drm/drmP.h>
 #include <drm/drm_crtc.h>
 
+#include "rcar_du_wback.h"
+
 struct rcar_du_group;
 
 struct rcar_du_crtc {
@@ -38,6 +40,7 @@ struct rcar_du_crtc {
 	bool enabled;
 
 	struct rcar_du_group *group;
+	struct rcar_du_wback wback;
 };
 
 #define to_rcar_crtc(c)	container_of(c, struct rcar_du_crtc, crtc)
@@ -52,6 +55,7 @@ enum rcar_du_output {
 };
 
 int rcar_du_crtc_create(struct rcar_du_group *rgrp, unsigned int index);
+void rcar_du_crtc_enable_rint(struct rcar_du_crtc *rcrtc, bool enable);
 void rcar_du_crtc_enable_vblank(struct rcar_du_crtc *rcrtc, bool enable);
 void rcar_du_crtc_cancel_page_flip(struct rcar_du_crtc *rcrtc,
 				   struct drm_file *file);
@@ -61,4 +65,7 @@ void rcar_du_crtc_resume(struct rcar_du_crtc *rcrtc);
 void rcar_du_crtc_route_output(struct drm_crtc *crtc,
 			       enum rcar_du_output output);
 
+int rcar_du_crtc_get(struct rcar_du_crtc *rcrtc);
+void rcar_du_crtc_put(struct rcar_du_crtc *rcrtc);
+
 #endif /* __RCAR_DU_CRTC_H__ */
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_drv.c b/drivers/gpu/drm/rcar-du/rcar_du_drv.c
index 1d9e4f8568ae..c7f94948153a 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_drv.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_drv.c
@@ -139,6 +139,8 @@ static int rcar_du_unload(struct drm_device *dev)
 	drm_mode_config_cleanup(dev);
 	drm_vblank_cleanup(dev);
 
+	rcar_du_wback_cleanup(rcdu);
+
 	dev->irq_enabled = 0;
 	dev->dev_private = NULL;
 
@@ -187,6 +189,12 @@ static int rcar_du_load(struct drm_device *dev, unsigned long flags)
 		goto done;
 	}
 
+	ret = rcar_du_wback_init(rcdu);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to initialize write-back\n");
+		goto done;
+	}
+
 	/* DRM/KMS objects */
 	ret = rcar_du_modeset_init(rcdu);
 	if (ret < 0) {
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_drv.h b/drivers/gpu/drm/rcar-du/rcar_du_drv.h
index c7c538dd2e68..b95f6de1c3bb 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_drv.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_drv.h
@@ -17,6 +17,8 @@
 #include <linux/kernel.h>
 #include <linux/wait.h>
 
+#include <media/v4l2-device.h>
+
 #include "rcar_du_crtc.h"
 #include "rcar_du_group.h"
 
@@ -73,6 +75,8 @@ struct rcar_du_device {
 	struct device *dev;
 	const struct rcar_du_device_info *info;
 
+	struct v4l2_device v4l2_dev;
+
 	void __iomem *mmio;
 
 	struct drm_device *ddev;
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_kms.c b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
index fb052bca574f..b1ff8050210d 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_kms.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
@@ -681,10 +681,10 @@ int rcar_du_modeset_init(struct rcar_du_device *rcdu)
 
 	drm_mode_config_init(dev);
 
-	dev->mode_config.min_width = 0;
-	dev->mode_config.min_height = 0;
-	dev->mode_config.max_width = 4095;
-	dev->mode_config.max_height = 2047;
+	dev->mode_config.min_width = RCAR_DU_MIN_WIDTH;
+	dev->mode_config.min_height = RCAR_DU_MIN_HEIGHT;
+	dev->mode_config.max_width = RCAR_DU_MAX_WIDTH;
+	dev->mode_config.max_height = RCAR_DU_MAX_HEIGHT;
 	dev->mode_config.funcs = &rcar_du_mode_config_funcs;
 
 	rcdu->num_crtcs = rcdu->info->num_crtcs;
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_kms.h b/drivers/gpu/drm/rcar-du/rcar_du_kms.h
index 07951d5fe38b..b772dc515c7a 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_kms.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_kms.h
@@ -21,6 +21,11 @@ struct drm_device;
 struct drm_mode_create_dumb;
 struct rcar_du_device;
 
+#define RCAR_DU_MIN_WIDTH		1
+#define RCAR_DU_MAX_WIDTH		4095
+#define RCAR_DU_MIN_HEIGHT		1
+#define RCAR_DU_MAX_HEIGHT		2047
+
 struct rcar_du_format_info {
 	u32 fourcc;
 	unsigned int bpp;
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_regs.h b/drivers/gpu/drm/rcar-du/rcar_du_regs.h
index 70fcbc471ebd..8dd510b5d34b 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_regs.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_regs.h
@@ -430,6 +430,10 @@
  */
 
 #define DCMR			0x0c100
+#define DCMR_CODE		(0x7790 << 16)
+#define DCMR_DCAR(a)		((a) << 8)
+#define DCMR_DCDF		(1 << 0)
+
 #define DCMWR			0x0c104
 #define DCSAR			0x0c120
 #define DCMLR			0x0c150
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_wback.c b/drivers/gpu/drm/rcar-du/rcar_du_wback.c
new file mode 100644
index 000000000000..573313f0f6f2
--- /dev/null
+++ b/drivers/gpu/drm/rcar-du/rcar_du_wback.c
@@ -0,0 +1,792 @@
+/*
+ * rcar_du_wback.c  --  R-Car Display Unit Write-Back
+ *
+ * Copyright (C) 2015 Renesas Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/slab.h>
+
+#include <media/v4l2-fh.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "rcar_du_crtc.h"
+#include "rcar_du_drv.h"
+#include "rcar_du_kms.h"
+#include "rcar_du_regs.h"
+#include "rcar_du_wback.h"
+
+#define RCAR_DU_WBACK_DEF_FORMAT	V4L2_PIX_FMT_RGB565
+
+static void rcar_du_wback_write(struct rcar_du_wback *wback, u32 reg, u32 data)
+{
+	rcar_du_write(wback->dev, wback->mmio_offset + reg, data);
+}
+
+static void rcar_du_wback_write_dcpcr(struct rcar_du_wback *wback, u32 data)
+{
+	u32 addr = wback->crtc->group->mmio_offset + DCPCR;
+	unsigned int shift = (wback->crtc->index & 1) ? 8 : 0;
+	u32 dcpcr;
+
+	dcpcr = rcar_du_read(wback->dev, addr) & (0xff << shift);
+	dcpcr |= data << (shift);
+	rcar_du_write(wback->dev, addr, DCPCR_CODE | dcpcr);
+}
+
+/* -----------------------------------------------------------------------------
+ * Format Helpers
+ */
+
+struct rcar_du_wback_format_info {
+	u32 fourcc;
+	const char *description;
+	unsigned int bpp;
+};
+
+static const struct rcar_du_wback_format_info rcar_du_wback_formats[] = {
+	{
+		.fourcc = V4L2_PIX_FMT_RGB565,
+		.description = "RGB565",
+		.bpp = 16,
+	}, {
+		.fourcc = V4L2_PIX_FMT_RGB555,
+		.description = "RGB555",
+		.bpp = 16,
+	}, {
+		.fourcc = V4L2_PIX_FMT_XBGR32,
+		.description = "XBGR 8:8:8:8",
+		.bpp = 32,
+	},
+};
+
+const struct rcar_du_wback_format_info *rcar_du_wback_format_info(u32 fourcc)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(rcar_du_wback_formats); ++i) {
+		if (rcar_du_wback_formats[i].fourcc == fourcc)
+			return &rcar_du_wback_formats[i];
+	}
+
+	return NULL;
+}
+
+static int __rcar_du_wback_try_format(struct rcar_du_wback *wback,
+				      struct v4l2_pix_format_mplane *pix,
+				      const struct rcar_du_wback_format_info **fmtinfo)
+{
+	const struct rcar_du_wback_format_info *info;
+	unsigned int align = 16;
+	unsigned int bpl;
+
+	/* Retrieve format information and select the default format if the
+	 * requested format isn't supported.
+	 */
+	info = rcar_du_wback_format_info(pix->pixelformat);
+	if (info == NULL)
+		info = rcar_du_wback_format_info(RCAR_DU_WBACK_DEF_FORMAT);
+
+	pix->pixelformat = info->fourcc;
+	pix->colorspace = V4L2_COLORSPACE_SRGB;
+	pix->field = V4L2_FIELD_NONE;
+	memset(pix->reserved, 0, sizeof(pix->reserved));
+
+	/* Clamp the width and height. */
+	pix->width = clamp_t(unsigned int, pix->width, RCAR_DU_MIN_WIDTH,
+			     RCAR_DU_MAX_WIDTH);
+	pix->height = clamp_t(unsigned int, pix->height, RCAR_DU_MIN_HEIGHT,
+			      RCAR_DU_MAX_HEIGHT);
+
+	/* Compute and clamp the stride and image size. The line stride must be
+	 * a multiple of 16 pixels.
+	 */
+	pix->num_planes = 1;
+
+	bpl = round_up(pix->plane_fmt[0].bytesperline * 8 / info->bpp, align);
+	bpl = clamp(bpl, round_up(pix->width, align), round_down(4096U, align));
+
+	pix->plane_fmt[0].bytesperline = bpl * info->bpp / 8;
+	pix->plane_fmt[0].sizeimage = pix->plane_fmt[0].bytesperline
+				    * pix->height;
+
+	if (fmtinfo)
+		*fmtinfo = info;
+
+	return 0;
+}
+
+static bool
+rcar_du_wback_format_adjust(struct rcar_du_wback *wback,
+			    const struct v4l2_pix_format_mplane *format,
+			    struct v4l2_pix_format_mplane *adjust)
+{
+	*adjust = *format;
+	__rcar_du_wback_try_format(wback, adjust, NULL);
+
+	if (format->width != adjust->width ||
+	    format->height != adjust->height ||
+	    format->pixelformat != adjust->pixelformat ||
+	    format->num_planes != adjust->num_planes)
+		return false;
+
+	if (format->plane_fmt[0].bytesperline !=
+	    adjust->plane_fmt[0].bytesperline)
+		return false;
+
+	adjust->plane_fmt[0].sizeimage =
+		max(adjust->plane_fmt[0].sizeimage,
+		    format->plane_fmt[0].sizeimage);
+
+	return true;
+}
+
+/* -----------------------------------------------------------------------------
+ * State Machine
+ */
+
+static bool rcar_du_wback_vblank_miss(struct rcar_du_wback *wback)
+{
+	return !!(rcar_du_read(wback->dev, wback->crtc->mmio_offset + DSSR) &
+		  DSSR_FRM);
+}
+
+static void rcar_du_wback_complete_buffer(struct rcar_du_wback *wback)
+{
+	struct rcar_du_wback_buffer *buf = wback->active_buffer;
+
+	if (buf && buf->state == RCAR_DU_WBACK_BUFFER_STATE_DONE) {
+		/* The previously active capture buffer has been released,
+		 * complete it.
+		 */
+		buf->buf.v4l2_buf.sequence = wback->sequence;
+		v4l2_get_timestamp(&buf->buf.v4l2_buf.timestamp);
+		vb2_set_plane_payload(&buf->buf, 0, buf->length);
+		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_DONE);
+	}
+
+	if (list_empty(&wback->irqqueue))
+		return;
+
+	buf = list_first_entry(&wback->irqqueue, struct rcar_du_wback_buffer,
+			       queue);
+	if (buf->state == RCAR_DU_WBACK_BUFFER_STATE_ACTIVE) {
+		/* The next buffer has been activated, remove it from the wait
+		 * list and store it as the active buffer.
+		 */
+		wback->active_buffer = buf;
+		list_del(&buf->queue);
+	}
+}
+
+static void rcar_du_wback_vblank(struct rcar_du_wback *wback)
+{
+	switch (wback->state) {
+	case RCAR_DU_WBACK_STATE_RUNNING:
+		rcar_du_wback_complete_buffer(wback);
+		wback->sequence++;
+		break;
+
+	case RCAR_DU_WBACK_STATE_STOP_WAIT:
+		/* Capture is now stopped, wake waiters. */
+		wback->state = RCAR_DU_WBACK_STATE_STOPPED;
+		wake_up(&wback->wait);
+		break;
+
+	case RCAR_DU_WBACK_STATE_STOPPING:
+	case RCAR_DU_WBACK_STATE_STOPPED:
+		break;
+	}
+}
+
+static void rcar_du_wback_activate_next_buffer(struct rcar_du_wback *wback)
+{
+	struct rcar_du_wback_buffer *buf;
+	u32 dcpcr;
+
+	/* If there's no buffer waiting keep the current buffer active and bail
+	 * out.
+	 */
+	if (list_empty(&wback->irqqueue))
+		return;
+
+	/* Activate the next buffer. */
+	buf = list_first_entry(&wback->irqqueue, struct rcar_du_wback_buffer,
+			       queue);
+
+	rcar_du_wback_write(wback, DCSAR, buf->addr);
+	dcpcr = wback->fmtinfo->fourcc == V4L2_PIX_FMT_RGB555
+	      ? DCPCR_CDF : 0;
+	rcar_du_wback_write_dcpcr(wback, dcpcr | DCPCR_DCE);
+
+	/* If we miss vertical blanking start, there's no way to know whether
+	 * the DU will capture the frame to the previous or next buffer. Assume
+	 * the worst case, reuse the currently active buffer for capture and try
+	 * again next time.
+	 */
+	if (rcar_du_wback_vblank_miss(wback))
+		return;
+
+	/* The new buffer has been successfully activated, mark it as active and
+	 * mark the previous active buffer as done.
+	 */
+	buf->state = RCAR_DU_WBACK_BUFFER_STATE_ACTIVE;
+	if (wback->active_buffer)
+		wback->active_buffer->state = RCAR_DU_WBACK_BUFFER_STATE_DONE;
+}
+
+static void rcar_du_wback_rint(struct rcar_du_wback *wback)
+{
+	switch (wback->state) {
+	case RCAR_DU_WBACK_STATE_RUNNING:
+		/* Program the DU to capture the next frame to the next queued
+		 * buffer.
+		 */
+		rcar_du_wback_activate_next_buffer(wback);
+		break;
+
+	case RCAR_DU_WBACK_STATE_STOPPING:
+		/* Stop capture. The setting will only take effect at the next
+		 * frame start. The delay can't be shortened by stopping capture
+		 * in the stop_streaming handler as it could race with the frame
+		 * interrupt and waiting for two frames would anyway be
+		 * required.
+		 *
+		 * If we miss the beginning of vertical blanking we need to wait
+		 * for an extra frame.
+		 */
+		rcar_du_wback_write_dcpcr(wback, 0);
+		if (!rcar_du_wback_vblank_miss(wback))
+			wback->state = RCAR_DU_WBACK_STATE_STOP_WAIT;
+		break;
+
+	case RCAR_DU_WBACK_STATE_STOP_WAIT:
+	case RCAR_DU_WBACK_STATE_STOPPED:
+		break;
+	}
+}
+
+/*
+ * The DU doesn't have write-back interrupts. We can use the frame interrupt
+ * (triggered at the start of the vertical blanking period) to be notified when
+ * a frame has been captured and reprogram the capture engine. The process is
+ * inherently racy though, as missing the end of vertical blanking would leave
+ * the capture running using the previously configured buffer. As this can't be
+ * avoided, we at least need to detect that condition.
+ *
+ * The hardware synchronizes shadow register writes to the beginning of a frame.
+ * There's unfortunately no corresponding interrupt, so we can't detect frame
+ * start misses. Instead, we need to reprogram the capture engine before the
+ * start of vertical blanking (using the raster interrupt as a trigger), and use
+ * the frame interrupt to detect misses. That's suboptimal as missing vertical
+ * blanking start doesn't mean we miss vertical blanking end, but that's the
+ * best procedure found so far.
+ */
+void rcar_du_wback_irq(struct rcar_du_wback *wback, u32 status)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&wback->irqlock, flags);
+
+	if (status & DSSR_RINT)
+		rcar_du_wback_rint(wback);
+
+	if (status & DSSR_FRM)
+		rcar_du_wback_vblank(wback);
+
+	spin_unlock_irqrestore(&wback->irqlock, flags);
+}
+
+/* -----------------------------------------------------------------------------
+ * videobuf2 Queue Operations
+ */
+
+/* Return all queued buffers to videobuf2 in the requested state. */
+static void rcar_du_wback_return_buffers(struct rcar_du_wback *wback,
+					 enum vb2_buffer_state state)
+{
+	/* There's no need to take the irqlock spinlock as the state is set to
+	 * stopped, the interrupt handlers will not touch the buffers, and the
+	 * videobuf2 API calls are serialized with the queue mutex.
+	 */
+	while (!list_empty(&wback->irqqueue)) {
+		struct rcar_du_wback_buffer *buf;
+
+		buf = list_first_entry(&wback->irqqueue,
+				       struct rcar_du_wback_buffer, queue);
+		list_del(&buf->queue);
+		vb2_buffer_done(&buf->buf, state);
+	}
+
+	if (wback->active_buffer) {
+		vb2_buffer_done(&wback->active_buffer->buf, state);
+		wback->active_buffer = NULL;
+	}
+}
+
+static int
+rcar_du_wback_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+		     unsigned int *nbuffers, unsigned int *nplanes,
+		     unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct rcar_du_wback *wback = vb2_get_drv_priv(vq);
+	const struct v4l2_pix_format_mplane *format;
+	struct v4l2_pix_format_mplane pix_mp;
+
+	if (fmt) {
+		/* Make sure the format is valid and adjust the sizeimage field
+		 * if needed.
+		 */
+		if (!rcar_du_wback_format_adjust(wback, &fmt->fmt.pix_mp,
+						 &pix_mp))
+			return -EINVAL;
+
+		format = &pix_mp;
+	} else {
+		format = &wback->format;
+	}
+
+	*nplanes = 1;
+	sizes[0] = format->plane_fmt[0].sizeimage;
+	alloc_ctxs[0] = wback->alloc_ctx;
+
+	return 0;
+}
+
+static int rcar_du_wback_buffer_prepare(struct vb2_buffer *vb)
+{
+	struct rcar_du_wback *wback = vb2_get_drv_priv(vb->vb2_queue);
+	struct rcar_du_wback_buffer *buf = to_rcar_du_wback_buffer(vb);
+	const struct v4l2_pix_format_mplane *format = &wback->format;
+
+	if (vb->num_planes < format->num_planes)
+		return -EINVAL;
+
+	buf->addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+	buf->length = vb2_plane_size(vb, 0);
+
+	if (buf->length < format->plane_fmt[0].sizeimage)
+		return -EINVAL;
+
+	return 0;
+}
+
+static void rcar_du_wback_buffer_queue(struct vb2_buffer *vb)
+{
+	struct rcar_du_wback *wback = vb2_get_drv_priv(vb->vb2_queue);
+	struct rcar_du_wback_buffer *buf = to_rcar_du_wback_buffer(vb);
+	unsigned long flags;
+
+	spin_lock_irqsave(&wback->irqlock, flags);
+	buf->state = RCAR_DU_WBACK_BUFFER_STATE_WAIT;
+	list_add_tail(&buf->queue, &wback->irqqueue);
+	spin_unlock_irqrestore(&wback->irqlock, flags);
+}
+
+static int rcar_du_wback_start_streaming(struct vb2_queue *vq,
+					 unsigned int count)
+{
+	struct rcar_du_wback *wback = vb2_get_drv_priv(vq);
+	const struct drm_display_mode *mode;
+	unsigned long flags;
+	u32 dcmr;
+	u32 mwr;
+
+	wback->sequence = 0;
+
+	/* Verify that the configured format matches the output of the connected
+	 * subdev.
+	 */
+	mode = &wback->crtc->crtc.state->adjusted_mode;
+	if (wback->format.height != mode->vdisplay ||
+	    wback->format.width != mode->hdisplay) {
+		rcar_du_wback_return_buffers(wback, VB2_BUF_STATE_QUEUED);
+		return -EINVAL;
+	}
+
+	/* Setup the capture registers. While documentation states that the
+	 * memory pitch is expressed in pixels, this seems to be only true in
+	 * practice for 16bpp formats. 32bpp formats requires multiplying the
+	 * pitch by two, effectively leading to bytesperline / 2 for every
+	 * format.
+	 */
+	mwr = wback->format.plane_fmt[0].bytesperline / 2;
+	dcmr = wback->fmtinfo->bpp == 32 ? DCMR_DCDF : 0;
+
+	rcar_du_wback_write(wback, DCMWR, mwr);
+	rcar_du_wback_write(wback, DCMLR, 0);
+	rcar_du_wback_write(wback, DCMR, DCMR_CODE | dcmr);
+
+	/* Set the state to started and enable the interrupts. The interrupt-
+	 * driven state machine will take care of starting the hardware.
+	 */
+	spin_lock_irqsave(&wback->irqlock, flags);
+	wback->state = RCAR_DU_WBACK_STATE_RUNNING;
+	spin_unlock_irqrestore(&wback->irqlock, flags);
+
+	drm_vblank_get(wback->dev->ddev, wback->crtc->index);
+	rcar_du_crtc_enable_rint(wback->crtc, true);
+
+	return 0;
+}
+
+static void rcar_du_wback_stop_streaming(struct vb2_queue *vq)
+{
+	struct rcar_du_wback *wback = vb2_get_drv_priv(vq);
+	unsigned long flags;
+	int ret;
+
+	/* Stop write-back. As the hardware can't be force-stopped in the middle
+	 * of a frame, set the state to stopping and let the interrupt handlers
+	 * manage the state machine. There's no need to stop the hardware here
+	 * as this would be racing the interrupt handlers which would need to
+	 * wait one extra frame anyway.
+	 */
+	spin_lock_irqsave(&wback->irqlock, flags);
+	wback->state = RCAR_DU_WBACK_STATE_STOPPING;
+	spin_unlock_irqrestore(&wback->irqlock, flags);
+
+	ret = wait_event_timeout(wback->wait,
+				 wback->state == RCAR_DU_WBACK_STATE_STOPPED,
+				 msecs_to_jiffies(1000));
+	if (wback->state != RCAR_DU_WBACK_STATE_STOPPED)
+		dev_err(wback->dev->dev, "pipeline stop timeout\n");
+
+	drm_vblank_put(wback->dev->ddev, wback->crtc->index);
+	rcar_du_crtc_enable_rint(wback->crtc, false);
+
+	/* Hand back all queued buffers to videobuf2. */
+	rcar_du_wback_return_buffers(wback, VB2_BUF_STATE_ERROR);
+}
+
+static struct vb2_ops rcar_du_wback_queue_qops = {
+	.queue_setup = rcar_du_wback_queue_setup,
+	.buf_prepare = rcar_du_wback_buffer_prepare,
+	.buf_queue = rcar_du_wback_buffer_queue,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
+	.start_streaming = rcar_du_wback_start_streaming,
+	.stop_streaming = rcar_du_wback_stop_streaming,
+};
+
+/* -----------------------------------------------------------------------------
+ * V4L2 ioctls
+ */
+
+static int
+rcar_du_wback_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct rcar_du_wback *wback = to_rcar_du_wback(vfh->vdev);
+
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE_MPLANE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+
+	strlcpy(cap->driver, "rcdu", sizeof(cap->driver));
+	strlcpy(cap->card, wback->video.name, sizeof(cap->card));
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
+		 dev_name(wback->dev->dev));
+
+	return 0;
+}
+
+static int
+rcar_du_wback_enum_formats(struct file *file, void *fh,
+			   struct v4l2_fmtdesc *fmt)
+{
+	const struct rcar_du_wback_format_info *info;
+
+	if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		return -EINVAL;
+
+	if (fmt->index >= ARRAY_SIZE(rcar_du_wback_formats))
+		return -EINVAL;
+
+	info = &rcar_du_wback_formats[fmt->index];
+
+	strlcpy(fmt->description, info->description, sizeof(fmt->description));
+	fmt->pixelformat = info->fourcc;
+
+	return 0;
+}
+
+static int
+rcar_du_wback_get_format(struct file *file, void *fh, struct v4l2_format *fmt)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct rcar_du_wback *wback = to_rcar_du_wback(vfh->vdev);
+
+	if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		return -EINVAL;
+
+	mutex_lock(&wback->lock);
+	fmt->fmt.pix_mp = wback->format;
+	mutex_unlock(&wback->lock);
+
+	return 0;
+}
+
+static int
+rcar_du_wback_try_format(struct file *file, void *fh, struct v4l2_format *fmt)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct rcar_du_wback *wback = to_rcar_du_wback(vfh->vdev);
+
+	if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		return -EINVAL;
+
+	return __rcar_du_wback_try_format(wback, &fmt->fmt.pix_mp, NULL);
+}
+
+static int
+rcar_du_wback_set_format(struct file *file, void *fh, struct v4l2_format *fmt)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct rcar_du_wback *wback = to_rcar_du_wback(vfh->vdev);
+	const struct rcar_du_wback_format_info *info;
+	int ret;
+
+	if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		return -EINVAL;
+
+	ret = __rcar_du_wback_try_format(wback, &fmt->fmt.pix_mp, &info);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&wback->lock);
+
+	if (vb2_is_busy(&wback->queue)) {
+		ret = -EBUSY;
+		goto done;
+	}
+
+	wback->format = fmt->fmt.pix_mp;
+	wback->fmtinfo = info;
+
+done:
+	mutex_unlock(&wback->lock);
+	return ret;
+}
+
+static int rcar_du_wback_streamon(struct file *file, void *priv,
+				  enum v4l2_buf_type i)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct rcar_du_wback *wback = to_rcar_du_wback(vdev);
+	int ret;
+
+	/* Take to DRM modeset lock to ensure that the CRTC mode won't change
+	 * behind our back while we verify the format when starting the video
+	 * stream.
+	 */
+	drm_modeset_lock_all(wback->dev->ddev);
+	ret = vb2_ioctl_streamon(file, priv, i);
+	drm_modeset_unlock_all(wback->dev->ddev);
+
+	return ret;
+}
+
+static int rcar_du_wback_streamoff(struct file *file, void *priv,
+				   enum v4l2_buf_type i)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct rcar_du_wback *wback = to_rcar_du_wback(vdev);
+	int ret;
+
+	drm_modeset_lock_all(wback->dev->ddev);
+	ret = vb2_ioctl_streamoff(file, priv, i);
+	drm_modeset_unlock_all(wback->dev->ddev);
+
+	return ret;
+}
+
+static const struct v4l2_ioctl_ops rcar_du_wback_ioctl_ops = {
+	.vidioc_querycap		= rcar_du_wback_querycap,
+	.vidioc_enum_fmt_vid_cap_mplane	= rcar_du_wback_enum_formats,
+	.vidioc_g_fmt_vid_cap_mplane	= rcar_du_wback_get_format,
+	.vidioc_s_fmt_vid_cap_mplane	= rcar_du_wback_set_format,
+	.vidioc_try_fmt_vid_cap_mplane	= rcar_du_wback_try_format,
+	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
+	.vidioc_querybuf		= vb2_ioctl_querybuf,
+	.vidioc_qbuf			= vb2_ioctl_qbuf,
+	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
+	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
+	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
+	.vidioc_streamon		= rcar_du_wback_streamon,
+	.vidioc_streamoff		= rcar_du_wback_streamoff,
+	.vidioc_expbuf			= vb2_ioctl_expbuf,
+};
+
+/* -----------------------------------------------------------------------------
+ * V4L2 File Operations
+ */
+
+static int rcar_du_wback_open(struct file *file)
+{
+	struct rcar_du_wback *wback = video_drvdata(file);
+	struct v4l2_fh *vfh;
+	int ret;
+
+	vfh = kzalloc(sizeof(*vfh), GFP_KERNEL);
+	if (vfh == NULL)
+		return -ENOMEM;
+
+	v4l2_fh_init(vfh, &wback->video);
+	v4l2_fh_add(vfh);
+
+	file->private_data = vfh;
+
+	ret = rcar_du_crtc_get(wback->crtc);
+	if (ret < 0) {
+		v4l2_fh_del(vfh);
+		kfree(vfh);
+	}
+
+	return ret;
+}
+
+static int rcar_du_wback_release(struct file *file)
+{
+	struct rcar_du_wback *wback = video_drvdata(file);
+	struct v4l2_fh *vfh = file->private_data;
+
+	mutex_lock(&wback->lock);
+	if (wback->queue.owner == vfh) {
+		vb2_queue_release(&wback->queue);
+		wback->queue.owner = NULL;
+	}
+	mutex_unlock(&wback->lock);
+
+	rcar_du_crtc_put(wback->crtc);
+
+	v4l2_fh_release(file);
+
+	file->private_data = NULL;
+
+	return 0;
+}
+
+static struct v4l2_file_operations rcar_du_wback_fops = {
+	.owner = THIS_MODULE,
+	.unlocked_ioctl = video_ioctl2,
+	.open = rcar_du_wback_open,
+	.release = rcar_du_wback_release,
+	.poll = vb2_fop_poll,
+	.mmap = vb2_fop_mmap,
+};
+
+/* -----------------------------------------------------------------------------
+ * Initialization and Cleanup
+ */
+
+int rcar_du_wback_init_crtc(struct rcar_du_crtc *rcrtc)
+{
+	struct rcar_du_wback *wback = &rcrtc->wback;
+	int ret;
+
+	mutex_init(&wback->lock);
+	spin_lock_init(&wback->irqlock);
+	INIT_LIST_HEAD(&wback->irqqueue);
+	init_waitqueue_head(&wback->wait);
+	wback->state = RCAR_DU_WBACK_STATE_STOPPED;
+
+	wback->dev = rcrtc->group->dev;
+	wback->crtc = rcrtc;
+
+	wback->mmio_offset = rcrtc->group->mmio_offset
+			   + 0x100 * (rcrtc->index % 2);
+
+	/* Initialize the media entity... */
+	wback->pad.flags = MEDIA_PAD_FL_SINK;
+
+	ret = media_entity_init(&wback->video.entity, 1, &wback->pad, 0);
+	if (ret < 0)
+		return ret;
+
+	/* ... and the format ... */
+	wback->fmtinfo = rcar_du_wback_format_info(RCAR_DU_WBACK_DEF_FORMAT);
+	wback->format.pixelformat = wback->fmtinfo->fourcc;
+	wback->format.colorspace = V4L2_COLORSPACE_SRGB;
+	wback->format.field = V4L2_FIELD_NONE;
+	wback->format.width = 0;
+	wback->format.height = 0;
+	wback->format.num_planes = 1;
+	wback->format.plane_fmt[0].bytesperline =
+		wback->format.width * wback->fmtinfo->bpp / 8;
+	wback->format.plane_fmt[0].sizeimage =
+		wback->format.plane_fmt[0].bytesperline * wback->format.height;
+
+	/* ... and the wback node... */
+	wback->video.v4l2_dev = &wback->dev->v4l2_dev;
+	wback->video.fops = &rcar_du_wback_fops;
+	snprintf(wback->video.name, sizeof(wback->video.name),
+		 "CRTC %u capture", rcrtc->index);
+	wback->video.vfl_type = VFL_TYPE_GRABBER;
+	wback->video.vfl_dir = VFL_DIR_RX;
+	wback->video.release = video_device_release_empty;
+	wback->video.ioctl_ops = &rcar_du_wback_ioctl_ops;
+
+	video_set_drvdata(&wback->video, wback);
+
+	/* ... and the buffers queue... */
+	wback->alloc_ctx = vb2_dma_contig_init_ctx(wback->dev->dev);
+	if (IS_ERR(wback->alloc_ctx))
+		goto error;
+
+	wback->queue.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	wback->queue.io_modes = VB2_MMAP | VB2_DMABUF;
+	wback->queue.lock = &wback->lock;
+	wback->queue.drv_priv = wback;
+	wback->queue.buf_struct_size = sizeof(struct rcar_du_wback_buffer);
+	wback->queue.ops = &rcar_du_wback_queue_qops;
+	wback->queue.mem_ops = &vb2_dma_contig_memops;
+	wback->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
+				     | V4L2_BUF_FLAG_TSTAMP_SRC_EOF;
+	ret = vb2_queue_init(&wback->queue);
+	if (ret < 0) {
+		dev_err(wback->dev->dev, "failed to initialize vb2 queue\n");
+		goto error;
+	}
+
+	/* ... and register the video device. */
+	wback->video.queue = &wback->queue;
+	ret = video_register_device(&wback->video, VFL_TYPE_GRABBER, -1);
+	if (ret < 0) {
+		dev_err(wback->dev->dev, "failed to register video device\n");
+		goto error;
+	}
+
+	return 0;
+
+error:
+	vb2_dma_contig_cleanup_ctx(wback->alloc_ctx);
+	rcar_du_wback_cleanup_crtc(rcrtc);
+	return ret;
+}
+
+void rcar_du_wback_cleanup_crtc(struct rcar_du_crtc *rcrtc)
+{
+	struct rcar_du_wback *wback = &rcrtc->wback;
+
+	video_unregister_device(&wback->video);
+
+	vb2_dma_contig_cleanup_ctx(wback->alloc_ctx);
+	media_entity_cleanup(&wback->video.entity);
+}
+
+int rcar_du_wback_init(struct rcar_du_device *rcdu)
+{
+	return v4l2_device_register(rcdu->dev, &rcdu->v4l2_dev);
+}
+
+void rcar_du_wback_cleanup(struct rcar_du_device *rcdu)
+{
+	v4l2_device_unregister(&rcdu->v4l2_dev);
+}
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_wback.h b/drivers/gpu/drm/rcar-du/rcar_du_wback.h
new file mode 100644
index 000000000000..529132812aa6
--- /dev/null
+++ b/drivers/gpu/drm/rcar-du/rcar_du_wback.h
@@ -0,0 +1,102 @@
+/*
+ * rcar_du_wback.h  --  R-Car Display Unit Write-Back
+ *
+ * Copyright (C) 2015 Renesas Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __RCAR_DU_WBACK_H__
+#define __RCAR_DU_WBACK_H__
+
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/wait.h>
+
+#include <media/media-entity.h>
+#include <media/v4l2-dev.h>
+#include <media/videobuf2-core.h>
+
+struct rcar_du_crtc;
+struct rcar_du_device;
+struct rcar_du_wback;
+struct rcar_du_wback_format_info;
+
+/*
+ * WAIT: The buffer is waiting to be queued to the hardware
+ * ACTIVE: The buffer is being used as the capture target
+ * DONE: The buffer is full and has been released as the capture target
+ */
+enum rcar_du_wback_buffer_state {
+	RCAR_DU_WBACK_BUFFER_STATE_WAIT,
+	RCAR_DU_WBACK_BUFFER_STATE_ACTIVE,
+	RCAR_DU_WBACK_BUFFER_STATE_DONE,
+};
+
+struct rcar_du_wback_buffer {
+	struct vb2_buffer buf;
+	struct list_head queue;
+	unsigned length;
+	dma_addr_t addr;
+	enum rcar_du_wback_buffer_state state;
+};
+
+static inline struct rcar_du_wback_buffer *
+to_rcar_du_wback_buffer(struct vb2_buffer *vb)
+{
+	return container_of(vb, struct rcar_du_wback_buffer, buf);
+}
+
+enum rcar_du_wback_state {
+	RCAR_DU_WBACK_STATE_STOPPED,
+	RCAR_DU_WBACK_STATE_RUNNING,
+	RCAR_DU_WBACK_STATE_STOPPING,
+	RCAR_DU_WBACK_STATE_STOP_WAIT,
+};
+
+struct rcar_du_wback {
+	struct rcar_du_device *dev;
+	struct rcar_du_crtc *crtc;
+
+	unsigned int mmio_offset;
+
+	struct video_device video;
+	enum v4l2_buf_type type;
+	struct media_pad pad;
+
+	struct mutex lock;
+	struct v4l2_pix_format_mplane format;
+	const struct rcar_du_wback_format_info *fmtinfo;
+
+	struct vb2_queue queue;
+	void *alloc_ctx;
+
+	wait_queue_head_t wait;
+	spinlock_t irqlock;	/* Protects irqqueue, active_buffer, sequence and state. */
+	enum rcar_du_wback_state state;
+	struct list_head irqqueue;
+	struct rcar_du_wback_buffer *active_buffer;
+	unsigned int sequence;
+};
+
+static inline struct rcar_du_wback *to_rcar_du_wback(struct video_device *vdev)
+{
+	return container_of(vdev, struct rcar_du_wback, video);
+}
+
+int rcar_du_wback_init_crtc(struct rcar_du_crtc *rcrtc);
+void rcar_du_wback_cleanup_crtc(struct rcar_du_crtc *rcrtc);
+
+int rcar_du_wback_init(struct rcar_du_device *rcdu);
+void rcar_du_wback_cleanup(struct rcar_du_device *rcdu);
+
+void rcar_du_wback_irq(struct rcar_du_wback *wback, u32 status);
+
+#endif /* __RCAR_DU_WBACK_H__ */
-- 
Regards,

Laurent Pinchart

