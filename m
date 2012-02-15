Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:29719 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab2BOGFi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Feb 2012 01:05:38 -0500
Received: from epcpsbgm2.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LZF0012L7KXA7A0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Feb 2012 15:05:35 +0900 (KST)
Received: from NOSUNGCHUNK01 ([12.23.119.73])
 by mmp2.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0LZF00G887LA2YK0@mmp2.samsung.com>
 for linux-media@vger.kernel.org; Wed, 15 Feb 2012 15:05:35 +0900 (KST)
Reply-to: sungchun.kang@samsung.com
From: Sungchun Kang <sungchun.kang@samsung.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com, jonghun.han@samsung.com,
	sy0816.kang@samsung.com, khw0178.kim@samsung.com
Subject: [PATCH] media: fimc-lite: Add new driver for camera interface
Date: Wed, 15 Feb 2012 15:05:34 +0900
Message-id: <005401cceba7$d4d75790$7e8606b0$%kang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support fimc-lite device which is a new device
for camera interface on EXYNOS5 SoCs.

This device supports the followings as key feature.
 1) Multiple input
  - ITU-R BT 601 mode
  - MIPI(CSI) mode
 2) Multiple output
  - DMA mode
  - Direct FIFO mode

Signed-off-by: Sungchun Kang <sungchun.kang@samsung.com>

NOTE : This patch is based on
"media: media-dev: Add media devices for EXYNOS5".
---
 drivers/media/video/Kconfig                        |    3 +-
 drivers/media/video/Makefile                       |    2 +-
 drivers/media/video/exynos/Kconfig                 |   20 +
 drivers/media/video/exynos/Makefile                |    4 +
 drivers/media/video/exynos/fimc-lite/Kconfig       |   22 +
 drivers/media/video/exynos/fimc-lite/Makefile      |    6 +
 .../media/video/exynos/fimc-lite/fimc-lite-core.c  | 1921 ++++++++++++++++++++
 .../media/video/exynos/fimc-lite/fimc-lite-core.h  |  310 ++++
 .../media/video/exynos/fimc-lite/fimc-lite-reg.c   |  332 ++++
 .../media/video/exynos/fimc-lite/fimc-lite-reg.h   |  135 ++
 include/media/exynos_camera.h                      |   59 +
 include/media/exynos_flite.h                       |   39 +
 12 files changed, 2851 insertions(+), 2 deletions(-)
 create mode 100644 drivers/media/video/exynos/Kconfig
 create mode 100644 drivers/media/video/exynos/Makefile
 create mode 100644 drivers/media/video/exynos/fimc-lite/Kconfig
 create mode 100644 drivers/media/video/exynos/fimc-lite/Makefile
 create mode 100644 drivers/media/video/exynos/fimc-lite/fimc-lite-core.c
 create mode 100644 drivers/media/video/exynos/fimc-lite/fimc-lite-core.h
 create mode 100644 drivers/media/video/exynos/fimc-lite/fimc-lite-reg.c
 create mode 100644 drivers/media/video/exynos/fimc-lite/fimc-lite-reg.h
 create mode 100644 include/media/exynos_camera.h
 create mode 100644 include/media/exynos_flite.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 9adada0..460d194 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -1124,8 +1124,9 @@ config VIDEO_S5P_MIPI_CSIS
 	  module will be called s5p-csis.
 
 source "drivers/media/video/s5p-tv/Kconfig"
-
 endif # V4L_PLATFORM_DRIVERS
+
+source "drivers/media/video/exynos/Kconfig"
 endif # VIDEO_CAPTURE_DRIVERS
 
 menuconfig V4L_MEM2MEM_DRIVERS
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 3541388..d7c6041 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -183,7 +183,7 @@ obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC)	+= s5p-mfc/
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_TV)	+= s5p-tv/
 
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_G2D)	+= s5p-g2d/
-
+obj-$(CONFIG_VIDEO_EXYNOS)		+= exynos/
 obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
 
 obj-$(CONFIG_VIDEO_SH_VOU)		+= sh_vou.o
