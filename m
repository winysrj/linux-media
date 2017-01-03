Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35800 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935250AbdACU6C (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2017 15:58:02 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
To: shawnguo@kernel.org, kernel@pengutronix.de, fabio.estevam@nxp.com,
        robh+dt@kernel.org, mark.rutland@arm.com, linux@armlinux.org.uk,
        mchehab@kernel.org, gregkh@linuxfoundation.org,
        p.zabel@pengutronix.de
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 13/19] media: imx: Add IC subdev drivers
Date: Tue,  3 Jan 2017 12:57:23 -0800
Message-Id: <1483477049-19056-14-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
References: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a set of three media entity subdevice drivers for the i.MX
Image Converter. The i.MX IC module contains three independent
"tasks":

- Pre-processing Encode task: video frames are routed directly from
  the CSI and can be scaled, color-space converted, and rotated.
  Scaled output is limited to 1024x1024 resolution. Output frames
  are routed to the camera interface entities (camif).

- Pre-processing Viewfinder task: this task can perform the same
  conversions as the pre-process encode task, but in addition can
  be used for hardware motion compensated deinterlacing. Frames can
  come either directly from the CSI or from the SMFC entities (memory
  buffers via IDMAC channels). Scaled output is limited to 1024x1024
  resolution. Output frames can be routed to various sinks including
  the post-processing task entities.

- Post-processing task: same conversions as pre-process encode. However
  this entity sends frames to the i.MX IPU image converter which supports
  image tiling, which allows scaled output up to 4096x4096 resolution.
  Output frames can be routed to the camera interfaces.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/Makefile        |    2 +
 drivers/staging/media/imx/imx-ic-common.c |  113 +++
 drivers/staging/media/imx/imx-ic-pp.c     |  636 ++++++++++++++++
 drivers/staging/media/imx/imx-ic-prpenc.c | 1037 +++++++++++++++++++++++++
 drivers/staging/media/imx/imx-ic-prpvf.c  | 1180 +++++++++++++++++++++++++++++
 drivers/staging/media/imx/imx-ic.h        |   36 +
 6 files changed, 3004 insertions(+)
 create mode 100644 drivers/staging/media/imx/imx-ic-common.c
 create mode 100644 drivers/staging/media/imx/imx-ic-pp.c
 create mode 100644 drivers/staging/media/imx/imx-ic-prpenc.c
 create mode 100644 drivers/staging/media/imx/imx-ic-prpvf.c
 create mode 100644 drivers/staging/media/imx/imx-ic.h

diff --git a/drivers/staging/media/imx/Makefile b/drivers/staging/media/imx/Makefile
index 3559d7b..d2a962c 100644
--- a/drivers/staging/media/imx/Makefile
+++ b/drivers/staging/media/imx/Makefile
@@ -1,8 +1,10 @@
 imx-media-objs := imx-media-dev.o imx-media-fim.o imx-media-internal-sd.o \
 	imx-media-of.o
+imx-ic-objs := imx-ic-common.o imx-ic-prpenc.o imx-ic-prpvf.o imx-ic-pp.o
 
 obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media.o
 obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media-common.o
+obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-ic.o
 
 obj-$(CONFIG_VIDEO_IMX_CAMERA) += imx-csi.o
 obj-$(CONFIG_VIDEO_IMX_CAMERA) += imx-smfc.o
