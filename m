Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34265 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab0JKR0m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 13:26:42 -0400
Date: Mon, 11 Oct 2010 19:26:32 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 5/6 v5] V4L/DVB: s5p-fimc: Add camera capture support
In-reply-to: <1286817993-21558-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1286817993-21558-6-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1286817993-21558-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add a video device driver per each FIMC entity to support
the camera capture input mode. Video capture node is registered
only if CCD sensor data is provided through driver's platfrom data
and board setup code.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/s5p-fimc/Makefile       |    2 +-
 drivers/media/video/s5p-fimc/fimc-capture.c |  819 +++++++++++++++++++++++++++
 drivers/media/video/s5p-fimc/fimc-core.c    |  563 +++++++++++++------
 drivers/media/video/s5p-fimc/fimc-core.h    |  205 +++++++-
 drivers/media/video/s5p-fimc/fimc-reg.c     |  173 +++++-
 include/media/s3c_fimc.h                    |   60 ++
 6 files changed, 1630 insertions(+), 192 deletions(-)
 create mode 100644 drivers/media/video/s5p-fimc/fimc-capture.c
 create mode 100644 include/media/s3c_fimc.h

diff --git a/drivers/media/video/s5p-fimc/Makefile b/drivers/media/video/s5p-fimc/Makefile
index 0d9d541..7ea1b14 100644
--- a/drivers/media/video/s5p-fimc/Makefile
+++ b/drivers/media/video/s5p-fimc/Makefile
@@ -1,3 +1,3 @@
 
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) := s5p-fimc.o
-s5p-fimc-y := fimc-core.o fimc-reg.o
+s5p-fimc-y := fimc-core.o fimc-reg.o fimc-capture.o
diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
new file mode 100644
index 0000000..e8f13d3
--- /dev/null
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -0,0 +1,819 @@
+/*
+ * Samsung S5P SoC series camera interface (camera capture) driver
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd
+ * Author: Sylwester Nawrocki, <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/version.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/bug.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <linux/i2c.h>
+
+#include <linux/videodev2.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/videobuf-core.h>
+#include <media/videobuf-dma-contig.h>
+
+#include "fimc-core.h"
+
+static struct v4l2_subdev *fimc_subdev_register(struct fimc_dev *fimc,
+					    struct s3c_fimc_isp_info *isp_info)
+{
+	struct i2c_adapter *i2c_adap;
+	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
+	struct v4l2_subdev *sd = NULL;
+
+	i2c_adap = i2c_get_adapter(isp_info->i2c_bus_num);
+	if (!i2c_adap)
+		return ERR_PTR(-ENOMEM);
+
+	sd = v4l2_i2c_new_subdev_board(&vid_cap->v4l2_dev, i2c_adap,
+				       MODULE_NAME, isp_info->board_info, NULL);
+	if (!sd) {
+		v4l2_err(&vid_cap->v4l2_dev, "failed to acquire subdev\n");
+		return NULL;
+	}
+
+	v4l2_info(&vid_cap->v4l2_dev, "subdevice %s registered successfuly\n",
+		isp_info->board_info->type);
+
+	return sd;
+}
+
+static void fimc_subdev_unregister(struct fimc_dev *fimc)
+{
+	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
+	struct i2c_client *client;
+
+	if (vid_cap->input_index < 0)
+		return;	/* Subdevice already released or not registered. */
+
+	if (vid_cap->sd) {
+		v4l2_device_unregister_subdev(vid_cap->sd);
+		client = v4l2_get_subdevdata(vid_cap->sd);
+		i2c_unregister_device(client);
+		i2c_put_adapter(client->adapter);
+		vid_cap->sd = NULL;
+	}
+
+	vid_cap->input_index = -1;
+}
+
+/**
+ * fimc_subdev_attach - attach v4l2_subdev to camera host interface
+ *
+ * @fimc: FIMC device information
+ * @index: index to the array of available subdevices,
+ *	   -1 for full array search or non negative value
+ *	   to select specific subdevice
+ */
+static int fimc_subdev_attach(struct fimc_dev *fimc, int index)
+{
+	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
+	struct s3c_platform_fimc *pdata = fimc->pdata;
+	struct s3c_fimc_isp_info *isp_info;
+	struct v4l2_subdev *sd;
+	int i;
+
+	for (i = 0; i < FIMC_MAX_CAMIF_CLIENTS; ++i) {
+		isp_info = pdata->isp_info[i];
+
+		if (!isp_info || (index >= 0 && i != index))
+			continue;
+
+		sd = fimc_subdev_register(fimc, isp_info);
+		if (sd) {
+			vid_cap->sd = sd;
+			vid_cap->input_index = i;
+
+			return 0;
+		}
+	}
+
+	vid_cap->input_index = -1;
+	vid_cap->sd = NULL;
+	v4l2_err(&vid_cap->v4l2_dev, "fimc%d: sensor attach failed\n",
+		 fimc->id);
+	return -ENODEV;
+}
+
+static int fimc_isp_subdev_init(struct fimc_dev *fimc, int index)
+{
+	struct s3c_fimc_isp_info *isp_info;
+	int ret;
+
+	ret = fimc_subdev_attach(fimc, index);
+	if (ret)
+		return ret;
+
+	isp_info = fimc->pdata->isp_info[fimc->vid_cap.input_index];
+	ret = fimc_hw_set_camera_polarity(fimc, isp_info);
+	if (!ret) {
+		ret = v4l2_subdev_call(fimc->vid_cap.sd, core,
+				       s_power, 1);
+		if (!ret)
+			return ret;
+	}
+
+	fimc_subdev_unregister(fimc);
+	err("ISP initialization failed: %d", ret);
+	return ret;
+}
+
+/*
+ * At least one buffer on the pending_buf_q queue is required.
+ * Locking: The caller holds fimc->slock spinlock.
+ */
+int fimc_vid_cap_buf_queue(struct fimc_dev *fimc,
+			     struct fimc_vid_buffer *fimc_vb)
+{
+	struct fimc_vid_cap *cap = &fimc->vid_cap;
+	struct fimc_ctx *ctx = cap->ctx;
+	int ret = 0;
+
+	BUG_ON(!fimc || !fimc_vb);
+
+	ret = fimc_prepare_addr(ctx, fimc_vb, &ctx->d_frame,
+				&fimc_vb->paddr);
+	if (ret)
+		return ret;
+
+	if (test_bit(ST_CAPT_STREAM, &fimc->state)) {
+		fimc_pending_queue_add(cap, fimc_vb);
+	} else {
+		/* Setup the buffer directly for processing. */
+		int buf_id = (cap->reqbufs_count == 1) ? -1 : cap->buf_index;
+		fimc_hw_set_output_addr(fimc, &fimc_vb->paddr, buf_id);
+
+		fimc_vb->index = cap->buf_index;
+		active_queue_add(cap, fimc_vb);
+
+		if (++cap->buf_index >= FIMC_MAX_OUT_BUFS)
+			cap->buf_index = 0;
+	}
+	return ret;
+}
+
+static int fimc_stop_capture(struct fimc_dev *fimc)
+{
+	unsigned long flags;
+	struct fimc_vid_cap *cap;
+	int ret;
+
+	cap = &fimc->vid_cap;
+
+	if (!fimc_capture_active(fimc))
+		return 0;
+
+	spin_lock_irqsave(&fimc->slock, flags);
+	set_bit(ST_CAPT_SHUT, &fimc->state);
+	fimc_deactivate_capture(fimc);
+	spin_unlock_irqrestore(&fimc->slock, flags);
+
+	wait_event_timeout(fimc->irq_queue,
+			   test_bit(ST_CAPT_SHUT, &fimc->state),
+			   FIMC_SHUTDOWN_TIMEOUT);
+
+	ret = v4l2_subdev_call(cap->sd, video, s_stream, 0);
+	if (ret)
+		v4l2_err(&fimc->vid_cap.v4l2_dev, "s_stream(0) failed\n");
+
+	spin_lock_irqsave(&fimc->slock, flags);
+	fimc->state &= ~(1 << ST_CAPT_RUN | 1 << ST_CAPT_PEND |
+			1 << ST_CAPT_STREAM);
+
+	fimc->vid_cap.active_buf_cnt = 0;
+	spin_unlock_irqrestore(&fimc->slock, flags);
+
+	dbg("state: 0x%lx", fimc->state);
+	return 0;
+}
+
+static int fimc_capture_open(struct file *file)
+{
+	struct fimc_dev *fimc = video_drvdata(file);
+	int ret = 0;
+
+	dbg("pid: %d, state: 0x%lx", task_pid_nr(current), fimc->state);
+
+	/* Return if the corresponding video mem2mem node is already opened. */
+	if (fimc_m2m_active(fimc))
+		return -EBUSY;
+
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
+
+	if (++fimc->vid_cap.refcnt == 1) {
+		ret = fimc_isp_subdev_init(fimc, -1);
+		if (ret) {
+			fimc->vid_cap.refcnt--;
+			ret = -EIO;
+		}
+	}
+
+	file->private_data = fimc->vid_cap.ctx;
+
+	mutex_unlock(&fimc->lock);
+	return ret;
+}
+
+static int fimc_capture_close(struct file *file)
+{
+	struct fimc_dev *fimc = video_drvdata(file);
+
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
+
+	dbg("pid: %d, state: 0x%lx", task_pid_nr(current), fimc->state);
+
+	if (--fimc->vid_cap.refcnt == 0) {
+		fimc_stop_capture(fimc);
+
+		videobuf_stop(&fimc->vid_cap.vbq);
+		videobuf_mmap_free(&fimc->vid_cap.vbq);
+
+		v4l2_err(&fimc->vid_cap.v4l2_dev, "releasing ISP\n");
+		v4l2_subdev_call(fimc->vid_cap.sd, core, s_power, 0);
+		fimc_subdev_unregister(fimc);
+	}
+
+	mutex_unlock(&fimc->lock);
+	return 0;
+}
+
+static unsigned int fimc_capture_poll(struct file *file,
+				      struct poll_table_struct *wait)
+{
+	struct fimc_ctx *ctx = file->private_data;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct fimc_vid_cap *cap = &fimc->vid_cap;
+	int ret;
+
+	if (mutex_lock_interruptible(&fimc->lock))
+		return POLLERR;
+
+	ret = videobuf_poll_stream(file, &cap->vbq, wait);
+	mutex_unlock(&fimc->lock);
+
+	return ret;
+}
+
+static int fimc_capture_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct fimc_ctx *ctx = file->private_data;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct fimc_vid_cap *cap = &fimc->vid_cap;
+	int ret;
+
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
+
+	ret = videobuf_mmap_mapper(&cap->vbq, vma);
+	mutex_unlock(&fimc->lock);
+
+	return ret;
+}
+
+/* video device file operations */
+static const struct v4l2_file_operations fimc_capture_fops = {
+	.owner		= THIS_MODULE,
+	.open		= fimc_capture_open,
+	.release	= fimc_capture_close,
+	.poll		= fimc_capture_poll,
+	.unlocked_ioctl	= video_ioctl2,
+	.mmap		= fimc_capture_mmap,
+};
+
+static int fimc_vidioc_querycap_capture(struct file *file, void *priv,
+					struct v4l2_capability *cap)
+{
+	struct fimc_ctx *ctx = file->private_data;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+
+	strncpy(cap->driver, fimc->pdev->name, sizeof(cap->driver) - 1);
+	strncpy(cap->card, fimc->pdev->name, sizeof(cap->card) - 1);
+	cap->bus_info[0] = 0;
+	cap->version = KERNEL_VERSION(1, 0, 0);
+	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE;
+
+	return 0;
+}
+
+/* Synchronize formats of the camera interface input and attached  sensor. */
+static int sync_capture_fmt(struct fimc_ctx *ctx)
+{
+	struct fimc_frame *frame = &ctx->s_frame;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct v4l2_mbus_framefmt *fmt = &fimc->vid_cap.fmt;
+	int ret;
+
+	fmt->width  = ctx->d_frame.o_width;
+	fmt->height = ctx->d_frame.o_height;
+
+	ret = v4l2_subdev_call(fimc->vid_cap.sd, video, s_mbus_fmt, fmt);
+	if (ret == -ENOIOCTLCMD) {
+		err("s_mbus_fmt failed");
+		return ret;
+	}
+	dbg("w: %d, h: %d, code= %d", fmt->width, fmt->height, fmt->code);
+
+	frame->fmt = find_mbus_format(fmt, FMT_FLAGS_CAM);
+	if (!frame->fmt) {
+		err("fimc source format not found\n");
+		return -EINVAL;
+	}
+
+	frame->f_width	= fmt->width;
+	frame->f_height = fmt->height;
+	frame->width	= fmt->width;
+	frame->height	= fmt->height;
+	frame->o_width	= fmt->width;
+	frame->o_height = fmt->height;
+	frame->offs_h	= 0;
+	frame->offs_v	= 0;
+
+	return 0;
+}
+
+static int fimc_cap_s_fmt(struct file *file, void *priv,
+			     struct v4l2_format *f)
+{
+	struct fimc_ctx *ctx = priv;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct fimc_frame *frame;
+	struct v4l2_pix_format *pix;
+	int ret;
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	ret = fimc_vidioc_try_fmt(file, priv, f);
+	if (ret)
+		return ret;
+
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
+
+	if (fimc_capture_active(fimc)) {
+		ret = -EBUSY;
+		goto sf_unlock;
+	}
+
+	frame = &ctx->d_frame;
+
+	pix = &f->fmt.pix;
+	frame->fmt = find_format(f, FMT_FLAGS_M2M | FMT_FLAGS_CAM);
+	if (!frame->fmt) {
+		err("fimc target format not found\n");
+		ret = -EINVAL;
+		goto sf_unlock;
+	}
+
+	/* Output DMA frame pixel size and offsets. */
+	frame->f_width	= pix->bytesperline * 8 / frame->fmt->depth;
+	frame->f_height = pix->height;
+	frame->width	= pix->width;
+	frame->height	= pix->height;
+	frame->o_width	= pix->width;
+	frame->o_height = pix->height;
+	frame->size	= (pix->width * pix->height * frame->fmt->depth) >> 3;
+	frame->offs_h	= 0;
+	frame->offs_v	= 0;
+
+	ret = sync_capture_fmt(ctx);
+
+	ctx->state |= (FIMC_PARAMS | FIMC_DST_FMT);
+
+sf_unlock:
+	mutex_unlock(&fimc->lock);
+	return ret;
+}
+
+static int fimc_cap_enum_input(struct file *file, void *priv,
+				     struct v4l2_input *i)
+{
+	struct fimc_ctx *ctx = priv;
+	struct s3c_platform_fimc *pldata = ctx->fimc_dev->pdata;
+	struct s3c_fimc_isp_info *isp_info;
+
+	if (i->index >= FIMC_MAX_CAMIF_CLIENTS)
+		return -EINVAL;
+
+	isp_info = pldata->isp_info[i->index];
+	if (isp_info == NULL)
+		return -EINVAL;
+
+	i->type = V4L2_INPUT_TYPE_CAMERA;
+	strncpy(i->name, isp_info->board_info->type, 32);
+	return 0;
+}
+
+static int fimc_cap_s_input(struct file *file, void *priv,
+				  unsigned int i)
+{
+	struct fimc_ctx *ctx = priv;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct s3c_platform_fimc *pdata = fimc->pdata;
+	int ret;
+
+	if (fimc_capture_active(ctx->fimc_dev))
+		return -EBUSY;
+
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
+
+	if (i >= FIMC_MAX_CAMIF_CLIENTS || !pdata->isp_info[i]) {
+		ret = -EINVAL;
+		goto si_unlock;
+	}
+
+	if (fimc->vid_cap.sd) {
+		ret = v4l2_subdev_call(fimc->vid_cap.sd, core, s_power, 0);
+		if (ret)
+			err("s_power failed: %d", ret);
+	}
+
+	/* Release the attached sensor subdevice. */
+	fimc_subdev_unregister(fimc);
+
+	ret = fimc_isp_subdev_init(fimc, i);
+
+si_unlock:
+	mutex_unlock(&fimc->lock);
+	return ret;
+}
+
+static int fimc_cap_g_input(struct file *file, void *priv,
+				       unsigned int *i)
+{
+	struct fimc_ctx *ctx = priv;
+	struct fimc_vid_cap *cap = &ctx->fimc_dev->vid_cap;
+
+	*i = cap->input_index;
+	return 0;
+}
+
+static int fimc_cap_streamon(struct file *file, void *priv,
+			   enum v4l2_buf_type type)
+{
+	struct s3c_fimc_isp_info *isp_info;
+	struct fimc_ctx *ctx = priv;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	int ret = -EBUSY;
+
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
+
+	if (fimc_capture_active(fimc) || !fimc->vid_cap.sd)
+		goto s_unlock;
+
+	if (!(ctx->state & FIMC_DST_FMT)) {
+		v4l2_err(&fimc->vid_cap.v4l2_dev, "Format is not set\n");
+		ret = -EINVAL;
+		goto s_unlock;
+	}
+
+	ret = v4l2_subdev_call(fimc->vid_cap.sd, video, s_stream, 1);
+	if (ret && ret != -ENOIOCTLCMD)
+		goto s_unlock;
+
+	ret = fimc_prepare_config(ctx, ctx->state);
+	if (ret)
+		goto s_unlock;
+
+	isp_info = fimc->pdata->isp_info[fimc->vid_cap.input_index];
+	fimc_hw_set_camera_type(fimc, isp_info);
+	fimc_hw_set_camera_source(fimc, isp_info);
+	fimc_hw_set_camera_offset(fimc, &ctx->s_frame);
+
+	if (ctx->state & FIMC_PARAMS) {
+		ret = fimc_set_scaler_info(ctx);
+		if (ret) {
+			err("Scaler setup error");
+			goto s_unlock;
+		}
+		fimc_hw_set_input_path(ctx);
+		fimc_hw_set_scaler(ctx);
+		fimc_hw_set_target_format(ctx);
+		fimc_hw_set_rotation(ctx);
+		fimc_hw_set_effect(ctx);
+	}
+
+	fimc_hw_set_output_path(ctx);
+	fimc_hw_set_out_dma(ctx);
+
+	INIT_LIST_HEAD(&fimc->vid_cap.pending_buf_q);
+	INIT_LIST_HEAD(&fimc->vid_cap.active_buf_q);
+	fimc->vid_cap.active_buf_cnt = 0;
+	fimc->vid_cap.frame_count = 0;
+
+	set_bit(ST_CAPT_PEND, &fimc->state);
+	ret = videobuf_streamon(&fimc->vid_cap.vbq);
+
+s_unlock:
+	mutex_unlock(&fimc->lock);
+	return ret;
+}
+
+static int fimc_cap_streamoff(struct file *file, void *priv,
+			    enum v4l2_buf_type type)
+{
+	struct fimc_ctx *ctx = priv;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct fimc_vid_cap *cap = &fimc->vid_cap;
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&fimc->slock, flags);
+	if (!fimc_capture_running(fimc) && !fimc_capture_pending(fimc)) {
+		spin_unlock_irqrestore(&fimc->slock, flags);
+		dbg("state: 0x%lx", fimc->state);
+		return -EINVAL;
+	}
+	spin_unlock_irqrestore(&fimc->slock, flags);
+
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
+
+	fimc_stop_capture(fimc);
+	ret = videobuf_streamoff(&cap->vbq);
+	mutex_unlock(&fimc->lock);
+	return ret;
+}
+
+static int fimc_cap_reqbufs(struct file *file, void *priv,
+			  struct v4l2_requestbuffers *reqbufs)
+{
+	struct fimc_ctx *ctx = priv;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct fimc_vid_cap *cap = &fimc->vid_cap;
+	int ret;
+
+	if (fimc_capture_active(ctx->fimc_dev))
+		return -EBUSY;
+
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
+
+	ret = videobuf_reqbufs(&cap->vbq, reqbufs);
+	if (!ret)
+		cap->reqbufs_count = reqbufs->count;
+
+	mutex_unlock(&fimc->lock);
+	return ret;
+}
+
+static int fimc_cap_querybuf(struct file *file, void *priv,
+			   struct v4l2_buffer *buf)
+{
+	struct fimc_ctx *ctx = priv;
+	struct fimc_vid_cap *cap = &ctx->fimc_dev->vid_cap;
+
+	if (fimc_capture_active(ctx->fimc_dev))
+		return -EBUSY;
+
+	return videobuf_querybuf(&cap->vbq, buf);
+}
+
+static int fimc_cap_qbuf(struct file *file, void *priv,
+			  struct v4l2_buffer *buf)
+{
+	struct fimc_ctx *ctx = priv;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct fimc_vid_cap *cap = &fimc->vid_cap;
+	int ret;
+
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
+
+	ret = videobuf_qbuf(&cap->vbq, buf);
+
+	mutex_unlock(&fimc->lock);
+	return ret;
+}
+
+static int fimc_cap_dqbuf(struct file *file, void *priv,
+			   struct v4l2_buffer *buf)
+{
+	struct fimc_ctx *ctx = priv;
+	int ret;
+
+	if (mutex_lock_interruptible(&ctx->fimc_dev->lock))
+		return -ERESTARTSYS;
+
+	ret = videobuf_dqbuf(&ctx->fimc_dev->vid_cap.vbq, buf,
+		file->f_flags & O_NONBLOCK);
+
+	mutex_unlock(&ctx->fimc_dev->lock);
+	return ret;
+}
+
+static int fimc_cap_s_ctrl(struct file *file, void *priv,
+			 struct v4l2_control *ctrl)
+{
+	struct fimc_ctx *ctx = priv;
+	int ret = -EINVAL;
+
+	if (mutex_lock_interruptible(&ctx->fimc_dev->lock))
+		return -ERESTARTSYS;
+
+	/* Allow any controls but 90/270 rotation while streaming */
+	if (!fimc_capture_active(ctx->fimc_dev) ||
+	    ctrl->id != V4L2_CID_ROTATE ||
+	    (ctrl->value != 90 && ctrl->value != 270)) {
+		ret = check_ctrl_val(ctx, ctrl);
+		if (!ret) {
+			ret = fimc_s_ctrl(ctx, ctrl);
+			if (!ret)
+				ctx->state |= FIMC_PARAMS;
+		}
+	}
+	if (ret == -EINVAL)
+		ret = v4l2_subdev_call(ctx->fimc_dev->vid_cap.sd,
+				       core, s_ctrl, ctrl);
+
+	mutex_unlock(&ctx->fimc_dev->lock);
+	return ret;
+}
+
+static int fimc_cap_s_crop(struct file *file, void *fh,
+			       struct v4l2_crop *cr)
+{
+	struct fimc_frame *f;
+	struct fimc_ctx *ctx = file->private_data;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	int ret = -EINVAL;
+
+	if (fimc_capture_active(fimc))
+		return -EBUSY;
+
+	ret = fimc_try_crop(ctx, cr);
+	if (ret)
+		return ret;
+
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
+
+	if (!(ctx->state & FIMC_DST_FMT)) {
+		v4l2_err(&fimc->vid_cap.v4l2_dev,
+			 "Capture color format not set\n");
+		goto sc_unlock;
+	}
+
+	f = &ctx->s_frame;
+	/* Check for the pixel scaling ratio when cropping input image. */
+	ret = fimc_check_scaler_ratio(&cr->c, &ctx->d_frame);
+	if (ret) {
+		v4l2_err(&fimc->vid_cap.v4l2_dev, "Out of the scaler range");
+	} else {
+		ret = 0;
+		f->offs_h = cr->c.left;
+		f->offs_v = cr->c.top;
+		f->width  = cr->c.width;
+		f->height = cr->c.height;
+	}
+
+sc_unlock:
+	mutex_unlock(&fimc->lock);
+	return ret;
+}
+
+
+static const struct v4l2_ioctl_ops fimc_capture_ioctl_ops = {
+	.vidioc_querycap		= fimc_vidioc_querycap_capture,
+
+	.vidioc_enum_fmt_vid_cap	= fimc_vidioc_enum_fmt,
+	.vidioc_try_fmt_vid_cap		= fimc_vidioc_try_fmt,
+	.vidioc_s_fmt_vid_cap		= fimc_cap_s_fmt,
+	.vidioc_g_fmt_vid_cap		= fimc_vidioc_g_fmt,
+
+	.vidioc_reqbufs			= fimc_cap_reqbufs,
+	.vidioc_querybuf		= fimc_cap_querybuf,
+
+	.vidioc_qbuf			= fimc_cap_qbuf,
+	.vidioc_dqbuf			= fimc_cap_dqbuf,
+
+	.vidioc_streamon		= fimc_cap_streamon,
+	.vidioc_streamoff		= fimc_cap_streamoff,
+
+	.vidioc_queryctrl		= fimc_vidioc_queryctrl,
+	.vidioc_g_ctrl			= fimc_vidioc_g_ctrl,
+	.vidioc_s_ctrl			= fimc_cap_s_ctrl,
+
+	.vidioc_g_crop			= fimc_vidioc_g_crop,
+	.vidioc_s_crop			= fimc_cap_s_crop,
+	.vidioc_cropcap			= fimc_vidioc_cropcap,
+
+	.vidioc_enum_input		= fimc_cap_enum_input,
+	.vidioc_s_input			= fimc_cap_s_input,
+	.vidioc_g_input			= fimc_cap_g_input,
+};
+
+int fimc_register_capture_device(struct fimc_dev *fimc)
+{
+	struct v4l2_device *v4l2_dev = &fimc->vid_cap.v4l2_dev;
+	struct video_device *vfd;
+	struct fimc_vid_cap *vid_cap;
+	struct fimc_ctx *ctx;
+	struct v4l2_format f;
+	int ret;
+
+	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	ctx->fimc_dev	 = fimc;
+	ctx->in_path	 = FIMC_CAMERA;
+	ctx->out_path	 = FIMC_DMA;
+	ctx->state	 = FIMC_CTX_CAP;
+
+	f.fmt.pix.pixelformat = V4L2_PIX_FMT_RGB24;
+	ctx->d_frame.fmt = find_format(&f, FMT_FLAGS_M2M);
+
+	if (!v4l2_dev->name[0])
+		snprintf(v4l2_dev->name, sizeof(v4l2_dev->name),
+			 "%s.capture", dev_name(&fimc->pdev->dev));
+
+	ret = v4l2_device_register(NULL, v4l2_dev);
+	if (ret)
+		goto err_info;
+
+	vfd = video_device_alloc();
+	if (!vfd) {
+		v4l2_err(v4l2_dev, "Failed to allocate video device\n");
+		goto err_v4l2_reg;
+	}
+
+	snprintf(vfd->name, sizeof(vfd->name), "%s:cap",
+		 dev_name(&fimc->pdev->dev));
+
+	vfd->fops	= &fimc_capture_fops;
+	vfd->ioctl_ops	= &fimc_capture_ioctl_ops;
+	vfd->minor	= -1;
+	vfd->release	= video_device_release;
+	video_set_drvdata(vfd, fimc);
+
+	vid_cap = &fimc->vid_cap;
+	vid_cap->vfd = vfd;
+	vid_cap->active_buf_cnt = 0;
+	vid_cap->reqbufs_count  = 0;
+	vid_cap->refcnt = 0;
+	/* The default color format for image sensor. */
+	vid_cap->fmt.code = V4L2_MBUS_FMT_YUYV8_2X8;
+
+	INIT_LIST_HEAD(&vid_cap->pending_buf_q);
+	INIT_LIST_HEAD(&vid_cap->active_buf_q);
+	spin_lock_init(&ctx->slock);
+	vid_cap->ctx = ctx;
+
+	videobuf_queue_dma_contig_init(&vid_cap->vbq, &fimc_qops,
+		vid_cap->v4l2_dev.dev, &fimc->irqlock,
+		V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
+		sizeof(struct fimc_vid_buffer), (void *)ctx);
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
+	if (ret) {
+		v4l2_err(v4l2_dev, "Failed to register video device\n");
+		goto err_vd_reg;
+	}
+
+	v4l2_info(v4l2_dev,
+		  "FIMC capture driver registered as /dev/video%d\n",
+		  vfd->num);
+
+	return 0;
+
+err_vd_reg:
+	video_device_release(vfd);
+err_v4l2_reg:
+	v4l2_device_unregister(v4l2_dev);
+err_info:
+	dev_err(&fimc->pdev->dev, "failed to install\n");
+	return ret;
+}
+
+void fimc_unregister_capture_device(struct fimc_dev *fimc)
+{
+	struct fimc_vid_cap *capture = &fimc->vid_cap;
+
+	if (capture->vfd)
+		video_unregister_device(capture->vfd);
+
+	kfree(capture->ctx);
+}
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 85a7e72..064e7d5 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -1,7 +1,7 @@
 /*
  * S5P camera interface (video postprocessor) driver
  *
- * Copyright (c) 2010 Samsung Electronics
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd
  *
  * Sylwester Nawrocki, <s.nawrocki@samsung.com>
  *
@@ -38,85 +38,102 @@ static struct fimc_fmt fimc_formats[] = {
 		.depth	= 16,
 		.color	= S5P_FIMC_RGB565,
 		.buff_cnt = 1,
-		.planes_cnt = 1
+		.planes_cnt = 1,
+		.mbus_code = V4L2_MBUS_FMT_RGB565_2X8_BE,
+		.flags = FMT_FLAGS_M2M,
 	}, {
 		.name	= "BGR666",
 		.fourcc	= V4L2_PIX_FMT_BGR666,
 		.depth	= 32,
 		.color	= S5P_FIMC_RGB666,
 		.buff_cnt = 1,
-		.planes_cnt = 1
+		.planes_cnt = 1,
+		.flags = FMT_FLAGS_M2M,
 	}, {
 		.name = "XRGB-8-8-8-8, 24 bpp",
 		.fourcc	= V4L2_PIX_FMT_RGB24,
 		.depth = 32,
 		.color	= S5P_FIMC_RGB888,
 		.buff_cnt = 1,
-		.planes_cnt = 1
+		.planes_cnt = 1,
+		.flags = FMT_FLAGS_M2M,
 	}, {
 		.name	= "YUV 4:2:2 packed, YCbYCr",
 		.fourcc	= V4L2_PIX_FMT_YUYV,
 		.depth	= 16,
 		.color	= S5P_FIMC_YCBYCR422,
 		.buff_cnt = 1,
-		.planes_cnt = 1
-		}, {
+		.planes_cnt = 1,
+		.mbus_code = V4L2_MBUS_FMT_YUYV8_2X8,
+		.flags = FMT_FLAGS_M2M | FMT_FLAGS_CAM,
+	}, {
 		.name	= "YUV 4:2:2 packed, CbYCrY",
 		.fourcc	= V4L2_PIX_FMT_UYVY,
 		.depth	= 16,
 		.color	= S5P_FIMC_CBYCRY422,
 		.buff_cnt = 1,
-		.planes_cnt = 1
+		.planes_cnt = 1,
+		.mbus_code = V4L2_MBUS_FMT_UYVY8_2X8,
+		.flags = FMT_FLAGS_M2M | FMT_FLAGS_CAM,
 	}, {
 		.name	= "YUV 4:2:2 packed, CrYCbY",
 		.fourcc	= V4L2_PIX_FMT_VYUY,
 		.depth	= 16,
 		.color	= S5P_FIMC_CRYCBY422,
 		.buff_cnt = 1,
-		.planes_cnt = 1
+		.planes_cnt = 1,
+		.mbus_code = V4L2_MBUS_FMT_VYUY8_2X8,
+		.flags = FMT_FLAGS_M2M | FMT_FLAGS_CAM,
 	}, {
 		.name	= "YUV 4:2:2 packed, YCrYCb",
 		.fourcc	= V4L2_PIX_FMT_YVYU,
 		.depth	= 16,
 		.color	= S5P_FIMC_YCRYCB422,
 		.buff_cnt = 1,
-		.planes_cnt = 1
+		.planes_cnt = 1,
+		.mbus_code = V4L2_MBUS_FMT_YVYU8_2X8,
+		.flags = FMT_FLAGS_M2M | FMT_FLAGS_CAM,
 	}, {
 		.name	= "YUV 4:2:2 planar, Y/Cb/Cr",
 		.fourcc	= V4L2_PIX_FMT_YUV422P,
 		.depth	= 12,
 		.color	= S5P_FIMC_YCBCR422,
 		.buff_cnt = 1,
-		.planes_cnt = 3
+		.planes_cnt = 3,
+		.flags = FMT_FLAGS_M2M,
 	}, {
 		.name	= "YUV 4:2:2 planar, Y/CbCr",
 		.fourcc	= V4L2_PIX_FMT_NV16,
 		.depth	= 16,
 		.color	= S5P_FIMC_YCBCR422,
 		.buff_cnt = 1,
-		.planes_cnt = 2
+		.planes_cnt = 2,
+		.flags = FMT_FLAGS_M2M,
 	}, {
 		.name	= "YUV 4:2:2 planar, Y/CrCb",
 		.fourcc	= V4L2_PIX_FMT_NV61,
 		.depth	= 16,
 		.color	= S5P_FIMC_RGB565,
 		.buff_cnt = 1,
-		.planes_cnt = 2
+		.planes_cnt = 2,
+		.flags = FMT_FLAGS_M2M,
 	}, {
 		.name	= "YUV 4:2:0 planar, YCbCr",
 		.fourcc	= V4L2_PIX_FMT_YUV420,
 		.depth	= 12,
 		.color	= S5P_FIMC_YCBCR420,
 		.buff_cnt = 1,
-		.planes_cnt = 3
+		.planes_cnt = 3,
+		.flags = FMT_FLAGS_M2M,
 	}, {
 		.name	= "YUV 4:2:0 planar, Y/CbCr",
 		.fourcc	= V4L2_PIX_FMT_NV12,
 		.depth	= 12,
 		.color	= S5P_FIMC_YCBCR420,
 		.buff_cnt = 1,
-		.planes_cnt = 2
-	}
+		.planes_cnt = 2,
+		.flags = FMT_FLAGS_M2M,
+	},
 };
 
 static struct v4l2_queryctrl fimc_ctrls[] = {
@@ -156,7 +173,7 @@ static struct v4l2_queryctrl *get_ctrl(int id)
 	return NULL;
 }
 
-static int fimc_check_scaler_ratio(struct v4l2_rect *r, struct fimc_frame *f)
+int fimc_check_scaler_ratio(struct v4l2_rect *r, struct fimc_frame *f)
 {
 	if (r->width > f->width) {
 		if (f->width > (r->width * SCALER_MAX_HRATIO))
@@ -199,7 +216,7 @@ static int fimc_get_scaler_factor(u32 src, u32 tar, u32 *ratio, u32 *shift)
 	return 0;
 }
 
-static int fimc_set_scaler_info(struct fimc_ctx *ctx)
+int fimc_set_scaler_info(struct fimc_ctx *ctx)
 {
 	struct fimc_scaler *sc = &ctx->scaler;
 	struct fimc_frame *s_frame = &ctx->s_frame;
@@ -259,6 +276,51 @@ static int fimc_set_scaler_info(struct fimc_ctx *ctx)
 	return 0;
 }
 
+static void fimc_capture_handler(struct fimc_dev *fimc)
+{
+	struct fimc_vid_cap *cap = &fimc->vid_cap;
+	struct fimc_vid_buffer *v_buf = NULL;
+
+	if (!list_empty(&cap->active_buf_q)) {
+		v_buf = active_queue_pop(cap);
+		fimc_buf_finish(fimc, v_buf);
+	}
+
+	if (test_and_clear_bit(ST_CAPT_SHUT, &fimc->state)) {
+		wake_up(&fimc->irq_queue);
+		return;
+	}
+
+	if (!list_empty(&cap->pending_buf_q)) {
+
+		v_buf = pending_queue_pop(cap);
+		fimc_hw_set_output_addr(fimc, &v_buf->paddr, cap->buf_index);
+		v_buf->index = cap->buf_index;
+
+		dbg("hw ptr: %d, sw ptr: %d",
+		    fimc_hw_get_frame_index(fimc), cap->buf_index);
+
+		spin_lock(&fimc->irqlock);
+		v_buf->vb.state = VIDEOBUF_ACTIVE;
+		spin_unlock(&fimc->irqlock);
+
+		/* Move the buffer to the capture active queue */
+		active_queue_add(cap, v_buf);
+
+		dbg("next frame: %d, done frame: %d",
+		    fimc_hw_get_frame_index(fimc), v_buf->index);
+
+		if (++cap->buf_index >= FIMC_MAX_OUT_BUFS)
+			cap->buf_index = 0;
+
+	} else if (test_and_clear_bit(ST_CAPT_STREAM, &fimc->state) &&
+		   cap->active_buf_cnt <= 1) {
+		fimc_deactivate_capture(fimc);
+	}
+
+	dbg("frame: %d, active_buf_cnt= %d",
+	    fimc_hw_get_frame_index(fimc), cap->active_buf_cnt);
+}
 
 static irqreturn_t fimc_isr(int irq, void *priv)
 {
@@ -285,6 +347,16 @@ static irqreturn_t fimc_isr(int irq, void *priv)
 			spin_unlock(&fimc->irqlock);
 			v4l2_m2m_job_finish(fimc->m2m.m2m_dev, ctx->m2m_ctx);
 		}
