Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:36945 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759939Ab2D0JxT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 05:53:19 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3400ACNU534Q00@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 10:53:27 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3400367U4SPW@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 10:53:17 +0100 (BST)
Date: Fri, 27 Apr 2012 11:53:04 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 11/13] s5p-fimc: Add support for Exynos4x12 FIMC-LITE
In-reply-to: <1335520386-20835-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	sungchun.kang@samsung.com, subash.ramaswamy@linaro.org,
	s.nawrocki@samsung.com
Message-id: <1335520386-20835-12-git-send-email-s.nawrocki@samsung.com>
References: <1335520386-20835-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds driver for FIMC-LITE camera host interface. This new IP
differs from the regular FIMC IP in that it doesn't have input DMA,
scaler and color space conversion support. So it just plain camera host
interface for MIPI-CSI2 and ITU-R interfaces. For the serial bus support
it interworks with MIPI-CSIS and the exisiting s5p-csis driver.
The FIMC-LITE and MIPI-CSIS drivers can also be reused in the Exynos5
SoC series.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/Kconfig                 |   24 +-
 drivers/media/video/s5p-fimc/Kconfig        |   47 +
 drivers/media/video/s5p-fimc/Makefile       |    4 +-
 drivers/media/video/s5p-fimc/fimc-core.h    |    1 +
 drivers/media/video/s5p-fimc/fimc-lite.c    | 1589 +++++++++++++++++++++++++++
 drivers/media/video/s5p-fimc/fimc-mdevice.c |  152 ++-
 drivers/media/video/s5p-fimc/fimc-mdevice.h |    5 +-
 7 files changed, 1778 insertions(+), 44 deletions(-)
 create mode 100644 drivers/media/video/s5p-fimc/Kconfig
 create mode 100644 drivers/media/video/s5p-fimc/fimc-lite.c

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index f2479c5..2885516 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -1127,19 +1127,6 @@ config VIDEO_MX2
 	  This is a v4l2 driver for the i.MX27 and the i.MX25 Camera Sensor
 	  Interface
 
-config  VIDEO_SAMSUNG_S5P_FIMC
-	tristate "Samsung S5P and EXYNOS4 camera interface driver (EXPERIMENTAL)"
-	depends on VIDEO_V4L2 && I2C && PLAT_S5P && PM_RUNTIME && \
-		VIDEO_V4L2_SUBDEV_API && EXPERIMENTAL
-	select VIDEOBUF2_DMA_CONTIG
-	select V4L2_MEM2MEM_DEV
-	---help---
-	  This is a v4l2 driver for Samsung S5P and EXYNOS4 camera
-	  host interface and video postprocessor.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called s5p-fimc.
-
 config VIDEO_ATMEL_ISI
 	tristate "ATMEL Image Sensor Interface (ISI) support"
 	depends on VIDEO_DEV && SOC_CAMERA && ARCH_AT91
@@ -1148,16 +1135,7 @@ config VIDEO_ATMEL_ISI
 	  This module makes the ATMEL Image Sensor Interface available
 	  as a v4l2 device.
 
-config VIDEO_S5P_MIPI_CSIS
-	tristate "Samsung S5P and EXYNOS4 MIPI CSI receiver driver"
-	depends on VIDEO_V4L2 && PM_RUNTIME && PLAT_S5P
-	depends on VIDEO_V4L2_SUBDEV_API && REGULATOR
-	---help---
-	  This is a v4l2 driver for Samsung S5P/EXYNOS4 MIPI-CSI receiver.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called s5p-csis.
-
+source "drivers/media/video/s5p-fimc/Kconfig"
 source "drivers/media/video/s5p-tv/Kconfig"
 
 endif # V4L_PLATFORM_DRIVERS
diff --git a/drivers/media/video/s5p-fimc/Kconfig b/drivers/media/video/s5p-fimc/Kconfig
new file mode 100644
index 0000000..383458f
--- /dev/null
+++ b/drivers/media/video/s5p-fimc/Kconfig
@@ -0,0 +1,47 @@
+
+config VIDEO_SAMSUNG_S5P_FIMC
+	bool "Samsung S5P/EXYNOS SoC camera interface driver (experimental)"
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && PLAT_S5P && PM_RUNTIME
+	depends on EXPERIMENTAL
+	help
+	  Say Y here to enable camera host interface devices for
+	  Samsung S5P and EXYNOS SoC series.
+
+if VIDEO_SAMSUNG_S5P_FIMC
+
+config VIDEO_S5P_FIMC
+	tristate "S5P/EXYNOS4 FIMC/CAMIF camera interface driver"
+	depends on I2C
+	select VIDEOBUF2_DMA_CONTIG
+	select V4L2_MEM2MEM_DEV
+	help
+	  This is a V4L2 driver for Samsung S5P and EXYNOS4 SoC camera host
+	  interface and video postprocessor (FIMC and FIMC-LITE) devices.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called s5p-fimc.
+
+config VIDEO_S5P_MIPI_CSIS
+	tristate "S5P/EXYNOS MIPI-CSI2 receiver (MIPI-CSIS) driver"
+	depends on REGULATOR
+	help
+	  This is a V4L2 driver for Samsung S5P and EXYNOS4 SoC MIPI-CSI2
+	  receiver (MIPI-CSIS) devices.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called s5p-csis.
+
+if ARCH_EXYNOS
+
+config VIDEO_EXYNOS_FIMC_LITE
+	tristate "EXYNOS FIMC-LITE camera interface driver"
+	depends on I2C
+	help
+	  This is a V4L2 driver for Samsung EXYNOS4/5 SoC FIMC-LITE camera
+	  host interface.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called exynos-fimc-lite.
+endif
+
+endif # VIDEO_SAMSUNG_S5P_FIMC
diff --git a/drivers/media/video/s5p-fimc/Makefile b/drivers/media/video/s5p-fimc/Makefile
index 1da3c6a..4648514 100644
--- a/drivers/media/video/s5p-fimc/Makefile
+++ b/drivers/media/video/s5p-fimc/Makefile
@@ -1,5 +1,7 @@
 s5p-fimc-objs := fimc-core.o fimc-reg.o fimc-m2m.o fimc-capture.o fimc-mdevice.o
+exynos-fimc-lite-objs += fimc-lite-reg.o fimc-lite.o
 s5p-csis-objs := mipi-csis.o
 
 obj-$(CONFIG_VIDEO_S5P_MIPI_CSIS)	+= s5p-csis.o
-obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC)	+= s5p-fimc.o
+obj-$(CONFIG_VIDEO_EXYNOS_FIMC_LITE)	+= exynos-fimc-lite.o
+obj-$(CONFIG_VIDEO_S5P_FIMC)		+= s5p-fimc.o
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index cbd1137..c42bbc9 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -17,6 +17,7 @@
 #include <linux/types.h>
 #include <linux/videodev2.h>
 #include <linux/io.h>
+#include <asm/sizes.h>
 
 #include <media/media-entity.h>
 #include <media/videobuf2-core.h>
