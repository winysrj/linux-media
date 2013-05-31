Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:23563 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab3EaQsL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 12:48:11 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNO00CRH9CANS10@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Sat, 01 Jun 2013 01:48:10 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hj210.choi@samsung.com, yhwan.joo@samsung.com, arun.kk@samsung.com,
	shaik.ameer@samsung.com, kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [REVIEW PATCH 7/7] exynos4-is: Add the FIMC-IS ISP capture DMA driver
Date: Fri, 31 May 2013 18:47:05 +0200
Message-id: <1370018825-13088-8-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1370018825-13088-1-git-send-email-s.nawrocki@samsung.com>
References: <1370018825-13088-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a video capture node for the FIMC-IS ISP IP block. The Exynos4x12
FIMC-IS ISP IP block has 2 DMA interfaces that allow to capture raw
Bayer and YUV data to memory.  Currently only the DMA2 output is and
raw Bayer data capture is supported.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/Kconfig          |    9 +
 drivers/media/platform/exynos4-is/Makefile         |    4 +
 drivers/media/platform/exynos4-is/fimc-is-param.h  |    5 +
 drivers/media/platform/exynos4-is/fimc-is-regs.c   |   14 +
 drivers/media/platform/exynos4-is/fimc-is-regs.h   |    1 +
 drivers/media/platform/exynos4-is/fimc-is.c        |    3 +
 drivers/media/platform/exynos4-is/fimc-is.h        |    5 +
 drivers/media/platform/exynos4-is/fimc-isp-video.c |  650 ++++++++++++++++++++
 drivers/media/platform/exynos4-is/fimc-isp-video.h |   44 ++
 drivers/media/platform/exynos4-is/fimc-isp.c       |   29 +-
 drivers/media/platform/exynos4-is/fimc-isp.h       |   27 +-
 drivers/media/platform/exynos4-is/media-dev.c      |   19 +-
 12 files changed, 802 insertions(+), 8 deletions(-)
 create mode 100644 drivers/media/platform/exynos4-is/fimc-isp-video.c
 create mode 100644 drivers/media/platform/exynos4-is/fimc-isp-video.h

diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
index c622532..d2c670c 100644
--- a/drivers/media/platform/exynos4-is/Kconfig
+++ b/drivers/media/platform/exynos4-is/Kconfig
@@ -63,4 +63,13 @@ config VIDEO_EXYNOS4_FIMC_IS
 	  To compile this driver as a module, choose M here: the
 	  module will be called exynos4-fimc-is.
 
+config VIDEO_EXYNOS4_ISP_DMA_CAPTURE
+	bool "EXYNOS4x12 FIMC-IS ISP Direct DMA capture support"
+	depends on VIDEO_EXYNOS4_FIMC_IS
+	select VIDEO_EXYNOS4_IS_COMMON
+	default y
+	  help
+	  This option enables an additional video device node exposing a V4L2
+	  video capture interface for the FIMC-IS ISP raw (Bayer) capture DMA.
+
 endif # VIDEO_SAMSUNG_EXYNOS4_IS
diff --git a/drivers/media/platform/exynos4-is/Makefile b/drivers/media/platform/exynos4-is/Makefile
index c2ff29b..eed1b18 100644
--- a/drivers/media/platform/exynos4-is/Makefile
+++ b/drivers/media/platform/exynos4-is/Makefile
@@ -6,6 +6,10 @@ exynos4-is-common-objs := common.o
 exynos-fimc-is-objs := fimc-is.o fimc-isp.o fimc-is-sensor.o fimc-is-regs.o
 exynos-fimc-is-objs += fimc-is-param.o fimc-is-errno.o fimc-is-i2c.o
 
+ifeq ($(CONFIG_VIDEO_EXYNOS4_ISP_DMA_CAPTURE),y)
+exynos-fimc-is-objs += fimc-isp-video.o
+endif
+
 obj-$(CONFIG_VIDEO_S5P_MIPI_CSIS)	+= s5p-csis.o
 obj-$(CONFIG_VIDEO_EXYNOS_FIMC_LITE)	+= exynos-fimc-lite.o
 obj-$(CONFIG_VIDEO_EXYNOS4_FIMC_IS)	+= exynos-fimc-is.o
diff --git a/drivers/media/platform/exynos4-is/fimc-is-param.h b/drivers/media/platform/exynos4-is/fimc-is-param.h
index f9358c2..8e31f76 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-param.h
+++ b/drivers/media/platform/exynos4-is/fimc-is-param.h
@@ -911,6 +911,10 @@ struct is_region {
 	u32 shared[MAX_SHARED_COUNT];
 } __packed;
 