+		goto isr_unlock;
+
+	}
+
+	if (test_bit(ST_CAPT_RUN, &fimc->state))
+		fimc_capture_handler(fimc);
+
+	if (test_and_clear_bit(ST_CAPT_PEND, &fimc->state)) {
+		set_bit(ST_CAPT_RUN, &fimc->state);
+		wake_up(&fimc->irq_queue);
 	}
 
 isr_unlock:
@@ -424,7 +496,7 @@ static void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f)
  *
  * Return: 0 if dimensions are valid or non zero otherwise.
  */
-static int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags)
+int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags)
 {
 	struct fimc_frame *s_frame, *d_frame;
 	struct fimc_vid_buffer *buf = NULL;
@@ -513,9 +585,9 @@ static void fimc_dma_run(void *priv)
 	if (ctx->state & FIMC_PARAMS)
 		fimc_hw_set_out_dma(ctx);
 
-	ctx->state = 0;
 	fimc_activate_capture(ctx);
 
+	ctx->state &= (FIMC_CTX_M2M | FIMC_CTX_CAP);
 	fimc_hw_activate_input_dma(fimc, true);
 
 dma_unlock:
@@ -598,10 +670,31 @@ static void fimc_buf_queue(struct videobuf_queue *vq,
 				  struct videobuf_buffer *vb)
 {
 	struct fimc_ctx *ctx = vq->priv_data;
-	v4l2_m2m_buf_queue(ctx->m2m_ctx, vq, vb);
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct fimc_vid_cap *cap = &fimc->vid_cap;
+	unsigned long flags;
+
+	dbg("ctx: %p, ctx->state: 0x%x", ctx, ctx->state);
+
+	if ((ctx->state & FIMC_CTX_M2M) && ctx->m2m_ctx) {
+		v4l2_m2m_buf_queue(ctx->m2m_ctx, vq, vb);
+	} else if (ctx->state & FIMC_CTX_CAP) {
+		spin_lock_irqsave(&fimc->slock, flags);
+		fimc_vid_cap_buf_queue(fimc, (struct fimc_vid_buffer *)vb);
+
+		dbg("fimc->cap.active_buf_cnt: %d",
+		    fimc->vid_cap.active_buf_cnt);
+
+		if (cap->active_buf_cnt >= cap->reqbufs_count ||
+		   cap->active_buf_cnt >= FIMC_MAX_OUT_BUFS) {
+			if (!test_and_set_bit(ST_CAPT_STREAM, &fimc->state))
+				fimc_activate_capture(ctx);
+		}
+		spin_unlock_irqrestore(&fimc->slock, flags);
+	}
 }
 
-static struct videobuf_queue_ops fimc_qops = {
+struct videobuf_queue_ops fimc_qops = {
 	.buf_setup	= fimc_buf_setup,
 	.buf_prepare	= fimc_buf_prepare,
 	.buf_queue	= fimc_buf_queue,
@@ -624,7 +717,7 @@ static int fimc_m2m_querycap(struct file *file, void *priv,
 	return 0;
 }
 
-static int fimc_m2m_enum_fmt(struct file *file, void *priv,
+int fimc_vidioc_enum_fmt(struct file *file, void *priv,
 				struct v4l2_fmtdesc *f)
 {
 	struct fimc_fmt *fmt;
@@ -635,109 +728,139 @@ static int fimc_m2m_enum_fmt(struct file *file, void *priv,
 	fmt = &fimc_formats[f->index];
 	strncpy(f->description, fmt->name, sizeof(f->description) - 1);
 	f->pixelformat = fmt->fourcc;
+
 	return 0;
 }
 
-static int fimc_m2m_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
+int fimc_vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 {
 	struct fimc_ctx *ctx = priv;
+	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct fimc_frame *frame;
 
 	frame = ctx_get_frame(ctx, f->type);
 	if (IS_ERR(frame))
 		return PTR_ERR(frame);
 
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
+
 	f->fmt.pix.width	= frame->width;
 	f->fmt.pix.height	= frame->height;
 	f->fmt.pix.field	= V4L2_FIELD_NONE;
 	f->fmt.pix.pixelformat	= frame->fmt->fourcc;
 
+	mutex_unlock(&fimc->lock);
 	return 0;
 }
 
-static struct fimc_fmt *find_format(struct v4l2_format *f)
+struct fimc_fmt *find_format(struct v4l2_format *f, unsigned int mask)
 {
 	struct fimc_fmt *fmt;
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(fimc_formats); ++i) {
 		fmt = &fimc_formats[i];
-		if (fmt->fourcc == f->fmt.pix.pixelformat)
+		if (fmt->fourcc == f->fmt.pix.pixelformat &&
+		   (fmt->flags & mask))
 			break;
 	}
-	if (i == ARRAY_SIZE(fimc_formats))
-		return NULL;
 
-	return fmt;
+	return (i == ARRAY_SIZE(fimc_formats)) ? NULL : fmt;
 }
 
-static int fimc_m2m_try_fmt(struct file *file, void *priv,
-			     struct v4l2_format *f)
+struct fimc_fmt *find_mbus_format(struct v4l2_mbus_framefmt *f,
+				  unsigned int mask)
 {
 	struct fimc_fmt *fmt;
-	u32 max_width, max_height, mod_x, mod_y;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(fimc_formats); ++i) {
+		fmt = &fimc_formats[i];
+		if (fmt->mbus_code == f->code && (fmt->flags & mask))
+			break;
+	}
+
+	return (i == ARRAY_SIZE(fimc_formats)) ? NULL : fmt;
+}
+
+
+int fimc_vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
+{
 	struct fimc_ctx *ctx = priv;
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct samsung_fimc_variant *variant = fimc->variant;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct fimc_fmt *fmt;
+	u32 max_width, mod_x, mod_y, mask;
+	int ret = -EINVAL, is_output = 0;
 
-	fmt = find_format(f);
-	if (!fmt) {
-		v4l2_err(&fimc->m2m.v4l2_dev,
-			 "Fourcc format (0x%X) invalid.\n",  pix->pixelformat);
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		if (ctx->state & FIMC_CTX_CAP)
+			return -EINVAL;
+		is_output = 1;
+	} else if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 		return -EINVAL;
 	}
 
+	dbg("w: %d, h: %d, bpl: %d",
+	    pix->width, pix->height, pix->bytesperline);
+
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
+
+	mask = is_output ? FMT_FLAGS_M2M : FMT_FLAGS_M2M | FMT_FLAGS_CAM;
+	fmt = find_format(f, mask);
+	if (!fmt) {
+		v4l2_err(&fimc->m2m.v4l2_dev, "Fourcc format (0x%X) invalid.\n",
+			 pix->pixelformat);
+		goto tf_out;
+	}
+
 	if (pix->field == V4L2_FIELD_ANY)
 		pix->field = V4L2_FIELD_NONE;
 	else if (V4L2_FIELD_NONE != pix->field)
-		return -EINVAL;
+		goto tf_out;
 
-	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+	if (is_output) {
 		max_width = variant->scaler_dis_w;
-		max_height = variant->scaler_dis_w;
-		mod_x = variant->min_inp_pixsize;
-		mod_y = variant->min_inp_pixsize;
-	} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		max_width = variant->out_rot_dis_w;
-		max_height = variant->out_rot_dis_w;
-		mod_x = variant->min_out_pixsize;
-		mod_y = variant->min_out_pixsize;
+		mod_x = ffs(variant->min_inp_pixsize) - 1;
 	} else {
-		err("Wrong stream type (%d)", f->type);
-		return -EINVAL;
+		max_width = variant->out_rot_dis_w;
+		mod_x = ffs(variant->min_out_pixsize) - 1;
 	}
 
-	dbg("max_w= %d, max_h= %d", max_width, max_height);
-
-	if (pix->height > max_height)
-		pix->height = max_height;
-	if (pix->width > max_width)
-		pix->width = max_width;
-
 	if (tiled_fmt(fmt)) {
-		mod_x = 64; /* 64x32 tile */
-		mod_y = 32;
+		mod_x = 6; /* 64 x 32 pixels tile */
+		mod_y = 5;
+	} else {
+		if (fimc->id == 1 && fimc->variant->pix_hoff)
+			mod_y = fimc_fmt_is_rgb(fmt->color) ? 0 : 1;
+		else
+			mod_y = mod_x;
 	}
 
-	dbg("mod_x= 0x%X, mod_y= 0x%X", mod_x, mod_y);
+	dbg("mod_x: %d, mod_y: %d, max_w: %d", mod_x, mod_y, max_width);
 
-	pix->width = (pix->width == 0) ? mod_x : ALIGN(pix->width, mod_x);
-	pix->height = (pix->height == 0) ? mod_y : ALIGN(pix->height, mod_y);
+	v4l_bound_align_image(&pix->width, 16, max_width, mod_x,
+		&pix->height, 8, variant->scaler_dis_w, mod_y, 0);
 
 	if (pix->bytesperline == 0 ||
-	    pix->bytesperline * 8 / fmt->depth > pix->width)
+	    (pix->bytesperline * 8 / fmt->depth) > pix->width)
 		pix->bytesperline = (pix->width * fmt->depth) >> 3;
 
 	if (pix->sizeimage == 0)
 		pix->sizeimage = pix->height * pix->bytesperline;
 
-	dbg("pix->bytesperline= %d, fmt->depth= %d",
-	    pix->bytesperline, fmt->depth);
+	dbg("w: %d, h: %d, bpl: %d, depth: %d",
+	    pix->width, pix->height, pix->bytesperline, fmt->depth);
 
-	return 0;
-}
+	ret = 0;
 