diff --git a/drivers/staging/media/imx/imx-ic-common.c b/drivers/staging/media/imx/imx-ic-common.c
new file mode 100644
index 0000000..1b40558
--- /dev/null
+++ b/drivers/staging/media/imx/imx-ic-common.c
@@ -0,0 +1,113 @@
+/*
+ * V4L2 Image Converter Subdev for Freescale i.MX5/6 SOC
+ *
+ * Copyright (c) 2014-2016 Mentor Graphics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-subdev.h>
+#include "imx-media.h"
+#include "imx-ic.h"
+
+static struct imx_ic_ops *ic_ops[IC_NUM_TASKS] = {
+	[IC_TASK_ENCODER]        = &imx_ic_prpenc_ops,
+	[IC_TASK_VIEWFINDER]     = &imx_ic_prpvf_ops,
+	[IC_TASK_POST_PROCESSOR] = &imx_ic_pp_ops,
+};
+
+static int imx_ic_probe(struct platform_device *pdev)
+{
+	struct imx_media_internal_sd_platformdata *pdata;
+	struct imx_ic_priv *priv;
+	int ret;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, &priv->sd);
+	priv->dev = &pdev->dev;
+
+	/* get our ipu_id, grp_id and IC task id */
+	pdata = priv->dev->platform_data;
+	priv->ipu_id = pdata->ipu_id;
+	switch (pdata->grp_id) {
+	case IMX_MEDIA_GRP_ID_IC_PRPENC:
+		priv->task_id = IC_TASK_ENCODER;
+		break;
+	case IMX_MEDIA_GRP_ID_IC_PRPVF:
+		priv->task_id = IC_TASK_VIEWFINDER;
+		break;
+	case IMX_MEDIA_GRP_ID_IC_PP0...IMX_MEDIA_GRP_ID_IC_PP3:
+		priv->task_id = IC_TASK_POST_PROCESSOR;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	v4l2_subdev_init(&priv->sd, ic_ops[priv->task_id]->subdev_ops);
+	v4l2_set_subdevdata(&priv->sd, priv);
+	priv->sd.internal_ops = ic_ops[priv->task_id]->internal_ops;
+	priv->sd.entity.ops = ic_ops[priv->task_id]->entity_ops;
+	priv->sd.entity.function = MEDIA_ENT_F_PROC_VIDEO_SCALER;
+	priv->sd.dev = &pdev->dev;
+	priv->sd.owner = THIS_MODULE;
+	priv->sd.flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
+	priv->sd.grp_id = pdata->grp_id;
+	strncpy(priv->sd.name, pdata->sd_name, sizeof(priv->sd.name));
+
+	ret = ic_ops[priv->task_id]->init(priv);
+	if (ret)
+		return ret;
+
+	ret = v4l2_async_register_subdev(&priv->sd);
+	if (ret)
+		goto remove;
+
+	return 0;
+remove:
+	ic_ops[priv->task_id]->remove(priv);
+	return ret;
+}
+
+static int imx_ic_remove(struct platform_device *pdev)
+{
+	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
+	struct imx_ic_priv *priv = container_of(sd, struct imx_ic_priv, sd);
+
+	ic_ops[priv->task_id]->remove(priv);
+
+	v4l2_async_unregister_subdev(&priv->sd);
+	media_entity_cleanup(&priv->sd.entity);
+	v4l2_device_unregister_subdev(sd);
+
+	return 0;
+}
+
+static const struct platform_device_id imx_ic_ids[] = {
+	{ .name = "imx-ipuv3-ic" },
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, imx_ic_ids);
+
+static struct platform_driver imx_ic_driver = {
+	.probe = imx_ic_probe,
+	.remove = imx_ic_remove,
+	.id_table = imx_ic_ids,
+	.driver = {
+		.name = "imx-ipuv3-ic",
+		.owner = THIS_MODULE,
+	},
+};
+module_platform_driver(imx_ic_driver);
+
+MODULE_DESCRIPTION("i.MX IC subdev driver");
+MODULE_AUTHOR("Steve Longerbeam <steve_longerbeam@mentor.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:imx-ipuv3-ic");
diff --git a/drivers/staging/media/imx/imx-ic-pp.c b/drivers/staging/media/imx/imx-ic-pp.c
new file mode 100644
index 0000000..5ef0581
--- /dev/null
+++ b/drivers/staging/media/imx/imx-ic-pp.c
@@ -0,0 +1,636 @@
+/*
+ * V4L2 IC Post-Processor Subdev for Freescale i.MX5/6 SOC
+ *
+ * Copyright (c) 2014-2016 Mentor Graphics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/timer.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/pinctrl/consumer.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-dma-contig.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-of.h>
+#include <media/v4l2-ctrls.h>
+#include <media/imx.h>
+#include <video/imx-ipu-image-convert.h>
+#include "imx-media.h"
+#include "imx-ic.h"
+
+#define PP_NUM_PADS 2
+
+struct pp_priv {
+	struct imx_media_dev *md;
+	struct imx_ic_priv *ic_priv;
+	int pp_id;
+
+	struct ipu_soc *ipu;
+	struct ipu_image_convert_ctx *ic_ctx;
+
+	struct media_pad pad[PP_NUM_PADS];
+	int input_pad;
+	int output_pad;
+
+	/* our dma buffer sink ring */
+	struct imx_media_dma_buf_ring *in_ring;
+	/* the dma buffer ring we send to sink */
+	struct imx_media_dma_buf_ring *out_ring;
+	struct ipu_image_convert_run *out_run;
+
+	struct imx_media_dma_buf *inbuf; /* last input buffer */
+
+	bool stream_on;    /* streaming is on */
+	bool stop;         /* streaming is stopping */
+	spinlock_t irqlock;
+
+	struct v4l2_subdev *src_sd;
+	struct v4l2_subdev *sink_sd;
+
+	struct v4l2_mbus_framefmt format_mbus[PP_NUM_PADS];
+	const struct imx_media_pixfmt *cc[PP_NUM_PADS];
+
+	/* motion select control */
+	struct v4l2_ctrl_handler ctrl_hdlr;
+	int  rotation; /* degrees */
+	bool hflip;
+	bool vflip;
+
+	/* derived from rotation, hflip, vflip controls */
+	enum ipu_rotate_mode rot_mode;
+};
+
+static inline struct pp_priv *sd_to_priv(struct v4l2_subdev *sd)
+{
+	struct imx_ic_priv *ic_priv = v4l2_get_subdevdata(sd);
+
+	return ic_priv->task_priv;
+}
+
+static void pp_convert_complete(struct ipu_image_convert_run *run,
+				void *data)
+{
+	struct pp_priv *priv = data;
+	struct imx_media_dma_buf *done;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->irqlock, flags);
+
+	done = imx_media_dma_buf_get_active(priv->out_ring);
+	/* give the completed buffer to the sink */
+	if (!WARN_ON(!done))
+		imx_media_dma_buf_done(done, run->status ?
+				       IMX_MEDIA_BUF_STATUS_ERROR :
+				       IMX_MEDIA_BUF_STATUS_DONE);
+
+	/* we're done with the inbuf, queue it back */
+	imx_media_dma_buf_queue(priv->in_ring, priv->inbuf->index);
+
+	spin_unlock_irqrestore(&priv->irqlock, flags);
+}
+
+static void pp_queue_conversion(struct pp_priv *priv,
+				struct imx_media_dma_buf *inbuf)
+{
+	struct ipu_image_convert_run *run;
+	struct imx_media_dma_buf *outbuf;
+
+	/* get next queued buffer and make it active */
+	outbuf = imx_media_dma_buf_get_next_queued(priv->out_ring);
+	imx_media_dma_buf_set_active(outbuf);
+	priv->inbuf = inbuf;
+
+	run = &priv->out_run[outbuf->index];
+	run->ctx = priv->ic_ctx;
+	run->in_phys = inbuf->phys;
+	run->out_phys = outbuf->phys;
+	ipu_image_convert_queue(run);
+}
+
+static long pp_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
+{
+	struct pp_priv *priv = sd_to_priv(sd);
+	struct imx_media_dma_buf_ring **ring;
+	struct imx_media_dma_buf *buf;
+	unsigned long flags;
+
+	switch (cmd) {
+	case IMX_MEDIA_REQ_DMA_BUF_SINK_RING:
+		/* src asks for a buffer ring */
+		if (!priv->in_ring)
+			return -EINVAL;
+		ring = (struct imx_media_dma_buf_ring **)arg;
+		*ring = priv->in_ring;
+		break;
+	case IMX_MEDIA_NEW_DMA_BUF:
+		/* src hands us a new buffer */
+		spin_lock_irqsave(&priv->irqlock, flags);
+		if (!priv->stop &&
+		    !imx_media_dma_buf_get_active(priv->out_ring)) {
+			buf = imx_media_dma_buf_dequeue(priv->in_ring);
+			if (buf)
+				pp_queue_conversion(priv, buf);
+		}
+		spin_unlock_irqrestore(&priv->irqlock, flags);
+		break;
+	case IMX_MEDIA_REL_DMA_BUF_SINK_RING:
+		/* src indicates sink buffer ring can be freed */
+		if (!priv->in_ring)
+			return 0;
+		v4l2_info(sd, "%s: freeing sink ring\n", __func__);
+		imx_media_free_dma_buf_ring(priv->in_ring);
+		priv->in_ring = NULL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int pp_start(struct pp_priv *priv)
+{
+	struct imx_ic_priv *ic_priv = priv->ic_priv;
+	struct ipu_image image_in, image_out;
+	const struct imx_media_pixfmt *incc;
+	struct v4l2_mbus_framefmt *infmt;
+	int i, in_size, ret;
+
+	/* ask the sink for the buffer ring */
+	ret = v4l2_subdev_call(priv->sink_sd, core, ioctl,
+			       IMX_MEDIA_REQ_DMA_BUF_SINK_RING,
+			       &priv->out_ring);
+	if (ret)
+		return ret;
+
+	imx_media_mbus_fmt_to_ipu_image(&image_in,
+					&priv->format_mbus[priv->input_pad]);
+	imx_media_mbus_fmt_to_ipu_image(&image_out,
+					&priv->format_mbus[priv->output_pad]);
+
+	priv->ipu = priv->md->ipu[ic_priv->ipu_id];
+	priv->ic_ctx = ipu_image_convert_prepare(priv->ipu,
+						 IC_TASK_POST_PROCESSOR,
+						 &image_in, &image_out,
+						 priv->rot_mode,
+						 pp_convert_complete, priv);
+	if (IS_ERR(priv->ic_ctx))
+		return PTR_ERR(priv->ic_ctx);
+
+	infmt = &priv->format_mbus[priv->input_pad];
+	incc = priv->cc[priv->input_pad];
+	in_size = (infmt->width * incc->bpp * infmt->height) >> 3;
+
+	if (priv->in_ring) {
+		v4l2_warn(&ic_priv->sd, "%s: dma-buf ring was not freed\n",
+			  __func__);
+		imx_media_free_dma_buf_ring(priv->in_ring);
+	}
+
+	priv->in_ring = imx_media_alloc_dma_buf_ring(priv->md,
+						     &priv->src_sd->entity,
+						     &ic_priv->sd.entity,
+						     in_size,
+						     IMX_MEDIA_MIN_RING_BUFS,
+						     true);
+	if (IS_ERR(priv->in_ring)) {
+		v4l2_err(&ic_priv->sd,
+			 "failed to alloc dma-buf ring\n");
+		ret = PTR_ERR(priv->in_ring);
+		priv->in_ring = NULL;
+		goto out_unprep;
+	}
+
+	for (i = 0; i < IMX_MEDIA_MIN_RING_BUFS; i++)
+		imx_media_dma_buf_queue(priv->in_ring, i);
+
+	priv->out_run = kzalloc(IMX_MEDIA_MAX_RING_BUFS *
+				sizeof(*priv->out_run), GFP_KERNEL);
+	if (!priv->out_run) {
+		v4l2_err(&ic_priv->sd, "failed to alloc src ring runs\n");
+		ret = -ENOMEM;
+		goto out_free_ring;
+	}
+
+	priv->stop = false;
+
+	return 0;
+
+out_free_ring:
+	imx_media_free_dma_buf_ring(priv->in_ring);
+	priv->in_ring = NULL;
+out_unprep:
+	ipu_image_convert_unprepare(priv->ic_ctx);
+	return ret;
+}
+
+static void pp_stop(struct pp_priv *priv)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->irqlock, flags);
+	priv->stop = true;
+	spin_unlock_irqrestore(&priv->irqlock, flags);
+
+	ipu_image_convert_unprepare(priv->ic_ctx);
+	kfree(priv->out_run);
+
+	priv->out_ring = NULL;
+
+	/* inform sink that its sink buffer ring can now be freed */
+	v4l2_subdev_call(priv->sink_sd, core, ioctl,
+			 IMX_MEDIA_REL_DMA_BUF_SINK_RING, 0);
+}
+
+static int pp_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct pp_priv *priv = sd_to_priv(sd);
+	int ret = 0;
+
+	if (!priv->src_sd || !priv->sink_sd)
+		return -EPIPE;
+
+	v4l2_info(sd, "stream %s\n", enable ? "ON" : "OFF");
+
+	if (enable && !priv->stream_on)
+		ret = pp_start(priv);
+	else if (!enable && priv->stream_on)
+		pp_stop(priv);
+
+	if (!ret)
+		priv->stream_on = enable;
+	return ret;
+}
+
+static int pp_enum_mbus_code(struct v4l2_subdev *sd,
+			     struct v4l2_subdev_pad_config *cfg,
+			     struct v4l2_subdev_mbus_code_enum *code)
+{
+	const struct imx_media_pixfmt *cc;
+	u32 fourcc;
+	int ret;
+
+	if (code->pad >= PP_NUM_PADS)
+		return -EINVAL;
+
+	ret = ipu_image_convert_enum_format(code->index, &fourcc);
+	if (ret)
+		return ret;
+
+	/* convert returned fourcc to mbus code */
+	cc = imx_media_find_format(fourcc, 0, true, true);
+	if (WARN_ON(!cc))
+		return -EINVAL;
+
+	code->code = cc->codes[0];
+	return 0;
+}
+
+static int pp_get_fmt(struct v4l2_subdev *sd,
+		      struct v4l2_subdev_pad_config *cfg,
+		      struct v4l2_subdev_format *sdformat)
+{
+	struct pp_priv *priv = sd_to_priv(sd);
+
+	if (sdformat->pad >= PP_NUM_PADS)
+		return -EINVAL;
+
+	sdformat->format = priv->format_mbus[sdformat->pad];
+
+	return 0;
+}
+
+static int pp_set_fmt(struct v4l2_subdev *sd,
+		      struct v4l2_subdev_pad_config *cfg,
+		      struct v4l2_subdev_format *sdformat)
+{
+	struct pp_priv *priv = sd_to_priv(sd);
+	struct v4l2_mbus_framefmt *infmt, *outfmt;
+	const struct imx_media_pixfmt *cc;
+	struct ipu_image test_in, test_out;
+	u32 code;
+
+	if (sdformat->pad >= PP_NUM_PADS)
+		return -EINVAL;
+
+	if (priv->stream_on)
+		return -EBUSY;
+
+	infmt = &priv->format_mbus[priv->input_pad];
+	outfmt = &priv->format_mbus[priv->output_pad];
+
+	cc = imx_media_find_format(0, sdformat->format.code, true, true);
+	if (!cc) {
+		imx_media_enum_format(&code, 0, true, true);
+		cc = imx_media_find_format(0, code, true, true);
+		sdformat->format.code = cc->codes[0];
+	}
+
+	if (sdformat->pad == priv->output_pad) {
+		imx_media_mbus_fmt_to_ipu_image(&test_out, &sdformat->format);
+		imx_media_mbus_fmt_to_ipu_image(&test_in, infmt);
+		ipu_image_convert_adjust(&test_in, &test_out, priv->rot_mode);
+		imx_media_ipu_image_to_mbus_fmt(&sdformat->format, &test_out);
+	} else {
+		imx_media_mbus_fmt_to_ipu_image(&test_in, &sdformat->format);
+		imx_media_mbus_fmt_to_ipu_image(&test_out, outfmt);
+		ipu_image_convert_adjust(&test_in, &test_out, priv->rot_mode);
+		imx_media_ipu_image_to_mbus_fmt(&sdformat->format, &test_in);
+	}
+
+	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY) {
+		cfg->try_fmt = sdformat->format;
+	} else {
+		if (sdformat->pad == priv->output_pad) {
+			*outfmt = sdformat->format;
+			imx_media_ipu_image_to_mbus_fmt(infmt, &test_in);
+		} else {
+			*infmt = sdformat->format;
+			imx_media_ipu_image_to_mbus_fmt(outfmt, &test_out);
+		}
+		priv->cc[sdformat->pad] = cc;
+	}
+
+	return 0;
+}
+
+static int pp_link_setup(struct media_entity *entity,
+			 const struct media_pad *local,
+			 const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct imx_ic_priv *ic_priv = v4l2_get_subdevdata(sd);
+	struct pp_priv *priv = ic_priv->task_priv;
+	struct v4l2_subdev *remote_sd;
+
+	dev_dbg(ic_priv->dev, "link setup %s -> %s", remote->entity->name,
+		local->entity->name);
+
+	remote_sd = media_entity_to_v4l2_subdev(remote->entity);
+
+	if (local->flags & MEDIA_PAD_FL_SOURCE) {
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (priv->sink_sd)
+				return -EBUSY;
+			priv->sink_sd = remote_sd;
+		} else {
+			priv->sink_sd = NULL;
+		}
+	} else {
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (priv->src_sd)
+				return -EBUSY;
+			priv->src_sd = remote_sd;
+		} else {
+			priv->src_sd = NULL;
+		}
+	}
+
+	return 0;
+}
+
+static int pp_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct pp_priv *priv = container_of(ctrl->handler,
+					       struct pp_priv, ctrl_hdlr);
+	struct imx_ic_priv *ic_priv = priv->ic_priv;
+	enum ipu_rotate_mode rot_mode;
+	bool hflip, vflip;
+	int rotation, ret;
+
+	rotation = priv->rotation;
+	hflip = priv->hflip;
+	vflip = priv->vflip;
+
+	switch (ctrl->id) {
+	case V4L2_CID_HFLIP:
+		hflip = (ctrl->val == 1);
+		break;
+	case V4L2_CID_VFLIP:
+		vflip = (ctrl->val == 1);
+		break;
+	case V4L2_CID_ROTATE:
+		rotation = ctrl->val;
+		break;
+	default:
+		v4l2_err(&ic_priv->sd, "Invalid control\n");
+		return -EINVAL;
+	}
+
+	ret = ipu_degrees_to_rot_mode(&rot_mode, rotation, hflip, vflip);
+	if (ret)
+		return ret;
+
+	if (rot_mode != priv->rot_mode) {
+		struct v4l2_mbus_framefmt *infmt, *outfmt;
+		struct ipu_image test_in, test_out;
+
+		/* can't change rotation mid-streaming */
+		if (priv->stream_on)
+			return -EBUSY;
+
+		/*
+		 * make sure this rotation will work with current input/output
+		 * formats before setting
+		 */
+		infmt = &priv->format_mbus[priv->input_pad];
+		outfmt = &priv->format_mbus[priv->output_pad];
+		imx_media_mbus_fmt_to_ipu_image(&test_in, infmt);
+		imx_media_mbus_fmt_to_ipu_image(&test_out, outfmt);
+
+		ret = ipu_image_convert_verify(&test_in, &test_out, rot_mode);
+		if (ret)
+			return ret;
+
+		priv->rot_mode = rot_mode;
+		priv->rotation = rotation;
+		priv->hflip = hflip;
+		priv->vflip = vflip;
+	}
+
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops pp_ctrl_ops = {
+	.s_ctrl = pp_s_ctrl,
+};
+
+static const struct v4l2_ctrl_config pp_std_ctrl[] = {
+	{
+		.id = V4L2_CID_HFLIP,
+		.name = "Horizontal Flip",
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.def =  0,
+		.min =  0,
+		.max =  1,
+		.step = 1,
+	}, {
+		.id = V4L2_CID_VFLIP,
+		.name = "Vertical Flip",
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.def =  0,
+		.min =  0,
+		.max =  1,
+		.step = 1,
+	}, {
+		.id = V4L2_CID_ROTATE,
+		.name = "Rotation",
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.def =   0,
+		.min =   0,
+		.max = 270,
+		.step = 90,
+	},
+};
+
+#define PP_NUM_CONTROLS ARRAY_SIZE(pp_std_ctrl)
+
+static int pp_init_controls(struct pp_priv *priv)
+{
+	struct imx_ic_priv *ic_priv = priv->ic_priv;
+	struct v4l2_ctrl_handler *hdlr = &priv->ctrl_hdlr;
+	const struct v4l2_ctrl_config *c;
+	int i, ret;
+
+	v4l2_ctrl_handler_init(hdlr, PP_NUM_CONTROLS);
+
+	for (i = 0; i < PP_NUM_CONTROLS; i++) {
+		c = &pp_std_ctrl[i];
+		v4l2_ctrl_new_std(hdlr, &pp_ctrl_ops,
+				  c->id, c->min, c->max, c->step, c->def);
+	}
+
+	ic_priv->sd.ctrl_handler = hdlr;
+
+	if (hdlr->error) {
+		ret = hdlr->error;
+		v4l2_ctrl_handler_free(hdlr);
+		return ret;
+	}
+
+	v4l2_ctrl_handler_setup(hdlr);
+
+	return 0;
+}
+
+/*
+ * retrieve our pads parsed from the OF graph by the media device
+ */
+static int pp_registered(struct v4l2_subdev *sd)
+{
+	struct pp_priv *priv = sd_to_priv(sd);
+	struct imx_media_subdev *imxsd;
+	struct imx_media_pad *pad;
+	int i, ret;
+
+	/* get media device */
+	priv->md = dev_get_drvdata(sd->v4l2_dev->dev);
+
+	imxsd = imx_media_find_subdev_by_sd(priv->md, sd);
+	if (IS_ERR(imxsd))
+		return PTR_ERR(imxsd);
+
+	if (imxsd->num_sink_pads != 1 || imxsd->num_src_pads != 1)
+		return -EINVAL;
+
+	for (i = 0; i < PP_NUM_PADS; i++) {
+		pad = &imxsd->pad[i];
+		priv->pad[i] = pad->pad;
+		if (priv->pad[i].flags & MEDIA_PAD_FL_SINK)
+			priv->input_pad = i;
+		else
+			priv->output_pad = i;
+
+		/* set a default mbus format  */
+		ret = imx_media_init_mbus_fmt(&priv->format_mbus[i],
+					      640, 480, 0, V4L2_FIELD_NONE,
+					      &priv->cc[i]);
+		if (ret)
+			return ret;
+	}
+
+	ret = pp_init_controls(priv);
+	if (ret)
+		return ret;
+
+	ret = media_entity_pads_init(&sd->entity, PP_NUM_PADS, priv->pad);
+	if (ret)
+		goto free_ctrls;
+
+	return 0;
+free_ctrls:
+	v4l2_ctrl_handler_free(&priv->ctrl_hdlr);
+	return ret;
+}
+
+static struct v4l2_subdev_pad_ops pp_pad_ops = {
+	.enum_mbus_code = pp_enum_mbus_code,
+	.get_fmt = pp_get_fmt,
+	.set_fmt = pp_set_fmt,
+};
+
+static struct v4l2_subdev_video_ops pp_video_ops = {
+	.s_stream = pp_s_stream,
+};
+
+static struct v4l2_subdev_core_ops pp_core_ops = {
+	.ioctl = pp_ioctl,
+};
+
+static struct media_entity_operations pp_entity_ops = {
+	.link_setup = pp_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
+};
+
+static struct v4l2_subdev_ops pp_subdev_ops = {
+	.video = &pp_video_ops,
+	.pad = &pp_pad_ops,
+	.core = &pp_core_ops,
+};
+
+static struct v4l2_subdev_internal_ops pp_internal_ops = {
+	.registered = pp_registered,
+};
+
+static int pp_init(struct imx_ic_priv *ic_priv)
+{
+	struct pp_priv *priv;
+
+	priv = devm_kzalloc(ic_priv->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	ic_priv->task_priv = priv;
+	priv->ic_priv = ic_priv;
+	spin_lock_init(&priv->irqlock);
+
+	/* get our PP id */
+	priv->pp_id = (ic_priv->sd.grp_id >> IMX_MEDIA_GRP_ID_IC_PP_BIT) - 1;
+
+	return 0;
+}
+
+static void pp_remove(struct imx_ic_priv *ic_priv)
+{
+	struct pp_priv *priv = ic_priv->task_priv;
+
+	v4l2_ctrl_handler_free(&priv->ctrl_hdlr);
+}
+
+struct imx_ic_ops imx_ic_pp_ops = {
+	.subdev_ops = &pp_subdev_ops,
+	.internal_ops = &pp_internal_ops,
+	.entity_ops = &pp_entity_ops,
+	.init = pp_init,
+	.remove = pp_remove,
+};
diff --git a/drivers/staging/media/imx/imx-ic-prpenc.c b/drivers/staging/media/imx/imx-ic-prpenc.c
new file mode 100644
index 0000000..e17216b
--- /dev/null
+++ b/drivers/staging/media/imx/imx-ic-prpenc.c
@@ -0,0 +1,1037 @@
+/*
+ * V4L2 Capture IC Encoder Subdev for Freescale i.MX5/6 SOC
+ *
+ * This subdevice handles capture of video frames from the CSI, which
+ * are routed directly to the Image Converter preprocess encode task,
+ * for resizing, colorspace conversion, and rotation.
+ *
+ * Copyright (c) 2012-2016 Mentor Graphics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/timer.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/platform_device.h>
+#include <linux/pinctrl/consumer.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-dma-contig.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-of.h>
+#include <media/v4l2-ctrls.h>
+#include <media/imx.h>
+#include "imx-media.h"
+#include "imx-ic.h"
+
+#define PRPENC_NUM_PADS 2
+
+#define MAX_W_IC   1024
+#define MAX_H_IC   1024
+#define MAX_W_SINK 4096
+#define MAX_H_SINK 4096
+
+struct prpenc_priv {
+	struct imx_media_dev *md;
+	struct imx_ic_priv *ic_priv;
+
+	/* IPU units we require */
+	struct ipu_soc *ipu;
+	struct ipu_ic *ic_enc;
+
+	struct media_pad pad[PRPENC_NUM_PADS];
+	int input_pad;
+	int output_pad;
+
+	struct ipuv3_channel *enc_ch;
+	struct ipuv3_channel *enc_rot_in_ch;
+	struct ipuv3_channel *enc_rot_out_ch;
+
+	/* the dma buffer ring to send to sink */
+	struct imx_media_dma_buf_ring *out_ring;
+	struct imx_media_dma_buf *next;
+
+	int ipu_buf_num;  /* ipu double buffer index: 0-1 */
+
+	struct v4l2_subdev *src_sd;
+	struct v4l2_subdev *sink_sd;
+
+	/* the CSI id at link validate */
+	int csi_id;
+
+	/* the attached sensor at stream on */
+	struct imx_media_subdev *sensor;
+
+	struct v4l2_mbus_framefmt format_mbus[PRPENC_NUM_PADS];
+	const struct imx_media_pixfmt *cc[PRPENC_NUM_PADS];
+
+	struct imx_media_dma_buf rot_buf[2];
+
+	/* controls */
+	struct v4l2_ctrl_handler ctrl_hdlr;
+	int  rotation; /* degrees */
+	bool hflip;
+	bool vflip;
+
+	/* derived from rotation, hflip, vflip controls */
+	enum ipu_rotate_mode rot_mode;
+
+	spinlock_t irqlock;
+
+	struct timer_list eof_timeout_timer;
+	int eof_irq;
+	int nfb4eof_irq;
+
+	bool stream_on; /* streaming is on */
+	bool last_eof;  /* waiting for last EOF at stream off */
+	struct completion last_eof_comp;
+};
+
+static inline struct prpenc_priv *sd_to_priv(struct v4l2_subdev *sd)
+{
+	struct imx_ic_priv *ic_priv = v4l2_get_subdevdata(sd);
+
+	return ic_priv->task_priv;
+}
+
+static void prpenc_put_ipu_resources(struct prpenc_priv *priv)
+{
+	if (!IS_ERR_OR_NULL(priv->ic_enc))
+		ipu_ic_put(priv->ic_enc);
+	priv->ic_enc = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->enc_ch))
+		ipu_idmac_put(priv->enc_ch);
+	priv->enc_ch = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->enc_rot_in_ch))
+		ipu_idmac_put(priv->enc_rot_in_ch);
+	priv->enc_rot_in_ch = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->enc_rot_out_ch))
+		ipu_idmac_put(priv->enc_rot_out_ch);
+	priv->enc_rot_out_ch = NULL;
+}
+
+static int prpenc_get_ipu_resources(struct prpenc_priv *priv)
+{
+	struct imx_ic_priv *ic_priv = priv->ic_priv;
+	int ret;
+
+	priv->ipu = priv->md->ipu[ic_priv->ipu_id];
+
+	priv->ic_enc = ipu_ic_get(priv->ipu, IC_TASK_ENCODER);
+	if (IS_ERR(priv->ic_enc)) {
+		v4l2_err(&ic_priv->sd, "failed to get IC ENC\n");
+		ret = PTR_ERR(priv->ic_enc);
+		goto out;
+	}
+
+	priv->enc_ch = ipu_idmac_get(priv->ipu,
+				     IPUV3_CHANNEL_IC_PRP_ENC_MEM);
+	if (IS_ERR(priv->enc_ch)) {
+		v4l2_err(&ic_priv->sd, "could not get IDMAC channel %u\n",
+			 IPUV3_CHANNEL_IC_PRP_ENC_MEM);
+		ret = PTR_ERR(priv->enc_ch);
+		goto out;
+	}
+
+	priv->enc_rot_in_ch = ipu_idmac_get(priv->ipu,
+					    IPUV3_CHANNEL_MEM_ROT_ENC);
+	if (IS_ERR(priv->enc_rot_in_ch)) {
+		v4l2_err(&ic_priv->sd, "could not get IDMAC channel %u\n",
+			 IPUV3_CHANNEL_MEM_ROT_ENC);
+		ret = PTR_ERR(priv->enc_rot_in_ch);
+		goto out;
+	}
+
+	priv->enc_rot_out_ch = ipu_idmac_get(priv->ipu,
+					     IPUV3_CHANNEL_ROT_ENC_MEM);
+	if (IS_ERR(priv->enc_rot_out_ch)) {
+		v4l2_err(&ic_priv->sd, "could not get IDMAC channel %u\n",
+			 IPUV3_CHANNEL_ROT_ENC_MEM);
+		ret = PTR_ERR(priv->enc_rot_out_ch);
+		goto out;
+	}
+
+	return 0;
+out:
+	prpenc_put_ipu_resources(priv);
+	return ret;
+}
+
+static irqreturn_t prpenc_eof_interrupt(int irq, void *dev_id)
+{
+	struct prpenc_priv *priv = dev_id;
+	struct imx_media_dma_buf *done, *next;
+	struct ipuv3_channel *channel;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->irqlock, flags);
+
+	if (priv->last_eof) {
+		complete(&priv->last_eof_comp);
+		priv->last_eof = false;
+		goto unlock;
+	}
+
+	/* inform CSI of this EOF so it can monitor frame intervals */
+	v4l2_subdev_call(priv->src_sd, core, interrupt_service_routine,
+			 0, NULL);
+
+	channel = (ipu_rot_mode_is_irt(priv->rot_mode)) ?
+		priv->enc_rot_out_ch : priv->enc_ch;
+
+	done = imx_media_dma_buf_get_active(priv->out_ring);
+	/* give the completed buffer to the sink  */
+	if (!WARN_ON(!done))
+		imx_media_dma_buf_done(done, IMX_MEDIA_BUF_STATUS_DONE);
+
+	/* priv->next buffer is now the active one */
+	imx_media_dma_buf_set_active(priv->next);
+
+	/* bump the EOF timeout timer */
+	mod_timer(&priv->eof_timeout_timer,
+		  jiffies + msecs_to_jiffies(IMX_MEDIA_EOF_TIMEOUT));
+
+	if (ipu_idmac_buffer_is_ready(channel, priv->ipu_buf_num))
+		ipu_idmac_clear_buffer(channel, priv->ipu_buf_num);
+
+	/* get next queued buffer */
+	next = imx_media_dma_buf_get_next_queued(priv->out_ring);
+
+	ipu_cpmem_set_buffer(channel, priv->ipu_buf_num, next->phys);
+	ipu_idmac_select_buffer(channel, priv->ipu_buf_num);
+
+	/* toggle IPU double-buffer index */
+	priv->ipu_buf_num ^= 1;
+	priv->next = next;
+
+unlock:
+	spin_unlock_irqrestore(&priv->irqlock, flags);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t prpenc_nfb4eof_interrupt(int irq, void *dev_id)
+{
+	struct prpenc_priv *priv = dev_id;
+	struct imx_ic_priv *ic_priv = priv->ic_priv;
+	static const struct v4l2_event ev = {
+		.type = V4L2_EVENT_IMX_NFB4EOF,
+	};
+
+	v4l2_err(&ic_priv->sd, "NFB4EOF\n");
+
+	v4l2_subdev_notify_event(&ic_priv->sd, &ev);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * EOF timeout timer function.
+ */
+static void prpenc_eof_timeout(unsigned long data)
+{
+	struct prpenc_priv *priv = (struct prpenc_priv *)data;
+	struct imx_ic_priv *ic_priv = priv->ic_priv;
+	static const struct v4l2_event ev = {
+		.type = V4L2_EVENT_IMX_EOF_TIMEOUT,
+	};
+
+	v4l2_err(&ic_priv->sd, "EOF timeout\n");
+
+	v4l2_subdev_notify_event(&ic_priv->sd, &ev);
+}
+
+static void prpenc_setup_channel(struct prpenc_priv *priv,
+				 struct ipuv3_channel *channel,
+				 enum ipu_rotate_mode rot_mode,
+				 dma_addr_t addr0, dma_addr_t addr1,
+				 bool rot_swap_width_height)
+{
+	struct v4l2_mbus_framefmt *infmt, *outfmt;
+	unsigned int burst_size;
+	struct ipu_image image;
+
+	infmt = &priv->format_mbus[priv->input_pad];
+	outfmt = &priv->format_mbus[priv->output_pad];
+
+	if (rot_swap_width_height)
+		swap(outfmt->width, outfmt->height);
+
+	ipu_cpmem_zero(channel);
+
+	imx_media_mbus_fmt_to_ipu_image(&image, outfmt);
+
+	image.phys0 = addr0;
+	image.phys1 = addr1;
+	ipu_cpmem_set_image(channel, &image);
+
+	if (channel == priv->enc_rot_in_ch ||
+	    channel == priv->enc_rot_out_ch) {
+		burst_size = 8;
+		ipu_cpmem_set_block_mode(channel);
+	} else {
+		burst_size = (outfmt->width & 0xf) ? 8 : 16;
+	}
+
+	ipu_cpmem_set_burstsize(channel, burst_size);
+
+	if (rot_mode)
+		ipu_cpmem_set_rotation(channel, rot_mode);
+
+	if (outfmt->field == V4L2_FIELD_NONE &&
+	    (V4L2_FIELD_HAS_BOTH(infmt->field) ||
+	     infmt->field == V4L2_FIELD_ALTERNATE) &&
+	    channel == priv->enc_ch)
+		ipu_cpmem_interlaced_scan(channel, image.pix.bytesperline);
+
+	ipu_ic_task_idma_init(priv->ic_enc, channel,
+			      outfmt->width, outfmt->height,
+			      burst_size, rot_mode);
+	ipu_cpmem_set_axi_id(channel, 1);
+
+	ipu_idmac_set_double_buffer(channel, true);
+
+	if (rot_swap_width_height)
+		swap(outfmt->width, outfmt->height);
+}
+
+static int prpenc_setup_rotation(struct prpenc_priv *priv)
+{
+	struct imx_ic_priv *ic_priv = priv->ic_priv;
+	struct v4l2_mbus_framefmt *infmt, *outfmt;
+	const struct imx_media_pixfmt *outcc, *incc;
+	struct imx_media_dma_buf *buf0, *buf1;
+	int out_size, ret;
+
+	infmt = &priv->format_mbus[priv->input_pad];
+	outfmt = &priv->format_mbus[priv->output_pad];
+	incc = priv->cc[priv->input_pad];
+	outcc = priv->cc[priv->output_pad];
+
+	out_size = (outfmt->width * outcc->bpp * outfmt->height) >> 3;
+
+	ret = imx_media_alloc_dma_buf(priv->md, &priv->rot_buf[0], out_size);
+	if (ret) {
+		v4l2_err(&ic_priv->sd, "failed to alloc rot_buf[0], %d\n", ret);
+		return ret;
+	}
+	ret = imx_media_alloc_dma_buf(priv->md, &priv->rot_buf[1], out_size);
+	if (ret) {
+		v4l2_err(&ic_priv->sd, "failed to alloc rot_buf[1], %d\n", ret);
+		goto free_rot0;
+	}
+
+	ret = ipu_ic_task_init(priv->ic_enc,
+			       infmt->width, infmt->height,
+			       outfmt->height, outfmt->width,
+			       incc->cs, outcc->cs);
+	if (ret) {
+		v4l2_err(&ic_priv->sd, "ipu_ic_task_init failed, %d\n", ret);
+		goto free_rot1;
+	}
+
+	/* init the IC ENC-->MEM IDMAC channel */
+	prpenc_setup_channel(priv, priv->enc_ch,
+			     IPU_ROTATE_NONE,
+			     priv->rot_buf[0].phys,
+			     priv->rot_buf[1].phys,
+			     true);
+
+	/* init the MEM-->IC ENC ROT IDMAC channel */
+	prpenc_setup_channel(priv, priv->enc_rot_in_ch,
+			     priv->rot_mode,
+			     priv->rot_buf[0].phys,
+			     priv->rot_buf[1].phys,
+			     true);
+
+	buf0 = imx_media_dma_buf_get_next_queued(priv->out_ring);
+	imx_media_dma_buf_set_active(buf0);
+	buf1 = imx_media_dma_buf_get_next_queued(priv->out_ring);
+	priv->next = buf1;
+
+	/* init the destination IC ENC ROT-->MEM IDMAC channel */
+	prpenc_setup_channel(priv, priv->enc_rot_out_ch,
+			     IPU_ROTATE_NONE,
+			     buf0->phys, buf1->phys,
+			     false);
+
+	/* now link IC ENC-->MEM to MEM-->IC ENC ROT */
+	ipu_idmac_link(priv->enc_ch, priv->enc_rot_in_ch);
+
+	/* enable the IC */
+	ipu_ic_enable(priv->ic_enc);
+
+	/* set buffers ready */
+	ipu_idmac_select_buffer(priv->enc_ch, 0);
+	ipu_idmac_select_buffer(priv->enc_ch, 1);
+	ipu_idmac_select_buffer(priv->enc_rot_out_ch, 0);
+	ipu_idmac_select_buffer(priv->enc_rot_out_ch, 1);
+
+	/* enable the channels */
+	ipu_idmac_enable_channel(priv->enc_ch);
+	ipu_idmac_enable_channel(priv->enc_rot_in_ch);
+	ipu_idmac_enable_channel(priv->enc_rot_out_ch);
+
+	/* and finally enable the IC PRPENC task */
+	ipu_ic_task_enable(priv->ic_enc);
+
+	return 0;
+
+free_rot1:
+	imx_media_free_dma_buf(priv->md, &priv->rot_buf[1]);
+free_rot0:
+	imx_media_free_dma_buf(priv->md, &priv->rot_buf[0]);
+	return ret;
+}
+
+static void prpenc_unsetup_rotation(struct prpenc_priv *priv)
+{
+	ipu_ic_task_disable(priv->ic_enc);
+
+	ipu_idmac_disable_channel(priv->enc_ch);
+	ipu_idmac_disable_channel(priv->enc_rot_in_ch);
+	ipu_idmac_disable_channel(priv->enc_rot_out_ch);
+
+	ipu_idmac_unlink(priv->enc_ch, priv->enc_rot_in_ch);
+
+	ipu_ic_disable(priv->ic_enc);
+
+	imx_media_free_dma_buf(priv->md, &priv->rot_buf[0]);
+	imx_media_free_dma_buf(priv->md, &priv->rot_buf[1]);
+}
+
+static int prpenc_setup_norotation(struct prpenc_priv *priv)
+{
+	struct imx_ic_priv *ic_priv = priv->ic_priv;
+	struct v4l2_mbus_framefmt *infmt, *outfmt;
+	const struct imx_media_pixfmt *outcc, *incc;
+	struct imx_media_dma_buf *buf0, *buf1;
+	int ret;
+
+	infmt = &priv->format_mbus[priv->input_pad];
+	outfmt = &priv->format_mbus[priv->output_pad];
+	incc = priv->cc[priv->input_pad];
+	outcc = priv->cc[priv->output_pad];
+
+	ret = ipu_ic_task_init(priv->ic_enc,
+			       infmt->width, infmt->height,
+			       outfmt->width, outfmt->height,
+			       incc->cs, outcc->cs);
+	if (ret) {
+		v4l2_err(&ic_priv->sd, "ipu_ic_task_init failed, %d\n", ret);
+		return ret;
+	}
+
+	buf0 = imx_media_dma_buf_get_next_queued(priv->out_ring);
+	imx_media_dma_buf_set_active(buf0);
+	buf1 = imx_media_dma_buf_get_next_queued(priv->out_ring);
+	priv->next = buf1;
+
+	/* init the IC PRP-->MEM IDMAC channel */
+	prpenc_setup_channel(priv, priv->enc_ch, priv->rot_mode,
+			     buf0->phys, buf1->phys,
+			     false);
+
+	ipu_cpmem_dump(priv->enc_ch);
+	ipu_ic_dump(priv->ic_enc);
+	ipu_dump(priv->ipu);
+
+	ipu_ic_enable(priv->ic_enc);
+
+	/* set buffers ready */
+	ipu_idmac_select_buffer(priv->enc_ch, 0);
+	ipu_idmac_select_buffer(priv->enc_ch, 1);
+
+	/* enable the channels */
+	ipu_idmac_enable_channel(priv->enc_ch);
+
+	/* enable the IC ENCODE task */
+	ipu_ic_task_enable(priv->ic_enc);
+
+	return 0;
+}
+
+static void prpenc_unsetup_norotation(struct prpenc_priv *priv)
+{
+	ipu_ic_task_disable(priv->ic_enc);
+	ipu_idmac_disable_channel(priv->enc_ch);
+	ipu_ic_disable(priv->ic_enc);
+}
+
+static int prpenc_start(struct prpenc_priv *priv)
+{
+	struct imx_ic_priv *ic_priv = priv->ic_priv;
+	int ret;
+
+	if (!priv->sensor) {
+		v4l2_err(&ic_priv->sd, "no sensor attached\n");
+		return -EINVAL;
+	}
+
+	ret = prpenc_get_ipu_resources(priv);
+	if (ret)
+		return ret;
+
+	/* set IC to receive from CSI */
+	ipu_set_ic_src_mux(priv->ipu, priv->csi_id, false);
+
+	/* ask the sink for the buffer ring */
+	ret = v4l2_subdev_call(priv->sink_sd, core, ioctl,
+			       IMX_MEDIA_REQ_DMA_BUF_SINK_RING,
+			       &priv->out_ring);
+	if (ret)
+		goto out_put_ipu;
+
+	priv->ipu_buf_num = 0;
+
+	/* init EOF completion waitq */
+	init_completion(&priv->last_eof_comp);
+	priv->last_eof = false;
+
+	if (ipu_rot_mode_is_irt(priv->rot_mode))
+		ret = prpenc_setup_rotation(priv);
+	else
+		ret = prpenc_setup_norotation(priv);
+	if (ret)
+		goto out_put_ipu;
+
+	priv->nfb4eof_irq = ipu_idmac_channel_irq(priv->ipu,
+						  priv->enc_ch,
+						  IPU_IRQ_NFB4EOF);
+	ret = devm_request_irq(ic_priv->dev, priv->nfb4eof_irq,
+			       prpenc_nfb4eof_interrupt, 0,
+			       "imx-ic-prpenc-nfb4eof", priv);
+	if (ret) {
+		v4l2_err(&ic_priv->sd,
+			 "Error registering NFB4EOF irq: %d\n", ret);
+		goto out_unsetup;
+	}
+
+	if (ipu_rot_mode_is_irt(priv->rot_mode))
+		priv->eof_irq = ipu_idmac_channel_irq(
+			priv->ipu, priv->enc_rot_out_ch, IPU_IRQ_EOF);
+	else
+		priv->eof_irq = ipu_idmac_channel_irq(
+			priv->ipu, priv->enc_ch, IPU_IRQ_EOF);
+
+	ret = devm_request_irq(ic_priv->dev, priv->eof_irq,
+			       prpenc_eof_interrupt, 0,
+			       "imx-ic-prpenc-eof", priv);
+	if (ret) {
+		v4l2_err(&ic_priv->sd,
+			 "Error registering eof irq: %d\n", ret);
+		goto out_free_nfb4eof_irq;
+	}
+
+	/* start the EOF timeout timer */
+	mod_timer(&priv->eof_timeout_timer,
+		  jiffies + msecs_to_jiffies(IMX_MEDIA_EOF_TIMEOUT));
+
+	return 0;
+
+out_free_nfb4eof_irq:
+	devm_free_irq(ic_priv->dev, priv->nfb4eof_irq, priv);
+out_unsetup:
+	if (ipu_rot_mode_is_irt(priv->rot_mode))
+		prpenc_unsetup_rotation(priv);
+	else
+		prpenc_unsetup_norotation(priv);
+out_put_ipu:
+	prpenc_put_ipu_resources(priv);
+	return ret;
+}
+
+static void prpenc_stop(struct prpenc_priv *priv)
+{
+	struct imx_ic_priv *ic_priv = priv->ic_priv;
+	unsigned long flags;
+	int ret;
+
+	/* mark next EOF interrupt as the last before stream off */
+	spin_lock_irqsave(&priv->irqlock, flags);
+	priv->last_eof = true;
+	spin_unlock_irqrestore(&priv->irqlock, flags);
+
+	/*
+	 * and then wait for interrupt handler to mark completion.
+	 */
+	ret = wait_for_completion_timeout(
+		&priv->last_eof_comp,
+		msecs_to_jiffies(IMX_MEDIA_EOF_TIMEOUT));
+	if (ret == 0)
+		v4l2_warn(&ic_priv->sd, "wait last EOF timeout\n");
+
+	devm_free_irq(ic_priv->dev, priv->eof_irq, priv);
+	devm_free_irq(ic_priv->dev, priv->nfb4eof_irq, priv);
+
+	if (ipu_rot_mode_is_irt(priv->rot_mode))
+		prpenc_unsetup_rotation(priv);
+	else
+		prpenc_unsetup_norotation(priv);
+
+	prpenc_put_ipu_resources(priv);
+
+	/* cancel the EOF timeout timer */
+	del_timer_sync(&priv->eof_timeout_timer);
+
+	priv->out_ring = NULL;
+
+	/* inform sink that the buffer ring can now be freed */
+	v4l2_subdev_call(priv->sink_sd, core, ioctl,
+			 IMX_MEDIA_REL_DMA_BUF_SINK_RING, 0);
+}
+
+static int prpenc_enum_mbus_code(struct v4l2_subdev *sd,
+				 struct v4l2_subdev_pad_config *cfg,
+				 struct v4l2_subdev_mbus_code_enum *code)
+{
+	struct prpenc_priv *priv = sd_to_priv(sd);
+	bool allow_planar;
+
+	if (code->pad >= PRPENC_NUM_PADS)
+		return -EINVAL;
+
+	allow_planar = (code->pad == priv->output_pad);
+
+	return imx_media_enum_format(&code->code, code->index,
+				     true, allow_planar);
+}
+
+static int prpenc_get_fmt(struct v4l2_subdev *sd,
+			  struct v4l2_subdev_pad_config *cfg,
+			  struct v4l2_subdev_format *sdformat)
+{
+	struct prpenc_priv *priv = sd_to_priv(sd);
+
+	if (sdformat->pad >= PRPENC_NUM_PADS)
+		return -EINVAL;
+
+	sdformat->format = priv->format_mbus[sdformat->pad];
+
+	return 0;
+}
+
+static int prpenc_set_fmt(struct v4l2_subdev *sd,
+			  struct v4l2_subdev_pad_config *cfg,
+			  struct v4l2_subdev_format *sdformat)
+{
+	struct prpenc_priv *priv = sd_to_priv(sd);
+	struct v4l2_mbus_framefmt *infmt, *outfmt;
+	const struct imx_media_pixfmt *cc;
+	bool allow_planar;
+	u32 code;
+
+	if (sdformat->pad >= PRPENC_NUM_PADS)
+		return -EINVAL;
+
+	if (priv->stream_on)
+		return -EBUSY;
+
+	infmt = &priv->format_mbus[priv->input_pad];
+	outfmt = &priv->format_mbus[priv->output_pad];
+	allow_planar = (sdformat->pad == priv->output_pad);
+
+	cc = imx_media_find_format(0, sdformat->format.code,
+				   true, allow_planar);
+	if (!cc) {
+		imx_media_enum_format(&code, 0, true, false);
+		cc = imx_media_find_format(0, code, true, false);
+		sdformat->format.code = cc->codes[0];
+	}
+
+	if (sdformat->pad == priv->output_pad) {
+		sdformat->format.width = min_t(__u32,
+					       sdformat->format.width,
+					       MAX_W_IC);
+		sdformat->format.height = min_t(__u32,
+						sdformat->format.height,
+						MAX_H_IC);
+
+		if (sdformat->format.field != V4L2_FIELD_NONE)
+			sdformat->format.field = infmt->field;
+
+		/* IC resizer cannot downsize more than 4:1 */
+		if (ipu_rot_mode_is_irt(priv->rot_mode)) {
+			sdformat->format.width = max_t(__u32,
+						       sdformat->format.width,
+						       infmt->height / 4);
+			sdformat->format.height = max_t(__u32,
+							sdformat->format.height,
+							infmt->width / 4);
+		} else {
+			sdformat->format.width = max_t(__u32,
+						       sdformat->format.width,
+						       infmt->width / 4);
+			sdformat->format.height = max_t(__u32,
+							sdformat->format.height,
+							infmt->height / 4);
+		}
+	} else {
+		sdformat->format.width = min_t(__u32,
+					       sdformat->format.width,
+					       MAX_W_SINK);
+		sdformat->format.height = min_t(__u32,
+						sdformat->format.height,
+						MAX_H_SINK);
+	}
+
+	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY) {
+		cfg->try_fmt = sdformat->format;
+	} else {
+		priv->format_mbus[sdformat->pad] = sdformat->format;
+		priv->cc[sdformat->pad] = cc;
+	}
+
+	return 0;
+}
+
+static int prpenc_link_setup(struct media_entity *entity,
+			     const struct media_pad *local,
+			     const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct imx_ic_priv *ic_priv = v4l2_get_subdevdata(sd);
+	struct prpenc_priv *priv = ic_priv->task_priv;
+	struct v4l2_subdev *remote_sd;
+
+	dev_dbg(ic_priv->dev, "link setup %s -> %s", remote->entity->name,
+		local->entity->name);
+
+	remote_sd = media_entity_to_v4l2_subdev(remote->entity);
+
+	if (local->flags & MEDIA_PAD_FL_SOURCE) {
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (priv->sink_sd)
+				return -EBUSY;
+			priv->sink_sd = remote_sd;
+		} else {
+			priv->sink_sd = NULL;
+		}
+
+		return 0;
+	}
+
+	/* this is sink pad */
+	if (flags & MEDIA_LNK_FL_ENABLED) {
+		if (priv->src_sd)
+			return -EBUSY;
+		priv->src_sd = remote_sd;
+	} else {
+		priv->src_sd = NULL;
+		return 0;
+	}
+
+	switch (remote_sd->grp_id) {
+	case IMX_MEDIA_GRP_ID_CSI0:
+		priv->csi_id = 0;
+		break;
+	case IMX_MEDIA_GRP_ID_CSI1:
+		priv->csi_id = 1;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int prpenc_link_validate(struct v4l2_subdev *sd,
+				struct media_link *link,
+				struct v4l2_subdev_format *source_fmt,
+				struct v4l2_subdev_format *sink_fmt)
+{
+	struct imx_ic_priv *ic_priv = v4l2_get_subdevdata(sd);
+	struct prpenc_priv *priv = ic_priv->task_priv;
+	struct v4l2_mbus_config sensor_mbus_cfg;
+	int ret;
+
+	ret = v4l2_subdev_link_validate_default(sd, link,
+						source_fmt, sink_fmt);
+	if (ret)
+		return ret;
+
+	priv->sensor = __imx_media_find_sensor(priv->md, &ic_priv->sd.entity);
+	if (IS_ERR(priv->sensor)) {
+		v4l2_err(&ic_priv->sd, "no sensor attached\n");
+		ret = PTR_ERR(priv->sensor);
+		priv->sensor = NULL;
+		return ret;
+	}
+
+	ret = v4l2_subdev_call(priv->sensor->sd, video, g_mbus_config,
+			       &sensor_mbus_cfg);
+	if (ret)
+		return ret;
+
+	if (sensor_mbus_cfg.type == V4L2_MBUS_CSI2) {
+		int vc_num = 0;
+		/* see NOTE in imx-csi.c */
+#if 0
+		vc_num = imx_media_find_mipi_csi2_channel(
+			priv->md, &ic_priv->sd.entity);
+		if (vc_num < 0)
+			return vc_num;
+#endif
+		/* only virtual channel 0 can be sent to IC */
+		if (vc_num != 0)
+			return -EINVAL;
+	} else {
+		/*
+		 * only 8-bit pixels can be sent to IC for parallel
+		 * busses
+		 */
+		if (priv->sensor->sensor_ep.bus.parallel.bus_width >= 16)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int prpenc_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct prpenc_priv *priv = container_of(ctrl->handler,
+					       struct prpenc_priv, ctrl_hdlr);
+	struct imx_ic_priv *ic_priv = priv->ic_priv;
+	enum ipu_rotate_mode rot_mode;
+	bool hflip, vflip;
+	int rotation, ret;
+
+	rotation = priv->rotation;
+	hflip = priv->hflip;
+	vflip = priv->vflip;
+
+	switch (ctrl->id) {
+	case V4L2_CID_HFLIP:
+		hflip = (ctrl->val == 1);
+		break;
+	case V4L2_CID_VFLIP:
+		vflip = (ctrl->val == 1);
+		break;
+	case V4L2_CID_ROTATE:
+		rotation = ctrl->val;
+		break;
+	default:
+		v4l2_err(&ic_priv->sd, "Invalid control\n");
+		return -EINVAL;
+	}
+
+	ret = ipu_degrees_to_rot_mode(&rot_mode, rotation, hflip, vflip);
+	if (ret)
+		return ret;
+
+	if (rot_mode != priv->rot_mode) {
+		/* can't change rotation mid-streaming */
+		if (priv->stream_on)
+			return -EBUSY;
+
+		priv->rot_mode = rot_mode;
+		priv->rotation = rotation;
+		priv->hflip = hflip;
+		priv->vflip = vflip;
+	}
+
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops prpenc_ctrl_ops = {
+	.s_ctrl = prpenc_s_ctrl,
+};
+
+static const struct v4l2_ctrl_config prpenc_std_ctrl[] = {
+	{
+		.id = V4L2_CID_HFLIP,
+		.name = "Horizontal Flip",
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.def =  0,
+		.min =  0,
+		.max =  1,
+		.step = 1,
+	}, {
+		.id = V4L2_CID_VFLIP,
+		.name = "Vertical Flip",
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.def =  0,
+		.min =  0,
+		.max =  1,
+		.step = 1,
+	}, {
+		.id = V4L2_CID_ROTATE,
+		.name = "Rotation",
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.def =   0,
+		.min =   0,
+		.max = 270,
+		.step = 90,
+	},
+};
+
+#define PRPENC_NUM_CONTROLS ARRAY_SIZE(prpenc_std_ctrl)
+
+static int prpenc_init_controls(struct prpenc_priv *priv)
+{
+	struct imx_ic_priv *ic_priv = priv->ic_priv;
+	struct v4l2_ctrl_handler *hdlr = &priv->ctrl_hdlr;
+	const struct v4l2_ctrl_config *c;
+	int i, ret;
+
+	v4l2_ctrl_handler_init(hdlr, PRPENC_NUM_CONTROLS);
+
+	for (i = 0; i < PRPENC_NUM_CONTROLS; i++) {
+		c = &prpenc_std_ctrl[i];
+		v4l2_ctrl_new_std(hdlr, &prpenc_ctrl_ops,
+				  c->id, c->min, c->max, c->step, c->def);
+	}
+
+	ic_priv->sd.ctrl_handler = hdlr;
+
+	if (hdlr->error) {
+		ret = hdlr->error;
+		goto out_free;
+	}
+
+	v4l2_ctrl_handler_setup(hdlr);
+	return 0;
+
+out_free:
+	v4l2_ctrl_handler_free(hdlr);
+	return ret;
+}
+
+static int prpenc_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct prpenc_priv *priv = sd_to_priv(sd);
+	int ret = 0;
+
+	if (!priv->src_sd || !priv->sink_sd)
+		return -EPIPE;
+
+	v4l2_info(sd, "stream %s\n", enable ? "ON" : "OFF");
+
+	if (enable && !priv->stream_on)
+		ret = prpenc_start(priv);
+	else if (!enable && priv->stream_on)
+		prpenc_stop(priv);
+
+	if (!ret)
+		priv->stream_on = enable;
+	return ret;
+}
+
+/*
+ * retrieve our pads parsed from the OF graph by the media device
+ */
+static int prpenc_registered(struct v4l2_subdev *sd)
+{
+	struct prpenc_priv *priv = sd_to_priv(sd);
+	struct imx_media_subdev *imxsd;
+	struct imx_media_pad *pad;
+	int i, ret;
+
+	/* get media device */
+	priv->md = dev_get_drvdata(sd->v4l2_dev->dev);
+
+	imxsd = imx_media_find_subdev_by_sd(priv->md, sd);
+	if (IS_ERR(imxsd))
+		return PTR_ERR(imxsd);
+
+	if (imxsd->num_sink_pads != 1 || imxsd->num_src_pads != 1)
+		return -EINVAL;
+
+	for (i = 0; i < PRPENC_NUM_PADS; i++) {
+		pad = &imxsd->pad[i];
+		priv->pad[i] = pad->pad;
+		if (priv->pad[i].flags & MEDIA_PAD_FL_SINK)
+			priv->input_pad = i;
+		else
+			priv->output_pad = i;
+
+		/* set a default mbus format  */
+		ret = imx_media_init_mbus_fmt(&priv->format_mbus[i],
+					      640, 480, 0, V4L2_FIELD_NONE,
+					      &priv->cc[i]);
+		if (ret)
+			return ret;
+	}
+
+	ret = prpenc_init_controls(priv);
+	if (ret)
+		return ret;
+
+	ret = media_entity_pads_init(&sd->entity, PRPENC_NUM_PADS, priv->pad);
+	if (ret)
+		goto free_ctrls;
+
+	return 0;
+free_ctrls:
+	v4l2_ctrl_handler_free(&priv->ctrl_hdlr);
+	return ret;
+}
+
+static struct v4l2_subdev_pad_ops prpenc_pad_ops = {
+	.enum_mbus_code = prpenc_enum_mbus_code,
+	.get_fmt = prpenc_get_fmt,
+	.set_fmt = prpenc_set_fmt,
+	.link_validate = prpenc_link_validate,
+};
+
+static struct v4l2_subdev_video_ops prpenc_video_ops = {
+	.s_stream = prpenc_s_stream,
+};
+
+static struct media_entity_operations prpenc_entity_ops = {
+	.link_setup = prpenc_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
+};
+
+static struct v4l2_subdev_ops prpenc_subdev_ops = {
+	.video = &prpenc_video_ops,
+	.pad = &prpenc_pad_ops,
+};
+
+static struct v4l2_subdev_internal_ops prpenc_internal_ops = {
+	.registered = prpenc_registered,
+};
+
+static int prpenc_init(struct imx_ic_priv *ic_priv)
+{
+	struct prpenc_priv *priv;
+
+	priv = devm_kzalloc(ic_priv->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	ic_priv->task_priv = priv;
+	priv->ic_priv = ic_priv;
+
+	spin_lock_init(&priv->irqlock);
+	init_timer(&priv->eof_timeout_timer);
+	priv->eof_timeout_timer.data = (unsigned long)priv;
+	priv->eof_timeout_timer.function = prpenc_eof_timeout;
+
+	return 0;
+}
+
+static void prpenc_remove(struct imx_ic_priv *ic_priv)
+{
+	struct prpenc_priv *priv = ic_priv->task_priv;
+
+	v4l2_ctrl_handler_free(&priv->ctrl_hdlr);
+}
+
+struct imx_ic_ops imx_ic_prpenc_ops = {
+	.subdev_ops = &prpenc_subdev_ops,
+	.internal_ops = &prpenc_internal_ops,
+	.entity_ops = &prpenc_entity_ops,
+	.init = prpenc_init,
+	.remove = prpenc_remove,
+};
diff --git a/drivers/staging/media/imx/imx-ic-prpvf.c b/drivers/staging/media/imx/imx-ic-prpvf.c
new file mode 100644
index 0000000..53ce006
--- /dev/null
+++ b/drivers/staging/media/imx/imx-ic-prpvf.c
@@ -0,0 +1,1180 @@
+/*
+ * V4L2 IC Deinterlacer Subdev for Freescale i.MX5/6 SOC
+ *
+ * Copyright (c) 2014-2016 Mentor Graphics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/timer.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/pinctrl/consumer.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-dma-contig.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-of.h>
+#include <media/v4l2-ctrls.h>
+#include <media/imx.h>
+#include "imx-media.h"
+#include "imx-ic.h"
+
+/*
+ * This subdev implements two different video pipelines:
+ *
+ * CSI -> VDIC -> IC -> CH21 -> MEM
+ *
+ * In this pipeline, the CSI sends a single interlaced field F(n-1)
+ * directly to the VDIC (and optionally the following field F(n)
+ * can be sent to memory via IDMAC channel 13). So only two fields
+ * can be processed by the VDIC. This pipeline only works in VDIC's
+ * high motion mode, which only requires a single field for processing.
+ * The other motion modes (low and medium) require three fields, so this
+ * pipeline does not work in those modes. Also, it is not clear how this
+ * pipeline can deal with the various field orders (sequential BT/TB,
+ * interlaced BT/TB).
+ *
+ * CSI -> CH[0-3] -> MEM -> CH8,9,10 -> VDIC -> IC -> CH21 -> MEM
+ *
+ * In this pipeline, the CSI sends raw and full frames to memory buffers
+ * via the SMFC channels 0-3. Fields from these frames are then
+ * transferred to the VDIC via IDMAC channels 8,9,10. The VDIC requires
+ * three fields: previous field F(n-1), current field F(n), and next
+ * field F(n+1), so we need three raw frames in memory: two completed frames
+ * to send F(n-1), F(n), F(n+1) to the VDIC, and a third frame for active
+ * CSI capture while the completed fields are sent through the VDIC->IC for
+ * processing.
+ *
+ * The "direct" CSI->VDIC pipeline requires less memory bus bandwidth
+ * (just 1 channel vs. 5 channels for indirect pipeline), but it can
+ * only be used in high motion mode, and it only processes a single
+ * field (so half the original image resolution is lost).
+ */
+
+struct prpvf_priv;
+
+struct prpvf_pipeline_ops {
+	int (*setup)(struct prpvf_priv *priv);
+	void (*start)(struct prpvf_priv *priv);
+	void (*stop)(struct prpvf_priv *priv);
+	void (*disable)(struct prpvf_priv *priv);
+};
+
+#define PRPVF_NUM_PADS 2
+
+#define MAX_W_IC   1024
+#define MAX_H_IC   1024
+#define MAX_W_VDIC  968
+#define MAX_H_VDIC 2048
+
+struct prpvf_priv {
+	struct imx_media_dev *md;
+	struct imx_ic_priv *ic_priv;
+
+	/* IPU units we require */
+	struct ipu_soc *ipu;
+	struct ipu_ic *ic_vf;
+	struct ipu_vdi *vdi;
+
+	struct media_pad pad[PRPVF_NUM_PADS];
+	int input_pad;
+	int output_pad;
+
+	struct ipuv3_channel *vdi_in_ch_p; /* F(n-1) transfer channel */
+	struct ipuv3_channel *vdi_in_ch;   /* F(n) transfer channel */
+	struct ipuv3_channel *vdi_in_ch_n; /* F(n+1) transfer channel */
+	struct ipuv3_channel *prpvf_out_ch;/* final progressive frame channel */
+
+	/* pipeline operations */
+	struct prpvf_pipeline_ops *ops;
+
+	/* our dma buffer sink ring */
+	struct imx_media_dma_buf_ring *in_ring;
+	/* the dma buffer ring to send to sink */
+	struct imx_media_dma_buf_ring *out_ring;
+
+	/* ipu buf num for double-buffering (csi-direct path only) */
+	int ipu_buf_num;
+	struct imx_media_dma_buf *next_out_buf;
+
+	/* current and last input buffers indirect path */
+	struct imx_media_dma_buf *curr_in_buf;
+	struct imx_media_dma_buf *last_in_buf;
+
+	/*
+	 * translated field type, input line stride, and field size
+	 * for indirect path
+	 */
+	u32 fieldtype;
+	u32 in_stride;
+	u32 field_size;
+
+	struct v4l2_subdev *src_sd;
+	/* the sink that will receive the progressive out buffers */
+	struct v4l2_subdev *sink_sd;
+
+	/* the attached CSI at stream on */
+	struct v4l2_subdev *csi_sd;
+
+	/* the attached sensor at stream on */
+	struct imx_media_subdev *sensor;
+
+	/* the video standard from sensor at time of streamon */
+	v4l2_std_id std;
+
+	struct v4l2_mbus_framefmt format_mbus[PRPVF_NUM_PADS];
+	const struct imx_media_pixfmt *cc[PRPVF_NUM_PADS];
+
+	bool csi_direct;  /* using direct CSI->VDIC->IC pipeline */
+
+	/* motion select control */
+	struct v4l2_ctrl_handler ctrl_hdlr;
+	enum ipu_motion_sel motion;
+
+	struct timer_list eof_timeout_timer;
+
+	int nfb4eof_irq; /* CSI or PRPVF channel NFB4EOF IRQ */
+	int out_eof_irq; /* PRPVF channel EOF IRQ */
+	spinlock_t irqlock;
+
+	bool stream_on; /* streaming is on */
+	bool last_eof;  /* waiting for last EOF at stream off */
+	struct completion last_eof_comp;
+};
+
+static inline struct prpvf_priv *sd_to_priv(struct v4l2_subdev *sd)
+{
+	struct imx_ic_priv *ic_priv = v4l2_get_subdevdata(sd);
+
+	return ic_priv->task_priv;
+}
+
+static void prpvf_put_ipu_resources(struct prpvf_priv *priv)
+{
+	if (!IS_ERR_OR_NULL(priv->ic_vf))
+		ipu_ic_put(priv->ic_vf);
+	priv->ic_vf = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->vdi_in_ch_p))
+		ipu_idmac_put(priv->vdi_in_ch_p);
+	priv->vdi_in_ch_p = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->vdi_in_ch))
+		ipu_idmac_put(priv->vdi_in_ch);
+	priv->vdi_in_ch = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->vdi_in_ch_n))
+		ipu_idmac_put(priv->vdi_in_ch_n);
+	priv->vdi_in_ch_n = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->prpvf_out_ch))
+		ipu_idmac_put(priv->prpvf_out_ch);
+	priv->prpvf_out_ch = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->vdi))
+		ipu_vdi_put(priv->vdi);
+	priv->vdi = NULL;
+}
+
+static int prpvf_get_ipu_resources(struct prpvf_priv *priv)
+{
+	struct imx_ic_priv *ic_priv = priv->ic_priv;
+	int ret, err_chan;
+
+	priv->ipu = priv->md->ipu[ic_priv->ipu_id];
+
+	priv->ic_vf = ipu_ic_get(priv->ipu, IC_TASK_VIEWFINDER);
+	if (IS_ERR(priv->ic_vf)) {
+		v4l2_err(&ic_priv->sd, "failed to get IC VF\n");
+		ret = PTR_ERR(priv->ic_vf);
+		goto out;
+	}
+
+	priv->vdi = ipu_vdi_get(priv->ipu);
+	if (IS_ERR(priv->vdi)) {
+		v4l2_err(&ic_priv->sd, "failed to get VDIC\n");
+		ret = PTR_ERR(priv->vdi);
+		goto out;
+	}
+
+	priv->prpvf_out_ch = ipu_idmac_get(priv->ipu,
+					   IPUV3_CHANNEL_IC_PRP_VF_MEM);
+	if (IS_ERR(priv->prpvf_out_ch)) {
+		err_chan = IPUV3_CHANNEL_IC_PRP_VF_MEM;
+		ret = PTR_ERR(priv->prpvf_out_ch);
+		goto out_err_chan;
+	}
+
+	if (!priv->csi_direct) {
+		priv->vdi_in_ch_p = ipu_idmac_get(priv->ipu,
+						  IPUV3_CHANNEL_MEM_VDI_PREV);
+		if (IS_ERR(priv->vdi_in_ch_p)) {
+			err_chan = IPUV3_CHANNEL_MEM_VDI_PREV;
+			ret = PTR_ERR(priv->vdi_in_ch_p);
+			goto out_err_chan;
+		}
+
+		priv->vdi_in_ch = ipu_idmac_get(priv->ipu,
+						IPUV3_CHANNEL_MEM_VDI_CUR);
+		if (IS_ERR(priv->vdi_in_ch)) {
+			err_chan = IPUV3_CHANNEL_MEM_VDI_CUR;
+			ret = PTR_ERR(priv->vdi_in_ch);
+			goto out_err_chan;
+		}
+
+		priv->vdi_in_ch_n = ipu_idmac_get(priv->ipu,
+						  IPUV3_CHANNEL_MEM_VDI_NEXT);
+		if (IS_ERR(priv->vdi_in_ch_n)) {
+			err_chan = IPUV3_CHANNEL_MEM_VDI_NEXT;
+			ret = PTR_ERR(priv->vdi_in_ch_n);
+			goto out_err_chan;
+		}
+	}
+
+	return 0;
+
+out_err_chan:
+	v4l2_err(&ic_priv->sd, "could not get IDMAC channel %u\n", err_chan);
+out:
+	prpvf_put_ipu_resources(priv);
+	return ret;
+}
+
+static void prepare_vdi_in_buffers(struct prpvf_priv *priv,
+				   struct imx_media_dma_buf *curr)
+{
+	dma_addr_t prev_phys, curr_phys, next_phys;
+	struct imx_media_dma_buf *last;
+
+	last = priv->last_in_buf ? priv->last_in_buf : curr;
+	priv->curr_in_buf = curr;
+
+	switch (priv->fieldtype) {
+	case V4L2_FIELD_SEQ_TB:
+		prev_phys = last->phys;
+		curr_phys = curr->phys + priv->field_size;
+		next_phys = curr->phys;
+		break;
+	case V4L2_FIELD_SEQ_BT:
+		prev_phys = last->phys + priv->field_size;
+		curr_phys = curr->phys;
+		next_phys = curr->phys + priv->field_size;
+		break;
+	case V4L2_FIELD_INTERLACED_BT:
+		prev_phys = last->phys + priv->in_stride;
+		curr_phys = curr->phys;
+		next_phys = curr->phys + priv->in_stride;
+		break;
+	default:
+		/* assume V4L2_FIELD_INTERLACED_TB */
+		prev_phys = last->phys;
+		curr_phys = curr->phys + priv->in_stride;
+		next_phys = curr->phys;
+		break;
+	}
+
+	ipu_cpmem_set_buffer(priv->vdi_in_ch_p, 0, prev_phys);
+	ipu_cpmem_set_buffer(priv->vdi_in_ch,   0, curr_phys);
+	ipu_cpmem_set_buffer(priv->vdi_in_ch_n, 0, next_phys);
+
+	ipu_idmac_select_buffer(priv->vdi_in_ch_p, 0);
+	ipu_idmac_select_buffer(priv->vdi_in_ch, 0);
+	ipu_idmac_select_buffer(priv->vdi_in_ch_n, 0);
+}
+
+static void prepare_prpvf_out_buffer(struct prpvf_priv *priv)
+{
+	struct imx_media_dma_buf *buf;
+
+	/* get next buffer to prepare */
+	buf = imx_media_dma_buf_get_next_queued(priv->out_ring);
+	if (!priv->csi_direct) {
+		/*
+		 * indirect does not use double-buffering, so this
+		 * buffer is now the active one
+		 */
+		imx_media_dma_buf_set_active(buf);
+	} else {
+		priv->next_out_buf = buf;
+	}
+
+	ipu_cpmem_set_buffer(priv->prpvf_out_ch, priv->ipu_buf_num, buf->phys);
+	ipu_idmac_select_buffer(priv->prpvf_out_ch, priv->ipu_buf_num);
+}
+
+/* prpvf_out_ch EOF interrupt (progressive frame ready) */
+static irqreturn_t prpvf_out_eof_interrupt(int irq, void *dev_id)
+{
+	struct prpvf_priv *priv = dev_id;
+	struct imx_media_dma_buf *done;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->irqlock, flags);
+
+	if (priv->last_eof) {
+		complete(&priv->last_eof_comp);
+		priv->last_eof = false;
+		goto unlock;
+	}
+
+	if (priv->csi_direct) {
+		/* inform CSI of this EOF so it can monitor frame intervals */
+		/* FIXME: frames are coming in twice as fast in direct path! */
+		v4l2_subdev_call(priv->src_sd, core, interrupt_service_routine,
+				 0, NULL);
+	}
+
+	done = imx_media_dma_buf_get_active(priv->out_ring);
+	/* give the completed buffer to the sink  */
+	if (!WARN_ON(!done))
+		imx_media_dma_buf_done(done, IMX_MEDIA_BUF_STATUS_DONE);
+
+	if (!priv->csi_direct) {
+		/* we're done with the input buffer, queue it back */
+		imx_media_dma_buf_queue(priv->in_ring,
+					priv->curr_in_buf->index);
+
+		/* current input buffer is now last */
+		priv->last_in_buf = priv->curr_in_buf;
+	} else {
+		/*
+		 * priv->next buffer is now the active one due
+		 * to IPU double-buffering
+		 */
+		imx_media_dma_buf_set_active(priv->next_out_buf);
+	}
+
+	/* bump the EOF timeout timer */
+	mod_timer(&priv->eof_timeout_timer,
+		  jiffies + msecs_to_jiffies(IMX_MEDIA_EOF_TIMEOUT));
+
+	if (priv->csi_direct) {
+		prepare_prpvf_out_buffer(priv);
+		/* toggle IPU double-buffer index */
+		priv->ipu_buf_num ^= 1;
+	}
+
+unlock:
+	spin_unlock_irqrestore(&priv->irqlock, flags);
+	return IRQ_HANDLED;
+}
+
+static long prpvf_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
+{
+	struct prpvf_priv *priv = sd_to_priv(sd);
+	struct imx_media_dma_buf_ring **ring;
+	struct imx_media_dma_buf *buf;
+	unsigned long flags;
+
+	switch (cmd) {
+	case IMX_MEDIA_REQ_DMA_BUF_SINK_RING:
+		if (!priv->in_ring)
+			return -EINVAL;
+		ring = (struct imx_media_dma_buf_ring **)arg;
+		*ring = priv->in_ring;
+		break;
+	case IMX_MEDIA_NEW_DMA_BUF:
+		spin_lock_irqsave(&priv->irqlock, flags);
+		if (!imx_media_dma_buf_get_active(priv->out_ring)) {
+			buf = imx_media_dma_buf_dequeue(priv->in_ring);
+			if (buf) {
+				prepare_vdi_in_buffers(priv, buf);
+				prepare_prpvf_out_buffer(priv);
+			}
+		}
+		spin_unlock_irqrestore(&priv->irqlock, flags);
+		break;
+	case IMX_MEDIA_REL_DMA_BUF_SINK_RING:
+		/* src indicates sink buffer ring can be freed */
+		if (!priv->in_ring)
+			return 0;
+		v4l2_info(sd, "%s: freeing sink ring\n", __func__);
+		imx_media_free_dma_buf_ring(priv->in_ring);
+		priv->in_ring = NULL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static irqreturn_t nfb4eof_interrupt(int irq, void *dev_id)
+{
+	struct prpvf_priv *priv = dev_id;
+	struct imx_ic_priv *ic_priv = priv->ic_priv;
+	static const struct v4l2_event ev = {
+		.type = V4L2_EVENT_IMX_NFB4EOF,
+	};
+
+	v4l2_err(&ic_priv->sd, "NFB4EOF\n");
+
+	v4l2_subdev_notify_event(&ic_priv->sd, &ev);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * EOF timeout timer function.
+ */
+static void prpvf_eof_timeout(unsigned long data)
+{
+	struct prpvf_priv *priv = (struct prpvf_priv *)data;
+	struct imx_ic_priv *ic_priv = priv->ic_priv;
+	static const struct v4l2_event ev = {
+		.type = V4L2_EVENT_IMX_EOF_TIMEOUT,
+	};
+
+	v4l2_err(&ic_priv->sd, "EOF timeout\n");
+
+	v4l2_subdev_notify_event(&ic_priv->sd, &ev);
+}
+
+static void setup_vdi_channel(struct prpvf_priv *priv,
+			      struct ipuv3_channel *channel,
+			      dma_addr_t phys0, dma_addr_t phys1,
+			      bool out_chan)
+{
+	struct v4l2_mbus_framefmt *infmt, *outfmt;
+	unsigned int burst_size;
+	struct ipu_image image;
+
+	infmt = &priv->format_mbus[priv->input_pad];
+	outfmt = &priv->format_mbus[priv->output_pad];
+
+	if (out_chan) {
+		imx_media_mbus_fmt_to_ipu_image(&image, outfmt);
+	} else {
+		/* one field to VDIC channels */
+		infmt->height /= 2;
+		imx_media_mbus_fmt_to_ipu_image(&image, infmt);
+		infmt->height *= 2;
+	}
+	image.phys0 = phys0;
+	image.phys1 = phys1;
+
+	ipu_cpmem_zero(channel);
+	ipu_cpmem_set_image(channel, &image);
+
+	if (out_chan) {
+		burst_size = (outfmt->width & 0xf) ? 8 : 16;
+		ipu_cpmem_set_burstsize(channel, burst_size);
+		ipu_ic_task_idma_init(priv->ic_vf, channel,
+				      outfmt->width, outfmt->height,
+				      burst_size, IPU_ROTATE_NONE);
+	} else {
+		burst_size = (infmt->width & 0xf) ? 8 : 16;
+		ipu_cpmem_set_burstsize(channel, burst_size);
+	}
+
+	ipu_cpmem_set_axi_id(channel, 1);
+
+	ipu_idmac_set_double_buffer(channel, priv->csi_direct && out_chan);
+}
+
+static int prpvf_setup_direct(struct prpvf_priv *priv)
+{
+	struct imx_media_dma_buf *buf0, *buf1;
+
+	/* set VDIC to receive from CSI for direct path */
+	ipu_fsu_link(priv->ipu, IPUV3_CHANNEL_CSI_DIRECT,
+		     IPUV3_CHANNEL_CSI_VDI_PREV);
+
+	priv->ipu_buf_num = 0;
+
+	buf0 = imx_media_dma_buf_get_next_queued(priv->out_ring);
+	imx_media_dma_buf_set_active(buf0);
+	buf1 = imx_media_dma_buf_get_next_queued(priv->out_ring);
+	priv->next_out_buf = buf1;
+
+	/* init the prpvf out channel */
+	setup_vdi_channel(priv, priv->prpvf_out_ch,
+			  buf0->phys, buf1->phys, true);
+
+	return 0;
+}
+
+static void prpvf_start_direct(struct prpvf_priv *priv)
+{
+	/* set buffers ready */
+	ipu_idmac_select_buffer(priv->prpvf_out_ch, 0);
+	ipu_idmac_select_buffer(priv->prpvf_out_ch, 1);
+
+	/* enable the channels */
+	ipu_idmac_enable_channel(priv->prpvf_out_ch);
+}
+
+static void prpvf_stop_direct(struct prpvf_priv *priv)
+{
+	ipu_idmac_disable_channel(priv->prpvf_out_ch);
+}
+
+static void prpvf_disable_direct(struct prpvf_priv *priv)
+{
+	ipu_fsu_unlink(priv->ipu, IPUV3_CHANNEL_CSI_DIRECT,
+		       IPUV3_CHANNEL_CSI_VDI_PREV);
+}
+
+static int prpvf_setup_indirect(struct prpvf_priv *priv)
+{
+	struct imx_ic_priv *ic_priv = priv->ic_priv;
+	struct v4l2_mbus_framefmt *infmt;
+	const struct imx_media_pixfmt *incc;
+	int in_size, i, ret;
+
+	infmt = &priv->format_mbus[priv->input_pad];
+	incc = priv->cc[priv->input_pad];
+
+	in_size = (infmt->width * incc->bpp * infmt->height) >> 3;
+
+	/* 1/2 full image size */
+	priv->field_size = in_size / 2;
+	priv->in_stride = incc->planar ?
+		infmt->width : (infmt->width * incc->bpp) >> 3;
+
+	priv->ipu_buf_num = 0;
+
+	if (priv->in_ring) {
+		v4l2_warn(&ic_priv->sd, "%s: dma-buf ring was not freed\n",
+			  __func__);
+		imx_media_free_dma_buf_ring(priv->in_ring);
+	}
+
+	priv->in_ring = imx_media_alloc_dma_buf_ring(
+		priv->md, &priv->src_sd->entity,
+		&ic_priv->sd.entity,
+		in_size, IMX_MEDIA_MIN_RING_BUFS_PRPVF, true);
+	if (IS_ERR(priv->in_ring)) {
+		v4l2_err(&ic_priv->sd, "failed to alloc dma-buf ring\n");
+		ret = PTR_ERR(priv->in_ring);
+		priv->in_ring = NULL;
+		return ret;
+	}
+
+	for (i = 0; i < IMX_MEDIA_MIN_RING_BUFS_PRPVF; i++)
+		imx_media_dma_buf_queue(priv->in_ring, i);
+
+	priv->last_in_buf = NULL;
+	priv->curr_in_buf = NULL;
+
+	/* translate V4L2_FIELD_ALTERNATE to SEQ_TB or SEQ_BT */
+	priv->fieldtype = infmt->field;
+	if (infmt->field == V4L2_FIELD_ALTERNATE)
+		priv->fieldtype = (priv->std & V4L2_STD_525_60) ?
+			V4L2_FIELD_SEQ_TB : V4L2_FIELD_SEQ_BT;
+
+	/* init the vdi-in channels */
+	setup_vdi_channel(priv, priv->vdi_in_ch_p, 0, 0, false);
+	setup_vdi_channel(priv, priv->vdi_in_ch, 0, 0, false);
+	setup_vdi_channel(priv, priv->vdi_in_ch_n, 0, 0, false);
+
+	/* init the prpvf out channel */
+	setup_vdi_channel(priv, priv->prpvf_out_ch, 0, 0, true);
+
+	return 0;
+}
+
+static void prpvf_start_indirect(struct prpvf_priv *priv)
+{
+	/* enable the channels */
+	ipu_idmac_enable_channel(priv->prpvf_out_ch);
+	ipu_idmac_enable_channel(priv->vdi_in_ch_p);
+	ipu_idmac_enable_channel(priv->vdi_in_ch);
+	ipu_idmac_enable_channel(priv->vdi_in_ch_n);
+}
+
+static void prpvf_stop_indirect(struct prpvf_priv *priv)
+{
+	/* disable channels */
+	ipu_idmac_disable_channel(priv->prpvf_out_ch);
+	ipu_idmac_disable_channel(priv->vdi_in_ch_p);
+	ipu_idmac_disable_channel(priv->vdi_in_ch);
+	ipu_idmac_disable_channel(priv->vdi_in_ch_n);
+}
+
+static void prpvf_disable_indirect(struct prpvf_priv *priv)
+{
+}
+
+static struct prpvf_pipeline_ops direct_ops = {
+	.setup = prpvf_setup_direct,
+	.start = prpvf_start_direct,
+	.stop = prpvf_stop_direct,
+	.disable = prpvf_disable_direct,
+};
+
+static struct prpvf_pipeline_ops indirect_ops = {
+	.setup = prpvf_setup_indirect,
+	.start = prpvf_start_indirect,
+	.stop = prpvf_stop_indirect,
+	.disable = prpvf_disable_indirect,
+};
+
+static int prpvf_start(struct prpvf_priv *priv)
+{
+	struct imx_ic_priv *ic_priv = priv->ic_priv;
+	struct v4l2_mbus_framefmt *infmt, *outfmt;
+	const struct imx_media_pixfmt *outcc, *incc;
+	int ret;
+
+	if (!priv->sensor) {
+		v4l2_err(&ic_priv->sd, "no sensor attached\n");
+		return -EINVAL;
+	}
+
+	infmt = &priv->format_mbus[priv->input_pad];
+	outfmt = &priv->format_mbus[priv->output_pad];
+	incc = priv->cc[priv->input_pad];
+	outcc = priv->cc[priv->output_pad];
+
+	priv->ops = priv->csi_direct ? &direct_ops : &indirect_ops;
+
+	ret = prpvf_get_ipu_resources(priv);
+	if (ret)
+		return ret;
+
+	/* set IC to receive from VDIC */
+	ipu_set_ic_src_mux(priv->ipu, 0, true);
+
+	/* ask the sink for the buffer ring */
+	ret = v4l2_subdev_call(priv->sink_sd, core, ioctl,
+			       IMX_MEDIA_REQ_DMA_BUF_SINK_RING,
+			       &priv->out_ring);
+	if (ret)
+		goto out_put_ipu;
+
+	/* init EOF completion waitq */
+	init_completion(&priv->last_eof_comp);
+	priv->last_eof = false;
+
+	/* request EOF irq for prpvf out channel */
+	priv->out_eof_irq = ipu_idmac_channel_irq(priv->ipu,
+						  priv->prpvf_out_ch,
+						  IPU_IRQ_EOF);
+	ret = devm_request_irq(ic_priv->dev, priv->out_eof_irq,
+			       prpvf_out_eof_interrupt, 0,
+			       "imx-ic-prpvf-out-eof", priv);
+	if (ret) {
+		v4l2_err(&ic_priv->sd,
+			 "Error registering out eof irq: %d\n", ret);
+		goto out_put_ipu;
+	}
+
+	/* request NFB4EOF irq */
+	priv->nfb4eof_irq = ipu_idmac_channel_irq(priv->ipu,
+						  priv->prpvf_out_ch,
+						  IPU_IRQ_NFB4EOF);
+	ret = devm_request_irq(ic_priv->dev, priv->nfb4eof_irq,
+			       nfb4eof_interrupt, 0,
+			       "imx-ic-prpvf-nfb4eof", priv);
+	if (ret) {
+		v4l2_err(&ic_priv->sd,
+			 "Error registering NFB4EOF irq: %d\n", ret);
+		goto out_free_eof_irq;
+	}
+
+	ret = v4l2_subdev_call(priv->sensor->sd, video, g_std, &priv->std);
+	if (ret)
+		goto out_free_nfb4eof_irq;
+
+	/* init the VDIC */
+	ipu_vdi_setup(priv->vdi, infmt->code,
+		      infmt->width, infmt->height);
+	ipu_vdi_set_field_order(priv->vdi, priv->std, infmt->field);
+	ipu_vdi_set_motion(priv->vdi, priv->motion);
+
+	ret = ipu_ic_task_init(priv->ic_vf,
+			       infmt->width, infmt->height,
+			       outfmt->width, outfmt->height,
+			       incc->cs, outcc->cs);
+	if (ret) {
+		v4l2_err(&ic_priv->sd, "ipu_ic_task_init failed, %d\n", ret);
+		goto out_free_nfb4eof_irq;
+	}
+
+	ret = priv->ops->setup(priv);
+	if (ret)
+		goto out_free_nfb4eof_irq;
+
+	ipu_vdi_enable(priv->vdi);
+	ipu_ic_enable(priv->ic_vf);
+
+	priv->ops->start(priv);
+
+	/* enable the IC VF task */
+	ipu_ic_task_enable(priv->ic_vf);
+
+	/* start the EOF timeout timer */
+	mod_timer(&priv->eof_timeout_timer,
+		  jiffies + msecs_to_jiffies(IMX_MEDIA_EOF_TIMEOUT));
+
+	return 0;
+
+out_free_nfb4eof_irq:
+	devm_free_irq(ic_priv->dev, priv->nfb4eof_irq, priv);
+out_free_eof_irq:
+	devm_free_irq(ic_priv->dev, priv->out_eof_irq, priv);
+out_put_ipu:
+	prpvf_put_ipu_resources(priv);
+	return ret;
+}
+
+static void prpvf_stop(struct prpvf_priv *priv)
+{
+	struct imx_ic_priv *ic_priv = priv->ic_priv;
+	unsigned long flags;
+	int ret;
+
+	/* mark next EOF interrupt as the last before stream off */
+	spin_lock_irqsave(&priv->irqlock, flags);
+	priv->last_eof = true;
+	spin_unlock_irqrestore(&priv->irqlock, flags);
+
+	/*
+	 * and then wait for interrupt handler to mark completion.
+	 */
+	ret = wait_for_completion_timeout(
+		&priv->last_eof_comp, msecs_to_jiffies(IMX_MEDIA_EOF_TIMEOUT));
+	if (ret == 0)
+		v4l2_warn(&ic_priv->sd, "wait last EOF timeout\n");
+
+	ipu_ic_task_disable(priv->ic_vf);
+	priv->ops->stop(priv);
+	ipu_ic_disable(priv->ic_vf);
+	ipu_vdi_disable(priv->vdi);
+	priv->ops->disable(priv);
+
+	devm_free_irq(ic_priv->dev, priv->nfb4eof_irq, priv);
+	devm_free_irq(ic_priv->dev, priv->out_eof_irq, priv);
+	prpvf_put_ipu_resources(priv);
+
+	/* cancel the EOF timeout timer */
+	del_timer_sync(&priv->eof_timeout_timer);
+
+	priv->out_ring = NULL;
+
+	/* inform sink that the buffer ring can now be freed */
+	v4l2_subdev_call(priv->sink_sd, core, ioctl,
+			 IMX_MEDIA_REL_DMA_BUF_SINK_RING, 0);
+}
+
+static int prpvf_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct prpvf_priv *priv = container_of(ctrl->handler,
+					       struct prpvf_priv, ctrl_hdlr);
+	struct imx_ic_priv *ic_priv = priv->ic_priv;
+	enum ipu_motion_sel motion;
+
+	switch (ctrl->id) {
+	case V4L2_CID_IMX_MOTION:
+		motion = ctrl->val;
+		if (motion != priv->motion) {
+			/* can't change motion control mid-streaming */
+			if (priv->stream_on)
+				return -EBUSY;
+			priv->motion = motion;
+		}
+		break;
+	default:
+		v4l2_err(&ic_priv->sd, "Invalid control\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops prpvf_ctrl_ops = {
+	.s_ctrl = prpvf_s_ctrl,
+};
+
+static const struct v4l2_ctrl_config prpvf_custom_ctrl[] = {
+	{
+		.ops = &prpvf_ctrl_ops,
+		.id = V4L2_CID_IMX_MOTION,
+		.name = "Motion Compensation",
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.def = MOTION_NONE,
+		.min = MOTION_NONE,
+		.max = HIGH_MOTION,
+		.step = 1,
+	},
+};
+
+#define PRPVF_NUM_CONTROLS ARRAY_SIZE(prpvf_custom_ctrl)
+
+static int prpvf_init_controls(struct prpvf_priv *priv)
+{
+	struct imx_ic_priv *ic_priv = priv->ic_priv;
+	struct v4l2_ctrl_handler *hdlr = &priv->ctrl_hdlr;
+	const struct v4l2_ctrl_config *c;
+	int i, ret;
+
+	v4l2_ctrl_handler_free(hdlr);
+	v4l2_ctrl_handler_init(hdlr, PRPVF_NUM_CONTROLS);
+
+	for (i = 0; i < PRPVF_NUM_CONTROLS; i++) {
+		c = &prpvf_custom_ctrl[i];
+		v4l2_ctrl_new_custom(hdlr, c, NULL);
+	}
+
+	ic_priv->sd.ctrl_handler = hdlr;
+
+	if (hdlr->error) {
+		ret = hdlr->error;
+		goto out_free;
+	}
+
+	v4l2_ctrl_handler_setup(hdlr);
+	return 0;
+
+out_free:
+	v4l2_ctrl_handler_free(hdlr);
+	return ret;
+}
+
+static int prpvf_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct prpvf_priv *priv = sd_to_priv(sd);
+	int ret = 0;
+
+	if (!priv->src_sd || !priv->sink_sd)
+		return -EPIPE;
+
+	v4l2_info(sd, "stream %s\n", enable ? "ON" : "OFF");
+
+	if (enable && !priv->stream_on)
+		ret = prpvf_start(priv);
+	else if (!enable && priv->stream_on)
+		prpvf_stop(priv);
+
+	if (!ret)
+		priv->stream_on = enable;
+	return ret;
+}
+
+static int prpvf_enum_mbus_code(struct v4l2_subdev *sd,
+				struct v4l2_subdev_pad_config *cfg,
+				struct v4l2_subdev_mbus_code_enum *code)
+{
+	struct prpvf_priv *priv = sd_to_priv(sd);
+	bool allow_planar, allow_rgb;
+
+	if (code->pad >= PRPVF_NUM_PADS)
+		return -EINVAL;
+
+	allow_planar = (code->pad == priv->output_pad);
+	allow_rgb = allow_planar;
+
+	return imx_media_enum_format(&code->code, code->index,
+				     allow_rgb, allow_planar);
+}
+
+static int prpvf_get_fmt(struct v4l2_subdev *sd,
+			 struct v4l2_subdev_pad_config *cfg,
+			 struct v4l2_subdev_format *sdformat)
+{
+	struct prpvf_priv *priv = sd_to_priv(sd);
+
+	if (sdformat->pad >= PRPVF_NUM_PADS)
+		return -EINVAL;
+
+	sdformat->format = priv->format_mbus[sdformat->pad];
+
+	return 0;
+}
+
+static int prpvf_set_fmt(struct v4l2_subdev *sd,
+			 struct v4l2_subdev_pad_config *cfg,
+			 struct v4l2_subdev_format *sdformat)
+{
+	struct prpvf_priv *priv = sd_to_priv(sd);
+	struct v4l2_mbus_framefmt *infmt, *outfmt;
+	const struct imx_media_pixfmt *cc;
+	bool allow_planar, allow_rgb;
+	u32 code;
+
+	if (sdformat->pad >= PRPVF_NUM_PADS)
+		return -EINVAL;
+
+	if (priv->stream_on)
+		return -EBUSY;
+
+	infmt = &priv->format_mbus[priv->input_pad];
+	outfmt = &priv->format_mbus[priv->output_pad];
+	allow_planar = (sdformat->pad == priv->output_pad);
+	allow_rgb = allow_planar;
+
+	cc = imx_media_find_format(0, sdformat->format.code,
+				   allow_rgb, allow_planar);
+	if (!cc) {
+		imx_media_enum_format(&code, 0, false, false);
+		cc = imx_media_find_format(0, code, false, false);
+		sdformat->format.code = cc->codes[0];
+	}
+
+	if (sdformat->pad == priv->output_pad) {
+		sdformat->format.width = min_t(__u32,
+					       sdformat->format.width,
+					       MAX_W_IC);
+		sdformat->format.height = min_t(__u32,
+						sdformat->format.height,
+						MAX_H_IC);
+		/* IC resizer cannot downsize more than 4:1 */
+		sdformat->format.width = max_t(__u32, sdformat->format.width,
+					       infmt->width / 4);
+		sdformat->format.height = max_t(__u32, sdformat->format.height,
+						infmt->height / 4);
+
+		/* output is always progressive! */
+		sdformat->format.field = V4L2_FIELD_NONE;
+	} else {
+		sdformat->format.width = min_t(__u32,
+					       sdformat->format.width,
+					       MAX_W_VDIC);
+		sdformat->format.height = min_t(__u32,
+						sdformat->format.height,
+						MAX_H_VDIC);
+
+		/* input must be interlaced! Choose alternate if not */
+		if (!V4L2_FIELD_HAS_BOTH(sdformat->format.field))
+			sdformat->format.field = V4L2_FIELD_ALTERNATE;
+	}
+
+	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY) {
+		cfg->try_fmt = sdformat->format;
+	} else {
+		priv->format_mbus[sdformat->pad] = sdformat->format;
+		priv->cc[sdformat->pad] = cc;
+	}
+
+	return 0;
+}
+
+static int prpvf_link_setup(struct media_entity *entity,
+			    const struct media_pad *local,
+			    const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct imx_ic_priv *ic_priv = v4l2_get_subdevdata(sd);
+	struct prpvf_priv *priv = ic_priv->task_priv;
+	struct v4l2_subdev *remote_sd;
+	int ret;
+
+	dev_dbg(ic_priv->dev, "link setup %s -> %s", remote->entity->name,
+		local->entity->name);
+
+	remote_sd = media_entity_to_v4l2_subdev(remote->entity);
+
+	if (local->flags & MEDIA_PAD_FL_SOURCE) {
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (priv->sink_sd)
+				return -EBUSY;
+			priv->sink_sd = remote_sd;
+		} else {
+			priv->sink_sd = NULL;
+		}
+
+		return 0;
+	}
+
+	/* this is sink pad */
+	if (flags & MEDIA_LNK_FL_ENABLED) {
+		if (priv->src_sd)
+			return -EBUSY;
+		priv->src_sd = remote_sd;
+
+		priv->csi_direct = ((priv->src_sd->grp_id &
+				     IMX_MEDIA_GRP_ID_CSI) != 0);
+
+		ret = prpvf_init_controls(priv);
+		if (ret)
+			return ret;
+	} else {
+		v4l2_ctrl_handler_free(&priv->ctrl_hdlr);
+		priv->src_sd = NULL;
+	}
+
+	return 0;
+}
+
+static int prpvf_link_validate(struct v4l2_subdev *sd,
+			       struct media_link *link,
+			       struct v4l2_subdev_format *source_fmt,
+			       struct v4l2_subdev_format *sink_fmt)
+{
+	struct imx_ic_priv *ic_priv = v4l2_get_subdevdata(sd);
+	struct prpvf_priv *priv = ic_priv->task_priv;
+	struct v4l2_mbus_config sensor_mbus_cfg;
+	struct imx_media_subdev *csi;
+	int ret;
+
+	ret = v4l2_subdev_link_validate_default(sd, link,
+						source_fmt, sink_fmt);
+	if (ret)
+		return ret;
+
+	priv->sensor = __imx_media_find_sensor(priv->md, &ic_priv->sd.entity);
+	if (IS_ERR(priv->sensor)) {
+		v4l2_err(&ic_priv->sd, "no sensor attached\n");
+		ret = PTR_ERR(priv->sensor);
+		priv->sensor = NULL;
+		return ret;
+	}
+
+	if (!priv->csi_direct) {
+		csi = imx_media_find_pipeline_subdev(
+			priv->md, &ic_priv->sd.entity, IMX_MEDIA_GRP_ID_CSI);
+		if (IS_ERR(csi)) {
+			v4l2_err(&ic_priv->sd, "no CSI attached\n");
+			ret = PTR_ERR(csi);
+			return ret;
+		}
+
+		priv->csi_sd = csi->sd;
+		return 0;
+	}
+
+	priv->csi_sd = priv->src_sd;
+
+	if (priv->motion != HIGH_MOTION) {
+		v4l2_err(&ic_priv->sd,
+			 "direct CSI pipeline requires HIGH_MOTION\n");
+		return -EINVAL;
+	}
+
+	ret = v4l2_subdev_call(priv->sensor->sd, video, g_mbus_config,
+			       &sensor_mbus_cfg);
+	if (ret)
+		return ret;
+
+	if (sensor_mbus_cfg.type == V4L2_MBUS_CSI2) {
+		int vc_num = 0;
+		/* see NOTE in imx-csi.c */
+#if 0
+		vc_num = imx_media_find_mipi_csi2_channel(
+			priv->md, &ic_priv->sd.entity);
+		if (vc_num < 0)
+			return vc_num;
+#endif
+		/* only virtual channel 0 can be sent to IC */
+		if (vc_num != 0)
+			return -EINVAL;
+	} else {
+		/* only 8-bit pixels can be sent to IC for parallel busses */
+		if (priv->sensor->sensor_ep.bus.parallel.bus_width >= 16)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * retrieve our pads parsed from the OF graph by the media device
+ */
+static int prpvf_registered(struct v4l2_subdev *sd)
+{
+	struct prpvf_priv *priv = sd_to_priv(sd);
+	struct imx_media_subdev *imxsd;
+	struct imx_media_pad *pad;
+	int i, ret;
+
+	/* get media device */
+	priv->md = dev_get_drvdata(sd->v4l2_dev->dev);
+
+	imxsd = imx_media_find_subdev_by_sd(priv->md, sd);
+	if (IS_ERR(imxsd))
+		return PTR_ERR(imxsd);
+
+	if (imxsd->num_sink_pads != 1 || imxsd->num_src_pads != 1)
+		return -EINVAL;
+
+	for (i = 0; i < PRPVF_NUM_PADS; i++) {
+		pad = &imxsd->pad[i];
+		priv->pad[i] = pad->pad;
+		if (priv->pad[i].flags & MEDIA_PAD_FL_SINK)
+			priv->input_pad = i;
+		else
+			priv->output_pad = i;
+
+		/* set a default mbus format  */
+		ret = imx_media_init_mbus_fmt(&priv->format_mbus[i],
+					      640, 480, 0, V4L2_FIELD_NONE,
+					      &priv->cc[i]);
+		if (ret)
+			return ret;
+	}
+
+	return media_entity_pads_init(&sd->entity, PRPVF_NUM_PADS, priv->pad);
+}
+
+static struct v4l2_subdev_pad_ops prpvf_pad_ops = {
+	.enum_mbus_code = prpvf_enum_mbus_code,
+	.get_fmt = prpvf_get_fmt,
+	.set_fmt = prpvf_set_fmt,
+	.link_validate = prpvf_link_validate,
+};
+
+static struct v4l2_subdev_video_ops prpvf_video_ops = {
+	.s_stream = prpvf_s_stream,
+};
+
+static struct v4l2_subdev_core_ops prpvf_core_ops = {
+	.ioctl = prpvf_ioctl,
+};
+
+static struct media_entity_operations prpvf_entity_ops = {
+	.link_setup = prpvf_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
+};
+
+static struct v4l2_subdev_ops prpvf_subdev_ops = {
+	.video = &prpvf_video_ops,
+	.pad = &prpvf_pad_ops,
+	.core = &prpvf_core_ops,
+};
+
+static struct v4l2_subdev_internal_ops prpvf_internal_ops = {
+	.registered = prpvf_registered,
+};
+
+static int prpvf_init(struct imx_ic_priv *ic_priv)
+{
+	struct prpvf_priv *priv;
+
+	priv = devm_kzalloc(ic_priv->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	ic_priv->task_priv = priv;
+	priv->ic_priv = ic_priv;
+
+	spin_lock_init(&priv->irqlock);
+	init_timer(&priv->eof_timeout_timer);
+	priv->eof_timeout_timer.data = (unsigned long)priv;
+	priv->eof_timeout_timer.function = prpvf_eof_timeout;
+
+	return 0;
+}
+
+static void prpvf_remove(struct imx_ic_priv *ic_priv)
+{
+	struct prpvf_priv *priv = ic_priv->task_priv;
+
+	v4l2_ctrl_handler_free(&priv->ctrl_hdlr);
+}
+
+struct imx_ic_ops imx_ic_prpvf_ops = {
+	.subdev_ops = &prpvf_subdev_ops,
+	.internal_ops = &prpvf_internal_ops,
+	.entity_ops = &prpvf_entity_ops,
+	.init = prpvf_init,
+	.remove = prpvf_remove,
+};
diff --git a/drivers/staging/media/imx/imx-ic.h b/drivers/staging/media/imx/imx-ic.h
new file mode 100644
index 0000000..9aed5f5
--- /dev/null
+++ b/drivers/staging/media/imx/imx-ic.h
@@ -0,0 +1,36 @@
+/*
+ * V4L2 Image Converter Subdev for Freescale i.MX5/6 SOC
+ *
+ * Copyright (c) 2016 Mentor Graphics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef _IMX_IC_H
+#define _IMX_IC_H
+
+struct imx_ic_priv {
+	struct device *dev;
+	struct v4l2_subdev sd;
+	int    ipu_id;
+	int    task_id;
+	void   *task_priv;
+};
+
+struct imx_ic_ops {
+	struct v4l2_subdev_ops *subdev_ops;
+	struct v4l2_subdev_internal_ops *internal_ops;
+	struct media_entity_operations *entity_ops;
+
+	int (*init)(struct imx_ic_priv *ic_priv);
+	void (*remove)(struct imx_ic_priv *ic_priv);
+};
+
+extern struct imx_ic_ops imx_ic_prpenc_ops;
+extern struct imx_ic_ops imx_ic_prpvf_ops;
+extern struct imx_ic_ops imx_ic_pp_ops;
+
+#endif
+
-- 
2.7.4