diff --git a/drivers/media/video/s5p-fimc/fimc-lite.c b/drivers/media/video/s5p-fimc/fimc-lite.c
new file mode 100644
index 0000000..6b6063e
--- /dev/null
+++ b/drivers/media/video/s5p-fimc/fimc-lite.c
@@ -0,0 +1,1589 @@
+/*
+ * Samsung EXYNOS FIMC-LITE (camera host interface) driver
+*
+ * Copyright (C) 2012 Samsung Electronics Co., Ltd.
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#define pr_fmt(fmt) "%s:%d " fmt, __func__, __LINE__
+
+#include <linux/bug.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/videodev2.h>
+
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "fimc-mdevice.h"
+#include "fimc-core.h"
+#include "fimc-lite-reg.h"
+
+static int debug;
+module_param(debug, int, 0644);
+
+static struct fimc_fmt fimc_lite_formats[] = {
+	{
+		.name		= "YUV 4:2:2 packed, YCbYCr",
+		.fourcc		= V4L2_PIX_FMT_YUYV,
+		.depth		= { 16 },
+		.color		= FIMC_FMT_YCBYCR422,
+		.memplanes	= 1,
+		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
+	}, {
+		.name		= "YUV 4:2:2 packed, CbYCrY",
+		.fourcc		= V4L2_PIX_FMT_UYVY,
+		.depth		= { 16 },
+		.color		= FIMC_FMT_CBYCRY422,
+		.memplanes	= 1,
+		.mbus_code	= V4L2_MBUS_FMT_UYVY8_2X8,
+	}, {
+		.name		= "YUV 4:2:2 packed, CrYCbY",
+		.fourcc		= V4L2_PIX_FMT_VYUY,
+		.depth		= { 16 },
+		.color		= FIMC_FMT_CRYCBY422,
+		.memplanes	= 1,
+		.mbus_code	= V4L2_MBUS_FMT_VYUY8_2X8,
+	}, {
+		.name		= "YUV 4:2:2 packed, YCrYCb",
+		.fourcc		= V4L2_PIX_FMT_YVYU,
+		.depth		= { 16 },
+		.color		= FIMC_FMT_YCRYCB422,
+		.memplanes	= 1,
+		.mbus_code	= V4L2_MBUS_FMT_YVYU8_2X8,
+	}, {
+		.name		= "RAW8 (GRBG)",
+		.fourcc		= V4L2_PIX_FMT_SGRBG8,
+		.depth		= { 8 },
+		.color		= FIMC_FMT_RAW8,
+		.memplanes	= 1,
+		.mbus_code	= V4L2_MBUS_FMT_SGRBG8_1X8,
+	}, {
+		.name		= "RAW10 (GRBG)",
+		.fourcc		= V4L2_PIX_FMT_SGRBG10,
+		.depth		= { 10 },
+		.color		= FIMC_FMT_RAW10,
+		.memplanes	= 1,
+		.mbus_code	= V4L2_MBUS_FMT_SGRBG10_1X10,
+	}, {
+		.name		= "RAW12 (GRBG)",
+		.fourcc		= V4L2_PIX_FMT_SGRBG12,
+		.depth		= { 12 },
+		.color		= FIMC_FMT_RAW12,
+		.memplanes	= 1,
+		.mbus_code	= V4L2_MBUS_FMT_SGRBG12_1X12,
+	},
+};
+
+void fimc_lite_fill_pix_format(struct v4l2_pix_format_mplane *pix,
+			       struct fimc_fmt *fmt, u32 width, u32 height)
+{
+	struct v4l2_plane_pix_format *plane_fmt = pix->plane_fmt;
+	u32 *sizeimage = &plane_fmt[0].sizeimage;
+	u32 bpl = plane_fmt[0].bytesperline;
+
+	if ((bpl == 0 || ((bpl * 8) / fmt->depth[0]) < pix->width))
+		plane_fmt[0].bytesperline = (pix->width * fmt->depth[0]) / 8;
+
+	if (*sizeimage == 0)
+		*sizeimage = (pix->width * pix->height * fmt->depth[0]) / 8;
+	pix->colorspace	= V4L2_COLORSPACE_JPEG;
+	pix->field = V4L2_FIELD_NONE;
+	pix->num_planes = fmt->memplanes;
+	pix->pixelformat = fmt->fourcc;
+	pix->height = height;
+	pix->width = width;
+}
+
+/**
+ * fimc_lite_find_format - lookup fimc color format by fourcc or media bus code
+ * @pixelformat: fourcc to match, ignored if null
+ * @mbus_code: media bus code to match, ignored if null
+ * @index: offset in the fimc_formats array, ignored if negative
+ */
+struct fimc_fmt *fimc_lite_find_format(const u32 *pixelformat,
+				       const u32 *mbus_code, int index)
+{
+	struct fimc_fmt *fmt, *def_fmt = NULL;
+	unsigned int i;
+	int id = 0;
+
+	if (index >= (int)ARRAY_SIZE(fimc_lite_formats))
+		return NULL;
+
+	for (i = 0; i < ARRAY_SIZE(fimc_lite_formats); ++i) {
+		fmt = &fimc_lite_formats[i];
+		if (pixelformat && fmt->fourcc == *pixelformat)
+			return fmt;
+		if (mbus_code && fmt->mbus_code == *mbus_code)
+			return fmt;
+		if (index == id)
+			def_fmt = fmt;
+		id++;
+	}
+	return def_fmt;
+}
+
+static int fimc_lite_hw_init(struct fimc_lite *fimc)
+{
+	struct fimc_pipeline *pipeline = &fimc->pipeline;
+	struct fimc_sensor_info *sensor;
+	unsigned long flags;
+	int ret = 0;
+
+	if (pipeline->subdevs[IDX_SENSOR] == NULL)
+		return -ENXIO;
+
+	if (fimc->fmt == NULL)
+		return -EINVAL;
+
+	sensor = v4l2_get_subdev_hostdata(pipeline->subdevs[IDX_SENSOR]);
+	spin_lock_irqsave(&fimc->slock, flags);
+
+	flite_hw_set_camera_bus(fimc, sensor->pdata);
+	flite_hw_set_source_format(fimc, &fimc->inp_frame);
+	flite_hw_set_window_offset(fimc, &fimc->inp_frame);
+	flite_hw_set_output_dma(fimc, &fimc->out_frame, true);
+	flite_hw_set_interrupt_mask(fimc);
+
+	if (debug > 0)
+		flite_hw_dump_regs(fimc, __func__);
+
+	spin_unlock_irqrestore(&fimc->slock, flags);
+	return ret;
+}
+
+/*
+ * Reinitialize the driver so it is ready to start the streaming again.
+ * Set fimc->state to indicate stream off and the hardware shut down state.
+ * If not suspending (@suspend is false), return any buffers to videobuf2.
+ * Otherwise put any owned buffers onto the pending buffers queue, so they
+ * can be re-spun when the device is being resumed. Also perform FIMC
+ * software reset and disable streaming on the whole pipeline if required.
+ */
+static int fimc_lite_reinit(struct fimc_lite *fimc, bool suspend)
+{
+	struct flite_buffer *buf;
+	unsigned long flags;
+	bool streaming;
+
+	spin_lock_irqsave(&fimc->slock, flags);
+	streaming = fimc->state & (1 << ST_SENSOR_STREAM);
+
+	fimc->state &= ~(1 << ST_FLITE_RUN | 1 << ST_FLITE_OFF |
+			 1 << ST_FLITE_STREAM | 1 << ST_SENSOR_STREAM);
+	if (suspend)
+		fimc->state |= (1 << ST_FLITE_SUSPENDED);
+	else
+		fimc->state &= ~(1 << ST_FLITE_PENDING | 1 << ST_FLITE_SUSPENDED);
+
+	/* Release unused buffers */
+	while (!suspend && !list_empty(&fimc->pending_buf_q)) {
+		buf = fimc_lite_pending_queue_pop(fimc);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+	}
+	/* If suspending put unused buffers onto pending queue */
+	while (!list_empty(&fimc->active_buf_q)) {
+		buf = fimc_lite_active_queue_pop(fimc);
+		if (suspend)
+			fimc_lite_pending_queue_add(fimc, buf);
+		else
+			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+	}
+
+	spin_unlock_irqrestore(&fimc->slock, flags);
+
+	flite_hw_reset(fimc);
+
+	if (streaming)
+		return fimc_pipeline_s_stream(&fimc->pipeline, 0);
+
+	return 0;
+}
+
+static int fimc_lite_stop_capture(struct fimc_lite *fimc, bool suspend)
+{
+	unsigned long flags;
+
+	if (!fimc_lite_active(fimc))
+		return 0;
+
+	spin_lock_irqsave(&fimc->slock, flags);
+	set_bit(ST_FLITE_OFF, &fimc->state);
+	flite_hw_capture_stop(fimc);
+	spin_unlock_irqrestore(&fimc->slock, flags);
+
+	wait_event_timeout(fimc->irq_queue,
+			   !test_bit(ST_FLITE_OFF, &fimc->state),
+			   (2*HZ/10)); /* 200 ms */
+
+	return fimc_lite_reinit(fimc, suspend);
+}
+
+/* Must be called  with fimc.slock spinlock held. */
+static void fimc_lite_config_update(struct fimc_lite *fimc)
+{
+	flite_hw_set_window_offset(fimc, &fimc->inp_frame);
+	flite_hw_set_dma_window(fimc, &fimc->out_frame);
+	clear_bit(ST_FLITE_CONFIG, &fimc->state);
+}
+
+static irqreturn_t flite_irq_handler(int irq, void *priv)
+{
+	struct fimc_lite *fimc = priv;
+	struct flite_buffer *vbuf;
+	unsigned long flags;
+	struct timeval *tv;
+	struct timespec ts;
+	u32 intsrc;
+
+	spin_lock_irqsave(&fimc->slock, flags);
+
+	intsrc = flite_hw_get_interrupt_source(fimc);
+	flite_hw_clear_pending_irq(fimc);
+
+	if (test_and_clear_bit(ST_FLITE_OFF, &fimc->state)) {
+		wake_up(&fimc->irq_queue);
+		goto done;
+	}
+
+	if (intsrc & FLITE_REG_CISTATUS_IRQ_SRC_OVERFLOW) {
+		clear_bit(ST_FLITE_RUN, &fimc->state);
+		fimc->events.data_overflow++;
+	}
+
+	if (intsrc & FLITE_REG_CISTATUS_IRQ_SRC_LASTCAPEND) {
+		flite_hw_clear_last_capture_end(fimc);
+		v4l2_info(fimc->vfd, "last capture end");
+		clear_bit(ST_FLITE_STREAM, &fimc->state);
+		wake_up(&fimc->irq_queue);
+	}
+
+	if (fimc->out_path != FIMC_IO_DMA)
+		goto done;
+
+	if ((intsrc & FLITE_REG_CISTATUS_IRQ_SRC_FRMSTART) &&
+	    test_bit(ST_FLITE_RUN, &fimc->state) &&
+	    !list_empty(&fimc->active_buf_q) &&
+	    !list_empty(&fimc->pending_buf_q)) {
+		vbuf = fimc_lite_active_queue_pop(fimc);
+		ktime_get_ts(&ts);
+		tv = &vbuf->vb.v4l2_buf.timestamp;
+		tv->tv_sec = ts.tv_sec;
+		tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
+		vbuf->vb.v4l2_buf.sequence = fimc->frame_count++;
+		vb2_buffer_done(&vbuf->vb, VB2_BUF_STATE_DONE);
+
+		vbuf = fimc_lite_pending_queue_pop(fimc);
+		flite_hw_set_output_addr(fimc, vbuf->paddr);
+		fimc_lite_active_queue_add(fimc, vbuf);
+	}
+
+	if (test_bit(ST_FLITE_CONFIG, &fimc->state))
+		fimc_lite_config_update(fimc);
+
+	if (list_empty(&fimc->pending_buf_q)) {
+		flite_hw_capture_stop(fimc);
+		clear_bit(ST_FLITE_STREAM, &fimc->state);
+	}
+done:
+	set_bit(ST_FLITE_RUN, &fimc->state);
+	spin_unlock_irqrestore(&fimc->slock, flags);
+	return IRQ_HANDLED;
+}
+
+static int start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	struct fimc_lite *fimc = q->drv_priv;
+	int ret;
+
+	fimc->frame_count = 0;
+
+	ret = fimc_lite_hw_init(fimc);
+	if (ret) {
+		fimc_lite_reinit(fimc, false);
+		return ret;
+	}
+
+	set_bit(ST_FLITE_PENDING, &fimc->state);
+
+	if (!list_empty(&fimc->active_buf_q) &&
+	    !test_and_set_bit(ST_FLITE_STREAM, &fimc->state)) {
+		flite_hw_capture_start(fimc);
+
+		if (!test_and_set_bit(ST_SENSOR_STREAM, &fimc->state))
+			fimc_pipeline_s_stream(&fimc->pipeline, 1);
+	}
+	if (debug > 0)
+		flite_hw_dump_regs(fimc, __func__);
+
+	return 0;
+}
+
+static int stop_streaming(struct vb2_queue *q)
+{
+	struct fimc_lite *fimc = q->drv_priv;
+
+	if (!fimc_lite_active(fimc))
+		return -EINVAL;
+
+	return fimc_lite_stop_capture(fimc, false);
+}
+
+int fimc_lite_capture_suspend(struct fimc_lite *fimc)
+{
+	bool suspend = test_bit(ST_FLITE_IN_USE, &fimc->state);
+
+	int ret = fimc_lite_stop_capture(fimc, suspend);
+	if (ret)
+		return ret;
+	return fimc_pipeline_shutdown(&fimc->pipeline);
+}
+
+static void buffer_queue(struct vb2_buffer *vb);
+
+int fimc_lite_capture_resume(struct fimc_lite *fimc)
+{
+	struct flite_buffer *buf;
+	int i;
+
+	if (!test_and_clear_bit(ST_FLITE_SUSPENDED, &fimc->state))
+		return 0;
+
+	INIT_LIST_HEAD(&fimc->active_buf_q);
+	fimc_pipeline_initialize(&fimc->pipeline, &fimc->vfd->entity, false);
+	fimc_lite_hw_init(fimc);
+
+	clear_bit(ST_FLITE_SUSPENDED, &fimc->state);
+
+	for (i = 0; i < fimc->reqbufs_count; i++) {
+		if (list_empty(&fimc->pending_buf_q))
+			break;
+		buf = fimc_lite_pending_queue_pop(fimc);
+		buffer_queue(&buf->vb);
+	}
+	return 0;
+
+}
+
+static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
+		       unsigned int *num_buffers, unsigned int *num_planes,
+		       unsigned int sizes[], void *allocators[])
+{
+	const struct v4l2_pix_format_mplane *pixm = NULL;
+	struct fimc_lite *fimc = vq->drv_priv;
+	struct flite_frame *frame = &fimc->out_frame;
+	struct fimc_fmt *fmt = fimc->fmt;
+	unsigned long wh;
+	int i;
+
+	if (pfmt) {
+		pixm = &pfmt->fmt.pix_mp;
+		fmt = fimc_lite_find_format(&pixm->pixelformat, NULL, -1);
+		wh = pixm->width * pixm->height;
+	} else {
+		wh = frame->f_width * frame->f_height;
+	}
+
+	if (fmt == NULL)
+		return -EINVAL;
+
+	*num_planes = fmt->memplanes;
+
+	for (i = 0; i < fmt->memplanes; i++) {
+		unsigned int size = (wh * fmt->depth[i]) / 8;
+		if (pixm)
+			sizes[i] = max(size, pixm->plane_fmt[i].sizeimage);
+		else
+			sizes[i] = size;
+		allocators[i] = fimc->alloc_ctx;
+	}
+
+	return 0;
+}
+
+static int buffer_prepare(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct fimc_lite *fimc = vq->drv_priv;
+	int i;
+
+	if (fimc->fmt == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < fimc->fmt->memplanes; i++) {
+		unsigned long size = fimc->payload[i];
+
+		if (vb2_plane_size(vb, i) < size) {
+			v4l2_err(fimc->vfd,
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
+static void buffer_queue(struct vb2_buffer *vb)
+{
+	struct flite_buffer *buf
+		= container_of(vb, struct flite_buffer, vb);
+	struct fimc_lite *fimc = vb2_get_drv_priv(vb->vb2_queue);
+	unsigned long flags;
+
+	spin_lock_irqsave(&fimc->slock, flags);
+	buf->paddr = vb2_dma_contig_plane_dma_addr(vb, 0);
+
+	if (!test_bit(ST_FLITE_SUSPENDED, &fimc->state) &&
+	    !test_bit(ST_FLITE_STREAM, &fimc->state) &&
+	    list_empty(&fimc->active_buf_q)) {
+		flite_hw_set_output_addr(fimc, buf->paddr);
+		fimc_lite_active_queue_add(fimc, buf);
+	} else {
+		fimc_lite_pending_queue_add(fimc, buf);
+	}
+
+	if (vb2_is_streaming(&fimc->vb_queue) &&
+	    !list_empty(&fimc->pending_buf_q) &&
+	    !test_and_set_bit(ST_FLITE_STREAM, &fimc->state)) {
+		flite_hw_capture_start(fimc);
+		spin_unlock_irqrestore(&fimc->slock, flags);
+
+		if (!test_and_set_bit(ST_SENSOR_STREAM, &fimc->state))
+			fimc_pipeline_s_stream(&fimc->pipeline, 1);
+		return;
+	}
+	spin_unlock_irqrestore(&fimc->slock, flags);
+}
+
+static void fimc_lock(struct vb2_queue *vq)
+{
+	struct fimc_lite *fimc = vb2_get_drv_priv(vq);
+	mutex_lock(&fimc->lock);
+}
+
+static void fimc_unlock(struct vb2_queue *vq)
+{
+	struct fimc_lite *fimc = vb2_get_drv_priv(vq);
+	mutex_unlock(&fimc->lock);
+}
+
+static struct vb2_ops fimc_lite_qops = {
+	.queue_setup		= queue_setup,
+	.buf_prepare		= buffer_prepare,
+	.buf_queue		= buffer_queue,
+	.wait_prepare		= fimc_unlock,
+	.wait_finish		= fimc_lock,
+	.start_streaming	= start_streaming,
+	.stop_streaming		= stop_streaming,
+};
+
+static void fimc_lite_clear_event_counters(struct fimc_lite *fimc)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&fimc->slock, flags);
+	memset(&fimc->events, 0, sizeof(fimc->events));
+	spin_unlock_irqrestore(&fimc->slock, flags);
+}
+
+static int fimc_lite_open(struct file *file)
+{
+	struct fimc_lite *fimc = video_drvdata(file);
+	int ret = v4l2_fh_open(file);
+
+	if (ret)
+		return ret;
+
+	set_bit(ST_FLITE_IN_USE, &fimc->state);
+	pm_runtime_get_sync(&fimc->pdev->dev);
+
+	if (++fimc->ref_count != 1 || fimc->out_path != FIMC_IO_DMA)
+		return ret;
+
+	ret = fimc_pipeline_initialize(&fimc->pipeline, &fimc->vfd->entity,
+				       true);
+	if (ret < 0) {
+		v4l2_err(fimc->vfd, "Video pipeline initialization failed\n");
+		pm_runtime_put_sync(&fimc->pdev->dev);
+		fimc->ref_count--;
+		v4l2_fh_release(file);
+		clear_bit(ST_FLITE_IN_USE, &fimc->state);
+	}
+
+	fimc_lite_clear_event_counters(fimc);
+	return ret;
+}
+
+static int fimc_lite_close(struct file *file)
+{
+	struct fimc_lite *fimc = video_drvdata(file);
+
+	if (--fimc->ref_count == 0 && fimc->out_path == FIMC_IO_DMA) {
+		clear_bit(ST_FLITE_IN_USE, &fimc->state);
+		fimc_lite_stop_capture(fimc, false);
+		fimc_pipeline_shutdown(&fimc->pipeline);
+		clear_bit(ST_FLITE_SUSPENDED, &fimc->state);
+	}
+
+	pm_runtime_put(&fimc->pdev->dev);
+
+	if (fimc->ref_count == 0)
+		vb2_queue_release(&fimc->vb_queue);
+
+	return v4l2_fh_release(file);
+}
+
+static unsigned int fimc_lite_poll(struct file *file,
+				   struct poll_table_struct *wait)
+{
+	struct fimc_lite *fimc = video_drvdata(file);
+	return vb2_poll(&fimc->vb_queue, file, wait);
+}
+
+static int fimc_lite_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct fimc_lite *fimc = video_drvdata(file);
+	return vb2_mmap(&fimc->vb_queue, vma);
+}
+
+static const struct v4l2_file_operations fimc_lite_fops = {
+	.owner		= THIS_MODULE,
+	.open		= fimc_lite_open,
+	.release	= fimc_lite_close,
+	.poll		= fimc_lite_poll,
+	.unlocked_ioctl	= video_ioctl2,
+	.mmap		= fimc_lite_mmap,
+};
+
+/*
+ * Format and crop negotiation helpers
+ */
+
+static struct fimc_fmt *fimc_lite_try_format(struct fimc_lite *fimc,
+					     u32 *width, u32 *height,
+					     u32 *code, u32 *fourcc, int pad)
+{
+	struct flite_variant *variant = fimc->variant;
+	struct fimc_fmt *fmt;
+
+	fmt = fimc_lite_find_format(fourcc, code, 0);
+	if (WARN_ON(!fmt))
+		return NULL;
+
+	if (code)
+		*code = fmt->mbus_code;
+	if (fourcc)
+		*fourcc = fmt->fourcc;
+
+	if (pad == FLITE_SD_PAD_SINK) {
+		v4l_bound_align_image(width, 8, variant->max_width,
+				      ffs(variant->out_width_align) - 1,
+				      height, 0, variant->max_height, 0, 0);
+	} else {
+		v4l_bound_align_image(width, 8, fimc->inp_frame.rect.width,
+				      ffs(variant->out_width_align) - 1,
+				      height, 0, fimc->inp_frame.rect.height,
+				      0, 0);
+	}
+
+	v4l2_dbg(1, debug, &fimc->subdev, "code: 0x%x, %dx%d\n",
+		 code ? *code : 0, *width, *height);
+
+	return fmt;
+}
+
+static void fimc_lite_try_crop(struct fimc_lite *fimc, struct v4l2_rect *r)
+{
+	struct flite_frame *frame = &fimc->inp_frame;
+
+	v4l_bound_align_image(&r->width, 0, frame->f_width, 0,
+			      &r->height, 0, frame->f_height, 0, 0);
+
+	/* Adjust left/top if cropping rectangle got out of bounds */
+	r->left = clamp_t(u32, r->left, 0, frame->f_width - r->width);
+	r->left = round_down(r->left, fimc->variant->win_hor_offs_align);
+	r->top  = clamp_t(u32, r->top, 0, frame->f_height - r->height);
+
+	v4l2_dbg(1, debug, &fimc->subdev, "(%d,%d)/%dx%d, sink fmt: %dx%d",
+		 r->left, r->top, r->width, r->height,
+		 frame->f_width, frame->f_height);
+}
+
+static void fimc_lite_try_compose(struct fimc_lite *fimc, struct v4l2_rect *r)
+{
+	struct flite_frame *frame = &fimc->out_frame;
+	struct v4l2_rect *crop_rect = &fimc->inp_frame.rect;
+
+	/* Scaling is not supported so we enforce compose rectangle size
+	   same as size of the sink crop rectangle. */
+	r->width = crop_rect->width;
+	r->height = crop_rect->height;
+
+	/* Adjust left/top if the composing rectangle got out of bounds */
+	r->left = clamp_t(u32, r->left, 0, frame->f_width - r->width);
+	r->left = round_down(r->left, fimc->variant->out_hor_offs_align);
+	r->top  = clamp_t(u32, r->top, 0, fimc->out_frame.f_height - r->height);
+
+	v4l2_dbg(1, debug, &fimc->subdev, "(%d,%d)/%dx%d, source fmt: %dx%d",
+		 r->left, r->top, r->width, r->height,
+		 frame->f_width, frame->f_height);
+}
+
+/*
+ * Video node ioctl operations
+ */
+static int fimc_vidioc_querycap_capture(struct file *file, void *priv,
+					struct v4l2_capability *cap)
+{
+	strlcpy(cap->driver, FIMC_LITE_DRV_NAME, sizeof(cap->driver));
+	cap->bus_info[0] = 0;
+	cap->card[0] = 0;
+	cap->capabilities = V4L2_CAP_STREAMING;
+
+	return 0;
+}
+
+static int fimc_lite_enum_fmt_mplane(struct file *file, void *priv,
+				     struct v4l2_fmtdesc *f)
+{
+	struct fimc_fmt *fmt;
+
+	if (f->index >= ARRAY_SIZE(fimc_lite_formats))
+		return -EINVAL;
+
+	fmt = &fimc_lite_formats[f->index];
+	strlcpy(f->description, fmt->name, sizeof(f->description));
+	f->pixelformat = fmt->fourcc;
+
+	return 0;
+}
+
+static int fimc_lite_g_fmt_mplane(struct file *file, void *fh,
+				  struct v4l2_format *f)
+{
+	struct fimc_lite *fimc = video_drvdata(file);
+	struct v4l2_pix_format_mplane *pixm = &f->fmt.pix_mp;
+	struct v4l2_plane_pix_format *plane_fmt = &pixm->plane_fmt[0];
+	struct flite_frame *frame = &fimc->out_frame;
+	struct fimc_fmt *fmt = fimc->fmt;
+
+	plane_fmt->bytesperline = (frame->f_width * fmt->depth[0]) / 8;
+	plane_fmt->sizeimage = plane_fmt->bytesperline * frame->f_height;
+
+	pixm->num_planes = fmt->memplanes;
+	pixm->pixelformat = fmt->fourcc;
+	pixm->width = frame->f_width;
+	pixm->height = frame->f_height;
+	pixm->field = V4L2_FIELD_NONE;
+	pixm->colorspace = V4L2_COLORSPACE_JPEG;
+	return 0;
+}
+
+static int fimc_lite_try_fmt_mplane(struct file *file, void *fh,
+				    struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
+	struct fimc_lite *fimc = video_drvdata(file);
+	struct fimc_fmt *fmt;
+
+	fmt = fimc_lite_try_format(fimc, &pix->width, &pix->height, NULL,
+				   &pix->pixelformat, FLITE_SD_PAD_SOURCE);
+	if (fmt == NULL)
+		return -EINVAL;
+
+	fimc_lite_fill_pix_format(pix, fmt, pix->width, pix->height);
+	return 0;
+}
+
+static int fimc_lite_s_fmt_mplane(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	struct v4l2_pix_format_mplane *pixm = &f->fmt.pix_mp;
+	struct fimc_lite *fimc = video_drvdata(file);
+	struct flite_frame *frame = &fimc->out_frame;
+	unsigned int width = pixm->width;
+	unsigned int height = pixm->height;
+	struct fimc_fmt *fmt;
+	unsigned int size;
+
+	if (vb2_is_busy(&fimc->vb_queue))
+		return -EBUSY;
+
+	fmt = fimc_lite_try_format(fimc, &pixm->width, &pixm->height,
+				   NULL, &pixm->pixelformat,
+				   FLITE_SD_PAD_SOURCE);
+	if (fmt == NULL)
+		return -EINVAL;
+
+	fimc->fmt = fmt;
+	fimc_lite_fill_pix_format(pixm, fmt, width, height);
+	size = (width * height * fmt->depth[0]) / 8;
+	fimc->payload[0] = max(size, pixm->plane_fmt[0].sizeimage);
+	frame->f_width = width;
+	frame->f_height = height;
+
+	return 0;
+}
+
+static int fimc_pipeline_validate(struct fimc_lite *fimc)
+{
+	struct v4l2_subdev *sd = &fimc->subdev;
+	struct media_pad *pad = &fimc->vd_pad;
+	struct v4l2_subdev_format sink_fmt, src_fmt;
+	int ret;
+
+	while (1) {
+		/* Retrieve format at the sink pad */
+		pad = &sd->entity.pads[0];
+		if (!(pad->flags & MEDIA_PAD_FL_SINK))
+			break;
+		/* Don't call FIMC subdev operation to avoid nested locking */
+		if (sd == &fimc->subdev) {
+			struct flite_frame *ff = &fimc->out_frame;
+			sink_fmt.format.width = ff->f_width;
+			sink_fmt.format.height = ff->f_height;
+			sink_fmt.format.code = fimc->fmt->mbus_code;
+		} else {
+			sink_fmt.pad = pad->index;
+			sink_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+			ret = v4l2_subdev_call(sd, pad, get_fmt, NULL,
+					       &sink_fmt);
+			if (ret < 0 && ret != -ENOIOCTLCMD)
+				return -EPIPE;
+		}
+		/* Retrieve format at the source pad */
+		pad = media_entity_remote_source(pad);
+		if (pad == NULL ||
+		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+			break;
+
+		sd = media_entity_to_v4l2_subdev(pad->entity);
+		src_fmt.pad = pad->index;
+		src_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+		ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &src_fmt);
+		if (ret < 0 && ret != -ENOIOCTLCMD)
+			return -EPIPE;
+
+		if (src_fmt.format.width != sink_fmt.format.width ||
+		    src_fmt.format.height != sink_fmt.format.height ||
+		    src_fmt.format.code != sink_fmt.format.code)
+			return -EPIPE;
+	}
+	return 0;
+}
+
+static int fimc_lite_streamon(struct file *file, void *priv,
+			      enum v4l2_buf_type type)
+{
+	struct fimc_lite *fimc = video_drvdata(file);
+	struct v4l2_subdev *sensor = fimc->pipeline.subdevs[IDX_SENSOR];
+	struct fimc_pipeline *p = &fimc->pipeline;
+	int ret;
+
+	if (fimc_lite_active(fimc))
+		return -EBUSY;
+
+	media_entity_pipeline_start(&sensor->entity, p->m_pipeline);
+
+	ret = fimc_pipeline_validate(fimc);
+	if (ret) {
+		media_entity_pipeline_stop(&sensor->entity);
+		return ret;
+	}
+
+	return vb2_streamon(&fimc->vb_queue, type);
+}
+
+static int fimc_lite_streamoff(struct file *file, void *priv,
+			       enum v4l2_buf_type type)
+{
+	struct fimc_lite *fimc = video_drvdata(file);
+	struct v4l2_subdev *sd = fimc->pipeline.subdevs[IDX_SENSOR];
+	int ret;
+
+	ret = vb2_streamoff(&fimc->vb_queue, type);
+	if (ret == 0)
+		media_entity_pipeline_stop(&sd->entity);
+	return ret;
+}
+
+static int fimc_lite_reqbufs(struct file *file, void *priv,
+			     struct v4l2_requestbuffers *reqbufs)
+{
+	struct fimc_lite *fimc = video_drvdata(file);
+	int ret;
+
+	reqbufs->count = max_t(u32, FLITE_REQ_BUFS_MIN, reqbufs->count);
+	ret = vb2_reqbufs(&fimc->vb_queue, reqbufs);
+	if (!ret < 0)
+		fimc->reqbufs_count = reqbufs->count;
+
+	return ret;
+}
+
+static int fimc_lite_querybuf(struct file *file, void *priv,
+			      struct v4l2_buffer *buf)
+{
+	struct fimc_lite *fimc = video_drvdata(file);
+
+	return vb2_querybuf(&fimc->vb_queue, buf);
+}
+
+static int fimc_lite_qbuf(struct file *file, void *priv,
+			  struct v4l2_buffer *buf)
+{
+	struct fimc_lite *fimc = video_drvdata(file);
+
+	return vb2_qbuf(&fimc->vb_queue, buf);
+}
+
+static int fimc_lite_dqbuf(struct file *file, void *priv,
+			   struct v4l2_buffer *buf)
+{
+	struct fimc_lite *fimc = video_drvdata(file);
+
+	return vb2_dqbuf(&fimc->vb_queue, buf, file->f_flags & O_NONBLOCK);
+}
+
+static int fimc_lite_create_bufs(struct file *file, void *priv,
+				 struct v4l2_create_buffers *create)
+{
+	struct fimc_lite *fimc = video_drvdata(file);
+
+	return vb2_create_bufs(&fimc->vb_queue, create);
+}
+
+static int fimc_lite_prepare_buf(struct file *file, void *priv,
+				 struct v4l2_buffer *b)
+{
+	struct fimc_lite *fimc = video_drvdata(file);
+
+	return vb2_prepare_buf(&fimc->vb_queue, b);
+}
+
+/* Return 1 if rectangle a is enclosed in rectangle b, or 0 otherwise. */
+static int enclosed_rectangle(struct v4l2_rect *a, struct v4l2_rect *b)
+{
+	if (a->left < b->left || a->top < b->top)
+		return 0;
+	if (a->left + a->width > b->left + b->width)
+		return 0;
+	if (a->top + a->height > b->top + b->height)
+		return 0;
+
+	return 1;
+}
+
+static int fimc_lite_g_selection(struct file *file, void *fh,
+				 struct v4l2_selection *sel)
+{
+	struct fimc_lite *fimc = video_drvdata(file);
+	struct flite_frame *f = &fimc->out_frame;
+
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		return -EINVAL;
+
+	switch (sel->target) {
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+		sel->r.left = 0;
+		sel->r.top = 0;
+		sel->r.width = f->f_width;
+		sel->r.height = f->f_height;
+		return 0;
+
+	case V4L2_SEL_TGT_CROP_ACTIVE:
+		sel->r = f->rect;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static int fimc_lite_s_selection(struct file *file, void *fh,
+				 struct v4l2_selection *sel)
+{
+	struct fimc_lite *fimc = video_drvdata(file);
+	struct flite_frame *f = &fimc->out_frame;
+	struct v4l2_rect rect = sel->r;
+	unsigned long flags;
+
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE ||
+	    sel->target != V4L2_SEL_TGT_COMPOSE_ACTIVE)
+		return -EINVAL;
+
+	fimc_lite_try_compose(fimc, &rect);
+
+	if ((sel->flags & V4L2_SEL_FLAG_LE) &&
+	    !enclosed_rectangle(&rect, &sel->r))
+		return -ERANGE;
+
+	if ((sel->flags & V4L2_SEL_FLAG_GE) &&
+	    !enclosed_rectangle(&sel->r, &rect))
+		return -ERANGE;
+
+	sel->r = rect;
+	spin_lock_irqsave(&fimc->slock, flags);
+	f->rect = rect;
+	set_bit(ST_FLITE_CONFIG, &fimc->state);
+	spin_unlock_irqrestore(&fimc->slock, flags);
+
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops fimc_lite_ioctl_ops = {
+	.vidioc_querycap		= fimc_vidioc_querycap_capture,
+	.vidioc_enum_fmt_vid_cap_mplane	= fimc_lite_enum_fmt_mplane,
+	.vidioc_try_fmt_vid_cap_mplane	= fimc_lite_try_fmt_mplane,
+	.vidioc_s_fmt_vid_cap_mplane	= fimc_lite_s_fmt_mplane,
+	.vidioc_g_fmt_vid_cap_mplane	= fimc_lite_g_fmt_mplane,
+	.vidioc_g_selection		= fimc_lite_g_selection,
+	.vidioc_s_selection		= fimc_lite_s_selection,
+	.vidioc_reqbufs			= fimc_lite_reqbufs,
+	.vidioc_querybuf		= fimc_lite_querybuf,
+	.vidioc_prepare_buf		= fimc_lite_prepare_buf,
+	.vidioc_create_bufs		= fimc_lite_create_bufs,
+	.vidioc_qbuf			= fimc_lite_qbuf,
+	.vidioc_dqbuf			= fimc_lite_dqbuf,
+	.vidioc_streamon		= fimc_lite_streamon,
+	.vidioc_streamoff		= fimc_lite_streamoff,
+};
+
+/* Capture subdev media entity operations */
+static int fimc_lite_link_setup(struct media_entity *entity,
+				const struct media_pad *local,
+				const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
+	unsigned int remote_ent_type = media_entity_type(remote->entity);
+
+	if (WARN_ON(fimc == NULL))
+		return 0;
+
+	v4l2_dbg(1, debug, sd, "%s: %s --> %s, flags: 0x%x. source_id: 0x%x",
+		 __func__, local->entity->name, remote->entity->name,
+		 flags, fimc->source_subdev_grp_id);
+
+	switch (local->index) {
+	case FIMC_SD_PAD_SINK:
+		if (remote_ent_type != MEDIA_ENT_T_V4L2_SUBDEV)
+			return -EINVAL;
+
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (fimc->source_subdev_grp_id != 0)
+				return -EBUSY;
+			fimc->source_subdev_grp_id = sd->grp_id;
+			return 0;
+		}
+
+		fimc->source_subdev_grp_id = 0;
+		break;
+
+	case FIMC_SD_PAD_SOURCE:
+		if (!(flags & MEDIA_LNK_FL_ENABLED)) {
+			fimc->out_path = FIMC_IO_NONE;
+			return 0;
+		}
+		if (remote_ent_type == MEDIA_ENT_T_V4L2_SUBDEV)
+			fimc->out_path = FIMC_IO_ISP;
+		else
+			fimc->out_path = FIMC_IO_DMA;
+		break;
+
+	default:
+		v4l2_err(sd, "Invalid pad index\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct media_entity_operations fimc_lite_subdev_media_ops = {
+	.link_setup = fimc_lite_link_setup,
+};
+
+static int fimc_lite_subdev_enum_mbus_code(struct v4l2_subdev *sd,
+					   struct v4l2_subdev_fh *fh,
+					   struct v4l2_subdev_mbus_code_enum *code)
+{
+	struct fimc_fmt *fmt;
+
+	fmt = fimc_lite_find_format(NULL, NULL, code->index);
+	if (!fmt)
+		return -EINVAL;
+	code->code = fmt->mbus_code;
+	return 0;
+}
+
+static int fimc_lite_subdev_get_fmt(struct v4l2_subdev *sd,
+				    struct v4l2_subdev_fh *fh,
+				    struct v4l2_subdev_format *fmt)
+{
+	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *mf = &fmt->format;
+	struct flite_frame *f = &fimc->out_frame;
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
+		fmt->format = *mf;
+		return 0;
+	}
+	mf->colorspace = V4L2_COLORSPACE_JPEG;
+
+	mutex_lock(&fimc->lock);
+	mf->code = fimc->fmt->mbus_code;
+
+	if (fmt->pad == FLITE_SD_PAD_SINK) {
+		/* full camera input frame size */
+		mf->width = f->f_width;
+		mf->height = f->f_height;
+	} else {
+		/* crop size */
+		mf->width = f->rect.width;
+		mf->height = f->rect.height;
+	}
+	mutex_unlock(&fimc->lock);
+	return 0;
+}
+
+static int fimc_lite_subdev_set_fmt(struct v4l2_subdev *sd,
+				    struct v4l2_subdev_fh *fh,
+				    struct v4l2_subdev_format *fmt)
+{
+	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *mf = &fmt->format;
+	struct flite_frame *f = &fimc->inp_frame;
+	struct fimc_fmt *ffmt;
+	int ret = 0;
+
+	v4l2_dbg(1, debug, sd, "pad%d: code: 0x%x, %dx%d",
+		 fmt->pad, mf->code, mf->width, mf->height);
+
+	mutex_lock(&fimc->lock);
+	if ((fimc->out_path == FIMC_IO_ISP && sd->entity.stream_count > 0) ||
+	    (fimc->out_path == FIMC_IO_DMA && vb2_is_busy(&fimc->vb_queue))) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	ffmt = fimc_lite_try_format(fimc, &mf->width, &mf->height,
+				    &mf->code, NULL, fmt->pad);
+	mutex_unlock(&fimc->lock);
+	mf->colorspace = V4L2_COLORSPACE_JPEG;
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
+		*mf = fmt->format;
+		return 0;
+	}
+
+	mutex_lock(&fimc->lock);
+	if (fmt->pad == FLITE_SD_PAD_SINK) {
+		f->f_width = mf->width;
+		f->f_height = mf->height;
+		/* reset the crop rectangle */
+		f->rect.left = 0;
+		f->rect.top = 0;
+		f->rect.width = mf->width;
+		f->rect.height = mf->height;
+		fimc->fmt = ffmt;
+	} else {
+		/* Allow changing pixel code only on sink pad */
+		mf->code = fimc->fmt->mbus_code;
+		f->rect.width = mf->width;
+		f->rect.height = mf->height;
+	}
+
+unlock:
+	mutex_unlock(&fimc->lock);
+	return ret;
+}
+
+static int fimc_lite_subdev_get_selection(struct v4l2_subdev *sd,
+					  struct v4l2_subdev_fh *fh,
+					  struct v4l2_subdev_selection *sel)
+{
+	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
+	struct flite_frame *f = &fimc->out_frame;
+	int ret = 0;
+
+	if (sel->pad != FLITE_SD_PAD_SINK)
+		return -EINVAL;
+
+	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
+		sel->r = *v4l2_subdev_get_try_crop(fh, sel->pad);
+		return 0;
+	}
+
+	mutex_lock(&fimc->lock);
+	switch (sel->target) {
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+		sel->r.left = 0;
+		sel->r.top = 0;
+		sel->r.width = f->f_width;
+		sel->r.height = f->f_height;
+		break;
+	case V4L2_SEL_TGT_COMPOSE_ACTIVE:
+		sel->r = f->rect;
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	mutex_unlock(&fimc->lock);
+
+	v4l2_dbg(1, debug, sd, "(%d,%d) %dx%d, f_w: %d, f_h: %d",
+		 f->rect.left, f->rect.top, f->rect.width, f->rect.height,
+		 f->f_width, f->f_height);
+
+	return 0;
+}
+
+static int fimc_lite_subdev_set_selection(struct v4l2_subdev *sd,
+					  struct v4l2_subdev_fh *fh,
+					  struct v4l2_subdev_selection *sel)
+{
+	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
+	struct flite_frame *f = &fimc->out_frame;
+	int ret = 0;
+
+	if (sel->pad != FLITE_SD_PAD_SINK)
+		return -EINVAL;
+
+	fimc_lite_try_crop(fimc, &sel->r);
+
+	mutex_lock(&fimc->lock);
+	switch (sel->target) {
+	case V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS:
+		sel->r.left = 0;
+		sel->r.top = 0;
+		sel->r.width = f->f_width;
+		sel->r.height = f->f_height;
+		break;
+	case V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL:
+		if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
+			*v4l2_subdev_get_try_crop(fh, sel->pad) = sel->r;
+		} else {
+			unsigned long flags;
+			spin_lock_irqsave(&fimc->slock, flags);
+			f->rect = sel->r;
+			set_bit(ST_FLITE_CONFIG, &fimc->state);
+			spin_unlock_irqrestore(&fimc->slock, flags);
+		}
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	mutex_unlock(&fimc->lock);
+
+	v4l2_dbg(1, debug, sd, "(%d,%d) %dx%d, f_w: %d, f_h: %d",
+		 f->rect.left, f->rect.top, f->rect.width, f->rect.height,
+		 f->f_width, f->f_height);
+
+	return ret;
+}
+
+static int fimc_lite_subdev_s_stream(struct v4l2_subdev *sd, int on)
+{
+	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
+
+	if (fimc->out_path == FIMC_IO_DMA)
+		return -ENOIOCTLCMD;
+
+	/* TODO: */
+
+	return 0;
+}
+
+static int fimc_lite_subdev_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
+
+	if (fimc->out_path == FIMC_IO_DMA)
+		return -ENOIOCTLCMD;
+
+	/* TODO: */
+
+	return 0;
+}
+
+static int fimc_lite_log_status(struct v4l2_subdev *sd)
+{
+	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
+
+	flite_hw_dump_regs(fimc, __func__);
+	return 0;
+}
+
+static int fimc_lite_subdev_registered(struct v4l2_subdev *sd)
+{
+	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
+	struct vb2_queue *q = &fimc->vb_queue;
+	struct video_device *vfd;
+	int ret;
+
+	fimc->fmt = &fimc_lite_formats[0];
+	fimc->out_path = FIMC_IO_DMA;
+
+	vfd = video_device_alloc();
+	if (!vfd) {
+		v4l2_err(sd->v4l2_dev, "Failed to allocate video device\n");
+		return -ENOMEM;
+	}
+
+	snprintf(vfd->name, sizeof(vfd->name), "fimc-lite.%d.capture",
+		 fimc->id);
+
+	vfd->fops = &fimc_lite_fops;
+	vfd->ioctl_ops = &fimc_lite_ioctl_ops;
+	vfd->v4l2_dev = sd->v4l2_dev;
+	vfd->minor = -1;
+	vfd->release = video_device_release;
+	vfd->lock = &fimc->lock;
+	fimc->vfd = vfd;
+	fimc->ref_count = 0;
+	fimc->reqbufs_count = 0;
+
+	INIT_LIST_HEAD(&fimc->pending_buf_q);
+	INIT_LIST_HEAD(&fimc->active_buf_q);
+
+	memset(q, 0, sizeof(*q));
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	q->io_modes = VB2_MMAP | VB2_USERPTR;
+	q->ops = &fimc_lite_qops;
+	q->mem_ops = &vb2_dma_contig_memops;
+	q->buf_struct_size = sizeof(struct flite_buffer);
+	q->drv_priv = fimc;
+
+	vb2_queue_init(q);
+
+	fimc->vd_pad.flags = MEDIA_PAD_FL_SINK;
+	ret = media_entity_init(&vfd->entity, 1, &fimc->vd_pad, 0);
+	if (ret)
+		goto err;
+
+	video_set_drvdata(vfd, fimc);
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
+	if (ret)
+		goto err_vd;
+
+	v4l2_info(sd->v4l2_dev, "Registered %s as /dev/%s\n",
+		  vfd->name, video_device_node_name(vfd));
+	return 0;
+
+ err_vd:
+	media_entity_cleanup(&vfd->entity);
+ err:
+	video_device_release(vfd);
+	return ret;
+}
+
+static void fimc_lite_subdev_unregistered(struct v4l2_subdev *sd)
+{
+	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
+
+	if (fimc == NULL)
+		return;
+
+	if (fimc->vfd) {
+		video_unregister_device(fimc->vfd);
+		media_entity_cleanup(&fimc->vfd->entity);
+		fimc->vfd = NULL;
+	}
+}
+
+static const struct v4l2_subdev_internal_ops fimc_lite_subdev_internal_ops = {
+	.registered = fimc_lite_subdev_registered,
+	.unregistered = fimc_lite_subdev_unregistered,
+};
+
+static const struct v4l2_subdev_pad_ops fimc_lite_subdev_pad_ops = {
+	.enum_mbus_code = fimc_lite_subdev_enum_mbus_code,
+	.get_selection = fimc_lite_subdev_get_selection,
+	.set_selection = fimc_lite_subdev_set_selection,
+	.get_fmt = fimc_lite_subdev_get_fmt,
+	.set_fmt = fimc_lite_subdev_set_fmt,
+};
+
+static const struct v4l2_subdev_video_ops fimc_lite_subdev_video_ops = {
+	.s_stream = fimc_lite_subdev_s_stream,
+};
+
+static const struct v4l2_subdev_core_ops fimc_lite_core_ops = {
+	.s_power = fimc_lite_subdev_s_power,
+	.log_status = fimc_lite_log_status,
+};
+
+static struct v4l2_subdev_ops fimc_lite_subdev_ops = {
+	.core = &fimc_lite_core_ops,
+	.video = &fimc_lite_subdev_video_ops,
+	.pad = &fimc_lite_subdev_pad_ops,
+};
+
+static int fimc_lite_create_capture_subdev(struct fimc_lite *fimc)
+{
+	struct v4l2_subdev *sd = &fimc->subdev;
+	int ret;
+
+	v4l2_subdev_init(sd, &fimc_lite_subdev_ops);
+	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
+	snprintf(sd->name, sizeof(sd->name), "FIMC-LITE.%d", fimc->id);
+
+	fimc->subdev_pads[FIMC_SD_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	fimc->subdev_pads[FIMC_SD_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_init(&sd->entity, FIMC_SD_PADS_NUM,
+				fimc->subdev_pads, 0);
+	if (ret)
+		return ret;
+
+	sd->internal_ops = &fimc_lite_subdev_internal_ops;
+	sd->entity.ops = &fimc_lite_subdev_media_ops;
+	v4l2_set_subdevdata(sd, fimc);
+
+	return 0;
+}
+
+static void fimc_lite_unregister_capture_subdev(struct fimc_lite *fimc)
+{
+	struct v4l2_subdev *sd = &fimc->subdev;
+
+	v4l2_device_unregister_subdev(sd);
+	media_entity_cleanup(&sd->entity);
+	v4l2_set_subdevdata(sd, NULL);
+}
+
+static void fimc_lite_clk_put(struct fimc_lite *fimc)
+{
+	if (IS_ERR_OR_NULL(fimc->clock))
+		return;
+
+	clk_unprepare(fimc->clock);
+	clk_put(fimc->clock);
+	fimc->clock = NULL;
+}
+
+static int fimc_lite_clk_get(struct fimc_lite *fimc)
+{
+	int ret;
+
+	fimc->clock = clk_get(&fimc->pdev->dev, FLITE_CLK_NAME);
+	if (IS_ERR(fimc->clock))
+		return PTR_ERR(fimc->clock);
+
+	ret = clk_prepare(fimc->clock);
+	if (ret < 0) {
+		clk_put(fimc->clock);
+		fimc->clock = NULL;
+	}
+	return ret;
+}
+
+static int __devinit fimc_lite_probe(struct platform_device *pdev)
+{
+	struct flite_drvdata *drv_data = fimc_lite_get_drvdata(pdev);
+	struct fimc_lite *fimc;
+	struct resource *res;
+	int ret;
+
+	fimc = devm_kzalloc(&pdev->dev, sizeof(*fimc), GFP_KERNEL);
+	if (!fimc)
+		return -ENOMEM;
+
+	fimc->id = pdev->id;
+	fimc->variant = drv_data->variant[fimc->id];
+	fimc->pdev = pdev;
+
+	init_waitqueue_head(&fimc->irq_queue);
+	spin_lock_init(&fimc->slock);
+	mutex_init(&fimc->lock);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	fimc->regs = devm_request_and_ioremap(&pdev->dev, res);
+	if (fimc->regs == NULL) {
+		dev_err(&pdev->dev, "Failed to obtain io memory\n");
+		return -ENOENT;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "Failed to get IRQ resource\n");
+		return -ENXIO;
+	}
+
+	ret = fimc_lite_clk_get(fimc);
+	if (ret)
+		return ret;
+
+	platform_set_drvdata(pdev, fimc);
+
+	ret = devm_request_irq(&pdev->dev, res->start, flite_irq_handler,
+			       0, dev_name(&pdev->dev), fimc);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to install irq (%d)\n", ret);
+		goto err_clk;
+	}
+
+	pm_runtime_enable(&pdev->dev);
+	ret = pm_runtime_get_sync(&pdev->dev);
+	if (ret < 0)
+		goto err_clk;
+
+	fimc->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
+	if (IS_ERR(fimc->alloc_ctx)) {
+		ret = PTR_ERR(fimc->alloc_ctx);
+		goto err_pm;
+	}
+//	pm_runtime_put(&pdev->dev);
+
+	/* The video node will be created within the subdev's registered() op */
+	ret = fimc_lite_create_capture_subdev(fimc);
+	if (ret)
+		goto err_sd;
+
+	dev_dbg(&pdev->dev, "FIMC-LITE.%d registered successfully\n",
+		fimc->id);
+	return 0;
+
+err_sd:
+	fimc_lite_unregister_capture_subdev(fimc);
+err_pm:
+	pm_runtime_put(&pdev->dev);
+err_clk:
+	fimc_lite_clk_put(fimc);
+	return ret;
+}
+
+static int fimc_lite_runtime_resume(struct device *dev)
+{
+	struct fimc_lite *fimc = dev_get_drvdata(dev);
+
+	v4l2_dbg(1, debug, &fimc->subdev, "%s: fimc_lite.%d",
+		 __func__, fimc->id);
+	clk_enable(fimc->clock);
+	return 0;
+}
+
+static int fimc_lite_runtime_suspend(struct device *dev)
+{
+	struct fimc_lite *fimc = dev_get_drvdata(dev);
+
+	v4l2_dbg(1, debug, &fimc->subdev, "%s: fimc_lite.%d",
+		 __func__, fimc->id);
+
+	clk_disable(fimc->clock);
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int fimc_lite_resume(struct device *dev)
+{
+	struct fimc_lite *fimc = dev_get_drvdata(dev);
+	unsigned long flags;
+
+	dev_dbg(dev, "fimc_lite.%d: state: 0x%lx", fimc->id, fimc->state);
+
+	spin_lock_irqsave(&fimc->slock, flags);
+
+	if (!test_and_clear_bit(ST_LPM, &fimc->state) ||
+	    !test_bit(ST_FLITE_IN_USE, &fimc->state)) {
+		spin_unlock_irqrestore(&fimc->slock, flags);
+		return 0;
+	}
+	flite_hw_reset(fimc);
+
+	spin_unlock_irqrestore(&fimc->slock, flags);
+	return fimc_lite_capture_resume(fimc);
+}
+
+static int fimc_lite_suspend(struct device *dev)
+{
+	struct fimc_lite *fimc = dev_get_drvdata(dev);
+
+	dev_dbg(dev, "fimc_lite.%d: state: 0x%lx", fimc->id, fimc->state);
+
+	if (test_and_set_bit(ST_LPM, &fimc->state))
+		return 0;
+
+	return fimc_lite_capture_suspend(fimc);
+}
+#endif /* CONFIG_PM_SLEEP */
+
+static int __devexit fimc_lite_remove(struct platform_device *pdev)
+{
+	struct fimc_lite *fimc = platform_get_drvdata(pdev);
+	struct device *dev = &pdev->dev;
+
+	pm_runtime_disable(dev);
+	pm_runtime_set_suspended(dev);
+	fimc_lite_unregister_capture_subdev(fimc);
+	vb2_dma_contig_cleanup_ctx(fimc->alloc_ctx);
+	fimc_lite_clk_put(fimc);
+
+	dev_info(dev, "driver unloaded\n");
+	return 0;
+}
+
+static struct flite_variant fimc_lite0_variant_exynos4 = {
+	.max_width		= 8192,
+	.max_height		= 8192,
+	.out_width_align	= 8,
+	.win_hor_offs_align	= 2,
+	.out_hor_offs_align	= 8,
+};
+
+/* EXYNOS4212, EXYNOS4412 */
+static struct flite_drvdata fimc_lite_drvdata_exynos4 = {
+	.variant = {
+		[0] = &fimc_lite0_variant_exynos4,
+		[1] = &fimc_lite0_variant_exynos4,
+	},
+	.lclk_frequency	= 160000000UL,
+};
+
+static struct platform_device_id fimc_lite_driver_ids[] = {
+	{
+		.name		= "exynos-fimc-lite",
+		.driver_data	= (unsigned long)&fimc_lite_drvdata_exynos4,
+	},
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(platform, fimc_lite_driver_ids);
+
+static const struct dev_pm_ops fimc_lite_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(fimc_lite_suspend, fimc_lite_resume)
+	SET_RUNTIME_PM_OPS(fimc_lite_runtime_suspend, fimc_lite_runtime_resume,
+			   NULL)
+};
+
+static struct platform_driver fimc_lite_driver = {
+	.probe		= fimc_lite_probe,
+	.remove		= __devexit_p(fimc_lite_remove),
+	.id_table	= fimc_lite_driver_ids,
+	.driver = {
+		.name	= FIMC_LITE_DRV_NAME,
+		.owner	= THIS_MODULE,
+		.pm     = &fimc_lite_pm_ops,
+	}
+};
+module_platform_driver(fimc_lite_driver);
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" FIMC_LITE_DRV_NAME);
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
index d6b26b1..61eea88 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -66,6 +66,9 @@ void fimc_pipeline_prepare(struct fimc_pipeline *p, struct media_entity *me)
 		case CSIS_GROUP_ID:
 			p->subdevs[IDX_CSIS] = sd;
 			break;
+		case FLITE_GROUP_ID:
+			p->subdevs[IDX_FLITE] = sd;
+			break;
 		case FIMC_GROUP_ID:
 			/* No need to control FIMC subdev through subdev ops */
 			break;
@@ -336,6 +339,7 @@ static int fimc_register_callback(struct device *dev, void *p)
 
 	if (!fimc || !fimc->pdev)
 		return 0;
+
 	if (fimc->pdev->id < 0 || fimc->pdev->id >= FIMC_MAX_DEVS)
 		return 0;
 
@@ -351,6 +355,31 @@ static int fimc_register_callback(struct device *dev, void *p)
 	return ret;
 }
 
+static int fimc_lite_register_callback(struct device *dev, void *p)
+{
+	struct fimc_lite *fimc = dev_get_drvdata(dev);
+	struct v4l2_subdev *sd = &fimc->subdev;
+	struct fimc_md *fmd = p;
+	int id, ret;
+
+	if (!fimc || !fimc->pdev)
+		return 0;
+
+	id = fimc->pdev->id;
+	if (id < 0 || id >= FIMC_LITE_MAX_DEVS)
+		return 0;
+
+	fmd->fimc_lite[id] = fimc;
+	sd->grp_id = FLITE_GROUP_ID;
+	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
+	if (ret) {
+		v4l2_err(&fmd->v4l2_dev,
+			 "Failed to register FIMC-LITE.%d (%d)\n",
+			 fimc->id, ret);
+	}
+	return ret;
+}
+
 static int csis_register_callback(struct device *dev, void *p)
 {
 	struct v4l2_subdev *sd = dev_get_drvdata(dev);
@@ -396,6 +425,15 @@ static int fimc_md_register_platform_entities(struct fimc_md *fmd)
 				     fimc_register_callback);
 	if (ret)
 		return ret;
+
+	driver = driver_find(FIMC_LITE_DRV_NAME, &platform_bus_type);
+	if (driver) {
+		ret = driver_for_each_device(driver, NULL, fmd,
+					     fimc_lite_register_callback);
+		put_driver(driver);
+		if (ret)
+			return ret;
+	}
 	/*
 	 * Check if there is any sensor on the MIPI-CSI2 bus and
 	 * if not skip the s5p-csis module loading.
@@ -431,6 +469,12 @@ static void fimc_md_unregister_entities(struct fimc_md *fmd)
 		v4l2_device_unregister_subdev(&fmd->fimc[i]->vid_cap.subdev);
 		fmd->fimc[i] = NULL;
 	}
+	for (i = 0; i < FIMC_LITE_MAX_DEVS; i++) {
+		if (fmd->fimc_lite[i] == NULL)
+			continue;
+		v4l2_device_unregister_subdev(&fmd->fimc_lite[i]->subdev);
+		fmd->fimc_lite[i] = NULL;
+	}
 	for (i = 0; i < CSIS_MAX_ENTITIES; i++) {
 		if (fmd->csis[i].sd == NULL)
 			continue;
@@ -454,28 +498,28 @@ static void fimc_md_unregister_entities(struct fimc_md *fmd)
  * @pad: the source entity pad index
  * @fimc_id: index of the fimc device for which link should be enabled
  */
-static int __fimc_md_create_fimc_links(struct fimc_md *fmd,
-				       struct media_entity *source,
-				       struct v4l2_subdev *sensor,
-				       int pad, int fimc_id)
+static int __fimc_md_create_fimc_sink_links(struct fimc_md *fmd,
+					    struct media_entity *source,
+					    struct v4l2_subdev *sensor,
+					    int pad, int fimc_id)
 {
 	struct fimc_sensor_info *s_info;
 	struct media_entity *sink;
-	unsigned int flags;
+	unsigned int flags = 0;
 	int ret, i;
 
 	for (i = 0; i < FIMC_MAX_DEVS; i++) {
 		if (!fmd->fimc[i])
-			break;
+			continue;
 		/*
 		 * Some FIMC variants are not fitted with camera capture
 		 * interface. Skip creating a link from sensor for those.
 		 */
-		if (sensor->grp_id == SENSOR_GROUP_ID &&
-		    !fmd->fimc[i]->variant->has_cam_if)
+		if (!fmd->fimc[i]->variant->has_cam_if)
 			continue;
 
 		flags = (i == fimc_id) ? MEDIA_LNK_FL_ENABLED : 0;
+
 		sink = &fmd->fimc[i]->vid_cap.subdev.entity;
 		ret = media_entity_create_link(source, pad, sink,
 					      FIMC_SD_PAD_SINK, flags);
@@ -491,7 +535,7 @@ static int __fimc_md_create_fimc_links(struct fimc_md *fmd,
 		v4l2_info(&fmd->v4l2_dev, "created link [%s] %c> [%s]",
 			  source->name, flags ? '=' : '-', sink->name);
 
-		if (flags == 0)
+		if (flags == 0 || sensor == NULL)
 			continue;
 		s_info = v4l2_get_subdev_hostdata(sensor);
 		if (!WARN_ON(s_info == NULL)) {
@@ -501,9 +545,55 @@ static int __fimc_md_create_fimc_links(struct fimc_md *fmd,
 			spin_unlock_irqrestore(&fmd->slock, irq_flags);
 		}
 	}
+
+	for (i = 0; i < FIMC_LITE_MAX_DEVS; i++) {
+		if (!fmd->fimc_lite[i])
+			continue;
+
+		flags = (i == fimc_id) ? MEDIA_LNK_FL_ENABLED : 0;
+
+		sink = &fmd->fimc_lite[i]->subdev.entity;
+		ret = media_entity_create_link(source, pad, sink,
+					       FLITE_SD_PAD_SINK, flags);
+		if (ret)
+			return ret;
+
+		/* Notify FIMC-LITE subdev entity */
+		ret = media_entity_call(sink, link_setup, &sink->pads[0],
+					&source->pads[pad], flags);
+		if (ret)
+			break;
+
+		v4l2_info(&fmd->v4l2_dev, "created link [%s] %c> [%s]",
+			  source->name, flags ? '=' : '-', sink->name);
+	}
 	return 0;
 }
 
+/* Create links from FIMC-LITE source pads to other entities */
+static int __fimc_md_create_flite_source_links(struct fimc_md *fmd)
+{
+	struct media_entity *source, *sink;
+	unsigned int flags = MEDIA_LNK_FL_ENABLED;
+	int i, ret;
+
+	for (i = 0; i < FIMC_LITE_MAX_DEVS; i++) {
+		struct fimc_lite *fimc = fmd->fimc_lite[i];
+		if (fimc == NULL)
+			continue;
+		source = &fimc->subdev.entity;
+		sink = &fimc->vfd->entity;
+		/* FIMC-LITE's subdev and video node */
+		ret = media_entity_create_link(source, FIMC_SD_PAD_SOURCE,
+					       sink, 0, flags);
+		if (ret)
+			break;
+		/* TODO: create links to other entities */
+	}
+
+	return ret;
+}
+
 /**
  * fimc_md_create_links - create default links between registered entities
  *
@@ -560,8 +650,7 @@ static int fimc_md_create_links(struct fimc_md *fmd)
 			v4l2_info(&fmd->v4l2_dev, "created link [%s] => [%s]",
 				  sensor->entity.name, csis->entity.name);
 
-			source = &csis->entity;
-			pad = CSIS_PAD_SOURCE;
+			source = NULL;
 			break;
 
 		case FIMC_ITU_601...FIMC_ITU_656:
@@ -577,9 +666,21 @@ static int fimc_md_create_links(struct fimc_md *fmd)
 		if (source == NULL)
 			continue;
 
-		ret = __fimc_md_create_fimc_links(fmd, source, sensor, pad,
-						  fimc_id++);
+		ret = __fimc_md_create_fimc_sink_links(fmd, source, sensor,
+						       pad, fimc_id++);
+	}
+
+	fimc_id = 0;
+	for (i = 0; i < ARRAY_SIZE(fmd->csis); i++) {
+		if (fmd->csis[i].sd == NULL)
+			continue;
+		source = &fmd->csis[i].sd->entity;
+		pad = CSIS_PAD_SOURCE;
+
+		ret = __fimc_md_create_fimc_sink_links(fmd, source, NULL,
+						       pad, fimc_id++);
 	}
+
 	/* Create immutable links between each FIMC's subdev and video node */
 	flags = MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED;
 	for (i = 0; i < FIMC_MAX_DEVS; i++) {
@@ -593,7 +694,7 @@ static int fimc_md_create_links(struct fimc_md *fmd)
 			break;
 	}
 
-	return ret;
+	return __fimc_md_create_flite_source_links(fmd);
 }
 
 /*
@@ -701,9 +802,10 @@ int fimc_md_set_camclk(struct v4l2_subdev *sd, bool on)
 static int fimc_md_link_notify(struct media_pad *source,
 			       struct media_pad *sink, u32 flags)
 {
+	struct fimc_lite *fimc_lite = NULL;
+	struct fimc_dev *fimc = NULL;
 	struct fimc_pipeline *pipeline;
 	struct v4l2_subdev *sd;
-	struct fimc_dev *fimc;
 	int ret = 0;
 
 	if (media_entity_type(sink->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
@@ -712,6 +814,10 @@ static int fimc_md_link_notify(struct media_pad *source,
 	sd = media_entity_to_v4l2_subdev(sink->entity);
 
 	switch (sd->grp_id) {
+	case FLITE_GROUP_ID:
+		fimc_lite = v4l2_get_subdevdata(sd);
+		pipeline = &fimc_lite->pipeline;
+		break;
 	case FIMC_GROUP_ID:
 		fimc = v4l2_get_subdevdata(sd);
 		pipeline = &fimc->pipeline;
@@ -737,15 +843,23 @@ static int fimc_md_link_notify(struct media_pad *source,
 	 * pipeline is already in use, i.e. its video node is opened.
 	 * Recreate the controls destroyed during the link deactivation.
 	 */
-	mutex_lock(&fimc->lock);
-	if (fimc->vid_cap.refcnt > 0) {
+	if (fimc) {
+		mutex_lock(&fimc->lock);
+		if (fimc->vid_cap.refcnt > 0) {
 			ret = __fimc_pipeline_initialize(pipeline,
 							 source->entity, true);
 		if (!ret)
 			ret = fimc_capture_ctrls_create(fimc);
+		}
+		mutex_unlock(&fimc->lock);
+	} else {
+		mutex_lock(&fimc_lite->lock);
+		if (fimc_lite->ref_count > 0) {
+			ret = __fimc_pipeline_initialize(pipeline,
+							 source->entity, true);
+		}
+		mutex_unlock(&fimc_lite->lock);
 	}
-	mutex_unlock(&fimc->lock);
-
 	return ret ? -EPIPE : ret;
 }
 
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.h b/drivers/media/video/s5p-fimc/fimc-mdevice.h
index c5ac3e6..3524c19 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.h
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.h
@@ -18,13 +18,15 @@
 #include <media/v4l2-subdev.h>
 
 #include "fimc-core.h"
+#include "fimc-lite.h"
 #include "mipi-csis.h"
 
-/* Group IDs of sensor, MIPI CSIS and the writeback subdevs. */
+/* Group IDs of sensor, MIPI-CSIS, FIMC-LITE and the writeback subdevs. */
 #define SENSOR_GROUP_ID		(1 << 8)
 #define CSIS_GROUP_ID		(1 << 9)
 #define WRITEBACK_GROUP_ID	(1 << 10)
 #define FIMC_GROUP_ID		(1 << 11)
+#define FLITE_GROUP_ID		(1 << 12)
 
 #define FIMC_MAX_SENSORS	8
 #define FIMC_MAX_CAMCLKS	2
@@ -74,6 +76,7 @@ struct fimc_md {
 	struct fimc_sensor_info sensor[FIMC_MAX_SENSORS];
 	int num_sensors;
 	struct fimc_camclk_info camclk[FIMC_MAX_CAMCLKS];
+	struct fimc_lite *fimc_lite[FIMC_LITE_MAX_DEVS];
 	struct fimc_dev *fimc[FIMC_MAX_DEVS];
 	struct media_device media_dev;
 	struct v4l2_device v4l2_dev;
-- 
1.7.10