+tf_out:
+	mutex_unlock(&fimc->lock);
+	return ret;
+}
 
 static int fimc_m2m_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 {
@@ -750,9 +873,7 @@ static int fimc_m2m_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	unsigned long flags;
 	int ret = 0;
 
-	BUG_ON(!ctx);
-
-	ret = fimc_m2m_try_fmt(file, priv, f);
+	ret = fimc_vidioc_try_fmt(file, priv, f);
 	if (ret)
 		return ret;
 
@@ -785,7 +906,7 @@ static int fimc_m2m_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	spin_unlock_irqrestore(&ctx->slock, flags);
 
 	pix = &f->fmt.pix;
-	frame->fmt = find_format(f);
+	frame->fmt = find_format(f, FMT_FLAGS_M2M);
 	if (!frame->fmt) {
 		ret = -EINVAL;
 		goto sf_out;
@@ -857,21 +978,33 @@ static int fimc_m2m_streamoff(struct file *file, void *priv,
 	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
 }
 
-int fimc_m2m_queryctrl(struct file *file, void *priv,
+int fimc_vidioc_queryctrl(struct file *file, void *priv,
 			    struct v4l2_queryctrl *qc)
 {
+	struct fimc_ctx *ctx = priv;
 	struct v4l2_queryctrl *c;
+
 	c = get_ctrl(qc->id);
-	if (!c)
-		return -EINVAL;
-	*qc = *c;
-	return 0;
+	if (c) {
+		*qc = *c;
+		return 0;
+	}
+
+	if (ctx->state & FIMC_CTX_CAP)
+		return v4l2_subdev_call(ctx->fimc_dev->vid_cap.sd,
+					core, queryctrl, qc);
+	return -EINVAL;
 }
 
-int fimc_m2m_g_ctrl(struct file *file, void *priv,
+int fimc_vidioc_g_ctrl(struct file *file, void *priv,
 			 struct v4l2_control *ctrl)
 {
 	struct fimc_ctx *ctx = priv;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	int ret = 0;
+
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
 
 	switch (ctrl->id) {
 	case V4L2_CID_HFLIP:
@@ -884,15 +1017,22 @@ int fimc_m2m_g_ctrl(struct file *file, void *priv,
 		ctrl->value = ctx->rotation;
 		break;
 	default:
-		v4l2_err(&ctx->fimc_dev->m2m.v4l2_dev, "Invalid control\n");
-		return -EINVAL;
+		if (ctx->state & FIMC_CTX_CAP) {
+			ret = v4l2_subdev_call(fimc->vid_cap.sd, core,
+				       g_ctrl, ctrl);
+		} else {
+			v4l2_err(&fimc->m2m.v4l2_dev,
+				 "Invalid control\n");
+			ret = -EINVAL;
+		}
 	}
 	dbg("ctrl->value= %d", ctrl->value);
-	return 0;
+
+	mutex_unlock(&fimc->lock);
+	return ret;
 }
 
-static int check_ctrl_val(struct fimc_ctx *ctx,
-			  struct v4l2_control *ctrl)
+int check_ctrl_val(struct fimc_ctx *ctx,  struct v4l2_control *ctrl)
 {
 	struct v4l2_queryctrl *c;
 	c = get_ctrl(ctrl->id);
@@ -909,22 +1049,23 @@ static int check_ctrl_val(struct fimc_ctx *ctx,
 	return 0;
 }
 
-int fimc_m2m_s_ctrl(struct file *file, void *priv,
-			 struct v4l2_control *ctrl)
+int fimc_s_ctrl(struct fimc_ctx *ctx, struct v4l2_control *ctrl)
 {
-	struct fimc_ctx *ctx = priv;
 	struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
+	struct fimc_dev *fimc = ctx->fimc_dev;
 	unsigned long flags;
-	int ret = 0;
 
-	ret = check_ctrl_val(ctx, ctrl);
-	if (ret)
-		return ret;
+	if (ctx->rotation != 0 &&
+	    (ctrl->id == V4L2_CID_HFLIP || ctrl->id == V4L2_CID_VFLIP)) {
+		v4l2_err(&fimc->m2m.v4l2_dev,
+			 "Simultaneous flip and rotation is not supported\n");
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&ctx->slock, flags);
 
 	switch (ctrl->id) {
 	case V4L2_CID_HFLIP:
-		if (ctx->rotation != 0)
-			return 0;
 		if (ctrl->value)
 			ctx->flip |= FLIP_X_AXIS;
 		else
@@ -932,8 +1073,6 @@ int fimc_m2m_s_ctrl(struct file *file, void *priv,
 		break;
 
 	case V4L2_CID_VFLIP:
-		if (ctx->rotation != 0)
-			return 0;
 		if (ctrl->value)
 			ctx->flip |= FLIP_Y_AXIS;
 		else
@@ -941,77 +1080,95 @@ int fimc_m2m_s_ctrl(struct file *file, void *priv,
 		break;
 
 	case V4L2_CID_ROTATE:
-		if (ctrl->value == 90 || ctrl->value == 270) {
-			if (ctx->out_path == FIMC_LCDFIFO &&
-			    !variant->has_inp_rot) {
-				return -EINVAL;
-			} else if (ctx->in_path == FIMC_DMA &&
-				   !variant->has_out_rot) {
-				return -EINVAL;
-			}
+		/* Check for the output rotator availability */
+		if ((ctrl->value == 90 || ctrl->value == 270) &&
+		    (ctx->in_path == FIMC_DMA && !variant->has_out_rot)) {
+			spin_unlock_irqrestore(&ctx->slock, flags);
+			return -EINVAL;
+		} else {
+			ctx->rotation = ctrl->value;
 		}
-		ctx->rotation = ctrl->value;
-		if (ctrl->value == 180)
-			ctx->flip = FLIP_XY_AXIS;
 		break;
 
 	default:
-		v4l2_err(&ctx->fimc_dev->m2m.v4l2_dev, "Invalid control\n");
+		spin_unlock_irqrestore(&ctx->slock, flags);
+		v4l2_err(&fimc->m2m.v4l2_dev, "Invalid control\n");
 		return -EINVAL;
 	}
-	spin_lock_irqsave(&ctx->slock, flags);
 	ctx->state |= FIMC_PARAMS;
 	spin_unlock_irqrestore(&ctx->slock, flags);
+
 	return 0;
 }
 
+static int fimc_m2m_s_ctrl(struct file *file, void *priv,
+			 struct v4l2_control *ctrl)
+{
+	struct fimc_ctx *ctx = priv;
+	int ret = 0;
+
+	ret = check_ctrl_val(ctx, ctrl);
+	if (ret)
+		return ret;
+
+	ret = fimc_s_ctrl(ctx, ctrl);
+	return 0;
+}
 
-static int fimc_m2m_cropcap(struct file *file, void *fh,
-			     struct v4l2_cropcap *cr)
+int fimc_vidioc_cropcap(struct file *file, void *fh,
+			struct v4l2_cropcap *cr)
 {
 	struct fimc_frame *frame;
 	struct fimc_ctx *ctx = fh;
+	struct fimc_dev *fimc = ctx->fimc_dev;
 
 	frame = ctx_get_frame(ctx, cr->type);
 	if (IS_ERR(frame))
 		return PTR_ERR(frame);
 
-	cr->bounds.left = 0;
-	cr->bounds.top = 0;
-	cr->bounds.width = frame->f_width;
-	cr->bounds.height = frame->f_height;
-	cr->defrect.left = frame->offs_h;
-	cr->defrect.top = frame->offs_v;
-	cr->defrect.width = frame->o_width;
-	cr->defrect.height = frame->o_height;
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
+
+	cr->bounds.left		= 0;
+	cr->bounds.top		= 0;
+	cr->bounds.width	= frame->f_width;
+	cr->bounds.height	= frame->f_height;
+	cr->defrect		= cr->bounds;
+
+	mutex_unlock(&fimc->lock);
 	return 0;
 }
 
-static int fimc_m2m_g_crop(struct file *file, void *fh, struct v4l2_crop *cr)
+int fimc_vidioc_g_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 {
 	struct fimc_frame *frame;
 	struct fimc_ctx *ctx = file->private_data;
+	struct fimc_dev *fimc = ctx->fimc_dev;
 
 	frame = ctx_get_frame(ctx, cr->type);
 	if (IS_ERR(frame))
 		return PTR_ERR(frame);
 
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
+
 	cr->c.left = frame->offs_h;
 	cr->c.top = frame->offs_v;
 	cr->c.width = frame->width;
 	cr->c.height = frame->height;
 
+	mutex_unlock(&fimc->lock);
 	return 0;
 }
 
-static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
+int fimc_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr)
 {
-	struct fimc_ctx *ctx = file->private_data;
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	unsigned long flags;
 	struct fimc_frame *f;
-	u32 min_size;
-	int ret = 0;
+	u32 min_size, halign;
+
+	f = (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) ?
+		&ctx->s_frame : &ctx->d_frame;
 
 	if (cr->c.top < 0 || cr->c.left < 0) {
 		v4l2_err(&fimc->m2m.v4l2_dev,
@@ -1019,66 +1176,98 @@ static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 		return -EINVAL;
 	}
 
-	if (cr->c.width  <= 0 || cr->c.height <= 0) {
-		v4l2_err(&fimc->m2m.v4l2_dev,
-			"crop width and height must be greater than 0\n");
-		return -EINVAL;
-	}
-
 	f = ctx_get_frame(ctx, cr->type);
 	if (IS_ERR(f))
 		return PTR_ERR(f);
 
-	/* Adjust to required pixel boundary. */
-	min_size = (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) ?
-		fimc->variant->min_inp_pixsize : fimc->variant->min_out_pixsize;
+	min_size = (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		? fimc->variant->min_inp_pixsize
+		: fimc->variant->min_out_pixsize;
 
-	cr->c.width = round_down(cr->c.width, min_size);
-	cr->c.height = round_down(cr->c.height, min_size);
-	cr->c.left = round_down(cr->c.left + 1, min_size);
-	cr->c.top = round_down(cr->c.top + 1, min_size);
-
-	if ((cr->c.left + cr->c.width > f->o_width)
-		|| (cr->c.top + cr->c.height > f->o_height)) {
-		v4l2_err(&fimc->m2m.v4l2_dev, "Error in S_CROP params\n");
-		return -EINVAL;
+	if (ctx->state & FIMC_CTX_M2M) {
+		if (fimc->id == 1 && fimc->variant->pix_hoff)
+			halign = fimc_fmt_is_rgb(f->fmt->color) ? 0 : 1;
+		else
+			halign = ffs(min_size) - 1;
+	/* there are more strict aligment requirements at camera interface */
+	} else {
+		min_size = 16;
+		halign = 4;
 	}
 
+	v4l_bound_align_image(&cr->c.width, min_size, f->o_width,
+			      ffs(min_size) - 1,
+			      &cr->c.height, min_size, f->o_height,
+			      halign, 64/(ALIGN(f->fmt->depth, 8)));
+
+	/* adjust left/top if cropping rectangle is out of bounds */
+	if (cr->c.left + cr->c.width > f->o_width)
+		cr->c.left = f->o_width - cr->c.width;
+	if (cr->c.top + cr->c.height > f->o_height)
+		cr->c.top = f->o_height - cr->c.height;
+
+	cr->c.left = round_down(cr->c.left, min_size);
+	cr->c.top  = round_down(cr->c.top,
+				ctx->state & FIMC_CTX_M2M ? 8 : 16);
+
+	dbg("l:%d, t:%d, w:%d, h:%d, f_w: %d, f_h: %d",
+	    cr->c.left, cr->c.top, cr->c.width, cr->c.height,
+	    f->f_width, f->f_height);
+
+	return 0;
+}
+
+
+static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
+{
+	struct fimc_ctx *ctx = file->private_data;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	unsigned long flags;
+	struct fimc_frame *f;
+	int ret;
+
+	ret = fimc_try_crop(ctx, cr);
+	if (ret)
+		return ret;
+
+	f = (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) ?
+		&ctx->s_frame : &ctx->d_frame;
+
 	spin_lock_irqsave(&ctx->slock, flags);
-	if ((ctx->state & FIMC_SRC_FMT) && (ctx->state & FIMC_DST_FMT)) {
-		/* Check for the pixel scaling ratio when cropping input img. */
+	if (~ctx->state & (FIMC_SRC_FMT | FIMC_DST_FMT)) {
+		/* Check to see if scaling ratio is within supported range */
 		if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
 			ret = fimc_check_scaler_ratio(&cr->c, &ctx->d_frame);
-		else if (cr->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		else
 			ret = fimc_check_scaler_ratio(&cr->c, &ctx->s_frame);
-
 		if (ret) {
 			spin_unlock_irqrestore(&ctx->slock, flags);
-			v4l2_err(&fimc->m2m.v4l2_dev,  "Out of scaler range");
+			v4l2_err(&fimc->m2m.v4l2_dev, "Out of scaler range");
 			return -EINVAL;
 		}
 	}
 	ctx->state |= FIMC_PARAMS;
-	spin_unlock_irqrestore(&ctx->slock, flags);
 
 	f->offs_h = cr->c.left;
 	f->offs_v = cr->c.top;
-	f->width = cr->c.width;
+	f->width  = cr->c.width;
 	f->height = cr->c.height;
+
+	spin_unlock_irqrestore(&ctx->slock, flags);
 	return 0;
 }
 
 static const struct v4l2_ioctl_ops fimc_m2m_ioctl_ops = {
 	.vidioc_querycap		= fimc_m2m_querycap,
 
-	.vidioc_enum_fmt_vid_cap	= fimc_m2m_enum_fmt,
-	.vidioc_enum_fmt_vid_out	= fimc_m2m_enum_fmt,
+	.vidioc_enum_fmt_vid_cap	= fimc_vidioc_enum_fmt,
+	.vidioc_enum_fmt_vid_out	= fimc_vidioc_enum_fmt,
 
-	.vidioc_g_fmt_vid_cap		= fimc_m2m_g_fmt,
-	.vidioc_g_fmt_vid_out		= fimc_m2m_g_fmt,
+	.vidioc_g_fmt_vid_cap		= fimc_vidioc_g_fmt,
+	.vidioc_g_fmt_vid_out		= fimc_vidioc_g_fmt,
 
-	.vidioc_try_fmt_vid_cap		= fimc_m2m_try_fmt,
-	.vidioc_try_fmt_vid_out		= fimc_m2m_try_fmt,
+	.vidioc_try_fmt_vid_cap		= fimc_vidioc_try_fmt,
+	.vidioc_try_fmt_vid_out		= fimc_vidioc_try_fmt,
 
 	.vidioc_s_fmt_vid_cap		= fimc_m2m_s_fmt,
 	.vidioc_s_fmt_vid_out		= fimc_m2m_s_fmt,
@@ -1092,13 +1281,13 @@ static const struct v4l2_ioctl_ops fimc_m2m_ioctl_ops = {
 	.vidioc_streamon		= fimc_m2m_streamon,
 	.vidioc_streamoff		= fimc_m2m_streamoff,
 
-	.vidioc_queryctrl		= fimc_m2m_queryctrl,
-	.vidioc_g_ctrl			= fimc_m2m_g_ctrl,
+	.vidioc_queryctrl		= fimc_vidioc_queryctrl,
+	.vidioc_g_ctrl			= fimc_vidioc_g_ctrl,
 	.vidioc_s_ctrl			= fimc_m2m_s_ctrl,
 
-	.vidioc_g_crop			= fimc_m2m_g_crop,
+	.vidioc_g_crop			= fimc_vidioc_g_crop,
 	.vidioc_s_crop			= fimc_m2m_s_crop,
-	.vidioc_cropcap			= fimc_m2m_cropcap
+	.vidioc_cropcap			= fimc_vidioc_cropcap
 
 };
 
@@ -1120,11 +1309,23 @@ static int fimc_m2m_open(struct file *file)
 	struct fimc_ctx *ctx = NULL;
 	int err = 0;
 
-	mutex_lock(&fimc->lock);
+	if (mutex_lock_interruptible(&fimc->lock))
+		return -ERESTARTSYS;
+
+	dbg("pid: %d, state: 0x%lx, refcnt: %d",
+		task_pid_nr(current), fimc->state, fimc->vid_cap.refcnt);
+
+	/*
+	 * Return if the corresponding video capture node
+	 * is already opened.
+	 */
+	if (fimc->vid_cap.refcnt > 0) {
+		mutex_unlock(&fimc->lock);
+		return -EBUSY;
+	}
+
 	fimc->m2m.refcnt++;
 	set_bit(ST_OUTDMA_RUN, &fimc->state);
-	mutex_unlock(&fimc->lock);
-
 
 	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
 	if (!ctx)
@@ -1135,8 +1336,8 @@ static int fimc_m2m_open(struct file *file)
 	/* Default color format */
 	ctx->s_frame.fmt = &fimc_formats[0];
 	ctx->d_frame.fmt = &fimc_formats[0];
-	/* per user process device context initialization */
-	ctx->state = 0;
+	/* Setup the device context for mem2mem mode. */
+	ctx->state = FIMC_CTX_M2M;
 	ctx->flags = 0;
 	ctx->in_path = FIMC_DMA;
 	ctx->out_path = FIMC_DMA;
@@ -1147,6 +1348,8 @@ static int fimc_m2m_open(struct file *file)
 		err = PTR_ERR(ctx->m2m_ctx);
 		kfree(ctx);
 	}
+
+	mutex_unlock(&fimc->lock);
 	return err;
 }
 
@@ -1155,11 +1358,16 @@ static int fimc_m2m_release(struct file *file)
 	struct fimc_ctx *ctx = file->private_data;
 	struct fimc_dev *fimc = ctx->fimc_dev;
 
+	mutex_lock(&fimc->lock);
+
+	dbg("pid: %d, state: 0x%lx, refcnt= %d",
+		task_pid_nr(current), fimc->state, fimc->m2m.refcnt);
+
 	v4l2_m2m_ctx_release(ctx->m2m_ctx);
 	kfree(ctx);
-	mutex_lock(&fimc->lock);
 	if (--fimc->m2m.refcnt <= 0)
 		clear_bit(ST_OUTDMA_RUN, &fimc->state);
+
 	mutex_unlock(&fimc->lock);
 	return 0;
 }
@@ -1168,6 +1376,7 @@ static unsigned int fimc_m2m_poll(struct file *file,
 				     struct poll_table_struct *wait)
 {
 	struct fimc_ctx *ctx = file->private_data;
+
 	return v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
 }
 
@@ -1175,6 +1384,7 @@ static unsigned int fimc_m2m_poll(struct file *file,
 static int fimc_m2m_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct fimc_ctx *ctx = file->private_data;
+
 	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
 }
 
@@ -1322,9 +1532,11 @@ static int fimc_probe(struct platform_device *pdev)
 	fimc->id = pdev->id;
 	fimc->variant = drv_data->variant[fimc->id];
 	fimc->pdev = pdev;
+	fimc->pdata = pdev->dev.platform_data;
 	fimc->state = ST_IDLE;
 
 	spin_lock_init(&fimc->irqlock);
+	init_waitqueue_head(&fimc->irq_queue);
 	spin_lock_init(&fimc->slock);
 
 	mutex_init(&fimc->lock);
@@ -1354,6 +1566,7 @@ static int fimc_probe(struct platform_device *pdev)
 	ret = fimc_clk_get(fimc);
 	if (ret)
 		goto err_regs_unmap;
+	clk_set_rate(fimc->clock[0], drv_data->lclk_frequency);
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!res) {
@@ -1375,11 +1588,27 @@ static int fimc_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_irq;
 
+	/* At least one camera sensor is required to register capture node */
+	if (fimc->pdata) {
+		int i;
+		for (i = 0; i < FIMC_MAX_CAMIF_CLIENTS; ++i)
+			if (fimc->pdata->isp_info[i])
+				break;
+
+		if (i < FIMC_MAX_CAMIF_CLIENTS) {
+			ret = fimc_register_capture_device(fimc);
+			if (ret)
+				goto err_m2m;
+		}
+	}
+
 	dev_dbg(&pdev->dev, "%s(): fimc-%d registered successfully\n",
 		__func__, fimc->id);
 
 	return 0;
 
+err_m2m:
+	fimc_unregister_m2m_device(fimc);
 err_irq:
 	free_irq(fimc->irq, fimc);
 err_clk:
@@ -1404,6 +1633,8 @@ static int __devexit fimc_remove(struct platform_device *pdev)
 	fimc_hw_reset(fimc);
 
 	fimc_unregister_m2m_device(fimc);
+	fimc_unregister_capture_device(fimc);
+
 	fimc_clk_release(fimc);
 	iounmap(fimc->regs);
 	release_resource(fimc->regs_res);
@@ -1474,7 +1705,8 @@ static struct samsung_fimc_driverdata fimc_drvdata_s5p = {
 		[1] = &fimc01_variant_s5p,
 		[2] = &fimc2_variant_s5p,
 	},
-	.devs_cnt = 3
+	.devs_cnt	= 3,
+	.lclk_frequency	= 133000000UL,
 };
 
 static struct samsung_fimc_driverdata fimc_drvdata_s5pv210 = {
@@ -1483,7 +1715,8 @@ static struct samsung_fimc_driverdata fimc_drvdata_s5pv210 = {
 		[1] = &fimc01_variant_s5pv210,
 		[2] = &fimc2_variant_s5pv210,
 	},
-	.devs_cnt = 3
+	.devs_cnt = 3,
+	.lclk_frequency	= 166000000UL,
 };
 
 static struct platform_device_id fimc_driver_ids[] = {
@@ -1524,6 +1757,6 @@ static void __exit fimc_exit(void)
 module_init(fimc_init);
 module_exit(fimc_exit);
 
-MODULE_AUTHOR("Sylwester Nawrocki, s.nawrocki@samsung.com");
-MODULE_DESCRIPTION("S3C/S5P FIMC (video postprocessor) driver");
+MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
+MODULE_DESCRIPTION("S5P FIMC camera host interface/video postprocessor driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 5aeb3ef..ce0a6b8 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -11,10 +11,14 @@
 #ifndef FIMC_CORE_H_
 #define FIMC_CORE_H_
 
+/*#define DEBUG*/
+
 #include <linux/types.h>
 #include <media/videobuf-core.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-mem2mem.h>
+#include <media/v4l2-mediabus.h>
+#include <media/s3c_fimc.h>
 #include <linux/videodev2.h>
 #include "regs-fimc.h"
 
@@ -28,6 +32,8 @@
 #define dbg(fmt, args...)
 #endif
 
+/* Time to wait for next frame VSYNC interrupt while stopping operation. */
+#define FIMC_SHUTDOWN_TIMEOUT	((100*HZ)/1000)
 #define NUM_FIMC_CLOCKS		2
 #define MODULE_NAME		"s5p-fimc"
 #define FIMC_MAX_DEVS		3
@@ -36,19 +42,41 @@
 #define SCALER_MAX_VRATIO	64
 #define DMA_MIN_SIZE		8
 
-enum {
+/* FIMC device state flags */
+enum fimc_dev_flags {
+	/* for m2m node */
 	ST_IDLE,
 	ST_OUTDMA_RUN,
 	ST_M2M_PEND,
+	/* for capture node */
+	ST_CAPT_PEND,
+	ST_CAPT_RUN,
+	ST_CAPT_STREAM,
+	ST_CAPT_SHUT,
 };
 
 #define fimc_m2m_active(dev) test_bit(ST_OUTDMA_RUN, &(dev)->state)
 #define fimc_m2m_pending(dev) test_bit(ST_M2M_PEND, &(dev)->state)
 
+#define fimc_capture_running(dev) test_bit(ST_CAPT_RUN, &(dev)->state)
+#define fimc_capture_pending(dev) test_bit(ST_CAPT_PEND, &(dev)->state)
+
+#define fimc_capture_active(dev) \
+	(test_bit(ST_CAPT_RUN, &(dev)->state) || \
+	 test_bit(ST_CAPT_PEND, &(dev)->state))
+
+#define fimc_capture_streaming(dev) \
+	test_bit(ST_CAPT_STREAM, &(dev)->state)
+
+#define fimc_buf_finish(dev, vid_buf) do { \
+	spin_lock(&(dev)->irqlock); \
+	(vid_buf)->vb.state = VIDEOBUF_DONE; \
+	spin_unlock(&(dev)->irqlock); \
+	wake_up(&(vid_buf)->vb.done); \
+} while (0)
+
 enum fimc_datapath {
-	FIMC_ITU_CAM_A,
-	FIMC_ITU_CAM_B,
-	FIMC_MIPI_CAM,
+	FIMC_CAMERA,
 	FIMC_DMA,
 	FIMC_LCDFIFO,
 	FIMC_WRITEBACK
@@ -123,20 +151,25 @@ enum fimc_color_fmt {
 
 /**
  * struct fimc_fmt - the driver's internal color format data
+ * @mbus_code: Media Bus pixel code, -1 if not applicable
  * @name: format description
- * @fourcc: the fourcc code for this format
+ * @fourcc: the fourcc code for this format, 0 if not applicable
  * @color: the corresponding fimc_color_fmt
- * @depth: number of bits per pixel
+ * @depth: driver's private 'number of bits per pixel'
  * @buff_cnt: number of physically non-contiguous data planes
  * @planes_cnt: number of physically contiguous data planes
  */
 struct fimc_fmt {
+	enum v4l2_mbus_pixelcode mbus_code;
 	char	*name;
 	u32	fourcc;
 	u32	color;
-	u32	depth;
 	u16	buff_cnt;
 	u16	planes_cnt;
+	u16	depth;
+	u16	flags;
+#define FMT_FLAGS_CAM	(1 << 0)
+#define FMT_FLAGS_M2M	(1 << 1)
 };
 
 /**
@@ -220,10 +253,14 @@ struct fimc_addr {
 
 /**
  * struct fimc_vid_buffer - the driver's video buffer
- * @vb:	v4l videobuf buffer
+ * @vb:    v4l videobuf buffer
+ * @paddr: precalculated physical address set
+ * @index: buffer index for the output DMA engine
  */
 struct fimc_vid_buffer {
 	struct videobuf_buffer	vb;
+	struct fimc_addr	paddr;
+	int			index;
 };
 
 /**
@@ -274,6 +311,40 @@ struct fimc_m2m_device {
 };
 
 /**
+ * struct fimc_vid_cap - camera capture device information
+ * @ctx: hardware context data
+ * @vfd: video device node for camera capture mode
+ * @v4l2_dev: v4l2_device struct to manage subdevs
+ * @sd: pointer to camera sensor subdevice currently in use
+ * @fmt: Media Bus format configured at selected image sensor
+ * @pending_buf_q: the pending buffer queue head
+ * @active_buf_q: the queue head of buffers scheduled in hardware
+ * @vbq: the capture am video buffer queue
+ * @active_buf_cnt: number of video buffers scheduled in hardware
+ * @buf_index: index for managing the output DMA buffers
+ * @frame_count: the frame counter for statistics
+ * @reqbufs_count: the number of buffers requested in REQBUFS ioctl
+ * @input_index: input (camera sensor) index
+ * @refcnt: driver's private reference counter
+ */
+struct fimc_vid_cap {
+	struct fimc_ctx			*ctx;
+	struct video_device		*vfd;
+	struct v4l2_device		v4l2_dev;
+	struct v4l2_subdev		*sd;
+	struct v4l2_mbus_framefmt	fmt;
+	struct list_head		pending_buf_q;
+	struct list_head		active_buf_q;
+	struct videobuf_queue		vbq;
+	int				active_buf_cnt;
+	int				buf_index;
+	unsigned int			frame_count;
+	unsigned int			reqbufs_count;
+	int				input_index;
+	int				refcnt;
+};
+
+/**
  * struct samsung_fimc_variant - camera interface variant information
  *
  * @pix_hoff: indicate whether horizontal offset is in pixels or in bytes
@@ -308,10 +379,12 @@ struct samsung_fimc_variant {
  *
  * @variant: the variant information for this driver.
  * @dev_cnt: number of fimc sub-devices available in SoC
+ * @lclk_frequency: fimc bus clock frequency
  */
 struct samsung_fimc_driverdata {
 	struct samsung_fimc_variant *variant[FIMC_MAX_DEVS];
-	int	devs_cnt;
+	unsigned long	lclk_frequency;
+	int		devs_cnt;
 };
 
 struct fimc_ctx;
@@ -322,19 +395,23 @@ struct fimc_ctx;
  * @slock:	the spinlock protecting this data structure
  * @lock:	the mutex protecting this data structure
  * @pdev:	pointer to the FIMC platform device
+ * @pdata:	pointer to the device platform data
  * @id:		FIMC device index (0..2)
  * @clock[]:	the clocks required for FIMC operation
  * @regs:	the mapped hardware registers
  * @regs_res:	the resource claimed for IO registers
  * @irq:	interrupt number of the FIMC subdevice
  * @irqlock:	spinlock protecting videobuffer queue
+ * @irq_queue:
  * @m2m:	memory-to-memory V4L2 device information
- * @state:	the FIMC device state flags
+ * @vid_cap:	camera capture device information
+ * @state:	flags used to synchronize m2m and capture mode operation
  */
 struct fimc_dev {
 	spinlock_t			slock;
 	struct mutex			lock;
 	struct platform_device		*pdev;
+	struct s3c_platform_fimc	*pdata;
 	struct samsung_fimc_variant	*variant;
 	int				id;
 	struct clk			*clock[NUM_FIMC_CLOCKS];
@@ -342,7 +419,9 @@ struct fimc_dev {
 	struct resource			*regs_res;
 	int				irq;
 	spinlock_t			irqlock;
+	wait_queue_head_t		irq_queue;
 	struct fimc_m2m_device		m2m;
+	struct fimc_vid_cap		vid_cap;
 	unsigned long			state;
 };
 
@@ -387,6 +466,7 @@ struct fimc_ctx {
 	struct v4l2_m2m_ctx	*m2m_ctx;
 };
 
+extern struct videobuf_queue_ops fimc_qops;
 
 static inline int tiled_fmt(struct fimc_fmt *fmt)
 {
@@ -433,7 +513,10 @@ static inline struct fimc_frame *ctx_get_frame(struct fimc_ctx *ctx,
 	struct fimc_frame *frame;
 
 	if (V4L2_BUF_TYPE_VIDEO_OUTPUT == type) {
-		frame = &ctx->s_frame;
+		if (ctx->state & FIMC_CTX_M2M)
+			frame = &ctx->s_frame;
+		else
+			return ERR_PTR(-EINVAL);
 	} else if (V4L2_BUF_TYPE_VIDEO_CAPTURE == type) {
 		frame = &ctx->d_frame;
 	} else {
@@ -445,6 +528,13 @@ static inline struct fimc_frame *ctx_get_frame(struct fimc_ctx *ctx,
 	return frame;
 }
 
+static inline u32 fimc_hw_get_frame_index(struct fimc_dev *dev)
+{
+	u32 reg = readl(dev->regs + S5P_CISTATUS);
+	return (reg & S5P_CISTATUS_FRAMECNT_MASK) >>
+		S5P_CISTATUS_FRAMECNT_SHIFT;
+}
+
 /* -----------------------------------------------------*/
 /* fimc-reg.c						*/
 void fimc_hw_reset(struct fimc_dev *fimc);
@@ -462,6 +552,52 @@ void fimc_hw_set_output_path(struct fimc_ctx *ctx);
 void fimc_hw_set_input_addr(struct fimc_dev *fimc, struct fimc_addr *paddr);
 void fimc_hw_set_output_addr(struct fimc_dev *fimc, struct fimc_addr *paddr,
 			      int index);
+int fimc_hw_set_camera_source(struct fimc_dev *fimc,
+			      struct s3c_fimc_isp_info *cam);
+int fimc_hw_set_camera_offset(struct fimc_dev *fimc, struct fimc_frame *f);
+int fimc_hw_set_camera_polarity(struct fimc_dev *fimc,
+				struct s3c_fimc_isp_info *cam);
+int fimc_hw_set_camera_type(struct fimc_dev *fimc,
+			    struct s3c_fimc_isp_info *cam);
+
+/* -----------------------------------------------------*/
+/* fimc-core.c */
+int fimc_vidioc_enum_fmt(struct file *file, void *priv,
+		      struct v4l2_fmtdesc *f);
+int fimc_vidioc_g_fmt(struct file *file, void *priv,
+		      struct v4l2_format *f);
+int fimc_vidioc_try_fmt(struct file *file, void *priv,
+			struct v4l2_format *f);
+int fimc_vidioc_g_crop(struct file *file, void *fh,
+		       struct v4l2_crop *cr);
+int fimc_vidioc_cropcap(struct file *file, void *fh,
+			struct v4l2_cropcap *cr);
+int fimc_vidioc_queryctrl(struct file *file, void *priv,
+			  struct v4l2_queryctrl *qc);
+int fimc_vidioc_g_ctrl(struct file *file, void *priv,
+		       struct v4l2_control *ctrl);
+
+int fimc_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr);
+int check_ctrl_val(struct fimc_ctx *ctx,  struct v4l2_control *ctrl);
+int fimc_s_ctrl(struct fimc_ctx *ctx, struct v4l2_control *ctrl);
+
+struct fimc_fmt *find_format(struct v4l2_format *f, unsigned int mask);
+struct fimc_fmt *find_mbus_format(struct v4l2_mbus_framefmt *f,
+				  unsigned int mask);
+
+int fimc_check_scaler_ratio(struct v4l2_rect *r, struct fimc_frame *f);
+int fimc_set_scaler_info(struct fimc_ctx *ctx);
+int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags);
+int fimc_prepare_addr(struct fimc_ctx *ctx, struct fimc_vid_buffer *buf,
+		      struct fimc_frame *frame, struct fimc_addr *paddr);
+
+/* -----------------------------------------------------*/
+/* fimc-capture.c					*/
+int fimc_register_capture_device(struct fimc_dev *fimc);
+void fimc_unregister_capture_device(struct fimc_dev *fimc);
+int fimc_sensor_sd_init(struct fimc_dev *fimc, int index);
+int fimc_vid_cap_buf_queue(struct fimc_dev *fimc,
+			     struct fimc_vid_buffer *fimc_vb);
 
 /* Locking: the caller holds fimc->slock */
 static inline void fimc_activate_capture(struct fimc_ctx *ctx)
@@ -478,4 +614,51 @@ static inline void fimc_deactivate_capture(struct fimc_dev *fimc)
 	fimc_hw_en_lastirq(fimc, false);
 }
 
+/*
+ * Add video buffer to the active buffers queue.
+ * The caller holds irqlock spinlock.
+ */
+static inline void active_queue_add(struct fimc_vid_cap *vid_cap,
+					 struct fimc_vid_buffer *buf)
+{
+	buf->vb.state = VIDEOBUF_ACTIVE;
+	list_add_tail(&buf->vb.queue, &vid_cap->active_buf_q);
+	vid_cap->active_buf_cnt++;
+}
+
+/*
+ * Pop a video buffer from the capture active buffers queue
+ * Locking: Need to be called with dev->slock held.
+ */
+static inline struct fimc_vid_buffer *
+active_queue_pop(struct fimc_vid_cap *vid_cap)
+{
+	struct fimc_vid_buffer *buf;
+	buf = list_entry(vid_cap->active_buf_q.next,
+			 struct fimc_vid_buffer, vb.queue);
+	list_del(&buf->vb.queue);
+	vid_cap->active_buf_cnt--;
+	return buf;
+}
+
+/* Add video buffer to the capture pending buffers queue */
+static inline void fimc_pending_queue_add(struct fimc_vid_cap *vid_cap,
+					  struct fimc_vid_buffer *buf)
+{
+	buf->vb.state = VIDEOBUF_QUEUED;
+	list_add_tail(&buf->vb.queue, &vid_cap->pending_buf_q);
+}
+
+/* Add video buffer to the capture pending buffers queue */
+static inline struct fimc_vid_buffer *
+pending_queue_pop(struct fimc_vid_cap *vid_cap)
+{
+	struct fimc_vid_buffer *buf;
+	buf = list_entry(vid_cap->pending_buf_q.next,
+			struct fimc_vid_buffer, vb.queue);
+	list_del(&buf->vb.queue);
+	return buf;
+}
+
+
 #endif /* FIMC_CORE_H_ */
diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index 95adc84..511631a 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -13,6 +13,7 @@
 #include <linux/io.h>
 #include <linux/delay.h>
 #include <mach/map.h>
+#include <media/s3c_fimc.h>
 
 #include "fimc-core.h"
 
@@ -176,6 +177,15 @@ static void fimc_hw_set_out_dma_size(struct fimc_ctx *ctx)
 	cfg = S5P_ORIG_SIZE_HOR(frame->f_width);
 	cfg |= S5P_ORIG_SIZE_VER(frame->f_height);
 	writel(cfg, dev->regs + S5P_ORGOSIZE);
+
+	/* Select color space conversion equation (HD/SD size).*/
+	cfg = readl(dev->regs + S5P_CIGCTRL);
+	if (frame->f_width >= 1280) /* HD */
+		cfg |= S5P_CIGCTRL_CSC_ITU601_709;
+	else	/* SD */
+		cfg &= ~S5P_CIGCTRL_CSC_ITU601_709;
+	writel(cfg, dev->regs + S5P_CIGCTRL);
+
 }
 
 void fimc_hw_set_out_dma(struct fimc_ctx *ctx)
@@ -231,19 +241,12 @@ static void fimc_hw_en_autoload(struct fimc_dev *dev, int enable)
 
 void fimc_hw_en_lastirq(struct fimc_dev *dev, int enable)
 {
-	unsigned long flags;
-	u32 cfg;
-
-	spin_lock_irqsave(&dev->slock, flags);
-
-	cfg = readl(dev->regs + S5P_CIOCTRL);
+	u32 cfg = readl(dev->regs + S5P_CIOCTRL);
 	if (enable)
 		cfg |= S5P_CIOCTRL_LASTIRQ_ENABLE;
 	else
 		cfg &= ~S5P_CIOCTRL_LASTIRQ_ENABLE;
 	writel(cfg, dev->regs + S5P_CIOCTRL);
-
-	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
 static void fimc_hw_set_prescaler(struct fimc_ctx *ctx)
@@ -325,14 +328,18 @@ void fimc_hw_set_scaler(struct fimc_ctx *ctx)
 void fimc_hw_en_capture(struct fimc_ctx *ctx)
 {
 	struct fimc_dev *dev = ctx->fimc_dev;
-	u32 cfg;
 
-	cfg = readl(dev->regs + S5P_CIIMGCPT);
-	/* One shot mode for output DMA or freerun for FIFO. */
-	if (ctx->out_path == FIMC_DMA)
-		cfg |= S5P_CIIMGCPT_CPT_FREN_ENABLE;
-	else
-		cfg &= ~S5P_CIIMGCPT_CPT_FREN_ENABLE;
+	u32 cfg = readl(dev->regs + S5P_CIIMGCPT);
+
+	if (ctx->out_path == FIMC_DMA) {
+		/* one shot mode */
+		cfg |= S5P_CIIMGCPT_CPT_FREN_ENABLE | S5P_CIIMGCPT_IMGCPTEN;
+	} else {
+		/* Continous frame capture mode (freerun). */
+		cfg &= ~(S5P_CIIMGCPT_CPT_FREN_ENABLE |
+			 S5P_CIIMGCPT_CPT_FRMOD_CNT);
+		cfg |= S5P_CIIMGCPT_IMGCPTEN;
+	}
 
 	if (ctx->scaler.enabled)
 		cfg |= S5P_CIIMGCPT_IMGCPTEN_SC;
@@ -523,3 +530,139 @@ void fimc_hw_set_output_addr(struct fimc_dev *dev,
 		    i, paddr->y, paddr->cb, paddr->cr);
 	} while (index == -1 && ++i < FIMC_MAX_OUT_BUFS);
 }
+
+int fimc_hw_set_camera_polarity(struct fimc_dev *fimc,
+				struct s3c_fimc_isp_info *cam)
+{
+	u32 cfg = readl(fimc->regs + S5P_CIGCTRL);
+
+	cfg &= ~(S5P_CIGCTRL_INVPOLPCLK | S5P_CIGCTRL_INVPOLVSYNC |
+		 S5P_CIGCTRL_INVPOLHREF | S5P_CIGCTRL_INVPOLHSYNC);
+
+	if (cam->flags & FIMC_CLK_INV_PCLK)
+		cfg |= S5P_CIGCTRL_INVPOLPCLK;
+
+	if (cam->flags & FIMC_CLK_INV_VSYNC)
+		cfg |= S5P_CIGCTRL_INVPOLVSYNC;
+
+	if (cam->flags & FIMC_CLK_INV_HREF)
+		cfg |= S5P_CIGCTRL_INVPOLHREF;
+
+	if (cam->flags & FIMC_CLK_INV_HSYNC)
+		cfg |= S5P_CIGCTRL_INVPOLHSYNC;
+
+	writel(cfg, fimc->regs + S5P_CIGCTRL);
+
+	return 0;
+}
+
+int fimc_hw_set_camera_source(struct fimc_dev *fimc,
+			      struct s3c_fimc_isp_info *cam)
+{
+	struct fimc_frame *f = &fimc->vid_cap.ctx->s_frame;
+	u32 cfg = 0;
+
+	if (cam->bus_type == FIMC_ITU_601 || cam->bus_type == FIMC_ITU_656) {
+
+		switch (fimc->vid_cap.fmt.code) {
+		case V4L2_MBUS_FMT_YUYV8_2X8:
+			cfg = S5P_CISRCFMT_ORDER422_YCBYCR;
+			break;
+		case V4L2_MBUS_FMT_YVYU8_2X8:
+			cfg = S5P_CISRCFMT_ORDER422_YCRYCB;
+			break;
+		case V4L2_MBUS_FMT_VYUY8_2X8:
+			cfg = S5P_CISRCFMT_ORDER422_CRYCBY;
+			break;
+		case V4L2_MBUS_FMT_UYVY8_2X8:
+			cfg = S5P_CISRCFMT_ORDER422_CBYCRY;
+			break;
+		default:
+			err("camera image format not supported: %d",
+			    fimc->vid_cap.fmt.code);
+			return -EINVAL;
+		}
+
+		if (cam->bus_type == FIMC_ITU_601) {
+			if (cam->bus_width == 8) {
+				cfg |= S5P_CISRCFMT_ITU601_8BIT;
+			} else if (cam->bus_width == 16) {
+				cfg |= S5P_CISRCFMT_ITU601_16BIT;
+			} else {
+				err("invalid bus width: %d", cam->bus_width);
+				return -EINVAL;
+			}
+		} /* else defaults to ITU-R BT.656 8-bit */
+	}
+
+	cfg |= S5P_CISRCFMT_HSIZE(f->o_width) | S5P_CISRCFMT_VSIZE(f->o_height);
+	writel(cfg, fimc->regs + S5P_CISRCFMT);
+	return 0;
+}
+
+
+int fimc_hw_set_camera_offset(struct fimc_dev *fimc, struct fimc_frame *f)
+{
+	u32 hoff2, voff2;
+
+	u32 cfg = readl(fimc->regs + S5P_CIWDOFST);
+
+	cfg &= ~(S5P_CIWDOFST_HOROFF_MASK | S5P_CIWDOFST_VEROFF_MASK);
+	cfg |=  S5P_CIWDOFST_OFF_EN |
+		S5P_CIWDOFST_HOROFF(f->offs_h) |
+		S5P_CIWDOFST_VEROFF(f->offs_v);
+
+	writel(cfg, fimc->regs + S5P_CIWDOFST);
+
+	/* See CIWDOFSTn register description in the datasheet for details. */
+	hoff2 = f->o_width - f->width - f->offs_h;
+	voff2 = f->o_height - f->height - f->offs_v;
+	cfg = S5P_CIWDOFST2_HOROFF(hoff2) | S5P_CIWDOFST2_VEROFF(voff2);
+
+	writel(cfg, fimc->regs + S5P_CIWDOFST2);
+	return 0;
+}
+
+int fimc_hw_set_camera_type(struct fimc_dev *fimc,
+			    struct s3c_fimc_isp_info *cam)
+{
+	u32 cfg, tmp;
+	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
+
+	cfg = readl(fimc->regs + S5P_CIGCTRL);
+
+	/* Select ITU B interface, disable Writeback path and test pattern. */
+	cfg &= ~(S5P_CIGCTRL_TESTPAT_MASK | S5P_CIGCTRL_SELCAM_ITU_A |
+		S5P_CIGCTRL_SELCAM_MIPI | S5P_CIGCTRL_CAMIF_SELWB |
+		S5P_CIGCTRL_SELCAM_MIPI_A);
+
+	if (cam->bus_type == FIMC_MIPI_CSI2) {
+		cfg |= S5P_CIGCTRL_SELCAM_MIPI;
+
+		if (cam->mux_id == 0)
+			cfg |= S5P_CIGCTRL_SELCAM_MIPI_A;
+
+		/* TODO: add remaining supported formats. */
+		if (vid_cap->fmt.code == V4L2_MBUS_FMT_VYUY8_2X8) {
+			tmp = S5P_CSIIMGFMT_YCBCR422_8BIT;
+		} else {
+			err("camera image format not supported: %d",
+			    vid_cap->fmt.code);
+			return -EINVAL;
+		}
+		writel(tmp | (0x1 << 8), fimc->regs + S5P_CSIIMGFMT);
+
+	} else if (cam->bus_type == FIMC_ITU_601 ||
+		  cam->bus_type == FIMC_ITU_656) {
+		if (cam->mux_id == 0) /* ITU-A, ITU-B: 0, 1 */
+			cfg |= S5P_CIGCTRL_SELCAM_ITU_A;
+	} else if (cam->bus_type == FIMC_LCD_WB) {
+		cfg |= S5P_CIGCTRL_CAMIF_SELWB;
+	} else {
+		err("invalid camera bus type selected\n");
+		return -EINVAL;
+	}
+	writel(cfg, fimc->regs + S5P_CIGCTRL);
+
+	return 0;
+}
diff --git a/include/media/s3c_fimc.h b/include/media/s3c_fimc.h
new file mode 100644
index 0000000..ca1b673
--- /dev/null
+++ b/include/media/s3c_fimc.h
@@ -0,0 +1,60 @@
+/*
+ * Samsung S5P SoC camera interface driver header
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd
+ * Author: Sylwester Nawrocki, <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef S3C_FIMC_H_
+#define S3C_FIMC_H_
+
+enum cam_bus_type {
+	FIMC_ITU_601 = 1,
+	FIMC_ITU_656,
+	FIMC_MIPI_CSI2,
+	FIMC_LCD_WB, /* FIFO link from LCD mixer */
+};
+
+#define FIMC_CLK_INV_PCLK	(1 << 0)
+#define FIMC_CLK_INV_VSYNC	(1 << 1)
+#define FIMC_CLK_INV_HREF	(1 << 2)
+#define FIMC_CLK_INV_HSYNC	(1 << 3)
+
+struct i2c_board_info;
+
+/**
+ * struct s3c_fimc_isp_info - image sensor information required for host
+ *			      interace configuration.
+ *
+ * @board_info: pointer to I2C subdevice's board info
+ * @bus_type: determines bus type, MIPI, ITU-R BT.601 etc.
+ * @i2c_bus_num: i2c control bus id the sensor is attached to
+ * @mux_id: FIMC camera interface multiplexer index (separate for MIPI and ITU)
+ * @bus_width: camera data bus width in bits
+ * @flags: flags defining bus signals polarity inversion (High by default)
+ */
+struct s3c_fimc_isp_info {
+	struct i2c_board_info *board_info;
+	enum cam_bus_type bus_type;
+	u16 i2c_bus_num;
+	u16 mux_id;
+	u16 bus_width;
+	u16 flags;
+};
+
+
+#define FIMC_MAX_CAMIF_CLIENTS	2
+
+/**
+ * struct s3c_platform_fimc - camera host interface platform data
+ *
+ * @isp_info: properties of camera sensor required for host interface setup
+ */
+struct s3c_platform_fimc {
+	struct s3c_fimc_isp_info *isp_info[FIMC_MAX_CAMIF_CLIENTS];
+};
+#endif /* S3C_FIMC_H_ */
-- 
1.7.3.1

