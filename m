Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:8770 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528Ab3CHOmV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 09:42:21 -0500
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org
Cc: s.nawrocki@samsung.com, kgene.kim@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com
Subject: [RFC 08/12] exynos-fimc-is: Adds scaler subdev
Date: Fri, 08 Mar 2013 09:59:21 -0500
Message-id: <1362754765-2651-9-git-send-email-arun.kk@samsung.com>
In-reply-to: <1362754765-2651-1-git-send-email-arun.kk@samsung.com>
References: <1362754765-2651-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

FIMC-IS has two hardware scalers named as scaler-codec and
scaler-preview. This patch adds the common code handling the
video nodes and subdevs of both the scalers.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
---
 drivers/media/platform/exynos5-is/fimc-is-scaler.c |  595 ++++++++++++++++++++
 drivers/media/platform/exynos5-is/fimc-is-scaler.h |  107 ++++
 2 files changed, 702 insertions(+)
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-scaler.c
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-scaler.h

diff --git a/drivers/media/platform/exynos5-is/fimc-is-scaler.c b/drivers/media/platform/exynos5-is/fimc-is-scaler.c
new file mode 100644
index 0000000..86ac9b8
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/fimc-is-scaler.c
@@ -0,0 +1,595 @@
+/*
+ * Samsung EXYNOS5250 FIMC-IS (Imaging Subsystem) driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ *  Arun Kumar K <arun.kk@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#define DEBUG
+#define pr_fmt(fmt) "%s:%d " fmt, __func__, __LINE__
+
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "fimc-is.h"
+
+static struct fimc_is_fmt formats[] = {
+	{
+		.name           = "YUV 4:2:0 3p MultiPlanar",
+		.fourcc         = V4L2_PIX_FMT_YUV420M,
+		.depth		= {8, 2, 2},
+		.num_planes     = 3,
+	},
+	{
+		.name           = "YUV 4:2:0 2p MultiPlanar",
+		.fourcc         = V4L2_PIX_FMT_NV12M,
+		.depth		= {8, 4},
+		.num_planes     = 2,
+	},
+	{
+		.name           = "YUV 4:2:2 1p MultiPlanar",
+		.fourcc         = V4L2_PIX_FMT_NV16,
+		.depth		= {16},
+		.num_planes     = 1,
+	},
+};
+#define NUM_FORMATS ARRAY_SIZE(formats)
+
+static struct fimc_is_fmt *find_format(struct v4l2_format *f)
+{
+	unsigned int i;
+
+	for (i = 0; i < NUM_FORMATS; i++) {
+		if (formats[i].fourcc == f->fmt.pix_mp.pixelformat)
+			return &formats[i];
+	}
+	return NULL;
+}
+
+static int scaler_video_capture_start_streaming(struct vb2_queue *vq,
+					unsigned int count)
+{
+	struct fimc_is_scaler *ctx = vb2_get_drv_priv(vq);
+	int ret;
+
+	/* Scaler start */
+	ret = fimc_is_pipeline_scaler_start(ctx->pipeline,
+			ctx->scaler_id,
+			(unsigned int **)ctx->buf_paddr,
+			ctx->num_buffers,
+			ctx->fmt->num_planes);
+	if (ret) {
+		is_err("Scaler start failed.\n");
+		return -EINVAL;
+	}
+
+	set_bit(STATE_RUNNING, &ctx->capture_state);
+	return 0;
+}
+
+static int scaler_video_capture_stop_streaming(struct vb2_queue *vq)
+{
+	struct fimc_is_scaler *ctx = vb2_get_drv_priv(vq);
+	int ret;
+
+	/* Scaler stop */
+	ret = fimc_is_pipeline_scaler_stop(ctx->pipeline, ctx->scaler_id);
+	if (ret)
+		is_dbg(3, "Scaler already stopped.\n");
+
+	clear_bit(STATE_RUNNING, &ctx->capture_state);
+	return 0;
+}
+
+static int scaler_video_capture_queue_setup(struct vb2_queue *vq,
+			const struct v4l2_format *pfmt,
+			unsigned int *num_buffers, unsigned int *num_planes,
+			unsigned int sizes[], void *allocators[])
+{
+	struct fimc_is_scaler *ctx = vb2_get_drv_priv(vq);
+	struct fimc_is_fmt *fmt = ctx->fmt;
+	unsigned int wh;
+	int i;
+
+	if (!fmt)
+		return -EINVAL;
+
+	*num_planes = fmt->num_planes;
+	wh = ctx->width * ctx->height;
+
+	for (i = 0; i < *num_planes; i++) {
+		allocators[i] = ctx->alloc_ctx;
+		sizes[i] = (wh * fmt->depth[i]) / 8;
+	}
+	return 0;
+}
+
+static int scaler_video_capture_buffer_init(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct fimc_is_scaler *ctx = vb2_get_drv_priv(vq);
+	struct fimc_is_buf *buf;
+	struct fimc_is_fmt *fmt;
+	int i;
+
+	buf = &ctx->capture_bufs[vb->v4l2_buf.index];
+	/* Initialize buffer */
+	buf->vb = vb;
+	fmt = ctx->fmt;
+	for (i = 0; i < fmt->num_planes; i++)
+		buf->paddr[i] = vb2_dma_contig_plane_dma_addr(vb, i);
+
+	ctx->cap_buf_cnt++;
+	return 0;
+}
+
+static void scaler_video_capture_buffer_queue(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct fimc_is_scaler *ctx = vb2_get_drv_priv(vq);
+	struct fimc_is_buf *buf;
+
+	buf = &ctx->capture_bufs[vb->v4l2_buf.index];
+
+	/* Add buffer to the wait queue */
+	is_dbg(5, "Add buffer %d in Scaler %d\n",
+			vb->v4l2_buf.index, ctx->scaler_id);
+	fimc_is_pipeline_buf_lock(ctx->pipeline);
+	fimc_is_scaler_wait_queue_add(ctx, buf);
+	fimc_is_pipeline_buf_unlock(ctx->pipeline);
+}
+
+static void scaler_lock(struct vb2_queue *vq)
+{
+	struct fimc_is_scaler *ctx = vb2_get_drv_priv(vq);
+	mutex_lock(&ctx->video_lock);
+}
+
+static void scaler_unlock(struct vb2_queue *vq)
+{
+	struct fimc_is_scaler *ctx = vb2_get_drv_priv(vq);
+	mutex_unlock(&ctx->video_lock);
+}
+
+static const struct vb2_ops scaler_video_capture_qops = {
+	.queue_setup		= scaler_video_capture_queue_setup,
+	.buf_init		= scaler_video_capture_buffer_init,
+	.buf_queue		= scaler_video_capture_buffer_queue,
+	.wait_prepare		= scaler_unlock,
+	.wait_finish		= scaler_lock,
+	.start_streaming	= scaler_video_capture_start_streaming,
+	.stop_streaming		= scaler_video_capture_stop_streaming,
+};
+
+static int scaler_video_capture_open(struct file *file)
+{
+	struct fimc_is_scaler *ctx = video_drvdata(file);
+	int ret = 0;
+
+	/* Check if opened before */
+	if (ctx->refcount >= FIMC_IS_MAX_INSTANCES) {
+		is_err("All instances are in use.\n");
+		return -EBUSY;
+	}
+
+	INIT_LIST_HEAD(&ctx->wait_queue);
+	ctx->wait_queue_cnt = 0;
+	INIT_LIST_HEAD(&ctx->run_queue);
+	ctx->run_queue_cnt = 0;
+
+	ctx->fmt = NULL;
+	ctx->refcount++;
+
+	return ret;
+}
+
+static int scaler_video_capture_close(struct file *file)
+{
+	struct fimc_is_scaler *ctx = video_drvdata(file);
+	int ret = 0;
+
+	vb2_queue_release(&ctx->vbq);
+	ctx->refcount--;
+	ctx->capture_state = 0;
+
+	return ret;
+}
+
+static unsigned int scaler_video_capture_poll(struct file *file,
+				   struct poll_table_struct *wait)
+{
+	struct fimc_is_scaler *ctx = video_drvdata(file);
+	int ret;
+
+	if (mutex_lock_interruptible(&ctx->video_lock))
+		return POLL_ERR;
+
+	ret = vb2_poll(&ctx->vbq, file, wait);
+	mutex_unlock(&ctx->video_lock);
+
+	return ret;
+}
+
+static int scaler_video_capture_mmap(struct file *file,
+		struct vm_area_struct *vma)
+{
+	struct fimc_is_scaler *ctx = video_drvdata(file);
+	int ret;
+
+	if (mutex_lock_interruptible(&ctx->video_lock))
+		return -ERESTARTSYS;
+
+	ret = vb2_mmap(&ctx->vbq, vma);
+	mutex_unlock(&ctx->video_lock);
+
+	return ret;
+}
+
+static const struct v4l2_file_operations scaler_video_capture_fops = {
+	.owner		= THIS_MODULE,
+	.open		= scaler_video_capture_open,
+	.release	= scaler_video_capture_close,
+	.poll		= scaler_video_capture_poll,
+	.unlocked_ioctl	= video_ioctl2,
+	.mmap		= scaler_video_capture_mmap,
+};
+
+/*
+ * Video node ioctl operations
+ */
+static int scaler_querycap_capture(struct file *file, void *priv,
+					struct v4l2_capability *cap)
+{
+	strlcpy(cap->driver, "fimc-is-scaler", sizeof(cap->driver));
+	cap->bus_info[0] = 0;
+	cap->card[0] = 0;
+	cap->capabilities = V4L2_CAP_STREAMING;
+	return 0;
+}
+
+static int scaler_enum_fmt_mplane(struct file *file, void *priv,
+				     struct v4l2_fmtdesc *f)
+{
+	const struct fimc_is_fmt *fmt;
+
+	if (f->index >= NUM_FORMATS)
+		return -EINVAL;
+
+	fmt = &formats[f->index];
+	strlcpy(f->description, fmt->name, sizeof(f->description));
+	f->pixelformat = fmt->fourcc;
+	return 0;
+}
+
+static int scaler_g_fmt_mplane(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	struct fimc_is_scaler *ctx = video_drvdata(file);
+	struct v4l2_pix_format_mplane *pixm = &f->fmt.pix_mp;
+	struct v4l2_plane_pix_format *plane_fmt = &pixm->plane_fmt[0];
+	const struct fimc_is_fmt *fmt = ctx->fmt;
+
+	plane_fmt->bytesperline = (ctx->width * fmt->depth[0]) / 8;
+	plane_fmt->sizeimage = plane_fmt->bytesperline * ctx->height;
+
+	pixm->num_planes = fmt->num_planes;
+	pixm->pixelformat = fmt->fourcc;
+	pixm->width = ctx->width;
+	pixm->height = ctx->height;
+	pixm->field = V4L2_FIELD_NONE;
+	pixm->colorspace = V4L2_COLORSPACE_JPEG;
+
+	return 0;
+}
+
+static int scaler_try_fmt_mplane(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	struct fimc_is_fmt *fmt;
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		return -EINVAL;
+
+	fmt = find_format(f);
+	if (!fmt) {
+		is_err("Format not supported.\n");
+		return -EINVAL;
+	}
+
+	if (fmt->num_planes != f->fmt.pix_mp.num_planes) {
+		is_err("Number of planes mismatch\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int scaler_s_fmt_mplane(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct fimc_is_scaler *ctx = video_drvdata(file);
+	struct fimc_is_fmt *fmt;
+	int ret;
+
+	ret = scaler_try_fmt_mplane(file, priv, f);
+	if (ret)
+		return ret;
+
+	/* Check width & height */
+	if (f->fmt.pix_mp.width > ctx->pipeline->sensor_width ||
+		f->fmt.pix_mp.height > ctx->pipeline->sensor_height) {
+		is_err("Too large width and height\n");
+		return -EINVAL;
+	}
+
+	/* Get format type */
+	fmt = find_format(f);
+	if (!fmt) {
+		is_err("Format not supported.\n");
+		return -EINVAL;
+	}
+
+	/* Save values to context */
+	ctx->fmt = fmt;
+	ctx->width = f->fmt.pix_mp.width;
+	ctx->height = f->fmt.pix_mp.height;
+	ctx->pipeline->scaler_width[ctx->scaler_id] = ctx->width;
+	ctx->pipeline->scaler_height[ctx->scaler_id] = ctx->height;
+	set_bit(STATE_INIT, &ctx->capture_state);
+	return 0;
+}
+
+static int scaler_streamon(struct file *file, void *priv,
+		enum v4l2_buf_type type)
+{
+	struct fimc_is_scaler *ctx = video_drvdata(file);
+
+	return vb2_streamon(&ctx->vbq, type);
+}
+
+static int scaler_streamoff(struct file *file, void *priv,
+		enum v4l2_buf_type type)
+{
+	struct fimc_is_scaler *ctx = video_drvdata(file);
+
+	return vb2_streamoff(&ctx->vbq, type);
+}
+
+static int scaler_reqbufs(struct file *file, void *priv,
+		struct v4l2_requestbuffers *reqbufs)
+{
+	struct fimc_is_scaler *ctx = video_drvdata(file);
+	int ret;
+
+	if (reqbufs->memory != V4L2_MEMORY_MMAP &&
+			reqbufs->memory != V4L2_MEMORY_DMABUF) {
+		is_err("Memory type not supported\n");
+		return -EINVAL;
+	}
+
+	if (!ctx->fmt) {
+		is_err("Set format not done\n");
+		return -EINVAL;
+	}
+
+	/* Check whether buffers are already allocated */
+	if (test_bit(STATE_BUFS_ALLOCATED, &ctx->capture_state)) {
+		is_err("Buffers already allocated\n");
+		return -EINVAL;
+	}
+
+	ret = vb2_reqbufs(&ctx->vbq, reqbufs);
+	if (ret) {
+		is_err("vb2 req buffers failed\n");
+		return ret;
+	}
+
+	ctx->num_buffers = reqbufs->count;
+	ctx->cap_buf_cnt = 0;
+	set_bit(STATE_BUFS_ALLOCATED, &ctx->capture_state);
+	return 0;
+}
+
+static int scaler_querybuf(struct file *file, void *priv,
+		struct v4l2_buffer *buf)
+{
+	struct fimc_is_scaler *ctx = video_drvdata(file);
+	return vb2_querybuf(&ctx->vbq, buf);
+}
+
+static int scaler_qbuf(struct file *file, void *priv,
+		struct v4l2_buffer *buf)
+{
+	struct fimc_is_scaler *ctx = video_drvdata(file);
+	return vb2_qbuf(&ctx->vbq, buf);
+}
+
+static int scaler_dqbuf(struct file *file, void *priv,
+		struct v4l2_buffer *buf)
+{
+	struct fimc_is_scaler *ctx = video_drvdata(file);
+	return vb2_dqbuf(&ctx->vbq, buf,
+			file->f_flags & O_NONBLOCK);
+}
+
+static int scaler_expbuf(struct file *file, void *priv,
+			struct v4l2_exportbuffer *eb)
+{
+	struct fimc_is_scaler *ctx = video_drvdata(file);
+
+	return vb2_expbuf(&ctx->vbq, eb);
+}
+
+static const struct v4l2_ioctl_ops scaler_video_capture_ioctl_ops = {
+	.vidioc_querycap		= scaler_querycap_capture,
+	.vidioc_enum_fmt_vid_cap_mplane	= scaler_enum_fmt_mplane,
+	.vidioc_try_fmt_vid_cap_mplane	= scaler_try_fmt_mplane,
+	.vidioc_s_fmt_vid_cap_mplane	= scaler_s_fmt_mplane,
+	.vidioc_g_fmt_vid_cap_mplane	= scaler_g_fmt_mplane,
+	.vidioc_reqbufs			= scaler_reqbufs,
+	.vidioc_querybuf		= scaler_querybuf,
+	.vidioc_qbuf			= scaler_qbuf,
+	.vidioc_dqbuf			= scaler_dqbuf,
+	.vidioc_expbuf			= scaler_expbuf,
+	.vidioc_streamon		= scaler_streamon,
+	.vidioc_streamoff		= scaler_streamoff,
+};
+
+static int scaler_subdev_s_stream(struct v4l2_subdev *sd, int on)
+{
+	return 0;
+}
+
+static int scaler_subdev_s_power(struct v4l2_subdev *sd, int on)
+{
+	/* Nothing to do as sensor has started the pipeline */
+	return 0;
+}
+
+static int scaler_subdev_registered(struct v4l2_subdev *sd)
+{
+	struct fimc_is_scaler *ctx = v4l2_get_subdevdata(sd);
+	struct vb2_queue *q = &ctx->vbq;
+	struct video_device *vfd = &ctx->vfd;
+	int ret;
+
+	mutex_init(&ctx->video_lock);
+
+	memset(vfd, 0, sizeof(*vfd));
+	if (ctx->scaler_id == SCALER_SCC)
+		snprintf(vfd->name, sizeof(vfd->name), "fimc-is-scaler.codec");
+	else
+		snprintf(vfd->name, sizeof(vfd->name),
+				"fimc-is-scaler.preview");
+
+	vfd->fops = &scaler_video_capture_fops;
+	vfd->ioctl_ops = &scaler_video_capture_ioctl_ops;
+	vfd->v4l2_dev = sd->v4l2_dev;
+	vfd->minor = -1;
+	vfd->release = video_device_release_empty;
+	vfd->lock = &ctx->video_lock;
+	vfd->vfl_dir = VFL_DIR_RX;
+
+	memset(q, 0, sizeof(*q));
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	q->io_modes = VB2_MMAP | VB2_DMABUF;
+	q->ops = &scaler_video_capture_qops;
+	q->mem_ops = &vb2_dma_contig_memops;
+	q->drv_priv = ctx;
+
+	ret = vb2_queue_init(q);
+	if (ret < 0)
+		return ret;
+
+	ctx->vd_pad.flags = MEDIA_PAD_FL_SINK;
+	ret = media_entity_init(&vfd->entity, 1, &ctx->vd_pad, 0);
+	if (ret < 0)
+		return ret;
+
+	video_set_drvdata(vfd, ctx);
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
+	if (ret < 0) {
+		media_entity_cleanup(&vfd->entity);
+		return ret;
+	}
+
+	v4l2_info(sd->v4l2_dev, "Registered %s as /dev/%s\n",
+		  vfd->name, video_device_node_name(vfd));
+	return 0;
+}
+
+static void scaler_subdev_unregistered(struct v4l2_subdev *sd)
+{
+	struct fimc_is_scaler *ctx = v4l2_get_subdevdata(sd);
+
+	if (ctx && video_is_registered(&ctx->vfd))
+		video_unregister_device(&ctx->vfd);
+}
+
+static const struct v4l2_subdev_internal_ops scaler_subdev_internal_ops = {
+	.registered = scaler_subdev_registered,
+	.unregistered = scaler_subdev_unregistered,
+};
+
+static const struct v4l2_subdev_video_ops scaler_subdev_video_ops = {
+	.s_stream = scaler_subdev_s_stream,
+};
+
+static const struct v4l2_subdev_core_ops scaler_core_ops = {
+	.s_power = scaler_subdev_s_power,
+};
+
+static struct v4l2_subdev_ops scaler_subdev_ops = {
+	.core = &scaler_core_ops,
+	.video = &scaler_subdev_video_ops,
+};
+
+static int scaler_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops scaler_ctrl_ops = {
+	.s_ctrl	= scaler_s_ctrl,
+};
+
+int fimc_is_scaler_subdev_create(struct fimc_is_scaler *ctx,
+		enum fimc_is_scaler_id scaler_id,
+		struct vb2_alloc_ctx *alloc_ctx,
+		struct fimc_is_pipeline *pipeline)
+{
+	struct v4l2_ctrl_handler *handler = &ctx->ctrl_handler;
+	struct v4l2_subdev *sd = &ctx->subdev;
+	int ret;
+
+	/* Set context data */
+	ctx->scaler_id = scaler_id;
+	ctx->alloc_ctx = alloc_ctx;
+	ctx->pipeline = pipeline;
+	ctx->fmt = &formats[0];
+	ctx->refcount = 0;
+	init_waitqueue_head(&ctx->event_q);
+
+	/* Initialize scaler subdev */
+	v4l2_subdev_init(sd, &scaler_subdev_ops);
+	sd->owner = THIS_MODULE;
+	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
+	if (scaler_id == SCALER_SCC)
+		snprintf(sd->name, sizeof(sd->name), "fimc-is-scc");
+	else
+		snprintf(sd->name, sizeof(sd->name), "fimc-is-scp");
+
+	ctx->subdev_pads[SCALER_SD_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	ctx->subdev_pads[SCALER_SD_PAD_SRC_FIFO].flags = MEDIA_PAD_FL_SOURCE;
+	ctx->subdev_pads[SCALER_SD_PAD_SRC_DMA].flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_init(&sd->entity, ISP_SD_PADS_NUM,
+			ctx->subdev_pads, 0);
+	if (ret < 0)
+		return ret;
+
+	v4l2_ctrl_handler_init(handler, 1);
+	if (handler->error)
+		return handler->error;
+
+	sd->ctrl_handler = handler;
+	sd->internal_ops = &scaler_subdev_internal_ops;
+	v4l2_set_subdevdata(sd, ctx);
+
+	return 0;
+}
+
+void fimc_is_scaler_subdev_destroy(struct fimc_is_scaler *ctx)
+{
+	struct v4l2_subdev *sd = &ctx->subdev;
+
+	v4l2_device_unregister_subdev(sd);
+	media_entity_cleanup(&sd->entity);
+	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+	v4l2_set_subdevdata(sd, NULL);
+}
+
diff --git a/drivers/media/platform/exynos5-is/fimc-is-scaler.h b/drivers/media/platform/exynos5-is/fimc-is-scaler.h
new file mode 100644
index 0000000..115e00a
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/fimc-is-scaler.h
@@ -0,0 +1,107 @@
+/*
+ * Samsung EXYNOS4x12 FIMC-IS (Imaging Subsystem) driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ *  Arun Kumar K <arun.kk@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef FIMC_IS_SCALER_H_
+#define FIMC_IS_SCALER_H_
+
+#include <linux/sizes.h>
+#include <linux/io.h>
+#include <linux/irqreturn.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/videodev2.h>
+
+#include <media/media-entity.h>
+#include <media/videobuf2-core.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-mediabus.h>
+#include <media/s5p_fimc.h>
+
+#include "fimc-is-core.h"
+
+#define SCALER_SD_PAD_SINK	0
+#define SCALER_SD_PAD_SRC_FIFO	1
+#define SCALER_SD_PAD_SRC_DMA	2
+#define SCALER_SD_PADS_NUM	3
+
+#define SCALER_MAX_BUFS		32
+#define SCALER_MAX_PLANES	3
+
+/**
+ * struct fimc_is_scaler - fimc-is scaler structure
+ * @vfd: video device node
+ * @fh: v4l2 file handle
+ * @alloc_ctx: videobuf2 memory allocator context
+ * @subdev: fimc-is-scaler subdev
+ * @vd_pad: media pad for the output video node
+ * @subdev_pads: the subdev media pads
+ * @ctrl_handler: v4l2 control handler
+ * @video_lock: video lock mutex
+ * @refcount: keeps track of number of instances opened
+ * @event_q: notifies scaler events
+ * @pipeline: pipeline instance for this scaler context
+ * @scaler_id: distinguishes scaler preview or scaler codec
+ * @vbq: vb2 buffers queue for ISP output video node
+ * @wait_queue: list holding buffers waiting to be queued to HW
+ * @wait_queue_cnt: wait queue number of buffers
+ * @run_queue: list holding buffers queued to HW
+ * @run_queue_cnt: run queue number of buffers
+ * @capture_bufs: scaler capture buffers array
+ * @cap_buf_cnt: number of capture buffers in use
+ * @fmt: capture plane format for scaler
+ * @width: user configured output width
+ * @height: user configured output height
+ * @num_buffers: number of capture plane buffers in use
+ * @capture_state: state of the capture video node operations
+ * @buf_paddr: holds the physical address of capture buffers
+ */
+struct fimc_is_scaler {
+	struct video_device		vfd;
+	struct v4l2_fh			fh;
+	struct vb2_alloc_ctx		*alloc_ctx;
+	struct v4l2_subdev		subdev;
+	struct media_pad		vd_pad;
+	struct media_pad		subdev_pads[SCALER_SD_PADS_NUM];
+	struct v4l2_mbus_framefmt	subdev_fmt;
+	struct v4l2_ctrl_handler	ctrl_handler;
+
+	struct mutex		video_lock;
+	unsigned int		refcount;
+	wait_queue_head_t	event_q;
+
+	struct fimc_is_pipeline	*pipeline;
+	enum fimc_is_scaler_id	scaler_id;
+
+	struct vb2_queue	vbq;
+	struct list_head	wait_queue;
+	unsigned int		wait_queue_cnt;
+	struct list_head	run_queue;
+	unsigned int		run_queue_cnt;
+
+	struct fimc_is_buf	capture_bufs[SCALER_MAX_BUFS];
+	unsigned int		cap_buf_cnt;
+
+	struct fimc_is_fmt	*fmt;
+	unsigned int		width;
+	unsigned int		height;
+	unsigned int		num_buffers;
+	unsigned long		capture_state;
+	unsigned int		buf_paddr[SCALER_MAX_BUFS][SCALER_MAX_PLANES];
+};
+
+int fimc_is_scaler_subdev_create(struct fimc_is_scaler *ctx,
+		enum fimc_is_scaler_id scaler_id,
+		struct vb2_alloc_ctx *alloc_ctx,
+		struct fimc_is_pipeline *pipeline);
+void fimc_is_scaler_subdev_destroy(struct fimc_is_scaler *scaler);
+
+#endif /* FIMC_IS_SCALER_H_ */
-- 
1.7.9.5

