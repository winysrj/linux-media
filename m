Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:33742 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab2BOGJ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Feb 2012 01:09:28 -0500
Received: from epcpsbgm1.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LZF00KLA7RLI3B0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Feb 2012 15:09:25 +0900 (KST)
Received: from NOSUNGCHUNK01 ([12.23.119.73])
 by mmp2.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0LZF00FM87ROR1P0@mmp2.samsung.com>
 for linux-media@vger.kernel.org; Wed, 15 Feb 2012 15:09:25 +0900 (KST)
Reply-to: sungchun.kang@samsung.com
From: Sungchun Kang <sungchun.kang@samsung.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, mchehab@redhat.com, jonghun.han@samsung.com,
	sy0816.kang@samsung.com, khw0178.kim@samsung.com,
	sungchun.kang@samsung.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH] media: gscaler: Add new driver for general scaler
Date: Wed, 15 Feb 2012 15:09:24 +0900
Message-id: <005501cceba8$5dcab2e0$196018a0$%kang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add support gscaler device which is a new device
for scaling and color space conversion on EXYNOS5 SoCs.

This device supports the followings as key feature.
 1) Input image format
   - RGB888/565, YUV422 1P/2P, YUV420 2P/3P, TILE
 2) Output image format
   - RGB888/565, YUV422 1P/2P, YUV420 2P/3P, YUV444
 3) Input rotation
   - 0/90/180/270 degree, X/Y Flip
 4) Scale ratio
   - 1/16 scale down to 8 scale up
 5) CSC
   - RGB to YUV / YUV to RGB
 6) Size
   - 2048 x 2048 for tile or rotation
   - 4800 x 3344 other case

Signed-off-by: Hynwoong Kim <khw0178.kim@samsung.com>
Signed-off-by: Sungchun Kang <sungchun.kang@samsung.com>

NOTE: This patch is based on
"media: fimc-lite: Add new driver for camera interface"
---
 drivers/media/video/exynos/Kconfig           |    1 +
 drivers/media/video/exynos/Makefile          |    2 +-
 drivers/media/video/exynos/gsc/Kconfig       |   28 +
 drivers/media/video/exynos/gsc/Makefile      |    2 +
 drivers/media/video/exynos/gsc/gsc-capture.c | 1593 ++++++++++++++++++++++++++
 drivers/media/video/exynos/gsc/gsc-core.c    | 1315 +++++++++++++++++++++
 drivers/media/video/exynos/gsc/gsc-core.h    |  752 ++++++++++++
 drivers/media/video/exynos/gsc/gsc-m2m.c     |  696 +++++++++++
 drivers/media/video/exynos/gsc/gsc-output.c  | 1034 +++++++++++++++++
 drivers/media/video/exynos/gsc/gsc-regs.c    |  671 +++++++++++
 drivers/media/video/exynos/gsc/regs-gsc.h    |  224 ++++
 include/media/exynos_gscaler.h               |   49 +
 12 files changed, 6366 insertions(+), 1 deletions(-)
 create mode 100644 drivers/media/video/exynos/gsc/Kconfig
 create mode 100644 drivers/media/video/exynos/gsc/Makefile
 create mode 100644 drivers/media/video/exynos/gsc/gsc-capture.c
 create mode 100644 drivers/media/video/exynos/gsc/gsc-core.c
 create mode 100644 drivers/media/video/exynos/gsc/gsc-core.h
 create mode 100644 drivers/media/video/exynos/gsc/gsc-m2m.c
 create mode 100644 drivers/media/video/exynos/gsc/gsc-output.c
 create mode 100644 drivers/media/video/exynos/gsc/gsc-regs.c
 create mode 100644 drivers/media/video/exynos/gsc/regs-gsc.h
 create mode 100644 include/media/exynos_gscaler.h

diff --git a/drivers/media/video/exynos/Kconfig b/drivers/media/video/exynos/Kconfig
index a84097d..2bd7e56 100644
--- a/drivers/media/video/exynos/Kconfig
+++ b/drivers/media/video/exynos/Kconfig
@@ -12,6 +12,7 @@ config VIDEO_EXYNOS
 if VIDEO_EXYNOS
 	source "drivers/media/video/exynos/mdev/Kconfig"
 	source "drivers/media/video/exynos/fimc-lite/Kconfig"
+	source "drivers/media/video/exynos/gsc/Kconfig"
 endif
 
 config MEDIA_EXYNOS
diff --git a/drivers/media/video/exynos/Makefile b/drivers/media/video/exynos/Makefile
index 56cb7b2..53d58f6 100644
--- a/drivers/media/video/exynos/Makefile
+++ b/drivers/media/video/exynos/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_EXYNOS_MEDIA_DEVICE)	+= mdev/
 obj-$(CONFIG_VIDEO_EXYNOS_FIMC_LITE)	+= fimc-lite/
-
+obj-$(CONFIG_VIDEO_EXYNOS_GSCALER)	+= gsc/
 EXTRA_CLAGS += -Idrivers/media/video
