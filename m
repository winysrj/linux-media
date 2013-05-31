Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:55324 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634Ab3EaMoQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 08:44:16 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MNN0078VY1M9LK0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 May 2013 21:44:15 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, kilyeon.im@samsung.com,
	shaik.ameer@samsung.com, arunkk.samsung@gmail.com
Subject: [RFC v2 06/10] exynos5-fimc-is: Adds isp subdev
Date: Fri, 31 May 2013 18:33:24 +0530
Message-id: <1370005408-10853-7-git-send-email-arun.kk@samsung.com>
In-reply-to: <1370005408-10853-1-git-send-email-arun.kk@samsung.com>
References: <1370005408-10853-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

fimc-is driver takes video data input from the ISP video node
which is added in this patch. This node accepts Bayer input
buffers which is given from the IS sensors.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
---
 drivers/media/platform/exynos5-is/fimc-is-isp.c |  438 +++++++++++++++++++++++
 drivers/media/platform/exynos5-is/fimc-is-isp.h |   89 +++++
 2 files changed, 527 insertions(+)
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-isp.c
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-isp.h

diff --git a/drivers/media/platform/exynos5-is/fimc-is-isp.c b/drivers/media/platform/exynos5-is/fimc-is-isp.c
new file mode 100644
index 0000000..2890f17
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/fimc-is-isp.c
@@ -0,0 +1,438 @@
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
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "fimc-is.h"
+
+#define ISP_DRV_NAME "fimc-is-isp"
+
+static const struct fimc_is_fmt formats[] = {
+	{
+		.name           = "Bayer GR-BG 8bits",
+		.fourcc         = V4L2_PIX_FMT_SGRBG8,
+		.depth		= {8},
+		.num_planes     = 1,
+	},
+	{
+		.name           = "Bayer GR-BG 10bits",
+		.fourcc         = V4L2_PIX_FMT_SGRBG10,
+		.depth		= {10},
+		.num_planes     = 1,
+	},
+	{
+		.name           = "Bayer GR-BG 12bits",
+		.fourcc         = V4L2_PIX_FMT_SGRBG12,
+		.depth		= {12},
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
+			return (struct fimc_is_fmt *) &formats[i];
+	}
+	return NULL;
+}
+
+static int isp_video_output_start_streaming(struct vb2_queue *vq,
+					unsigned int count)
+{
+	struct fimc_is_isp *isp = vb2_get_drv_priv(vq);
+
+	/* Set state to RUNNING */
+	set_bit(STATE_RUNNING, &isp->output_state);
+	return 0;
+}
+
+static int isp_video_output_stop_streaming(struct vb2_queue *vq)
+{
+	struct fimc_is_isp *isp = vb2_get_drv_priv(vq);
+
+	clear_bit(STATE_RUNNING, &isp->output_state);
+	return 0;
+}
+
+static int isp_video_output_queue_setup(struct vb2_queue *vq,
+			const struct v4l2_format *pfmt,
+			unsigned int *num_buffers, unsigned int *num_planes,
+			unsigned int sizes[], void *allocators[])
+{
+	struct fimc_is_isp *isp = vb2_get_drv_priv(vq);
+	struct fimc_is_fmt *fmt = isp->fmt;
+	unsigned int wh, i;
+
+	if (!fmt)
+		return -EINVAL;
+
+	*num_planes = fmt->num_planes;
+	wh = isp->width * isp->height;
+
+	for (i = 0; i < *num_planes; i++) {
+		allocators[i] = isp->alloc_ctx;
+		sizes[i] = (wh * fmt->depth[i]) / 8;
+	}
+	return 0;
+}
+
+static int isp_video_output_buffer_init(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct fimc_is_isp *isp = vb2_get_drv_priv(vq);
+	struct fimc_is_buf *buf;
+
+	buf = &isp->output_bufs[vb->v4l2_buf.index];
+	/* Initialize buffer */
+	buf->vb = vb;
+	buf->paddr[0] = vb2_dma_contig_plane_dma_addr(vb, 0);
+	isp->out_buf_cnt++;
+	return 0;
+}
+
+static void isp_video_output_buffer_queue(struct vb2_buffer *vb)
+{
+	struct vb2_queue *vq = vb->vb2_queue;
+	struct fimc_is_isp *isp = vb2_get_drv_priv(vq);
+	struct fimc_is_buf *buf;
+
+	buf = &isp->output_bufs[vb->v4l2_buf.index];
+
+	fimc_is_pipeline_buf_lock(isp->pipeline);
+	fimc_is_isp_wait_queue_add(isp, buf);
+	fimc_is_pipeline_buf_unlock(isp->pipeline);
+
+	/* Call shot command */
+	fimc_is_pipeline_shot(isp->pipeline);
+}
+
+static void isp_lock(struct vb2_queue *vq)
+{
+	struct fimc_is_isp *isp = vb2_get_drv_priv(vq);
+	mutex_lock(&isp->video_lock);
+}
+
+static void isp_unlock(struct vb2_queue *vq)
+{
+	struct fimc_is_isp *isp = vb2_get_drv_priv(vq);
+	mutex_unlock(&isp->video_lock);
+}
+
+static const struct vb2_ops isp_video_output_qops = {
+	.queue_setup	 = isp_video_output_queue_setup,
+	.buf_init	 = isp_video_output_buffer_init,
+	.buf_queue	 = isp_video_output_buffer_queue,
+	.wait_prepare	 = isp_unlock,
+	.wait_finish	 = isp_lock,
+	.start_streaming = isp_video_output_start_streaming,
+	.stop_streaming	 = isp_video_output_stop_streaming,
+};
+
+static int isp_video_output_open(struct file *file)
+{
+	struct fimc_is_isp *isp = video_drvdata(file);
+	int ret = 0;
+
+	/* Check if opened before */
+	if (isp->refcount >= FIMC_IS_MAX_INSTANCES) {
+		pr_err("All instances are in use.\n");
+		return -EBUSY;
+	}
+
+	INIT_LIST_HEAD(&isp->wait_queue);
+	isp->wait_queue_cnt = 0;
+	INIT_LIST_HEAD(&isp->run_queue);
+	isp->run_queue_cnt = 0;
+
+	isp->refcount++;
+	return ret;
+}
+
+static int isp_video_output_close(struct file *file)
+{
+	struct fimc_is_isp *isp = video_drvdata(file);
+	int ret = 0;
+
+	isp->refcount--;
+	isp->output_state = 0;
+	vb2_fop_release(file);
+	return ret;
+}
+
+static const struct v4l2_file_operations isp_video_output_fops = {
+	.owner		= THIS_MODULE,
+	.open		= isp_video_output_open,
+	.release	= isp_video_output_close,
+	.poll		= vb2_fop_poll,
+	.unlocked_ioctl	= video_ioctl2,
+	.mmap		= vb2_fop_mmap,
+};
+
+/*
+ * Video node ioctl operations
+ */
+static int isp_querycap_output(struct file *file, void *priv,
+					struct v4l2_capability *cap)
+{
+	strncpy(cap->driver, ISP_DRV_NAME, sizeof(cap->driver) - 1);
+	strncpy(cap->card, ISP_DRV_NAME, sizeof(cap->card) - 1);
+	strncpy(cap->bus_info, ISP_DRV_NAME, sizeof(cap->bus_info) - 1);
+	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
+	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
+	return 0;
+}
+
+static int isp_enum_fmt_mplane(struct file *file, void *priv,
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
+
+	return 0;
+}
+
+static int isp_g_fmt_mplane(struct file *file, void *fh,
+				  struct v4l2_format *f)
+{
+	struct fimc_is_isp *isp = video_drvdata(file);
+	struct v4l2_pix_format_mplane *pixm = &f->fmt.pix_mp;
+	struct v4l2_plane_pix_format *plane_fmt = &pixm->plane_fmt[0];
+	const struct fimc_is_fmt *fmt = isp->fmt;
+
+	plane_fmt->bytesperline = (isp->width * fmt->depth[0]) / 8;
+	plane_fmt->sizeimage = plane_fmt->bytesperline * isp->height;
+
+	pixm->num_planes = fmt->num_planes;
+	pixm->pixelformat = fmt->fourcc;
+	pixm->width = isp->width;
+	pixm->height = isp->height;
+	pixm->field = V4L2_FIELD_NONE;
+	pixm->colorspace = V4L2_COLORSPACE_JPEG;
+
+	return 0;
+}
+
+static int isp_try_fmt_mplane(struct file *file, void *fh,
+		struct v4l2_format *f)
+{
+	struct fimc_is_fmt *fmt;
+
+	fmt = find_format(f);
+	if (!fmt) {
+		fmt = (struct fimc_is_fmt *) &formats[0];
+		f->fmt.pix_mp.pixelformat = fmt->fourcc;
+	}
+
+	if (fmt->num_planes != f->fmt.pix_mp.num_planes)
+		f->fmt.pix_mp.num_planes = fmt->num_planes;
+
+	return 0;
+}
+
+static int isp_s_fmt_mplane(struct file *file, void *priv,
+		struct v4l2_format *f)
+{
+	struct fimc_is_isp *isp = video_drvdata(file);
+	struct fimc_is_pipeline *p = isp->pipeline;
+	struct fimc_is_fmt *fmt;
+	unsigned int sensor_width, sensor_height;
+	int ret;
+
+	ret = isp_try_fmt_mplane(file, priv, f);
+	if (ret)
+		return ret;
+
+	/* Get format type */
+	fmt = find_format(f);
+	if (!fmt) {
+		fmt = (struct fimc_is_fmt *) &formats[0];
+		f->fmt.pix_mp.pixelformat = fmt->fourcc;
+		f->fmt.pix_mp.num_planes = fmt->num_planes;
+	}
+
+	/* Check if same as sensor width & height */
+	sensor_width = p->sensor->drvdata->pixel_width;
+	sensor_height = p->sensor->drvdata->pixel_height;
+	if ((sensor_width != f->fmt.pix_mp.width) ||
+		(sensor_height != f->fmt.pix_mp.height)) {
+		f->fmt.pix_mp.width = sensor_width;
+		f->fmt.pix_mp.height = sensor_height;
+	}
+
+	isp->fmt = fmt;
+	isp->width = f->fmt.pix_mp.width;
+	isp->height = f->fmt.pix_mp.height;
+	isp->size_image = f->fmt.pix_mp.plane_fmt[0].sizeimage;
+	set_bit(STATE_INIT, &isp->output_state);
+	return 0;
+}
+
+static int isp_reqbufs(struct file *file, void *priv,
+		struct v4l2_requestbuffers *reqbufs)
+{
+	struct fimc_is_isp *isp = video_drvdata(file);
+	int ret;
+
+	ret = vb2_reqbufs(&isp->vbq, reqbufs);
+	if (ret) {
+		pr_err("vb2 req buffers failed\n");
+		return ret;
+	}
+
+	isp->num_buffers = reqbufs->count;
+	isp->out_buf_cnt = 0;
+	set_bit(STATE_BUFS_ALLOCATED, &isp->output_state);
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops isp_video_output_ioctl_ops = {
+	.vidioc_querycap		= isp_querycap_output,
+	.vidioc_enum_fmt_vid_out_mplane	= isp_enum_fmt_mplane,
+	.vidioc_try_fmt_vid_out_mplane	= isp_try_fmt_mplane,
+	.vidioc_s_fmt_vid_out_mplane	= isp_s_fmt_mplane,
+	.vidioc_g_fmt_vid_out_mplane	= isp_g_fmt_mplane,
+	.vidioc_reqbufs			= isp_reqbufs,
+	.vidioc_querybuf		= vb2_ioctl_querybuf,
+	.vidioc_qbuf			= vb2_ioctl_qbuf,
+	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
+	.vidioc_streamon		= vb2_ioctl_streamon,
+	.vidioc_streamoff		= vb2_ioctl_streamoff,
+};
+
+static int isp_subdev_registered(struct v4l2_subdev *sd)
+{
+	struct fimc_is_isp *isp = v4l2_get_subdevdata(sd);
+	struct vb2_queue *q = &isp->vbq;
+	struct video_device *vfd = &isp->vfd;
+	int ret;
+
+	mutex_init(&isp->video_lock);
+
+	memset(vfd, 0, sizeof(*vfd));
+	snprintf(vfd->name, sizeof(vfd->name), "fimc-is-isp.output");
+
+	vfd->fops = &isp_video_output_fops;
+	vfd->ioctl_ops = &isp_video_output_ioctl_ops;
+	vfd->v4l2_dev = sd->v4l2_dev;
+	vfd->minor = -1;
+	vfd->release = video_device_release_empty;
+	vfd->lock = &isp->video_lock;
+	vfd->queue = q;
+	vfd->vfl_dir = VFL_DIR_TX;
+
+	memset(q, 0, sizeof(*q));
+	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	q->io_modes = VB2_MMAP | VB2_DMABUF;
+	q->ops = &isp_video_output_qops;
+	q->mem_ops = &vb2_dma_contig_memops;
+	q->drv_priv = isp;
+
+	ret = vb2_queue_init(q);
+	if (ret < 0)
+		return ret;
+
+	isp->vd_pad.flags = MEDIA_PAD_FL_SINK;
+	ret = media_entity_init(&vfd->entity, 1, &isp->vd_pad, 0);
+	if (ret < 0)
+		return ret;
+
+	video_set_drvdata(vfd, isp);
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
+static void isp_subdev_unregistered(struct v4l2_subdev *sd)
+{
+	struct fimc_is_isp *isp = v4l2_get_subdevdata(sd);
+
+	if (isp && video_is_registered(&isp->vfd))
+		video_unregister_device(&isp->vfd);
+}
+
+static const struct v4l2_subdev_internal_ops isp_subdev_internal_ops = {
+	.registered = isp_subdev_registered,
+	.unregistered = isp_subdev_unregistered,
+};
+
+static struct v4l2_subdev_ops isp_subdev_ops;
+
+int fimc_is_isp_subdev_create(struct fimc_is_isp *isp,
+		struct vb2_alloc_ctx *alloc_ctx,
+		struct fimc_is_pipeline *pipeline)
+{
+	struct v4l2_ctrl_handler *handler = &isp->ctrl_handler;
+	struct v4l2_subdev *sd = &isp->subdev;
+	int ret;
+
+	/* Init context vars */
+	isp->alloc_ctx = alloc_ctx;
+	isp->pipeline = pipeline;
+	isp->refcount = 0;
+	isp->fmt = (struct fimc_is_fmt *) &formats[1];
+
+	v4l2_subdev_init(sd, &isp_subdev_ops);
+	sd->owner = THIS_MODULE;
+	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
+	snprintf(sd->name, sizeof(sd->name), ISP_DRV_NAME);
+
+	isp->subdev_pads[ISP_SD_PAD_SINK_DMA].flags = MEDIA_PAD_FL_SINK;
+	isp->subdev_pads[ISP_SD_PAD_SINK_OTF].flags = MEDIA_PAD_FL_SINK;
+	isp->subdev_pads[ISP_SD_PAD_SRC].flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_init(&sd->entity, ISP_SD_PADS_NUM,
+			isp->subdev_pads, 0);
+	if (ret < 0)
+		return ret;
+
+	ret = v4l2_ctrl_handler_init(handler, 1);
+	if (handler->error)
+		goto err_ctrl;
+
+	sd->ctrl_handler = handler;
+	sd->internal_ops = &isp_subdev_internal_ops;
+	v4l2_set_subdevdata(sd, isp);
+
+	return 0;
+
+err_ctrl:
+	media_entity_cleanup(&sd->entity);
+	v4l2_ctrl_handler_free(handler);
+	return ret;
+}
+
+void fimc_is_isp_subdev_destroy(struct fimc_is_isp *isp)
+{
+	struct v4l2_subdev *sd = &isp->subdev;
+
+	v4l2_device_unregister_subdev(sd);
+	media_entity_cleanup(&sd->entity);
+	v4l2_ctrl_handler_free(&isp->ctrl_handler);
+	v4l2_set_subdevdata(sd, NULL);
+}
+
diff --git a/drivers/media/platform/exynos5-is/fimc-is-isp.h b/drivers/media/platform/exynos5-is/fimc-is-isp.h
new file mode 100644
index 0000000..f707a8d
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/fimc-is-isp.h
@@ -0,0 +1,89 @@
+/*
+ * Samsung EXYNOS4x12 FIMC-IS (Imaging Subsystem) driver
+ *
+ * Copyright (C) 2012 Samsung Electronics Co., Ltd.
+ *  Arun Kumar K <arun.kk@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef FIMC_IS_ISP_H_
+#define FIMC_IS_ISP_H_
+
+#include "fimc-is-core.h"
+#include "fimc-is-pipeline.h"
+
+#define FIMC_IS_ISP_REQ_BUFS_MIN	2
+
+#define ISP_SD_PAD_SINK_DMA	0
+#define ISP_SD_PAD_SINK_OTF	1
+#define ISP_SD_PAD_SRC		2
+#define ISP_SD_PADS_NUM		3
+
+#define ISP_MAX_BUFS		2
+
+/**
+ * struct fimc_is_isp - ISP context
+ * @vfd: video device node
+ * @fh: v4l2 file handle
+ * @alloc_ctx: videobuf2 memory allocator context
+ * @subdev: fimc-is-isp subdev
+ * @vd_pad: media pad for the output video node
+ * @subdev_pads: the subdev media pads
+ * @ctrl_handler: v4l2 control handler
+ * @video_lock: video lock mutex
+ * @refcount: keeps track of number of instances opened
+ * @pipeline: pipeline instance for this isp context
+ * @vbq: vb2 buffers queue for ISP output video node
+ * @wait_queue: list holding buffers waiting to be queued to HW
+ * @wait_queue_cnt: wait queue number of buffers
+ * @run_queue: list holding buffers queued to HW
+ * @run_queue_cnt: run queue number of buffers
+ * @output_bufs: isp output buffers array
+ * @out_buf_cnt: number of output buffers in use
+ * @fmt: output plane format for isp
+ * @width: user configured input width
+ * @height: user configured input height
+ * @num_buffers: number of output plane buffers in use
+ * @size_image: image size in bytes
+ * @output_state: state of the output video node operations
+ */
+struct fimc_is_isp {
+	struct video_device		vfd;
+	struct v4l2_fh			fh;
+	struct vb2_alloc_ctx		*alloc_ctx;
+	struct v4l2_subdev		subdev;
+	struct media_pad		vd_pad;
+	struct media_pad		subdev_pads[ISP_SD_PADS_NUM];
+	struct v4l2_ctrl_handler	ctrl_handler;
+
+	struct mutex			video_lock;
+
+	unsigned int			refcount;
+
+	struct fimc_is_pipeline		*pipeline;
+
+	struct vb2_queue		vbq;
+	struct list_head		wait_queue;
+	unsigned int			wait_queue_cnt;
+	struct list_head		run_queue;
+	unsigned int			run_queue_cnt;
+
+	struct fimc_is_buf		output_bufs[ISP_MAX_BUFS];
+	unsigned int			out_buf_cnt;
+
+	struct fimc_is_fmt		*fmt;
+	unsigned int			width;
+	unsigned int			height;
+	unsigned int			num_buffers;
+	unsigned int			size_image;
+	unsigned long			output_state;
+};
+
+int fimc_is_isp_subdev_create(struct fimc_is_isp *isp,
+		struct vb2_alloc_ctx *alloc_ctx,
+		struct fimc_is_pipeline *pipeline);
+void fimc_is_isp_subdev_destroy(struct fimc_is_isp *isp);
+
+#endif /* FIMC_IS_ISP_H_ */
-- 
1.7.9.5