+/* Offset to the ISP DMA2 output buffer address array. */
+#define DMA2_OUTPUT_ADDR_ARRAY_OFFS \
+	(offsetof(struct is_region, shared) + 32 * sizeof(u32))
+
 struct is_debug_frame_descriptor {
 	u32 sensor_frame_time;
 	u32 sensor_exposure_time;
@@ -988,6 +992,7 @@ struct sensor_open_extended {
 struct fimc_is;
 
 int fimc_is_hw_get_sensor_max_framerate(struct fimc_is *is);
+int __fimc_is_hw_update_param(struct fimc_is *is, u32 offset);
 void fimc_is_set_initial_params(struct fimc_is *is);
 unsigned int __get_pending_param_count(struct fimc_is *is);
 
diff --git a/drivers/media/platform/exynos4-is/fimc-is-regs.c b/drivers/media/platform/exynos4-is/fimc-is-regs.c
index 11b7b0a..78df83d 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-regs.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-regs.c
@@ -129,6 +129,20 @@ int fimc_is_hw_get_params(struct fimc_is *is, unsigned int num_args)
 	return 0;
 }
 
+void fimc_is_hw_set_isp_buf_mask(struct fimc_is *is, unsigned int mask)
+{
+	if (hweight32(mask) == 1) {
+		dev_err(&is->pdev->dev, "%s(): not enough buffers (mask %#x)\n",
+							__func__, mask);
+		return;
+	}
+
+	if (mcuctl_read(is, MCUCTL_REG_ISSR(23)) != 0)
+		dev_dbg(&is->pdev->dev, "non-zero DMA buffer mask\n");
+
+	mcuctl_write(mask, is, MCUCTL_REG_ISSR(23));
+}
+
 void fimc_is_hw_set_sensor_num(struct fimc_is *is)
 {
 	pr_debug("setting sensor index to: %d\n", is->sensor_index);
diff --git a/drivers/media/platform/exynos4-is/fimc-is-regs.h b/drivers/media/platform/exynos4-is/fimc-is-regs.h
index 5fa2fda..ab73957 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-regs.h
+++ b/drivers/media/platform/exynos4-is/fimc-is-regs.h
@@ -148,6 +148,7 @@ void fimc_is_hw_set_intgr0_gd0(struct fimc_is *is);
 int fimc_is_hw_wait_intsr0_intsd0(struct fimc_is *is);
 int fimc_is_hw_wait_intmsr0_intmsd0(struct fimc_is *is);
 void fimc_is_hw_set_sensor_num(struct fimc_is *is);
+void fimc_is_hw_set_isp_buf_mask(struct fimc_is *is, unsigned int mask);
 void fimc_is_hw_stream_on(struct fimc_is *is);
 void fimc_is_hw_stream_off(struct fimc_is *is);
 int fimc_is_hw_set_param(struct fimc_is *is);
diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index e0870e2..13e039a 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -190,6 +190,9 @@ static int fimc_is_register_subdevs(struct fimc_is *is)
 	if (ret < 0)
 		return ret;
 
+	/* Initialize memory allocator context for the ISP DMA. */
+	is->isp.alloc_ctx = is->alloc_ctx;
+
 	for_each_compatible_node(adapter, NULL, FIMC_IS_I2C_COMPATIBLE) {
 		if (!of_find_device_by_node(adapter)) {
 			of_node_put(adapter);
diff --git a/drivers/media/platform/exynos4-is/fimc-is.h b/drivers/media/platform/exynos4-is/fimc-is.h
index 4b0eccb..682662f 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.h
+++ b/drivers/media/platform/exynos4-is/fimc-is.h
@@ -293,6 +293,11 @@ static inline struct fimc_is *fimc_isp_to_is(struct fimc_isp *isp)
 	return container_of(isp, struct fimc_is, isp);
 }
 
+static inline struct chain_config *__get_curr_is_config(struct fimc_is *is)
+{
+	return &is->config[is->config_index];
+}
+
 static inline void fimc_is_mem_barrier(void)
 {
 	mb();
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
new file mode 100644
index 0000000..da65ea1
--- /dev/null
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -0,0 +1,650 @@
+/*
+ * Samsung EXYNOS4x12 FIMC-IS (Imaging Subsystem) driver
+ *
+ * FIMC-IS ISP video input and video output DMA interface driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * The hardware handling code derived from a driver written by
+ * Younghwan Joo <yhwan.joo@samsung.com>.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/bitops.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/printk.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/videodev2.h>
+
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-contig.h>
+#include <media/s5p_fimc.h>
+
+#include "common.h"
+#include "media-dev.h"
+#include "fimc-is.h"
+#include "fimc-isp-video.h"
+#include "fimc-is-param.h"
+
+static int isp_video_capture_queue_setup(struct vb2_queue *vq,
+			const struct v4l2_format *pfmt,
+			unsigned int *num_buffers, unsigned int *num_planes,
+			unsigned int sizes[], void *allocators[])
+{
+	struct fimc_isp *isp = vb2_get_drv_priv(vq);
+	struct v4l2_pix_format_mplane *vid_fmt = &isp->video_capture.pixfmt;
+	const struct v4l2_pix_format_mplane *pixm = NULL;
+	const struct fimc_fmt *fmt;
+	unsigned int wh, i;
+
+	if (pfmt) {
+		pixm = &pfmt->fmt.pix_mp;
+		fmt = fimc_isp_find_format(&pixm->pixelformat, NULL, -1);
+		wh = pixm->width * pixm->height;
+	} else {
+		fmt = isp->video_capture.format;
+		wh = vid_fmt->width * vid_fmt->height;
+	}
+
+	if (fmt == NULL)
+		return -EINVAL;
+
+	*num_buffers = clamp_t(u32, *num_buffers, FIMC_ISP_REQ_BUFS_MIN,
+						FIMC_ISP_REQ_BUFS_MAX);
+	*num_planes = fmt->memplanes;
+
+	for (i = 0; i < fmt->memplanes; i++) {
+		unsigned int size = (wh * fmt->depth[i]) / 8;
+		if (pixm)
+			sizes[i] = max(size, pixm->plane_fmt[i].sizeimage);
+		else
+			sizes[i] = size;
+		allocators[i] = isp->alloc_ctx;
+	}
+
+	return 0;
+}
+
+static inline struct param_dma_output *__get_isp_dma2(struct fimc_is *is)
+{
+	return &__get_curr_is_config(is)->isp.dma2_output;
+}
+
+static int isp_video_capture_start_streaming(struct vb2_queue *q,
+						unsigned int count)
+{
+	struct fimc_isp *isp = vb2_get_drv_priv(q);
+	struct fimc_is *is = fimc_isp_to_is(isp);
+	struct param_dma_output *dma = __get_isp_dma2(is);
+	struct fimc_is_video *video = &isp->video_capture;
+	int ret;
+
+	if (!test_bit(ST_ISP_VID_CAP_BUF_PREP, &isp->state) ||
+	    test_bit(ST_ISP_VID_CAP_STREAMING, &isp->state))
+		return 0;
+
+
+	dma->cmd = DMA_OUTPUT_COMMAND_ENABLE;
+	dma->notify_dma_done = DMA_OUTPUT_NOTIFY_DMA_DONE_ENABLE;
+	dma->buffer_address = is->is_dma_p_region +
+				DMA2_OUTPUT_ADDR_ARRAY_OFFS;
+	dma->buffer_number = video->reqbufs_count;
+	dma->dma_out_mask = video->buf_mask;
+
+	isp_dbg(2, &video->ve.vdev,
+		"buf_count: %d, planes: %d, dma addr table: %#x\n",
+		video->buf_count, video->format->memplanes,
+		dma->buffer_address);
+
+	fimc_is_mem_barrier();
+
+	__fimc_is_hw_update_param(is, PARAM_ISP_DMA2_OUTPUT);
+	fimc_is_set_param_bit(is, PARAM_ISP_DMA2_OUTPUT);
+	fimc_is_hw_set_param(is);
+
+	ret = fimc_pipeline_call(&video->ve, set_stream, 1);
+	if (ret < 0)
+		return ret;
+
+	set_bit(ST_ISP_VID_CAP_STREAMING, &isp->state);
+	return ret;
+}
+
+static int isp_video_capture_stop_streaming(struct vb2_queue *q)
+{
+	struct fimc_isp *isp = vb2_get_drv_priv(q);
+	struct fimc_is *is = fimc_isp_to_is(isp);
+	struct param_dma_output *dma = __get_isp_dma2(is);
+	int ret;
+
+	ret = fimc_pipeline_call(&isp->video_capture.ve, set_stream, 0);
+	if (ret < 0)
+		return ret;
+
+	isp->video_capture.buf_count = 0;
+
+	dma->cmd = DMA_OUTPUT_COMMAND_DISABLE;
+	dma->notify_dma_done = DMA_OUTPUT_NOTIFY_DMA_DONE_DISABLE;
+	dma->buffer_number = 0;
+	dma->buffer_address = 0;
+	dma->dma_out_mask = 0;
+
+	__fimc_is_hw_update_param(is, PARAM_ISP_DMA2_OUTPUT);
+	fimc_is_set_param_bit(is, PARAM_ISP_DMA2_OUTPUT);
+
+	fimc_is_hw_set_param(is);
+
+	clear_bit(ST_ISP_VID_CAP_BUF_PREP, &isp->state);
+	clear_bit(ST_ISP_VID_CAP_STREAMING, &isp->state);
+
+	return 0;
+}
+
+static int isp_video_capture_buffer_prepare(struct vb2_buffer *vb)
+{
+	struct fimc_isp *isp = vb2_get_drv_priv(vb->vb2_queue);
+	struct fimc_is_video *video = &isp->video_capture;
+	int i;
+
+	if (video->format == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < video->format->memplanes; i++) {
+		unsigned long size = video->pixfmt.plane_fmt[i].sizeimage;
+
+		if (vb2_plane_size(vb, i) < size) {
+			v4l2_err(&video->ve.vdev,
+				 "User buffer too small (%ld < %ld)\n",
+				 vb2_plane_size(vb, i), size);
+			return -EINVAL;
+		}
+		vb2_set_plane_payload(vb, i, size);
+	}
+
+	/* Check if we get one of the already known buffers. */
+	if (test_bit(ST_ISP_VID_CAP_BUF_PREP, &isp->state)) {
+		dma_addr_t dma_addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+		int i;
+
+		for (i = 0; i < video->buf_count; i++)
+			if (video->buffers[i]->dma_addr[0] == dma_addr)
+				return 0;
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+static void isp_video_capture_buffer_queue(struct vb2_buffer *vb)
+{
+	struct fimc_isp *isp = vb2_get_drv_priv(vb->vb2_queue);
+	struct fimc_is_video *video = &isp->video_capture;
+	struct fimc_is *is = fimc_isp_to_is(isp);
+	struct isp_video_buf *ivb = to_isp_video_buf(vb);
+	unsigned long flags;
+	unsigned int i;
+
+	if (test_bit(ST_ISP_VID_CAP_BUF_PREP, &isp->state)) {
+		spin_lock_irqsave(&is->slock, flags);
+		video->buf_mask |= BIT(ivb->index);
+		spin_unlock_irqrestore(&is->slock, flags);
+	} else {
+		unsigned int num_planes = video->format->memplanes;
+
+		ivb->index = video->buf_count;
+		video->buffers[ivb->index] = ivb;
+
+		for (i = 0; i < num_planes; i++) {
+			int buf_index = ivb->index * num_planes + i;
+
+			ivb->dma_addr[i] = vb2_dma_contig_plane_dma_addr(vb, i);
+			is->is_p_region->shared[32 + buf_index] =
+							ivb->dma_addr[i];
+
+			isp_dbg(2, &video->ve.vdev,
+				"dma_buf %d (%d/%d/%d) addr: %#x\n",
+				buf_index, ivb->index, i, vb->v4l2_buf.index,
+				ivb->dma_addr[i]);
+		}
+
+		if (++video->buf_count < video->reqbufs_count)
+			return;
+
+		video->buf_mask = (1UL << video->buf_count) - 1;
+		set_bit(ST_ISP_VID_CAP_BUF_PREP, &isp->state);
+	}
+
+	if (!test_bit(ST_ISP_VID_CAP_STREAMING, &isp->state))
+		isp_video_capture_start_streaming(vb->vb2_queue, 0);
+}
+
+/*
+ * FIMC-IS ISP input and output DMA interface interrupt handler.
+ * Locking: called with is->slock spinlock held.
+ */
+void fimc_isp_video_irq_handler(struct fimc_is *is)
+{
+	struct fimc_is_video *video = &is->isp.video_capture;
+	struct vb2_buffer *vb;
+	int buf_index;
+
+	buf_index = (is->i2h_cmd.args[1] - 1) % video->buf_count;
+	vb = &video->buffers[buf_index]->vb;
+
+	v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
+	vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+
+	video->buf_mask &= ~BIT(buf_index);
+	fimc_is_hw_set_isp_buf_mask(is, video->buf_mask);
+}
+
+static const struct vb2_ops isp_video_capture_qops = {
+	.queue_setup	 = isp_video_capture_queue_setup,
+	.buf_prepare	 = isp_video_capture_buffer_prepare,
+	.buf_queue	 = isp_video_capture_buffer_queue,
+	.wait_prepare	 = vb2_ops_wait_prepare,
+	.wait_finish	 = vb2_ops_wait_finish,
+	.start_streaming = isp_video_capture_start_streaming,
+	.stop_streaming	 = isp_video_capture_stop_streaming,
+};
+
+static int isp_video_open(struct file *file)
+{
+	struct fimc_isp *isp = video_drvdata(file);
+	struct exynos_video_entity *ve = &isp->video_capture.ve;
+	struct media_entity *me = &ve->vdev.entity;
+	int ret;
+
+	if (mutex_lock_interruptible(&isp->video_lock))
+		return -ERESTARTSYS;
+
+	ret = v4l2_fh_open(file);
+	if (ret < 0)
+		goto unlock;
+
+	ret = pm_runtime_get_sync(&isp->pdev->dev);
+	if (ret < 0)
+		goto rel_fh;
+
+	if (v4l2_fh_is_singular_file(file)) {
+		mutex_lock(&me->parent->graph_mutex);
+
+		ret = fimc_pipeline_call(ve, open, me, true);
+
+		/* Mark the video pipeline as in use. */
+		if (ret == 0)
+			me->use_count++;
+
+		mutex_unlock(&me->parent->graph_mutex);
+	}
+	if (!ret)
+		goto unlock;
+rel_fh:
+	v4l2_fh_release(file);
+unlock:
+	mutex_unlock(&isp->video_lock);
+	return ret;
+}
+
+static int isp_video_release(struct file *file)
+{
+	struct fimc_isp *isp = video_drvdata(file);
+	struct fimc_is_video *ivc = &isp->video_capture;
+	struct media_entity *entity = &ivc->ve.vdev.entity;
+	struct media_device *mdev = entity->parent;
+	int ret = 0;
+
+	mutex_lock(&isp->video_lock);
+
+	if (v4l2_fh_is_singular_file(file) && ivc->streaming) {
+		media_entity_pipeline_stop(entity);
+		ivc->streaming = 0;
+	}
+
+	vb2_fop_release(file);
+
+	if (v4l2_fh_is_singular_file(file)) {
+		fimc_pipeline_call(&ivc->ve, close);
+
+		mutex_lock(&mdev->graph_mutex);
+		entity->use_count--;
+		mutex_unlock(&mdev->graph_mutex);
+	}
+
+	pm_runtime_put(&isp->pdev->dev);
+	mutex_unlock(&isp->video_lock);
+
+	return ret;
+}
+
+static const struct v4l2_file_operations isp_video_fops = {
+	.owner		= THIS_MODULE,
+	.open		= isp_video_open,
+	.release	= isp_video_release,
+	.poll		= vb2_fop_poll,
+	.unlocked_ioctl	= video_ioctl2,
+	.mmap		= vb2_fop_mmap,
+};
+
+/*
+ * Video node ioctl operations
+ */
+static int isp_video_querycap(struct file *file, void *priv,
+					struct v4l2_capability *cap)
+{
+	struct fimc_isp *isp = video_drvdata(file);
+
+	__fimc_vidioc_querycap(&isp->pdev->dev, cap, V4L2_CAP_STREAMING);
+	return 0;
+}
+
+static int isp_video_enum_fmt_mplane(struct file *file, void *priv,
+					struct v4l2_fmtdesc *f)
+{
+	const struct fimc_fmt *fmt;
+
+	if (f->index >= FIMC_ISP_NUM_FORMATS)
+		return -EINVAL;
+
+	fmt = fimc_isp_find_format(NULL, NULL, f->index);
+	if (WARN_ON(fmt == NULL))
+		return -EINVAL;
+
+	strlcpy(f->description, fmt->name, sizeof(f->description));
+	f->pixelformat = fmt->fourcc;
+
+	return 0;
+}
+
+static int isp_video_g_fmt_mplane(struct file *file, void *fh,
+					struct v4l2_format *f)
+{
+	struct fimc_isp *isp = video_drvdata(file);
+
+	f->fmt.pix_mp = isp->video_capture.pixfmt;
+	return 0;
+}
+
+static void __isp_video_try_fmt(struct fimc_isp *isp,
+				struct v4l2_pix_format_mplane *pixm,
+				const struct fimc_fmt **fmt)
+{
+	*fmt = fimc_isp_find_format(&pixm->pixelformat, NULL, 2);
+
+	pixm->colorspace = V4L2_COLORSPACE_SRGB;
+	pixm->field = V4L2_FIELD_NONE;
+	pixm->num_planes = (*fmt)->memplanes;
+	pixm->pixelformat = (*fmt)->fourcc;
+	/*
+	 * TODO: double check with the docmentation these width/height
+	 * constraints are correct.
+	 */
+	v4l_bound_align_image(&pixm->width, FIMC_ISP_SOURCE_WIDTH_MIN,
+			      FIMC_ISP_SOURCE_WIDTH_MAX, 3,
+			      &pixm->height, FIMC_ISP_SOURCE_HEIGHT_MIN,
+			      FIMC_ISP_SOURCE_HEIGHT_MAX, 0, 0);
+}
+
+static int isp_video_try_fmt_mplane(struct file *file, void *fh,
+					struct v4l2_format *f)
+{
+	struct fimc_isp *isp = video_drvdata(file);
+
+	__isp_video_try_fmt(isp, &f->fmt.pix_mp, NULL);
+	return 0;
+}
+
+static int isp_video_s_fmt_mplane(struct file *file, void *priv,
+					struct v4l2_format *f)
+{
+	struct fimc_isp *isp = video_drvdata(file);
+	struct fimc_is *is = fimc_isp_to_is(isp);
+	struct v4l2_pix_format_mplane *pixm = &f->fmt.pix_mp;
+	const struct fimc_fmt *ifmt = NULL;
+	struct param_dma_output *dma = __get_isp_dma2(is);
+
+	__isp_video_try_fmt(isp, pixm, &ifmt);
+
+	if (WARN_ON(ifmt == NULL))
+		return -EINVAL;
+
+	dma->format = DMA_OUTPUT_FORMAT_BAYER;
+	dma->order = DMA_OUTPUT_ORDER_GB_BG;
+	dma->plane = ifmt->memplanes;
+	dma->bitwidth = ifmt->depth[0];
+	dma->width = pixm->width;
+	dma->height = pixm->height;
+
+	fimc_is_mem_barrier();
+
+	isp->video_capture.format = ifmt;
+	isp->video_capture.pixfmt = *pixm;
+
+	return 0;
+}
+
+/*
+ * Check for source/sink format differences at each link.
+ * Return 0 if the formats match or -EPIPE otherwise.
+ */
+static int isp_video_pipeline_validate(struct fimc_isp *isp)
+{
+	struct v4l2_subdev *sd = &isp->subdev;
+	struct v4l2_subdev_format sink_fmt, src_fmt;
+	struct media_pad *pad;
+	int ret;
+
+	while (1) {
+		/* Retrieve format at the sink pad */
+		pad = &sd->entity.pads[0];
+		if (!(pad->flags & MEDIA_PAD_FL_SINK))
+			break;
+		sink_fmt.pad = pad->index;
+		sink_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+		ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &sink_fmt);
+		if (ret < 0 && ret != -ENOIOCTLCMD)
+			return -EPIPE;
+
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
+
+	return 0;
+}
+
+static int isp_video_streamon(struct file *file, void *priv,
+				      enum v4l2_buf_type type)
+{
+	struct fimc_isp *isp = video_drvdata(file);
+	struct exynos_video_entity *ve = &isp->video_capture.ve;
+	struct media_entity *me = &ve->vdev.entity;
+	int ret;
+
+	ret = media_entity_pipeline_start(me, &ve->pipe->mp);
+	if (ret < 0)
+		return ret;
+
+	ret = isp_video_pipeline_validate(isp);
+	if (ret < 0)
+		goto p_stop;
+
+	ret = vb2_ioctl_streamon(file, priv, type);
+	if (ret < 0)
+		goto p_stop;
+
+	isp->video_capture.streaming = 1;
+	return 0;
+p_stop:
+	media_entity_pipeline_stop(me);
+	return ret;
+}
+
+static int isp_video_streamoff(struct file *file, void *priv,
+					enum v4l2_buf_type type)
+{
+	struct fimc_isp *isp = video_drvdata(file);
+	struct fimc_is_video *video = &isp->video_capture;
+	int ret;
+
+	ret = vb2_ioctl_streamoff(file, priv, type);
+	if (ret < 0)
+		return ret;
+
+	media_entity_pipeline_stop(&video->ve.vdev.entity);
+	video->streaming = 0;
+	return 0;
+}
+
+static int isp_video_reqbufs(struct file *file, void *priv,
+				struct v4l2_requestbuffers *rb)
+{
+	struct fimc_isp *isp = video_drvdata(file);
+	int ret;
+
+	ret = vb2_ioctl_reqbufs(file, priv, rb);
+	if (ret < 0)
+		return ret;
+
+	if (rb->count && rb->count < FIMC_ISP_REQ_BUFS_MIN) {
+		rb->count = 0;
+		vb2_ioctl_reqbufs(file, priv, rb);
+		ret = -ENOMEM;
+	}
+
+	isp->video_capture.reqbufs_count = rb->count;
+	return ret;
+}
+
+static const struct v4l2_ioctl_ops isp_video_ioctl_ops = {
+	.vidioc_querycap		= isp_video_querycap,
+	.vidioc_enum_fmt_vid_cap_mplane	= isp_video_enum_fmt_mplane,
+	.vidioc_try_fmt_vid_cap_mplane	= isp_video_try_fmt_mplane,
+	.vidioc_s_fmt_vid_cap_mplane	= isp_video_s_fmt_mplane,
+	.vidioc_g_fmt_vid_cap_mplane	= isp_video_g_fmt_mplane,
+	.vidioc_reqbufs			= isp_video_reqbufs,
+	.vidioc_querybuf		= vb2_ioctl_querybuf,
+	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
+	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
+	.vidioc_qbuf			= vb2_ioctl_qbuf,
+	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
+	.vidioc_streamon		= isp_video_streamon,
+	.vidioc_streamoff		= isp_video_streamoff,
+};
+
+int fimc_isp_video_device_register(struct fimc_isp *isp,
+				   struct v4l2_device *v4l2_dev,
+				   enum v4l2_buf_type type)
+{
+	struct vb2_queue *q = &isp->video_capture.vb_queue;
+	struct fimc_is_video *iv;
+	struct video_device *vdev;
+	int ret;
+
+	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		iv = &isp->video_capture;
+	else
+		return -ENOSYS;
+
+	mutex_init(&isp->video_lock);
+	INIT_LIST_HEAD(&iv->pending_buf_q);
+	INIT_LIST_HEAD(&iv->active_buf_q);
+	iv->format = fimc_isp_find_format(NULL, NULL, 0);
+	iv->pixfmt.width = IS_DEFAULT_WIDTH;
+	iv->pixfmt.height = IS_DEFAULT_HEIGHT;
+	iv->pixfmt.pixelformat = iv->format->fourcc;
+	iv->pixfmt.colorspace = V4L2_COLORSPACE_SRGB;
+	iv->reqbufs_count = 0;
+
+	memset(q, 0, sizeof(*q));
+	q->type = type;
+	q->io_modes = VB2_MMAP | VB2_USERPTR;
+	q->ops = &isp_video_capture_qops;
+	q->mem_ops = &vb2_dma_contig_memops;
+	q->buf_struct_size = sizeof(struct isp_video_buf);
+	q->drv_priv = isp;
+	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->lock = &isp->video_lock;
+
+	ret = vb2_queue_init(q);
+	if (ret < 0)
+		return ret;
+
+	vdev = &iv->ve.vdev;
+	memset(vdev, 0, sizeof(*vdev));
+	snprintf(vdev->name, sizeof(vdev->name), "fimc-is-isp.%s",
+			type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE ?
+			"capture" : "output");
+	vdev->queue = q;
+	vdev->fops = &isp_video_fops;
+	vdev->ioctl_ops = &isp_video_ioctl_ops;
+	vdev->v4l2_dev = v4l2_dev;
+	vdev->minor = -1;
+	vdev->release = video_device_release_empty;
+	vdev->lock = &isp->video_lock;
+
+	iv->pad.flags = MEDIA_PAD_FL_SINK;
+	ret = media_entity_init(&vdev->entity, 1, &iv->pad, 0);
+	if (ret < 0)
+		return ret;
+
+	video_set_drvdata(vdev, isp);
+
+	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
+	if (ret < 0) {
+		media_entity_cleanup(&vdev->entity);
+		return ret;
+	}
+
+	v4l2_info(v4l2_dev, "Registered %s as /dev/%s\n",
+		  vdev->name, video_device_node_name(vdev));
+
+	return 0;
+}
+
+void fimc_isp_video_device_unregister(struct fimc_isp *isp,
+				      enum v4l2_buf_type type)
+{
+	struct exynos_video_entity *ve;
+
+	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		ve = &isp->video_capture.ve;
+	else
+		return;
+
+	mutex_lock(&isp->video_lock);
+
+	if (video_is_registered(&ve->vdev)) {
+		video_unregister_device(&ve->vdev);
+		media_entity_cleanup(&ve->vdev.entity);
+		ve->pipe = NULL;
+	}
+
+	mutex_unlock(&isp->video_lock);
+}
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.h b/drivers/media/platform/exynos4-is/fimc-isp-video.h
new file mode 100644
index 0000000..98c6626
--- /dev/null
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.h
@@ -0,0 +1,44 @@
+/*
+ * Samsung EXYNOS4x12 FIMC-IS (Imaging Subsystem) driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef FIMC_ISP_VIDEO__
+#define FIMC_ISP_VIDEO__
+
+#include <media/videobuf2-core.h>
+#include "fimc-isp.h"
+
+#ifdef CONFIG_VIDEO_EXYNOS4_ISP_DMA_CAPTURE
+int fimc_isp_video_device_register(struct fimc_isp *isp,
+				struct v4l2_device *v4l2_dev,
+				enum v4l2_buf_type type);
+
+void fimc_isp_video_device_unregister(struct fimc_isp *isp,
+				enum v4l2_buf_type type);
+
+void fimc_isp_video_irq_handler(struct fimc_is *is);
+#else
+static inline void fimc_isp_video_irq_handler(struct fimc_is *is)
+{
+}
+
+static inline int fimc_isp_video_device_register(struct fimc_isp *isp,
+						struct v4l2_device *v4l2_dev,
+						enum v4l2_buf_type type)
+{
+	return 0;
+}
+
+void fimc_isp_video_device_unregister(struct fimc_isp *isp,
+				enum v4l2_buf_type type)
+{
+}
+#endif /* !CONFIG_VIDEO_EXYNOS4_ISP_DMA_CAPTURE */
+
+#endif /* FIMC_ISP_VIDEO__ */
diff --git a/drivers/media/platform/exynos4-is/fimc-isp.c b/drivers/media/platform/exynos4-is/fimc-isp.c
index ecb82a9..eda8134 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp.c
@@ -25,6 +25,7 @@
 #include <media/v4l2-device.h>
 
 #include "media-dev.h"
+#include "fimc-isp-video.h"
 #include "fimc-is-command.h"
 #include "fimc-is-param.h"
 #include "fimc-is-regs.h"
@@ -93,8 +94,8 @@ void fimc_isp_irq_handler(struct fimc_is *is)
 	is->i2h_cmd.args[1] = mcuctl_read(is, MCUCTL_REG_ISSR(21));
 
 	fimc_is_fw_clear_irq1(is, FIMC_IS_INT_FRAME_DONE_ISP);
+	fimc_isp_video_irq_handler(is);
 
-	/* TODO: Complete ISP DMA interrupt handler */
 	wake_up(&is->irq_queue);
 }
 
@@ -352,7 +353,33 @@ static int fimc_isp_subdev_open(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int fimc_isp_subdev_registered(struct v4l2_subdev *sd)
+{
+	struct fimc_isp *isp = v4l2_get_subdevdata(sd);
+	int ret;
+
+	/* Use pipeline object allocated by the media device. */
+	isp->video_capture.ve.pipe = v4l2_get_subdev_hostdata(sd);
+
+	ret = fimc_isp_video_device_register(isp, sd->v4l2_dev,
+			V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
+	if (ret < 0)
+		isp->video_capture.ve.pipe = NULL;
+
+	return ret;
+}
+
+static void fimc_isp_subdev_unregistered(struct v4l2_subdev *sd)
+{
+	struct fimc_isp *isp = v4l2_get_subdevdata(sd);
+
+	fimc_isp_video_device_unregister(isp,
+			V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
+}
+
 static const struct v4l2_subdev_internal_ops fimc_is_subdev_internal_ops = {
+	.registered = fimc_isp_subdev_registered,
+	.unregistered = fimc_isp_subdev_unregistered,
 	.open = fimc_isp_subdev_open,
 };
 
diff --git a/drivers/media/platform/exynos4-is/fimc-isp.h b/drivers/media/platform/exynos4-is/fimc-isp.h
index 756063e..0aa2a54 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.h
+++ b/drivers/media/platform/exynos4-is/fimc-isp.h
@@ -35,17 +35,18 @@ extern int fimc_isp_debug;
 #define FIMC_ISP_SINK_WIDTH_MIN		(16 + 8)
 #define FIMC_ISP_SINK_HEIGHT_MIN	(12 + 8)
 #define FIMC_ISP_SOURCE_WIDTH_MIN	8
-#define FIMC_ISP_SOURC_HEIGHT_MIN	8
+#define FIMC_ISP_SOURCE_HEIGHT_MIN	8
 #define FIMC_ISP_CAC_MARGIN_WIDTH	16
 #define FIMC_ISP_CAC_MARGIN_HEIGHT	12
 
 #define FIMC_ISP_SINK_WIDTH_MAX		(4000 - 16)
 #define FIMC_ISP_SINK_HEIGHT_MAX	(4000 + 12)
 #define FIMC_ISP_SOURCE_WIDTH_MAX	4000
-#define FIMC_ISP_SOURC_HEIGHT_MAX	4000
+#define FIMC_ISP_SOURCE_HEIGHT_MAX	4000
 
 #define FIMC_ISP_NUM_FORMATS		3
 #define FIMC_ISP_REQ_BUFS_MIN		2
+#define FIMC_ISP_REQ_BUFS_MAX		32
 
 #define FIMC_ISP_SD_PAD_SINK		0
 #define FIMC_ISP_SD_PAD_SRC_FIFO	1
@@ -100,6 +101,16 @@ struct fimc_isp_ctrls {
 	struct v4l2_ctrl *colorfx;
 };
 
+struct isp_video_buf {
+	struct vb2_buffer vb;
+	dma_addr_t dma_addr[FIMC_ISP_MAX_PLANES];
+	unsigned int index;
+};
+
+#define to_isp_video_buf(_b) container_of(_b, struct isp_video_buf, vb)
+
+#define FIMC_ISP_MAX_BUFS	4
+
 /**
  * struct fimc_is_video - fimc-is video device structure
  * @vdev: video_device structure
@@ -114,18 +125,26 @@ struct fimc_isp_ctrls {
  * @format: current pixel format
  */
 struct fimc_is_video {
-	struct video_device	vdev;
+	struct exynos_video_entity ve;
 	enum v4l2_buf_type	type;
 	struct media_pad	pad;
 	struct list_head	pending_buf_q;
 	struct list_head	active_buf_q;
 	struct vb2_queue	vb_queue;
-	unsigned int		frame_count;
 	unsigned int		reqbufs_count;
+	unsigned int		buf_count;
+	unsigned int		buf_mask;
+	unsigned int		frame_count;
 	int			streaming;
+	struct isp_video_buf	*buffers[FIMC_ISP_MAX_BUFS];
 	const struct fimc_fmt	*format;
+	struct v4l2_pix_format_mplane pixfmt;
 };
 
+/* struct fimc_isp:state bit definitions */
+#define ST_ISP_VID_CAP_BUF_PREP		0
+#define ST_ISP_VID_CAP_STREAMING	1
+
 /**
  * struct fimc_isp - FIMC-IS ISP data structure
  * @pdev: pointer to FIMC-IS platform device
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index af49e0f..68a9d81 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -732,8 +732,16 @@ static int register_csis_entity(struct fimc_md *fmd,
 static int register_fimc_is_entity(struct fimc_md *fmd, struct fimc_is *is)
 {
 	struct v4l2_subdev *sd = &is->isp.subdev;
+	struct exynos_media_pipeline *ep;
 	int ret;
 
+	/* Allocate pipeline object for the ISP capture video node. */
+	ep = fimc_md_pipeline_create(fmd);
+	if (!ep)
+		return -ENOMEM;
+
+	v4l2_set_subdev_hostdata(sd, ep);
+
 	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
 	if (ret) {
 		v4l2_err(&fmd->v4l2_dev,
@@ -1005,16 +1013,17 @@ static int __fimc_md_create_flite_source_links(struct fimc_md *fmd)
 /* Create FIMC-IS links */
 static int __fimc_md_create_fimc_is_links(struct fimc_md *fmd)
 {
+	struct fimc_isp *isp = &fmd->fimc_is->isp;
 	struct media_entity *source, *sink;
 	int i, ret;
 
-	source = &fmd->fimc_is->isp.subdev.entity;
+	source = &isp->subdev.entity;
 
 	for (i = 0; i < FIMC_MAX_DEVS; i++) {
 		if (fmd->fimc[i] == NULL)
 			continue;
 
-		/* Link from IS-ISP subdev to FIMC */
+		/* Link from FIMC-IS-ISP subdev to FIMC */
 		sink = &fmd->fimc[i]->vid_cap.subdev.entity;
 		ret = media_entity_create_link(source, FIMC_ISP_SD_PAD_SRC_FIFO,
 					       sink, FIMC_SD_PAD_SINK_FIFO, 0);
@@ -1022,7 +1031,11 @@ static int __fimc_md_create_fimc_is_links(struct fimc_md *fmd)
 			return ret;
 	}
 
-	return ret;
+	/* Link from FIMC-IS-ISP subdev to fimc-is-isp.capture video node */
+	sink = &isp->video_capture.ve.vdev.entity;
+
+	return media_entity_create_link(source, FIMC_ISP_SD_PAD_SRC_DMA,
+					sink, 0, 0);
 }
 
 /**
-- 
1.7.9.5