diff --git a/drivers/media/video/exynos/gsc/Kconfig b/drivers/media/video/exynos/gsc/Kconfig
new file mode 100644
index 0000000..8d8b49d
--- /dev/null
+++ b/drivers/media/video/exynos/gsc/Kconfig
@@ -0,0 +1,28 @@
+config VIDEO_EXYNOS_GSCALER
+	bool "Exynos G-Scaler driver"
+	depends on VIDEO_EXYNOS
+	select MEDIA_EXYNOS
+	select V4L2_MEM2MEM_DEV
+	default n
+	help
+	  This is a v4l2 driver for exynos G-Scaler device.
+
+if VIDEO_EXYNOS_GSCALER && VIDEOBUF2_CMA_PHYS
+comment "Reserved memory configurations"
+config VIDEO_SAMSUNG_MEMSIZE_GSC0
+	int "Memory size in kbytes for GSC0"
+	default "5120"
+
+config VIDEO_SAMSUNG_MEMSIZE_GSC1
+	int "Memory size in kbytes for GSC1"
+	default "5120"
+
+config VIDEO_SAMSUNG_MEMSIZE_GSC2
+	int "Memory size in kbytes for GSC2"
+	default "5120"
+
+config VIDEO_SAMSUNG_MEMSIZE_GSC3
+	int "Memory size in kbytes for GSC3"
+	default "5120"
+endif
+
diff --git a/drivers/media/video/exynos/gsc/Makefile b/drivers/media/video/exynos/gsc/Makefile
new file mode 100644
index 0000000..83ee67d
--- /dev/null
+++ b/drivers/media/video/exynos/gsc/Makefile
@@ -0,0 +1,2 @@
+gsc-objs := gsc-core.o gsc-m2m.o gsc-output.o gsc-capture.o gsc-regs.o
+obj-$(CONFIG_VIDEO_EXYNOS_GSCALER)	+= gsc.o
diff --git a/drivers/media/video/exynos/gsc/gsc-capture.c b/drivers/media/video/exynos/gsc/gsc-capture.c
new file mode 100644
index 0000000..d7c6ded
--- /dev/null
+++ b/drivers/media/video/exynos/gsc/gsc-capture.c
@@ -0,0 +1,1593 @@
+/* linux/drivers/media/video/exynos/gsc/gsc-capture.c
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Samsung EXYNOS5 SoC series G-scaler driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation, either version 2 of the License,
+ * or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/version.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/bug.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/list.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <linux/string.h>
+#include <linux/i2c.h>
+#include <media/v4l2-ioctl.h>
+#include <media/exynos_gscaler.h>
+
+#include "gsc-core.h"
+
+static int gsc_capture_queue_setup(struct vb2_queue *vq,
+			const struct v4l2_format *fmt, unsigned int *num_buffers,
+			unsigned int *num_planes, unsigned int sizes[],
+			void *allocators[])
+{
+	struct gsc_ctx *ctx = vq->drv_priv;
+	struct gsc_fmt *ffmt = ctx->d_frame.fmt;
+	int i;
+
+	if (!ffmt)
+		return -EINVAL;
+
+	*num_planes = ffmt->num_planes;
+
+	for (i = 0; i < ffmt->num_planes; i++) {
+		sizes[i] = get_plane_size(&ctx->d_frame, i);
+		allocators[i] = ctx->gsc_dev->alloc_ctx;
+	}
+
+	return 0;
+}
+static int gsc_capture_buf_prepare(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct gsc_ctx *ctx = vq->drv_priv;
+	struct gsc_frame *frame = &ctx->d_frame;
+	int i;
+
+	if (frame->fmt == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < frame->fmt->num_planes; i++) {
+		unsigned long size = frame->payload[i];
+
+		if (vb2_plane_size(vb, i) < size) {
+			v4l2_err(ctx->gsc_dev->cap.vfd,
+				 "User buffer too small (%ld < %ld)\n",
+				 vb2_plane_size(vb, i), size);
+			return -EINVAL;
+		}
+		vb2_set_plane_payload(vb, i, size);
+	}
+
+	return 0;
+}
+
+int gsc_cap_pipeline_s_stream(struct gsc_dev *gsc, int on)
+{
+	struct gsc_pipeline *p = &gsc->pipeline;
+	int ret = 0;
+
+	if ((!p->sensor || !p->flite) && (!p->disp))
+		return -ENODEV;
+
+	if (on) {
+		ret = v4l2_subdev_call(p->sd_gsc, video, s_stream, 1);
+		if (ret < 0 && ret != -ENOIOCTLCMD)
+			return ret;
+		if (p->disp) {
+			ret = v4l2_subdev_call(p->disp, video, s_stream, 1);
+			if (ret < 0 && ret != -ENOIOCTLCMD)
+				return ret;
+		} else {
+			ret = v4l2_subdev_call(p->flite, video, s_stream, 1);
+			if (ret < 0 && ret != -ENOIOCTLCMD)
+				return ret;
+			ret = v4l2_subdev_call(p->csis, video, s_stream, 1);
+			if (ret < 0 && ret != -ENOIOCTLCMD)
+				return ret;
+			ret = v4l2_subdev_call(p->sensor, video, s_stream, 1);
+		}
+	} else {
+		ret = v4l2_subdev_call(p->sd_gsc, video, s_stream, 0);
+		if (ret < 0 && ret != -ENOIOCTLCMD)
+			return ret;
+		if (p->disp) {
+			ret = v4l2_subdev_call(p->disp, video, s_stream, 0);
+			if (ret < 0 && ret != -ENOIOCTLCMD)
+				return ret;
+		} else {
+			ret = v4l2_subdev_call(p->sensor, video, s_stream, 0);
+			if (ret < 0 && ret != -ENOIOCTLCMD)
+				return ret;
+			ret = v4l2_subdev_call(p->csis, video, s_stream, 0);
+			if (ret < 0 && ret != -ENOIOCTLCMD)
+				return ret;
+			ret = v4l2_subdev_call(p->flite, video, s_stream, 0);
+		}
+	}
+
+	return ret == -ENOIOCTLCMD ? 0 : ret;
+}
+
+static int gsc_capture_set_addr(struct vb2_buffer *vb)
+{
+	struct gsc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct gsc_dev *gsc = ctx->gsc_dev;
+	int ret;
+
+	ret = gsc_prepare_addr(ctx, vb, &ctx->d_frame, &ctx->d_frame.addr);
+	if (ret) {
+		gsc_err("Prepare G-Scaler address failed\n");
+		return -EINVAL;
+	}
+
+	gsc_hw_set_output_addr(gsc, &ctx->d_frame.addr, vb->v4l2_buf.index);
+
+	return 0;
+}
+
+static void gsc_capture_buf_queue(struct vb2_buffer *vb)
+{
+	struct gsc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct gsc_dev *gsc = ctx->gsc_dev;
+	struct gsc_capture_device *cap = &gsc->cap;
+	int min_bufs, ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&gsc->slock, flags);
+	ret = gsc_capture_set_addr(vb);
+	if (ret)
+		gsc_err("Failed to prepare output addr");
+
+	if (!test_bit(ST_CAPT_SUSPENDED, &gsc->state)) {
+		gsc_info("buf_index : %d", vb->v4l2_buf.index);
+		gsc_hw_set_output_buf_masking(gsc, vb->v4l2_buf.index, 0);
+	}
+
+	min_bufs = cap->reqbufs_cnt > 1 ? 2 : 1;
+
+	if (vb2_is_streaming(&cap->vbq) &&
+		(gsc_hw_get_nr_unmask_bits(gsc) >= min_bufs) &&
+		!test_bit(ST_CAPT_STREAM, &gsc->state)) {
+		if (!test_and_set_bit(ST_CAPT_PIPE_STREAM, &gsc->state)) {
+			spin_unlock_irqrestore(&gsc->slock, flags);
+			gsc_cap_pipeline_s_stream(gsc, 1);
+			return;
+		}
+
+		if (!test_bit(ST_CAPT_STREAM, &gsc->state)) {
+			gsc_info("G-Scaler h/w enable control");
+			gsc_hw_enable_control(gsc, true);
+			set_bit(ST_CAPT_STREAM, &gsc->state);
+		}
+	}
+	spin_unlock_irqrestore(&gsc->slock, flags);
+
+	return;
+}
+
+static int gsc_capture_get_scaler_factor(u32 src, u32 tar, u32 *ratio)
+{
+	u32 sh = 3;
+	tar *= 4;
+	if (tar >= src) {
+		*ratio = 1;
+		return 0;
+	}
+
+	while (--sh) {
+		u32 tmp = 1 << sh;
+		if (src >= tar * tmp)
+			*ratio = sh;
+	}
+	return 0;
+}
+
+static int gsc_capture_scaler_info(struct gsc_ctx *ctx)
+{
+	struct gsc_frame *s_frame = &ctx->s_frame;
+	struct gsc_frame *d_frame = &ctx->d_frame;
+	struct gsc_scaler *sc = &ctx->scaler;
+
+	gsc_capture_get_scaler_factor(s_frame->crop.width, d_frame->crop.width,
+				      &sc->pre_hratio);
+	gsc_capture_get_scaler_factor(s_frame->crop.height, d_frame->crop.width,
+				      &sc->pre_vratio);
+
+	sc->main_hratio = (s_frame->crop.width << 16) / d_frame->crop.width;
+	sc->main_vratio = (s_frame->crop.height << 16) / d_frame->crop.height;
+
+	gsc_info("src width : %d, src height : %d, dst width : %d,\
+		dst height : %d", s_frame->crop.width, s_frame->crop.height,\
+		d_frame->crop.width, d_frame->crop.height);
+	gsc_info("pre_hratio : 0x%x, pre_vratio : 0x%x, main_hratio : 0x%lx,\
+			main_vratio : 0x%lx", sc->pre_hratio,\
+			sc->pre_vratio, sc->main_hratio, sc->main_vratio);
+
+	return 0;
+}
+
+static int gsc_capture_subdev_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct gsc_dev *gsc = v4l2_get_subdevdata(sd);
+	struct gsc_capture_device *cap = &gsc->cap;
+	struct gsc_ctx *ctx = cap->ctx;
+
+	gsc_info("");
+
+	gsc_hw_set_frm_done_irq_mask(gsc, false);
+	gsc_hw_set_overflow_irq_mask(gsc, false);
+	gsc_hw_set_one_frm_mode(gsc, false);
+	gsc_hw_set_gsc_irq_enable(gsc, true);
+
+	if (gsc->pipeline.disp)
+		gsc_hw_set_sysreg_writeback(ctx);
+	else
+		gsc_hw_set_sysreg_camif(true);
+
+	gsc_hw_set_input_path(ctx);
+	gsc_hw_set_in_size(ctx);
+	gsc_hw_set_in_image_format(ctx);
+	gsc_hw_set_output_path(ctx);
+	gsc_hw_set_out_size(ctx);
+	gsc_hw_set_out_image_format(ctx);
+	gsc_hw_set_global_alpha(ctx);
+
+	gsc_capture_scaler_info(ctx);
+	gsc_hw_set_prescaler(ctx);
+	gsc_hw_set_mainscaler(ctx);
+
+	set_bit(ST_CAPT_PEND, &gsc->state);
+
+	gsc_hw_enable_control(gsc, true);
+	set_bit(ST_CAPT_STREAM, &gsc->state);
+
+	return 0;
+
+}
+
+static int gsc_capture_start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	struct gsc_ctx *ctx = q->drv_priv;
+	struct gsc_dev *gsc = ctx->gsc_dev;
+	struct gsc_capture_device *cap = &gsc->cap;
+	int min_bufs;
+
+	gsc_hw_set_sw_reset(gsc);
+	gsc_wait_reset(gsc);
+	gsc_hw_set_output_buf_mask_all(gsc);
+
+	min_bufs = cap->reqbufs_cnt > 1 ? 2 : 1;
+	if ((gsc_hw_get_nr_unmask_bits(gsc) >= min_bufs) &&
+		!test_bit(ST_CAPT_STREAM, &gsc->state)) {
+		if (!test_and_set_bit(ST_CAPT_PIPE_STREAM, &gsc->state)) {
+			gsc_info("");
+			gsc_cap_pipeline_s_stream(gsc, 1);
+		}
+	}
+
+	return 0;
+}
+
+static int gsc_capture_state_cleanup(struct gsc_dev *gsc)
+{
+	unsigned long flags;
+	bool streaming;
+
+	spin_lock_irqsave(&gsc->slock, flags);
+	streaming = gsc->state & (1 << ST_CAPT_PIPE_STREAM);
+
+	gsc->state &= ~(1 << ST_CAPT_RUN | 1 << ST_CAPT_STREAM |
+			1 << ST_CAPT_PIPE_STREAM | 1 << ST_CAPT_PEND);
+
+	set_bit(ST_CAPT_SUSPENDED, &gsc->state);
+	spin_unlock_irqrestore(&gsc->slock, flags);
+
+	if (streaming)
+		return gsc_cap_pipeline_s_stream(gsc, 0);
+	else
+		return 0;
+}
+
+static int gsc_cap_stop_capture(struct gsc_dev *gsc)
+{
+	int ret;
+	if (!gsc_cap_active(gsc)) {
+		gsc_warn("already stopped\n");
+		return 0;
+	}
+	gsc_info("G-Scaler h/w disable control");
+	gsc_hw_enable_control(gsc, false);
+	clear_bit(ST_CAPT_STREAM, &gsc->state);
+	ret = gsc_wait_operating(gsc);
+	if (ret) {
+		gsc_err("GSCALER_OP_STATUS is operating\n");
+		return ret;
+	}
+
+	return gsc_capture_state_cleanup(gsc);
+}
+
+static int gsc_capture_stop_streaming(struct vb2_queue *q)
+{
+	struct gsc_ctx *ctx = q->drv_priv;
+	struct gsc_dev *gsc = ctx->gsc_dev;
+
+	if (!gsc_cap_active(gsc))
+		return -EINVAL;
+
+	return gsc_cap_stop_capture(gsc);
+}
+
+static struct vb2_ops gsc_capture_qops = {
+	.queue_setup		= gsc_capture_queue_setup,
+	.buf_prepare		= gsc_capture_buf_prepare,
+	.buf_queue		= gsc_capture_buf_queue,
+	.wait_prepare		= gsc_unlock,
+	.wait_finish		= gsc_lock,
+	.start_streaming	= gsc_capture_start_streaming,
+	.stop_streaming		= gsc_capture_stop_streaming,
+};
+
+/*
+ * The video node ioctl operations
+ */
+static int gsc_vidioc_querycap_capture(struct file *file, void *priv,
+				       struct v4l2_capability *cap)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+
+	strncpy(cap->driver, gsc->pdev->name, sizeof(cap->driver) - 1);
+	strncpy(cap->card, gsc->pdev->name, sizeof(cap->card) - 1);
+	cap->bus_info[0] = 0;
+	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE_MPLANE;
+
+	return 0;
+}
+
+static int gsc_capture_enum_fmt_mplane(struct file *file, void *priv,
+				    struct v4l2_fmtdesc *f)
+{
+	return gsc_enum_fmt_mplane(f);
+}
+
+static int gsc_capture_try_fmt_mplane(struct file *file, void *fh,
+				   struct v4l2_format *f)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		return -EINVAL;
+
+	return gsc_try_fmt_mplane(gsc->cap.ctx, f);
+}
+
+static int gsc_capture_s_fmt_mplane(struct file *file, void *fh,
+				 struct v4l2_format *f)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+	struct gsc_ctx *ctx = gsc->cap.ctx;
+	struct gsc_frame *frame;
+	struct v4l2_pix_format_mplane *pix;
+	int i, ret = 0;
+
+	ret = gsc_capture_try_fmt_mplane(file, fh, f);
+	if (ret)
+		return ret;
+
+	if (vb2_is_streaming(&gsc->cap.vbq)) {
+		gsc_err("queue (%d) busy", f->type);
+		return -EBUSY;
+	}
+
+	frame = &ctx->d_frame;
+
+	pix = &f->fmt.pix_mp;
+	frame->fmt = find_fmt(&pix->pixelformat, NULL, 0);
+	if (!frame->fmt)
+		return -EINVAL;
+
+	for (i = 0; i < frame->fmt->nr_comp; i++)
+		frame->payload[i] =
+			pix->plane_fmt[i].bytesperline * pix->height;
+
+	gsc_set_frame_size(frame, pix->width, pix->height);
+
+	gsc_info("f_w: %d, f_h: %d", frame->f_width, frame->f_height);
+
+	return 0;
+}
+
+static int gsc_capture_g_fmt_mplane(struct file *file, void *fh,
+				 struct v4l2_format *f)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+	struct gsc_ctx *ctx = gsc->cap.ctx;
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		return -EINVAL;
+
+	return gsc_g_fmt_mplane(ctx, f);
+}
+
+static int gsc_capture_reqbufs(struct file *file, void *priv,
+			    struct v4l2_requestbuffers *reqbufs)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+	struct gsc_capture_device *cap = &gsc->cap;
+	struct gsc_frame *frame;
+	int ret;
+
+	frame = ctx_get_frame(cap->ctx, reqbufs->type);
+
+	ret = vb2_reqbufs(&cap->vbq, reqbufs);
+	if (!ret)
+		cap->reqbufs_cnt = reqbufs->count;
+
+	return ret;
+
+}
+
+static int gsc_capture_querybuf(struct file *file, void *priv,
+			   struct v4l2_buffer *buf)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+	struct gsc_capture_device *cap = &gsc->cap;
+
+	return vb2_querybuf(&cap->vbq, buf);
+}
+
+static int gsc_capture_qbuf(struct file *file, void *priv,
+			  struct v4l2_buffer *buf)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+	struct gsc_capture_device *cap = &gsc->cap;
+
+	return vb2_qbuf(&cap->vbq, buf);
+}
+
+static int gsc_capture_dqbuf(struct file *file, void *priv,
+			   struct v4l2_buffer *buf)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+	return vb2_dqbuf(&gsc->cap.vbq, buf,
+		file->f_flags & O_NONBLOCK);
+}
+
+static int gsc_capture_cropcap(struct file *file, void *fh,
+			    struct v4l2_cropcap *cr)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+	struct gsc_ctx *ctx = gsc->cap.ctx;
+
+	if (cr->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		return -EINVAL;
+
+	cr->bounds.left		= 0;
+	cr->bounds.top		= 0;
+	cr->bounds.width	= ctx->d_frame.f_width;
+	cr->bounds.height	= ctx->d_frame.f_height;
+	cr->defrect		= cr->bounds;
+
+	return 0;
+}
+
+static int gsc_capture_enum_input(struct file *file, void *priv,
+			       struct v4l2_input *i)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+	struct exynos_platform_gscaler *pdata = gsc->pdata;
+	struct exynos_isp_info *isp_info;
+
+	if (i->index >= MAX_CAMIF_CLIENTS)
+		return -EINVAL;
+
+	isp_info = pdata->isp_info[i->index];
+	if (isp_info == NULL)
+		return -EINVAL;
+
+	i->type = V4L2_INPUT_TYPE_CAMERA;
+
+	strncpy(i->name, isp_info->board_info->type, 32);
+
+	return 0;
+}
+
+static int gsc_capture_s_input(struct file *file, void *priv, unsigned int i)
+{
+	return i == 0 ? 0 : -EINVAL;
+}
+
+static int gsc_capture_g_input(struct file *file, void *priv, unsigned int *i)
+{
+	*i = 0;
+	return 0;
+}
+
+int gsc_capture_ctrls_create(struct gsc_dev *gsc)
+{
+	int ret;
+
+	if (WARN_ON(gsc->cap.ctx == NULL))
+		return -ENXIO;
+	if (gsc->cap.ctx->ctrls_rdy)
+		return 0;
+	ret = gsc_ctrls_create(gsc->cap.ctx);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+void gsc_cap_pipeline_prepare(struct gsc_dev *gsc, struct media_entity *me)
+{
+	struct media_entity_graph graph;
+	struct v4l2_subdev *sd;
+
+	media_entity_graph_walk_start(&graph, me);
+
+	while ((me = media_entity_graph_walk_next(&graph))) {
+		gsc_info("me->name : %s", me->name);
+		if (media_entity_type(me) != MEDIA_ENT_T_V4L2_SUBDEV)
+			continue;
+		sd = media_entity_to_v4l2_subdev(me);
+
+		switch (sd->grp_id) {
+		case GSC_CAP_GRP_ID:
+			gsc->pipeline.sd_gsc = sd;
+			break;
+		case FLITE_GRP_ID:
+			gsc->pipeline.flite = sd;
+			break;
+		case SENSOR_GRP_ID:
+			gsc->pipeline.sensor = sd;
+			break;
+		case CSIS_GRP_ID:
+			gsc->pipeline.csis = sd;
+			break;
+		case FIMD_GRP_ID:
+			gsc->pipeline.disp = sd;
+			break;
+		default:
+			gsc_err("Unsupported group id");
+			break;
+		}
+	}
+
+	gsc_info("gsc->pipeline.sd_gsc : 0x%p", gsc->pipeline.sd_gsc);
+	gsc_info("gsc->pipeline.flite : 0x%p", gsc->pipeline.flite);
+	gsc_info("gsc->pipeline.sensor : 0x%p", gsc->pipeline.sensor);
+	gsc_info("gsc->pipeline.csis : 0x%p", gsc->pipeline.csis);
+	gsc_info("gsc->pipeline.disp : 0x%p", gsc->pipeline.disp);
+}
+
+static int __subdev_set_power(struct v4l2_subdev *sd, int on)
+{
+	int *use_count;
+	int ret;
+
+	if (sd == NULL)
+		return -ENXIO;
+
+	use_count = &sd->entity.use_count;
+	if (on && (*use_count)++ > 0)
+		return 0;
+	else if (!on && (*use_count == 0 || --(*use_count) > 0))
+		return 0;
+	ret = v4l2_subdev_call(sd, core, s_power, on);
+
+	return ret != -ENOIOCTLCMD ? ret : 0;
+}
+
+int gsc_cap_pipeline_s_power(struct gsc_dev *gsc, int state)
+{
+	int ret = 0;
+
+	if (!gsc->pipeline.sensor || !gsc->pipeline.flite)
+		return -ENXIO;
+
+	if (state) {
+		ret = __subdev_set_power(gsc->pipeline.flite, 1);
+		if (ret && ret != -ENXIO)
+			return ret;
+		ret = __subdev_set_power(gsc->pipeline.csis, 1);
+		if (ret && ret != -ENXIO)
+			return ret;
+		ret = __subdev_set_power(gsc->pipeline.sensor, 1);
+	} else {
+		ret = __subdev_set_power(gsc->pipeline.flite, 0);
+		if (ret && ret != -ENXIO)
+			return ret;
+		ret = __subdev_set_power(gsc->pipeline.sensor, 0);
+		if (ret && ret != -ENXIO)
+			return ret;
+		ret = __subdev_set_power(gsc->pipeline.csis, 0);
+	}
+	return ret == -ENXIO ? 0 : ret;
+}
+
+static void gsc_set_cam_clock(struct gsc_dev *gsc, bool on)
+{
+	struct v4l2_subdev *sd = NULL;
+	struct gsc_sensor_info *s_info = NULL;
+
+	if (gsc->pipeline.sensor) {
+		sd = gsc->pipeline.sensor;
+		s_info = v4l2_get_subdev_hostdata(sd);
+	}
+	if (on) {
+		clk_enable(gsc->clock);
+		if (gsc->pipeline.sensor)
+			clk_enable(s_info->camclk);
+	} else {
+		clk_disable(gsc->clock);
+		if (gsc->pipeline.sensor)
+			clk_disable(s_info->camclk);
+	}
+}
+
+static int __gsc_cap_pipeline_initialize(struct gsc_dev *gsc,
+					 struct media_entity *me, bool prep)
+{
+	int ret = 0;
+
+	if (prep)
+		gsc_cap_pipeline_prepare(gsc, me);
+	if ((!gsc->pipeline.sensor || !gsc->pipeline.flite) &&
+			!gsc->pipeline.disp)
+		return -EINVAL;
+
+	gsc_set_cam_clock(gsc, true);
+
+	if (gsc->pipeline.sensor && gsc->pipeline.flite)
+		ret = gsc_cap_pipeline_s_power(gsc, 1);
+
+	return ret;
+}
+
+int gsc_cap_pipeline_initialize(struct gsc_dev *gsc, struct media_entity *me,
+				bool prep)
+{
+	int ret;
+
+	mutex_lock(&me->parent->graph_mutex);
+	ret =  __gsc_cap_pipeline_initialize(gsc, me, prep);
+	mutex_unlock(&me->parent->graph_mutex);
+
+	return ret;
+}
+
+static int gsc_capture_open(struct file *file)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+	int ret = v4l2_fh_open(file);
+
+	if (ret)
+		return ret;
+
+	if (gsc_m2m_opened(gsc) || gsc_out_opened(gsc) || gsc_cap_opened(gsc)) {
+		v4l2_fh_release(file);
+		return -EBUSY;
+	}
+
+	set_bit(ST_CAPT_OPEN, &gsc->state);
+	pm_runtime_get_sync(&gsc->pdev->dev);
+
+	if (++gsc->cap.refcnt == 1) {
+		ret = gsc_cap_pipeline_initialize(gsc, &gsc->cap.vfd->entity, true);
+		if (ret < 0) {
+			gsc_err("gsc pipeline initialization failed\n");
+			goto err;
+		}
+
+		ret = gsc_capture_ctrls_create(gsc);
+		if (ret) {
+			gsc_err("failed to create controls\n");
+			goto err;
+		}
+	}
+
+	gsc_info("pid: %d, state: 0x%lx", task_pid_nr(current), gsc->state);
+
+	return 0;
+
+err:
+	pm_runtime_put_sync(&gsc->pdev->dev);
+	v4l2_fh_release(file);
+	clear_bit(ST_CAPT_OPEN, &gsc->state);
+	return ret;
+}
+
+int __gsc_cap_pipeline_shutdown(struct gsc_dev *gsc)
+{
+	int ret = 0;
+
+	if (gsc->pipeline.sensor && gsc->pipeline.flite)
+		ret = gsc_cap_pipeline_s_power(gsc, 0);
+
+	if (ret && ret != -ENXIO)
+		gsc_set_cam_clock(gsc, false);
+
+	return ret == -ENXIO ? 0 : ret;
+}
+
+int gsc_cap_pipeline_shutdown(struct gsc_dev *gsc)
+{
+	struct media_entity *me = &gsc->cap.vfd->entity;
+	int ret;
+
+	mutex_lock(&me->parent->graph_mutex);
+	ret = __gsc_cap_pipeline_shutdown(gsc);
+	mutex_unlock(&me->parent->graph_mutex);
+
+	return ret;
+}
+static int gsc_capture_close(struct file *file)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+
+	gsc_info("pid: %d, state: 0x%lx", task_pid_nr(current), gsc->state);
+
+	if (--gsc->cap.refcnt == 0) {
+		clear_bit(ST_CAPT_OPEN, &gsc->state);
+		gsc_info("G-Scaler h/w disable control");
+		gsc_hw_enable_control(gsc, false);
+		clear_bit(ST_CAPT_STREAM, &gsc->state);
+		gsc_cap_pipeline_shutdown(gsc);
+		clear_bit(ST_CAPT_SUSPENDED, &gsc->state);
+	}
+
+	pm_runtime_put(&gsc->pdev->dev);
+
+	if (gsc->cap.refcnt == 0) {
+		vb2_queue_release(&gsc->cap.vbq);
+		gsc_ctrls_delete(gsc->cap.ctx);
+	}
+
+	return v4l2_fh_release(file);
+}
+
+static unsigned int gsc_capture_poll(struct file *file,
+				      struct poll_table_struct *wait)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+
+	return vb2_poll(&gsc->cap.vbq, file, wait);
+}
+
+static int gsc_capture_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+
+	return vb2_mmap(&gsc->cap.vbq, vma);
+}
+
+static int gsc_cap_link_validate(struct gsc_dev *gsc)
+{
+	struct gsc_capture_device *cap = &gsc->cap;
+	struct v4l2_subdev_format sink_fmt, src_fmt;
+	struct v4l2_subdev *sd;
+	struct media_pad *pad;
+	int ret;
+
+	/* Get the source pad connected with gsc-video */
+	pad =  media_entity_remote_source(&cap->vd_pad);
+	if (pad == NULL)
+		return -EPIPE;
+	/* Get the subdev of source pad */
+	sd = media_entity_to_v4l2_subdev(pad->entity);
+
+	while (1) {
+		/* Find sink pad of the subdev*/
+		pad = &sd->entity.pads[0];
+		if (!(pad->flags & MEDIA_PAD_FL_SINK))
+			break;
+		if (sd == cap->sd_cap) {
+			struct gsc_frame *gf = &cap->ctx->s_frame;
+			sink_fmt.format.width = gf->crop.width;
+			sink_fmt.format.height = gf->crop.height;
+			sink_fmt.format.code = gf->fmt ? gf->fmt->mbus_code : 0;
+		} else {
+			sink_fmt.pad = pad->index;
+			sink_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+			ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &sink_fmt);
+			if (ret < 0 && ret != -ENOIOCTLCMD) {
+				gsc_err("failed %s subdev get_fmt", sd->name);
+				return -EPIPE;
+			}
+		}
+		gsc_info("sink sd name : %s", sd->name);
+		/* Get the source pad connected with remote sink pad */
+		pad = media_entity_remote_source(pad);
+		if (pad == NULL ||
+		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+			break;
+
+		/* Get the subdev of source pad */
+		sd = media_entity_to_v4l2_subdev(pad->entity);
+		gsc_info("source sd name : %s", sd->name);
+
+		src_fmt.pad = pad->index;
+		src_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+		ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &src_fmt);
+		if (ret < 0 && ret != -ENOIOCTLCMD) {
+			gsc_err("failed %s subdev get_fmt", sd->name);
+			return -EPIPE;
+		}
+
+		gsc_info("src_width : %d, src_height : %d, src_code : %d",
+			src_fmt.format.width, src_fmt.format.height,
+			src_fmt.format.code);
+		gsc_info("sink_width : %d, sink_height : %d, sink_code : %d",
+			sink_fmt.format.width, sink_fmt.format.height,
+			sink_fmt.format.code);
+
+		if (src_fmt.format.width != sink_fmt.format.width ||
+		    src_fmt.format.height != sink_fmt.format.height ||
+		    src_fmt.format.code != sink_fmt.format.code) {
+			gsc_err("mismatch sink and source");
+			return -EPIPE;
+		}
+	}
+
+	return 0;
+}
+
+static int gsc_capture_streamon(struct file *file, void *priv,
+				enum v4l2_buf_type type)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+	struct gsc_pipeline *p = &gsc->pipeline;
+	int ret;
+
+	if (gsc_cap_active(gsc))
+		return -EBUSY;
+
+	if (p->disp) {
+		media_entity_pipeline_start(&p->disp->entity, p->pipe);
+	} else if (p->sensor) {
+		media_entity_pipeline_start(&p->sensor->entity, p->pipe);
+	} else {
+		gsc_err("Error pipeline");
+		return -EPIPE;
+	}
+
+	ret = gsc_cap_link_validate(gsc);
+	if (ret)
+		return ret;
+
+	return vb2_streamon(&gsc->cap.vbq, type);
+}
+
+static int gsc_capture_streamoff(struct file *file, void *priv,
+			    enum v4l2_buf_type type)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+	struct v4l2_subdev *sd = gsc->pipeline.sensor;
+	int ret;
+
+	ret = vb2_streamoff(&gsc->cap.vbq, type);
+	if (ret == 0)
+		media_entity_pipeline_stop(&sd->entity);
+	return ret;
+}
+
+static struct v4l2_subdev *gsc_cap_remote_subdev(struct gsc_dev *gsc, u32 *pad)
+{
+	struct media_pad *remote;
+
+	remote = media_entity_remote_source(&gsc->cap.vd_pad);
+
+	if (remote == NULL ||
+	    media_entity_type(remote->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+		return NULL;
+
+	if (pad)
+		*pad = remote->index;
+
+	return media_entity_to_v4l2_subdev(remote->entity);
+}
+
+static int gsc_capture_g_crop(struct file *file, void *fh, struct v4l2_crop *crop)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+	struct v4l2_subdev_format format;
+	struct v4l2_subdev *subdev;
+	u32 pad;
+	int ret;
+
+	subdev = gsc_cap_remote_subdev(gsc, &pad);
+	if (subdev == NULL)
+		return -EINVAL;
+
+	/* Try the get crop operation first and fallback to get format if not
+	 * implemented.
+	 */
+	ret = v4l2_subdev_call(subdev, video, g_crop, crop);
+	if (ret != -ENOIOCTLCMD)
+		return ret;
+
+	format.pad = pad;
+	format.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &format);
+	if (ret < 0)
+		return ret == -ENOIOCTLCMD ? -EINVAL : ret;
+
+	crop->c.left = 0;
+	crop->c.top = 0;
+	crop->c.width = format.format.width;
+	crop->c.height = format.format.height;
+
+	return 0;
+}
+
+static int gsc_capture_s_crop(struct file *file, void *fh, struct v4l2_crop *crop)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+	struct v4l2_subdev *subdev;
+	int ret;
+
+	subdev = gsc_cap_remote_subdev(gsc, NULL);
+	if (subdev == NULL)
+		return -EINVAL;
+
+	ret = v4l2_subdev_call(subdev, video, s_crop, crop);
+
+	return ret == -ENOIOCTLCMD ? -EINVAL : ret;
+}
+
+static const struct v4l2_ioctl_ops gsc_capture_ioctl_ops = {
+	.vidioc_querycap		= gsc_vidioc_querycap_capture,
+
+	.vidioc_enum_fmt_vid_cap_mplane	= gsc_capture_enum_fmt_mplane,
+	.vidioc_try_fmt_vid_cap_mplane	= gsc_capture_try_fmt_mplane,
+	.vidioc_s_fmt_vid_cap_mplane	= gsc_capture_s_fmt_mplane,
+	.vidioc_g_fmt_vid_cap_mplane	= gsc_capture_g_fmt_mplane,
+
+	.vidioc_reqbufs			= gsc_capture_reqbufs,
+	.vidioc_querybuf		= gsc_capture_querybuf,
+
+	.vidioc_qbuf			= gsc_capture_qbuf,
+	.vidioc_dqbuf			= gsc_capture_dqbuf,
+
+	.vidioc_streamon		= gsc_capture_streamon,
+	.vidioc_streamoff		= gsc_capture_streamoff,
+
+	.vidioc_g_crop			= gsc_capture_g_crop,
+	.vidioc_s_crop			= gsc_capture_s_crop,
+	.vidioc_cropcap			= gsc_capture_cropcap,
+
+	.vidioc_enum_input		= gsc_capture_enum_input,
+	.vidioc_s_input			= gsc_capture_s_input,
+	.vidioc_g_input			= gsc_capture_g_input,
+};
+
+static const struct v4l2_file_operations gsc_capture_fops = {
+	.owner		= THIS_MODULE,
+	.open		= gsc_capture_open,
+	.release	= gsc_capture_close,
+	.poll		= gsc_capture_poll,
+	.unlocked_ioctl	= video_ioctl2,
+	.mmap		= gsc_capture_mmap,
+};
+
+/*
+ * __gsc_cap_get_format - helper function for getting gscaler format
+ * @res   : pointer to resizer private structure
+ * @pad   : pad number
+ * @fh    : V4L2 subdev file handle
+ * @which : wanted subdev format
+ * return zero
+ */
+static struct v4l2_mbus_framefmt *__gsc_cap_get_format(struct gsc_dev *gsc,
+				struct v4l2_subdev_fh *fh, unsigned int pad,
+				enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_format(fh, pad);
+	else
+		return &gsc->cap.mbus_fmt[pad];
+}
+
+static void gsc_cap_check_limit_size(struct gsc_dev *gsc, unsigned int pad,
+				   struct v4l2_mbus_framefmt *fmt)
+{
+	struct gsc_variant *variant = gsc->variant;
+	struct gsc_ctx *ctx = gsc->cap.ctx;
+	u32 min_w, min_h, max_w, max_h;
+
+	switch (pad) {
+	case GSC_PAD_SINK:
+		if (gsc_cap_opened(gsc) &&
+		    (ctx->gsc_ctrls.rotate->val == 90 ||
+		    ctx->gsc_ctrls.rotate->val == 270)) {
+			min_w = variant->pix_min->real_w;
+			min_h = variant->pix_min->real_h;
+			max_w = variant->pix_max->real_rot_en_w;
+			max_h = variant->pix_max->real_rot_en_h;
+		} else {
+			min_w = variant->pix_min->real_w;
+			min_h = variant->pix_min->real_h;
+			max_w = variant->pix_max->real_rot_dis_w;
+			max_h = variant->pix_max->real_rot_dis_h;
+		}
+		break;
+
+	case GSC_PAD_SOURCE:
+		min_w = variant->pix_min->target_rot_dis_w;
+		min_h = variant->pix_min->target_rot_dis_h;
+		max_w = variant->pix_max->target_rot_dis_w;
+		max_h = variant->pix_max->target_rot_dis_h;
+		break;
+	}
+
+	fmt->width = clamp_t(u32, fmt->width, min_w, max_w);
+	fmt->height = clamp_t(u32, fmt->height , min_h, max_h);
+}
+
+static void gsc_cap_try_format(struct gsc_dev *gsc,
+			       struct v4l2_subdev_fh *fh, unsigned int pad,
+			       struct v4l2_mbus_framefmt *fmt,
+			       enum v4l2_subdev_format_whence which)
+{
+	struct gsc_fmt *gfmt;
+
+	gfmt = find_fmt(NULL, &fmt->code, 0);
+	WARN_ON(!gfmt);
+
+	if (pad == GSC_PAD_SINK) {
+		struct gsc_ctx *ctx = gsc->cap.ctx;
+		struct gsc_frame *frame = &ctx->s_frame;
+
+		frame->fmt = gfmt;
+	}
+
+	gsc_cap_check_limit_size(gsc, pad, fmt);
+
+	fmt->colorspace = V4L2_COLORSPACE_JPEG;
+	fmt->field = V4L2_FIELD_NONE;
+}
+
+static int gsc_capture_subdev_set_fmt(struct v4l2_subdev *sd,
+				      struct v4l2_subdev_fh *fh,
+				      struct v4l2_subdev_format *fmt)
+{
+	struct gsc_dev *gsc = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *mf;
+	struct gsc_ctx *ctx = gsc->cap.ctx;
+	struct gsc_frame *frame;
+
+	mf = __gsc_cap_get_format(gsc, fh, fmt->pad, fmt->which);
+	if (mf == NULL)
+		return -EINVAL;
+
+	gsc_cap_try_format(gsc, fh, fmt->pad, &fmt->format, fmt->which);
+	*mf = fmt->format;
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY)
+		return 0;
+
+	frame = gsc_capture_get_frame(ctx, fmt->pad);
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		frame->crop.left = 0;
+		frame->crop.top = 0;
+		frame->f_width = mf->width;
+		frame->f_height = mf->height;
+		frame->crop.width = mf->width;
+		frame->crop.height = mf->height;
+	}
+	gsc_dbg("offs_h : %d, offs_v : %d, f_width : %d, f_height :%d,\
+				width : %d, height : %d", frame->crop.left,\
+				frame->crop.top, frame->f_width,
+				frame->f_height,\
+				frame->crop.width, frame->crop.height);
+
+	return 0;
+}
+
+static int gsc_capture_subdev_get_fmt(struct v4l2_subdev *sd,
+				      struct v4l2_subdev_fh *fh,
+				      struct v4l2_subdev_format *fmt)
+{
+	struct gsc_dev *gsc = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *mf;
+
+	mf = __gsc_cap_get_format(gsc, fh, fmt->pad, fmt->which);
+	if (mf == NULL)
+		return -EINVAL;
+
+	fmt->format = *mf;
+
+	return 0;
+}
+
+static int __gsc_cap_get_crop(struct gsc_dev *gsc, struct v4l2_subdev_fh *fh,
+			      unsigned int pad, enum v4l2_subdev_format_whence which,
+				struct v4l2_rect *crop)
+{
+	struct gsc_ctx *ctx = gsc->cap.ctx;
+	struct gsc_frame *frame = gsc_capture_get_frame(ctx, pad);
+
+	if (which == V4L2_SUBDEV_FORMAT_TRY) {
+		crop = v4l2_subdev_get_try_crop(fh, pad);
+	} else {
+		crop->left = frame->crop.left;
+		crop->top = frame->crop.top;
+		crop->width = frame->crop.width;
+		crop->height = frame->crop.height;
+	}
+
+	return 0;
+}
+
+static void gsc_cap_try_crop(struct gsc_dev *gsc, struct v4l2_rect *crop,
+				u32 pad)
+{
+	struct gsc_variant *variant = gsc->variant;
+	struct gsc_ctx *ctx = gsc->cap.ctx;
+	struct gsc_frame *frame = gsc_capture_get_frame(ctx, pad);
+
+	u32 crop_min_w = variant->pix_min->target_rot_dis_w;
+	u32 crop_min_h = variant->pix_min->target_rot_dis_h;
+	u32 crop_max_w = frame->f_width;
+	u32 crop_max_h = frame->f_height;
+
+	crop->left = clamp_t(u32, crop->left, 0, crop_max_w - crop_min_w);
+	crop->top = clamp_t(u32, crop->top, 0, crop_max_h - crop_min_h);
+	crop->width = clamp_t(u32, crop->width, crop_min_w, crop_max_w);
+	crop->height = clamp_t(u32, crop->height, crop_min_h, crop_max_h);
+}
+
+static int gsc_capture_subdev_set_crop(struct v4l2_subdev *sd,
+				       struct v4l2_subdev_fh *fh,
+				       struct v4l2_subdev_crop *crop)
+{
+	struct gsc_dev *gsc = v4l2_get_subdevdata(sd);
+	struct gsc_ctx *ctx = gsc->cap.ctx;
+	struct gsc_frame *frame = gsc_capture_get_frame(ctx, crop->pad);
+
+	gsc_cap_try_crop(gsc, &crop->rect, crop->pad);
+
+	if (crop->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		frame->crop = crop->rect;
+
+	return 0;
+}
+
+static int gsc_capture_subdev_get_crop(struct v4l2_subdev *sd,
+				       struct v4l2_subdev_fh *fh,
+				       struct v4l2_subdev_crop *crop)
+{
+	struct gsc_dev *gsc = v4l2_get_subdevdata(sd);
+	struct v4l2_rect gcrop = {0, };
+
+	__gsc_cap_get_crop(gsc, fh, crop->pad, crop->which, &gcrop);
+	crop->rect = gcrop;
+
+	return 0;
+}
+
+static struct v4l2_subdev_pad_ops gsc_cap_subdev_pad_ops = {
+	.get_fmt = gsc_capture_subdev_get_fmt,
+	.set_fmt = gsc_capture_subdev_set_fmt,
+	.get_crop = gsc_capture_subdev_get_crop,
+	.set_crop = gsc_capture_subdev_set_crop,
+};
+
+static struct v4l2_subdev_video_ops gsc_cap_subdev_video_ops = {
+	.s_stream = gsc_capture_subdev_s_stream,
+};
+
+static struct v4l2_subdev_ops gsc_cap_subdev_ops = {
+	.pad = &gsc_cap_subdev_pad_ops,
+	.video = &gsc_cap_subdev_video_ops,
+};
+
+static int gsc_capture_init_formats(struct v4l2_subdev *sd,
+				    struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_subdev_format format;
+	struct gsc_dev *gsc = v4l2_get_subdevdata(sd);
+	struct gsc_ctx *ctx = gsc->cap.ctx;
+
+	ctx->s_frame.fmt = get_format(2);
+	memset(&format, 0, sizeof(format));
+	format.pad = GSC_PAD_SINK;
+	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
+	format.format.code = ctx->s_frame.fmt->mbus_code;
+	format.format.width = DEFAULT_GSC_SINK_WIDTH;
+	format.format.height = DEFAULT_GSC_SINK_HEIGHT;
+	gsc_capture_subdev_set_fmt(sd, fh, &format);
+
+	/* G-scaler should not propagate, because it is possible that sink
+	 * format different from source format. But the operation of source pad
+	 * is not needed.
+	 */
+	ctx->d_frame.fmt = get_format(2);
+
+	return 0;
+}
+
+static int gsc_capture_subdev_close(struct v4l2_subdev *sd,
+				    struct v4l2_subdev_fh *fh)
+{
+	gsc_dbg("");
+
+	return 0;
+}
+
+static int gsc_capture_subdev_registered(struct v4l2_subdev *sd)
+{
+	gsc_dbg("");
+
+	return 0;
+}
+
+static void gsc_capture_subdev_unregistered(struct v4l2_subdev *sd)
+{
+	gsc_dbg("");
+}
+
+static const struct v4l2_subdev_internal_ops gsc_cap_v4l2_internal_ops = {
+	.open = gsc_capture_init_formats,
+	.close = gsc_capture_subdev_close,
+	.registered = gsc_capture_subdev_registered,
+	.unregistered = gsc_capture_subdev_unregistered,
+};
+
+static int gsc_capture_link_setup(struct media_entity *entity,
+				  const struct media_pad *local,
+				  const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct gsc_dev *gsc = v4l2_get_subdevdata(sd);
+	struct gsc_capture_device *cap = &gsc->cap;
+
+	gsc_info("");
+	switch (local->index | media_entity_type(remote->entity)) {
+	case GSC_PAD_SINK | MEDIA_ENT_T_V4L2_SUBDEV:
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (cap->input != 0)
+				return -EBUSY;
+			/* Write-Back link enabled */
+			if (!strcmp(remote->entity->name, FIMD_MODULE_NAME)) {
+				gsc->cap.sd_disp =
+					media_entity_to_v4l2_subdev(remote->entity);
+				gsc->cap.sd_disp->grp_id = FIMD_GRP_ID;
+				cap->ctx->in_path = GSC_WRITEBACK;
+				cap->input |= GSC_IN_FIMD_WRITEBACK;
+			} else if (remote->index == FLITE_PAD_SOURCE_PREV) {
+				cap->input |= GSC_IN_FLITE_PREVIEW;
+			} else {
+				cap->input |= GSC_IN_FLITE_CAMCORDING;
+			}
+		} else {
+			cap->input = GSC_IN_NONE;
+		}
+		break;
+	case GSC_PAD_SOURCE | MEDIA_ENT_T_DEVNODE:
+		/* gsc-cap always write to memory */
+		break;
+	}
+
+	return 0;
+}
+
+static const struct media_entity_operations gsc_cap_media_ops = {
+	.link_setup = gsc_capture_link_setup,
+};
+
+static int gsc_capture_create_subdev(struct gsc_dev *gsc)
+{
+	struct v4l2_device *v4l2_dev;
+	struct v4l2_subdev *sd;
+	int ret;
+
+	sd = kzalloc(sizeof(*sd), GFP_KERNEL);
+	if (!sd)
+	       return -ENOMEM;
+
+	v4l2_subdev_init(sd, &gsc_cap_subdev_ops);
+	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
+	snprintf(sd->name, sizeof(sd->name), "gsc-cap-subdev.%d", gsc->id);
+
+	gsc->cap.sd_pads[GSC_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	gsc->cap.sd_pads[GSC_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_init(&sd->entity, GSC_PADS_NUM,
+				gsc->cap.sd_pads, 0);
+	if (ret)
+		goto err_ent;
+
+	sd->internal_ops = &gsc_cap_v4l2_internal_ops;
+	sd->entity.ops = &gsc_cap_media_ops;
+	sd->grp_id = GSC_CAP_GRP_ID;
+	v4l2_dev = &gsc->mdev[MDEV_CAPTURE]->v4l2_dev;
+
+	ret = v4l2_device_register_subdev(v4l2_dev, sd);
+	if (ret)
+		goto err_sub;
+
+	gsc->mdev[MDEV_CAPTURE]->gsc_cap_sd[gsc->id] = sd;
+	gsc->cap.sd_cap = sd;
+	v4l2_set_subdevdata(sd, gsc);
+	gsc_capture_init_formats(sd, NULL);
+
+	return 0;
+
+err_sub:
+	media_entity_cleanup(&sd->entity);
+err_ent:
+	kfree(sd);
+	return ret;
+}
+
+static int gsc_capture_create_link(struct gsc_dev *gsc)
+{
+	struct media_entity *source, *sink;
+	struct exynos_platform_gscaler *pdata = gsc->pdata;
+	struct exynos_isp_info *isp_info;
+	u32 num_clients = pdata->num_clients;
+	int ret, i;
+	enum cam_port id;
+
+	/* GSC-SUBDEV ------> GSC-VIDEO (Always link enable) */
+	source = &gsc->cap.sd_cap->entity;
+	sink = &gsc->cap.vfd->entity;
+	if (source && sink) {
+		ret = media_entity_create_link(source, GSC_PAD_SOURCE, sink,
+				0, MEDIA_LNK_FL_IMMUTABLE |
+				MEDIA_LNK_FL_ENABLED);
+		if (ret) {
+			gsc_err("failed link flite to gsc\n");
+			return ret;
+		}
+	}
+	for (i = 0; i < num_clients; i++) {
+		isp_info = pdata->isp_info[i];
+		id = isp_info->cam_port;
+		/* FIMC-LITE ------> GSC-SUBDEV (ITU & MIPI common) */
+		source = &gsc->cap.sd_flite[id]->entity;
+		sink = &gsc->cap.sd_cap->entity;
+		if (source && sink) {
+			if (pdata->cam_preview)
+				ret = media_entity_create_link(source,
+						FLITE_PAD_SOURCE_PREV,
+						sink, GSC_PAD_SINK, 0);
+			if (!ret && pdata->cam_camcording)
+				ret = media_entity_create_link(source,
+						FLITE_PAD_SOURCE_CAMCORD,
+						sink, GSC_PAD_SINK, 0);
+			if (ret) {
+				gsc_err("failed link flite to gsc\n");
+				return ret;
+			}
+		}
+	}
+
+	return 0;
+}
+
+static struct v4l2_subdev *gsc_cap_register_sensor(struct gsc_dev *gsc, int i)
+{
+	struct exynos_md *mdev = gsc->mdev[MDEV_CAPTURE];
+	struct v4l2_subdev *sd = NULL;
+
+	sd = mdev->sensor_sd[i];
+	if (!sd)
+		return NULL;
+
+	v4l2_set_subdev_hostdata(sd, &gsc->cap.sensor[i]);
+
+	return sd;
+}
+
+static int gsc_cap_register_sensor_entities(struct gsc_dev *gsc)
+{
+	struct exynos_platform_gscaler *pdata = gsc->pdata;
+	u32 num_clients = pdata->num_clients;
+	int i;
+
+	for (i = 0; i < num_clients; i++) {
+		gsc->cap.sensor[i].pdata = pdata->isp_info[i];
+		gsc->cap.sensor[i].sd = gsc_cap_register_sensor(gsc, i);
+		if (IS_ERR_OR_NULL(gsc->cap.sensor[i].sd)) {
+			gsc_err("failed to get register sensor");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int gsc_cap_config_camclk(struct gsc_dev *gsc,
+		struct exynos_isp_info *isp_info, int i)
+{
+	struct gsc_capture_device *gsc_cap = &gsc->cap;
+	struct clk *camclk;
+	struct clk *srclk;
+
+	camclk = clk_get(&gsc->pdev->dev, isp_info->cam_clk_name);
+	if (IS_ERR_OR_NULL(camclk)) {
+		gsc_err("failed to get cam clk");
+		return -ENXIO;
+	}
+	gsc_cap->sensor[i].camclk = camclk;
+
+	srclk = clk_get(&gsc->pdev->dev, isp_info->cam_srclk_name);
+	if (IS_ERR_OR_NULL(srclk)) {
+		clk_put(camclk);
+		gsc_err("failed to get cam source clk\n");
+		return -ENXIO;
+	}
+	clk_set_parent(camclk, srclk);
+	clk_set_rate(camclk, isp_info->clk_frequency);
+	clk_put(srclk);
+
+	return 0;
+}
+
+int gsc_register_capture_device(struct gsc_dev *gsc)
+{
+	struct video_device *vfd;
+	struct gsc_capture_device *gsc_cap;
+	struct gsc_ctx *ctx;
+	struct vb2_queue *q;
+	struct exynos_platform_gscaler *pdata = gsc->pdata;
+	struct exynos_isp_info *isp_info;
+	int ret = -ENOMEM;
+	int i;
+
+	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	ctx->gsc_dev	 = gsc;
+	ctx->in_path	 = GSC_CAMERA;
+	ctx->out_path	 = GSC_DMA;
+	ctx->state	 = GSC_CTX_CAP;
+
+	vfd = video_device_alloc();
+	if (!vfd) {
+		printk("Failed to allocate video device\n");
+		goto err_ctx_alloc;
+	}
+
+	snprintf(vfd->name, sizeof(vfd->name), "%s.capture",
+		 dev_name(&gsc->pdev->dev));
+
+	vfd->fops	= &gsc_capture_fops;
+	vfd->ioctl_ops	= &gsc_capture_ioctl_ops;
+	vfd->v4l2_dev	= &gsc->mdev[MDEV_CAPTURE]->v4l2_dev;
+	vfd->minor	= -1;
+	vfd->release	= video_device_release;
+	vfd->lock	= &gsc->lock;
+	video_set_drvdata(vfd, gsc);
+
+	gsc_cap	= &gsc->cap;
+	gsc_cap->vfd = vfd;
+	gsc_cap->refcnt = 0;
+	gsc_cap->active_buf_cnt = 0;
+	gsc_cap->reqbufs_cnt  = 0;
+
+	spin_lock_init(&ctx->slock);
+	gsc_cap->ctx = ctx;
+
+	q = &gsc->cap.vbq;
+	memset(q, 0, sizeof(*q));
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	q->io_modes = VB2_MMAP | VB2_USERPTR;
+	q->drv_priv = gsc->cap.ctx;
+	q->ops = &gsc_capture_qops;
+	q->mem_ops = &vb2_dma_contig_memops;
+
+	vb2_queue_init(q);
+
+	/* Get mipi-csis and fimc-lite subdev ptr using mdev */
+	for (i = 0; i < FLITE_MAX_ENTITIES; i++)
+		gsc->cap.sd_flite[i] = gsc->mdev[MDEV_CAPTURE]->flite_sd[i];
+
+	for (i = 0; i < CSIS_MAX_ENTITIES; i++)
+		gsc->cap.sd_csis[i] = gsc->mdev[MDEV_CAPTURE]->csis_sd[i];
+
+	for (i = 0; i < pdata->num_clients; i++) {
+		isp_info = pdata->isp_info[i];
+		ret = gsc_cap_config_camclk(gsc, isp_info, i);
+		if (ret) {
+			gsc_err("failed setup cam clk");
+			goto err_ctx_alloc;
+		}
+	}
+
+	ret = gsc_cap_register_sensor_entities(gsc);
+	if (ret) {
+		gsc_err("failed register sensor entities");
+		goto err_clk;
+	}
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
+	if (ret) {
+		gsc_err("failed to register video device");
+		goto err_clk;
+	}
+
+	gsc->cap.vd_pad.flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_init(&vfd->entity, 1, &gsc->cap.vd_pad, 0);
+	if (ret) {
+		gsc_err("failed to initialize entity");
+		goto err_ent;
+	}
+
+	ret = gsc_capture_create_subdev(gsc);
+	if (ret) {
+		gsc_err("failed create subdev");
+		goto err_sd_reg;
+	}
+
+	ret = gsc_capture_create_link(gsc);
+	if (ret) {
+		gsc_err("failed create link");
+		goto err_sd_reg;
+	}
+
+	vfd->ctrl_handler = &ctx->ctrl_handler;
+	gsc_dbg("gsc capture driver registered as /dev/video%d", vfd->num);
+
+	return 0;
+
+err_sd_reg:
+	media_entity_cleanup(&vfd->entity);
+err_ent:
+	video_device_release(vfd);
+err_clk:
+	for (i = 0; i < pdata->num_clients; i++)
+		clk_put(gsc_cap->sensor[i].camclk);
+err_ctx_alloc:
+	kfree(ctx);
+
+	return ret;
+}
+
+static void gsc_capture_destroy_subdev(struct gsc_dev *gsc)
+{
+	struct v4l2_subdev *sd = gsc->cap.sd_cap;
+
+	if (!sd)
+		return;
+	media_entity_cleanup(&sd->entity);
+	v4l2_device_unregister_subdev(sd);
+	kfree(sd);
+	sd = NULL;
+}
+
+void gsc_unregister_capture_device(struct gsc_dev *gsc)
+{
+	struct video_device *vfd = gsc->cap.vfd;
+
+	if (vfd) {
+		media_entity_cleanup(&vfd->entity);
+		/* Can also be called if video device was
+		   not registered */
+		video_unregister_device(vfd);
+	}
+	gsc_capture_destroy_subdev(gsc);
+	kfree(gsc->cap.ctx);
+	gsc->cap.ctx = NULL;
+}
+
diff --git a/drivers/media/video/exynos/gsc/gsc-core.c b/drivers/media/video/exynos/gsc/gsc-core.c
new file mode 100644
index 0000000..9c8e9ce
--- /dev/null
+++ b/drivers/media/video/exynos/gsc/gsc-core.c
@@ -0,0 +1,1315 @@
+/* linux/drivers/media/video/exynos/gsc/gsc-core.c
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Samsung EXYNOS5 SoC series G-scaler driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation, either version 2 of the License,
+ * or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/version.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/bug.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/list.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <media/v4l2-ioctl.h>
+
+#include "gsc-core.h"
+#define GSC_CLOCK_GATE_NAME		"gscl"
+
+int gsc_dbg = 6;
+module_param(gsc_dbg, int, 0644);
+
+static struct gsc_fmt gsc_formats[] = {
+	{
+		.name		= "RGB565",
+		.pixelformat	= V4L2_PIX_FMT_RGB565X,
+		.depth		= { 16 },
+		.color		= GSC_RGB,
+		.num_planes	= 1,
+		.nr_comp	= 1,
+	}, {
+		.name		= "XRGB-8-8-8-8, 32 bpp",
+		.pixelformat	= V4L2_PIX_FMT_RGB32,
+		.depth		= { 32 },
+		.color		= GSC_RGB,
+		.num_planes	= 1,
+		.nr_comp	= 1,
+	}, {
+		.name		= "YUV 4:2:2 packed, YCbYCr",
+		.pixelformat	= V4L2_PIX_FMT_YUYV,
+		.depth		= { 16 },
+		.color		= GSC_YUV422,
+		.yorder		= GSC_LSB_Y,
+		.corder		= GSC_CBCR,
+		.num_planes	= 1,
+		.nr_comp	= 1,
+		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
+	}, {
+		.name		= "YUV 4:2:2 packed, CbYCrY",
+		.pixelformat	= V4L2_PIX_FMT_UYVY,
+		.depth		= { 16 },
+		.color		= GSC_YUV422,
+		.yorder		= GSC_LSB_C,
+		.corder		= GSC_CBCR,
+		.num_planes	= 1,
+		.nr_comp	= 1,
+		.mbus_code	= V4L2_MBUS_FMT_UYVY8_2X8,
+	}, {
+		.name		= "YUV 4:2:2 packed, CrYCbY",
+		.pixelformat	= V4L2_PIX_FMT_VYUY,
+		.depth		= { 16 },
+		.color		= GSC_YUV422,
+		.yorder		= GSC_LSB_C,
+		.corder		= GSC_CRCB,
+		.num_planes	= 1,
+		.nr_comp	= 1,
+		.mbus_code	= V4L2_MBUS_FMT_VYUY8_2X8,
+	}, {
+		.name		= "YUV 4:2:2 packed, YCrYCb",
+		.pixelformat	= V4L2_PIX_FMT_YVYU,
+		.depth		= { 16 },
+		.color		= GSC_YUV422,
+		.yorder		= GSC_LSB_Y,
+		.corder		= GSC_CRCB,
+		.num_planes	= 1,
+		.nr_comp	= 1,
+		.mbus_code	= V4L2_MBUS_FMT_YVYU8_2X8,
+	}, {
+		.name		= "YUV 4:4:4 planar, YCbYCr",
+		.pixelformat	= V4L2_PIX_FMT_YUV32,
+		.depth		= { 32 },
+		.color		= GSC_YUV444,
+		.yorder		= GSC_LSB_Y,
+		.corder		= GSC_CBCR,
+		.num_planes	= 1,
+		.nr_comp	= 1,
+	}, {
+		.name		= "YUV 4:2:2 planar, Y/Cb/Cr",
+		.pixelformat	= V4L2_PIX_FMT_YUV422P,
+		.depth		= { 16 },
+		.color		= GSC_YUV422,
+		.yorder		= GSC_LSB_Y,
+		.corder		= GSC_CBCR,
+		.num_planes	= 1,
+		.nr_comp	= 3,
+	}, {
+		.name		= "YUV 4:2:2 planar, Y/CbCr",
+		.pixelformat	= V4L2_PIX_FMT_NV16,
+		.depth		= { 16 },
+		.color		= GSC_YUV422,
+		.yorder		= GSC_LSB_Y,
+		.corder		= GSC_CBCR,
+		.num_planes	= 1,
+		.nr_comp	= 2,
+	}, {
+		.name		= "YUV 4:2:2 planar, Y/CrCb",
+		.pixelformat	= V4L2_PIX_FMT_NV61,
+		.depth		= { 16 },
+		.color		= GSC_YUV422,
+		.yorder		= GSC_LSB_Y,
+		.corder		= GSC_CRCB,
+		.num_planes	= 1,
+		.nr_comp	= 2,
+	}, {
+		.name		= "YUV 4:2:0 planar, YCbCr",
+		.pixelformat	= V4L2_PIX_FMT_YUV420,
+		.depth		= { 12 },
+		.color		= GSC_YUV420,
+		.yorder		= GSC_LSB_Y,
+		.corder		= GSC_CBCR,
+		.num_planes	= 1,
+		.nr_comp	= 3,
+	}, {
+		.name		= "YUV 4:2:0 planar, YCbCr",
+		.pixelformat	= V4L2_PIX_FMT_YVU420,
+		.depth		= { 12 },
+		.color		= GSC_YUV420,
+		.yorder		= GSC_LSB_Y,
+		.corder		= GSC_CRCB,
+		.num_planes	= 1,
+		.nr_comp	= 3,
+
+	}, {
+		.name		= "YUV 4:2:0 planar, Y/CbCr",
+		.pixelformat	= V4L2_PIX_FMT_NV12,
+		.depth		= { 12 },
+		.color		= GSC_YUV420,
+		.yorder		= GSC_LSB_Y,
+		.corder		= GSC_CBCR,
+		.num_planes	= 1,
+		.nr_comp	= 2,
+	}, {
+		.name		= "YUV 4:2:0 planar, Y/CrCb",
+		.pixelformat	= V4L2_PIX_FMT_NV21,
+		.depth		= { 12 },
+		.color		= GSC_YUV420,
+		.yorder		= GSC_LSB_Y,
+		.corder		= GSC_CRCB,
+		.num_planes	= 1,
+		.nr_comp	= 2,
+	}, {
+		.name		= "YUV 4:2:0 non-contiguous 2-planar, Y/CbCr",
+		.pixelformat	= V4L2_PIX_FMT_NV12M,
+		.depth		= { 8, 4 },
+		.color		= GSC_YUV420,
+		.yorder		= GSC_LSB_Y,
+		.corder		= GSC_CBCR,
+		.num_planes	= 2,
+		.nr_comp	= 2,
+	}, {
+		.name		= "YUV 4:2:0 non-contiguous 3-planar, Y/Cb/Cr",
+		.pixelformat	= V4L2_PIX_FMT_YUV420M,
+		.depth		= { 8, 2, 2 },
+		.color		= GSC_YUV420,
+		.yorder		= GSC_LSB_Y,
+		.corder		= GSC_CBCR,
+		.num_planes	= 3,
+		.nr_comp	= 3,
+	},
+};
+
+struct gsc_fmt *get_format(int index)
+{
+	return &gsc_formats[index];
+}
+
+struct gsc_fmt *find_fmt(u32 *pixelformat, u32 *mbus_code, int index)
+{
+	struct gsc_fmt *fmt, *def_fmt = NULL;
+	unsigned int i;
+
+	if (index >= ARRAY_SIZE(gsc_formats))
+		return NULL;
+
+	for (i = 0; i < ARRAY_SIZE(gsc_formats); ++i) {
+		fmt = get_format(i);
+		if (pixelformat && fmt->pixelformat == *pixelformat)
+			return fmt;
+		if (mbus_code && fmt->mbus_code == *mbus_code)
+			return fmt;
+		if (index == i)
+			def_fmt = fmt;
+	}
+	return def_fmt;
+
+}
+
+void gsc_set_frame_size(struct gsc_frame *frame, int width, int height)
+{
+	frame->f_width	= width;
+	frame->f_height	= height;
+	frame->crop.width = width;
+	frame->crop.height = height;
+	frame->crop.left = 0;
+	frame->crop.top = 0;
+}
+
+int gsc_cal_prescaler_ratio(struct gsc_variant *var, u32 src, u32 dst, u32 *ratio)
+{
+	if ((dst > src) || (dst >= src / var->poly_sc_down_max)) {
+		*ratio = 1;
+		return 0;
+	}
+
+	if ((src / var->poly_sc_down_max / var->pre_sc_down_max) > dst) {
+		gsc_err("scale ratio exceeded maximun scale down ratio(1/16)");
+		return -EINVAL;
+	}
+
+	*ratio = (dst > (src / 8)) ? 2 : 4;
+
+	return 0;
+}
+
+void gsc_get_prescaler_shfactor(u32 hratio, u32 vratio, u32 *sh)
+{
+	if (hratio == 4 && vratio == 4)
+		*sh = 4;
+	else if ((hratio == 4 && vratio == 2) ||
+		 (hratio == 2 && vratio == 4))
+		*sh = 3;
+	else if ((hratio == 4 && vratio == 1) ||
+		 (hratio == 1 && vratio == 4) ||
+		 (hratio == 2 && vratio == 2))
+		*sh = 2;
+	else if (hratio == 1 && vratio == 1)
+		*sh = 0;
+	else
+		*sh = 1;
+}
+
+void gsc_check_src_scale_info(struct gsc_variant *var, struct gsc_frame *s_frame,
+			      u32 *wratio, u32 tx, u32 ty, u32 *hratio)
+{
+	int remainder = 0, walign, halign;
+
+	if (is_yuv420(s_frame->fmt->color)) {
+		walign = GSC_SC_ALIGN_4;
+		halign = GSC_SC_ALIGN_4;
+	} else if (is_yuv422(s_frame->fmt->color)) {
+		walign = GSC_SC_ALIGN_4;
+		halign = GSC_SC_ALIGN_2;
+	} else {
+		walign = GSC_SC_ALIGN_2;
+		halign = GSC_SC_ALIGN_2;
+	}
+
+	remainder = s_frame->crop.width % (*wratio * walign);
+	if (remainder) {
+		s_frame->crop.width -= remainder;
+		gsc_cal_prescaler_ratio(var, s_frame->crop.width, tx, wratio);
+		gsc_info("cropped src width size is recalculated from %d to %d",
+			s_frame->crop.width + remainder, s_frame->crop.width);
+	}
+
+	remainder = s_frame->crop.height % (*hratio * halign);
+	if (remainder) {
+		s_frame->crop.height -= remainder;
+		gsc_cal_prescaler_ratio(var, s_frame->crop.height, ty, hratio);
+		gsc_info("cropped src height size is recalculated from %d to %d",
+			s_frame->crop.height + remainder, s_frame->crop.height);
+	}
+}
+
+int gsc_enum_fmt_mplane(struct v4l2_fmtdesc *f)
+{
+	struct gsc_fmt *fmt;
+
+	fmt = find_fmt(NULL, NULL, f->index);
+	if (!fmt)
+		return -EINVAL;
+
+	strncpy(f->description, fmt->name, sizeof(f->description) - 1);
+	f->pixelformat = fmt->pixelformat;
+
+	return 0;
+}
+
+u32 get_plane_size(struct gsc_frame *frame, unsigned int plane)
+{
+	if (!frame || plane >= frame->fmt->num_planes) {
+		gsc_err("Invalid argument");
+		return 0;
+	}
+
+	return frame->payload[plane];
+}
+
+u32 get_plane_info(struct gsc_frame frm, u32 addr, u32 *index)
+{
+	if (frm.addr.y == addr) {
+		*index = 0;
+		return frm.addr.y;
+	} else if (frm.addr.cb == addr) {
+		*index = 1;
+		return frm.addr.cb;
+	} else if (frm.addr.cr == addr) {
+		*index = 2;
+		return frm.addr.cr;
+	} else {
+		gsc_err("Plane address is wrong");
+		return -EINVAL;
+	}
+}
+
+void gsc_set_prefbuf(struct gsc_dev *gsc, struct gsc_frame frm)
+{
+	u32 f_chk_addr, f_chk_len, s_chk_addr, s_chk_len;
+	f_chk_addr = f_chk_len = s_chk_addr = s_chk_len = 0;
+
+	f_chk_addr = frm.addr.y;
+	f_chk_len = frm.payload[0];
+	if (frm.fmt->num_planes == 2) {
+		s_chk_addr = frm.addr.cb;
+		s_chk_len = frm.payload[1];
+	} else if (frm.fmt->num_planes == 3) {
+		u32 low_addr, low_plane, mid_addr, mid_plane, high_addr, high_plane;
+		u32 t_min, t_max;
+
+		t_min = min3(frm.addr.y, frm.addr.cb, frm.addr.cr);
+		low_addr = get_plane_info(frm, t_min, &low_plane);
+		t_max = max3(frm.addr.y, frm.addr.cb, frm.addr.cr);
+		high_addr = get_plane_info(frm, t_max, &high_plane);
+
+		mid_plane = 3 - (low_plane + high_plane);
+		if (mid_plane == 0)
+			mid_addr = frm.addr.y;
+		else if (mid_plane == 1)
+			mid_addr = frm.addr.cb;
+		else if (mid_plane == 2)
+			mid_addr = frm.addr.cr;
+		else
+			return;
+
+		f_chk_addr = low_addr;
+		if (mid_addr + frm.payload[mid_plane] - low_addr >
+		    high_addr + frm.payload[high_plane] - mid_addr) {
+			f_chk_len = frm.payload[low_plane];
+			s_chk_addr = mid_addr;
+			s_chk_len = high_addr + frm.payload[high_plane] - mid_addr;
+		} else {
+			f_chk_len = mid_addr + frm.payload[mid_plane] - low_addr;
+			s_chk_addr = high_addr;
+			s_chk_len = frm.payload[high_plane];
+		}
+	}
+	gsc_dbg("f_addr = 0x%08x, f_len = %d, s_addr = 0x%08x, s_len = %d\n",
+		f_chk_addr, f_chk_len, s_chk_addr, s_chk_len);
+}
+
+int gsc_try_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f)
+{
+	struct gsc_dev *gsc = ctx->gsc_dev;
+	struct gsc_variant *variant = gsc->variant;
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	struct gsc_fmt *fmt;
+	u32 max_w, max_h, mod_x, mod_y;
+	u32 min_w, min_h, tmp_w, tmp_h;
+	int i;
+
+	gsc_dbg("user put w: %d, h: %d", pix_mp->width, pix_mp->height);
+
+	fmt = find_fmt(&pix_mp->pixelformat, NULL, 0);
+	if (!fmt) {
+		gsc_err("pixelformat format (0x%X) invalid\n", pix_mp->pixelformat);
+		return -EINVAL;
+	}
+
+	if (pix_mp->field == V4L2_FIELD_ANY)
+		pix_mp->field = V4L2_FIELD_NONE;
+	else if (pix_mp->field != V4L2_FIELD_NONE) {
+		gsc_err("Not supported field order(%d)\n", pix_mp->field);
+		return -EINVAL;
+	}
+
+	max_w = variant->pix_max->target_rot_dis_w;
+	max_h = variant->pix_max->target_rot_dis_h;
+	if (V4L2_TYPE_IS_OUTPUT(f->type)) {
+		mod_x = ffs(variant->pix_align->org_w) - 1;
+		if (is_yuv420(fmt->color))
+			mod_y = ffs(variant->pix_align->org_h) - 1;
+		else
+			mod_y = ffs(variant->pix_align->org_h) - 2;
+		min_w = variant->pix_min->org_w;
+		min_h = variant->pix_min->org_h;
+	} else {
+		mod_x = ffs(variant->pix_align->org_w) - 1;
+		if (is_yuv420(fmt->color))
+			mod_y = ffs(variant->pix_align->org_h) - 1;
+		else
+			mod_y = ffs(variant->pix_align->org_h) - 2;
+		min_w = variant->pix_min->target_rot_dis_w;
+		min_h = variant->pix_min->target_rot_dis_h;
+	}
+	gsc_dbg("mod_x: %d, mod_y: %d, max_w: %d, max_h = %d",
+	     mod_x, mod_y, max_w, max_h);
+	/* To check if image size is modified to adjust parameter against
+	   hardware abilities */
+	tmp_w = pix_mp->width;
+	tmp_h = pix_mp->height;
+
+	v4l_bound_align_image(&pix_mp->width, min_w, max_w, mod_x,
+		&pix_mp->height, min_h, max_h, mod_y, 0);
+	if (tmp_w != pix_mp->width || tmp_h != pix_mp->height)
+		gsc_info("Image size has been modified from %dx%d to %dx%d",
+			 tmp_w, tmp_h, pix_mp->width, pix_mp->height);
+
+	pix_mp->num_planes = fmt->num_planes;
+
+	if (ctx->gsc_ctrls.csc_eq_mode->val)
+		ctx->gsc_ctrls.csc_eq->val =
+			(pix_mp->width >= 1280) ? 1 : 0;
+	if (ctx->gsc_ctrls.csc_eq->val) /* HD */
+		pix_mp->colorspace = V4L2_COLORSPACE_REC709;
+	else	/* SD */
+		pix_mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
+
+
+	for (i = 0; i < pix_mp->num_planes; ++i) {
+		int bpl = (pix_mp->width * fmt->depth[i]) >> 3;
+		pix_mp->plane_fmt[i].bytesperline = bpl;
+		pix_mp->plane_fmt[i].sizeimage = bpl * pix_mp->height;
+
+		gsc_dbg("[%d]: bpl: %d, sizeimage: %d",
+		    i, bpl, pix_mp->plane_fmt[i].sizeimage);
+	}
+
+	return 0;
+}
+
+int gsc_g_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f)
+{
+	struct gsc_frame *frame;
+	struct v4l2_pix_format_mplane *pix_mp;
+	int i;
+
+	frame = ctx_get_frame(ctx, f->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	pix_mp = &f->fmt.pix_mp;
+
+	pix_mp->width		= frame->f_width;
+	pix_mp->height		= frame->f_height;
+	pix_mp->field		= V4L2_FIELD_NONE;
+	pix_mp->pixelformat	= frame->fmt->pixelformat;
+	pix_mp->colorspace	= V4L2_COLORSPACE_JPEG;
+	pix_mp->num_planes	= frame->fmt->num_planes;
+
+	for (i = 0; i < pix_mp->num_planes; ++i) {
+		pix_mp->plane_fmt[i].bytesperline = (frame->f_width *
+			frame->fmt->depth[i]) / 8;
+		pix_mp->plane_fmt[i].sizeimage = pix_mp->plane_fmt[i].bytesperline *
+			frame->f_height;
+	}
+
+	return 0;
+}
+
+void gsc_check_crop_change(u32 tmp_w, u32 tmp_h, u32 *w, u32 *h)
+{
+	if (tmp_w != *w || tmp_h != *h) {
+		gsc_info("Image cropped size has been modified from %dx%d to %dx%d",
+				*w, *h, tmp_w, tmp_h);
+		*w = tmp_w;
+		*h = tmp_h;
+	}
+}
+
+int gsc_g_crop(struct gsc_ctx *ctx, struct v4l2_crop *cr)
+{
+	struct gsc_frame *frame;
+
+	frame = ctx_get_frame(ctx, cr->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	memcpy(&cr->c, &frame->crop, sizeof(struct v4l2_rect));
+
+	return 0;
+}
+
+int gsc_try_crop(struct gsc_ctx *ctx, struct v4l2_crop *cr)
+{
+	struct gsc_frame *f;
+	struct gsc_dev *gsc = ctx->gsc_dev;
+	struct gsc_variant *variant = gsc->variant;
+	u32 mod_x = 0, mod_y = 0, tmp_w, tmp_h;
+	u32 min_w, min_h, max_w, max_h;
+
+	if (cr->c.top < 0 || cr->c.left < 0) {
+		gsc_err("doesn't support negative values for top & left\n");
+		return -EINVAL;
+	}
+	gsc_dbg("user put w: %d, h: %d", cr->c.width, cr->c.height);
+
+	if (cr->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		f = &ctx->d_frame;
+	else if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		f = &ctx->s_frame;
+	else
+		return -EINVAL;
+
+	max_w = f->f_width;
+	max_h = f->f_height;
+	tmp_w = cr->c.width;
+	tmp_h = cr->c.height;
+
+	if (V4L2_TYPE_IS_OUTPUT(cr->type)) {
+		if ((is_yuv422(f->fmt->color) && f->fmt->nr_comp == 1) ||
+		    is_rgb(f->fmt->color))
+			min_w = 32;
+		else
+			min_w = 64;
+		if ((is_yuv422(f->fmt->color) && f->fmt->nr_comp == 3) ||
+		    is_yuv420(f->fmt->color))
+			min_h = 32;
+		else
+			min_h = 16;
+	} else {
+		if (is_yuv420(f->fmt->color) || is_yuv422(f->fmt->color))
+			mod_x = ffs(variant->pix_align->target_w) - 1;
+		if (is_yuv420(f->fmt->color))
+			mod_y = ffs(variant->pix_align->target_h) - 1;
+		if (ctx->gsc_ctrls.rotate->val == 90 ||
+		    ctx->gsc_ctrls.rotate->val == 270) {
+			max_w = f->f_height;
+			max_h = f->f_width;
+			min_w = variant->pix_min->target_rot_en_w;
+			min_h = variant->pix_min->target_rot_en_h;
+			tmp_w = cr->c.height;
+			tmp_h = cr->c.width;
+		} else {
+			min_w = variant->pix_min->target_rot_dis_w;
+			min_h = variant->pix_min->target_rot_dis_h;
+		}
+	}
+	gsc_dbg("mod_x: %d, mod_y: %d, min_w: %d, min_h = %d,\
+		tmp_w : %d, tmp_h : %d",
+		mod_x, mod_y, min_w, min_h, tmp_w, tmp_h);
+
+	v4l_bound_align_image(&tmp_w, min_w, max_w, mod_x,
+			      &tmp_h, min_h, max_h, mod_y, 0);
+
+	if (!V4L2_TYPE_IS_OUTPUT(cr->type) &&
+	    (ctx->gsc_ctrls.rotate->val == 90 ||
+	    ctx->gsc_ctrls.rotate->val == 270)) {
+		gsc_check_crop_change(tmp_h, tmp_w, &cr->c.width, &cr->c.height);
+	} else {
+		gsc_check_crop_change(tmp_w, tmp_h, &cr->c.width, &cr->c.height);
+	}
+
+	/* adjust left/top if cropping rectangle is out of bounds */
+	/* Need to add code to algin left value with 2's multiple */
+	if (cr->c.left + tmp_w > max_w)
+		cr->c.left = max_w - tmp_w;
+	if (cr->c.top + tmp_h > max_h)
+		cr->c.top = max_h - tmp_h;
+
+	if (is_yuv420(f->fmt->color) || is_yuv422(f->fmt->color))
+		if (cr->c.left % 2)
+			cr->c.left -= 1;
+
+	gsc_dbg("Aligned l:%d, t:%d, w:%d, h:%d, f_w: %d, f_h: %d",
+	    cr->c.left, cr->c.top, cr->c.width, cr->c.height, max_w, max_h);
+
+	return 0;
+}
+
+int gsc_check_scaler_ratio(struct gsc_variant *var, int sw, int sh, int dw,
+			   int dh, int rot, int out_path)
+{
+	int tmp_w, tmp_h, sc_down_max;
+	sc_down_max =
+		(out_path == GSC_DMA) ? var->sc_down_max : var->local_sc_down;
+
+	if (rot == 90 || rot == 270) {
+		tmp_w = dh;
+		tmp_h = dw;
+	} else {
+		tmp_w = dw;
+		tmp_h = dh;
+	}
+
+	if ((sw / tmp_w) > sc_down_max ||
+	    (sh / tmp_h) > sc_down_max ||
+	    (tmp_w / sw) > var->sc_up_max ||
+	    (tmp_h / sh) > var->sc_up_max)
+		return -EINVAL;
+
+	return 0;
+}
+
+int gsc_set_scaler_info(struct gsc_ctx *ctx)
+{
+	struct gsc_scaler *sc = &ctx->scaler;
+	struct gsc_frame *s_frame = &ctx->s_frame;
+	struct gsc_frame *d_frame = &ctx->d_frame;
+	struct gsc_variant *variant = ctx->gsc_dev->variant;
+	int tx, ty;
+	int ret;
+
+	ret = gsc_check_scaler_ratio(variant, s_frame->crop.width,
+		s_frame->crop.height, d_frame->crop.width, d_frame->crop.height,
+		ctx->gsc_ctrls.rotate->val, ctx->out_path);
+	if (ret) {
+		gsc_err("out of scaler range");
+		return ret;
+	}
+
+	if (ctx->gsc_ctrls.rotate->val == 90 ||
+	    ctx->gsc_ctrls.rotate->val == 270) {
+		ty = d_frame->crop.width;
+		tx = d_frame->crop.height;
+	} else {
+		tx = d_frame->crop.width;
+		ty = d_frame->crop.height;
+	}
+
+	ret = gsc_cal_prescaler_ratio(variant, s_frame->crop.width,
+				      tx, &sc->pre_hratio);
+	if (ret) {
+		gsc_err("Horizontal scale ratio is out of range");
+		return ret;
+	}
+
+	ret = gsc_cal_prescaler_ratio(variant, s_frame->crop.height,
+				      ty, &sc->pre_vratio);
+	if (ret) {
+		gsc_err("Vertical scale ratio is out of range");
+		return ret;
+	}
+
+	gsc_check_src_scale_info(variant, s_frame, &sc->pre_hratio,
+				 tx, ty, &sc->pre_vratio);
+
+	gsc_get_prescaler_shfactor(sc->pre_hratio, sc->pre_vratio,
+				   &sc->pre_shfactor);
+
+	sc->main_hratio = (s_frame->crop.width << 16) / tx;
+	sc->main_vratio = (s_frame->crop.height << 16) / ty;
+
+	gsc_dbg("scaler input/output size : sx = %d, sy = %d, tx = %d, ty = %d",
+		s_frame->crop.width, s_frame->crop.height, tx, ty);
+	gsc_dbg("scaler ratio info : pre_shfactor : %d, pre_h : %d, pre_v :%d,\
+		main_h : %ld, main_v : %ld", sc->pre_shfactor, sc->pre_hratio,
+		sc->pre_vratio, sc->main_hratio, sc->main_vratio);
+
+	return 0;
+}
+
+int gsc_pipeline_s_stream(struct gsc_dev *gsc, bool on)
+{
+	struct gsc_pipeline *p = &gsc->pipeline;
+	struct exynos_entity_data md_data;
+	int ret = 0;
+
+	/* If gscaler subdev calls the mixer's s_stream, the gscaler must
+	   inform the mixer subdev pipeline started from gscaler */
+	if (!strncmp(p->disp->name, MXR_SUBDEV_NAME,
+				sizeof(MXR_SUBDEV_NAME) - 1)) {
+		md_data.mxr_data_from = FROM_GSC_SD;
+		v4l2_set_subdevdata(p->disp, &md_data);
+	}
+
+	ret = v4l2_subdev_call(p->disp, video, s_stream, on);
+	if (ret)
+		gsc_err("Display s_stream on failed\n");
+
+	return ret;
+}
+
+int gsc_out_link_validate(const struct media_pad *source,
+			  const struct media_pad *sink)
+{
+	struct v4l2_subdev_format src_fmt;
+	struct v4l2_subdev_crop dst_crop;
+	struct v4l2_subdev *sd;
+	struct gsc_dev *gsc;
+	struct gsc_frame *f;
+	int ret;
+
+	if (media_entity_type(source->entity) != MEDIA_ENT_T_V4L2_SUBDEV ||
+	    media_entity_type(sink->entity) != MEDIA_ENT_T_V4L2_SUBDEV) {
+		gsc_err("media entity type isn't subdev\n");
+		return 0;
+	}
+
+	sd = media_entity_to_v4l2_subdev(source->entity);
+	gsc = entity_data_to_gsc(v4l2_get_subdevdata(sd));
+	f = &gsc->out.ctx->d_frame;
+
+	src_fmt.format.width = f->crop.width;
+	src_fmt.format.height = f->crop.height;
+	src_fmt.format.code = f->fmt->mbus_code;
+
+	sd = media_entity_to_v4l2_subdev(sink->entity);
+	/* To check if G-Scaler destination size and Mixer destinatin size
+	   are the same */
+	dst_crop.pad = sink->index;
+	dst_crop.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	ret = v4l2_subdev_call(sd, pad, get_crop, NULL, &dst_crop);
+	if (ret < 0 && ret != -ENOIOCTLCMD) {
+		gsc_err("subdev get_fmt is failed\n");
+		return -EPIPE;
+	}
+
+	if (src_fmt.format.width != dst_crop.rect.width ||
+	    src_fmt.format.height != dst_crop.rect.height) {
+		gsc_err("sink and source format is different\
+			src_fmt.w = %d, src_fmt.h = %d,\
+			dst_crop.w = %d, dst_crop.h = %d, rotation = %d",
+			src_fmt.format.width, src_fmt.format.height,
+			dst_crop.rect.width, dst_crop.rect.height,
+			gsc->out.ctx->gsc_ctrls.rotate->val);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * V4L2 controls handling
+ */
+static int gsc_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct gsc_ctx *ctx = ctrl_to_ctx(ctrl);
+
+	switch (ctrl->id) {
+	case V4L2_CID_HFLIP:
+		user_to_drv(ctx->gsc_ctrls.hflip, ctrl->val);
+		break;
+
+	case V4L2_CID_VFLIP:
+		user_to_drv(ctx->gsc_ctrls.vflip, ctrl->val);
+		break;
+
+	case V4L2_CID_ROTATE:
+		user_to_drv(ctx->gsc_ctrls.rotate, ctrl->val);
+		break;
+
+	default:
+		break;
+	}
+
+	if (gsc_m2m_opened(ctx->gsc_dev))
+		gsc_ctx_state_lock_set(GSC_PARAMS, ctx);
+
+	return 0;
+}
+
+const struct v4l2_ctrl_ops gsc_ctrl_ops = {
+	.s_ctrl = gsc_s_ctrl,
+};
+
+int gsc_ctrls_create(struct gsc_ctx *ctx)
+{
+	if (ctx->ctrls_rdy) {
+		gsc_err("Control handler of this context was created already");
+		return 0;
+	}
+
+	v4l2_ctrl_handler_init(&ctx->ctrl_handler, GSC_MAX_CTRL_NUM);
+
+	ctx->gsc_ctrls.rotate = v4l2_ctrl_new_std(&ctx->ctrl_handler,
+				&gsc_ctrl_ops, V4L2_CID_ROTATE, 0, 270, 90, 0);
+	ctx->gsc_ctrls.hflip = v4l2_ctrl_new_std(&ctx->ctrl_handler,
+				&gsc_ctrl_ops, V4L2_CID_HFLIP, 0, 1, 1, 0);
+	ctx->gsc_ctrls.vflip = v4l2_ctrl_new_std(&ctx->ctrl_handler,
+				&gsc_ctrl_ops, V4L2_CID_VFLIP, 0, 1, 1, 0);
+
+	if (ctx->ctrl_handler.error) {
+		int err = ctx->ctrl_handler.error;
+		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+		gsc_err("Failed to gscaler control hander create");
+		return err;
+	}
+
+	return 0;
+}
+
+void gsc_ctrls_delete(struct gsc_ctx *ctx)
+{
+	if (ctx->ctrls_rdy) {
+		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+		ctx->ctrls_rdy = false;
+	}
+}
+
+/* The color format (nr_comp, num_planes) must be already configured. */
+int gsc_prepare_addr(struct gsc_ctx *ctx, struct vb2_buffer *vb,
+		     struct gsc_frame *frame, struct gsc_addr *addr)
+{
+	int ret = 0;
+	u32 pix_size;
+
+	if (IS_ERR(vb) || IS_ERR(frame)) {
+		gsc_err("Invalid argument");
+		return -EINVAL;
+	}
+
+	pix_size = frame->f_width * frame->f_height;
+
+	gsc_dbg("num_planes= %d, nr_comp= %d, pix_size= %d",
+		frame->fmt->num_planes, frame->fmt->nr_comp, pix_size);
+
+	addr->y = vb2_dma_contig_plane_dma_addr(vb, 0);
+
+	if (frame->fmt->num_planes == 1) {
+		switch (frame->fmt->nr_comp) {
+		case 1:
+			addr->cb = 0;
+			addr->cr = 0;
+			break;
+		case 2:
+			/* decompose Y into Y/Cb */
+			addr->cb = (dma_addr_t)(addr->y + pix_size);
+			addr->cr = 0;
+			break;
+		case 3:
+			addr->cb = (dma_addr_t)(addr->y + pix_size);
+			addr->cr = (dma_addr_t)(addr->cb + (pix_size >> 2));
+			break;
+		default:
+			gsc_err("Invalid the number of color planes");
+			return -EINVAL;
+		}
+	} else {
+		if (frame->fmt->num_planes >= 2)
+			addr->cb = vb2_dma_contig_plane_dma_addr(vb, 1);
+
+		if (frame->fmt->num_planes == 3)
+			addr->cr = vb2_dma_contig_plane_dma_addr(vb, 2);
+	}
+
+	if (frame->fmt->pixelformat == V4L2_PIX_FMT_YVU420) {
+		u32 t_cb = addr->cb;
+		addr->cb = addr->cr;
+		addr->cr = t_cb;
+	}
+
+	gsc_dbg("ADDR: y= 0x%X  cb= 0x%X cr= 0x%X ret= %d",
+		addr->y, addr->cb, addr->cr, ret);
+
+	return ret;
+}
+
+void gsc_wq_suspend(struct work_struct *work)
+{
+	struct gsc_dev *gsc = container_of(work, struct gsc_dev,
+					     work_struct);
+	pm_runtime_put_sync(&gsc->pdev->dev);
+}
+
+void gsc_cap_irq_handler(struct gsc_dev *gsc)
+{
+	int done_index;
+
+	done_index = gsc_hw_get_done_output_buf_index(gsc);
+	gsc_info("done_index : %d", done_index);
+	if (done_index < 0)
+		gsc_err("All buffers are masked\n");
+	test_bit(ST_CAPT_RUN, &gsc->state) ? :
+		set_bit(ST_CAPT_RUN, &gsc->state);
+	vb2_buffer_done(gsc->cap.vbq.bufs[done_index], VB2_BUF_STATE_DONE);
+}
+
+static irqreturn_t gsc_irq_handler(int irq, void *priv)
+{
+	struct gsc_dev *gsc = priv;
+	int gsc_irq;
+
+	gsc_irq = gsc_hw_get_irq_status(gsc);
+	gsc_hw_clear_irq(gsc, gsc_irq);
+
+	if (gsc_irq == GSC_OR_IRQ) {
+		gsc_err("Local path input over-run interrupt has occurred!\n");
+		return IRQ_HANDLED;
+	}
+
+	spin_lock(&gsc->slock);
+
+	if (test_and_clear_bit(ST_M2M_RUN, &gsc->state)) {
+		struct vb2_buffer *src_vb, *dst_vb;
+		struct gsc_ctx *ctx =
+			v4l2_m2m_get_curr_priv(gsc->m2m.m2m_dev);
+
+		if (!ctx || !ctx->m2m_ctx)
+			goto isr_unlock;
+
+		src_vb = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+		dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
+		if (src_vb && dst_vb) {
+			v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
+			v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
+
+			if (test_and_clear_bit(ST_STOP_REQ, &gsc->state))
+				wake_up(&gsc->irq_queue);
+			else
+				v4l2_m2m_job_finish(gsc->m2m.m2m_dev, ctx->m2m_ctx);
+
+			/* wake_up job_abort, stop_streaming */
+			spin_lock(&ctx->slock);
+			if (ctx->state & GSC_CTX_STOP_REQ) {
+				ctx->state &= ~GSC_CTX_STOP_REQ;
+				wake_up(&gsc->irq_queue);
+			}
+			spin_unlock(&ctx->slock);
+		}
+		/* schedule pm_runtime_put_sync */
+		queue_work(gsc->irq_workqueue, &gsc->work_struct);
+	} else if (test_bit(ST_OUTPUT_STREAMON, &gsc->state)) {
+		if (!list_empty(&gsc->out.active_buf_q)) {
+			struct gsc_input_buf *done_buf;
+			done_buf = active_queue_pop(&gsc->out, gsc);
+			gsc_hw_set_input_buf_masking(gsc, done_buf->idx, true);
+			if (!list_is_last(&done_buf->list, &gsc->out.active_buf_q)) {
+				vb2_buffer_done(&done_buf->vb, VB2_BUF_STATE_DONE);
+				list_del(&done_buf->list);
+			}
+		}
+	} else if (test_bit(ST_CAPT_PEND, &gsc->state)) {
+		gsc_cap_irq_handler(gsc);
+	}
+
+isr_unlock:
+	spin_unlock(&gsc->slock);
+	return IRQ_HANDLED;
+}
+
+static int gsc_get_media_info(struct device *dev, void *p)
+{
+	struct exynos_md **mdev = p;
+	struct platform_device *pdev = to_platform_device(dev);
+
+	mdev[pdev->id] = dev_get_drvdata(dev);
+	if (!mdev[pdev->id])
+		return -ENODEV;
+
+	return 0;
+}
+
+static int gsc_runtime_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct gsc_dev *gsc = (struct gsc_dev *)platform_get_drvdata(pdev);
+
+	if (gsc_m2m_opened(gsc))
+		gsc->m2m.ctx = NULL;
+
+	clk_disable(gsc->clock);
+	clear_bit(ST_PWR_ON, &gsc->state);
+
+	return 0;
+}
+
+static int gsc_runtime_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct gsc_dev *gsc = (struct gsc_dev *)platform_get_drvdata(pdev);
+
+	clk_enable(gsc->clock);
+	set_bit(ST_PWR_ON, &gsc->state);
+	return 0;
+}
+
+static int gsc_probe(struct platform_device *pdev)
+{
+	struct gsc_dev *gsc;
+	struct resource *res;
+	struct gsc_driverdata *drv_data;
+	struct device_driver *driver;
+	struct exynos_md *mdev[MDEV_MAX_NUM] = {NULL,};
+	int ret = 0;
+	char workqueue_name[WORKQUEUE_NAME_SIZE];
+
+	dev_dbg(&pdev->dev, "%s():\n", __func__);
+	drv_data = (struct gsc_driverdata *)
+		platform_get_device_id(pdev)->driver_data;
+
+	if (pdev->id >= drv_data->num_entities) {
+		dev_err(&pdev->dev, "Invalid platform device id: %d\n",
+			pdev->id);
+		return -EINVAL;
+	}
+
+	gsc = kzalloc(sizeof(struct gsc_dev), GFP_KERNEL);
+	if (!gsc)
+		return -ENOMEM;
+
+	gsc->id = pdev->id;
+	gsc->variant = drv_data->variant[gsc->id];
+	gsc->pdev = pdev;
+	gsc->pdata = pdev->dev.platform_data;
+
+	init_waitqueue_head(&gsc->irq_queue);
+	spin_lock_init(&gsc->slock);
+	mutex_init(&gsc->lock);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "failed to find the registers\n");
+		ret = -ENOENT;
+		goto err_info;
+	}
+
+	gsc->regs_res = request_mem_region(res->start, resource_size(res),
+			dev_name(&pdev->dev));
+	if (!gsc->regs_res) {
+		dev_err(&pdev->dev, "failed to obtain register region\n");
+		ret = -ENOENT;
+		goto err_info;
+	}
+
+	gsc->regs = ioremap(res->start, resource_size(res));
+	if (!gsc->regs) {
+		dev_err(&pdev->dev, "failed to map registers\n");
+		ret = -ENXIO;
+		goto err_req_region;
+	}
+
+	/* Get Gscaler clock */
+	gsc->clock = clk_get(&gsc->pdev->dev, GSC_CLOCK_GATE_NAME);
+	if (IS_ERR(gsc->clock)) {
+		gsc_err("failed to get gscaler.%d clock", gsc->id);
+		goto err_regs_unmap;
+	}
+	clk_put(gsc->clock);
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "failed to get IRQ resource\n");
+		ret = -ENXIO;
+		goto err_regs_unmap;
+	}
+	gsc->irq = res->start;
+
+	ret = request_irq(gsc->irq, gsc_irq_handler, 0, pdev->name, gsc);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to install irq (%d)\n", ret);
+		goto err_regs_unmap;
+	}
+
+	platform_set_drvdata(pdev, gsc);
+
+	ret = gsc_register_m2m_device(gsc);
+	if (ret)
+		goto err_irq;
+
+	/* find media device */
+	driver = driver_find(MDEV_MODULE_NAME, &platform_bus_type);
+	if (!driver)
+		goto err_irq;
+
+	ret = driver_for_each_device(driver, NULL, &mdev[0],
+			gsc_get_media_info);
+	put_driver(driver);
+	if (ret)
+		goto err_irq;
+
+	gsc->mdev[MDEV_OUTPUT] = mdev[MDEV_OUTPUT];
+	gsc->mdev[MDEV_CAPTURE] = mdev[MDEV_CAPTURE];
+
+	gsc_dbg("mdev->mdev[%d] = 0x%08x, mdev->mdev[%d] = 0x%08x",
+		 MDEV_OUTPUT, (u32)gsc->mdev[MDEV_OUTPUT], MDEV_CAPTURE,
+		 (u32)gsc->mdev[MDEV_CAPTURE]);
+
+	ret = gsc_register_output_device(gsc);
+	if (ret)
+		goto err_irq;
+
+	if (gsc->pdata)	{
+		ret = gsc_register_capture_device(gsc);
+		if (ret)
+			goto err_irq;
+	}
+
+	sprintf(workqueue_name, "gsc%d_irq_wq_name", gsc->id);
+	gsc->irq_workqueue = create_singlethread_workqueue(workqueue_name);
+	if (gsc->irq_workqueue == NULL) {
+		dev_err(&pdev->dev, "failed to create workqueue for gsc\n");
+		goto err_irq;
+	}
+	INIT_WORK(&gsc->work_struct, gsc_wq_suspend);
+
+	gsc->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
+	if (IS_ERR(gsc->alloc_ctx)) {
+		ret = PTR_ERR(gsc->alloc_ctx);
+		goto err_wq;
+	}
+	pm_runtime_enable(&pdev->dev);
+
+	gsc_info("gsc-%d registered successfully", gsc->id);
+
+	return 0;
+
+err_wq:
+	destroy_workqueue(gsc->irq_workqueue);
+err_irq:
+	free_irq(gsc->irq, gsc);
+err_regs_unmap:
+	iounmap(gsc->regs);
+err_req_region:
+	release_resource(gsc->regs_res);
+	kfree(gsc->regs_res);
+err_info:
+	kfree(gsc);
+
+	return ret;
+}
+
+static int __devexit gsc_remove(struct platform_device *pdev)
+{
+	struct gsc_dev *gsc =
+		(struct gsc_dev *)platform_get_drvdata(pdev);
+
+	free_irq(gsc->irq, gsc);
+
+	gsc_unregister_m2m_device(gsc);
+	gsc_unregister_output_device(gsc);
+	gsc_unregister_capture_device(gsc);
+
+	vb2_dma_contig_cleanup_ctx(gsc->alloc_ctx);
+	pm_runtime_disable(&pdev->dev);
+
+	iounmap(gsc->regs);
+	release_resource(gsc->regs_res);
+	kfree(gsc->regs_res);
+	kfree(gsc);
+
+	dev_info(&pdev->dev, "%s driver unloaded\n", pdev->name);
+	return 0;
+}
+
+static int gsc_suspend(struct device *dev)
+{
+	struct platform_device *pdev;
+	struct gsc_dev *gsc;
+	int ret = 0;
+
+	pdev = to_platform_device(dev);
+	gsc = (struct gsc_dev *)platform_get_drvdata(pdev);
+
+	if (gsc_m2m_run(gsc)) {
+		set_bit(ST_STOP_REQ, &gsc->state);
+		ret = wait_event_timeout(gsc->irq_queue,
+				!test_bit(ST_STOP_REQ, &gsc->state),
+				GSC_SHUTDOWN_TIMEOUT);
+		if (ret == 0)
+			dev_err(&gsc->pdev->dev, "wait timeout : %s\n",
+				__func__);
+	}
+	if (gsc_cap_active(gsc)) {
+		gsc_err("capture device is running!!");
+		return -EINVAL;
+	}
+
+	pm_runtime_put_sync(dev);
+
+	return ret;
+}
+
+static int gsc_resume(struct device *dev)
+{
+	struct platform_device *pdev;
+	struct gsc_driverdata *drv_data;
+	struct gsc_dev *gsc;
+	struct gsc_ctx *ctx;
+
+	pdev = to_platform_device(dev);
+	gsc = (struct gsc_dev *)platform_get_drvdata(pdev);
+	drv_data = (struct gsc_driverdata *)
+		platform_get_device_id(pdev)->driver_data;
+
+	pm_runtime_get_sync(dev);
+	if (gsc_m2m_opened(gsc)) {
+		ctx = v4l2_m2m_get_curr_priv(gsc->m2m.m2m_dev);
+		if (ctx != NULL) {
+			gsc->m2m.ctx = NULL;
+			v4l2_m2m_job_finish(gsc->m2m.m2m_dev, ctx->m2m_ctx);
+		}
+	}
+
+	return 0;
+}
+
+static const struct dev_pm_ops gsc_pm_ops = {
+	.suspend		= gsc_suspend,
+	.resume			= gsc_resume,
+	.runtime_suspend	= gsc_runtime_suspend,
+	.runtime_resume		= gsc_runtime_resume,
+};
+
+struct gsc_pix_max gsc_v_100_max = {
+	.org_scaler_bypass_w	= 8192,
+	.org_scaler_bypass_h	= 8192,
+	.org_scaler_input_w	= 4800,
+	.org_scaler_input_h	= 3344,
+	.real_rot_dis_w		= 4800,
+	.real_rot_dis_h		= 3344,
+	.real_rot_en_w		= 2047,
+	.real_rot_en_h		= 2047,
+	.target_rot_dis_w	= 4800,
+	.target_rot_dis_h	= 3344,
+	.target_rot_en_w	= 2016,
+	.target_rot_en_h	= 2016,
+};
+
+struct gsc_pix_min gsc_v_100_min = {
+	.org_w			= 64,
+	.org_h			= 32,
+	.real_w			= 64,
+	.real_h			= 32,
+	.target_rot_dis_w	= 64,
+	.target_rot_dis_h	= 32,
+	.target_rot_en_w	= 32,
+	.target_rot_en_h	= 16,
+};
+
+struct gsc_pix_align gsc_v_100_align = {
+	.org_h			= 16,
+	.org_w			= 16, /* yuv420 : 16, others : 8 */
+	.offset_h		= 2,  /* yuv420/422 : 2, others : 1 */
+	.real_w			= 16, /* yuv420/422 : 4~16, others : 2~8 */
+	.real_h			= 16, /* yuv420 : 4~16, others : 1 */
+	.target_w		= 2,  /* yuv420/422 : 2, others : 1 */
+	.target_h		= 2,  /* yuv420 : 2, others : 1 */
+};
+
+struct gsc_variant gsc_v_100_variant = {
+	.pix_max		= &gsc_v_100_max,
+	.pix_min		= &gsc_v_100_min,
+	.pix_align		= &gsc_v_100_align,
+	.in_buf_cnt		= 8,
+	.out_buf_cnt		= 16,
+	.sc_up_max		= 8,
+	.sc_down_max		= 16,
+	.poly_sc_down_max	= 4,
+	.pre_sc_down_max	= 4,
+	.local_sc_down		= 2,
+};
+
+static struct gsc_driverdata gsc_v_100_drvdata = {
+	.variant = {
+		[0] = &gsc_v_100_variant,
+		[1] = &gsc_v_100_variant,
+		[2] = &gsc_v_100_variant,
+		[3] = &gsc_v_100_variant,
+	},
+	.num_entities = 4,
+	.lclk_frequency = 266000000UL,
+};
+
+static struct platform_device_id gsc_driver_ids[] = {
+	{
+		.name		= "exynos-gsc",
+		.driver_data	= (unsigned long)&gsc_v_100_drvdata,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(platform, gsc_driver_ids);
+
+static struct platform_driver gsc_driver = {
+	.probe		= gsc_probe,
+	.remove	= __devexit_p(gsc_remove),
+	.id_table	= gsc_driver_ids,
+	.driver = {
+		.name	= GSC_MODULE_NAME,
+		.owner	= THIS_MODULE,
+		.pm	= &gsc_pm_ops,
+	}
+};
+
+static int __init gsc_init(void)
+{
+	int ret = platform_driver_register(&gsc_driver);
+	if (ret)
+		gsc_err("platform_driver_register failed: %d\n", ret);
+	return ret;
+}
+
+static void __exit gsc_exit(void)
+{
+	platform_driver_unregister(&gsc_driver);
+}
+
+module_init(gsc_init);
+module_exit(gsc_exit);
+
+MODULE_AUTHOR("Hyunwong Kim <khw0178.kim@samsung.com>");
+MODULE_DESCRIPTION("Samsung EXYNOS5 Soc series G-Scaler driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/exynos/gsc/gsc-core.h b/drivers/media/video/exynos/gsc/gsc-core.h
new file mode 100644
index 0000000..5c65446
--- /dev/null
+++ b/drivers/media/video/exynos/gsc/gsc-core.h
@@ -0,0 +1,752 @@
+/* linux/drivers/media/video/exynos/gsc/gsc-core.h
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * header file for Samsung EXYNOS5 SoC series G-scaler driver
+
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef GSC_CORE_H_
+#define GSC_CORE_H_
+
+#include <linux/delay.h>
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/videodev2.h>
+#include <linux/io.h>
+#include <linux/pm_runtime.h>
+#include <media/videobuf2-core.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/v4l2-mediabus.h>
+#include <media/exynos_mc.h>
+#include <media/exynos_gscaler.h>
+#include <media/videobuf2-dma-contig.h>
+#include "regs-gsc.h"
+
+extern int gsc_dbg;
+
+#define gsc_info(fmt, args...)						\
+	do {								\
+		if (gsc_dbg >= 6)						\
+			printk(KERN_INFO "[INFO]%s:%d: "fmt "\n",	\
+				__func__, __LINE__, ##args);		\
+	} while (0)
+
+#define gsc_err(fmt, args...)						\
+	do {								\
+		if (gsc_dbg >= 3)						\
+			printk(KERN_ERR "[ERROR]%s:%d: "fmt "\n",	\
+				__func__, __LINE__, ##args);		\
+	} while (0)
+
+#define gsc_warn(fmt, args...)						\
+	do {								\
+		if (gsc_dbg >= 4)						\
+			printk(KERN_WARNING "[WARN]%s:%d: "fmt "\n",	\
+				__func__, __LINE__, ##args);		\
+	} while (0)
+
+#define gsc_dbg(fmt, args...)						\
+	do {								\
+		if (gsc_dbg >= 7)						\
+			printk(KERN_DEBUG "[DEBUG]%s:%d: "fmt "\n",	\
+				__func__, __LINE__, ##args);		\
+	} while (0)
+
+#define GSC_MAX_CLOCKS			3
+#define GSC_SHUTDOWN_TIMEOUT		((100*HZ)/1000)
+#define GSC_MAX_DEVS			4
+#define WORKQUEUE_NAME_SIZE		32
+#define FIMD_NAME_SIZE			32
+#define GSC_M2M_BUF_NUM			0
+#define GSC_OUT_BUF_MAX			2
+#define GSC_MAX_CTRL_NUM		10
+#define GSC_OUT_MAX_MASK_NUM		7
+#define GSC_SC_ALIGN_4			4
+#define GSC_SC_ALIGN_2			2
+#define GSC_OUT_DEF_SRC			15
+#define GSC_OUT_DEF_DST			7
+#define DEFAULT_GSC_SINK_WIDTH		800
+#define DEFAULT_GSC_SINK_HEIGHT		480
+#define DEFAULT_GSC_SOURCE_WIDTH	800
+#define DEFAULT_GSC_SOURCE_HEIGHT	480
+#define DEFAULT_CSC_EQ			1
+#define DEFAULT_CSC_RANGE		1
+
+#define GSC_LAST_DEV_ID			3
+#define GSC_PAD_SINK			0
+#define GSC_PAD_SOURCE			1
+#define GSC_PADS_NUM			2
+
+#define	GSC_PARAMS			(1 << 0)
+#define	GSC_SRC_FMT			(1 << 1)
+#define	GSC_DST_FMT			(1 << 2)
+#define	GSC_CTX_M2M			(1 << 3)
+#define	GSC_CTX_OUTPUT			(1 << 4)
+#define	GSC_CTX_START			(1 << 5)
+#define	GSC_CTX_STOP_REQ		(1 << 6)
+#define	GSC_CTX_CAP			(1 << 10)
+#define MAX_MDEV			2
+
+enum gsc_dev_flags {
+	/* for global */
+	ST_PWR_ON,
+	ST_STOP_REQ,
+	/* for m2m node */
+	ST_M2M_OPEN,
+	ST_M2M_RUN,
+	/* for output node */
+	ST_OUTPUT_OPEN,
+	ST_OUTPUT_STREAMON,
+	/* for capture node */
+	ST_CAPT_OPEN,
+	ST_CAPT_PEND,
+	ST_CAPT_RUN,
+	ST_CAPT_STREAM,
+	ST_CAPT_PIPE_STREAM,
+	ST_CAPT_SUSPENDED,
+	ST_CAPT_SHUT,
+	ST_CAPT_APPLY_CFG,
+	ST_CAPT_JPEG,
+};
+
+enum gsc_cap_input_entity {
+	GSC_IN_NONE,
+	GSC_IN_FLITE_PREVIEW,
+	GSC_IN_FLITE_CAMCORDING,
+	GSC_IN_FIMD_WRITEBACK,
+};
+
+enum gsc_irq {
+	GSC_OR_IRQ = 17,
+	GSC_DONE_IRQ = 16,
+};
+
+/**
+ * enum gsc_datapath - the path of data used for gscaler
+ * @GSC_CAMERA: from camera
+ * @GSC_DMA: from/to DMA
+ * @GSC_LOCAL: to local path
+ * @GSC_WRITEBACK: from FIMD
+ */
+enum gsc_datapath {
+	GSC_CAMERA = 0x1,
+	GSC_DMA,
+	GSC_MIXER,
+	GSC_FIMD,
+	GSC_WRITEBACK,
+};
+
+enum gsc_color_fmt {
+	GSC_RGB = 0x1,
+	GSC_YUV420 = 0x2,
+	GSC_YUV422 = 0x4,
+	GSC_YUV444 = 0x8,
+};
+
+enum gsc_yuv_fmt {
+	GSC_LSB_Y = 0x10,
+	GSC_LSB_C,
+	GSC_CBCR = 0x20,
+	GSC_CRCB,
+};
+
+#define fh_to_ctx(__fh) container_of(__fh, struct gsc_ctx, fh)
+#define is_rgb(x) (!!((x) & 0x1))
+#define is_yuv420(x) (!!((x) & 0x2))
+#define is_yuv422(x) (!!((x) & 0x4))
+#define gsc_m2m_run(dev) test_bit(ST_M2M_RUN, &(dev)->state)
+#define gsc_m2m_opened(dev) test_bit(ST_M2M_OPEN, &(dev)->state)
+#define gsc_out_run(dev) test_bit(ST_OUTPUT_STREAMON, &(dev)->state)
+#define gsc_out_opened(dev) test_bit(ST_OUTPUT_OPEN, &(dev)->state)
+#define gsc_cap_opened(dev) test_bit(ST_CAPT_OPEN, &(dev)->state)
+#define gsc_cap_active(dev) test_bit(ST_CAPT_RUN, &(dev)->state)
+
+#define ctrl_to_ctx(__ctrl) \
+	container_of((__ctrl)->handler, struct gsc_ctx, ctrl_handler)
+#define entity_data_to_gsc(data) \
+	container_of(data, struct gsc_dev, md_data)
+#define gsc_capture_get_frame(ctx, pad)\
+	((pad == GSC_PAD_SINK) ? &ctx->s_frame : &ctx->d_frame)
+/**
+ * struct gsc_fmt - the driver's internal color format data
+ * @mbus_code: Media Bus pixel code, -1 if not applicable
+ * @name: format description
+ * @pixelformat: the fourcc code for this format, 0 if not applicable
+ * @yorder: Y/C order
+ * @corder: Chrominance order control
+ * @num_planes: number of physically non-contiguous data planes
+ * @nr_comp: number of physically contiguous data planes
+ * @depth: per plane driver's private 'number of bits per pixel'
+ * @flags: flags indicating which operation mode format applies to
+ */
+struct gsc_fmt {
+	enum v4l2_mbus_pixelcode mbus_code;
+	char	*name;
+	u32	pixelformat;
+	u32	color;
+	u32	yorder;
+	u32	corder;
+	u16	num_planes;
+	u16	nr_comp;
+	u8	depth[VIDEO_MAX_PLANES];
+	u32	flags;
+};
+
+/**
+ * struct gsc_input_buf - the driver's video buffer
+ * @vb:	videobuf2 buffer
+ * @list : linked list structure for buffer queue
+ * @idx : index of G-Scaler input buffer
+ */
+struct gsc_input_buf {
+	struct vb2_buffer	vb;
+	struct list_head	list;
+	int			idx;
+};
+
+/**
+ * struct gsc_addr - the G-Scaler physical address set
+ * @y:	 luminance plane address
+ * @cb:	 Cb plane address
+ * @cr:	 Cr plane address
+ */
+struct gsc_addr {
+	dma_addr_t	y;
+	dma_addr_t	cb;
+	dma_addr_t	cr;
+};
+
+/* struct gsc_ctrls - the G-Scaler control set
+ * @rotate: rotation degree
+ * @hflip: horizontal flip
+ * @vflip: vertical flip
+ * @global_alpha: the alpha value of current frame
+ * @layer_blend_en: enable mixer layer alpha blending
+ * @layer_alpha: set alpha value for mixer layer
+ * @pixel_blend_en: enable mixer pixel alpha blending
+ * @chroma_en: enable chromakey
+ * @chroma_val:	set value for chromakey
+ * @csc_eq_mode: mode to select csc equation of current frame
+ * @csc_eq: csc equation of current frame
+ * @csc_range: csc range of current frame
+ */
+struct gsc_ctrls {
+	struct v4l2_ctrl	*rotate;
+	struct v4l2_ctrl	*hflip;
+	struct v4l2_ctrl	*vflip;
+	struct v4l2_ctrl	*global_alpha;
+	struct v4l2_ctrl	*layer_blend_en;
+	struct v4l2_ctrl	*layer_alpha;
+	struct v4l2_ctrl	*pixel_blend_en;
+	struct v4l2_ctrl	*chroma_en;
+	struct v4l2_ctrl	*chroma_val;
+	struct v4l2_ctrl	*csc_eq_mode;
+	struct v4l2_ctrl	*csc_eq;
+	struct v4l2_ctrl	*csc_range;
+};
+
+/**
+ * struct gsc_scaler - the configuration data for G-Scaler inetrnal scaler
+ * @pre_shfactor:	pre sclaer shift factor
+ * @pre_hratio:		horizontal ratio of the prescaler
+ * @pre_vratio:		vertical ratio of the prescaler
+ * @main_hratio:	the main scaler's horizontal ratio
+ * @main_vratio:	the main scaler's vertical ratio
+ */
+struct gsc_scaler {
+	u32	pre_shfactor;
+	u32	pre_hratio;
+	u32	pre_vratio;
+	unsigned long main_hratio;
+	unsigned long main_vratio;
+};
+
+struct gsc_dev;
+
+struct gsc_ctx;
+
+/**
+ * struct gsc_frame - source/target frame properties
+ * @f_width:	SRC : SRCIMG_WIDTH, DST : OUTPUTDMA_WHOLE_IMG_WIDTH
+ * @f_height:	SRC : SRCIMG_HEIGHT, DST : OUTPUTDMA_WHOLE_IMG_HEIGHT
+ * @crop:	cropped(source)/scaled(destination) size
+ * @payload:	image size in bytes (w x h x bpp)
+ * @addr:	image frame buffer physical addresses
+ * @fmt:	G-scaler color format pointer
+ * @alph:	frame's alpha value
+ */
+struct gsc_frame {
+	u32	f_width;
+	u32	f_height;
+	struct v4l2_rect	crop;
+	unsigned long payload[VIDEO_MAX_PLANES];
+	struct gsc_addr		addr;
+	struct gsc_fmt		*fmt;
+	u8	alpha;
+};
+
+struct gsc_sensor_info {
+	struct exynos_isp_info *pdata;
+	struct v4l2_subdev *sd;
+	struct clk *camclk;
+};
+
+struct gsc_capture_device {
+	struct gsc_ctx			*ctx;
+	struct video_device		*vfd;
+	struct v4l2_subdev		*sd_cap;
+	struct v4l2_subdev		*sd_disp;
+	struct v4l2_subdev		*sd_flite[FLITE_MAX_ENTITIES];
+	struct v4l2_subdev		*sd_csis[CSIS_MAX_ENTITIES];
+	struct gsc_sensor_info		sensor[SENSOR_MAX_ENTITIES];
+	struct media_pad		vd_pad;
+	struct media_pad		sd_pads[GSC_PADS_NUM];
+	struct v4l2_mbus_framefmt	mbus_fmt[GSC_PADS_NUM];
+	struct vb2_queue		vbq;
+	int				active_buf_cnt;
+	int				buf_index;
+	int				input_index;
+	int				refcnt;
+	u32				frame_cnt;
+	u32				reqbufs_cnt;
+	enum gsc_cap_input_entity	input;
+	u32				cam_index;
+};
+
+/**
+ * struct gsc_output_device - v4l2 output device data
+ * @vfd: the video device node for v4l2 output mode
+ * @alloc_ctx: v4l2 memory-to-memory device data
+ * @ctx: hardware context data
+ * @sd: v4l2 subdev pointer of gscaler
+ * @vbq: videobuf2 queue of gscaler output device
+ * @vb_pad: the pad of gscaler video entity
+ * @sd_pads: pads of gscaler subdev entity
+ * @active_buf_q: linked list structure of input buffer
+ * @req_cnt: the number of requested buffer
+ */
+struct gsc_output_device {
+	struct video_device	*vfd;
+	struct vb2_alloc_ctx	*alloc_ctx;
+	struct gsc_ctx		*ctx;
+	struct v4l2_subdev	*sd;
+	struct vb2_queue	vbq;
+	struct media_pad	vd_pad;
+	struct media_pad	sd_pads[GSC_PADS_NUM];
+	struct list_head	active_buf_q;
+	int			req_cnt;
+};
+
+/**
+ * struct gsc_m2m_device - v4l2 memory-to-memory device data
+ * @vfd: the video device node for v4l2 m2m mode
+ * @m2m_dev: v4l2 memory-to-memory device data
+ * @ctx: hardware context data
+ * @refcnt: the reference counter
+ */
+struct gsc_m2m_device {
+	struct video_device	*vfd;
+	struct v4l2_m2m_dev	*m2m_dev;
+	struct gsc_ctx		*ctx;
+	int			refcnt;
+};
+
+/**
+ *  struct gsc_pix_max - image pixel size limits in various IP configurations
+ *
+ *  @org_scaler_bypass_w: max pixel width when the scaler is disabled
+ *  @org_scaler_bypass_h: max pixel height when the scaler is disabled
+ *  @org_scaler_input_w: max pixel width when the scaler is enabled
+ *  @org_scaler_input_h: max pixel height when the scaler is enabled
+ *  @real_rot_dis_w: max pixel src cropped height with the rotator is off
+ *  @real_rot_dis_h: max pixel src croppped width with the rotator is off
+ *  @real_rot_en_w: max pixel src cropped width with the rotator is on
+ *  @real_rot_en_h: max pixel src cropped height with the rotator is on
+ *  @target_rot_dis_w: max pixel dst scaled width with the rotator is off
+ *  @target_rot_dis_h: max pixel dst scaled height with the rotator is off
+ *  @target_rot_en_w: max pixel dst scaled width with the rotator is on
+ *  @target_rot_en_h: max pixel dst scaled height with the rotator is on
+ */
+struct gsc_pix_max {
+	u16 org_scaler_bypass_w;
+	u16 org_scaler_bypass_h;
+	u16 org_scaler_input_w;
+	u16 org_scaler_input_h;
+	u16 real_rot_dis_w;
+	u16 real_rot_dis_h;
+	u16 real_rot_en_w;
+	u16 real_rot_en_h;
+	u16 target_rot_dis_w;
+	u16 target_rot_dis_h;
+	u16 target_rot_en_w;
+	u16 target_rot_en_h;
+};
+
+/**
+ *  struct gsc_pix_min - image pixel size limits in various IP configurations
+ *
+ *  @org_w: minimum source pixel width
+ *  @org_h: minimum source pixel height
+ *  @real_w: minimum input crop pixel width
+ *  @real_h: minimum input crop pixel height
+ *  @target_rot_dis_w: minimum output scaled pixel height when rotator is off
+ *  @target_rot_dis_h: minimum output scaled pixel height when rotator is off
+ *  @target_rot_en_w: minimum output scaled pixel height when rotator is on
+ *  @target_rot_en_h: minimum output scaled pixel height when rotator is on
+ */
+struct gsc_pix_min {
+	u16 org_w;
+	u16 org_h;
+	u16 real_w;
+	u16 real_h;
+	u16 target_rot_dis_w;
+	u16 target_rot_dis_h;
+	u16 target_rot_en_w;
+	u16 target_rot_en_h;
+};
+
+struct gsc_pix_align {
+	u16 org_h;
+	u16 org_w;
+	u16 offset_h;
+	u16 real_w;
+	u16 real_h;
+	u16 target_w;
+	u16 target_h;
+};
+
+/**
+ * struct gsc_variant - G-Scaler variant information
+ */
+struct gsc_variant {
+	struct gsc_pix_max *pix_max;
+	struct gsc_pix_min *pix_min;
+	struct gsc_pix_align *pix_align;
+	u16		in_buf_cnt;
+	u16		out_buf_cnt;
+	u16		sc_up_max;
+	u16		sc_down_max;
+	u16		poly_sc_down_max;
+	u16		pre_sc_down_max;
+	u16		local_sc_down;
+};
+
+/**
+ * struct gsc_driverdata - per device type driver data for init time.
+ *
+ * @variant: the variant information for this driver.
+ * @lclk_frequency: g-scaler clock frequency
+ * @num_entities: the number of g-scalers
+ */
+struct gsc_driverdata {
+	struct gsc_variant *variant[GSC_MAX_DEVS];
+	unsigned long	lclk_frequency;
+	int		num_entities;
+};
+
+struct gsc_pipeline {
+	struct media_pipeline *pipe;
+	struct v4l2_subdev *sd_gsc;
+	struct v4l2_subdev *disp;
+	struct v4l2_subdev *flite;
+	struct v4l2_subdev *csis;
+	struct v4l2_subdev *sensor;
+};
+
+/**
+ * struct gsc_dev - abstraction for G-Scaler entity
+ * @slock:	the spinlock protecting this data structure
+ * @lock:	the mutex protecting this data structure
+ * @pdev:	pointer to the G-Scaler platform device
+ * @variant:	the IP variant information
+ * @id:		g_scaler device index (0..GSC_MAX_DEVS)
+ * @regs:	the mapped hardware registers
+ * @regs_res:	the resource claimed for IO registers
+ * @irq:	G-scaler interrupt number
+ * @irq_queue:	interrupt handler waitqueue
+ * @m2m:	memory-to-memory V4L2 device information
+ * @out:	memory-to-local V4L2 output device information
+ * @state:	flags used to synchronize m2m and capture mode operation
+ * @alloc_ctx:	videobuf2 memory allocator context
+ * @vb2:	videobuf2 memory allocator call-back functions
+ * @mdev:	pointer to exynos media device
+ * @pipeline:	pointer to subdevs that are connected with gscaler
+ */
+struct gsc_dev {
+	spinlock_t			slock;
+	struct mutex			lock;
+	struct platform_device		*pdev;
+	struct gsc_variant		*variant;
+	u16				id;
+	struct clk			*clock;
+	void __iomem			*regs;
+	struct resource			*regs_res;
+	int				irq;
+	wait_queue_head_t		irq_queue;
+	struct work_struct		work_struct;
+	struct workqueue_struct		*irq_workqueue;
+	struct gsc_m2m_device		m2m;
+	struct gsc_output_device	out;
+	struct gsc_capture_device	cap;
+	struct exynos_platform_gscaler	*pdata;
+	unsigned long			state;
+	struct vb2_alloc_ctx		*alloc_ctx;
+	struct exynos_md		*mdev[MAX_MDEV];
+	struct gsc_pipeline		pipeline;
+	struct exynos_entity_data	md_data;
+};
+
+/**
+ * gsc_ctx - the device context data
+ * @slock:		spinlock protecting this data structure
+ * @s_frame:		source frame properties
+ * @d_frame:		destination frame properties
+ * @in_path:		input mode (DMA or camera)
+ * @out_path:		output mode (DMA or FIFO)
+ * @scaler:		image scaler properties
+ * @flags:		additional flags for image conversion
+ * @state:		flags to keep track of user configuration
+ * @gsc_dev:		the g-scaler device this context applies to
+ * @m2m_ctx:		memory-to-memory device context
+ * @fh:                 v4l2 file handle
+ * @ctrl_handler:       v4l2 controls handler
+ * @ctrls_rdy:          true if the control handler is initialized
+ * @gsc_ctrls		G-Scaler control set
+ * @m2m_ctx:		memory-to-memory device context
+ */
+struct gsc_ctx {
+	spinlock_t		slock;
+	struct gsc_frame	s_frame;
+	struct gsc_frame	d_frame;
+	enum gsc_datapath	in_path;
+	enum gsc_datapath	out_path;
+	struct gsc_scaler	scaler;
+	u32			flags;
+	u32			state;
+	struct gsc_dev		*gsc_dev;
+	struct v4l2_m2m_ctx	*m2m_ctx;
+	struct v4l2_fh		fh;
+	struct v4l2_ctrl_handler ctrl_handler;
+	struct gsc_ctrls	gsc_ctrls;
+	bool			ctrls_rdy;
+};
+
+void gsc_set_prefbuf(struct gsc_dev *gsc, struct gsc_frame frm);
+void gsc_clk_release(struct gsc_dev *gsc);
+int gsc_register_m2m_device(struct gsc_dev *gsc);
+void gsc_unregister_m2m_device(struct gsc_dev *gsc);
+int gsc_register_output_device(struct gsc_dev *gsc);
+void gsc_unregister_output_device(struct gsc_dev *gsc);
+int gsc_register_capture_device(struct gsc_dev *gsc);
+void gsc_unregister_capture_device(struct gsc_dev *gsc);
+
+u32 get_plane_size(struct gsc_frame *fr, unsigned int plane);
+char gsc_total_fmts(void);
+struct gsc_fmt *get_format(int index);
+struct gsc_fmt *find_fmt(u32 *pixelformat, u32 *mbus_code, int index);
+int gsc_enum_fmt_mplane(struct v4l2_fmtdesc *f);
+int gsc_try_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f);
+void gsc_set_frame_size(struct gsc_frame *frame, int width, int height);
+int gsc_g_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f);
+void gsc_check_crop_change(u32 tmp_w, u32 tmp_h, u32 *w, u32 *h);
+int gsc_g_crop(struct gsc_ctx *ctx, struct v4l2_crop *cr);
+int gsc_try_crop(struct gsc_ctx *ctx, struct v4l2_crop *cr);
+int gsc_cal_prescaler_ratio(struct gsc_variant *var, u32 src, u32 dst, u32 *ratio);
+void gsc_get_prescaler_shfactor(u32 hratio, u32 vratio, u32 *sh);
+void gsc_check_src_scale_info(struct gsc_variant *var, struct gsc_frame *s_frame,
+			      u32 *wratio, u32 tx, u32 ty, u32 *hratio);
+int gsc_check_scaler_ratio(struct gsc_variant *var, int sw, int sh, int dw,
+			   int dh, int rot, int out_path);
+int gsc_set_scaler_info(struct gsc_ctx *ctx);
+int gsc_ctrls_create(struct gsc_ctx *ctx);
+void gsc_ctrls_delete(struct gsc_ctx *ctx);
+int gsc_out_hw_set(struct gsc_ctx *ctx);
+int gsc_out_set_in_addr(struct gsc_dev *gsc, struct gsc_ctx *ctx,
+		   struct gsc_input_buf *buf, int index);
+int gsc_prepare_addr(struct gsc_ctx *ctx, struct vb2_buffer *vb,
+		     struct gsc_frame *frame, struct gsc_addr *addr);
+int gsc_out_link_validate(const struct media_pad *source,
+			  const struct media_pad *sink);
+int gsc_pipeline_s_stream(struct gsc_dev *gsc, bool on);
+
+static inline void gsc_ctx_state_lock_set(u32 state, struct gsc_ctx *ctx)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->slock, flags);
+	ctx->state |= state;
+	spin_unlock_irqrestore(&ctx->slock, flags);
+}
+
+static inline void gsc_ctx_state_lock_clear(u32 state, struct gsc_ctx *ctx)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->slock, flags);
+	ctx->state &= ~state;
+	spin_unlock_irqrestore(&ctx->slock, flags);
+}
+
+static inline int get_win_num(struct gsc_dev *dev)
+{
+	return (dev->id == 3) ? 2 : dev->id;
+}
+
+static inline int is_output(enum v4l2_buf_type type)
+{
+	return (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE ||
+		type == V4L2_BUF_TYPE_VIDEO_OUTPUT) ? 1 : 0;
+}
+
+static inline void gsc_hw_enable_control(struct gsc_dev *dev, bool on)
+{
+	u32 cfg = readl(dev->regs + GSC_ENABLE);
+
+	if (on)
+		cfg |= GSC_ENABLE_ON;
+	else
+		cfg &= ~GSC_ENABLE_ON;
+
+	writel(cfg, dev->regs + GSC_ENABLE);
+}
+
+static inline int gsc_hw_get_irq_status(struct gsc_dev *dev)
+{
+	u32 cfg = readl(dev->regs + GSC_IRQ);
+	if (cfg & (1 << GSC_OR_IRQ))
+		return GSC_OR_IRQ;
+	else
+		return GSC_DONE_IRQ;
+
+}
+
+static inline void gsc_hw_clear_irq(struct gsc_dev *dev, int irq)
+{
+	u32 cfg = readl(dev->regs + GSC_IRQ);
+	if (irq == GSC_OR_IRQ)
+		cfg |= GSC_IRQ_STATUS_OR_IRQ;
+	else if (irq == GSC_DONE_IRQ)
+		cfg |= GSC_IRQ_STATUS_OR_FRM_DONE;
+	writel(cfg, dev->regs + GSC_IRQ);
+}
+
+static inline void gsc_lock(struct vb2_queue *vq)
+{
+	struct gsc_ctx *ctx = vb2_get_drv_priv(vq);
+	mutex_lock(&ctx->gsc_dev->lock);
+}
+
+static inline void gsc_unlock(struct vb2_queue *vq)
+{
+	struct gsc_ctx *ctx = vb2_get_drv_priv(vq);
+	mutex_unlock(&ctx->gsc_dev->lock);
+}
+
+static inline bool gsc_ctx_state_is_set(u32 mask, struct gsc_ctx *ctx)
+{
+	unsigned long flags;
+	bool ret;
+
+	spin_lock_irqsave(&ctx->slock, flags);
+	ret = (ctx->state & mask) == mask;
+	spin_unlock_irqrestore(&ctx->slock, flags);
+	return ret;
+}
+
+static inline struct gsc_frame *ctx_get_frame(struct gsc_ctx *ctx,
+					      enum v4l2_buf_type type)
+{
+	struct gsc_frame *frame;
+
+	if (V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE == type) {
+		frame = &ctx->s_frame;
+	} else if (V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE == type) {
+		frame = &ctx->d_frame;
+	} else {
+		gsc_err("Wrong buffer/video queue type (%d)", type);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return frame;
+}
+
+static inline struct gsc_input_buf *
+active_queue_pop(struct gsc_output_device *vid_out, struct gsc_dev *dev)
+{
+	struct gsc_input_buf *buf;
+
+	buf = list_entry(vid_out->active_buf_q.next, struct gsc_input_buf, list);
+	return buf;
+}
+
+static inline void active_queue_push(struct gsc_output_device *vid_out,
+				     struct gsc_input_buf *buf, struct gsc_dev *dev)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&dev->slock, flags);
+	list_add_tail(&buf->list, &vid_out->active_buf_q);
+	spin_unlock_irqrestore(&dev->slock, flags);
+}
+
+static inline struct gsc_dev *entity_to_gsc(struct media_entity *me)
+{
+	struct v4l2_subdev *sd;
+
+	sd = container_of(me, struct v4l2_subdev, entity);
+	return entity_data_to_gsc(v4l2_get_subdevdata(sd));
+}
+
+static inline void user_to_drv(struct v4l2_ctrl *ctrl, s32 value)
+{
+	ctrl->cur.val = ctrl->val = value;
+}
+
+void gsc_hw_set_sw_reset(struct gsc_dev *dev);
+void gsc_hw_set_one_frm_mode(struct gsc_dev *dev, bool mask);
+void gsc_hw_set_frm_done_irq_mask(struct gsc_dev *dev, bool mask);
+void gsc_hw_set_overflow_irq_mask(struct gsc_dev *dev, bool mask);
+void gsc_hw_set_gsc_irq_enable(struct gsc_dev *dev, bool mask);
+void gsc_hw_set_input_buf_mask_all(struct gsc_dev *dev);
+void gsc_hw_set_output_buf_mask_all(struct gsc_dev *dev);
+void gsc_hw_set_input_buf_masking(struct gsc_dev *dev, u32 shift, bool enable);
+void gsc_hw_set_output_buf_masking(struct gsc_dev *dev, u32 shift, bool enable);
+void gsc_hw_set_input_addr(struct gsc_dev *dev, struct gsc_addr *addr, int index);
+void gsc_hw_set_output_addr(struct gsc_dev *dev, struct gsc_addr *addr, int index);
+void gsc_hw_set_input_path(struct gsc_ctx *ctx);
+void gsc_hw_set_in_size(struct gsc_ctx *ctx);
+void gsc_hw_set_in_image_rgb(struct gsc_ctx *ctx);
+void gsc_hw_set_in_image_format(struct gsc_ctx *ctx);
+void gsc_hw_set_output_path(struct gsc_ctx *ctx);
+void gsc_hw_set_out_size(struct gsc_ctx *ctx);
+void gsc_hw_set_out_image_rgb(struct gsc_ctx *ctx);
+void gsc_hw_set_out_image_format(struct gsc_ctx *ctx);
+void gsc_hw_set_prescaler(struct gsc_ctx *ctx);
+void gsc_hw_set_mainscaler(struct gsc_ctx *ctx);
+void gsc_hw_set_rotation(struct gsc_ctx *ctx);
+void gsc_hw_set_global_alpha(struct gsc_ctx *ctx);
+void gsc_hw_set_sfr_update(struct gsc_ctx *ctx);
+void gsc_hw_set_local_dst(int id, bool on);
+void gsc_hw_set_sysreg_writeback(struct gsc_ctx *ctx);
+void gsc_hw_set_sysreg_camif(bool on);
+
+int gsc_hw_get_input_buf_mask_status(struct gsc_dev *dev);
+int gsc_hw_get_done_input_buf_index(struct gsc_dev *dev);
+int gsc_hw_get_done_output_buf_index(struct gsc_dev *dev);
+int gsc_hw_get_nr_unmask_bits(struct gsc_dev *dev);
+int gsc_wait_reset(struct gsc_dev *dev);
+int gsc_wait_operating(struct gsc_dev *dev);
+int gsc_wait_stop(struct gsc_dev *dev);
+
+void gsc_disp_fifo_sw_reset(struct gsc_dev *dev);
+void gsc_pixelasync_sw_reset(struct gsc_dev *dev);
+
+
+#endif /* GSC_CORE_H_ */
diff --git a/drivers/media/video/exynos/gsc/gsc-m2m.c b/drivers/media/video/exynos/gsc/gsc-m2m.c
new file mode 100644
index 0000000..a00a642
--- /dev/null
+++ b/drivers/media/video/exynos/gsc/gsc-m2m.c
@@ -0,0 +1,696 @@
+/* linux/drivers/media/video/exynos/gsc/gsc-m2m.c
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Samsung EXYNOS5 SoC series G-scaler driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation, either version 2 of the License,
+ * or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/version.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/bug.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/list.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <media/v4l2-ioctl.h>
+
+#include "gsc-core.h"
+
+static int gsc_ctx_stop_req(struct gsc_ctx *ctx)
+{
+	struct gsc_ctx *curr_ctx;
+	struct gsc_dev *gsc = ctx->gsc_dev;
+	int ret = 0;
+
+	curr_ctx = v4l2_m2m_get_curr_priv(gsc->m2m.m2m_dev);
+	if (!gsc_m2m_run(gsc) || (curr_ctx != ctx))
+		return 0;
+	ctx->state |= GSC_CTX_STOP_REQ;
+	ret = wait_event_timeout(gsc->irq_queue,
+			!gsc_ctx_state_is_set(GSC_CTX_STOP_REQ, ctx),
+			GSC_SHUTDOWN_TIMEOUT);
+	if (!ret)
+		ret = -EBUSY;
+
+	return ret;
+}
+
+static int gsc_m2m_stop_streaming(struct vb2_queue *q)
+{
+	struct gsc_ctx *ctx = q->drv_priv;
+	struct gsc_dev *gsc = ctx->gsc_dev;
+	int ret;
+
+	ret = gsc_ctx_stop_req(ctx);
+	/* FIXME: need to add v4l2_m2m_job_finish(fail) if ret is timeout */
+	if (ret < 0)
+		dev_err(&gsc->pdev->dev, "wait timeout : %s\n", __func__);
+
+	return 0;
+}
+
+static void gsc_m2m_job_abort(void *priv)
+{
+	struct gsc_ctx *ctx = priv;
+	struct gsc_dev *gsc = ctx->gsc_dev;
+	int ret;
+
+	ret = gsc_ctx_stop_req(ctx);
+	/* FIXME: need to add v4l2_m2m_job_finish(fail) if ret is timeout */
+	if (ret < 0)
+		dev_err(&gsc->pdev->dev, "wait timeout : %s\n", __func__);
+}
+
+int gsc_fill_addr(struct gsc_ctx *ctx)
+{
+	struct gsc_frame *s_frame, *d_frame;
+	struct vb2_buffer *vb = NULL;
+	int ret = 0;
+
+	s_frame = &ctx->s_frame;
+	d_frame = &ctx->d_frame;
+
+	vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	ret = gsc_prepare_addr(ctx, vb, s_frame, &s_frame->addr);
+	if (ret)
+		return ret;
+
+	vb = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	ret = gsc_prepare_addr(ctx, vb, d_frame, &d_frame->addr);
+
+	return ret;
+}
+
+static void gsc_m2m_device_run(void *priv)
+{
+	struct gsc_ctx *ctx = priv;
+	struct gsc_dev *gsc;
+	unsigned long flags;
+	u32 ret;
+	bool is_set = false;
+
+	if (WARN(!ctx, "null hardware context\n"))
+		return;
+
+	gsc = ctx->gsc_dev;
+	pm_runtime_get_sync(&gsc->pdev->dev);
+
+	spin_lock_irqsave(&ctx->slock, flags);
+	/* Reconfigure hardware if the context has changed. */
+	if (gsc->m2m.ctx != ctx) {
+		gsc_dbg("gsc->m2m.ctx = 0x%p, current_ctx = 0x%p",
+			  gsc->m2m.ctx, ctx);
+		ctx->state |= GSC_PARAMS;
+		gsc->m2m.ctx = ctx;
+	}
+
+	is_set = (ctx->state & GSC_CTX_STOP_REQ) ? 1 : 0;
+	ctx->state &= ~GSC_CTX_STOP_REQ;
+	if (is_set) {
+		wake_up(&gsc->irq_queue);
+		goto put_device;
+	}
+
+	ret = gsc_fill_addr(ctx);
+	if (ret) {
+		gsc_err("Wrong address");
+		goto put_device;
+	}
+
+	gsc_set_prefbuf(gsc, ctx->s_frame);
+	gsc_hw_set_input_addr(gsc, &ctx->s_frame.addr, GSC_M2M_BUF_NUM);
+	gsc_hw_set_output_addr(gsc, &ctx->d_frame.addr, GSC_M2M_BUF_NUM);
+
+	if (ctx->state & GSC_PARAMS) {
+		gsc_hw_set_input_buf_masking(gsc, GSC_M2M_BUF_NUM, false);
+		gsc_hw_set_output_buf_masking(gsc, GSC_M2M_BUF_NUM, false);
+		gsc_hw_set_frm_done_irq_mask(gsc, false);
+		gsc_hw_set_gsc_irq_enable(gsc, true);
+
+		if (gsc_set_scaler_info(ctx)) {
+			gsc_err("Scaler setup error");
+			goto put_device;
+		}
+
+		gsc_hw_set_input_path(ctx);
+		gsc_hw_set_in_size(ctx);
+		gsc_hw_set_in_image_format(ctx);
+
+		gsc_hw_set_output_path(ctx);
+		gsc_hw_set_out_size(ctx);
+		gsc_hw_set_out_image_format(ctx);
+
+		gsc_hw_set_prescaler(ctx);
+		gsc_hw_set_mainscaler(ctx);
+		gsc_hw_set_rotation(ctx);
+		gsc_hw_set_global_alpha(ctx);
+	}
+	/* When you update SFRs in the middle of operating
+	gsc_hw_set_sfr_update(ctx);
+	*/
+
+	ctx->state &= ~GSC_PARAMS;
+
+	if (!test_and_set_bit(ST_M2M_RUN, &gsc->state)) {
+		/* One frame mode sequence
+		 GSCALER_ON on -> GSCALER_OP_STATUS is operating ->
+		 GSCALER_ON off */
+		gsc_hw_enable_control(gsc, true);
+		ret = gsc_wait_operating(gsc);
+		if (ret < 0) {
+			gsc_err("gscaler wait operating timeout");
+			goto put_device;
+		}
+		gsc_hw_enable_control(gsc, false);
+	}
+
+	spin_unlock_irqrestore(&ctx->slock, flags);
+	return;
+
+put_device:
+	ctx->state &= ~GSC_PARAMS;
+	spin_unlock_irqrestore(&ctx->slock, flags);
+	pm_runtime_put_sync(&gsc->pdev->dev);
+}
+
+static int gsc_m2m_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+			unsigned int *num_buffers, unsigned int *num_planes,
+			unsigned int sizes[], void *allocators[])
+{
+	struct gsc_ctx *ctx = vb2_get_drv_priv(vq);
+	struct gsc_frame *frame;
+	int i;
+
+	frame = ctx_get_frame(ctx, vq->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	if (!frame->fmt)
+		return -EINVAL;
+
+	*num_planes = frame->fmt->num_planes;
+	for (i = 0; i < frame->fmt->num_planes; i++) {
+		sizes[i] = get_plane_size(frame, i);
+		allocators[i] = ctx->gsc_dev->alloc_ctx;
+	}
+	return 0;
+}
+
+static int gsc_m2m_buf_prepare(struct vb2_buffer *vb)
+{
+	struct gsc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct gsc_frame *frame;
+	int i;
+
+	frame = ctx_get_frame(ctx, vb->vb2_queue->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	if (!V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
+		for (i = 0; i < frame->fmt->num_planes; i++)
+			vb2_set_plane_payload(vb, i, frame->payload[i]);
+	}
+
+	return 0;
+}
+
+static void gsc_m2m_buf_queue(struct vb2_buffer *vb)
+{
+	struct gsc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+
+	gsc_dbg("ctx: %p, ctx->state: 0x%x", ctx, ctx->state);
+
+	if (ctx->m2m_ctx)
+		v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
+}
+
+struct vb2_ops gsc_m2m_qops = {
+	.queue_setup	 = gsc_m2m_queue_setup,
+	.buf_prepare	 = gsc_m2m_buf_prepare,
+	.buf_queue	 = gsc_m2m_buf_queue,
+	.wait_prepare	 = gsc_unlock,
+	.wait_finish	 = gsc_lock,
+	.stop_streaming	 = gsc_m2m_stop_streaming,
+};
+
+static int gsc_m2m_querycap(struct file *file, void *fh,
+			   struct v4l2_capability *cap)
+{
+	struct gsc_ctx *ctx = fh_to_ctx(fh);
+	struct gsc_dev *gsc = ctx->gsc_dev;
+
+	strncpy(cap->driver, gsc->pdev->name, sizeof(cap->driver) - 1);
+	strncpy(cap->card, gsc->pdev->name, sizeof(cap->card) - 1);
+	cap->bus_info[0] = 0;
+	cap->capabilities = V4L2_CAP_STREAMING |
+		V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT |
+		V4L2_CAP_VIDEO_CAPTURE_MPLANE | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
+
+	return 0;
+}
+
+static int gsc_m2m_enum_fmt_mplane(struct file *file, void *priv,
+				struct v4l2_fmtdesc *f)
+{
+	return gsc_enum_fmt_mplane(f);
+}
+
+static int gsc_m2m_g_fmt_mplane(struct file *file, void *fh,
+			     struct v4l2_format *f)
+{
+	struct gsc_ctx *ctx = fh_to_ctx(fh);
+
+	if ((f->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) &&
+	    (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE))
+		return -EINVAL;
+
+	return gsc_g_fmt_mplane(ctx, f);
+}
+
+static int gsc_m2m_try_fmt_mplane(struct file *file, void *fh,
+				  struct v4l2_format *f)
+{
+	struct gsc_ctx *ctx = fh_to_ctx(fh);
+
+	if ((f->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) &&
+	    (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE))
+		return -EINVAL;
+
+	return gsc_try_fmt_mplane(ctx, f);
+}
+
+static int gsc_m2m_s_fmt_mplane(struct file *file, void *fh,
+				 struct v4l2_format *f)
+{
+	struct gsc_ctx *ctx = fh_to_ctx(fh);
+	struct vb2_queue *vq;
+	struct gsc_frame *frame;
+	struct v4l2_pix_format_mplane *pix;
+	int i, ret = 0;
+
+	ret = gsc_m2m_try_fmt_mplane(file, fh, f);
+	if (ret)
+		return ret;
+
+	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+
+	if (vb2_is_streaming(vq)) {
+		gsc_err("queue (%d) busy", f->type);
+		return -EBUSY;
+	}
+
+	if (V4L2_TYPE_IS_OUTPUT(f->type)) {
+		frame = &ctx->s_frame;
+	} else {
+		frame = &ctx->d_frame;
+	}
+
+	pix = &f->fmt.pix_mp;
+	frame->fmt = find_fmt(&pix->pixelformat, NULL, 0);
+	if (!frame->fmt)
+		return -EINVAL;
+
+	for (i = 0; i < frame->fmt->num_planes; i++)
+		frame->payload[i] = pix->plane_fmt[i].sizeimage;
+
+	gsc_set_frame_size(frame, pix->width, pix->height);
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		gsc_ctx_state_lock_set(GSC_PARAMS | GSC_DST_FMT, ctx);
+	else
+		gsc_ctx_state_lock_set(GSC_PARAMS | GSC_SRC_FMT, ctx);
+
+	gsc_dbg("f_w: %d, f_h: %d", frame->f_width, frame->f_height);
+
+	return 0;
+}
+
+static int gsc_m2m_reqbufs(struct file *file, void *fh,
+			  struct v4l2_requestbuffers *reqbufs)
+{
+	struct gsc_ctx *ctx = fh_to_ctx(fh);
+	struct gsc_dev *gsc = ctx->gsc_dev;
+	struct gsc_frame *frame;
+	u32 max_cnt;
+
+	max_cnt = (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) ?
+		gsc->variant->in_buf_cnt : gsc->variant->out_buf_cnt;
+	if (reqbufs->count > max_cnt)
+		return -EINVAL;
+	else if (reqbufs->count == 0) {
+		if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+			gsc_ctx_state_lock_clear(GSC_SRC_FMT, ctx);
+		else
+			gsc_ctx_state_lock_clear(GSC_DST_FMT, ctx);
+	}
+
+	frame = ctx_get_frame(ctx, reqbufs->type);
+
+	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
+}
+
+static int gsc_m2m_querybuf(struct file *file, void *fh,
+			   struct v4l2_buffer *buf)
+{
+	struct gsc_ctx *ctx = fh_to_ctx(fh);
+	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
+}
+
+static int gsc_m2m_qbuf(struct file *file, void *fh,
+			  struct v4l2_buffer *buf)
+{
+	struct gsc_ctx *ctx = fh_to_ctx(fh);
+	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
+}
+
+static int gsc_m2m_dqbuf(struct file *file, void *fh,
+			   struct v4l2_buffer *buf)
+{
+	struct gsc_ctx *ctx = fh_to_ctx(fh);
+	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
+}
+
+static int gsc_m2m_streamon(struct file *file, void *fh,
+			   enum v4l2_buf_type type)
+{
+	struct gsc_ctx *ctx = fh_to_ctx(fh);
+
+	/* The source and target color format need to be set */
+	if (V4L2_TYPE_IS_OUTPUT(type)) {
+		if (!gsc_ctx_state_is_set(GSC_SRC_FMT, ctx))
+			return -EINVAL;
+	} else if (!gsc_ctx_state_is_set(GSC_DST_FMT, ctx)) {
+		return -EINVAL;
+	}
+
+	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
+}
+
+static int gsc_m2m_streamoff(struct file *file, void *fh,
+			    enum v4l2_buf_type type)
+{
+	struct gsc_ctx *ctx = fh_to_ctx(fh);
+	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
+}
+
+static int gsc_m2m_cropcap(struct file *file, void *fh,
+			struct v4l2_cropcap *cr)
+{
+	struct gsc_frame *frame;
+	struct gsc_ctx *ctx = fh_to_ctx(fh);
+
+	frame = ctx_get_frame(ctx, cr->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	cr->bounds.left		= 0;
+	cr->bounds.top		= 0;
+	cr->bounds.width	= frame->f_width;
+	cr->bounds.height	= frame->f_height;
+	cr->defrect		= cr->bounds;
+
+	return 0;
+}
+
+static int gsc_m2m_g_crop(struct file *file, void *fh, struct v4l2_crop *cr)
+{
+	struct gsc_ctx *ctx = fh_to_ctx(fh);
+
+	return gsc_g_crop(ctx, cr);
+}
+
+static int gsc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
+{
+	struct gsc_ctx *ctx = fh_to_ctx(fh);
+	struct gsc_variant *variant = ctx->gsc_dev->variant;
+	struct gsc_frame *f;
+	int ret;
+
+	ret = gsc_try_crop(ctx, cr);
+	if (ret)
+		return ret;
+
+	f = (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) ?
+		&ctx->s_frame : &ctx->d_frame;
+
+	/* Check to see if scaling ratio is within supported range */
+	if (gsc_ctx_state_is_set(GSC_DST_FMT | GSC_SRC_FMT, ctx)) {
+		if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+			ret = gsc_check_scaler_ratio(variant, cr->c.width,
+					cr->c.height, ctx->d_frame.crop.width,
+					ctx->d_frame.crop.height,
+					ctx->gsc_ctrls.rotate->val, ctx->out_path);
+		} else {
+			ret = gsc_check_scaler_ratio(variant, ctx->s_frame.crop.width,
+					ctx->s_frame.crop.height, cr->c.width,
+					cr->c.height, ctx->gsc_ctrls.rotate->val,
+					ctx->out_path);
+		}
+		if (ret) {
+			gsc_err("Out of scaler range");
+			return -EINVAL;
+		}
+	}
+
+	f->crop.left = cr->c.left;
+	f->crop.top = cr->c.top;
+	f->crop.width  = cr->c.width;
+	f->crop.height = cr->c.height;
+
+	gsc_ctx_state_lock_set(GSC_PARAMS, ctx);
+
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops gsc_m2m_ioctl_ops = {
+	.vidioc_querycap		= gsc_m2m_querycap,
+
+	.vidioc_enum_fmt_vid_cap_mplane	= gsc_m2m_enum_fmt_mplane,
+	.vidioc_enum_fmt_vid_out_mplane	= gsc_m2m_enum_fmt_mplane,
+
+	.vidioc_g_fmt_vid_cap_mplane	= gsc_m2m_g_fmt_mplane,
+	.vidioc_g_fmt_vid_out_mplane	= gsc_m2m_g_fmt_mplane,
+
+	.vidioc_try_fmt_vid_cap_mplane	= gsc_m2m_try_fmt_mplane,
+	.vidioc_try_fmt_vid_out_mplane	= gsc_m2m_try_fmt_mplane,
+
+	.vidioc_s_fmt_vid_cap_mplane	= gsc_m2m_s_fmt_mplane,
+	.vidioc_s_fmt_vid_out_mplane	= gsc_m2m_s_fmt_mplane,
+
+	.vidioc_reqbufs			= gsc_m2m_reqbufs,
+	.vidioc_querybuf		= gsc_m2m_querybuf,
+
+	.vidioc_qbuf			= gsc_m2m_qbuf,
+	.vidioc_dqbuf			= gsc_m2m_dqbuf,
+
+	.vidioc_streamon		= gsc_m2m_streamon,
+	.vidioc_streamoff		= gsc_m2m_streamoff,
+
+	.vidioc_g_crop			= gsc_m2m_g_crop,
+	.vidioc_s_crop			= gsc_m2m_s_crop,
+	.vidioc_cropcap			= gsc_m2m_cropcap
+
+};
+
+static int queue_init(void *priv, struct vb2_queue *src_vq,
+		      struct vb2_queue *dst_vq)
+{
+	struct gsc_ctx *ctx = priv;
+	int ret;
+
+	memset(src_vq, 0, sizeof(*src_vq));
+	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	src_vq->io_modes = VB2_MMAP | VB2_USERPTR;
+	src_vq->drv_priv = ctx;
+	src_vq->ops = &gsc_m2m_qops;
+	src_vq->mem_ops = &vb2_dma_contig_memops;
+	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+
+	ret = vb2_queue_init(src_vq);
+	if (ret)
+		return ret;
+
+	memset(dst_vq, 0, sizeof(*dst_vq));
+	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
+	dst_vq->drv_priv = ctx;
+	dst_vq->ops = &gsc_m2m_qops;
+	dst_vq->mem_ops = &vb2_dma_contig_memops;
+	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+
+	return vb2_queue_init(dst_vq);
+}
+
+static int gsc_m2m_open(struct file *file)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+	struct gsc_ctx *ctx = NULL;
+	int ret;
+
+	gsc_dbg("pid: %d, state: 0x%lx", task_pid_nr(current), gsc->state);
+
+	if (gsc_out_opened(gsc) || gsc_cap_opened(gsc))
+		return -EBUSY;
+
+	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	v4l2_fh_init(&ctx->fh, gsc->m2m.vfd);
+	ret = gsc_ctrls_create(ctx);
+	if (ret)
+		goto error_fh;
+
+	/* Use separate control handler per file handle */
+	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
+	file->private_data = &ctx->fh;
+	v4l2_fh_add(&ctx->fh);
+
+	ctx->gsc_dev = gsc;
+	/* Default color format */
+	ctx->s_frame.fmt = get_format(0);
+	ctx->d_frame.fmt = get_format(0);
+	/* Setup the device context for mem2mem mode. */
+	ctx->state |= GSC_CTX_M2M;
+	ctx->flags = 0;
+	ctx->in_path = GSC_DMA;
+	ctx->out_path = GSC_DMA;
+	spin_lock_init(&ctx->slock);
+
+	ctx->m2m_ctx = v4l2_m2m_ctx_init(gsc->m2m.m2m_dev, ctx, queue_init);
+	if (IS_ERR(ctx->m2m_ctx)) {
+		gsc_err("Failed to initialize m2m context");
+		ret = PTR_ERR(ctx->m2m_ctx);
+		goto error_fh;
+	}
+
+	if (gsc->m2m.refcnt++ == 0)
+		set_bit(ST_M2M_OPEN, &gsc->state);
+
+	gsc_dbg("gsc m2m driver is opened, ctx(0x%p)", ctx);
+	return 0;
+
+error_fh:
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	kfree(ctx);
+	return ret;
+}
+
+static int gsc_m2m_release(struct file *file)
+{
+	struct gsc_ctx *ctx = fh_to_ctx(file->private_data);
+	struct gsc_dev *gsc = ctx->gsc_dev;
+
+	gsc_dbg("pid: %d, state: 0x%lx, refcnt= %d",
+		task_pid_nr(current), gsc->state, gsc->m2m.refcnt);
+
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	gsc_ctrls_delete(ctx);
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+
+	if (--gsc->m2m.refcnt <= 0)
+		clear_bit(ST_M2M_OPEN, &gsc->state);
+	kfree(ctx);
+	return 0;
+}
+
+static unsigned int gsc_m2m_poll(struct file *file,
+				     struct poll_table_struct *wait)
+{
+	struct gsc_ctx *ctx = fh_to_ctx(file->private_data);
+
+	return v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
+}
+
+static int gsc_m2m_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct gsc_ctx *ctx = fh_to_ctx(file->private_data);
+
+	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
+}
+static const struct v4l2_file_operations gsc_m2m_fops = {
+	.owner		= THIS_MODULE,
+	.open		= gsc_m2m_open,
+	.release	= gsc_m2m_release,
+	.poll		= gsc_m2m_poll,
+	.unlocked_ioctl	= video_ioctl2,
+	.mmap		= gsc_m2m_mmap,
+};
+
+static struct v4l2_m2m_ops gsc_m2m_ops = {
+	.device_run	= gsc_m2m_device_run,
+	.job_abort	= gsc_m2m_job_abort,
+};
+
+int gsc_register_m2m_device(struct gsc_dev *gsc)
+{
+	struct video_device *vfd;
+	struct platform_device *pdev;
+	int ret = 0;
+
+	if (!gsc)
+		return -ENODEV;
+
+	pdev = gsc->pdev;
+
+	vfd = video_device_alloc();
+	if (!vfd) {
+		dev_err(&pdev->dev, "Failed to allocate video device\n");
+		return -ENOMEM;
+	}
+
+	vfd->fops	= &gsc_m2m_fops;
+	vfd->ioctl_ops	= &gsc_m2m_ioctl_ops;
+	vfd->release	= video_device_release;
+	vfd->lock	= &gsc->lock;
+	snprintf(vfd->name, sizeof(vfd->name), "%s:m2m", dev_name(&pdev->dev));
+
+	video_set_drvdata(vfd, gsc);
+
+	gsc->m2m.vfd = vfd;
+	gsc->m2m.m2m_dev = v4l2_m2m_init(&gsc_m2m_ops);
+	if (IS_ERR(gsc->m2m.m2m_dev)) {
+		dev_err(&pdev->dev, "failed to initialize v4l2-m2m device\n");
+		ret = PTR_ERR(gsc->m2m.m2m_dev);
+		goto err_m2m_r1;
+	}
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
+	if (ret) {
+		dev_err(&pdev->dev,
+			 "%s(): failed to register video device\n", __func__);
+		goto err_m2m_r2;
+	}
+
+	gsc_dbg("gsc m2m driver registered as /dev/video%d", vfd->num);
+
+	return 0;
+
+err_m2m_r2:
+	v4l2_m2m_release(gsc->m2m.m2m_dev);
+err_m2m_r1:
+	video_device_release(gsc->m2m.vfd);
+
+	return ret;
+}
+
+void gsc_unregister_m2m_device(struct gsc_dev *gsc)
+{
+	if (gsc)
+		v4l2_m2m_release(gsc->m2m.m2m_dev);
+}
diff --git a/drivers/media/video/exynos/gsc/gsc-output.c b/drivers/media/video/exynos/gsc/gsc-output.c
new file mode 100644
index 0000000..c460d7c
--- /dev/null
+++ b/drivers/media/video/exynos/gsc/gsc-output.c
@@ -0,0 +1,1034 @@
+/* linux/drivers/media/video/exynos/gsc/gsc-output.c
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Samsung EXYNOS5 SoC series G-scaler driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation, either version 2 of the License,
+ * or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/version.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/bug.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/list.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <linux/string.h>
+#include <linux/delay.h>
+#include <media/v4l2-ioctl.h>
+
+#include "gsc-core.h"
+
+int gsc_out_hw_reset_off (struct gsc_dev *gsc)
+{
+	int ret;
+
+	mdelay(1);
+	gsc_hw_set_sw_reset(gsc);
+	ret = gsc_wait_reset(gsc);
+	if (ret < 0) {
+		gsc_err("gscaler s/w reset timeout");
+		return ret;
+	}
+	gsc_pixelasync_sw_reset(gsc);
+	gsc_disp_fifo_sw_reset(gsc);
+	gsc_hw_enable_control(gsc, false);
+	ret = gsc_wait_stop(gsc);
+	if (ret < 0) {
+		gsc_err("gscaler stop timeout");
+		return ret;
+	}
+
+	return 0;
+}
+
+int gsc_out_hw_set(struct gsc_ctx *ctx)
+{
+	struct gsc_dev *gsc = ctx->gsc_dev;
+	int ret = 0;
+
+	ret = gsc_set_scaler_info(ctx);
+	if (ret) {
+		gsc_err("Scaler setup error");
+		return ret;
+	}
+
+	gsc_hw_set_frm_done_irq_mask(gsc, false);
+	gsc_hw_set_gsc_irq_enable(gsc, true);
+
+	gsc_hw_set_input_path(ctx);
+	gsc_hw_set_in_size(ctx);
+	gsc_hw_set_in_image_format(ctx);
+
+	gsc_hw_set_output_path(ctx);
+	gsc_hw_set_out_size(ctx);
+	gsc_hw_set_out_image_format(ctx);
+
+	gsc_hw_set_prescaler(ctx);
+	gsc_hw_set_mainscaler(ctx);
+	gsc_hw_set_rotation(ctx);
+	gsc_hw_set_global_alpha(ctx);
+	gsc_hw_set_input_buf_mask_all(gsc);
+
+	return 0;
+}
+
+static void gsc_subdev_try_crop(struct gsc_dev *gsc, struct v4l2_rect *cr)
+{
+	struct gsc_variant *variant = gsc->variant;
+	u32 max_w, max_h, min_w, min_h;
+	u32 tmp_w, tmp_h;
+
+	if (gsc->out.ctx->gsc_ctrls.rotate->val == 90 ||
+	gsc->out.ctx->gsc_ctrls.rotate->val == 270) {
+		max_w = variant->pix_max->target_rot_en_w;
+		max_h = variant->pix_max->target_rot_en_h;
+		min_w = variant->pix_min->target_rot_en_w;
+		min_h = variant->pix_min->target_rot_en_h;
+		tmp_w = cr->height;
+		tmp_h = cr->width;
+	} else {
+		max_w = variant->pix_max->target_rot_dis_w;
+		max_h = variant->pix_max->target_rot_dis_h;
+		min_w = variant->pix_min->target_rot_dis_w;
+		min_h = variant->pix_min->target_rot_dis_h;
+		tmp_w = cr->width;
+		tmp_h = cr->height;
+	}
+
+	gsc_dbg("min_w: %d, min_h: %d, max_w: %d, max_h = %d",
+	     min_w, min_h, max_w, max_h);
+
+	v4l_bound_align_image(&tmp_w, min_w, max_w, 0,
+			      &tmp_h, min_h, max_h, 0, 0);
+
+	if (gsc->out.ctx->gsc_ctrls.rotate->val == 90 ||
+	    gsc->out.ctx->gsc_ctrls.rotate->val == 270)
+		gsc_check_crop_change(tmp_h, tmp_w, &cr->width, &cr->height);
+	else
+		gsc_check_crop_change(tmp_w, tmp_h, &cr->width, &cr->height);
+
+	gsc_dbg("Aligned l:%d, t:%d, w:%d, h:%d", cr->left, cr->top,
+		cr->width, cr->height);
+}
+
+static int gsc_subdev_get_fmt(struct v4l2_subdev *sd,
+			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_format *fmt)
+{
+	struct gsc_dev *gsc = entity_data_to_gsc(v4l2_get_subdevdata(sd));
+	struct gsc_ctx *ctx = gsc->out.ctx;
+	struct v4l2_mbus_framefmt *mf = &fmt->format;
+	struct gsc_frame *f;
+
+	if (fmt->pad == GSC_PAD_SINK) {
+		gsc_err("Sink pad get_fmt is not supported");
+		return 0;
+	}
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		fmt->format = *v4l2_subdev_get_try_format(fh, fmt->pad);
+		return 0;
+	}
+
+	f = &ctx->d_frame;
+	mf->code = f->fmt->mbus_code;
+	mf->width = f->f_width;
+	mf->height = f->f_height;
+	mf->colorspace = V4L2_COLORSPACE_JPEG;
+
+	return 0;
+}
+
+static int gsc_subdev_set_fmt(struct v4l2_subdev *sd,
+			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_format *fmt)
+{
+	struct gsc_dev *gsc = entity_data_to_gsc(v4l2_get_subdevdata(sd));
+	struct v4l2_mbus_framefmt *mf;
+	struct gsc_ctx *ctx = gsc->out.ctx;
+	struct gsc_frame *f;
+
+	gsc_dbg("pad%d: code: 0x%x, %dx%d",
+	    fmt->pad, fmt->format.code, fmt->format.width, fmt->format.height);
+
+	if (fmt->pad == GSC_PAD_SINK) {
+		gsc_err("Sink pad set_fmt is not supported");
+		return 0;
+	}
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
+		mf->width = fmt->format.width;
+		mf->height = fmt->format.height;
+		mf->code = fmt->format.code;
+		mf->colorspace = V4L2_COLORSPACE_JPEG;
+	} else {
+		f = &ctx->d_frame;
+		gsc_set_frame_size(f, fmt->format.width, fmt->format.height);
+		f->fmt = find_fmt(NULL, &fmt->format.code, 0);
+		ctx->state |= GSC_DST_FMT;
+	}
+
+	return 0;
+}
+
+static int gsc_subdev_get_crop(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_crop *crop)
+{
+	struct gsc_dev *gsc = entity_data_to_gsc(v4l2_get_subdevdata(sd));
+	struct gsc_ctx *ctx = gsc->out.ctx;
+	struct v4l2_rect *r = &crop->rect;
+	struct gsc_frame *f;
+
+	if (crop->pad == GSC_PAD_SINK) {
+		gsc_err("Sink pad get_crop is not supported");
+		return 0;
+	}
+
+	if (crop->which == V4L2_SUBDEV_FORMAT_TRY) {
+		crop->rect = *v4l2_subdev_get_try_crop(fh, crop->pad);
+		return 0;
+	}
+
+	f = &ctx->d_frame;
+	r->left	  = f->crop.left;
+	r->top	  = f->crop.top;
+	r->width  = f->crop.width;
+	r->height = f->crop.height;
+
+	gsc_dbg("f:%p, pad%d: l:%d, t:%d, %dx%d, f_w: %d, f_h: %d",
+	    f, crop->pad, r->left, r->top, r->width, r->height,
+	    f->f_width, f->f_height);
+
+	return 0;
+}
+
+static int gsc_subdev_set_crop(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_crop *crop)
+{
+	struct gsc_dev *gsc = entity_data_to_gsc(v4l2_get_subdevdata(sd));
+	struct gsc_ctx *ctx = gsc->out.ctx;
+	struct v4l2_rect *r;
+	struct gsc_frame *f;
+
+	gsc_dbg("(%d,%d)/%dx%d", crop->rect.left, crop->rect.top, crop->rect.width, crop->rect.height);
+
+	if (crop->pad == GSC_PAD_SINK) {
+		gsc_err("Sink pad set_fmt is not supported\n");
+		return 0;
+	}
+
+	if (crop->which == V4L2_SUBDEV_FORMAT_TRY) {
+		r = v4l2_subdev_get_try_crop(fh, crop->pad);
+		r->left = crop->rect.left;
+		r->top = crop->rect.top;
+		r->width = crop->rect.width;
+		r->height = crop->rect.height;
+	} else {
+		f = &ctx->d_frame;
+		f->crop.left = crop->rect.left;
+		f->crop.top = crop->rect.top;
+		f->crop.width = crop->rect.width;
+		f->crop.height = crop->rect.height;
+	}
+
+	gsc_dbg("pad%d: (%d,%d)/%dx%d", crop->pad, crop->rect.left, crop->rect.top,
+	    crop->rect.width, crop->rect.height);
+
+	return 0;
+}
+
+static int gsc_subdev_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct gsc_dev *gsc = entity_data_to_gsc(v4l2_get_subdevdata(sd));
+	int ret;
+
+	if (enable) {
+		pm_runtime_get_sync(&gsc->pdev->dev);
+		ret = gsc_out_hw_set(gsc->out.ctx);
+		if (ret) {
+			gsc_err("GSC H/W setting is failed");
+			return -EINVAL;
+		}
+	} else {
+		INIT_LIST_HEAD(&gsc->out.active_buf_q);
+		clear_bit(ST_OUTPUT_STREAMON, &gsc->state);
+		pm_runtime_put_sync(&gsc->pdev->dev);
+	}
+
+	return 0;
+}
+
+static struct v4l2_subdev_pad_ops gsc_subdev_pad_ops = {
+	.get_fmt = gsc_subdev_get_fmt,
+	.set_fmt = gsc_subdev_set_fmt,
+	.get_crop = gsc_subdev_get_crop,
+	.set_crop = gsc_subdev_set_crop,
+};
+
+static struct v4l2_subdev_video_ops gsc_subdev_video_ops = {
+	.s_stream = gsc_subdev_s_stream,
+};
+
+static struct v4l2_subdev_ops gsc_subdev_ops = {
+	.pad = &gsc_subdev_pad_ops,
+	.video = &gsc_subdev_video_ops,
+};
+
+static int gsc_out_power_off(struct v4l2_subdev *sd)
+{
+	struct gsc_dev *gsc = entity_data_to_gsc(v4l2_get_subdevdata(sd));
+	int ret;
+
+	ret = gsc_out_hw_reset_off(gsc);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static struct exynos_media_ops gsc_out_link_callback = {
+	.power_off = gsc_out_power_off,
+};
+
+/*
+ * The video node ioctl operations
+ */
+static int gsc_output_querycap(struct file *file, void *priv,
+					struct v4l2_capability *cap)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+
+	strncpy(cap->driver, gsc->pdev->name, sizeof(cap->driver) - 1);
+	strncpy(cap->card, gsc->pdev->name, sizeof(cap->card) - 1);
+	cap->bus_info[0] = 0;
+	cap->capabilities = V4L2_CAP_STREAMING |
+		V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
+
+	return 0;
+}
+
+static int gsc_output_enum_fmt_mplane(struct file *file, void *priv,
+				struct v4l2_fmtdesc *f)
+{
+	return gsc_enum_fmt_mplane(f);
+}
+
+static int gsc_output_try_fmt_mplane(struct file *file, void *fh,
+			       struct v4l2_format *f)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+
+	if (!is_output(f->type)) {
+		gsc_err("Not supported buffer type");
+		return -EINVAL;
+	}
+
+	return gsc_try_fmt_mplane(gsc->out.ctx, f);
+}
+
+static int gsc_output_s_fmt_mplane(struct file *file, void *fh,
+				 struct v4l2_format *f)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+	struct gsc_ctx *ctx = gsc->out.ctx;
+	struct gsc_frame *frame;
+	struct v4l2_pix_format_mplane *pix;
+	int i, ret = 0;
+
+	ret = gsc_output_try_fmt_mplane(file, fh, f);
+	if (ret) {
+		gsc_err("Invalid argument");
+		return ret;
+	}
+
+	if (vb2_is_streaming(&gsc->out.vbq)) {
+		gsc_err("queue (%d) busy", f->type);
+		return -EBUSY;
+	}
+
+	frame = &ctx->s_frame;
+
+	pix = &f->fmt.pix_mp;
+	frame->fmt = find_fmt(&pix->pixelformat, NULL, 0);
+	if (!frame->fmt) {
+		gsc_err("Not supported pixel format");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < frame->fmt->num_planes; i++)
+		frame->payload[i] = pix->plane_fmt[i].sizeimage;
+
+	gsc_set_frame_size(frame, pix->width, pix->height);
+
+	ctx->state |= GSC_SRC_FMT;
+
+	gsc_dbg("f_w: %d, f_h: %d", frame->f_width, frame->f_height);
+
+	return 0;
+}
+
+static int gsc_output_g_fmt_mplane(struct file *file, void *fh,
+			     struct v4l2_format *f)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+	struct gsc_ctx *ctx = gsc->out.ctx;
+
+	if (!is_output(f->type)) {
+		gsc_err("Not supported buffer type");
+		return -EINVAL;
+	}
+
+	return gsc_g_fmt_mplane(ctx, f);
+}
+
+static int gsc_output_reqbufs(struct file *file, void *priv,
+			    struct v4l2_requestbuffers *reqbufs)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+	struct gsc_output_device *out = &gsc->out;
+	struct gsc_frame *frame;
+	int ret;
+
+	if (reqbufs->count > gsc->variant->in_buf_cnt) {
+		gsc_err("Requested count exceeds maximun count of input buffer");
+		return -EINVAL;
+	} else if (reqbufs->count == 0)
+		gsc_ctx_state_lock_clear(GSC_SRC_FMT | GSC_DST_FMT,
+					 out->ctx);
+
+	frame = ctx_get_frame(out->ctx, reqbufs->type);
+
+	ret = vb2_reqbufs(&out->vbq, reqbufs);
+	if (ret)
+		return ret;
+	out->req_cnt = reqbufs->count;
+
+	return ret;
+}
+
+static int gsc_output_querybuf(struct file *file, void *priv,
+			   struct v4l2_buffer *buf)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+	struct gsc_output_device *out = &gsc->out;
+
+	return vb2_querybuf(&out->vbq, buf);
+}
+
+static int gsc_output_streamon(struct file *file, void *priv,
+			     enum v4l2_buf_type type)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+	struct gsc_output_device *out = &gsc->out;
+	struct media_pad *sink_pad;
+	int ret;
+
+	sink_pad = media_entity_remote_source(&out->sd_pads[GSC_PAD_SOURCE]);
+	if (IS_ERR(sink_pad)) {
+		gsc_err("No sink pad conncted with a gscaler source pad");
+		return PTR_ERR(sink_pad);
+	}
+
+	ret = gsc_out_link_validate(&out->sd_pads[GSC_PAD_SOURCE], sink_pad);
+	if (ret) {
+		gsc_err("Output link validation is failed");
+		return ret;
+	}
+
+	media_entity_pipeline_start(&out->vfd->entity, gsc->pipeline.pipe);
+
+	return vb2_streamon(&gsc->out.vbq, type);
+}
+
+static int gsc_output_streamoff(struct file *file, void *priv,
+			    enum v4l2_buf_type type)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+
+	return vb2_streamoff(&gsc->out.vbq, type);
+}
+
+static int gsc_output_qbuf(struct file *file, void *priv,
+			  struct v4l2_buffer *buf)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+	struct gsc_output_device *out = &gsc->out;
+
+	return vb2_qbuf(&out->vbq, buf);
+}
+
+static int gsc_output_dqbuf(struct file *file, void *priv,
+			   struct v4l2_buffer *buf)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+
+	return vb2_dqbuf(&gsc->out.vbq, buf,
+			 file->f_flags & O_NONBLOCK);
+}
+
+static int gsc_output_cropcap(struct file *file, void *fh,
+				struct v4l2_cropcap *cr)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+	struct gsc_ctx *ctx = gsc->out.ctx;
+
+	if (!is_output(cr->type)) {
+		gsc_err("Not supported buffer type");
+		return -EINVAL;
+	}
+
+	cr->bounds.left		= 0;
+	cr->bounds.top		= 0;
+	cr->bounds.width	= ctx->s_frame.f_width;
+	cr->bounds.height	= ctx->s_frame.f_height;
+	cr->defrect		= cr->bounds;
+
+	return 0;
+
+}
+
+static int gsc_output_g_crop(struct file *file, void *fh,
+			     struct v4l2_crop *cr)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+
+	if (!is_output(cr->type)) {
+		gsc_err("Not supported buffer type");
+		return -EINVAL;
+	}
+
+	return gsc_g_crop(gsc->out.ctx, cr);
+}
+
+static int gsc_output_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+	struct gsc_ctx *ctx = gsc->out.ctx;
+	struct gsc_variant *variant = gsc->variant;
+	struct gsc_frame *f;
+	unsigned int mask = GSC_DST_FMT | GSC_SRC_FMT;
+	int ret;
+
+	if (!is_output(cr->type)) {
+		gsc_err("Not supported buffer type");
+		return -EINVAL;
+	}
+
+	ret = gsc_try_crop(ctx, cr);
+	if (ret)
+		return ret;
+
+	f = &ctx->s_frame;
+
+	/* Check to see if scaling ratio is within supported range */
+	if ((ctx->state & (GSC_DST_FMT | GSC_SRC_FMT)) == mask) {
+		ret = gsc_check_scaler_ratio(variant, f->crop.width,
+				f->crop.height, ctx->d_frame.crop.width,
+				ctx->d_frame.crop.height,
+				ctx->gsc_ctrls.rotate->val, ctx->out_path);
+		if (ret) {
+			gsc_err("Out of scaler range");
+			return -EINVAL;
+		}
+		gsc_subdev_try_crop(gsc, &ctx->d_frame.crop);
+	}
+
+	f->crop.left = cr->c.left;
+	f->crop.top = cr->c.top;
+	f->crop.width  = cr->c.width;
+	f->crop.height = cr->c.height;
+
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops gsc_output_ioctl_ops = {
+	.vidioc_querycap		= gsc_output_querycap,
+	.vidioc_enum_fmt_vid_out_mplane	= gsc_output_enum_fmt_mplane,
+
+	.vidioc_try_fmt_vid_out_mplane	= gsc_output_try_fmt_mplane,
+	.vidioc_s_fmt_vid_out_mplane	= gsc_output_s_fmt_mplane,
+	.vidioc_g_fmt_vid_out_mplane	= gsc_output_g_fmt_mplane,
+
+	.vidioc_reqbufs			= gsc_output_reqbufs,
+	.vidioc_querybuf		= gsc_output_querybuf,
+
+	.vidioc_qbuf			= gsc_output_qbuf,
+	.vidioc_dqbuf			= gsc_output_dqbuf,
+
+	.vidioc_streamon		= gsc_output_streamon,
+	.vidioc_streamoff		= gsc_output_streamoff,
+
+	.vidioc_g_crop			= gsc_output_g_crop,
+	.vidioc_s_crop			= gsc_output_s_crop,
+	.vidioc_cropcap			= gsc_output_cropcap,
+};
+
+static int gsc_out_video_s_stream(struct gsc_dev *gsc, int enable)
+{
+	struct gsc_output_device *out = &gsc->out;
+	struct media_pad *sink_pad;
+	struct v4l2_subdev *sd;
+	int ret = 0;
+
+	sink_pad = media_entity_remote_source(&out->vd_pad);
+	if (IS_ERR(sink_pad)) {
+		gsc_err("No sink pad conncted with a gscaler video source pad");
+		return PTR_ERR(sink_pad);
+	}
+	sd = media_entity_to_v4l2_subdev(sink_pad->entity);
+	ret = v4l2_subdev_call(sd, video, s_stream, enable);
+	if (ret)
+		gsc_err("G-Scaler subdev s_stream[%d] failed", enable);
+
+	return ret;
+}
+
+static int gsc_out_start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	struct gsc_ctx *ctx = q->drv_priv;
+	struct gsc_dev *gsc = ctx->gsc_dev;
+
+	return gsc_out_video_s_stream(gsc, 1);
+}
+
+static int gsc_out_stop_streaming(struct vb2_queue *q)
+{
+	struct gsc_ctx *ctx = q->drv_priv;
+	struct gsc_dev *gsc = ctx->gsc_dev;
+	int ret = 0;
+
+	ret = gsc_pipeline_s_stream(gsc, false);
+	if (ret)
+		return ret;
+
+	if (ctx->out_path == GSC_FIMD) {
+		gsc_hw_enable_control(gsc, false);
+		ret = gsc_wait_stop(gsc);
+		if (ret < 0)
+			return ret;
+	}
+	gsc_hw_set_input_buf_mask_all(gsc);
+
+	/* TODO: Add gscaler clock off function */
+	ret = gsc_out_video_s_stream(gsc, 0);
+	if (ret) {
+		gsc_err("G-Scaler video s_stream off failed");
+		return ret;
+	}
+	media_entity_pipeline_stop(&gsc->out.vfd->entity);
+
+	return ret;
+}
+
+static int gsc_out_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+			unsigned int *num_buffers, unsigned int *num_planes,
+			unsigned int sizes[], void *allocators[])
+{
+	struct gsc_ctx *ctx = vq->drv_priv;
+	struct gsc_fmt *ffmt = ctx->s_frame.fmt;
+	int i;
+
+	if (IS_ERR(ffmt)) {
+		gsc_err("Invalid source format");
+		return PTR_ERR(ffmt);
+	}
+
+	*num_planes = ffmt->num_planes;
+
+	for (i = 0; i < ffmt->num_planes; i++) {
+		sizes[i] = get_plane_size(&ctx->s_frame, i);
+		allocators[i] = ctx->gsc_dev->alloc_ctx;
+	}
+
+	return 0;
+}
+
+static int gsc_out_buffer_prepare(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct gsc_ctx *ctx = vq->drv_priv;
+
+	if (!ctx->s_frame.fmt || !is_output(vq->type)) {
+		gsc_err("Invalid argument");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int gsc_out_set_in_addr(struct gsc_dev *gsc, struct gsc_ctx *ctx,
+			struct gsc_input_buf *buf, int index)
+{
+	int ret;
+
+	ret = gsc_prepare_addr(ctx, &buf->vb, &ctx->s_frame, &ctx->s_frame.addr);
+	if (ret) {
+		gsc_err("Fail to prepare G-Scaler address");
+		return -EINVAL;
+	}
+	gsc_hw_set_input_addr(gsc, &ctx->s_frame.addr, index);
+	active_queue_push(&gsc->out, buf, gsc);
+	buf->idx = index;
+
+	return 0;
+}
+
+static void gsc_out_buffer_queue(struct vb2_buffer *vb)
+{
+	struct gsc_input_buf *buf
+		= container_of(vb, struct gsc_input_buf, vb);
+	struct vb2_queue *q = vb->vb2_queue;
+	struct gsc_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct gsc_dev *gsc = ctx->gsc_dev;
+	int ret;
+
+	if (gsc->out.req_cnt >= atomic_read(&q->queued_count)) {
+		ret = gsc_out_set_in_addr(gsc, ctx, buf, vb->v4l2_buf.index);
+		if (ret) {
+			gsc_err("Failed to prepare G-Scaler address");
+			return;
+		}
+		gsc_hw_set_input_buf_masking(gsc, vb->v4l2_buf.index, false);
+	} else {
+		gsc_err("All requested buffers have been queued already");
+		return;
+	}
+
+	if (!test_and_set_bit(ST_OUTPUT_STREAMON, &gsc->state)) {
+		gsc_disp_fifo_sw_reset(gsc);
+		gsc_pixelasync_sw_reset(gsc);
+		gsc_hw_enable_control(gsc, true);
+		ret = gsc_wait_operating(gsc);
+		if (ret < 0) {
+			gsc_err("wait operation timeout");
+			return;
+		}
+		gsc_pipeline_s_stream(gsc, true);
+	}
+}
+
+static struct vb2_ops gsc_output_qops = {
+	.queue_setup		= gsc_out_queue_setup,
+	.buf_prepare		= gsc_out_buffer_prepare,
+	.buf_queue		= gsc_out_buffer_queue,
+	.wait_prepare		= gsc_unlock,
+	.wait_finish		= gsc_lock,
+	.start_streaming	= gsc_out_start_streaming,
+	.stop_streaming		= gsc_out_stop_streaming,
+};
+
+static int gsc_out_link_setup(struct media_entity *entity,
+			   const struct media_pad *local,
+			   const struct media_pad *remote, u32 flags)
+{
+	if (media_entity_type(entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+		return 0;
+
+	if (local->flags == MEDIA_PAD_FL_SOURCE) {
+		struct gsc_dev *gsc = entity_to_gsc(entity);
+		struct v4l2_subdev *sd;
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (gsc->pipeline.disp == NULL) {
+				/* Gscaler 0 --> Winwow 0, Gscaler 1 --> Window 1,
+				   Gscaler 2 --> Window 2, Gscaler 3 --> Window 2 */
+				char name[FIMD_NAME_SIZE];
+				sprintf(name, "%s%d", FIMD_ENTITY_NAME, get_win_num(gsc));
+				gsc_hw_set_local_dst(gsc->id, true);
+				sd = media_entity_to_v4l2_subdev(remote->entity);
+				gsc->pipeline.disp = sd;
+				if (!strcmp(sd->name, name))
+					gsc->out.ctx->out_path = GSC_FIMD;
+				else
+					gsc->out.ctx->out_path = GSC_MIXER;
+			} else
+				gsc_err("G-Scaler source pad was linked already");
+		} else if (!(flags & ~MEDIA_LNK_FL_ENABLED)) {
+			if (gsc->pipeline.disp != NULL) {
+				gsc_hw_set_local_dst(gsc->id, false);
+				gsc->pipeline.disp = NULL;
+				gsc->out.ctx->out_path = 0;
+			} else
+				gsc_err("G-Scaler source pad was unlinked already");
+		}
+	}
+
+	return 0;
+}
+
+static const struct media_entity_operations gsc_out_media_ops = {
+	.link_setup = gsc_out_link_setup,
+};
+
+int gsc_output_ctrls_create(struct gsc_dev *gsc)
+{
+	int ret;
+
+	ret = gsc_ctrls_create(gsc->out.ctx);
+	if (ret) {
+		gsc_err("Failed to create controls of G-Scaler");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int gsc_output_open(struct file *file)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+	int ret = v4l2_fh_open(file);
+
+	if (ret)
+		return ret;
+
+	gsc_dbg("pid: %d, state: 0x%lx", task_pid_nr(current), gsc->state);
+
+	/* Return if the corresponding mem2mem/output/capture video node
+	   is already opened. */
+	if (gsc_m2m_opened(gsc) || gsc_cap_opened(gsc) || gsc_out_opened(gsc)) {
+		gsc_err("G-Scaler%d has been opened already", gsc->id);
+		return -EBUSY;
+	}
+
+	if (WARN_ON(gsc->out.ctx == NULL)) {
+		gsc_err("G-Scaler output context is NULL");
+		return -ENXIO;
+	}
+
+	set_bit(ST_OUTPUT_OPEN, &gsc->state);
+
+	ret = gsc_ctrls_create(gsc->out.ctx);
+	if (ret < 0) {
+		v4l2_fh_release(file);
+		clear_bit(ST_OUTPUT_OPEN, &gsc->state);
+		return ret;
+	}
+
+	return ret;
+}
+
+static int gsc_output_close(struct file *file)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+
+	gsc_dbg("pid: %d, state: 0x%lx", task_pid_nr(current), gsc->state);
+
+	clear_bit(ST_OUTPUT_OPEN, &gsc->state);
+	vb2_queue_release(&gsc->out.vbq);
+	gsc_ctrls_delete(gsc->out.ctx);
+	v4l2_fh_release(file);
+
+	return 0;
+}
+
+static unsigned int gsc_output_poll(struct file *file,
+				      struct poll_table_struct *wait)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+
+	return vb2_poll(&gsc->out.vbq, file, wait);
+}
+
+static int gsc_output_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct gsc_dev *gsc = video_drvdata(file);
+
+	return vb2_mmap(&gsc->out.vbq, vma);
+}
+
+static const struct v4l2_file_operations gsc_output_fops = {
+	.owner		= THIS_MODULE,
+	.open		= gsc_output_open,
+	.release	= gsc_output_close,
+	.poll		= gsc_output_poll,
+	.unlocked_ioctl	= video_ioctl2,
+	.mmap		= gsc_output_mmap,
+};
+
+static int gsc_create_link(struct gsc_dev *gsc)
+{
+	struct media_entity *source, *sink;
+	int ret;
+
+	source = &gsc->out.vfd->entity;
+	sink = &gsc->out.sd->entity;
+	ret = media_entity_create_link(source, 0, sink, GSC_PAD_SINK,
+				       MEDIA_LNK_FL_IMMUTABLE |
+				       MEDIA_LNK_FL_ENABLED);
+	if (ret) {
+		gsc_err("Failed to create link between G-Scaler vfd and subdev");
+		return ret;
+	}
+
+	return 0;
+}
+
+
+static int gsc_create_subdev(struct gsc_dev *gsc)
+{
+	struct v4l2_subdev *sd;
+	int ret;
+
+	sd = kzalloc(sizeof(*sd), GFP_KERNEL);
+	if (!sd)
+	       return -ENOMEM;
+
+	v4l2_subdev_init(sd, &gsc_subdev_ops);
+	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
+	snprintf(sd->name, sizeof(sd->name), "%s.%d", GSC_SUBDEV_NAME, gsc->id);
+
+	gsc->out.sd_pads[GSC_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	gsc->out.sd_pads[GSC_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_init(&sd->entity, GSC_PADS_NUM,
+				gsc->out.sd_pads, 0);
+	if (ret) {
+		gsc_err("Failed to initialize the G-Scaler media entity");
+		goto error;
+	}
+
+	sd->entity.ops = &gsc_out_media_ops;
+	ret = v4l2_device_register_subdev(&gsc->mdev[MDEV_OUTPUT]->v4l2_dev, sd);
+	if (ret) {
+		media_entity_cleanup(&sd->entity);
+		goto error;
+	}
+	gsc->mdev[MDEV_OUTPUT]->gsc_sd[gsc->id] = sd;
+	gsc_dbg("gsc_sd[%d] = 0x%08x\n", gsc->id,
+			(u32)gsc->mdev[MDEV_OUTPUT]->gsc_sd[gsc->id]);
+	gsc->out.sd = sd;
+	gsc->md_data.media_ops = &gsc_out_link_callback;
+	v4l2_set_subdevdata(sd, &gsc->md_data);
+
+	return 0;
+error:
+	kfree(sd);
+	return ret;
+}
+
+int gsc_register_output_device(struct gsc_dev *gsc)
+{
+	struct video_device *vfd;
+	struct gsc_output_device *gsc_out;
+	struct gsc_ctx *ctx;
+	struct vb2_queue *q;
+	int ret = -ENOMEM;
+
+	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	ctx->gsc_dev	 = gsc;
+	ctx->s_frame.fmt = get_format(GSC_OUT_DEF_SRC);
+	ctx->d_frame.fmt = get_format(GSC_OUT_DEF_DST);
+	ctx->in_path	 = GSC_DMA;
+	ctx->state	 = GSC_CTX_OUTPUT;
+
+	vfd = video_device_alloc();
+	if (!vfd) {
+		gsc_err("Failed to allocate video device");
+		goto err_ctx_alloc;
+	}
+
+	snprintf(vfd->name, sizeof(vfd->name), "%s.output",
+		 dev_name(&gsc->pdev->dev));
+
+
+	vfd->fops	= &gsc_output_fops;
+	vfd->ioctl_ops	= &gsc_output_ioctl_ops;
+	vfd->v4l2_dev	= &gsc->mdev[MDEV_OUTPUT]->v4l2_dev;
+	vfd->release	= video_device_release;
+	vfd->lock	= &gsc->lock;
+	video_set_drvdata(vfd, gsc);
+
+	gsc_out	= &gsc->out;
+	gsc_out->vfd = vfd;
+
+	INIT_LIST_HEAD(&gsc_out->active_buf_q);
+	spin_lock_init(&ctx->slock);
+	gsc_out->ctx = ctx;
+
+	q = &gsc->out.vbq;
+	memset(q, 0, sizeof(*q));
+	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	q->io_modes = VB2_MMAP | VB2_USERPTR;
+	q->drv_priv = gsc->out.ctx;
+	q->ops = &gsc_output_qops;
+	q->mem_ops = &vb2_dma_contig_memops;;
+	q->buf_struct_size = sizeof(struct gsc_input_buf);
+
+	vb2_queue_init(q);
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
+	if (ret) {
+		gsc_err("Failed to register video device");
+		goto err_ent;
+	}
+
+	gsc->out.vd_pad.flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_init(&vfd->entity, 1, &gsc->out.vd_pad, 0);
+	if (ret)
+		goto err_ent;
+
+	ret = gsc_create_subdev(gsc);
+	if (ret)
+		goto err_sd_reg;
+
+	ret = gsc_create_link(gsc);
+	if (ret)
+		goto err_sd_reg;
+
+	vfd->ctrl_handler = &ctx->ctrl_handler;
+	gsc_dbg("gsc output driver registered as /dev/video%d, ctx(0x%08x)",
+		vfd->num, (u32)ctx);
+	return 0;
+
+err_sd_reg:
+	media_entity_cleanup(&vfd->entity);
+err_ent:
+	video_device_release(vfd);
+err_ctx_alloc:
+	kfree(ctx);
+	return ret;
+}
+
+static void gsc_destroy_subdev(struct gsc_dev *gsc)
+{
+	struct v4l2_subdev *sd = gsc->out.sd;
+
+	if (!sd)
+		return;
+	media_entity_cleanup(&sd->entity);
+	v4l2_device_unregister_subdev(sd);
+	kfree(sd);
+	sd = NULL;
+}
+
+void gsc_unregister_output_device(struct gsc_dev *gsc)
+{
+	struct video_device *vfd = gsc->out.vfd;
+
+	if (vfd) {
+		media_entity_cleanup(&vfd->entity);
+		/* Can also be called if video device was
+		   not registered */
+		video_unregister_device(vfd);
+	}
+	gsc_destroy_subdev(gsc);
+	kfree(gsc->out.ctx);
+	gsc->out.ctx = NULL;
+}
diff --git a/drivers/media/video/exynos/gsc/gsc-regs.c b/drivers/media/video/exynos/gsc/gsc-regs.c
new file mode 100644
index 0000000..81e33fd
--- /dev/null
+++ b/drivers/media/video/exynos/gsc/gsc-regs.c
@@ -0,0 +1,671 @@
+/* linux/drivers/media/video/exynos/gsc/gsc-regs.c
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Samsung EXYNOS5 SoC series G-scaler driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation, either version 2 of the License,
+ * or (at your option) any later version.
+ */
+
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <mach/map.h>
+#include "gsc-core.h"
+
+void gsc_hw_set_sw_reset(struct gsc_dev *dev)
+{
+	u32 cfg = 0;
+
+	cfg |= GSC_SW_RESET_SRESET;
+	writel(cfg, dev->regs + GSC_SW_RESET);
+}
+
+void gsc_disp_fifo_sw_reset(struct gsc_dev *dev)
+{
+	u32 cfg = readl(SYSREG_DISP1BLK_CFG);
+	/* DISPBLK1 FIFO S/W reset sequence
+	   set FIFORST_DISP1 as 0 then, set FIFORST_DISP1 as 1 again */
+	cfg &= ~FIFORST_DISP1;
+	writel(cfg, SYSREG_DISP1BLK_CFG);
+	cfg |= FIFORST_DISP1;
+	writel(cfg, SYSREG_DISP1BLK_CFG);
+}
+
+void gsc_pixelasync_sw_reset(struct gsc_dev *dev)
+{
+	u32 cfg = readl(SYSREG_GSCBLK_CFG0);
+	/* GSCBLK Pixel asyncy FIFO S/W reset sequence
+	   set PXLASYNC_SW_RESET as 0 then, set PXLASYNC_SW_RESET as 1 again */
+	cfg &= ~GSC_PXLASYNC_RST(dev->id);
+	writel(cfg, SYSREG_GSCBLK_CFG0);
+	cfg |= GSC_PXLASYNC_RST(dev->id);
+	writel(cfg, SYSREG_GSCBLK_CFG0);
+}
+
+int gsc_wait_reset(struct gsc_dev *dev)
+{
+	unsigned long timeo = jiffies + 10; /* timeout of 50ms */
+	u32 cfg;
+
+	while (time_before(jiffies, timeo)) {
+		cfg = readl(dev->regs + GSC_SW_RESET);
+		if (!cfg)
+			return 0;
+		usleep_range(10, 20);
+	}
+	gsc_dbg("wait time : %d ms", jiffies_to_msecs(jiffies - timeo + 20));
+
+	return -EBUSY;
+}
+
+int gsc_wait_operating(struct gsc_dev *dev)
+{
+	unsigned long timeo = jiffies + 10; /* timeout of 50ms */
+	u32 cfg;
+
+	while (time_before(jiffies, timeo)) {
+		cfg = readl(dev->regs + GSC_ENABLE);
+		if ((cfg & GSC_ENABLE_OP_STATUS) == GSC_ENABLE_OP_STATUS)
+			return 0;
+		usleep_range(10, 20);
+	}
+	gsc_dbg("wait time : %d ms", jiffies_to_msecs(jiffies - timeo + 20));
+
+	return -EBUSY;
+}
+
+int gsc_wait_stop(struct gsc_dev *dev)
+{
+	unsigned long timeo = jiffies + 10; /* timeout of 50ms */
+	u32 cfg;
+
+	while (time_before(jiffies, timeo)) {
+		cfg = readl(dev->regs + GSC_ENABLE);
+		if (!(cfg & GSC_ENABLE_OP_STATUS))
+			return 0;
+		usleep_range(10, 20);
+	}
+	gsc_dbg("wait time : %d ms", jiffies_to_msecs(jiffies - timeo + 20));
+
+	return -EBUSY;
+}
+
+
+void gsc_hw_set_one_frm_mode(struct gsc_dev *dev, bool mask)
+{
+	u32 cfg;
+
+	cfg = readl(dev->regs + GSC_ENABLE);
+	if (mask)
+		cfg |= GSC_ENABLE_ON_CLEAR;
+	else
+		cfg &= ~GSC_ENABLE_ON_CLEAR;
+	writel(cfg, dev->regs + GSC_ENABLE);
+}
+
+int gsc_hw_get_input_buf_mask_status(struct gsc_dev *dev)
+{
+	u32 cfg, status, bits = 0;
+
+	cfg = readl(dev->regs + GSC_IN_BASE_ADDR_Y_MASK);
+	status = cfg & GSC_IN_BASE_ADDR_MASK;
+	while (status) {
+		status = status & (status - 1);
+		bits++;
+	}
+	return bits;
+}
+
+int gsc_hw_get_done_input_buf_index(struct gsc_dev *dev)
+{
+	u32 cfg, curr_index, i;
+
+	cfg = readl(dev->regs + GSC_IN_BASE_ADDR_Y_MASK);
+	curr_index = GSC_IN_CURR_GET_INDEX(cfg);
+	for (i = curr_index; i > 1; i--) {
+		if (cfg ^ (1 << (i - 2)))
+			return i - 2;
+	}
+
+	for (i = dev->variant->in_buf_cnt; i > curr_index; i--) {
+		if (cfg ^ (1 << (i - 1)))
+			return i - 1;
+	}
+
+	return curr_index - 1;
+}
+
+int gsc_hw_get_done_output_buf_index(struct gsc_dev *dev)
+{
+	u32 cfg, curr_index, done_buf_index;
+	unsigned long state_mask;
+	u32 reqbufs_cnt = dev->cap.reqbufs_cnt;
+
+	cfg = readl(dev->regs + GSC_OUT_BASE_ADDR_Y_MASK);
+	curr_index = GSC_OUT_CURR_GET_INDEX(cfg);
+	gsc_dbg("curr_index : %d", curr_index);
+	state_mask = cfg & GSC_OUT_BASE_ADDR_MASK;
+
+	done_buf_index = (curr_index == 0) ? reqbufs_cnt - 1 : curr_index - 1;
+
+	do {
+		/* Test done_buf_index whether masking or not */
+		if (test_bit(done_buf_index, &state_mask))
+			done_buf_index = (done_buf_index == 0) ?
+				reqbufs_cnt - 1 : done_buf_index - 1;
+		else
+			return done_buf_index;
+	} while (done_buf_index != curr_index);
+
+	return -EBUSY;
+}
+
+void gsc_hw_set_frm_done_irq_mask(struct gsc_dev *dev, bool mask)
+{
+	u32 cfg;
+
+	cfg = readl(dev->regs + GSC_IRQ);
+	if (mask)
+		cfg |= GSC_IRQ_FRMDONE_MASK;
+	else
+		cfg &= ~GSC_IRQ_FRMDONE_MASK;
+	writel(cfg, dev->regs + GSC_IRQ);
+}
+
+void gsc_hw_set_overflow_irq_mask(struct gsc_dev *dev, bool mask)
+{
+	u32 cfg;
+
+	cfg = readl(dev->regs + GSC_IRQ);
+	if (mask)
+		cfg |= GSC_IRQ_OR_MASK;
+	else
+		cfg &= ~GSC_IRQ_OR_MASK;
+	writel(cfg, dev->regs + GSC_IRQ);
+}
+
+void gsc_hw_set_gsc_irq_enable(struct gsc_dev *dev, bool mask)
+{
+	u32 cfg;
+
+	cfg = readl(dev->regs + GSC_IRQ);
+	if (mask)
+		cfg |= GSC_IRQ_ENABLE;
+	else
+		cfg &= ~GSC_IRQ_ENABLE;
+	writel(cfg, dev->regs + GSC_IRQ);
+}
+
+void gsc_hw_set_input_buf_mask_all(struct gsc_dev *dev)
+{
+	u32 cfg;
+
+	cfg = readl(dev->regs + GSC_IN_BASE_ADDR_Y_MASK);
+	cfg |= GSC_IN_BASE_ADDR_MASK;
+	cfg |= GSC_IN_BASE_ADDR_PINGPONG(dev->variant->in_buf_cnt);
+
+	writel(cfg, dev->regs + GSC_IN_BASE_ADDR_Y_MASK);
+	writel(cfg, dev->regs + GSC_IN_BASE_ADDR_CB_MASK);
+	writel(cfg, dev->regs + GSC_IN_BASE_ADDR_CR_MASK);
+}
+
+void gsc_hw_set_output_buf_mask_all(struct gsc_dev *dev)
+{
+	u32 cfg;
+
+	cfg = readl(dev->regs + GSC_OUT_BASE_ADDR_Y_MASK);
+	cfg |= GSC_OUT_BASE_ADDR_MASK;
+	cfg |= GSC_OUT_BASE_ADDR_PINGPONG(dev->variant->out_buf_cnt);
+
+	writel(cfg, dev->regs + GSC_OUT_BASE_ADDR_Y_MASK);
+	writel(cfg, dev->regs + GSC_OUT_BASE_ADDR_CB_MASK);
+	writel(cfg, dev->regs + GSC_OUT_BASE_ADDR_CR_MASK);
+}
+
+void gsc_hw_set_input_buf_masking(struct gsc_dev *dev, u32 shift,
+				bool enable)
+{
+	u32 cfg = readl(dev->regs + GSC_IN_BASE_ADDR_Y_MASK);
+	u32 mask = 1 << shift;
+
+	cfg &= (~mask);
+	cfg |= enable << shift;
+
+	writel(cfg, dev->regs + GSC_IN_BASE_ADDR_Y_MASK);
+	writel(cfg, dev->regs + GSC_IN_BASE_ADDR_CB_MASK);
+	writel(cfg, dev->regs + GSC_IN_BASE_ADDR_CR_MASK);
+}
+
+void gsc_hw_set_output_buf_masking(struct gsc_dev *dev, u32 shift,
+				bool enable)
+{
+	u32 cfg = readl(dev->regs + GSC_OUT_BASE_ADDR_Y_MASK);
+	u32 mask = 1 << shift;
+
+	cfg &= (~mask);
+	cfg |= enable << shift;
+
+	writel(cfg, dev->regs + GSC_OUT_BASE_ADDR_Y_MASK);
+	writel(cfg, dev->regs + GSC_OUT_BASE_ADDR_CB_MASK);
+	writel(cfg, dev->regs + GSC_OUT_BASE_ADDR_CR_MASK);
+}
+
+int gsc_hw_get_nr_unmask_bits(struct gsc_dev *dev)
+{
+	u32 bits = 0;
+	u32 mask_bits = readl(dev->regs + GSC_OUT_BASE_ADDR_Y_MASK);
+	mask_bits &= GSC_OUT_BASE_ADDR_MASK;
+
+	while (mask_bits) {
+		mask_bits = mask_bits & (mask_bits - 1);
+		bits++;
+	}
+	bits = 16 - bits;
+
+	return bits;
+}
+
+void gsc_hw_set_input_addr(struct gsc_dev *dev, struct gsc_addr *addr,
+				int index)
+{
+	gsc_dbg("src_buf[%d]: 0x%X, cb: 0x%X, cr: 0x%X", index,
+		addr->y, addr->cb, addr->cr);
+	writel(addr->y, dev->regs + GSC_IN_BASE_ADDR_Y(index));
+	writel(addr->cb, dev->regs + GSC_IN_BASE_ADDR_CB(index));
+	writel(addr->cr, dev->regs + GSC_IN_BASE_ADDR_CR(index));
+
+}
+
+void gsc_hw_set_output_addr(struct gsc_dev *dev,
+			     struct gsc_addr *addr, int index)
+{
+	gsc_dbg("dst_buf[%d]: 0x%X, cb: 0x%X, cr: 0x%X",
+			index, addr->y, addr->cb, addr->cr);
+	writel(addr->y, dev->regs + GSC_OUT_BASE_ADDR_Y(index));
+	writel(addr->cb, dev->regs + GSC_OUT_BASE_ADDR_CB(index));
+	writel(addr->cr, dev->regs + GSC_OUT_BASE_ADDR_CR(index));
+}
+
+void gsc_hw_set_input_path(struct gsc_ctx *ctx)
+{
+	struct gsc_dev *dev = ctx->gsc_dev;
+
+	u32 cfg = readl(dev->regs + GSC_IN_CON);
+	cfg &= ~(GSC_IN_PATH_MASK | GSC_IN_LOCAL_SEL_MASK);
+
+	if (ctx->in_path == GSC_DMA) {
+		cfg |= GSC_IN_PATH_MEMORY;
+	} else {
+		cfg |= GSC_IN_PATH_LOCAL;
+		if (ctx->in_path == GSC_WRITEBACK) {
+			cfg |= GSC_IN_LOCAL_FIMD_WB;
+		} else {
+			struct v4l2_subdev *sd = dev->pipeline.sensor;
+			struct gsc_sensor_info *s_info =
+				v4l2_get_subdev_hostdata(sd);
+			if (s_info->pdata->cam_port == CAM_PORT_A)
+				cfg |= GSC_IN_LOCAL_CAM0;
+			else
+				cfg |= GSC_IN_LOCAL_CAM1;
+		}
+	}
+
+	writel(cfg, dev->regs + GSC_IN_CON);
+}
+
+void gsc_hw_set_in_size(struct gsc_ctx *ctx)
+{
+	struct gsc_dev *dev = ctx->gsc_dev;
+	struct gsc_frame *frame = &ctx->s_frame;
+	u32 cfg;
+
+	/* Set input pixel offset */
+	cfg = GSC_SRCIMG_OFFSET_X(frame->crop.left);
+	cfg |= GSC_SRCIMG_OFFSET_Y(frame->crop.top);
+	writel(cfg, dev->regs + GSC_SRCIMG_OFFSET);
+
+	/* Set input original size */
+	cfg = GSC_SRCIMG_WIDTH(frame->f_width);
+	cfg |= GSC_SRCIMG_HEIGHT(frame->f_height);
+	writel(cfg, dev->regs + GSC_SRCIMG_SIZE);
+
+	/* Set input cropped size */
+	cfg = GSC_CROPPED_WIDTH(frame->crop.width);
+	cfg |= GSC_CROPPED_HEIGHT(frame->crop.height);
+	writel(cfg, dev->regs + GSC_CROPPED_SIZE);
+}
+
+void gsc_hw_set_in_image_rgb(struct gsc_ctx *ctx)
+{
+	struct gsc_dev *dev = ctx->gsc_dev;
+	struct gsc_frame *frame = &ctx->s_frame;
+	u32 cfg;
+
+	cfg = readl(dev->regs + GSC_IN_CON);
+	if (ctx->gsc_ctrls.csc_eq->val) {
+		if (ctx->gsc_ctrls.csc_range->val)
+			cfg |= GSC_IN_RGB_HD_WIDE;
+		else
+			cfg |= GSC_IN_RGB_HD_NARROW;
+	} else {
+		if (ctx->gsc_ctrls.csc_range->val)
+			cfg |= GSC_IN_RGB_SD_WIDE;
+		else
+			cfg |= GSC_IN_RGB_SD_NARROW;
+	}
+
+	if (frame->fmt->pixelformat == V4L2_PIX_FMT_RGB565X)
+		cfg |= GSC_IN_RGB565;
+	else if (frame->fmt->pixelformat == V4L2_PIX_FMT_RGB32)
+		cfg |= GSC_IN_XRGB8888;
+
+	writel(cfg, dev->regs + GSC_IN_CON);
+}
+
+void gsc_hw_set_in_image_format(struct gsc_ctx *ctx)
+{
+	struct gsc_dev *dev = ctx->gsc_dev;
+	struct gsc_frame *frame = &ctx->s_frame;
+	u32 i, depth = 0;
+	u32 cfg;
+
+	cfg = readl(dev->regs + GSC_IN_CON);
+	cfg &= ~(GSC_IN_RGB_TYPE_MASK | GSC_IN_YUV422_1P_ORDER_MASK |
+		 GSC_IN_CHROMA_ORDER_MASK | GSC_IN_FORMAT_MASK |
+		 GSC_IN_TILE_TYPE_MASK | GSC_IN_TILE_MODE);
+	writel(cfg, dev->regs + GSC_IN_CON);
+
+	if (is_rgb(frame->fmt->color)) {
+		gsc_hw_set_in_image_rgb(ctx);
+		return;
+	}
+	for (i = 0; i < frame->fmt->num_planes; i++)
+		depth += frame->fmt->depth[i];
+
+	switch (frame->fmt->nr_comp) {
+	case 1:
+		cfg |= GSC_IN_YUV422_1P;
+		if (frame->fmt->yorder == GSC_LSB_Y)
+			cfg |= GSC_IN_YUV422_1P_ORDER_LSB_Y;
+		else
+			cfg |= GSC_IN_YUV422_1P_OEDER_LSB_C;
+		if (frame->fmt->corder == GSC_CBCR)
+			cfg |= GSC_IN_CHROMA_ORDER_CBCR;
+		else
+			cfg |= GSC_IN_CHROMA_ORDER_CRCB;
+		break;
+	case 2:
+		if (depth == 12)
+			cfg |= GSC_IN_YUV420_2P;
+		else
+			cfg |= GSC_IN_YUV422_2P;
+		if (frame->fmt->corder == GSC_CBCR)
+			cfg |= GSC_IN_CHROMA_ORDER_CBCR;
+		else
+			cfg |= GSC_IN_CHROMA_ORDER_CRCB;
+		break;
+	case 3:
+		if (depth == 12)
+			cfg |= GSC_IN_YUV420_3P;
+		else
+			cfg |= GSC_IN_YUV422_3P;
+		break;
+	};
+
+	writel(cfg, dev->regs + GSC_IN_CON);
+}
+
+void gsc_hw_set_output_path(struct gsc_ctx *ctx)
+{
+	struct gsc_dev *dev = ctx->gsc_dev;
+
+	u32 cfg = readl(dev->regs + GSC_OUT_CON);
+	cfg &= ~GSC_OUT_PATH_MASK;
+
+	if (ctx->out_path == GSC_DMA) {
+		cfg |= GSC_OUT_PATH_MEMORY;
+	} else {
+		cfg |= GSC_OUT_PATH_LOCAL;
+	}
+
+	writel(cfg, dev->regs + GSC_OUT_CON);
+}
+
+void gsc_hw_set_out_size(struct gsc_ctx *ctx)
+{
+	struct gsc_dev *dev = ctx->gsc_dev;
+	struct gsc_frame *frame = &ctx->d_frame;
+	u32 cfg;
+
+	/* Set output original size */
+	if (ctx->out_path == GSC_DMA) {
+		cfg = GSC_DSTIMG_OFFSET_X(frame->crop.left);
+		cfg |= GSC_DSTIMG_OFFSET_Y(frame->crop.top);
+		writel(cfg, dev->regs + GSC_DSTIMG_OFFSET);
+
+		cfg = GSC_DSTIMG_WIDTH(frame->f_width);
+		cfg |= GSC_DSTIMG_HEIGHT(frame->f_height);
+		writel(cfg, dev->regs + GSC_DSTIMG_SIZE);
+	}
+
+	/* Set output scaled size */
+	if (ctx->gsc_ctrls.rotate->val == 90 ||
+	    ctx->gsc_ctrls.rotate->val == 270) {
+		cfg = GSC_SCALED_WIDTH(frame->crop.height);
+		cfg |= GSC_SCALED_HEIGHT(frame->crop.width);
+	} else {
+		cfg = GSC_SCALED_WIDTH(frame->crop.width);
+		cfg |= GSC_SCALED_HEIGHT(frame->crop.height);
+	}
+	writel(cfg, dev->regs + GSC_SCALED_SIZE);
+}
+
+void gsc_hw_set_out_image_rgb(struct gsc_ctx *ctx)
+{
+	struct gsc_dev *dev = ctx->gsc_dev;
+	struct gsc_frame *frame = &ctx->d_frame;
+	u32 cfg;
+
+	cfg = readl(dev->regs + GSC_OUT_CON);
+	if (ctx->gsc_ctrls.csc_eq->val) {
+		if (ctx->gsc_ctrls.csc_range->val)
+			cfg |= GSC_OUT_RGB_HD_WIDE;
+		else
+			cfg |= GSC_OUT_RGB_HD_NARROW;
+	} else {
+		if (ctx->gsc_ctrls.csc_range->val)
+			cfg |= GSC_OUT_RGB_SD_WIDE;
+		else
+			cfg |= GSC_OUT_RGB_SD_NARROW;
+	}
+
+	if (frame->fmt->pixelformat == V4L2_PIX_FMT_RGB565X)
+		cfg |= GSC_OUT_RGB565;
+	else if (frame->fmt->pixelformat == V4L2_PIX_FMT_RGB32)
+		cfg |= GSC_OUT_XRGB8888;
+
+	writel(cfg, dev->regs + GSC_OUT_CON);
+}
+
+void gsc_hw_set_out_image_format(struct gsc_ctx *ctx)
+{
+	struct gsc_dev *dev = ctx->gsc_dev;
+	struct gsc_frame *frame = &ctx->d_frame;
+	u32 i, depth = 0;
+	u32 cfg;
+
+	cfg = readl(dev->regs + GSC_OUT_CON);
+	cfg &= ~(GSC_OUT_RGB_TYPE_MASK | GSC_OUT_YUV422_1P_ORDER_MASK |
+		 GSC_OUT_CHROMA_ORDER_MASK | GSC_OUT_FORMAT_MASK |
+		 GSC_OUT_TILE_TYPE_MASK | GSC_OUT_TILE_MODE);
+	writel(cfg, dev->regs + GSC_OUT_CON);
+
+	if (is_rgb(frame->fmt->color)) {
+		gsc_hw_set_out_image_rgb(ctx);
+		return;
+	}
+
+	if (ctx->out_path != GSC_DMA) {
+		cfg |= GSC_OUT_YUV444;
+		goto end_set;
+	}
+
+	for (i = 0; i < frame->fmt->num_planes; i++)
+		depth += frame->fmt->depth[i];
+
+	switch (frame->fmt->nr_comp) {
+	case 1:
+		cfg |= GSC_OUT_YUV422_1P;
+		if (frame->fmt->yorder == GSC_LSB_Y)
+			cfg |= GSC_OUT_YUV422_1P_ORDER_LSB_Y;
+		else
+			cfg |= GSC_OUT_YUV422_1P_OEDER_LSB_C;
+		if (frame->fmt->corder == GSC_CBCR)
+			cfg |= GSC_OUT_CHROMA_ORDER_CBCR;
+		else
+			cfg |= GSC_OUT_CHROMA_ORDER_CRCB;
+		break;
+	case 2:
+		if (depth == 12)
+			cfg |= GSC_OUT_YUV420_2P;
+		else
+			cfg |= GSC_OUT_YUV422_2P;
+		if (frame->fmt->corder == GSC_CBCR)
+			cfg |= GSC_OUT_CHROMA_ORDER_CBCR;
+		else
+			cfg |= GSC_OUT_CHROMA_ORDER_CRCB;
+		break;
+	case 3:
+		cfg |= GSC_OUT_YUV420_3P;
+		break;
+	};
+
+end_set:
+	writel(cfg, dev->regs + GSC_OUT_CON);
+}
+
+void gsc_hw_set_prescaler(struct gsc_ctx *ctx)
+{
+	struct gsc_dev *dev = ctx->gsc_dev;
+	struct gsc_scaler *sc = &ctx->scaler;
+	u32 cfg;
+
+	cfg = GSC_PRESC_SHFACTOR(sc->pre_shfactor);
+	cfg |= GSC_PRESC_H_RATIO(sc->pre_hratio);
+	cfg |= GSC_PRESC_V_RATIO(sc->pre_vratio);
+	writel(cfg, dev->regs + GSC_PRE_SCALE_RATIO);
+}
+
+void gsc_hw_set_mainscaler(struct gsc_ctx *ctx)
+{
+	struct gsc_dev *dev = ctx->gsc_dev;
+	struct gsc_scaler *sc = &ctx->scaler;
+	u32 cfg;
+
+	cfg = GSC_MAIN_H_RATIO_VALUE(sc->main_hratio);
+	writel(cfg, dev->regs + GSC_MAIN_H_RATIO);
+
+	cfg = GSC_MAIN_V_RATIO_VALUE(sc->main_vratio);
+	writel(cfg, dev->regs + GSC_MAIN_V_RATIO);
+}
+
+void gsc_hw_set_rotation(struct gsc_ctx *ctx)
+{
+	struct gsc_dev *dev = ctx->gsc_dev;
+	u32 cfg;
+
+	cfg = readl(dev->regs + GSC_IN_CON);
+	cfg &= ~GSC_IN_ROT_MASK;
+
+	switch (ctx->gsc_ctrls.rotate->val) {
+	case 270:
+		cfg |= GSC_IN_ROT_270;
+		break;
+	case 180:
+		cfg |= GSC_IN_ROT_180;
+		break;
+	case 90:
+		if (ctx->gsc_ctrls.hflip->val)
+			cfg |= GSC_IN_ROT_90_XFLIP;
+		else if (ctx->gsc_ctrls.vflip->val)
+			cfg |= GSC_IN_ROT_90_YFLIP;
+		else
+			cfg |= GSC_IN_ROT_90;
+		break;
+	case 0:
+		if (ctx->gsc_ctrls.hflip->val)
+			cfg |= GSC_IN_ROT_XFLIP;
+		else if (ctx->gsc_ctrls.vflip->val)
+			cfg |= GSC_IN_ROT_YFLIP;
+	}
+
+	writel(cfg, dev->regs + GSC_IN_CON);
+}
+
+void gsc_hw_set_global_alpha(struct gsc_ctx *ctx)
+{
+	struct gsc_dev *dev = ctx->gsc_dev;
+	struct gsc_frame *frame = &ctx->d_frame;
+	u32 cfg;
+
+	cfg = readl(dev->regs + GSC_OUT_CON);
+	cfg &= ~GSC_OUT_GLOBAL_ALPHA_MASK;
+
+	if (!is_rgb(frame->fmt->color)) {
+		gsc_dbg("Not a RGB format");
+		return;
+	}
+
+	cfg |= GSC_OUT_GLOBAL_ALPHA(ctx->gsc_ctrls.global_alpha->val);
+	writel(cfg, dev->regs + GSC_OUT_CON);
+}
+
+void gsc_hw_set_sfr_update(struct gsc_ctx *ctx)
+{
+	struct gsc_dev *dev = ctx->gsc_dev;
+	u32 cfg;
+
+	cfg = readl(dev->regs + GSC_ENABLE);
+	cfg |= GSC_ENABLE_SFR_UPDATE;
+	writel(cfg, dev->regs + GSC_ENABLE);
+}
+
+void gsc_hw_set_local_dst(int id, bool on)
+{
+	u32 cfg = readl(SYSREG_GSCBLK_CFG0);
+
+	if (on)
+		cfg |= GSC_OUT_DST_SEL(id);
+	else
+		cfg &= ~(GSC_OUT_DST_SEL(id));
+	writel(cfg, SYSREG_GSCBLK_CFG0);
+}
+
+void gsc_hw_set_sysreg_writeback(struct gsc_ctx *ctx)
+{
+	struct gsc_dev *dev = ctx->gsc_dev;
+
+	u32 cfg = readl(SYSREG_GSCBLK_CFG1);
+
+	cfg |= GSC_BLK_DISP1WB_DEST(dev->id);
+	cfg |= GSC_BLK_GSCL_WB_IN_SRC_SEL(dev->id);
+	cfg |= GSC_BLK_SW_RESET_WB_DEST(dev->id);
+
+	writel(cfg, SYSREG_GSCBLK_CFG1);
+}
+
+void gsc_hw_set_sysreg_camif(bool on)
+{
+	u32 cfg = readl(SYSREG_GSCBLK_CFG0);
+
+	if (on)
+		cfg |= GSC_PXLASYNC_CAMIF_TOP;
+	else
+		cfg &= ~(GSC_PXLASYNC_CAMIF_TOP);
+
+	writel(cfg, SYSREG_GSCBLK_CFG0);
+}
diff --git a/drivers/media/video/exynos/gsc/regs-gsc.h b/drivers/media/video/exynos/gsc/regs-gsc.h
new file mode 100644
index 0000000..9345d5c
--- /dev/null
+++ b/drivers/media/video/exynos/gsc/regs-gsc.h
@@ -0,0 +1,224 @@
+/* linux/drivers/media/video/exynos/gsc/regs-gsc.h
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Register definition file for Samsung G-Scaler driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef REGS_GSC_H_
+#define REGS_GSC_H_
+
+/* SYSCON. GSCBLK_CFG */
+#include <plat/map-base.h>
+#define SYSREG_DISP1BLK_CFG		(S3C_VA_SYS + 0x0214)
+#define FIFORST_DISP1			(1 << 23)
+#define SYSREG_GSCBLK_CFG0		(S3C_VA_SYS + 0x0220)
+#define GSC_OUT_DST_SEL(x)		(1 << (8 + 2 * (x)))
+#define GSC_PXLASYNC_RST(x)		(1 << (x))
+#define GSC_PXLASYNC_CAMIF_TOP		(1 << 20)
+#define SYSREG_GSCBLK_CFG1		(S3C_VA_SYS + 0x0224)
+#define GSC_BLK_DISP1WB_DEST(x)		(x << 10)
+#define GSC_BLK_SW_RESET_WB_DEST(x)	(1 << (18 + x))
+#define GSC_BLK_GSCL_WB_IN_SRC_SEL(x)	(1 << (2 * x))
+
+/* G-Scaler enable */
+#define GSC_ENABLE			0x00
+#define GSC_ENABLE_ON_CLEAR		(1 << 4)
+#define GSC_ENABLE_QOS_ENABLE		(1 << 3)
+#define GSC_ENABLE_OP_STATUS		(1 << 2)
+#define GSC_ENABLE_SFR_UPDATE		(1 << 1)
+#define GSC_ENABLE_ON			(1 << 0)
+
+/* G-Scaler S/W reset */
+#define GSC_SW_RESET			0x04
+#define GSC_SW_RESET_SRESET		(1 << 0)
+
+/* G-Scaler IRQ */
+#define GSC_IRQ				0x08
+#define GSC_IRQ_STATUS_OR_IRQ		(1 << 17)
+#define GSC_IRQ_STATUS_OR_FRM_DONE	(1 << 16)
+#define GSC_IRQ_OR_MASK			(1 << 2)
+#define GSC_IRQ_FRMDONE_MASK		(1 << 1)
+#define GSC_IRQ_ENABLE			(1 << 0)
+
+/* G-Scaler input control */
+#define GSC_IN_CON			0x10
+#define GSC_IN_ROT_MASK			(7 << 16)
+#define GSC_IN_ROT_270			(7 << 16)
+#define GSC_IN_ROT_90_YFLIP		(6 << 16)
+#define GSC_IN_ROT_90_XFLIP		(5 << 16)
+#define GSC_IN_ROT_90			(4 << 16)
+#define GSC_IN_ROT_180			(3 << 16)
+#define GSC_IN_ROT_YFLIP		(2 << 16)
+#define GSC_IN_ROT_XFLIP		(1 << 16)
+#define GSC_IN_RGB_TYPE_MASK		(3 << 14)
+#define GSC_IN_RGB_HD_WIDE		(3 << 14)
+#define GSC_IN_RGB_HD_NARROW		(2 << 14)
+#define GSC_IN_RGB_SD_WIDE		(1 << 14)
+#define GSC_IN_RGB_SD_NARROW		(0 << 14)
+#define GSC_IN_YUV422_1P_ORDER_MASK	(1 << 13)
+#define GSC_IN_YUV422_1P_ORDER_LSB_Y	(0 << 13)
+#define GSC_IN_YUV422_1P_OEDER_LSB_C	(1 << 13)
+#define GSC_IN_CHROMA_ORDER_MASK	(1 << 12)
+#define GSC_IN_CHROMA_ORDER_CBCR	(0 << 12)
+#define GSC_IN_CHROMA_ORDER_CRCB	(1 << 12)
+#define GSC_IN_FORMAT_MASK		(7 << 8)
+#define GSC_IN_XRGB8888			(0 << 8)
+#define GSC_IN_RGB565			(1 << 8)
+#define GSC_IN_YUV420_2P		(2 << 8)
+#define GSC_IN_YUV420_3P		(3 << 8)
+#define GSC_IN_YUV422_1P		(4 << 8)
+#define GSC_IN_YUV422_2P		(5 << 8)
+#define GSC_IN_YUV422_3P		(6 << 8)
+#define GSC_IN_TILE_TYPE_MASK		(1 << 4)
+#define GSC_IN_TILE_C_16x8		(0 << 4)
+#define GSC_IN_TILE_C_16x16		(1 << 4)
+#define GSC_IN_TILE_MODE		(1 << 3)
+#define GSC_IN_LOCAL_SEL_MASK		(3 << 1)
+#define GSC_IN_LOCAL_FIMD_WB		(2 << 1)
+#define GSC_IN_LOCAL_CAM1		(1 << 1)
+#define GSC_IN_LOCAL_CAM0		(0 << 1)
+#define GSC_IN_PATH_MASK		(1 << 0)
+#define GSC_IN_PATH_LOCAL		(1 << 0)
+#define GSC_IN_PATH_MEMORY		(0 << 0)
+
+/* G-Scaler source image size */
+#define GSC_SRCIMG_SIZE			0x14
+#define GSC_SRCIMG_HEIGHT_MASK		(0x1fff << 16)
+#define GSC_SRCIMG_HEIGHT(x)		((x) << 16)
+#define GSC_SRCIMG_WIDTH_MASK		(0x1fff << 0)
+#define GSC_SRCIMG_WIDTH(x)		((x) << 0)
+
+/* G-Scaler source image offset */
+#define GSC_SRCIMG_OFFSET		0x18
+#define GSC_SRCIMG_OFFSET_Y_MASK	(0x1fff << 16)
+#define GSC_SRCIMG_OFFSET_Y(x)		((x) << 16)
+#define GSC_SRCIMG_OFFSET_X_MASK	(0x1fff << 0)
+#define GSC_SRCIMG_OFFSET_X(x)		((x) << 0)
+
+/* G-Scaler cropped source image size */
+#define GSC_CROPPED_SIZE		0x1C
+#define GSC_CROPPED_HEIGHT_MASK		(0x1fff << 16)
+#define GSC_CROPPED_HEIGHT(x)		((x) << 16)
+#define GSC_CROPPED_WIDTH_MASK		(0x1fff << 0)
+#define GSC_CROPPED_WIDTH(x)		((x) << 0)
+
+/* G-Scaler output control */
+#define GSC_OUT_CON			0x20
+#define GSC_OUT_GLOBAL_ALPHA_MASK	(0xff << 24)
+#define GSC_OUT_GLOBAL_ALPHA(x)		((x) << 24)
+#define GSC_OUT_RGB_TYPE_MASK		(3 << 10)
+#define GSC_OUT_RGB_HD_NARROW		(3 << 10)
+#define GSC_OUT_RGB_HD_WIDE		(2 << 10)
+#define GSC_OUT_RGB_SD_NARROW		(1 << 10)
+#define GSC_OUT_RGB_SD_WIDE		(0 << 10)
+#define GSC_OUT_YUV422_1P_ORDER_MASK	(1 << 9)
+#define GSC_OUT_YUV422_1P_ORDER_LSB_Y	(0 << 9)
+#define GSC_OUT_YUV422_1P_OEDER_LSB_C	(1 << 9)
+#define GSC_OUT_CHROMA_ORDER_MASK	(1 << 8)
+#define GSC_OUT_CHROMA_ORDER_CBCR	(0 << 8)
+#define GSC_OUT_CHROMA_ORDER_CRCB	(1 << 8)
+#define GSC_OUT_FORMAT_MASK		(7 << 4)
+#define GSC_OUT_XRGB8888		(0 << 4)
+#define GSC_OUT_RGB565			(1 << 4)
+#define GSC_OUT_YUV420_2P		(2 << 4)
+#define GSC_OUT_YUV420_3P		(3 << 4)
+#define GSC_OUT_YUV422_1P		(4 << 4)
+#define GSC_OUT_YUV422_2P		(5 << 4)
+#define GSC_OUT_YUV444			(7 << 4)
+#define GSC_OUT_TILE_TYPE_MASK		(1 << 2)
+#define GSC_OUT_TILE_C_16x8		(0 << 2)
+#define GSC_OUT_TILE_C_16x16		(1 << 2)
+#define GSC_OUT_TILE_MODE		(1 << 1)
+#define GSC_OUT_PATH_MASK		(1 << 0)
+#define GSC_OUT_PATH_LOCAL		(1 << 0)
+#define GSC_OUT_PATH_MEMORY		(0 << 0)
+
+/* G-Scaler scaled destination image size */
+#define GSC_SCALED_SIZE			0x24
+#define GSC_SCALED_HEIGHT_MASK		(0x1fff << 16)
+#define GSC_SCALED_HEIGHT(x)		((x) << 16)
+#define GSC_SCALED_WIDTH_MASK		(0x1fff << 0)
+#define GSC_SCALED_WIDTH(x)		((x) << 0)
+
+/* G-Scaler pre scale ratio */
+#define GSC_PRE_SCALE_RATIO		0x28
+#define GSC_PRESC_SHFACTOR_MASK		(7 << 28)
+#define GSC_PRESC_SHFACTOR(x)		((x) << 28)
+#define GSC_PRESC_V_RATIO_MASK		(7 << 16)
+#define GSC_PRESC_V_RATIO(x)		((x) << 16)
+#define GSC_PRESC_H_RATIO_MASK		(7 << 0)
+#define GSC_PRESC_H_RATIO(x)		((x) << 0)
+
+/* G-Scaler main scale horizontal ratio */
+#define GSC_MAIN_H_RATIO		0x2C
+#define GSC_MAIN_H_RATIO_MASK		(0xfffff << 0)
+#define GSC_MAIN_H_RATIO_VALUE(x)	((x) << 0)
+
+/* G-Scaler main scale vertical ratio */
+#define GSC_MAIN_V_RATIO		0x30
+#define GSC_MAIN_V_RATIO_MASK		(0xfffff << 0)
+#define GSC_MAIN_V_RATIO_VALUE(x)	((x) << 0)
+
+/* G-Scaler destination image size */
+#define GSC_DSTIMG_SIZE			0x40
+#define GSC_DSTIMG_HEIGHT_MASK		(0x1fff << 16)
+#define GSC_DSTIMG_HEIGHT(x)		((x) << 16)
+#define GSC_DSTIMG_WIDTH_MASK		(0x1fff << 0)
+#define GSC_DSTIMG_WIDTH(x)		((x) << 0)
+
+/* G-Scaler destination image offset */
+#define GSC_DSTIMG_OFFSET		0x44
+#define GSC_DSTIMG_OFFSET_Y_MASK	(0x1fff << 16)
+#define GSC_DSTIMG_OFFSET_Y(x)		((x) << 16)
+#define GSC_DSTIMG_OFFSET_X_MASK	(0x1fff << 0)
+#define GSC_DSTIMG_OFFSET_X(x)		((x) << 0)
+
+/* G-Scaler input y address mask */
+#define GSC_IN_BASE_ADDR_Y_MASK		0x4C
+/* G-Scaler input y base address */
+#define GSC_IN_BASE_ADDR_Y(n)		(0x50 + (n) * 0x4)
+
+/* G-Scaler input cb address mask */
+#define GSC_IN_BASE_ADDR_CB_MASK	0x7C
+/* G-Scaler input cb base address */
+#define GSC_IN_BASE_ADDR_CB(n)		(0x80 + (n) * 0x4)
+
+/* G-Scaler input cr address mask */
+#define GSC_IN_BASE_ADDR_CR_MASK	0xAC
+/* G-Scaler input cr base address */
+#define GSC_IN_BASE_ADDR_CR(n)		(0xB0 + (n) * 0x4)
+
+/* G-Scaler input address mask */
+#define GSC_IN_CURR_ADDR_INDEX		(0xf << 12)
+#define GSC_IN_CURR_GET_INDEX(x)	((x) >> 12)
+#define GSC_IN_BASE_ADDR_PINGPONG(x)	((x) << 8)
+#define GSC_IN_BASE_ADDR_MASK		(0xff << 0)
+
+/* G-Scaler output y address mask */
+#define GSC_OUT_BASE_ADDR_Y_MASK	0x10C
+/* G-Scaler output y base address */
+#define GSC_OUT_BASE_ADDR_Y(n)		(0x110 + (n) * 0x4)
+
+/* G-Scaler output cb address mask */
+#define GSC_OUT_BASE_ADDR_CB_MASK	0x15C
+/* G-Scaler output cb base address */
+#define GSC_OUT_BASE_ADDR_CB(n)		(0x160 + (n) * 0x4)
+
+/* G-Scaler output cr address mask */
+#define GSC_OUT_BASE_ADDR_CR_MASK	0x1AC
+/* G-Scaler output cr base address */
+#define GSC_OUT_BASE_ADDR_CR(n)		(0x1B0 + (n) * 0x4)
+
+/* G-Scaler output address mask */
+#define GSC_OUT_CURR_ADDR_INDEX		(0xf << 24)
+#define GSC_OUT_CURR_GET_INDEX(x)	((x) >> 24)
+#define GSC_OUT_BASE_ADDR_PINGPONG(x)	((x) << 16)
+#define GSC_OUT_BASE_ADDR_MASK		(0xffff << 0)
+
+#endif /* REGS_GSC_H_ */
diff --git a/include/media/exynos_gscaler.h b/include/media/exynos_gscaler.h
new file mode 100644
index 0000000..e468fb5
--- /dev/null
+++ b/include/media/exynos_gscaler.h
@@ -0,0 +1,49 @@
+/* include/media/exynos_gscaler.h
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Samsung EXYNOS SoC Gscaler driver header
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef EXYNOS_GSCALER_H_
+#define EXYNOS_GSCALER_H_
+
+#include <media/exynos_camera.h>
+
+/**
+ * struct exynos_platform_gscaler - camera host interface platform data
+ *
+ * @isp_info: properties of camera sensor required for host interface setup
+ */
+struct exynos_platform_gscaler {
+	struct exynos_isp_info *isp_info[MAX_CAMIF_CLIENTS];
+	u32 active_cam_index;
+	u32 num_clients;
+	u32 cam_preview:1;
+	u32 cam_camcording:1;
+};
+
+extern struct exynos_platform_gscaler exynos_gsc0_default_data;
+extern struct exynos_platform_gscaler exynos_gsc1_default_data;
+extern struct exynos_platform_gscaler exynos_gsc2_default_data;
+extern struct exynos_platform_gscaler exynos_gsc3_default_data;
+
+/**
+ * exynos5_gsc_set_parent_clock() = Exynos5 setup function for parent clock.
+ * @child: child clock used for gscaler
+ * @parent: parent clock used for gscaler
+ */
+int __init exynos5_gsc_set_parent_clock(const char *child, const char *parent);
+
+/**
+ * exynos5_gsc_set_clock_rate() = Exynos5 setup function for clock rate.
+ * @clk: name of clock used for gscaler
+ * @clk_rate: clock_rate for gscaler clock
+ */
+int __init exynos5_gsc_set_clock_rate(const char *clk, unsigned long clk_rate);
+#endif /* EXYNOS_GSCALER_H_ */
-- 
1.7.1