diff --git a/drivers/media/video/exynos/Kconfig b/drivers/media/video/exynos/Kconfig
new file mode 100644
index 0000000..a84097d
--- /dev/null
+++ b/drivers/media/video/exynos/Kconfig
@@ -0,0 +1,20 @@
+#
+# Exynos multimedia device drivers
+#
+config VIDEO_EXYNOS
+	bool "Exynos Multimedia Devices"
+	depends on ARCH_EXYNOS5
+	default n
+	select VIDEO_FIXED_MINOR_RANGES
+	help
+	  This is a representative exynos multimedia device.
+
+if VIDEO_EXYNOS
+	source "drivers/media/video/exynos/mdev/Kconfig"
+	source "drivers/media/video/exynos/fimc-lite/Kconfig"
+endif
+
+config MEDIA_EXYNOS
+	bool
+	help
+	  Compile mdev to use exynos5 media device driver.
diff --git a/drivers/media/video/exynos/Makefile b/drivers/media/video/exynos/Makefile
new file mode 100644
index 0000000..56cb7b2
--- /dev/null
+++ b/drivers/media/video/exynos/Makefile
@@ -0,0 +1,4 @@
+obj-$(CONFIG_EXYNOS_MEDIA_DEVICE)	+= mdev/
+obj-$(CONFIG_VIDEO_EXYNOS_FIMC_LITE)	+= fimc-lite/
+
+EXTRA_CLAGS += -Idrivers/media/video
diff --git a/drivers/media/video/exynos/fimc-lite/Kconfig b/drivers/media/video/exynos/fimc-lite/Kconfig
new file mode 100644
index 0000000..90814e0
--- /dev/null
+++ b/drivers/media/video/exynos/fimc-lite/Kconfig
@@ -0,0 +1,22 @@
+#
+# Exynos fimc-lite device driver
+#
+config VIDEO_EXYNOS_FIMC_LITE
+	bool "Exynos Camera Interface(FIMC-Lite) driver"
+	depends on VIDEO_EXYNOS && (ARCH_EXYNOS4 || ARCH_EXYNOS5)
+	select MEDIA_EXYNOS
+	select VIDEOBUF2_DMA_CONTIG
+	default n
+	help
+	  This is a v4l2 driver for exynos camera interface device.
+
+if VIDEO_EXYNOS_FIMC_LITE && VIDEOBUF2_CMA_PHYS
+comment "Reserved memory configurations"
+config VIDEO_SAMSUNG_MEMSIZE_FLITE0
+	int "Memory size in kbytes for FLITE0"
+	default "10240"
+
+config VIDEO_SAMSUNG_MEMSIZE_FLITE1
+	int "Memory size in kbytes for FLITE1"
+	default "10240"
+endif
diff --git a/drivers/media/video/exynos/fimc-lite/Makefile b/drivers/media/video/exynos/fimc-lite/Makefile
new file mode 100644
index 0000000..431d199
--- /dev/null
+++ b/drivers/media/video/exynos/fimc-lite/Makefile
@@ -0,0 +1,6 @@
+ifeq ($(CONFIG_ARCH_EXYNOS5),y)
+fimc-lite-objs := fimc-lite-core.o fimc-lite-reg.o
+else
+fimc-lite-objs := fimc-lite-core.o fimc-lite-reg.o
+endif
+obj-$(CONFIG_VIDEO_EXYNOS_FIMC_LITE)	+= fimc-lite.o
diff --git a/drivers/media/video/exynos/fimc-lite/fimc-lite-core.c b/drivers/media/video/exynos/fimc-lite/fimc-lite-core.c
new file mode 100644
index 0000000..9bb1c88
--- /dev/null
+++ b/drivers/media/video/exynos/fimc-lite/fimc-lite-core.c
@@ -0,0 +1,1921 @@
+/*
+ * Register interface file for Samsung Camera Interface (FIMC-Lite) driver
+ *
+ * Copyright (c) 2011 Samsung Electronics
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <media/exynos_mc.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "fimc-lite-core.h"
+
+#define MODULE_NAME			"exynos-fimc-lite"
+#define DEFAULT_FLITE_SINK_WIDTH	800
+#define DEFAULT_FLITE_SINK_HEIGHT	480
+
+static struct flite_fmt flite_formats[] = {
+	{
+		.name		= "YUV422 8-bit 1 plane(UYVY)",
+		.pixelformat	= V4L2_PIX_FMT_UYVY,
+		.depth		= { 16 },
+		.code		= V4L2_MBUS_FMT_UYVY8_2X8,
+		.fmt_reg	= FLITE_REG_CIGCTRL_YUV422_1P,
+		.is_yuv		= 1,
+	}, {
+		.name		= "YUV422 8-bit 1 plane(VYUY)",
+		.pixelformat	= V4L2_PIX_FMT_VYUY,
+		.depth		= { 16 },
+		.code		= V4L2_MBUS_FMT_VYUY8_2X8,
+		.fmt_reg	= FLITE_REG_CIGCTRL_YUV422_1P,
+		.is_yuv		= 1,
+	}, {
+		.name		= "YUV422 8-bit 1 plane(YUYV)",
+		.pixelformat	= V4L2_PIX_FMT_YUYV,
+		.depth		= { 16 },
+		.code		= V4L2_MBUS_FMT_YUYV8_2X8,
+		.fmt_reg	= FLITE_REG_CIGCTRL_YUV422_1P,
+		.is_yuv		= 1,
+	}, {
+		.name		= "YUV422 8-bit 1 plane(YVYU)",
+		.pixelformat	= V4L2_PIX_FMT_YVYU,
+		.depth		= { 16 },
+		.code		= V4L2_MBUS_FMT_YVYU8_2X8,
+		.fmt_reg	= FLITE_REG_CIGCTRL_YUV422_1P,
+		.is_yuv		= 1,
+	}, {
+		.name		= "RAW8(GRBG)",
+		.pixelformat	= V4L2_PIX_FMT_SGRBG8,
+		.depth		= { 8 },
+		.code		= V4L2_MBUS_FMT_SGRBG8_1X8,
+		.fmt_reg	= FLITE_REG_CIGCTRL_RAW8,
+		.is_yuv		= 0,
+	}, {
+		.name		= "RAW10(GRBG)",
+		.pixelformat	= V4L2_PIX_FMT_SGRBG10,
+		.depth		= { 10 },
+		.code		= V4L2_MBUS_FMT_SGRBG10_1X10,
+		.fmt_reg	= FLITE_REG_CIGCTRL_RAW10,
+		.is_yuv		= 0,
+	}, {
+		.name		= "RAW12(GRBG)",
+		.pixelformat	= V4L2_PIX_FMT_SGRBG12,
+		.depth		= { 12 },
+		.code		= V4L2_MBUS_FMT_SGRBG12_1X12,
+		.fmt_reg	= FLITE_REG_CIGCTRL_RAW12,
+		.is_yuv		= 0,
+	}, {
+		.name		= "User Defined(JPEG)",
+		.code		= V4L2_MBUS_FMT_JPEG_1X8,
+		.depth		= { 8 },
+		.fmt_reg	= FLITE_REG_CIGCTRL_USER(1),
+		.is_yuv		= 0,
+	},
+};
+
+static struct flite_variant variant = {
+	.max_w			= 8192,
+	.max_h			= 8192,
+	.align_win_offs_w	= 2,
+	.align_out_w		= 8,
+	.align_out_offs_w	= 8,
+};
+
+static struct flite_fmt *get_format(int index)
+{
+	return &flite_formats[index];
+}
+
+struct flite_fmt *find_format(u32 *pixelformat, u32 *mbus_code,	int index)
+{
+	struct flite_fmt *fmt, *def_fmt = NULL;
+	unsigned int i;
+
+	if (index >= ARRAY_SIZE(flite_formats))
+		return NULL;
+
+	for (i = 0; i < ARRAY_SIZE(flite_formats); ++i) {
+		fmt = get_format(i);
+		if (pixelformat && fmt->pixelformat == *pixelformat)
+			return fmt;
+		if (mbus_code && fmt->code == *mbus_code)
+			return fmt;
+		if (index == i)
+			def_fmt = fmt;
+	}
+	return def_fmt;
+
+}
+
+static int flite_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct flite_dev *flite = v4l2_get_subdevdata(sd);
+	u32 index = flite->pdata->active_cam_index;
+	struct s3c_platform_camera *cam = NULL;
+	u32 int_src = 0;
+	unsigned long flags;
+	int ret = 0;
+
+	if (!(flite->output & FLITE_OUTPUT_MEM)) {
+		if (enable)
+			flite_hw_reset(flite);
+		cam = flite->pdata->cam[index];
+	}
+
+	spin_lock_irqsave(&flite->slock, flags);
+
+	if (test_bit(FLITE_ST_SUSPEND, &flite->state))
+		goto s_stream_unlock;
+
+	if (enable) {
+		flite_hw_set_cam_channel(flite);
+		flite_hw_set_cam_source_size(flite);
+
+		if (!(flite->output & FLITE_OUTPUT_MEM)) {
+			flite_info("@local out start@");
+			flite_hw_set_camera_type(flite, cam);
+			flite_hw_set_config_irq(flite, cam);
+			if (cam->use_isp)
+				flite_hw_set_output_dma(flite, false);
+			int_src = FLITE_REG_CIGCTRL_IRQ_OVFEN0_ENABLE |
+				FLITE_REG_CIGCTRL_IRQ_LASTEN0_ENABLE |
+				FLITE_REG_CIGCTRL_IRQ_ENDEN0_DISABLE |
+				FLITE_REG_CIGCTRL_IRQ_STARTEN0_DISABLE;
+		} else {
+			flite_info("@mem out start@");
+			flite_hw_set_sensor_type(flite);
+			flite_hw_set_inverse_polarity(flite);
+			set_bit(FLITE_ST_PEND, &flite->state);
+			flite_hw_set_output_dma(flite, true);
+			int_src = FLITE_REG_CIGCTRL_IRQ_OVFEN0_ENABLE |
+				FLITE_REG_CIGCTRL_IRQ_LASTEN0_ENABLE |
+				FLITE_REG_CIGCTRL_IRQ_ENDEN0_ENABLE |
+				FLITE_REG_CIGCTRL_IRQ_STARTEN0_DISABLE;
+			flite_hw_set_out_order(flite);
+			flite_hw_set_output_size(flite);
+			flite_hw_set_dma_offset(flite);
+		}
+		ret = flite_hw_set_source_format(flite);
+		if (unlikely(ret < 0))
+			goto s_stream_unlock;
+
+		flite_hw_set_interrupt_source(flite, int_src);
+		flite_hw_set_window_offset(flite);
+		flite_hw_set_capture_start(flite);
+
+		set_bit(FLITE_ST_STREAM, &flite->state);
+	} else {
+		if (test_bit(FLITE_ST_STREAM, &flite->state)) {
+			flite_hw_set_capture_stop(flite);
+			spin_unlock_irqrestore(&flite->slock, flags);
+			ret = wait_event_timeout(flite->irq_queue,
+			!test_bit(FLITE_ST_STREAM, &flite->state), HZ/20);
+			if (unlikely(!ret)) {
+				v4l2_err(sd, "wait timeout\n");
+				ret = -EBUSY;
+			}
+			return ret;
+		} else {
+			goto s_stream_unlock;
+		}
+	}
+s_stream_unlock:
+	spin_unlock_irqrestore(&flite->slock, flags);
+	return ret;
+}
+
+static irqreturn_t flite_irq_handler(int irq, void *priv)
+{
+	struct flite_dev *flite = priv;
+	struct flite_buffer *buf;
+	u32 int_src = 0;
+
+	flite_hw_get_int_src(flite, &int_src);
+	flite_hw_clear_irq(flite);
+
+	spin_lock(&flite->slock);
+
+	switch (int_src & FLITE_REG_CISTATUS_IRQ_MASK) {
+	case FLITE_REG_CISTATUS_IRQ_SRC_OVERFLOW:
+		clear_bit(FLITE_ST_RUN, &flite->state);
+		flite_err("overflow generated");
+		break;
+	case FLITE_REG_CISTATUS_IRQ_SRC_LASTCAPEND:
+		flite_hw_set_last_capture_end_clear(flite);
+		flite_info("last capture end");
+		clear_bit(FLITE_ST_STREAM, &flite->state);
+		wake_up(&flite->irq_queue);
+		break;
+	case FLITE_REG_CISTATUS_IRQ_SRC_FRMSTART:
+		flite_dbg("frame start");
+		break;
+	case FLITE_REG_CISTATUS_IRQ_SRC_FRMEND:
+		set_bit(FLITE_ST_RUN, &flite->state);
+		flite_dbg("frame end");
+		break;
+	}
+
+	if (flite->output & FLITE_OUTPUT_MEM) {
+		if (!list_empty(&flite->active_buf_q)) {
+			buf = active_queue_pop(flite);
+			if (!test_bit(FLITE_ST_RUN, &flite->state)) {
+				vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+				goto unlock;
+			}
+			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+			flite_dbg("done_index : %d", buf->vb.v4l2_buf.index);
+		}
+		if (!list_empty(&flite->pending_buf_q)) {
+			buf = pending_queue_pop(flite);
+			flite_hw_set_output_addr(flite, &buf->paddr,
+					buf->vb.v4l2_buf.index);
+			active_queue_add(flite, buf);
+		}
+		if (flite->active_buf_cnt == 0)
+			clear_bit(FLITE_ST_RUN, &flite->state);
+	}
+unlock:
+	spin_unlock(&flite->slock);
+
+	return IRQ_HANDLED;
+}
+
+static int flite_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct flite_dev *flite = v4l2_get_subdevdata(sd);
+	int ret = 0;
+
+	if (on) {
+		pm_runtime_get_sync(&flite->pdev->dev);
+		set_bit(FLITE_ST_POWER, &flite->state);
+	} else {
+		pm_runtime_put_sync(&flite->pdev->dev);
+		clear_bit(FLITE_ST_POWER, &flite->state);
+	}
+
+	return ret;
+}
+
+static int flite_subdev_enum_mbus_code(struct v4l2_subdev *sd,
+				       struct v4l2_subdev_fh *fh,
+				       struct v4l2_subdev_mbus_code_enum *code)
+{
+	if (code->index >= ARRAY_SIZE(flite_formats))
+		return -EINVAL;
+
+	code->code = flite_formats[code->index].code;
+
+	return 0;
+}
+
+static struct v4l2_mbus_framefmt *__flite_get_format(
+		struct flite_dev *flite, struct v4l2_subdev_fh *fh,
+		u32 pad, enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return fh ? v4l2_subdev_get_try_format(fh, pad) : NULL;
+	else
+		return &flite->mbus_fmt;
+}
+
+static void flite_try_format(struct flite_dev *flite, struct v4l2_subdev_fh *fh,
+			     struct v4l2_mbus_framefmt *fmt,
+			     enum v4l2_subdev_format_whence which)
+{
+	struct flite_fmt *ffmt;
+	struct flite_frame *f = &flite->s_frame;
+	ffmt = find_format(NULL, &fmt->code, 0);
+	if (ffmt == NULL)
+		ffmt = &flite_formats[1];
+
+	fmt->code = ffmt->code;
+	fmt->width = clamp_t(u32, fmt->width, 1, variant.max_w);
+	fmt->height = clamp_t(u32, fmt->height, 1, variant.max_h);
+
+	f->offs_h = f->offs_v = 0;
+	f->width = f->o_width = fmt->width;
+	f->height = f->o_height = fmt->height;
+
+	fmt->colorspace = V4L2_COLORSPACE_JPEG;
+	fmt->field = V4L2_FIELD_NONE;
+}
+
+static int flite_subdev_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_format *fmt)
+{
+	struct flite_dev *flite = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *mf;
+
+	mf = __flite_get_format(flite, fh, fmt->pad, fmt->which);
+	if (mf == NULL) {
+		flite_err("__flite_get_format is null");
+		return -EINVAL;
+	}
+
+	fmt->format = *mf;
+
+	if (fmt->pad != FLITE_PAD_SINK) {
+		struct flite_frame *f = &flite->s_frame;
+		fmt->format.width = f->width;
+		fmt->format.height = f->height;
+	}
+
+	return 0;
+}
+
+static int flite_subdev_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_format *fmt)
+{
+	struct flite_dev *flite = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *mf;
+
+	if (fmt->pad != FLITE_PAD_SINK)
+		return -EPERM;
+
+	mf = __flite_get_format(flite, fh, fmt->pad, fmt->which);
+	if (mf == NULL) {
+		flite_err("__flite_get_format is null");
+		return -EINVAL;
+	}
+
+	flite_try_format(flite, fh, &fmt->format, fmt->which);
+	*mf = fmt->format;
+
+	return 0;
+}
+
+static void flite_try_crop(struct flite_dev *flite, struct v4l2_subdev_crop *crop)
+{
+	struct flite_frame *f_frame = flite_get_frame(flite, crop->pad);
+
+	u32 max_left = f_frame->o_width - crop->rect.width;
+	u32 max_top = f_frame->o_height - crop->rect.height;
+	u32 crop_max_w = f_frame->o_width - crop->rect.left;
+	u32 crop_max_h = f_frame->o_height - crop->rect.top;
+
+	crop->rect.left = clamp_t(u32, crop->rect.left, 0, max_left);
+	crop->rect.top = clamp_t(u32, crop->rect.top, 0, max_top);
+	crop->rect.width = clamp_t(u32, crop->rect.width, 2, crop_max_w);
+	crop->rect.height = clamp_t(u32, crop->rect.height, 1, crop_max_h);
+}
+
+static int __flite_get_crop(struct flite_dev *flite, struct v4l2_subdev_fh *fh,
+			    unsigned int pad, enum v4l2_subdev_format_whence which,
+			    struct v4l2_rect *crop)
+{
+	struct flite_frame *frame = &flite->s_frame;
+
+	if (which == V4L2_SUBDEV_FORMAT_TRY) {
+		crop = v4l2_subdev_get_try_crop(fh, pad);
+	} else {
+		crop->left = frame->offs_h;
+		crop->top = frame->offs_v;
+		crop->width = frame->width;
+		crop->height = frame->height;
+	}
+
+	return 0;
+}
+
+static int flite_subdev_get_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_crop *crop)
+{
+	struct flite_dev *flite = v4l2_get_subdevdata(sd);
+	struct v4l2_rect fcrop;
+
+	fcrop.left = fcrop.top = fcrop.width = fcrop.height = 0;
+
+	if (crop->pad != FLITE_PAD_SINK) {
+		flite_err("crop is supported only sink pad");
+		return -EINVAL;
+	}
+
+	__flite_get_crop(flite, fh, crop->pad, crop->which, &fcrop);
+	crop->rect = fcrop;
+
+	return 0;
+}
+
+static int flite_subdev_set_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_crop *crop)
+{
+	struct flite_dev *flite = v4l2_get_subdevdata(sd);
+	struct flite_frame *f_frame = flite_get_frame(flite, crop->pad);
+
+	if (!(flite->output & FLITE_OUTPUT_MEM) && (crop->pad != FLITE_PAD_SINK)) {
+		flite_err("crop is supported only sink pad");
+		return -EINVAL;
+	}
+
+	flite_try_crop(flite, crop);
+
+	if (crop->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		f_frame->offs_h = crop->rect.left;
+		f_frame->offs_v = crop->rect.top;
+		f_frame->width = crop->rect.width;
+		f_frame->height = crop->rect.height;
+	}
+
+	return 0;
+}
+
+static int flite_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_subdev_format format;
+	struct flite_dev *flite = v4l2_get_subdevdata(sd);
+
+	if (!test_bit(FLITE_ST_SUBDEV_OPEN, &flite->state)) {
+		flite->s_frame.fmt = get_format(2);
+		memset(&format, 0, sizeof(format));
+		format.pad = FLITE_PAD_SINK;
+		format.which = fh ?
+			V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
+		format.format.code = flite->s_frame.fmt->code;
+		format.format.width = DEFAULT_FLITE_SINK_WIDTH;
+		format.format.height = DEFAULT_FLITE_SINK_HEIGHT;
+
+		flite_subdev_set_fmt(sd, fh, &format);
+
+		flite->d_frame.fmt = get_format(2);
+		set_bit(FLITE_ST_SUBDEV_OPEN, &flite->state);
+	}
+
+	return 0;
+}
+
+static int flite_subdev_close(struct v4l2_subdev *sd,
+			      struct v4l2_subdev_fh *fh)
+{
+	struct flite_dev *flite = v4l2_get_subdevdata(sd);
+
+	flite_info("");
+	clear_bit(FLITE_ST_SUBDEV_OPEN, &flite->state);
+	return 0;
+}
+
+static int flite_subdev_registered(struct v4l2_subdev *sd)
+{
+	flite_dbg("");
+	return 0;
+}
+
+static void flite_subdev_unregistered(struct v4l2_subdev *sd)
+{
+	flite_dbg("");
+}
+
+static const struct v4l2_subdev_internal_ops flite_v4l2_internal_ops = {
+	.open = flite_init_formats,
+	.close = flite_subdev_close,
+	.registered = flite_subdev_registered,
+	.unregistered = flite_subdev_unregistered,
+};
+
+static int flite_link_setup(struct media_entity *entity,
+			    const struct media_pad *local,
+			    const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct flite_dev *flite = v4l2_get_subdevdata(sd);
+
+	flite_info("");
+	switch (local->index | media_entity_type(remote->entity)) {
+	case FLITE_PAD_SINK | MEDIA_ENT_T_V4L2_SUBDEV:
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (flite->input != FLITE_INPUT_NONE) {
+				flite_err("link is busy");
+				return -EBUSY;
+			}
+			if (remote->index == CSIS_PAD_SOURCE)
+				flite->input = FLITE_INPUT_CSIS;
+			else
+				flite->input = FLITE_INPUT_SENSOR;
+		} else {
+			flite->input = FLITE_INPUT_NONE;
+		}
+		break;
+
+	case FLITE_PAD_SOURCE_PREV | MEDIA_ENT_T_V4L2_SUBDEV: /* fall through */
+	case FLITE_PAD_SOURCE_CAMCORD | MEDIA_ENT_T_V4L2_SUBDEV:
+		if (flags & MEDIA_LNK_FL_ENABLED)
+			flite->output |= FLITE_OUTPUT_GSC;
+		else
+			flite->output &= ~FLITE_OUTPUT_GSC;
+		break;
+	case FLITE_PAD_SOURCE_MEM | MEDIA_ENT_T_DEVNODE:
+		if (flags & MEDIA_LNK_FL_ENABLED)
+			flite->output |= FLITE_OUTPUT_MEM;
+		else
+			flite->output &= ~FLITE_OUTPUT_MEM;
+		break;
+	default:
+		flite_err("ERR link");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct media_entity_operations flite_media_ops = {
+	.link_setup = flite_link_setup,
+};
+
+static struct v4l2_subdev_pad_ops flite_pad_ops = {
+	.enum_mbus_code = flite_subdev_enum_mbus_code,
+	.get_fmt	= flite_subdev_get_fmt,
+	.set_fmt	= flite_subdev_set_fmt,
+	.get_crop	= flite_subdev_get_crop,
+	.set_crop	= flite_subdev_set_crop,
+};
+
+static void flite_pipeline_prepare(struct flite_dev *flite, struct media_entity *me)
+{
+	struct media_entity_graph graph;
+	struct v4l2_subdev *sd;
+
+	media_entity_graph_walk_start(&graph, me);
+
+	while ((me = media_entity_graph_walk_next(&graph))) {
+		if (media_entity_type(me) != MEDIA_ENT_T_V4L2_SUBDEV)
+			continue;
+
+		sd = media_entity_to_v4l2_subdev(me);
+		switch (sd->grp_id) {
+		case FLITE_GRP_ID:
+			flite->pipeline.flite = sd;
+			break;
+		case SENSOR_GRP_ID:
+			flite->pipeline.sensor = sd;
+			break;
+		case CSIS_GRP_ID:
+			flite->pipeline.csis = sd;
+			break;
+		default:
+			flite_warn("Another link's group id");
+			break;
+		}
+	}
+
+	flite_info("flite->pipeline.flite : 0x%p", flite->pipeline.flite);
+	flite_info("flite->pipeline.sensor : 0x%p", flite->pipeline.sensor);
+	flite_info("flite->pipeline.csis : 0x%p", flite->pipeline.csis);
+}
+
+static void flite_set_cam_clock(struct flite_dev *flite, bool on)
+{
+	struct v4l2_subdev *sd = flite->pipeline.sensor;
+
+	clk_enable(flite->gsc_clk);
+	if (flite->pipeline.sensor) {
+		struct flite_sensor_info *s_info = v4l2_get_subdev_hostdata(sd);
+		on ? clk_enable(s_info->camclk) : clk_disable(s_info->camclk);
+	}
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
+static int flite_pipeline_s_power(struct flite_dev *flite, int state)
+{
+	int ret = 0;
+
+	if (!flite->pipeline.sensor)
+		return -ENXIO;
+
+	if (state) {
+		ret = __subdev_set_power(flite->pipeline.flite, 1);
+		if (ret && ret != -ENXIO)
+			return ret;
+		ret = __subdev_set_power(flite->pipeline.csis, 1);
+		if (ret && ret != -ENXIO)
+			return ret;
+		ret = __subdev_set_power(flite->pipeline.sensor, 1);
+	} else {
+		ret = __subdev_set_power(flite->pipeline.flite, 0);
+		if (ret && ret != -ENXIO)
+			return ret;
+		ret = __subdev_set_power(flite->pipeline.sensor, 0);
+		if (ret && ret != -ENXIO)
+			return ret;
+		ret = __subdev_set_power(flite->pipeline.csis, 0);
+	}
+
+	return ret == -ENXIO ? 0 : ret;
+}
+
+static int __flite_pipeline_initialize(struct flite_dev *flite,
+					 struct media_entity *me, bool prep)
+{
+	int ret = 0;
+
+	if (prep)
+		flite_pipeline_prepare(flite, me);
+
+	if (!flite->pipeline.sensor)
+		return -EINVAL;
+
+	flite_set_cam_clock(flite, true);
+
+	if (flite->pipeline.sensor)
+		ret = flite_pipeline_s_power(flite, 1);
+
+	return ret;
+}
+
+static int flite_pipeline_initialize(struct flite_dev *flite,
+				struct media_entity *me, bool prep)
+{
+	int ret;
+
+	mutex_lock(&me->parent->graph_mutex);
+	ret =  __flite_pipeline_initialize(flite, me, prep);
+	mutex_unlock(&me->parent->graph_mutex);
+
+	return ret;
+}
+
+static int flite_open(struct file *file)
+{
+	struct flite_dev *flite = video_drvdata(file);
+	int ret = v4l2_fh_open(file);
+
+	if (ret)
+		return ret;
+
+	if (test_bit(FLITE_ST_OPEN, &flite->state)) {
+		v4l2_fh_release(file);
+		return -EBUSY;
+	}
+
+	set_bit(FLITE_ST_OPEN, &flite->state);
+
+	if (++flite->refcnt == 1) {
+		ret = flite_pipeline_initialize(flite, &flite->vfd->entity, true);
+		if (ret < 0) {
+			flite_err("flite pipeline initialization failed\n");
+			goto err;
+		}
+	}
+
+	flite_info("pid: %d, state: 0x%lx", task_pid_nr(current), flite->state);
+
+	return 0;
+
+err:
+	v4l2_fh_release(file);
+	clear_bit(FLITE_ST_OPEN, &flite->state);
+	return ret;
+}
+
+int __flite_pipeline_shutdown(struct flite_dev *flite)
+{
+	int ret = 0;
+
+	if (flite->pipeline.sensor)
+		ret = flite_pipeline_s_power(flite, 0);
+
+	if (ret && ret != -ENXIO)
+		flite_set_cam_clock(flite, false);
+
+	return ret == -ENXIO ? 0 : ret;
+}
+
+int flite_pipeline_shutdown(struct flite_dev *flite)
+{
+	struct media_entity *me = &flite->vfd->entity;
+	int ret;
+
+	mutex_lock(&me->parent->graph_mutex);
+	ret = __flite_pipeline_shutdown(flite);
+	mutex_unlock(&me->parent->graph_mutex);
+
+	return ret;
+}
+
+static int flite_close(struct file *file)
+{
+	struct flite_dev *flite = video_drvdata(file);
+	struct flite_buffer *buf;
+
+	flite_info("pid: %d, state: 0x%lx", task_pid_nr(current), flite->state);
+
+	if (--flite->refcnt == 0) {
+		clear_bit(FLITE_ST_OPEN, &flite->state);
+		flite_info("FIMC-LITE h/w disable control");
+		flite_hw_set_capture_stop(flite);
+		clear_bit(FLITE_ST_STREAM, &flite->state);
+		flite_pipeline_shutdown(flite);
+		clear_bit(FLITE_ST_SUSPEND, &flite->state);
+	}
+
+	if (flite->refcnt == 0) {
+		while (!list_empty(&flite->pending_buf_q)) {
+			flite_info("clean pending q");
+			buf = pending_queue_pop(flite);
+			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		}
+
+		while (!list_empty(&flite->active_buf_q)) {
+			flite_info("clean active q");
+			buf = active_queue_pop(flite);
+			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		}
+		vb2_queue_release(&flite->vbq);
+	}
+
+	return v4l2_fh_release(file);
+}
+
+static unsigned int flite_poll(struct file *file,
+				      struct poll_table_struct *wait)
+{
+	struct flite_dev *flite = video_drvdata(file);
+
+	return vb2_poll(&flite->vbq, file, wait);
+}
+
+static int flite_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct flite_dev *flite = video_drvdata(file);
+
+	return vb2_mmap(&flite->vbq, vma);
+}
+
+/*
+ * videobuf2 operations
+ */
+
+int flite_pipeline_s_stream(struct flite_dev *flite, int on)
+{
+	struct flite_pipeline *p = &flite->pipeline;
+	int ret = 0;
+
+	if (!p->sensor)
+		return -ENODEV;
+
+	if (on) {
+		ret = v4l2_subdev_call(p->flite, video, s_stream, 1);
+		if (ret < 0 && ret != -ENOIOCTLCMD)
+			return ret;
+		ret = v4l2_subdev_call(p->csis, video, s_stream, 1);
+		if (ret < 0 && ret != -ENOIOCTLCMD)
+			return ret;
+		ret = v4l2_subdev_call(p->sensor, video, s_stream, 1);
+	} else {
+		ret = v4l2_subdev_call(p->sensor, video, s_stream, 0);
+		if (ret < 0 && ret != -ENOIOCTLCMD)
+			return ret;
+		ret = v4l2_subdev_call(p->csis, video, s_stream, 0);
+		if (ret < 0 && ret != -ENOIOCTLCMD)
+			return ret;
+		ret = v4l2_subdev_call(p->flite, video, s_stream, 0);
+	}
+
+	return ret == -ENOIOCTLCMD ? 0 : ret;
+}
+
+static int flite_start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	struct flite_dev *flite = q->drv_priv;
+
+	flite_hw_reset(flite);
+	flite->active_buf_cnt = 0;
+	flite->pending_buf_cnt = 0;
+
+	return 0;
+}
+
+static int flite_state_cleanup(struct flite_dev *flite)
+{
+	unsigned long flags;
+	bool streaming;
+
+	spin_lock_irqsave(&flite->slock, flags);
+	streaming = flite->state & (1 << FLITE_ST_PIPE_STREAM);
+
+	flite->state &= ~(1 << FLITE_ST_RUN | 1 << FLITE_ST_STREAM |
+			1 << FLITE_ST_PIPE_STREAM | 1 << FLITE_ST_PEND);
+
+	set_bit(FLITE_ST_SUSPEND, &flite->state);
+	spin_unlock_irqrestore(&flite->slock, flags);
+
+	if (streaming)
+		return flite_pipeline_s_stream(flite, 0);
+	else
+		return 0;
+}
+
+static int flite_stop_capture(struct flite_dev *flite)
+{
+	if (!flite_active(flite)) {
+		flite_warn("already stopped\n");
+		return 0;
+	}
+	flite_info("FIMC-Lite H/W disable control");
+	flite_hw_set_capture_stop(flite);
+	clear_bit(FLITE_ST_STREAM, &flite->state);
+
+	return flite_state_cleanup(flite);
+}
+
+static int flite_stop_streaming(struct vb2_queue *q)
+{
+	struct flite_dev *flite = q->drv_priv;
+
+	if (!flite_active(flite))
+		return -EINVAL;
+
+	return flite_stop_capture(flite);
+}
+
+static u32 get_plane_size(struct flite_frame *frame, unsigned int plane)
+{
+	if (!frame) {
+		flite_err("frame is null");
+		return 0;
+	}
+
+	return frame->payload;
+}
+
+static int flite_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+			unsigned int *num_buffers, unsigned int *num_planes,
+			unsigned int sizes[], void *allocators[])
+{
+	struct flite_dev *flite = vq->drv_priv;
+	struct flite_fmt *ffmt = flite->d_frame.fmt;
+
+	if (!ffmt)
+		return -EINVAL;
+
+	*num_planes = 1;
+
+	sizes[0] = get_plane_size(&flite->d_frame, 0);
+	allocators[0] = flite->alloc_ctx;
+
+	return 0;
+}
+
+static int flite_buf_prepare(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct flite_dev *flite = vq->drv_priv;
+	struct flite_frame *frame = &flite->d_frame;
+	unsigned long size;
+
+	if (frame->fmt == NULL)
+		return -EINVAL;
+
+	size = frame->payload;
+
+	if (vb2_plane_size(vb, 0) < size) {
+		v4l2_err(flite->vfd, "User buffer too small (%ld < %ld)\n",
+			 vb2_plane_size(vb, 0), size);
+		return -EINVAL;
+	}
+	vb2_set_plane_payload(vb, 0, size);
+
+	return 0;
+}
+
+/* The color format (nr_comp, num_planes) must be already configured. */
+int flite_prepare_addr(struct flite_dev *flite, struct vb2_buffer *vb,
+		     struct flite_frame *frame, struct flite_addr *addr)
+{
+	if (IS_ERR(vb) || IS_ERR(frame)) {
+		flite_err("Invalid argument");
+		return -EINVAL;
+	}
+
+	addr->y = vb2_dma_contig_plane_dma_addr(vb, 0);
+
+	flite_info("ADDR: y= 0x%X", addr->y);
+
+	return 0;
+}
+
+
+static void flite_buf_queue(struct vb2_buffer *vb)
+{
+	struct flite_buffer *buf = container_of(vb, struct flite_buffer, vb);
+	struct flite_dev *flite = vb2_get_drv_priv(vb->vb2_queue);
+	int min_bufs;
+	unsigned long flags;
+
+	spin_lock_irqsave(&flite->slock, flags);
+	flite_prepare_addr(flite, &buf->vb, &flite->d_frame, &buf->paddr);
+
+	min_bufs = flite->reqbufs_cnt > 1 ? 2 : 1;
+
+	if (flite->active_buf_cnt < FLITE_MAX_OUT_BUFS) {
+		active_queue_add(flite, buf);
+		flite_hw_set_output_addr(flite, &buf->paddr, vb->v4l2_buf.index);
+	} else {
+		pending_queue_add(flite, buf);
+	}
+
+	if (vb2_is_streaming(&flite->vbq) &&
+		(flite->pending_buf_cnt >= min_bufs) &&
+		!test_bit(FLITE_ST_STREAM, &flite->state)) {
+		if (!test_and_set_bit(FLITE_ST_PIPE_STREAM, &flite->state)) {
+			spin_unlock_irqrestore(&flite->slock, flags);
+			flite_pipeline_s_stream(flite, 1);
+			return;
+		}
+
+		if (!test_bit(FLITE_ST_STREAM, &flite->state)) {
+			flite_info("G-Scaler h/w enable control");
+			flite_hw_set_capture_start(flite);
+			set_bit(FLITE_ST_STREAM, &flite->state);
+		}
+	}
+	spin_unlock_irqrestore(&flite->slock, flags);
+
+	return;
+}
+
+static struct vb2_ops flite_qops = {
+	.queue_setup		= flite_queue_setup,
+	.buf_prepare		= flite_buf_prepare,
+	.buf_queue		= flite_buf_queue,
+	.wait_prepare		= flite_unlock,
+	.wait_finish		= flite_lock,
+	.start_streaming	= flite_start_streaming,
+	.stop_streaming		= flite_stop_streaming,
+};
+
+/*
+ * The video node ioctl operations
+ */
+static int flite_vidioc_querycap(struct file *file, void *priv,
+				       struct v4l2_capability *cap)
+{
+	struct flite_dev *flite = video_drvdata(file);
+
+	strncpy(cap->driver, flite->pdev->name, sizeof(cap->driver) - 1);
+	strncpy(cap->card, flite->pdev->name, sizeof(cap->card) - 1);
+	cap->bus_info[0] = 0;
+	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE_MPLANE;
+
+	return 0;
+}
+
+static int flite_enum_fmt_mplane(struct file *file, void *priv,
+					struct v4l2_fmtdesc *f)
+{
+	struct flite_fmt *fmt;
+
+	fmt = find_format(NULL, NULL, f->index);
+	if (!fmt)
+		return -EINVAL;
+
+	strncpy(f->description, fmt->name, sizeof(f->description) - 1);
+	f->pixelformat = fmt->pixelformat;
+
+	return 0;
+}
+
+static int flite_try_fmt_mplane(struct file *file, void *fh, struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
+	struct flite_fmt *fmt;
+	u32 max_w, max_h, mod_x, mod_y;
+	u32 min_w, min_h, tmp_w, tmp_h;
+	int i;
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		return -EINVAL;
+
+	flite_dbg("user put w: %d, h: %d", pix_mp->width, pix_mp->height);
+
+	fmt = find_format(&pix_mp->pixelformat, NULL, 0);
+	if (!fmt) {
+		flite_err("pixelformat format (0x%X) invalid\n", pix_mp->pixelformat);
+		return -EINVAL;
+	}
+
+	max_w = variant.max_w;
+	max_h = variant.max_h;
+	min_w = min_h = mod_y = 0;
+
+	if (fmt->is_yuv)
+		mod_x = ffs(variant.align_out_w / 2) - 1;
+	else
+		mod_x = ffs(variant.align_out_w) - 1;
+
+	flite_dbg("mod_x: %d, mod_y: %d, max_w: %d, max_h = %d",
+	     mod_x, mod_y, max_w, max_h);
+	/* To check if image size is modified to adjust parameter against
+	   hardware abilities */
+	tmp_w = pix_mp->width;
+	tmp_h = pix_mp->height;
+
+	v4l_bound_align_image(&pix_mp->width, min_w, max_w, mod_x,
+		&pix_mp->height, min_h, max_h, mod_y, 0);
+	if (tmp_w != pix_mp->width || tmp_h != pix_mp->height)
+		flite_info("Image size has been modified from %dx%d to %dx%d",
+			 tmp_w, tmp_h, pix_mp->width, pix_mp->height);
+
+	pix_mp->num_planes = 1;
+
+	for (i = 0; i < pix_mp->num_planes; ++i) {
+		int bpl = (pix_mp->width * fmt->depth[i]) >> 3;
+		pix_mp->plane_fmt[i].bytesperline = bpl;
+		pix_mp->plane_fmt[i].sizeimage = bpl * pix_mp->height;
+
+		flite_dbg("[%d]: bpl: %d, sizeimage: %d",
+		    i, bpl, pix_mp->plane_fmt[i].sizeimage);
+	}
+
+	return 0;
+}
+
+void flite_set_frame_size(struct flite_frame *frame, int width, int height)
+{
+	frame->o_width	= width;
+	frame->o_height	= height;
+	frame->width = width;
+	frame->height = height;
+	frame->offs_h = 0;
+	frame->offs_v = 0;
+}
+
+static int flite_s_fmt_mplane(struct file *file, void *fh, struct v4l2_format *f)
+{
+	struct flite_dev *flite = video_drvdata(file);
+	struct flite_frame *frame;
+	struct v4l2_pix_format_mplane *pix;
+	int ret = 0;
+
+	ret = flite_try_fmt_mplane(file, fh, f);
+	if (ret)
+		return ret;
+
+	if (vb2_is_streaming(&flite->vbq)) {
+		flite_err("queue (%d) busy", f->type);
+		return -EBUSY;
+	}
+
+	frame = &flite->d_frame;
+
+	pix = &f->fmt.pix_mp;
+	frame->fmt = find_format(&pix->pixelformat, NULL, 0);
+	if (!frame->fmt)
+		return -EINVAL;
+
+	frame->payload = pix->plane_fmt[0].bytesperline * pix->height;
+	flite_set_frame_size(frame, pix->width, pix->height);
+
+	flite_info("f_w: %d, f_h: %d", frame->o_width, frame->o_height);
+
+	return 0;
+}
+
+static int flite_g_fmt_mplane(struct file *file, void *fh, struct v4l2_format *f)
+{
+	struct flite_dev *flite = video_drvdata(file);
+	struct flite_frame *frame;
+	struct v4l2_pix_format_mplane *pix_mp;
+	int i;
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		return -EINVAL;
+
+	frame = &flite->d_frame;
+
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	pix_mp = &f->fmt.pix_mp;
+
+	pix_mp->width		= frame->o_width;
+	pix_mp->height		= frame->o_height;
+	pix_mp->field		= V4L2_FIELD_NONE;
+	pix_mp->pixelformat	= frame->fmt->pixelformat;
+	pix_mp->colorspace	= V4L2_COLORSPACE_JPEG;
+	pix_mp->num_planes	= 1;
+
+	for (i = 0; i < pix_mp->num_planes; ++i) {
+		pix_mp->plane_fmt[i].bytesperline = (frame->o_width *
+			frame->fmt->depth[i]) / 8;
+		pix_mp->plane_fmt[i].sizeimage = pix_mp->plane_fmt[i].bytesperline *
+			frame->o_height;
+	}
+
+	return 0;
+}
+
+static int flite_reqbufs(struct file *file, void *priv,
+			    struct v4l2_requestbuffers *reqbufs)
+{
+	struct flite_dev *flite = video_drvdata(file);
+	struct flite_frame *frame;
+	int ret;
+
+	frame = &flite->d_frame;
+
+	ret = vb2_reqbufs(&flite->vbq, reqbufs);
+	if (!ret)
+		flite->reqbufs_cnt = reqbufs->count;
+
+	return ret;
+}
+
+static int flite_querybuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+{
+	struct flite_dev *flite = video_drvdata(file);
+
+	return vb2_querybuf(&flite->vbq, buf);
+}
+
+static int flite_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+{
+	struct flite_dev *flite = video_drvdata(file);
+
+	return vb2_qbuf(&flite->vbq, buf);
+}
+
+static int flite_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+{
+	struct flite_dev *flite = video_drvdata(file);
+
+	return vb2_dqbuf(&flite->vbq, buf, file->f_flags & O_NONBLOCK);
+}
+
+static int flite_link_validate(struct flite_dev *flite)
+{
+	struct v4l2_subdev_format sink_fmt, src_fmt;
+	struct v4l2_subdev *sd;
+	struct media_pad *pad;
+	int ret;
+
+	/* Get the source pad connected with flite-video */
+	pad =  media_entity_remote_source(&flite->vd_pad);
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
+		if (sd == flite->sd_flite) {
+			struct flite_frame *f = &flite->s_frame;
+			sink_fmt.format.width = f->o_width;
+			sink_fmt.format.height = f->o_height;
+			sink_fmt.format.code = f->fmt ? f->fmt->code : 0;
+		} else {
+			sink_fmt.pad = pad->index;
+			sink_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+			ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &sink_fmt);
+			if (ret < 0 && ret != -ENOIOCTLCMD) {
+				flite_err("failed %s subdev get_fmt", sd->name);
+				return -EPIPE;
+			}
+		}
+		flite_info("sink sd name : %s", sd->name);
+		/* Get the source pad connected with remote sink pad */
+		pad = media_entity_remote_source(pad);
+		if (pad == NULL ||
+		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+			break;
+
+		/* Get the subdev of source pad */
+		sd = media_entity_to_v4l2_subdev(pad->entity);
+		flite_info("source sd name : %s", sd->name);
+
+		src_fmt.pad = pad->index;
+		src_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+		ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &src_fmt);
+		if (ret < 0 && ret != -ENOIOCTLCMD) {
+			flite_err("failed %s subdev get_fmt", sd->name);
+			return -EPIPE;
+		}
+
+		flite_info("src_width : %d, src_height : %d, src_code : %d",
+			src_fmt.format.width, src_fmt.format.height,
+			src_fmt.format.code);
+		flite_info("sink_width : %d, sink_height : %d, sink_code : %d",
+			sink_fmt.format.width, sink_fmt.format.height,
+			sink_fmt.format.code);
+
+		if (src_fmt.format.width != sink_fmt.format.width ||
+		    src_fmt.format.height != sink_fmt.format.height ||
+		    src_fmt.format.code != sink_fmt.format.code) {
+			flite_err("mismatch sink and source");
+			return -EPIPE;
+		}
+	}
+
+	return 0;
+}
+static int flite_streamon(struct file *file, void *priv, enum v4l2_buf_type type)
+{
+	struct flite_dev *flite = video_drvdata(file);
+	struct flite_pipeline *p = &flite->pipeline;
+	int ret;
+
+	if (flite_active(flite))
+		return -EBUSY;
+
+	if (p->sensor) {
+		media_entity_pipeline_start(&p->sensor->entity, p->pipe);
+	} else {
+		flite_err("Error pipeline");
+		return -EPIPE;
+	}
+
+	ret = flite_link_validate(flite);
+	if (ret)
+		return ret;
+
+	return vb2_streamon(&flite->vbq, type);
+}
+
+static int flite_streamoff(struct file *file, void *priv,
+			    enum v4l2_buf_type type)
+{
+	struct flite_dev *flite = video_drvdata(file);
+	struct v4l2_subdev *sd = flite->pipeline.sensor;
+	int ret;
+
+	ret = vb2_streamoff(&flite->vbq, type);
+	if (ret == 0)
+		media_entity_pipeline_stop(&sd->entity);
+	return ret;
+}
+
+static int flite_enum_input(struct file *file, void *priv,
+			       struct v4l2_input *i)
+{
+	struct flite_dev *flite = video_drvdata(file);
+	struct exynos_platform_flite *pdata = flite->pdata;
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
+
+}
+
+static int flite_s_input(struct file *file, void *priv, unsigned int i)
+{
+	return i == 0 ? 0 : -EINVAL;
+}
+
+static int flite_g_input(struct file *file, void *priv, unsigned int *i)
+{
+	*i = 0;
+	return 0;
+}
+
+
+static const struct v4l2_ioctl_ops flite_capture_ioctl_ops = {
+	.vidioc_querycap		= flite_vidioc_querycap,
+
+	.vidioc_enum_fmt_vid_cap_mplane	= flite_enum_fmt_mplane,
+	.vidioc_try_fmt_vid_cap_mplane	= flite_try_fmt_mplane,
+	.vidioc_s_fmt_vid_cap_mplane	= flite_s_fmt_mplane,
+	.vidioc_g_fmt_vid_cap_mplane	= flite_g_fmt_mplane,
+
+	.vidioc_reqbufs			= flite_reqbufs,
+	.vidioc_querybuf		= flite_querybuf,
+
+	.vidioc_qbuf			= flite_qbuf,
+	.vidioc_dqbuf			= flite_dqbuf,
+
+	.vidioc_streamon		= flite_streamon,
+	.vidioc_streamoff		= flite_streamoff,
+
+	.vidioc_enum_input		= flite_enum_input,
+	.vidioc_s_input			= flite_s_input,
+	.vidioc_g_input			= flite_g_input,
+};
+
+static const struct v4l2_file_operations flite_fops = {
+	.owner		= THIS_MODULE,
+	.open		= flite_open,
+	.release	= flite_close,
+	.poll		= flite_poll,
+	.unlocked_ioctl	= video_ioctl2,
+	.mmap		= flite_mmap,
+};
+
+static int flite_config_camclk(struct flite_dev *flite,
+		struct exynos_isp_info *isp_info, int i)
+{
+	struct clk *camclk;
+	struct clk *srclk;
+
+	camclk = clk_get(&flite->pdev->dev, isp_info->cam_clk_name);
+	if (IS_ERR_OR_NULL(camclk)) {
+		flite_err("failed to get cam clk");
+		return -ENXIO;
+	}
+	flite->sensor[i].camclk = camclk;
+
+	srclk = clk_get(&flite->pdev->dev, isp_info->cam_srclk_name);
+	if (IS_ERR_OR_NULL(srclk)) {
+		clk_put(camclk);
+		flite_err("failed to get cam source clk\n");
+		return -ENXIO;
+	}
+	clk_set_parent(camclk, srclk);
+	clk_set_rate(camclk, isp_info->clk_frequency);
+	clk_put(srclk);
+
+	flite->gsc_clk = clk_get(&flite->pdev->dev, "gscl");
+	if (IS_ERR_OR_NULL(flite->gsc_clk)) {
+		flite_err("failed to get gscl clk");
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+static struct v4l2_subdev *flite_register_sensor(struct flite_dev *flite,
+		int i)
+{
+	struct exynos_platform_flite *pdata = flite->pdata;
+	struct exynos_isp_info *isp_info = pdata->isp_info[i];
+	struct exynos_md *mdev = flite->mdev;
+	struct i2c_adapter *adapter;
+	struct v4l2_subdev *sd = NULL;
+
+	adapter = i2c_get_adapter(isp_info->i2c_bus_num);
+	if (!adapter)
+		return NULL;
+	sd = v4l2_i2c_new_subdev_board(&mdev->v4l2_dev, adapter,
+				       isp_info->board_info, NULL);
+	if (IS_ERR_OR_NULL(sd)) {
+		v4l2_err(&mdev->v4l2_dev, "Failed to acquire subdev\n");
+		return NULL;
+	}
+	v4l2_set_subdev_hostdata(sd, &flite->sensor[i]);
+	sd->grp_id = SENSOR_GRP_ID;
+
+	v4l2_info(&mdev->v4l2_dev, "Registered sensor subdevice %s\n",
+		  isp_info->board_info->type);
+
+	return sd;
+}
+
+static int flite_register_sensor_entities(struct flite_dev *flite)
+{
+	struct exynos_platform_flite *pdata = flite->pdata;
+	u32 num_clients = pdata->num_clients;
+	int i;
+
+	for (i = 0; i < num_clients; i++) {
+		flite->sensor[i].pdata = pdata->isp_info[i];
+		flite->sensor[i].sd = flite_register_sensor(flite, i);
+		if (IS_ERR_OR_NULL(flite->sensor[i].sd)) {
+			flite_err("failed to get register sensor");
+			return -EINVAL;
+		}
+		flite->mdev->sensor_sd[i] = flite->sensor[i].sd;
+	}
+
+	return 0;
+}
+
+static int flite_create_subdev(struct flite_dev *flite, struct v4l2_subdev *sd)
+{
+	struct v4l2_device *v4l2_dev;
+	int ret;
+
+	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	flite->pads[FLITE_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	flite->pads[FLITE_PAD_SOURCE_PREV].flags = MEDIA_PAD_FL_SOURCE;
+	flite->pads[FLITE_PAD_SOURCE_CAMCORD].flags = MEDIA_PAD_FL_SOURCE;
+	flite->pads[FLITE_PAD_SOURCE_MEM].flags = MEDIA_PAD_FL_SOURCE;
+
+	ret = media_entity_init(&sd->entity, FLITE_PADS_NUM,
+				flite->pads, 0);
+	if (ret)
+		goto err_ent;
+
+	sd->internal_ops = &flite_v4l2_internal_ops;
+	sd->entity.ops = &flite_media_ops;
+	sd->grp_id = FLITE_GRP_ID;
+	v4l2_dev = &flite->mdev->v4l2_dev;
+	flite->mdev->flite_sd[flite->id] = sd;
+
+	ret = v4l2_device_register_subdev(v4l2_dev, sd);
+	if (ret)
+		goto err_sub;
+
+	flite_init_formats(sd, NULL);
+
+	return 0;
+
+err_sub:
+	media_entity_cleanup(&sd->entity);
+err_ent:
+	return ret;
+}
+
+static int flite_create_link(struct flite_dev *flite)
+{
+	struct media_entity *source, *sink;
+	struct exynos_platform_flite *pdata = flite->pdata;
+	struct exynos_isp_info *isp_info;
+	u32 num_clients = pdata->num_clients;
+	int ret, i;
+	enum cam_port id;
+
+	/* FIMC-LITE-SUBDEV ------> FIMC-LITE-VIDEO (Always link enable) */
+	source = &flite->sd_flite->entity;
+	sink = &flite->vfd->entity;
+	if (source && sink) {
+		ret = media_entity_create_link(source, FLITE_PAD_SOURCE_MEM, sink,
+				0, 0);
+		if (ret) {
+			flite_err("failed link flite-subdev to flite-video\n");
+			return ret;
+		}
+	}
+	/* link sensor to mipi-csis */
+	for (i = 0; i < num_clients; i++) {
+		isp_info = pdata->isp_info[i];
+		id = isp_info->cam_port;
+		switch (isp_info->bus_type) {
+		case CAM_TYPE_ITU:
+			/*	SENSOR ------> FIMC-LITE	*/
+			source = &flite->sensor[i].sd->entity;
+			sink = &flite->sd_flite->entity;
+			if (source && sink) {
+				ret = media_entity_create_link(source, 0,
+					      sink, FLITE_PAD_SINK, 0);
+				if (ret) {
+					flite_err("failed link sensor to flite\n");
+					return ret;
+				}
+			}
+			break;
+		case CAM_TYPE_MIPI:
+			/*	SENSOR ------> MIPI-CSI2	*/
+			source = &flite->sensor[i].sd->entity;
+			sink = &flite->sd_csis->entity;
+			if (source && sink) {
+				ret = media_entity_create_link(source, 0,
+					      sink, CSIS_PAD_SINK, 0);
+				if (ret) {
+					flite_err("failed link sensor to csis\n");
+					return ret;
+				}
+			}
+			/*	MIPI-CSI2 ------> FIMC-LITE	*/
+			source = &flite->sd_csis->entity;
+			sink = &flite->sd_flite->entity;
+			if (source && sink) {
+				ret = media_entity_create_link(source,
+						CSIS_PAD_SOURCE,
+						sink, FLITE_PAD_SINK, 0);
+				if (ret) {
+					flite_err("failed link csis to flite\n");
+					return ret;
+				}
+			}
+			break;
+		}
+	}
+
+	flite->input = FLITE_INPUT_NONE;
+	flite->output = FLITE_OUTPUT_NONE;
+
+	return 0;
+}
+static int flite_register_video_device(struct flite_dev *flite)
+{
+	struct video_device *vfd;
+	struct vb2_queue *q;
+	int ret = -ENOMEM;
+
+	vfd = video_device_alloc();
+	if (!vfd) {
+		flite_info("Failed to allocate video device");
+		return ret;
+	}
+
+	snprintf(vfd->name, sizeof(vfd->name), "%s", dev_name(&flite->pdev->dev));
+
+	vfd->fops	= &flite_fops;
+	vfd->ioctl_ops	= &flite_capture_ioctl_ops;
+	vfd->v4l2_dev	= &flite->mdev->v4l2_dev;
+	vfd->minor	= -1;
+	vfd->release	= video_device_release;
+	vfd->lock	= &flite->lock;
+	video_set_drvdata(vfd, flite);
+
+	flite->vfd = vfd;
+	flite->refcnt = 0;
+	flite->reqbufs_cnt  = 0;
+	INIT_LIST_HEAD(&flite->active_buf_q);
+	INIT_LIST_HEAD(&flite->pending_buf_q);
+
+	q = &flite->vbq;
+	memset(q, 0, sizeof(*q));
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	q->io_modes = VB2_MMAP | VB2_USERPTR;
+	q->drv_priv = flite;
+	q->ops = &flite_qops;
+	q->mem_ops = &vb2_dma_contig_memops;
+
+	vb2_queue_init(q);
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
+	if (ret) {
+		flite_err("failed to register video device");
+		goto err_vfd_alloc;
+	}
+
+	flite->vd_pad.flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_init(&vfd->entity, 1, &flite->vd_pad, 0);
+	if (ret) {
+		flite_err("failed to initialize entity");
+		goto err_unreg_video;
+	}
+
+	flite_dbg("flite video-device driver registered as /dev/video%d", vfd->num);
+
+	return 0;
+
+err_unreg_video:
+	video_unregister_device(vfd);
+err_vfd_alloc:
+	video_device_release(vfd);
+
+	return ret;
+}
+
+static int flite_get_md_callback(struct device *dev, void *p)
+{
+	struct exynos_md **md_list = p;
+	struct exynos_md *md = NULL;
+
+	md = dev_get_drvdata(dev);
+
+	if (md)
+		*(md_list + md->id) = md;
+
+	return 0; /* non-zero value stops iteration */
+}
+
+static struct exynos_md *flite_get_capture_md(enum mdev_node node)
+{
+	struct device_driver *drv;
+	struct exynos_md *md[MDEV_MAX_NUM] = {NULL,};
+	int ret;
+
+	drv = driver_find(MDEV_MODULE_NAME, &platform_bus_type);
+	if (!drv)
+		return ERR_PTR(-ENODEV);
+
+	ret = driver_for_each_device(drv, NULL, &md[0],
+				     flite_get_md_callback);
+	put_driver(drv);
+
+	return ret ? NULL : md[node];
+
+}
+
+static void flite_destroy_subdev(struct flite_dev *flite)
+{
+	struct v4l2_subdev *sd = flite->sd_flite;
+
+	if (!sd)
+		return;
+	media_entity_cleanup(&sd->entity);
+	v4l2_device_unregister_subdev(sd);
+	kfree(sd);
+	sd = NULL;
+}
+
+void flite_unregister_device(struct flite_dev *flite)
+{
+	struct video_device *vfd = flite->vfd;
+
+	if (vfd) {
+		media_entity_cleanup(&vfd->entity);
+		/* Can also be called if video device was
+		   not registered */
+		video_unregister_device(vfd);
+	}
+	flite_destroy_subdev(flite);
+}
+
+static int flite_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
+	struct flite_dev *flite = v4l2_get_subdevdata(sd);
+
+	if (test_bit(FLITE_ST_STREAM, &flite->state))
+		flite_s_stream(sd, false);
+	if (test_bit(FLITE_ST_POWER, &flite->state))
+		flite_s_power(sd, false);
+
+	set_bit(FLITE_ST_SUSPEND, &flite->state);
+
+	return 0;
+}
+
+static int flite_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
+	struct flite_dev *flite = v4l2_get_subdevdata(sd);
+
+	if (test_bit(FLITE_ST_POWER, &flite->state))
+		flite_s_power(sd, true);
+	if (test_bit(FLITE_ST_STREAM, &flite->state))
+		flite_s_stream(sd, true);
+
+	clear_bit(FLITE_ST_SUSPEND, &flite->state);
+
+	return 0;
+}
+
+static int flite_runtime_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
+	struct flite_dev *flite = v4l2_get_subdevdata(sd);
+	unsigned long flags;
+
+	spin_lock_irqsave(&flite->slock, flags);
+	set_bit(FLITE_ST_SUSPEND, &flite->state);
+	spin_unlock_irqrestore(&flite->slock, flags);
+
+	return 0;
+}
+
+static int flite_runtime_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
+	struct flite_dev *flite = v4l2_get_subdevdata(sd);
+	unsigned long flags;
+
+	spin_lock_irqsave(&flite->slock, flags);
+	clear_bit(FLITE_ST_SUSPEND, &flite->state);
+	spin_unlock_irqrestore(&flite->slock, flags);
+
+	return 0;
+}
+
+static struct v4l2_subdev_core_ops flite_core_ops = {
+	.s_power = flite_s_power,
+};
+
+static struct v4l2_subdev_video_ops flite_video_ops = {
+	.s_stream	= flite_s_stream,
+};
+
+static struct v4l2_subdev_ops flite_subdev_ops = {
+	.core	= &flite_core_ops,
+	.pad	= &flite_pad_ops,
+	.video	= &flite_video_ops,
+};
+
+static int flite_probe(struct platform_device *pdev)
+{
+	struct resource *mem_res;
+	struct resource *regs_res;
+	struct flite_dev *flite;
+	struct v4l2_subdev *sd;
+	int ret = -ENODEV;
+	struct exynos_isp_info *isp_info;
+	int i;
+
+	if (!pdev->dev.platform_data) {
+		dev_err(&pdev->dev, "platform data is NULL\n");
+		return -EINVAL;
+	}
+
+	flite = kzalloc(sizeof(struct flite_dev), GFP_KERNEL);
+	if (!flite)
+		return -ENOMEM;
+
+	flite->pdev = pdev;
+	flite->pdata = pdev->dev.platform_data;
+
+	flite->id = pdev->id;
+
+	init_waitqueue_head(&flite->irq_queue);
+	spin_lock_init(&flite->slock);
+
+	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem_res) {
+		dev_err(&pdev->dev, "Failed to get io memory region\n");
+		goto err_flite;
+	}
+
+	regs_res = request_mem_region(mem_res->start, resource_size(mem_res),
+				      pdev->name);
+	if (!regs_res) {
+		dev_err(&pdev->dev, "Failed to request io memory region\n");
+		goto err_resource;
+	}
+
+	flite->regs_res = regs_res;
+	flite->regs = ioremap(mem_res->start, resource_size(mem_res));
+	if (!flite->regs) {
+		dev_err(&pdev->dev, "Failed to remap io region\n");
+		goto err_reg_region;
+	}
+
+	flite->irq = platform_get_irq(pdev, 0);
+	if (flite->irq < 0) {
+		dev_err(&pdev->dev, "Failed to get irq\n");
+		goto err_reg_unmap;
+	}
+
+	ret = request_irq(flite->irq, flite_irq_handler, 0, dev_name(&pdev->dev), flite);
+	if (ret) {
+		dev_err(&pdev->dev, "request_irq failed\n");
+		goto err_reg_unmap;
+	}
+
+	sd = kzalloc(sizeof(*sd), GFP_KERNEL);
+	if (!sd)
+	       goto err_irq;
+
+	v4l2_subdev_init(sd, &flite_subdev_ops);
+	snprintf(sd->name, sizeof(sd->name), "flite-subdev.%d", flite->id);
+
+	flite->sd_flite = sd;
+	v4l2_set_subdevdata(flite->sd_flite, flite);
+
+	mutex_init(&flite->lock);
+	flite->mdev = flite_get_capture_md(MDEV_CAPTURE);
+	if (IS_ERR_OR_NULL(flite->mdev))
+		goto err_irq;
+
+	flite_dbg("mdev = 0x%08x", (u32)flite->mdev);
+
+	ret = flite_register_video_device(flite);
+	if (ret)
+		goto err_irq;
+
+	/* Get mipi-csis subdev ptr using mdev */
+	flite->sd_csis = flite->mdev->csis_sd[flite->id];
+
+	for (i = 0; i < flite->pdata->num_clients; i++) {
+		isp_info = flite->pdata->isp_info[i];
+		ret = flite_config_camclk(flite, isp_info, i);
+		if (ret) {
+			flite_err("failed setup cam clk");
+			goto err_vfd_alloc;
+		}
+	}
+
+	ret = flite_register_sensor_entities(flite);
+	if (ret) {
+		flite_err("failed register sensor entities");
+		goto err_clk;
+	}
+
+	ret = flite_create_subdev(flite, sd);
+	if (ret) {
+		flite_err("failed create subdev");
+		goto err_clk;
+	}
+
+	ret = flite_create_link(flite);
+	if (ret) {
+		flite_err("failed create link");
+		goto err_entity;
+	}
+
+	flite->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
+	if (IS_ERR(flite->alloc_ctx)) {
+		ret = PTR_ERR(flite->alloc_ctx);
+		goto err_entity;
+	}
+
+	platform_set_drvdata(flite->pdev, flite->sd_flite);
+	pm_runtime_enable(&pdev->dev);
+
+	flite_info("FIMC-LITE%d probe success", pdev->id);
+
+	return 0;
+
+err_entity:
+	media_entity_cleanup(&sd->entity);
+err_clk:
+	for (i = 0; i < flite->pdata->num_clients; i++)
+		clk_put(flite->sensor[i].camclk);
+err_vfd_alloc:
+	media_entity_cleanup(&flite->vfd->entity);
+	video_device_release(flite->vfd);
+err_irq:
+	free_irq(flite->irq, flite);
+err_reg_unmap:
+	iounmap(flite->regs);
+err_reg_region:
+	release_mem_region(regs_res->start, resource_size(regs_res));
+err_resource:
+	release_resource(flite->regs_res);
+	kfree(flite->regs_res);
+err_flite:
+	kfree(flite);
+	return ret;
+}
+
+static int flite_remove(struct platform_device *pdev)
+{
+	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
+	struct flite_dev *flite = v4l2_get_subdevdata(sd);
+	struct resource *res = flite->regs_res;
+
+	flite_s_power(flite->sd_flite, 0);
+	flite_subdev_close(sd, NULL);
+	flite_unregister_device(flite);
+
+	vb2_dma_contig_cleanup_ctx(flite->alloc_ctx);
+
+	pm_runtime_disable(&pdev->dev);
+	free_irq(flite->irq, flite);
+	iounmap(flite->regs);
+	release_mem_region(res->start, resource_size(res));
+	kfree(flite);
+
+	return 0;
+}
+
+
+static const struct dev_pm_ops flite_pm_ops = {
+	.suspend		= flite_suspend,
+	.resume			= flite_resume,
+	.runtime_suspend	= flite_runtime_suspend,
+	.runtime_resume		= flite_runtime_resume,
+};
+
+static struct platform_driver flite_driver = {
+	.probe		= flite_probe,
+	.remove	= __devexit_p(flite_remove),
+	.driver = {
+		.name	= MODULE_NAME,
+		.owner	= THIS_MODULE,
+		.pm	= &flite_pm_ops,
+	}
+};
+
+static int __init flite_init(void)
+{
+	int ret = platform_driver_register(&flite_driver);
+	if (ret)
+		flite_err("platform_driver_register failed: %d", ret);
+	return ret;
+}
+
+static void __exit flite_exit(void)
+{
+	platform_driver_unregister(&flite_driver);
+}
+module_init(flite_init);
+module_exit(flite_exit);
+
+MODULE_AUTHOR("Sky Kang<sungchun.kang@samsung.com>");
+MODULE_DESCRIPTION("Exynos FIMC-Lite driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/exynos/fimc-lite/fimc-lite-core.h b/drivers/media/video/exynos/fimc-lite/fimc-lite-core.h
new file mode 100644
index 0000000..d6da3b0
--- /dev/null
+++ b/drivers/media/video/exynos/fimc-lite/fimc-lite-core.h
@@ -0,0 +1,310 @@
+/*
+ * Register interface file for Samsung Camera Interface (FIMC-Lite) driver
+ *
+ * Copyright (c) 2011 Samsung Electronics
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+#ifndef FLITE_CORE_H_
+#define FLITE_CORE_H_
+
+/* #define DEBUG */
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/videodev2.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/pm_runtime.h>
+#include <media/videobuf2-core.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-mediabus.h>
+#include <media/exynos_flite.h>
+#include <media/v4l2-ioctl.h>
+#include <media/exynos_mc.h>
+#include "fimc-lite-reg.h"
+
+#define flite_info(fmt, args...) \
+	printk(KERN_INFO "[INFO]%s:%d: "fmt "\n", __func__, __LINE__, ##args)
+#define flite_err(fmt, args...) \
+	printk(KERN_ERR "[ERROR]%s:%d: "fmt "\n", __func__, __LINE__, ##args)
+#define flite_warn(fmt, args...) \
+	printk(KERN_WARNING "[WARNNING]%s:%d: "fmt "\n", __func__, __LINE__, ##args)
+
+#ifdef DEBUG
+#define flite_dbg(fmt, args...) \
+	printk(KERN_DEBUG "[DEBUG]%s:%d: " fmt "\n", __func__, __LINE__, ##args)
+#else
+#define flite_dbg(fmt, args...)
+#endif
+
+#define FLITE_MAX_RESET_READY_TIME	20 /* 100ms */
+#define FLITE_MAX_CTRL_NUM		1
+#define FLITE_MAX_OUT_BUFS		1
+
+enum flite_input_entity {
+	FLITE_INPUT_NONE,
+	FLITE_INPUT_SENSOR,
+	FLITE_INPUT_CSIS,
+};
+
+enum flite_output_entity {
+	FLITE_OUTPUT_NONE = (1 << 0),
+	FLITE_OUTPUT_GSC = (1 << 1),
+	FLITE_OUTPUT_MEM = (1 << 2),
+};
+
+enum flite_out_path {
+	FLITE_ISP,
+	FLITE_DMA,
+};
+
+enum flite_state {
+	FLITE_ST_OPEN,
+	FLITE_ST_SUBDEV_OPEN,
+	FLITE_ST_POWER,
+	FLITE_ST_STREAM,
+	FLITE_ST_SUSPEND,
+	FLITE_ST_RUN,
+	FLITE_ST_PIPE_STREAM,
+	FLITE_ST_PEND,
+};
+
+#define flite_active(dev) test_bit(FLITE_ST_RUN, &(dev)->state)
+#define ctrl_to_dev(__ctrl) \
+	container_of((__ctrl)->handler, struct flite_dev, ctrl_handler)
+#define flite_get_frame(flite, pad)\
+	((pad == FLITE_PAD_SINK) ? &flite->s_frame : &flite->d_frame)
+
+struct flite_variant {
+	u16 max_w;
+	u16 max_h;
+	u16 align_win_offs_w;
+	u16 align_out_w;
+	u16 align_out_offs_w;
+};
+
+/**
+  * struct flite_fmt - driver's color format data
+  * @name :	format description
+  * @code :	Media Bus pixel code
+  * @fmt_reg :	H/W bit for setting format
+  */
+struct flite_fmt {
+	char				*name;
+	u32				pixelformat;
+	enum v4l2_mbus_pixelcode	code;
+	u32				fmt_reg;
+	u32				is_yuv;
+	u8				depth[VIDEO_MAX_PLANES];
+};
+
+struct flite_addr {
+	dma_addr_t	y;
+};
+
+/**
+ * struct flite_frame - source/target frame properties
+ * @o_width:	buffer width as set by S_FMT
+ * @o_height:	buffer height as set by S_FMT
+ * @width:	image pixel width
+ * @height:	image pixel weight
+ * @offs_h:	image horizontal pixel offset
+ * @offs_v:	image vertical pixel offset
+ */
+
+/*
+		o_width
+	---------------------
+	|    width(cropped) |
+	|	-----	    |
+	|offs_h |   |	    |
+	|	-----	    |
+	|		    |
+	---------------------
+ */
+struct flite_frame {
+	u32 o_width;
+	u32 o_height;
+	u32 width;
+	u32 height;
+	u32 offs_h;
+	u32 offs_v;
+	unsigned long payload;
+	struct flite_addr addr;
+	struct flite_fmt *fmt;
+};
+
+struct flite_pipeline {
+	struct media_pipeline *pipe;
+	struct v4l2_subdev *flite;
+	struct v4l2_subdev *csis;
+	struct v4l2_subdev *sensor;
+};
+
+struct flite_sensor_info {
+	struct exynos_isp_info *pdata;
+	struct v4l2_subdev *sd;
+	struct clk *camclk;
+};
+
+/**
+  * struct flite_dev - top structure of FIMC-Lite device
+  * @pdev :	pointer to the FIMC-Lite platform device
+  * @lock :	the mutex protecting this data structure
+  * @sd :	subdevice pointer of FIMC-Lite
+  * @fmt :	Media bus format of FIMC-Lite
+  * @regs_res :	ioremapped regs of FIMC-Lite
+  * @regs :	SFR of FIMC-Lite
+  */
+struct flite_dev {
+	struct platform_device		*pdev;
+	struct exynos_platform_flite	*pdata; /* depended on isp */
+	spinlock_t			slock;
+	struct v4l2_subdev		*sd_flite;
+	struct exynos_md		*mdev;
+	struct v4l2_subdev		*sd_csis;
+	struct flite_sensor_info	sensor[SENSOR_MAX_ENTITIES];
+	struct media_pad		pads[FLITE_PADS_NUM];
+	struct media_pad		vd_pad;
+	struct flite_frame		d_frame;
+	struct mutex			lock;
+	struct video_device		*vfd;
+	int				refcnt;
+	u32				reqbufs_cnt;
+	struct vb2_queue		vbq;
+	struct vb2_alloc_ctx		*alloc_ctx;
+	const struct flite_vb2		*vb2;
+	struct flite_pipeline		pipeline;
+	bool				ctrls_rdy;
+	struct list_head		pending_buf_q;
+	struct list_head		active_buf_q;
+	int				active_buf_cnt;
+	int				pending_buf_cnt;
+	int				buf_index;
+	struct clk			*gsc_clk;
+	struct v4l2_mbus_framefmt	mbus_fmt;
+	struct flite_frame		s_frame;
+	struct resource			*regs_res;
+	void __iomem			*regs;
+	int				irq;
+	unsigned long			state;
+	u32				out_path;
+	wait_queue_head_t		irq_queue;
+	u32				id;
+	enum flite_input_entity		input;
+	enum flite_output_entity	output;
+};
+
+struct flite_buffer {
+	struct vb2_buffer	vb;
+	struct list_head	list;
+	struct flite_addr	paddr;
+	int			index;
+};
+/* fimc-reg.c */
+void flite_hw_set_cam_source_size(struct flite_dev *dev);
+void flite_hw_set_cam_channel(struct flite_dev *dev);
+void flite_hw_set_camera_type(struct flite_dev *dev, struct s3c_platform_camera *cam);
+int flite_hw_set_source_format(struct flite_dev *dev);
+void flite_hw_set_output_dma(struct flite_dev *dev, bool enable);
+void flite_hw_set_interrupt_source(struct flite_dev *dev, u32 source);
+void flite_hw_set_config_irq(struct flite_dev *dev, struct s3c_platform_camera *cam);
+void flite_hw_set_window_offset(struct flite_dev *dev);
+void flite_hw_set_capture_start(struct flite_dev *dev);
+void flite_hw_set_capture_stop(struct flite_dev *dev);
+void flite_hw_reset(struct flite_dev *dev);
+void flite_hw_set_last_capture_end_clear(struct flite_dev *dev);
+void flite_hw_set_inverse_polarity(struct flite_dev *dev);
+void flite_hw_set_sensor_type(struct flite_dev *dev);
+void flite_hw_set_out_order(struct flite_dev *dev);
+void flite_hw_set_output_size(struct flite_dev *dev);
+void flite_hw_set_dma_offset(struct flite_dev *dev);
+void flite_hw_set_output_addr(struct flite_dev *dev, struct flite_addr *addr,
+							int index);
+
+/* inline function for performance-sensitive region */
+static inline void flite_hw_clear_irq(struct flite_dev *dev)
+{
+	u32 cfg = readl(dev->regs + FLITE_REG_CISTATUS);
+	cfg &= ~FLITE_REG_CISTATUS_IRQ_CAM;
+	writel(cfg, dev->regs + FLITE_REG_CISTATUS);
+}
+
+static inline void flite_hw_get_int_src(struct flite_dev *dev, u32 *src)
+{
+	*src = readl(dev->regs + FLITE_REG_CISTATUS);
+	*src &= FLITE_REG_CISTATUS_IRQ_MASK;
+}
+
+static inline void user_to_drv(struct v4l2_ctrl *ctrl, s32 value)
+{
+	ctrl->cur.val = ctrl->val = value;
+}
+
+inline struct flite_fmt *find_format(u32 *pixelformat, u32 *mbus_code,
+						int index);
+
+/*
+ * Add buf to the capture active buffers queue.
+ * Locking: Need to be called with fimc_dev::slock held.
+ */
+
+static inline void active_queue_add(struct flite_dev *flite,
+				    struct flite_buffer *buf)
+{
+	list_add_tail(&buf->list, &flite->active_buf_q);
+	flite->active_buf_cnt++;
+}
+
+/*
+ * Pop a video buffer from the capture active buffers queue
+ * Locking: Need to be called with fimc_dev::slock held.
+ */
+static inline struct flite_buffer *active_queue_pop(struct flite_dev *flite)
+{
+	struct flite_buffer *buf;
+
+	buf = list_entry(flite->active_buf_q.next, struct flite_buffer, list);
+	list_del(&buf->list);
+	flite->active_buf_cnt--;
+
+	return buf;
+}
+
+/* Add video buffer to the capture pending buffers queue */
+static inline void pending_queue_add(struct flite_dev *flite,
+					  struct flite_buffer *buf)
+{
+	list_add_tail(&buf->list, &flite->pending_buf_q);
+	flite->pending_buf_cnt++;
+}
+
+/* Add video buffer to the capture pending buffers queue */
+static inline struct flite_buffer *pending_queue_pop(struct flite_dev *flite)
+{
+	struct flite_buffer *buf;
+
+	buf = list_entry(flite->pending_buf_q.next, struct flite_buffer, list);
+	list_del(&buf->list);
+	flite->pending_buf_cnt--;
+
+	return buf;
+}
+
+static inline void flite_lock(struct vb2_queue *vq)
+{
+	struct flite_dev *flite = vb2_get_drv_priv(vq);
+	mutex_lock(&flite->lock);
+}
+
+static inline void flite_unlock(struct vb2_queue *vq)
+{
+	struct flite_dev *flite = vb2_get_drv_priv(vq);
+	mutex_unlock(&flite->lock);
+}
+#endif /* FLITE_CORE_H */
diff --git a/drivers/media/video/exynos/fimc-lite/fimc-lite-reg.c b/drivers/media/video/exynos/fimc-lite/fimc-lite-reg.c
new file mode 100644
index 0000000..c0d205e
--- /dev/null
+++ b/drivers/media/video/exynos/fimc-lite/fimc-lite-reg.c
@@ -0,0 +1,332 @@
+/*
+ * Register interface file for Samsung Camera Interface (FIMC-Lite) driver
+ *
+ * Copyright (c) 2011 Samsung Electronics
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/io.h>
+#include <media/exynos_flite.h>
+#include <mach/map.h>
+#include <plat/cpu.h>
+
+#include "fimc-lite-core.h"
+
+void flite_hw_set_cam_source_size(struct flite_dev *dev)
+{
+	struct flite_frame *f_frame =  &dev->s_frame;
+	u32 cfg = 0;
+
+	cfg = readl(dev->regs + FLITE_REG_CISRCSIZE);
+
+	cfg |= FLITE_REG_CISRCSIZE_SIZE_H(f_frame->o_width);
+	cfg |= FLITE_REG_CISRCSIZE_SIZE_V(f_frame->o_height);
+
+	writel(cfg, dev->regs + FLITE_REG_CISRCSIZE);
+}
+
+void flite_hw_set_cam_channel(struct flite_dev *dev)
+{
+	u32 cfg = readl(dev->regs + FLITE_REG_CIGENERAL);
+
+	if (dev->id == 0)
+		cfg &= FLITE_REG_CIGENERAL_CAM_A;
+	else
+		cfg |= FLITE_REG_CIGENERAL_CAM_B;
+
+	writel(cfg, dev->regs + FLITE_REG_CIGENERAL);
+}
+
+void flite_hw_reset(struct flite_dev *dev)
+{
+	u32 cfg = 0;
+	unsigned long timeo = jiffies + FLITE_MAX_RESET_READY_TIME;
+
+	cfg = readl(dev->regs + FLITE_REG_CIGCTRL);
+	cfg |= FLITE_REG_CIGCTRL_SWRST_REQ;
+	writel(cfg, dev->regs + FLITE_REG_CIGCTRL);
+
+	do {
+		if (cfg & FLITE_REG_CIGCTRL_SWRST_RDY)
+			break;
+		usleep_range(1000, 5000);
+	} while (time_before(jiffies, timeo));
+
+	flite_dbg("wait time : %d ms",
+		jiffies_to_msecs(jiffies - timeo + FLITE_MAX_RESET_READY_TIME));
+
+	cfg |= FLITE_REG_CIGCTRL_SWRST;
+	writel(cfg, dev->regs + FLITE_REG_CIGCTRL);
+}
+
+/* Support only FreeRun mode
+ * If output DMA is supported, I will implement one shot mode
+ * with Cpt_FrCnt and Cpt_FrEn
+ */
+
+void flite_hw_set_capture_start(struct flite_dev *dev)
+{
+	u32 cfg = 0;
+
+	cfg = readl(dev->regs + FLITE_REG_CIIMGCPT);
+	cfg |= FLITE_REG_CIIMGCPT_IMGCPTEN;
+
+	writel(cfg, dev->regs + FLITE_REG_CIIMGCPT);
+}
+
+void flite_hw_set_capture_stop(struct flite_dev *dev)
+{
+	u32 cfg = 0;
+
+	cfg = readl(dev->regs + FLITE_REG_CIIMGCPT);
+	cfg &= ~FLITE_REG_CIIMGCPT_IMGCPTEN;
+
+	writel(cfg, dev->regs + FLITE_REG_CIIMGCPT);
+
+	if (soc_is_exynos4212() || soc_is_exynos4412())
+		clear_bit(FLITE_ST_STREAM, &dev->state);
+}
+
+int flite_hw_set_source_format(struct flite_dev *dev)
+{
+	struct v4l2_mbus_framefmt *mbus_fmt = &dev->mbus_fmt;
+	struct flite_fmt *f_fmt = find_format(NULL, &mbus_fmt->code, 0);
+	u32 cfg = 0;
+
+	if (!f_fmt) {
+		flite_err("f_fmt is null");
+		return -EINVAL;
+	}
+
+	cfg = readl(dev->regs + FLITE_REG_CIGCTRL);
+	cfg |= f_fmt->fmt_reg;
+	writel(cfg, dev->regs + FLITE_REG_CIGCTRL);
+
+	if (f_fmt->is_yuv) {
+		cfg = readl(dev->regs + FLITE_REG_CISRCSIZE);
+
+		switch (f_fmt->code) {
+		case V4L2_MBUS_FMT_YUYV8_2X8:
+			cfg |= FLITE_REG_CISRCSIZE_ORDER422_IN_YCBYCR;
+			break;
+		case V4L2_MBUS_FMT_YVYU8_2X8:
+			cfg |= FLITE_REG_CISRCSIZE_ORDER422_IN_YCRYCB;
+			break;
+		case V4L2_MBUS_FMT_UYVY8_2X8:
+			cfg |= FLITE_REG_CISRCSIZE_ORDER422_IN_CBYCRY;
+			break;
+		case V4L2_MBUS_FMT_VYUY8_2X8:
+			cfg |= FLITE_REG_CISRCSIZE_ORDER422_IN_CRYCBY;
+			break;
+		default:
+			flite_err("not supported mbus code");
+			return -EINVAL;
+		}
+		writel(cfg, dev->regs + FLITE_REG_CISRCSIZE);
+	}
+	return 0;
+}
+
+void flite_hw_set_shadow_mask(struct flite_dev *dev, bool enable)
+{
+	u32 cfg = 0;
+	cfg = readl(dev->regs + FLITE_REG_CIGCTRL);
+
+	if (enable)
+		cfg &= ~FLITE_REG_CIGCTRL_SHADOWMASK_DISABLE;
+	else
+		cfg |= FLITE_REG_CIGCTRL_SHADOWMASK_DISABLE;
+
+	writel(cfg, dev->regs + FLITE_REG_CIGCTRL);
+}
+
+void flite_hw_set_output_dma(struct flite_dev *dev, bool enable)
+{
+	u32 cfg = 0;
+	cfg = readl(dev->regs + FLITE_REG_CIGCTRL);
+
+	if (enable)
+		cfg &= ~FLITE_REG_CIGCTRL_ODMA_DISABLE;
+	else
+		cfg |= FLITE_REG_CIGCTRL_ODMA_DISABLE;
+
+	writel(cfg, dev->regs + FLITE_REG_CIGCTRL);
+}
+
+void flite_hw_set_test_pattern_enable(struct flite_dev *dev)
+{
+	u32 cfg = 0;
+	cfg = readl(dev->regs + FLITE_REG_CIGCTRL);
+	cfg |= FLITE_REG_CIGCTRL_TEST_PATTERN_COLORBAR;
+
+	writel(cfg, dev->regs + FLITE_REG_CIGCTRL);
+}
+
+void flite_hw_set_config_irq(struct flite_dev *dev, struct s3c_platform_camera *cam)
+{
+	u32 cfg = 0;
+	cfg = readl(dev->regs + FLITE_REG_CIGCTRL);
+	cfg &= ~(FLITE_REG_CIGCTRL_INVPOLPCLK | FLITE_REG_CIGCTRL_INVPOLVSYNC
+			| FLITE_REG_CIGCTRL_INVPOLHREF);
+
+	if (cam->inv_pclk)
+		cfg |= FLITE_REG_CIGCTRL_INVPOLPCLK;
+	if (cam->inv_vsync)
+		cfg |= FLITE_REG_CIGCTRL_INVPOLVSYNC;
+	if (cam->inv_href)
+		cfg |= FLITE_REG_CIGCTRL_INVPOLHREF;
+
+	writel(cfg, dev->regs + FLITE_REG_CIGCTRL);
+}
+
+void flite_hw_set_interrupt_source(struct flite_dev *dev, u32 source)
+{
+	u32 cfg = 0;
+	cfg = readl(dev->regs + FLITE_REG_CIGCTRL);
+	cfg |= source;
+
+	writel(cfg, dev->regs + FLITE_REG_CIGCTRL);
+}
+
+void flite_hw_set_camera_type(struct flite_dev *dev, struct s3c_platform_camera *cam)
+{
+	u32 cfg = 0;
+	cfg = readl(dev->regs + FLITE_REG_CIGCTRL);
+
+	if (cam->type == CAM_TYPE_ITU)
+		cfg &= ~FLITE_REG_CIGCTRL_SELCAM_MIPI;
+	else
+		cfg |= FLITE_REG_CIGCTRL_SELCAM_MIPI;
+
+	writel(cfg, dev->regs + FLITE_REG_CIGCTRL);
+}
+
+void flite_hw_set_window_offset(struct flite_dev *dev)
+{
+	u32 cfg = 0;
+	u32 hoff2, voff2;
+	struct flite_frame *f_frame = &dev->s_frame;
+
+	cfg = readl(dev->regs + FLITE_REG_CIWDOFST);
+	cfg &= ~(FLITE_REG_CIWDOFST_HOROFF_MASK |
+		FLITE_REG_CIWDOFST_VEROFF_MASK);
+	cfg |= FLITE_REG_CIWDOFST_WINOFSEN |
+		FLITE_REG_CIWDOFST_WINHOROFST(f_frame->offs_h) |
+		FLITE_REG_CIWDOFST_WINVEROFST(f_frame->offs_v);
+
+	writel(cfg, dev->regs + FLITE_REG_CIWDOFST);
+
+	hoff2 = f_frame->o_width - f_frame->width - f_frame->offs_h;
+	voff2 = f_frame->o_height - f_frame->height - f_frame->offs_v;
+	cfg = FLITE_REG_CIWDOFST2_WINHOROFST2(hoff2) |
+		FLITE_REG_CIWDOFST2_WINVEROFST2(voff2);
+
+	writel(cfg, dev->regs + FLITE_REG_CIWDOFST2);
+}
+
+void flite_hw_set_last_capture_end_clear(struct flite_dev *dev)
+{
+	u32 cfg = 0;
+
+	cfg = readl(dev->regs + FLITE_REG_CISTATUS2);
+	cfg &= ~FLITE_REG_CISTATUS2_LASTCAPEND;
+
+	writel(cfg, dev->regs + FLITE_REG_CISTATUS2);
+}
+
+void flite_hw_set_inverse_polarity(struct flite_dev *dev)
+{
+	struct v4l2_subdev *sd = dev->pipeline.sensor;
+	struct flite_sensor_info *s_info = v4l2_get_subdev_hostdata(sd);
+	u32 cfg = 0;
+	cfg = readl(dev->regs + FLITE_REG_CIGCTRL);
+	cfg &= ~(FLITE_REG_CIGCTRL_INVPOLPCLK | FLITE_REG_CIGCTRL_INVPOLVSYNC
+			| FLITE_REG_CIGCTRL_INVPOLHREF);
+
+	if (s_info->pdata->flags & CAM_CLK_INV_PCLK)
+		cfg |= FLITE_REG_CIGCTRL_INVPOLPCLK;
+	if (s_info->pdata->flags & CAM_CLK_INV_VSYNC)
+		cfg |= FLITE_REG_CIGCTRL_INVPOLVSYNC;
+	if (s_info->pdata->flags & CAM_CLK_INV_HREF)
+		cfg |= FLITE_REG_CIGCTRL_INVPOLHREF;
+
+	writel(cfg, dev->regs + FLITE_REG_CIGCTRL);
+}
+
+void flite_hw_set_sensor_type(struct flite_dev *dev)
+{
+	struct v4l2_subdev *sd = dev->pipeline.sensor;
+	struct flite_sensor_info *s_info = v4l2_get_subdev_hostdata(sd);
+	u32 cfg = 0;
+	cfg = readl(dev->regs + FLITE_REG_CIGCTRL);
+
+	if (s_info->pdata->bus_type == CAM_TYPE_ITU)
+		cfg &= ~FLITE_REG_CIGCTRL_SELCAM_MIPI;
+	else
+		cfg |= FLITE_REG_CIGCTRL_SELCAM_MIPI;
+
+	writel(cfg, dev->regs + FLITE_REG_CIGCTRL);
+
+}
+
+void flite_hw_set_dma_offset(struct flite_dev *dev)
+{
+	u32 cfg = 0;
+	struct flite_frame *f_frame = &dev->d_frame;
+	cfg = readl(dev->regs + FLITE_REG_CIOOFF);
+	cfg |= FLITE_REG_CIOOFF_OOFF_H(f_frame->offs_h) |
+		FLITE_REG_CIOOFF_OOFF_V(f_frame->offs_v);
+
+	writel(cfg, dev->regs + FLITE_REG_CIOOFF);
+}
+
+void flite_hw_set_output_addr(struct flite_dev *dev,
+			     struct flite_addr *addr, int index)
+{
+	flite_info("dst_buf[%d]: 0x%X", index, addr->y);
+
+	writel(addr->y, dev->regs + FLITE_REG_CIOSA);
+}
+
+void flite_hw_set_out_order(struct flite_dev *dev)
+{
+	struct flite_frame *frame = &dev->d_frame;
+	u32 cfg = readl(dev->regs + FLITE_REG_CIODMAFMT);
+	if (frame->fmt->is_yuv) {
+		switch (frame->fmt->code) {
+		case V4L2_MBUS_FMT_UYVY8_2X8:
+			cfg |= FLITE_REG_CIODMAFMT_CBYCRY;
+			break;
+		case V4L2_MBUS_FMT_VYUY8_2X8:
+			cfg |= FLITE_REG_CIODMAFMT_CRYCBY;
+			break;
+		case V4L2_MBUS_FMT_YUYV8_2X8:
+			cfg |= FLITE_REG_CIODMAFMT_YCBYCR;
+			break;
+		case V4L2_MBUS_FMT_YVYU8_2X8:
+			cfg |= FLITE_REG_CIODMAFMT_YCRYCB;
+			break;
+		default:
+			flite_err("not supported mbus_code");
+			break;
+
+		}
+	}
+	writel(cfg, dev->regs + FLITE_REG_CIODMAFMT);
+}
+
+void flite_hw_set_output_size(struct flite_dev *dev)
+{
+	struct flite_frame *f_frame =  &dev->d_frame;
+	u32 cfg = 0;
+
+	cfg = readl(dev->regs + FLITE_REG_CIOCAN);
+
+	cfg |= FLITE_REG_CIOCAN_OCAN_V(f_frame->o_height);
+	cfg |= FLITE_REG_CIOCAN_OCAN_H(f_frame->o_width);
+
+	writel(cfg, dev->regs + FLITE_REG_CIOCAN);
+}
diff --git a/drivers/media/video/exynos/fimc-lite/fimc-lite-reg.h b/drivers/media/video/exynos/fimc-lite/fimc-lite-reg.h
new file mode 100644
index 0000000..df99fa5
--- /dev/null
+++ b/drivers/media/video/exynos/fimc-lite/fimc-lite-reg.h
@@ -0,0 +1,135 @@
+/*
+ * Register interface file for Samsung Camera Interface (FIMC-Lite) driver
+ *
+ * Copyright (c) 2011 Samsung Electronics
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef FIMC_LITE_REG_H_
+#define FIMC_LITE_REG_H_
+
+/* Camera Source size */
+#define FLITE_REG_CISRCSIZE				0x00
+#define FLITE_REG_CISRCSIZE_SIZE_H(x)			((x) << 16)
+#define FLITE_REG_CISRCSIZE_SIZE_V(x)			((x) << 0)
+#define FLITE_REG_CISRCSIZE_ORDER422_IN_YCBYCR		(0 << 14)
+#define FLITE_REG_CISRCSIZE_ORDER422_IN_YCRYCB		(1 << 14)
+#define FLITE_REG_CISRCSIZE_ORDER422_IN_CBYCRY		(2 << 14)
+#define FLITE_REG_CISRCSIZE_ORDER422_IN_CRYCBY		(3 << 14)
+
+/* Global control */
+#define FLITE_REG_CIGCTRL				0x04
+#define FLITE_REG_CIGCTRL_YUV422_1P			(0x1E << 24)
+#define FLITE_REG_CIGCTRL_RAW8				(0x2A << 24)
+#define FLITE_REG_CIGCTRL_RAW10				(0x2B << 24)
+#define FLITE_REG_CIGCTRL_RAW12				(0x2C << 24)
+#define FLITE_REG_CIGCTRL_RAW14				(0x2D << 24)
+/* User defined formats. x = 0...0xF. */
+#define FLITE_REG_CIGCTRL_USER(x)			(0x30 + x - 1)
+#define FLITE_REG_CIGCTRL_SHADOWMASK_DISABLE		(1 << 21)
+#define FLITE_REG_CIGCTRL_ODMA_DISABLE			(1 << 20)
+#define FLITE_REG_CIGCTRL_SWRST_REQ			(1 << 19)
+#define FLITE_REG_CIGCTRL_SWRST_RDY			(1 << 18)
+#define FLITE_REG_CIGCTRL_SWRST				(1 << 17)
+#define FLITE_REG_CIGCTRL_TEST_PATTERN_COLORBAR		(1 << 15)
+#define FLITE_REG_CIGCTRL_INVPOLPCLK			(1 << 14)
+#define FLITE_REG_CIGCTRL_INVPOLVSYNC			(1 << 13)
+#define FLITE_REG_CIGCTRL_INVPOLHREF			(1 << 12)
+#define FLITE_REG_CIGCTRL_IRQ_LASTEN0_ENABLE		(0 << 8)
+#define FLITE_REG_CIGCTRL_IRQ_LASTEN0_DISABLE		(1 << 8)
+#define FLITE_REG_CIGCTRL_IRQ_ENDEN0_ENABLE		(0 << 7)
+#define FLITE_REG_CIGCTRL_IRQ_ENDEN0_DISABLE		(1 << 7)
+#define FLITE_REG_CIGCTRL_IRQ_STARTEN0_ENABLE		(0 << 6)
+#define FLITE_REG_CIGCTRL_IRQ_STARTEN0_DISABLE		(1 << 6)
+#define FLITE_REG_CIGCTRL_IRQ_OVFEN0_ENABLE		(0 << 5)
+#define FLITE_REG_CIGCTRL_IRQ_OVFEN0_DISABLE		(1 << 5)
+#define FLITE_REG_CIGCTRL_SELCAM_MIPI			(1 << 3)
+
+/* Image Capture Enable */
+#define FLITE_REG_CIIMGCPT				0x08
+#define FLITE_REG_CIIMGCPT_IMGCPTEN			(1 << 31)
+#define FLITE_REG_CIIMGCPT_CPT_FREN			(1 << 25)
+#define FLITE_REG_CIIMGCPT_CPT_FRPTR(x)			((x) << 19)
+#define FLITE_REG_CIIMGCPT_CPT_MOD_FRCNT		(1 << 18)
+#define FLITE_REG_CIIMGCPT_CPT_MOD_FREN			(0 << 18)
+#define FLITE_REG_CIIMGCPT_CPT_FRCNT(x)			((x) << 10)
+
+/* Capture Sequence */
+#define FLITE_REG_CICPTSEQ				0x0C
+#define FLITE_REG_CPT_FRSEQ(x)				((x) << 0)
+
+/* Camera Window Offset */
+#define FLITE_REG_CIWDOFST				0x10
+#define FLITE_REG_CIWDOFST_WINOFSEN			(1 << 31)
+#define FLITE_REG_CIWDOFST_CLROVIY			(1 << 31)
+#define FLITE_REG_CIWDOFST_WINHOROFST(x)		((x) << 16)
+#define FLITE_REG_CIWDOFST_HOROFF_MASK			(0x1fff << 16)
+#define FLITE_REG_CIWDOFST_CLROVFICB			(1 << 15)
+#define FLITE_REG_CIWDOFST_CLROVFICR			(1 << 14)
+#define FLITE_REG_CIWDOFST_WINVEROFST(x)		((x) << 0)
+#define FLITE_REG_CIWDOFST_VEROFF_MASK			(0x1fff << 0)
+
+/* Cmaera Window Offset2 */
+#define FLITE_REG_CIWDOFST2				0x14
+#define FLITE_REG_CIWDOFST2_WINHOROFST2(x)		((x) << 16)
+#define FLITE_REG_CIWDOFST2_WINVEROFST2(x)		((x) << 0)
+
+/* Camera Output DMA Format */
+#define FLITE_REG_CIODMAFMT				0x18
+#define FLITE_REG_CIODMAFMT_1D_DMA			(1 << 15)
+#define FLITE_REG_CIODMAFMT_2D_DMA			(0 << 15)
+#define FLITE_REG_CIODMAFMT_PACK12			(1 << 14)
+#define FLITE_REG_CIODMAFMT_NORMAL			(0 << 14)
+#define FLITE_REG_CIODMAFMT_CRYCBY			(0 << 4)
+#define FLITE_REG_CIODMAFMT_CBYCRY			(1 << 4)
+#define FLITE_REG_CIODMAFMT_YCRYCB			(2 << 4)
+#define FLITE_REG_CIODMAFMT_YCBYCR			(3 << 4)
+
+/* Camera Output Canvas */
+#define FLITE_REG_CIOCAN				0x20
+#define FLITE_REG_CIOCAN_OCAN_V(x)			((x) << 16)
+#define FLITE_REG_CIOCAN_OCAN_H(x)			((x) << 0)
+
+/* Camera Output DMA Offset */
+#define FLITE_REG_CIOOFF				0x24
+#define FLITE_REG_CIOOFF_OOFF_V(x)			((x) << 16)
+#define FLITE_REG_CIOOFF_OOFF_H(x)			((x) << 0)
+
+/* Camera Output DMA Address */
+#define FLITE_REG_CIOSA					0x30
+
+/* Camera Status */
+#define FLITE_REG_CISTATUS				0x40
+#define FLITE_REG_CISTATUS_MIPI_VVALID			(1 << 22)
+#define FLITE_REG_CISTATUS_MIPI_HVALID			(1 << 21)
+#define FLITE_REG_CISTATUS_MIPI_DVALID			(1 << 20)
+#define FLITE_REG_CISTATUS_ITU_VSYNC			(1 << 14)
+#define FLITE_REG_CISTATUS_ITU_HREFF			(1 << 13)
+#define FLITE_REG_CISTATUS_OVFIY			(1 << 10)
+#define FLITE_REG_CISTATUS_OVFICB			(1 << 9)
+#define FLITE_REG_CISTATUS_OVFICR			(1 << 8)
+#define FLITE_REG_CISTATUS_IRQ_SRC_OVERFLOW		(1 << 7)
+#define FLITE_REG_CISTATUS_IRQ_SRC_LASTCAPEND		(1 << 6)
+#define FLITE_REG_CISTATUS_IRQ_SRC_FRMSTART		(1 << 5)
+#define FLITE_REG_CISTATUS_IRQ_SRC_FRMEND		(1 << 4)
+#define FLITE_REG_CISTATUS_IRQ_CAM			(1 << 0)
+#define FLITE_REG_CISTATUS_IRQ_MASK			(0xf << 4)
+/* Camera Status2 */
+#define FLITE_REG_CISTATUS2				0x44
+#define FLITE_REG_CISTATUS2_LASTCAPEND			(1 << 1)
+#define FLITE_REG_CISTATUS2_FRMEND			(1 << 0)
+
+/* Qos Threshold */
+#define FLITE_REG_CITHOLD				0xF0
+#define FLITE_REG_CITHOLD_W_QOS_EN			(1 << 30)
+#define FLITE_REG_CITHOLD_WTH_QOS(x)			((x) << 0)
+
+/* Camera General Purpose */
+#define FLITE_REG_CIGENERAL				0xFC
+#define FLITE_REG_CIGENERAL_CAM_A			(0 << 0)
+#define FLITE_REG_CIGENERAL_CAM_B			(1 << 0)
+
+#endif /* FIMC_LITE_REG_H */
diff --git a/include/media/exynos_camera.h b/include/media/exynos_camera.h
new file mode 100644
index 0000000..e7fafd1
--- /dev/null
+++ b/include/media/exynos_camera.h
@@ -0,0 +1,59 @@
+/* include/media/exynos_camera.h
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * The header file related to camera
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef EXYNOS_CAMERA_H_
+#define EXYNOS_CAMERA_H_
+
+#include <media/exynos_mc.h>
+
+enum cam_bus_type {
+	CAM_TYPE_ITU = 1,
+	CAM_TYPE_MIPI,
+};
+
+enum cam_port {
+	CAM_PORT_A,
+	CAM_PORT_B,
+};
+
+#define CAM_CLK_INV_PCLK	(1 << 0)
+#define CAM_CLK_INV_VSYNC	(1 << 1)
+#define CAM_CLK_INV_HREF	(1 << 2)
+#define CAM_CLK_INV_HSYNC	(1 << 3)
+
+struct i2c_board_info;
+
+/**
+ * struct exynos_isp_info - image sensor information required for host
+ *			      interface configuration.
+ *
+ * @board_info: pointer to I2C subdevice's board info
+ * @clk_frequency: frequency of the clock the host interface provides to sensor
+ * @bus_type: determines bus type, MIPI, ITU-R BT.601 etc.
+ * @csi_data_align: MIPI-CSI interface data alignment in bits
+ * @i2c_bus_num: i2c control bus id the sensor is attached to
+ * @mux_id: FIMC camera interface multiplexer index (separate for MIPI and ITU)
+ * @flags: flags defining bus signals polarity inversion (High by default)
+ * @use_cam: a means of used by GSCALER
+ */
+struct exynos_isp_info {
+	struct i2c_board_info *board_info;
+	unsigned long clk_frequency;
+	const char *cam_srclk_name;
+	const char *cam_clk_name;
+	enum cam_bus_type bus_type;
+	u16 csi_data_align;
+	u16 i2c_bus_num;
+	enum cam_port cam_port;
+	u16 flags;
+};
+#endif /* EXYNOS_CAMERA_H_ */
diff --git a/include/media/exynos_flite.h b/include/media/exynos_flite.h
new file mode 100644
index 0000000..789e040
--- /dev/null
+++ b/include/media/exynos_flite.h
@@ -0,0 +1,39 @@
+/*
+ * Samsung S5P SoC camera interface driver header
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef EXYNOS_FLITE_H_
+#define EXYNOS_FLITE_H_
+
+#include <media/exynos_camera.h>
+
+struct s3c_platform_camera {
+	enum cam_bus_type type;
+	bool use_isp;
+	int inv_pclk;
+	int inv_vsync;
+	int inv_href;
+	int inv_hsync;
+};
+
+/**
+ * struct exynos_platform_flite - camera host interface platform data
+ *
+ * @cam: properties of camera sensor required for host interface setup
+ */
+struct exynos_platform_flite {
+	struct s3c_platform_camera *cam[MAX_CAMIF_CLIENTS];
+	struct exynos_isp_info *isp_info[MAX_CAMIF_CLIENTS];
+	u32 active_cam_index;
+	u32 num_clients;
+};
+
+extern struct exynos_platform_flite exynos_flite0_default_data;
+extern struct exynos_platform_flite exynos_flite1_default_data;
+#endif /* EXYNOS_FLITE_H_*/
-- 
1.7.1


