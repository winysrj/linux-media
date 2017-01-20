Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:59411 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752393AbdATO3q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jan 2017 09:29:46 -0500
Subject: Re: [PATCH v3 19/24] media: imx: Add IC subdev drivers
To: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-20-git-send-email-steve_longerbeam@mentor.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <07f4bc9e-22ef-a925-f4ee-c14df65e4f0d@xs4all.nl>
Date: Fri, 20 Jan 2017 15:29:39 +0100
MIME-Version: 1.0
In-Reply-To: <1483755102-24785-20-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/07/2017 03:11 AM, Steve Longerbeam wrote:
> This is a set of three media entity subdevice drivers for the i.MX
> Image Converter. The i.MX IC module contains three independent
> "tasks":
> 
> - Pre-processing Encode task: video frames are routed directly from
>   the CSI and can be scaled, color-space converted, and rotated.
>   Scaled output is limited to 1024x1024 resolution. Output frames
>   are routed to the camera interface entities (camif).
> 
> - Pre-processing Viewfinder task: this task can perform the same
>   conversions as the pre-process encode task, but in addition can
>   be used for hardware motion compensated deinterlacing. Frames can
>   come either directly from the CSI or from the SMFC entities (memory
>   buffers via IDMAC channels). Scaled output is limited to 1024x1024
>   resolution. Output frames can be routed to various sinks including
>   the post-processing task entities.
> 
> - Post-processing task: same conversions as pre-process encode. However
>   this entity sends frames to the i.MX IPU image converter which supports
>   image tiling, which allows scaled output up to 4096x4096 resolution.
>   Output frames can be routed to the camera interfaces.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/staging/media/imx/Makefile        |    2 +
>  drivers/staging/media/imx/imx-ic-common.c |  109 +++
>  drivers/staging/media/imx/imx-ic-pp.c     |  636 ++++++++++++++++
>  drivers/staging/media/imx/imx-ic-prpenc.c | 1033 +++++++++++++++++++++++++
>  drivers/staging/media/imx/imx-ic-prpvf.c  | 1179 +++++++++++++++++++++++++++++
>  drivers/staging/media/imx/imx-ic.h        |   38 +
>  6 files changed, 2997 insertions(+)
>  create mode 100644 drivers/staging/media/imx/imx-ic-common.c
>  create mode 100644 drivers/staging/media/imx/imx-ic-pp.c
>  create mode 100644 drivers/staging/media/imx/imx-ic-prpenc.c
>  create mode 100644 drivers/staging/media/imx/imx-ic-prpvf.c
>  create mode 100644 drivers/staging/media/imx/imx-ic.h
> 
> diff --git a/drivers/staging/media/imx/Makefile b/drivers/staging/media/imx/Makefile
> index 3559d7b..d2a962c 100644
> --- a/drivers/staging/media/imx/Makefile
> +++ b/drivers/staging/media/imx/Makefile
> @@ -1,8 +1,10 @@
>  imx-media-objs := imx-media-dev.o imx-media-fim.o imx-media-internal-sd.o \
>  	imx-media-of.o
> +imx-ic-objs := imx-ic-common.o imx-ic-prpenc.o imx-ic-prpvf.o imx-ic-pp.o
>  
>  obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media.o
>  obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media-common.o
> +obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-ic.o
>  
>  obj-$(CONFIG_VIDEO_IMX_CAMERA) += imx-csi.o
>  obj-$(CONFIG_VIDEO_IMX_CAMERA) += imx-smfc.o
> diff --git a/drivers/staging/media/imx/imx-ic-common.c b/drivers/staging/media/imx/imx-ic-common.c
> new file mode 100644
> index 0000000..45706ca
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx-ic-common.c
> @@ -0,0 +1,109 @@
> +/*
> + * V4L2 Image Converter Subdev for Freescale i.MX5/6 SOC
> + *
> + * Copyright (c) 2014-2016 Mentor Graphics Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-subdev.h>
> +#include "imx-media.h"
> +#include "imx-ic.h"
> +
> +static struct imx_ic_ops *ic_ops[IC_NUM_TASKS] = {
> +	[IC_TASK_ENCODER]        = &imx_ic_prpenc_ops,
> +	[IC_TASK_VIEWFINDER]     = &imx_ic_prpvf_ops,
> +	[IC_TASK_POST_PROCESSOR] = &imx_ic_pp_ops,
> +};
> +
> +static int imx_ic_probe(struct platform_device *pdev)
> +{
> +	struct imx_media_internal_sd_platformdata *pdata;
> +	struct imx_ic_priv *priv;
> +	int ret;
> +
> +	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, &priv->sd);
> +	priv->dev = &pdev->dev;
> +
> +	/* get our ipu_id, grp_id and IC task id */
> +	pdata = priv->dev->platform_data;
> +	priv->ipu_id = pdata->ipu_id;
> +	switch (pdata->grp_id) {
> +	case IMX_MEDIA_GRP_ID_IC_PRPENC:
> +		priv->task_id = IC_TASK_ENCODER;
> +		break;
> +	case IMX_MEDIA_GRP_ID_IC_PRPVF:
> +		priv->task_id = IC_TASK_VIEWFINDER;
> +		break;
> +	case IMX_MEDIA_GRP_ID_IC_PP0...IMX_MEDIA_GRP_ID_IC_PP3:
> +		priv->task_id = IC_TASK_POST_PROCESSOR;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	v4l2_subdev_init(&priv->sd, ic_ops[priv->task_id]->subdev_ops);
> +	v4l2_set_subdevdata(&priv->sd, priv);
> +	priv->sd.internal_ops = ic_ops[priv->task_id]->internal_ops;
> +	priv->sd.entity.ops = ic_ops[priv->task_id]->entity_ops;
> +	priv->sd.entity.function = MEDIA_ENT_F_PROC_VIDEO_SCALER;
> +	priv->sd.dev = &pdev->dev;
> +	priv->sd.owner = THIS_MODULE;
> +	priv->sd.flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
> +	priv->sd.grp_id = pdata->grp_id;
> +	strncpy(priv->sd.name, pdata->sd_name, sizeof(priv->sd.name));
> +
> +	ret = ic_ops[priv->task_id]->init(priv);
> +	if (ret)
> +		return ret;
> +
> +	ret = v4l2_async_register_subdev(&priv->sd);
> +	if (ret)
> +		ic_ops[priv->task_id]->remove(priv);
> +
> +	return ret;
> +}
> +
> +static int imx_ic_remove(struct platform_device *pdev)
> +{
> +	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
> +	struct imx_ic_priv *priv = container_of(sd, struct imx_ic_priv, sd);
> +
> +	ic_ops[priv->task_id]->remove(priv);
> +
> +	v4l2_async_unregister_subdev(&priv->sd);
> +	media_entity_cleanup(&priv->sd.entity);
> +	v4l2_device_unregister_subdev(sd);
> +
> +	return 0;
> +}
> +
> +static const struct platform_device_id imx_ic_ids[] = {
> +	{ .name = "imx-ipuv3-ic" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(platform, imx_ic_ids);
> +
> +static struct platform_driver imx_ic_driver = {
> +	.probe = imx_ic_probe,
> +	.remove = imx_ic_remove,
> +	.id_table = imx_ic_ids,
> +	.driver = {
> +		.name = "imx-ipuv3-ic",
> +	},
> +};
> +module_platform_driver(imx_ic_driver);
> +
> +MODULE_DESCRIPTION("i.MX IC subdev driver");
> +MODULE_AUTHOR("Steve Longerbeam <steve_longerbeam@mentor.com>");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:imx-ipuv3-ic");
> diff --git a/drivers/staging/media/imx/imx-ic-pp.c b/drivers/staging/media/imx/imx-ic-pp.c
> new file mode 100644
> index 0000000..1f75616
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx-ic-pp.c
> @@ -0,0 +1,636 @@
> +/*
> + * V4L2 IC Post-Processor Subdev for Freescale i.MX5/6 SOC
> + *
> + * Copyright (c) 2014-2016 Mentor Graphics Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#include <linux/delay.h>
> +#include <linux/fs.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/pinctrl/consumer.h>
> +#include <linux/platform_device.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +#include <linux/timer.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-of.h>
> +#include <media/v4l2-subdev.h>
> +#include <media/videobuf2-dma-contig.h>
> +#include <video/imx-ipu-image-convert.h>
> +#include <media/imx.h>
> +#include "imx-media.h"
> +#include "imx-ic.h"
> +
> +#define PP_NUM_PADS 2
> +
> +struct pp_priv {
> +	struct imx_media_dev *md;
> +	struct imx_ic_priv *ic_priv;
> +	int pp_id;
> +
> +	struct ipu_soc *ipu;
> +	struct ipu_image_convert_ctx *ic_ctx;
> +
> +	struct media_pad pad[PP_NUM_PADS];
> +	int input_pad;
> +	int output_pad;
> +
> +	/* our dma buffer sink ring */
> +	struct imx_media_dma_buf_ring *in_ring;
> +	/* the dma buffer ring we send to sink */
> +	struct imx_media_dma_buf_ring *out_ring;
> +	struct ipu_image_convert_run *out_run;
> +
> +	struct imx_media_dma_buf *inbuf; /* last input buffer */
> +
> +	bool stream_on;    /* streaming is on */
> +	bool stop;         /* streaming is stopping */
> +	spinlock_t irqlock;
> +
> +	struct v4l2_subdev *src_sd;
> +	struct v4l2_subdev *sink_sd;
> +
> +	struct v4l2_mbus_framefmt format_mbus[PP_NUM_PADS];
> +	const struct imx_media_pixfmt *cc[PP_NUM_PADS];
> +
> +	/* motion select control */
> +	struct v4l2_ctrl_handler ctrl_hdlr;
> +	int  rotation; /* degrees */
> +	bool hflip;
> +	bool vflip;
> +
> +	/* derived from rotation, hflip, vflip controls */
> +	enum ipu_rotate_mode rot_mode;
> +};
> +
> +static inline struct pp_priv *sd_to_priv(struct v4l2_subdev *sd)
> +{
> +	struct imx_ic_priv *ic_priv = v4l2_get_subdevdata(sd);
> +
> +	return ic_priv->task_priv;
> +}
> +
> +static void pp_convert_complete(struct ipu_image_convert_run *run,
> +				void *data)
> +{
> +	struct pp_priv *priv = data;
> +	struct imx_media_dma_buf *done;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&priv->irqlock, flags);
> +
> +	done = imx_media_dma_buf_get_active(priv->out_ring);
> +	/* give the completed buffer to the sink */
> +	if (!WARN_ON(!done))
> +		imx_media_dma_buf_done(done, run->status ?
> +				       IMX_MEDIA_BUF_STATUS_ERROR :
> +				       IMX_MEDIA_BUF_STATUS_DONE);
> +
> +	/* we're done with the inbuf, queue it back */
> +	imx_media_dma_buf_queue(priv->in_ring, priv->inbuf->index);
> +
> +	spin_unlock_irqrestore(&priv->irqlock, flags);
> +}
> +
> +static void pp_queue_conversion(struct pp_priv *priv,
> +				struct imx_media_dma_buf *inbuf)
> +{
> +	struct ipu_image_convert_run *run;
> +	struct imx_media_dma_buf *outbuf;
> +
> +	/* get next queued buffer and make it active */
> +	outbuf = imx_media_dma_buf_get_next_queued(priv->out_ring);
> +	imx_media_dma_buf_set_active(outbuf);
> +	priv->inbuf = inbuf;
> +
> +	run = &priv->out_run[outbuf->index];
> +	run->ctx = priv->ic_ctx;
> +	run->in_phys = inbuf->phys;
> +	run->out_phys = outbuf->phys;
> +	ipu_image_convert_queue(run);
> +}
> +
> +static long pp_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
> +{
> +	struct pp_priv *priv = sd_to_priv(sd);
> +	struct imx_media_dma_buf_ring **ring;
> +	struct imx_media_dma_buf *buf;
> +	unsigned long flags;
> +
> +	switch (cmd) {
> +	case IMX_MEDIA_REQ_DMA_BUF_SINK_RING:
> +		/* src asks for a buffer ring */
> +		if (!priv->in_ring)
> +			return -EINVAL;
> +		ring = (struct imx_media_dma_buf_ring **)arg;
> +		*ring = priv->in_ring;
> +		break;
> +	case IMX_MEDIA_NEW_DMA_BUF:
> +		/* src hands us a new buffer */
> +		spin_lock_irqsave(&priv->irqlock, flags);
> +		if (!priv->stop &&
> +		    !imx_media_dma_buf_get_active(priv->out_ring)) {
> +			buf = imx_media_dma_buf_dequeue(priv->in_ring);
> +			if (buf)
> +				pp_queue_conversion(priv, buf);
> +		}
> +		spin_unlock_irqrestore(&priv->irqlock, flags);
> +		break;
> +	case IMX_MEDIA_REL_DMA_BUF_SINK_RING:
> +		/* src indicates sink buffer ring can be freed */
> +		if (!priv->in_ring)
> +			return 0;
> +		v4l2_info(sd, "%s: freeing sink ring\n", __func__);
> +		imx_media_free_dma_buf_ring(priv->in_ring);
> +		priv->in_ring = NULL;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int pp_start(struct pp_priv *priv)
> +{
> +	struct imx_ic_priv *ic_priv = priv->ic_priv;
> +	struct ipu_image image_in, image_out;
> +	const struct imx_media_pixfmt *incc;
> +	struct v4l2_mbus_framefmt *infmt;
> +	int i, in_size, ret;
> +
> +	/* ask the sink for the buffer ring */
> +	ret = v4l2_subdev_call(priv->sink_sd, core, ioctl,
> +			       IMX_MEDIA_REQ_DMA_BUF_SINK_RING,
> +			       &priv->out_ring);
> +	if (ret)
> +		return ret;
> +
> +	imx_media_mbus_fmt_to_ipu_image(&image_in,
> +					&priv->format_mbus[priv->input_pad]);
> +	imx_media_mbus_fmt_to_ipu_image(&image_out,
> +					&priv->format_mbus[priv->output_pad]);
> +
> +	priv->ipu = priv->md->ipu[ic_priv->ipu_id];
> +	priv->ic_ctx = ipu_image_convert_prepare(priv->ipu,
> +						 IC_TASK_POST_PROCESSOR,
> +						 &image_in, &image_out,
> +						 priv->rot_mode,
> +						 pp_convert_complete, priv);
> +	if (IS_ERR(priv->ic_ctx))
> +		return PTR_ERR(priv->ic_ctx);
> +
> +	infmt = &priv->format_mbus[priv->input_pad];
> +	incc = priv->cc[priv->input_pad];
> +	in_size = (infmt->width * incc->bpp * infmt->height) >> 3;
> +
> +	if (priv->in_ring) {
> +		v4l2_warn(&ic_priv->sd, "%s: dma-buf ring was not freed\n",
> +			  __func__);
> +		imx_media_free_dma_buf_ring(priv->in_ring);
> +	}
> +
> +	priv->in_ring = imx_media_alloc_dma_buf_ring(priv->md,
> +						     &priv->src_sd->entity,
> +						     &ic_priv->sd.entity,
> +						     in_size,
> +						     IMX_MEDIA_MIN_RING_BUFS,
> +						     true);
> +	if (IS_ERR(priv->in_ring)) {
> +		v4l2_err(&ic_priv->sd,
> +			 "failed to alloc dma-buf ring\n");
> +		ret = PTR_ERR(priv->in_ring);
> +		priv->in_ring = NULL;
> +		goto out_unprep;
> +	}
> +
> +	for (i = 0; i < IMX_MEDIA_MIN_RING_BUFS; i++)
> +		imx_media_dma_buf_queue(priv->in_ring, i);
> +
> +	priv->out_run = kzalloc(IMX_MEDIA_MAX_RING_BUFS *
> +				sizeof(*priv->out_run), GFP_KERNEL);
> +	if (!priv->out_run) {
> +		v4l2_err(&ic_priv->sd, "failed to alloc src ring runs\n");
> +		ret = -ENOMEM;
> +		goto out_free_ring;
> +	}
> +
> +	priv->stop = false;
> +
> +	return 0;
> +
> +out_free_ring:
> +	imx_media_free_dma_buf_ring(priv->in_ring);
> +	priv->in_ring = NULL;
> +out_unprep:
> +	ipu_image_convert_unprepare(priv->ic_ctx);
> +	return ret;
> +}
> +
> +static void pp_stop(struct pp_priv *priv)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&priv->irqlock, flags);
> +	priv->stop = true;
> +	spin_unlock_irqrestore(&priv->irqlock, flags);
> +
> +	ipu_image_convert_unprepare(priv->ic_ctx);
> +	kfree(priv->out_run);
> +
> +	priv->out_ring = NULL;
> +
> +	/* inform sink that its sink buffer ring can now be freed */
> +	v4l2_subdev_call(priv->sink_sd, core, ioctl,
> +			 IMX_MEDIA_REL_DMA_BUF_SINK_RING, 0);
> +}
> +
> +static int pp_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct pp_priv *priv = sd_to_priv(sd);
> +	int ret = 0;
> +
> +	if (!priv->src_sd || !priv->sink_sd)
> +		return -EPIPE;
> +
> +	v4l2_info(sd, "stream %s\n", enable ? "ON" : "OFF");
> +
> +	if (enable && !priv->stream_on)
> +		ret = pp_start(priv);
> +	else if (!enable && priv->stream_on)
> +		pp_stop(priv);
> +
> +	if (!ret)
> +		priv->stream_on = enable;
> +	return ret;
> +}
> +
> +static int pp_enum_mbus_code(struct v4l2_subdev *sd,
> +			     struct v4l2_subdev_pad_config *cfg,
> +			     struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	const struct imx_media_pixfmt *cc;
> +	u32 fourcc;
> +	int ret;
> +
> +	if (code->pad >= PP_NUM_PADS)
> +		return -EINVAL;
> +
> +	ret = ipu_image_convert_enum_format(code->index, &fourcc);
> +	if (ret)
> +		return ret;
> +
> +	/* convert returned fourcc to mbus code */
> +	cc = imx_media_find_format(fourcc, 0, true, true);
> +	if (WARN_ON(!cc))
> +		return -EINVAL;
> +
> +	code->code = cc->codes[0];
> +	return 0;
> +}
> +
> +static int pp_get_fmt(struct v4l2_subdev *sd,
> +		      struct v4l2_subdev_pad_config *cfg,
> +		      struct v4l2_subdev_format *sdformat)
> +{
> +	struct pp_priv *priv = sd_to_priv(sd);
> +
> +	if (sdformat->pad >= PP_NUM_PADS)
> +		return -EINVAL;
> +
> +	sdformat->format = priv->format_mbus[sdformat->pad];
> +
> +	return 0;
> +}
> +
> +static int pp_set_fmt(struct v4l2_subdev *sd,
> +		      struct v4l2_subdev_pad_config *cfg,
> +		      struct v4l2_subdev_format *sdformat)
> +{
> +	struct pp_priv *priv = sd_to_priv(sd);
> +	struct v4l2_mbus_framefmt *infmt, *outfmt;
> +	const struct imx_media_pixfmt *cc;
> +	struct ipu_image test_in, test_out;
> +	u32 code;
> +
> +	if (sdformat->pad >= PP_NUM_PADS)
> +		return -EINVAL;
> +
> +	if (priv->stream_on)
> +		return -EBUSY;
> +
> +	infmt = &priv->format_mbus[priv->input_pad];
> +	outfmt = &priv->format_mbus[priv->output_pad];
> +
> +	cc = imx_media_find_format(0, sdformat->format.code, true, true);
> +	if (!cc) {
> +		imx_media_enum_format(&code, 0, true, true);
> +		cc = imx_media_find_format(0, code, true, true);
> +		sdformat->format.code = cc->codes[0];
> +	}
> +
> +	if (sdformat->pad == priv->output_pad) {
> +		imx_media_mbus_fmt_to_ipu_image(&test_out, &sdformat->format);
> +		imx_media_mbus_fmt_to_ipu_image(&test_in, infmt);
> +		ipu_image_convert_adjust(&test_in, &test_out, priv->rot_mode);
> +		imx_media_ipu_image_to_mbus_fmt(&sdformat->format, &test_out);
> +	} else {
> +		imx_media_mbus_fmt_to_ipu_image(&test_in, &sdformat->format);
> +		imx_media_mbus_fmt_to_ipu_image(&test_out, outfmt);
> +		ipu_image_convert_adjust(&test_in, &test_out, priv->rot_mode);
> +		imx_media_ipu_image_to_mbus_fmt(&sdformat->format, &test_in);
> +	}
> +
> +	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		cfg->try_fmt = sdformat->format;
> +	} else {
> +		if (sdformat->pad == priv->output_pad) {
> +			*outfmt = sdformat->format;
> +			imx_media_ipu_image_to_mbus_fmt(infmt, &test_in);
> +		} else {
> +			*infmt = sdformat->format;
> +			imx_media_ipu_image_to_mbus_fmt(outfmt, &test_out);
> +		}
> +		priv->cc[sdformat->pad] = cc;
> +	}
> +
> +	return 0;
> +}
> +
> +static int pp_link_setup(struct media_entity *entity,
> +			 const struct media_pad *local,
> +			 const struct media_pad *remote, u32 flags)
> +{
> +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
> +	struct imx_ic_priv *ic_priv = v4l2_get_subdevdata(sd);
> +	struct pp_priv *priv = ic_priv->task_priv;
> +	struct v4l2_subdev *remote_sd;
> +
> +	dev_dbg(ic_priv->dev, "link setup %s -> %s", remote->entity->name,
> +		local->entity->name);
> +
> +	remote_sd = media_entity_to_v4l2_subdev(remote->entity);
> +
> +	if (local->flags & MEDIA_PAD_FL_SOURCE) {
> +		if (flags & MEDIA_LNK_FL_ENABLED) {
> +			if (priv->sink_sd)
> +				return -EBUSY;
> +			priv->sink_sd = remote_sd;
> +		} else {
> +			priv->sink_sd = NULL;
> +		}
> +	} else {
> +		if (flags & MEDIA_LNK_FL_ENABLED) {
> +			if (priv->src_sd)
> +				return -EBUSY;
> +			priv->src_sd = remote_sd;
> +		} else {
> +			priv->src_sd = NULL;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int pp_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct pp_priv *priv = container_of(ctrl->handler,
> +					       struct pp_priv, ctrl_hdlr);
> +	struct imx_ic_priv *ic_priv = priv->ic_priv;
> +	enum ipu_rotate_mode rot_mode;
> +	bool hflip, vflip;
> +	int rotation, ret;
> +
> +	rotation = priv->rotation;
> +	hflip = priv->hflip;
> +	vflip = priv->vflip;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_HFLIP:
> +		hflip = (ctrl->val == 1);
> +		break;
> +	case V4L2_CID_VFLIP:
> +		vflip = (ctrl->val == 1);
> +		break;
> +	case V4L2_CID_ROTATE:
> +		rotation = ctrl->val;
> +		break;
> +	default:
> +		v4l2_err(&ic_priv->sd, "Invalid control\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = ipu_degrees_to_rot_mode(&rot_mode, rotation, hflip, vflip);
> +	if (ret)
> +		return ret;
> +
> +	if (rot_mode != priv->rot_mode) {
> +		struct v4l2_mbus_framefmt *infmt, *outfmt;
> +		struct ipu_image test_in, test_out;
> +
> +		/* can't change rotation mid-streaming */
> +		if (priv->stream_on)
> +			return -EBUSY;
> +
> +		/*
> +		 * make sure this rotation will work with current input/output
> +		 * formats before setting
> +		 */
> +		infmt = &priv->format_mbus[priv->input_pad];
> +		outfmt = &priv->format_mbus[priv->output_pad];
> +		imx_media_mbus_fmt_to_ipu_image(&test_in, infmt);
> +		imx_media_mbus_fmt_to_ipu_image(&test_out, outfmt);
> +
> +		ret = ipu_image_convert_verify(&test_in, &test_out, rot_mode);
> +		if (ret)
> +			return ret;
> +
> +		priv->rot_mode = rot_mode;
> +		priv->rotation = rotation;
> +		priv->hflip = hflip;
> +		priv->vflip = vflip;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ctrl_ops pp_ctrl_ops = {
> +	.s_ctrl = pp_s_ctrl,
> +};
> +
> +static const struct v4l2_ctrl_config pp_std_ctrl[] = {
> +	{
> +		.id = V4L2_CID_HFLIP,
> +		.name = "Horizontal Flip",
> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> +		.def =  0,
> +		.min =  0,
> +		.max =  1,
> +		.step = 1,
> +	}, {
> +		.id = V4L2_CID_VFLIP,
> +		.name = "Vertical Flip",
> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> +		.def =  0,
> +		.min =  0,
> +		.max =  1,
> +		.step = 1,
> +	}, {
> +		.id = V4L2_CID_ROTATE,
> +		.name = "Rotation",
> +		.type = V4L2_CTRL_TYPE_INTEGER,
> +		.def =   0,
> +		.min =   0,
> +		.max = 270,
> +		.step = 90,
> +	},
> +};
> +
> +#define PP_NUM_CONTROLS ARRAY_SIZE(pp_std_ctrl)
> +
> +static int pp_init_controls(struct pp_priv *priv)
> +{
> +	struct imx_ic_priv *ic_priv = priv->ic_priv;
> +	struct v4l2_ctrl_handler *hdlr = &priv->ctrl_hdlr;
> +	const struct v4l2_ctrl_config *c;
> +	int i, ret;
> +
> +	v4l2_ctrl_handler_init(hdlr, PP_NUM_CONTROLS);
> +
> +	for (i = 0; i < PP_NUM_CONTROLS; i++) {
> +		c = &pp_std_ctrl[i];
> +		v4l2_ctrl_new_std(hdlr, &pp_ctrl_ops,
> +				  c->id, c->min, c->max, c->step, c->def);
> +	}
> +
> +	ic_priv->sd.ctrl_handler = hdlr;
> +
> +	if (hdlr->error) {
> +		ret = hdlr->error;
> +		v4l2_ctrl_handler_free(hdlr);
> +		return ret;
> +	}
> +
> +	v4l2_ctrl_handler_setup(hdlr);
> +
> +	return 0;
> +}
> +
> +/*
> + * retrieve our pads parsed from the OF graph by the media device
> + */
> +static int pp_registered(struct v4l2_subdev *sd)
> +{
> +	struct pp_priv *priv = sd_to_priv(sd);
> +	struct imx_media_subdev *imxsd;
> +	struct imx_media_pad *pad;
> +	int i, ret;
> +
> +	/* get media device */
> +	priv->md = dev_get_drvdata(sd->v4l2_dev->dev);
> +
> +	imxsd = imx_media_find_subdev_by_sd(priv->md, sd);
> +	if (IS_ERR(imxsd))
> +		return PTR_ERR(imxsd);
> +
> +	if (imxsd->num_sink_pads != 1 || imxsd->num_src_pads != 1)
> +		return -EINVAL;
> +
> +	for (i = 0; i < PP_NUM_PADS; i++) {
> +		pad = &imxsd->pad[i];
> +		priv->pad[i] = pad->pad;
> +		if (priv->pad[i].flags & MEDIA_PAD_FL_SINK)
> +			priv->input_pad = i;
> +		else
> +			priv->output_pad = i;
> +
> +		/* set a default mbus format  */
> +		ret = imx_media_init_mbus_fmt(&priv->format_mbus[i],
> +					      640, 480, 0, V4L2_FIELD_NONE,
> +					      &priv->cc[i]);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	ret = pp_init_controls(priv);
> +	if (ret)
> +		return ret;
> +
> +	ret = media_entity_pads_init(&sd->entity, PP_NUM_PADS, priv->pad);
> +	if (ret)
> +		goto free_ctrls;
> +
> +	return 0;
> +free_ctrls:
> +	v4l2_ctrl_handler_free(&priv->ctrl_hdlr);
> +	return ret;
> +}
> +
> +static struct v4l2_subdev_pad_ops pp_pad_ops = {
> +	.enum_mbus_code = pp_enum_mbus_code,
> +	.get_fmt = pp_get_fmt,
> +	.set_fmt = pp_set_fmt,
> +};
> +
> +static struct v4l2_subdev_video_ops pp_video_ops = {
> +	.s_stream = pp_s_stream,
> +};
> +
> +static struct v4l2_subdev_core_ops pp_core_ops = {
> +	.ioctl = pp_ioctl,
> +};
> +
> +static struct media_entity_operations pp_entity_ops = {
> +	.link_setup = pp_link_setup,
> +	.link_validate = v4l2_subdev_link_validate,
> +};
> +
> +static struct v4l2_subdev_ops pp_subdev_ops = {
> +	.video = &pp_video_ops,
> +	.pad = &pp_pad_ops,
> +	.core = &pp_core_ops,
> +};
> +
> +static struct v4l2_subdev_internal_ops pp_internal_ops = {
> +	.registered = pp_registered,
> +};
> +
> +static int pp_init(struct imx_ic_priv *ic_priv)
> +{
> +	struct pp_priv *priv;
> +
> +	priv = devm_kzalloc(ic_priv->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	ic_priv->task_priv = priv;
> +	priv->ic_priv = ic_priv;
> +	spin_lock_init(&priv->irqlock);
> +
> +	/* get our PP id */
> +	priv->pp_id = (ic_priv->sd.grp_id >> IMX_MEDIA_GRP_ID_IC_PP_BIT) - 1;
> +
> +	return 0;
> +}
> +
> +static void pp_remove(struct imx_ic_priv *ic_priv)
> +{
> +	struct pp_priv *priv = ic_priv->task_priv;
> +
> +	v4l2_ctrl_handler_free(&priv->ctrl_hdlr);
> +}
> +
> +struct imx_ic_ops imx_ic_pp_ops = {
> +	.subdev_ops = &pp_subdev_ops,
> +	.internal_ops = &pp_internal_ops,
> +	.entity_ops = &pp_entity_ops,
> +	.init = pp_init,
> +	.remove = pp_remove,
> +};
> diff --git a/drivers/staging/media/imx/imx-ic-prpenc.c b/drivers/staging/media/imx/imx-ic-prpenc.c
> new file mode 100644
> index 0000000..3d85a82
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx-ic-prpenc.c
> @@ -0,0 +1,1033 @@
> +/*
> + * V4L2 Capture IC Encoder Subdev for Freescale i.MX5/6 SOC
> + *
> + * This subdevice handles capture of video frames from the CSI, which
> + * are routed directly to the Image Converter preprocess encode task,
> + * for resizing, colorspace conversion, and rotation.
> + *
> + * Copyright (c) 2012-2016 Mentor Graphics Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#include <linux/delay.h>
> +#include <linux/fs.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/pinctrl/consumer.h>
> +#include <linux/platform_device.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +#include <linux/timer.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-of.h>
> +#include <media/v4l2-subdev.h>
> +#include <media/videobuf2-dma-contig.h>
> +#include <media/imx.h>
> +#include "imx-media.h"
> +#include "imx-ic.h"
> +
> +#define PRPENC_NUM_PADS 2
> +
> +#define MAX_W_IC   1024
> +#define MAX_H_IC   1024
> +#define MAX_W_SINK 4096
> +#define MAX_H_SINK 4096
> +
> +struct prpenc_priv {
> +	struct imx_media_dev *md;
> +	struct imx_ic_priv *ic_priv;
> +
> +	/* IPU units we require */
> +	struct ipu_soc *ipu;
> +	struct ipu_ic *ic_enc;
> +
> +	struct media_pad pad[PRPENC_NUM_PADS];
> +	int input_pad;
> +	int output_pad;
> +
> +	struct ipuv3_channel *enc_ch;
> +	struct ipuv3_channel *enc_rot_in_ch;
> +	struct ipuv3_channel *enc_rot_out_ch;
> +
> +	/* the dma buffer ring to send to sink */
> +	struct imx_media_dma_buf_ring *out_ring;
> +	struct imx_media_dma_buf *next;
> +
> +	int ipu_buf_num;  /* ipu double buffer index: 0-1 */
> +
> +	struct v4l2_subdev *src_sd;
> +	struct v4l2_subdev *sink_sd;
> +
> +	/* the CSI id at link validate */
> +	int csi_id;
> +
> +	/* the attached sensor at stream on */
> +	struct imx_media_subdev *sensor;
> +
> +	struct v4l2_mbus_framefmt format_mbus[PRPENC_NUM_PADS];
> +	const struct imx_media_pixfmt *cc[PRPENC_NUM_PADS];
> +
> +	struct imx_media_dma_buf rot_buf[2];
> +
> +	/* controls */
> +	struct v4l2_ctrl_handler ctrl_hdlr;
> +	int  rotation; /* degrees */
> +	bool hflip;
> +	bool vflip;
> +
> +	/* derived from rotation, hflip, vflip controls */
> +	enum ipu_rotate_mode rot_mode;
> +
> +	spinlock_t irqlock;
> +
> +	struct timer_list eof_timeout_timer;
> +	int eof_irq;
> +	int nfb4eof_irq;
> +
> +	bool stream_on; /* streaming is on */
> +	bool last_eof;  /* waiting for last EOF at stream off */
> +	struct completion last_eof_comp;
> +};
> +
> +static inline struct prpenc_priv *sd_to_priv(struct v4l2_subdev *sd)
> +{
> +	struct imx_ic_priv *ic_priv = v4l2_get_subdevdata(sd);
> +
> +	return ic_priv->task_priv;
> +}
> +
> +static void prpenc_put_ipu_resources(struct prpenc_priv *priv)
> +{
> +	if (!IS_ERR_OR_NULL(priv->ic_enc))
> +		ipu_ic_put(priv->ic_enc);
> +	priv->ic_enc = NULL;
> +
> +	if (!IS_ERR_OR_NULL(priv->enc_ch))
> +		ipu_idmac_put(priv->enc_ch);
> +	priv->enc_ch = NULL;
> +
> +	if (!IS_ERR_OR_NULL(priv->enc_rot_in_ch))
> +		ipu_idmac_put(priv->enc_rot_in_ch);
> +	priv->enc_rot_in_ch = NULL;
> +
> +	if (!IS_ERR_OR_NULL(priv->enc_rot_out_ch))
> +		ipu_idmac_put(priv->enc_rot_out_ch);
> +	priv->enc_rot_out_ch = NULL;
> +}
> +
> +static int prpenc_get_ipu_resources(struct prpenc_priv *priv)
> +{
> +	struct imx_ic_priv *ic_priv = priv->ic_priv;
> +	int ret;
> +
> +	priv->ipu = priv->md->ipu[ic_priv->ipu_id];
> +
> +	priv->ic_enc = ipu_ic_get(priv->ipu, IC_TASK_ENCODER);
> +	if (IS_ERR(priv->ic_enc)) {
> +		v4l2_err(&ic_priv->sd, "failed to get IC ENC\n");
> +		ret = PTR_ERR(priv->ic_enc);
> +		goto out;
> +	}
> +
> +	priv->enc_ch = ipu_idmac_get(priv->ipu,
> +				     IPUV3_CHANNEL_IC_PRP_ENC_MEM);
> +	if (IS_ERR(priv->enc_ch)) {
> +		v4l2_err(&ic_priv->sd, "could not get IDMAC channel %u\n",
> +			 IPUV3_CHANNEL_IC_PRP_ENC_MEM);
> +		ret = PTR_ERR(priv->enc_ch);
> +		goto out;
> +	}
> +
> +	priv->enc_rot_in_ch = ipu_idmac_get(priv->ipu,
> +					    IPUV3_CHANNEL_MEM_ROT_ENC);
> +	if (IS_ERR(priv->enc_rot_in_ch)) {
> +		v4l2_err(&ic_priv->sd, "could not get IDMAC channel %u\n",
> +			 IPUV3_CHANNEL_MEM_ROT_ENC);
> +		ret = PTR_ERR(priv->enc_rot_in_ch);
> +		goto out;
> +	}
> +
> +	priv->enc_rot_out_ch = ipu_idmac_get(priv->ipu,
> +					     IPUV3_CHANNEL_ROT_ENC_MEM);
> +	if (IS_ERR(priv->enc_rot_out_ch)) {
> +		v4l2_err(&ic_priv->sd, "could not get IDMAC channel %u\n",
> +			 IPUV3_CHANNEL_ROT_ENC_MEM);
> +		ret = PTR_ERR(priv->enc_rot_out_ch);
> +		goto out;
> +	}
> +
> +	return 0;
> +out:
> +	prpenc_put_ipu_resources(priv);
> +	return ret;
> +}
> +
> +static irqreturn_t prpenc_eof_interrupt(int irq, void *dev_id)
> +{
> +	struct prpenc_priv *priv = dev_id;
> +	struct imx_media_dma_buf *done, *next;
> +	struct ipuv3_channel *channel;
> +
> +	spin_lock(&priv->irqlock);
> +
> +	if (priv->last_eof) {
> +		complete(&priv->last_eof_comp);
> +		priv->last_eof = false;
> +		goto unlock;
> +	}
> +
> +	/* inform CSI of this EOF so it can monitor frame intervals */
> +	v4l2_subdev_call(priv->src_sd, core, interrupt_service_routine,
> +			 0, NULL);
> +
> +	channel = (ipu_rot_mode_is_irt(priv->rot_mode)) ?
> +		priv->enc_rot_out_ch : priv->enc_ch;
> +
> +	done = imx_media_dma_buf_get_active(priv->out_ring);
> +	/* give the completed buffer to the sink  */
> +	if (!WARN_ON(!done))
> +		imx_media_dma_buf_done(done, IMX_MEDIA_BUF_STATUS_DONE);
> +
> +	/* priv->next buffer is now the active one */
> +	imx_media_dma_buf_set_active(priv->next);
> +
> +	/* bump the EOF timeout timer */
> +	mod_timer(&priv->eof_timeout_timer,
> +		  jiffies + msecs_to_jiffies(IMX_MEDIA_EOF_TIMEOUT));
> +
> +	if (ipu_idmac_buffer_is_ready(channel, priv->ipu_buf_num))
> +		ipu_idmac_clear_buffer(channel, priv->ipu_buf_num);
> +
> +	/* get next queued buffer */
> +	next = imx_media_dma_buf_get_next_queued(priv->out_ring);
> +
> +	ipu_cpmem_set_buffer(channel, priv->ipu_buf_num, next->phys);
> +	ipu_idmac_select_buffer(channel, priv->ipu_buf_num);
> +
> +	/* toggle IPU double-buffer index */
> +	priv->ipu_buf_num ^= 1;
> +	priv->next = next;
> +
> +unlock:
> +	spin_unlock(&priv->irqlock);
> +	return IRQ_HANDLED;
> +}
> +
> +static irqreturn_t prpenc_nfb4eof_interrupt(int irq, void *dev_id)
> +{
> +	struct prpenc_priv *priv = dev_id;
> +	struct imx_ic_priv *ic_priv = priv->ic_priv;
> +	static const struct v4l2_event ev = {
> +		.type = V4L2_EVENT_IMX_NFB4EOF,
> +	};
> +
> +	v4l2_err(&ic_priv->sd, "NFB4EOF\n");
> +
> +	v4l2_subdev_notify_event(&ic_priv->sd, &ev);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +/*
> + * EOF timeout timer function.
> + */
> +static void prpenc_eof_timeout(unsigned long data)
> +{
> +	struct prpenc_priv *priv = (struct prpenc_priv *)data;
> +	struct imx_ic_priv *ic_priv = priv->ic_priv;
> +	static const struct v4l2_event ev = {
> +		.type = V4L2_EVENT_IMX_EOF_TIMEOUT,
> +	};
> +
> +	v4l2_err(&ic_priv->sd, "EOF timeout\n");
> +
> +	v4l2_subdev_notify_event(&ic_priv->sd, &ev);
> +}
> +
> +static void prpenc_setup_channel(struct prpenc_priv *priv,
> +				 struct ipuv3_channel *channel,
> +				 enum ipu_rotate_mode rot_mode,
> +				 dma_addr_t addr0, dma_addr_t addr1,
> +				 bool rot_swap_width_height)
> +{
> +	struct v4l2_mbus_framefmt *infmt, *outfmt;
> +	unsigned int burst_size;
> +	struct ipu_image image;
> +
> +	infmt = &priv->format_mbus[priv->input_pad];
> +	outfmt = &priv->format_mbus[priv->output_pad];
> +
> +	if (rot_swap_width_height)
> +		swap(outfmt->width, outfmt->height);
> +
> +	ipu_cpmem_zero(channel);
> +
> +	imx_media_mbus_fmt_to_ipu_image(&image, outfmt);
> +
> +	image.phys0 = addr0;
> +	image.phys1 = addr1;
> +	ipu_cpmem_set_image(channel, &image);
> +
> +	if (channel == priv->enc_rot_in_ch ||
> +	    channel == priv->enc_rot_out_ch) {
> +		burst_size = 8;
> +		ipu_cpmem_set_block_mode(channel);
> +	} else {
> +		burst_size = (outfmt->width & 0xf) ? 8 : 16;
> +	}
> +
> +	ipu_cpmem_set_burstsize(channel, burst_size);
> +
> +	if (rot_mode)
> +		ipu_cpmem_set_rotation(channel, rot_mode);
> +
> +	if (outfmt->field == V4L2_FIELD_NONE &&
> +	    (V4L2_FIELD_HAS_BOTH(infmt->field) ||
> +	     infmt->field == V4L2_FIELD_ALTERNATE) &&
> +	    channel == priv->enc_ch)
> +		ipu_cpmem_interlaced_scan(channel, image.pix.bytesperline);
> +
> +	ipu_ic_task_idma_init(priv->ic_enc, channel,
> +			      outfmt->width, outfmt->height,
> +			      burst_size, rot_mode);
> +	ipu_cpmem_set_axi_id(channel, 1);
> +
> +	ipu_idmac_set_double_buffer(channel, true);
> +
> +	if (rot_swap_width_height)
> +		swap(outfmt->width, outfmt->height);
> +}
> +
> +static int prpenc_setup_rotation(struct prpenc_priv *priv)
> +{
> +	struct imx_ic_priv *ic_priv = priv->ic_priv;
> +	struct v4l2_mbus_framefmt *infmt, *outfmt;
> +	const struct imx_media_pixfmt *outcc, *incc;
> +	struct imx_media_dma_buf *buf0, *buf1;
> +	int out_size, ret;
> +
> +	infmt = &priv->format_mbus[priv->input_pad];
> +	outfmt = &priv->format_mbus[priv->output_pad];
> +	incc = priv->cc[priv->input_pad];
> +	outcc = priv->cc[priv->output_pad];
> +
> +	out_size = (outfmt->width * outcc->bpp * outfmt->height) >> 3;
> +
> +	ret = imx_media_alloc_dma_buf(priv->md, &priv->rot_buf[0], out_size);
> +	if (ret) {
> +		v4l2_err(&ic_priv->sd, "failed to alloc rot_buf[0], %d\n", ret);
> +		return ret;
> +	}
> +	ret = imx_media_alloc_dma_buf(priv->md, &priv->rot_buf[1], out_size);
> +	if (ret) {
> +		v4l2_err(&ic_priv->sd, "failed to alloc rot_buf[1], %d\n", ret);
> +		goto free_rot0;
> +	}
> +
> +	ret = ipu_ic_task_init(priv->ic_enc,
> +			       infmt->width, infmt->height,
> +			       outfmt->height, outfmt->width,
> +			       incc->cs, outcc->cs);
> +	if (ret) {
> +		v4l2_err(&ic_priv->sd, "ipu_ic_task_init failed, %d\n", ret);
> +		goto free_rot1;
> +	}
> +
> +	/* init the IC ENC-->MEM IDMAC channel */
> +	prpenc_setup_channel(priv, priv->enc_ch,
> +			     IPU_ROTATE_NONE,
> +			     priv->rot_buf[0].phys,
> +			     priv->rot_buf[1].phys,
> +			     true);
> +
> +	/* init the MEM-->IC ENC ROT IDMAC channel */
> +	prpenc_setup_channel(priv, priv->enc_rot_in_ch,
> +			     priv->rot_mode,
> +			     priv->rot_buf[0].phys,
> +			     priv->rot_buf[1].phys,
> +			     true);
> +
> +	buf0 = imx_media_dma_buf_get_next_queued(priv->out_ring);
> +	imx_media_dma_buf_set_active(buf0);
> +	buf1 = imx_media_dma_buf_get_next_queued(priv->out_ring);
> +	priv->next = buf1;
> +
> +	/* init the destination IC ENC ROT-->MEM IDMAC channel */
> +	prpenc_setup_channel(priv, priv->enc_rot_out_ch,
> +			     IPU_ROTATE_NONE,
> +			     buf0->phys, buf1->phys,
> +			     false);
> +
> +	/* now link IC ENC-->MEM to MEM-->IC ENC ROT */
> +	ipu_idmac_link(priv->enc_ch, priv->enc_rot_in_ch);
> +
> +	/* enable the IC */
> +	ipu_ic_enable(priv->ic_enc);
> +
> +	/* set buffers ready */
> +	ipu_idmac_select_buffer(priv->enc_ch, 0);
> +	ipu_idmac_select_buffer(priv->enc_ch, 1);
> +	ipu_idmac_select_buffer(priv->enc_rot_out_ch, 0);
> +	ipu_idmac_select_buffer(priv->enc_rot_out_ch, 1);
> +
> +	/* enable the channels */
> +	ipu_idmac_enable_channel(priv->enc_ch);
> +	ipu_idmac_enable_channel(priv->enc_rot_in_ch);
> +	ipu_idmac_enable_channel(priv->enc_rot_out_ch);
> +
> +	/* and finally enable the IC PRPENC task */
> +	ipu_ic_task_enable(priv->ic_enc);
> +
> +	return 0;
> +
> +free_rot1:
> +	imx_media_free_dma_buf(priv->md, &priv->rot_buf[1]);
> +free_rot0:
> +	imx_media_free_dma_buf(priv->md, &priv->rot_buf[0]);
> +	return ret;
> +}
> +
> +static void prpenc_unsetup_rotation(struct prpenc_priv *priv)
> +{
> +	ipu_ic_task_disable(priv->ic_enc);
> +
> +	ipu_idmac_disable_channel(priv->enc_ch);
> +	ipu_idmac_disable_channel(priv->enc_rot_in_ch);
> +	ipu_idmac_disable_channel(priv->enc_rot_out_ch);
> +
> +	ipu_idmac_unlink(priv->enc_ch, priv->enc_rot_in_ch);
> +
> +	ipu_ic_disable(priv->ic_enc);
> +
> +	imx_media_free_dma_buf(priv->md, &priv->rot_buf[0]);
> +	imx_media_free_dma_buf(priv->md, &priv->rot_buf[1]);
> +}
> +
> +static int prpenc_setup_norotation(struct prpenc_priv *priv)
> +{
> +	struct imx_ic_priv *ic_priv = priv->ic_priv;
> +	struct v4l2_mbus_framefmt *infmt, *outfmt;
> +	const struct imx_media_pixfmt *outcc, *incc;
> +	struct imx_media_dma_buf *buf0, *buf1;
> +	int ret;
> +
> +	infmt = &priv->format_mbus[priv->input_pad];
> +	outfmt = &priv->format_mbus[priv->output_pad];
> +	incc = priv->cc[priv->input_pad];
> +	outcc = priv->cc[priv->output_pad];
> +
> +	ret = ipu_ic_task_init(priv->ic_enc,
> +			       infmt->width, infmt->height,
> +			       outfmt->width, outfmt->height,
> +			       incc->cs, outcc->cs);
> +	if (ret) {
> +		v4l2_err(&ic_priv->sd, "ipu_ic_task_init failed, %d\n", ret);
> +		return ret;
> +	}
> +
> +	buf0 = imx_media_dma_buf_get_next_queued(priv->out_ring);
> +	imx_media_dma_buf_set_active(buf0);
> +	buf1 = imx_media_dma_buf_get_next_queued(priv->out_ring);
> +	priv->next = buf1;
> +
> +	/* init the IC PRP-->MEM IDMAC channel */
> +	prpenc_setup_channel(priv, priv->enc_ch, priv->rot_mode,
> +			     buf0->phys, buf1->phys,
> +			     false);
> +
> +	ipu_cpmem_dump(priv->enc_ch);
> +	ipu_ic_dump(priv->ic_enc);
> +	ipu_dump(priv->ipu);
> +
> +	ipu_ic_enable(priv->ic_enc);
> +
> +	/* set buffers ready */
> +	ipu_idmac_select_buffer(priv->enc_ch, 0);
> +	ipu_idmac_select_buffer(priv->enc_ch, 1);
> +
> +	/* enable the channels */
> +	ipu_idmac_enable_channel(priv->enc_ch);
> +
> +	/* enable the IC ENCODE task */
> +	ipu_ic_task_enable(priv->ic_enc);
> +
> +	return 0;
> +}
> +
> +static void prpenc_unsetup_norotation(struct prpenc_priv *priv)
> +{
> +	ipu_ic_task_disable(priv->ic_enc);
> +	ipu_idmac_disable_channel(priv->enc_ch);
> +	ipu_ic_disable(priv->ic_enc);
> +}
> +
> +static int prpenc_start(struct prpenc_priv *priv)
> +{
> +	struct imx_ic_priv *ic_priv = priv->ic_priv;
> +	int ret;
> +
> +	if (!priv->sensor) {
> +		v4l2_err(&ic_priv->sd, "no sensor attached\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = prpenc_get_ipu_resources(priv);
> +	if (ret)
> +		return ret;
> +
> +	/* set IC to receive from CSI */
> +	ipu_set_ic_src_mux(priv->ipu, priv->csi_id, false);
> +
> +	/* ask the sink for the buffer ring */
> +	ret = v4l2_subdev_call(priv->sink_sd, core, ioctl,
> +			       IMX_MEDIA_REQ_DMA_BUF_SINK_RING,
> +			       &priv->out_ring);
> +	if (ret)
> +		goto out_put_ipu;
> +
> +	priv->ipu_buf_num = 0;
> +
> +	/* init EOF completion waitq */
> +	init_completion(&priv->last_eof_comp);
> +	priv->last_eof = false;
> +
> +	if (ipu_rot_mode_is_irt(priv->rot_mode))
> +		ret = prpenc_setup_rotation(priv);
> +	else
> +		ret = prpenc_setup_norotation(priv);
> +	if (ret)
> +		goto out_put_ipu;
> +
> +	priv->nfb4eof_irq = ipu_idmac_channel_irq(priv->ipu,
> +						  priv->enc_ch,
> +						  IPU_IRQ_NFB4EOF);
> +	ret = devm_request_irq(ic_priv->dev, priv->nfb4eof_irq,
> +			       prpenc_nfb4eof_interrupt, 0,
> +			       "imx-ic-prpenc-nfb4eof", priv);
> +	if (ret) {
> +		v4l2_err(&ic_priv->sd,
> +			 "Error registering NFB4EOF irq: %d\n", ret);
> +		goto out_unsetup;
> +	}
> +
> +	if (ipu_rot_mode_is_irt(priv->rot_mode))
> +		priv->eof_irq = ipu_idmac_channel_irq(
> +			priv->ipu, priv->enc_rot_out_ch, IPU_IRQ_EOF);
> +	else
> +		priv->eof_irq = ipu_idmac_channel_irq(
> +			priv->ipu, priv->enc_ch, IPU_IRQ_EOF);
> +
> +	ret = devm_request_irq(ic_priv->dev, priv->eof_irq,
> +			       prpenc_eof_interrupt, 0,
> +			       "imx-ic-prpenc-eof", priv);
> +	if (ret) {
> +		v4l2_err(&ic_priv->sd,
> +			 "Error registering eof irq: %d\n", ret);
> +		goto out_free_nfb4eof_irq;
> +	}
> +
> +	/* start the EOF timeout timer */
> +	mod_timer(&priv->eof_timeout_timer,
> +		  jiffies + msecs_to_jiffies(IMX_MEDIA_EOF_TIMEOUT));
> +
> +	return 0;
> +
> +out_free_nfb4eof_irq:
> +	devm_free_irq(ic_priv->dev, priv->nfb4eof_irq, priv);
> +out_unsetup:
> +	if (ipu_rot_mode_is_irt(priv->rot_mode))
> +		prpenc_unsetup_rotation(priv);
> +	else
> +		prpenc_unsetup_norotation(priv);
> +out_put_ipu:
> +	prpenc_put_ipu_resources(priv);
> +	return ret;
> +}
> +
> +static void prpenc_stop(struct prpenc_priv *priv)
> +{
> +	struct imx_ic_priv *ic_priv = priv->ic_priv;
> +	unsigned long flags;
> +	int ret;
> +
> +	/* mark next EOF interrupt as the last before stream off */
> +	spin_lock_irqsave(&priv->irqlock, flags);
> +	priv->last_eof = true;
> +	spin_unlock_irqrestore(&priv->irqlock, flags);
> +
> +	/*
> +	 * and then wait for interrupt handler to mark completion.
> +	 */
> +	ret = wait_for_completion_timeout(
> +		&priv->last_eof_comp,
> +		msecs_to_jiffies(IMX_MEDIA_EOF_TIMEOUT));
> +	if (ret == 0)
> +		v4l2_warn(&ic_priv->sd, "wait last EOF timeout\n");
> +
> +	devm_free_irq(ic_priv->dev, priv->eof_irq, priv);
> +	devm_free_irq(ic_priv->dev, priv->nfb4eof_irq, priv);
> +
> +	if (ipu_rot_mode_is_irt(priv->rot_mode))
> +		prpenc_unsetup_rotation(priv);
> +	else
> +		prpenc_unsetup_norotation(priv);
> +
> +	prpenc_put_ipu_resources(priv);
> +
> +	/* cancel the EOF timeout timer */
> +	del_timer_sync(&priv->eof_timeout_timer);
> +
> +	priv->out_ring = NULL;
> +
> +	/* inform sink that the buffer ring can now be freed */
> +	v4l2_subdev_call(priv->sink_sd, core, ioctl,
> +			 IMX_MEDIA_REL_DMA_BUF_SINK_RING, 0);
> +}
> +
> +static int prpenc_enum_mbus_code(struct v4l2_subdev *sd,
> +				 struct v4l2_subdev_pad_config *cfg,
> +				 struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	struct prpenc_priv *priv = sd_to_priv(sd);
> +	bool allow_planar;
> +
> +	if (code->pad >= PRPENC_NUM_PADS)
> +		return -EINVAL;
> +
> +	allow_planar = (code->pad == priv->output_pad);
> +
> +	return imx_media_enum_format(&code->code, code->index,
> +				     true, allow_planar);
> +}
> +
> +static int prpenc_get_fmt(struct v4l2_subdev *sd,
> +			  struct v4l2_subdev_pad_config *cfg,
> +			  struct v4l2_subdev_format *sdformat)
> +{
> +	struct prpenc_priv *priv = sd_to_priv(sd);
> +
> +	if (sdformat->pad >= PRPENC_NUM_PADS)
> +		return -EINVAL;
> +
> +	sdformat->format = priv->format_mbus[sdformat->pad];
> +
> +	return 0;
> +}
> +
> +static int prpenc_set_fmt(struct v4l2_subdev *sd,
> +			  struct v4l2_subdev_pad_config *cfg,
> +			  struct v4l2_subdev_format *sdformat)
> +{
> +	struct prpenc_priv *priv = sd_to_priv(sd);
> +	struct v4l2_mbus_framefmt *infmt, *outfmt;
> +	const struct imx_media_pixfmt *cc;
> +	bool allow_planar;
> +	u32 code;
> +
> +	if (sdformat->pad >= PRPENC_NUM_PADS)
> +		return -EINVAL;
> +
> +	if (priv->stream_on)
> +		return -EBUSY;
> +
> +	infmt = &priv->format_mbus[priv->input_pad];
> +	outfmt = &priv->format_mbus[priv->output_pad];
> +	allow_planar = (sdformat->pad == priv->output_pad);
> +
> +	cc = imx_media_find_format(0, sdformat->format.code,
> +				   true, allow_planar);
> +	if (!cc) {
> +		imx_media_enum_format(&code, 0, true, false);
> +		cc = imx_media_find_format(0, code, true, false);
> +		sdformat->format.code = cc->codes[0];
> +	}
> +
> +	if (sdformat->pad == priv->output_pad) {
> +		sdformat->format.width = min_t(__u32,
> +					       sdformat->format.width,
> +					       MAX_W_IC);
> +		sdformat->format.height = min_t(__u32,
> +						sdformat->format.height,
> +						MAX_H_IC);
> +
> +		if (sdformat->format.field != V4L2_FIELD_NONE)
> +			sdformat->format.field = infmt->field;
> +
> +		/* IC resizer cannot downsize more than 4:1 */
> +		if (ipu_rot_mode_is_irt(priv->rot_mode)) {
> +			sdformat->format.width = max_t(__u32,
> +						       sdformat->format.width,
> +						       infmt->height / 4);
> +			sdformat->format.height = max_t(__u32,
> +							sdformat->format.height,
> +							infmt->width / 4);
> +		} else {
> +			sdformat->format.width = max_t(__u32,
> +						       sdformat->format.width,
> +						       infmt->width / 4);
> +			sdformat->format.height = max_t(__u32,
> +							sdformat->format.height,
> +							infmt->height / 4);
> +		}
> +	} else {
> +		sdformat->format.width = min_t(__u32,
> +					       sdformat->format.width,
> +					       MAX_W_SINK);
> +		sdformat->format.height = min_t(__u32,
> +						sdformat->format.height,
> +						MAX_H_SINK);
> +	}
> +
> +	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		cfg->try_fmt = sdformat->format;
> +	} else {
> +		priv->format_mbus[sdformat->pad] = sdformat->format;
> +		priv->cc[sdformat->pad] = cc;
> +	}
> +
> +	return 0;
> +}
> +
> +static int prpenc_link_setup(struct media_entity *entity,
> +			     const struct media_pad *local,
> +			     const struct media_pad *remote, u32 flags)
> +{
> +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
> +	struct imx_ic_priv *ic_priv = v4l2_get_subdevdata(sd);
> +	struct prpenc_priv *priv = ic_priv->task_priv;
> +	struct v4l2_subdev *remote_sd;
> +
> +	dev_dbg(ic_priv->dev, "link setup %s -> %s", remote->entity->name,
> +		local->entity->name);
> +
> +	remote_sd = media_entity_to_v4l2_subdev(remote->entity);
> +
> +	if (local->flags & MEDIA_PAD_FL_SOURCE) {
> +		if (flags & MEDIA_LNK_FL_ENABLED) {
> +			if (priv->sink_sd)
> +				return -EBUSY;
> +			priv->sink_sd = remote_sd;
> +		} else {
> +			priv->sink_sd = NULL;
> +		}
> +
> +		return 0;
> +	}
> +
> +	/* this is sink pad */
> +	if (flags & MEDIA_LNK_FL_ENABLED) {
> +		if (priv->src_sd)
> +			return -EBUSY;
> +		priv->src_sd = remote_sd;
> +	} else {
> +		priv->src_sd = NULL;
> +		return 0;
> +	}
> +
> +	switch (remote_sd->grp_id) {
> +	case IMX_MEDIA_GRP_ID_CSI0:
> +		priv->csi_id = 0;
> +		break;
> +	case IMX_MEDIA_GRP_ID_CSI1:
> +		priv->csi_id = 1;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int prpenc_link_validate(struct v4l2_subdev *sd,
> +				struct media_link *link,
> +				struct v4l2_subdev_format *source_fmt,
> +				struct v4l2_subdev_format *sink_fmt)
> +{
> +	struct imx_ic_priv *ic_priv = v4l2_get_subdevdata(sd);
> +	struct prpenc_priv *priv = ic_priv->task_priv;
> +	struct v4l2_mbus_config sensor_mbus_cfg;
> +	int ret;
> +
> +	ret = v4l2_subdev_link_validate_default(sd, link,
> +						source_fmt, sink_fmt);
> +	if (ret)
> +		return ret;
> +
> +	priv->sensor = __imx_media_find_sensor(priv->md, &ic_priv->sd.entity);
> +	if (IS_ERR(priv->sensor)) {
> +		v4l2_err(&ic_priv->sd, "no sensor attached\n");
> +		ret = PTR_ERR(priv->sensor);
> +		priv->sensor = NULL;
> +		return ret;
> +	}
> +
> +	ret = v4l2_subdev_call(priv->sensor->sd, video, g_mbus_config,
> +			       &sensor_mbus_cfg);
> +	if (ret)
> +		return ret;
> +
> +	if (sensor_mbus_cfg.type == V4L2_MBUS_CSI2) {
> +		int vc_num = 0;
> +		/* see NOTE in imx-csi.c */
> +#if 0
> +		vc_num = imx_media_find_mipi_csi2_channel(
> +			priv->md, &ic_priv->sd.entity);
> +		if (vc_num < 0)
> +			return vc_num;
> +#endif
> +		/* only virtual channel 0 can be sent to IC */
> +		if (vc_num != 0)
> +			return -EINVAL;
> +	} else {
> +		/*
> +		 * only 8-bit pixels can be sent to IC for parallel
> +		 * busses
> +		 */
> +		if (priv->sensor->sensor_ep.bus.parallel.bus_width >= 16)
> +			return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int prpenc_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct prpenc_priv *priv = container_of(ctrl->handler,
> +					       struct prpenc_priv, ctrl_hdlr);
> +	struct imx_ic_priv *ic_priv = priv->ic_priv;
> +	enum ipu_rotate_mode rot_mode;
> +	bool hflip, vflip;
> +	int rotation, ret;
> +
> +	rotation = priv->rotation;
> +	hflip = priv->hflip;
> +	vflip = priv->vflip;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_HFLIP:
> +		hflip = (ctrl->val == 1);
> +		break;
> +	case V4L2_CID_VFLIP:
> +		vflip = (ctrl->val == 1);
> +		break;
> +	case V4L2_CID_ROTATE:
> +		rotation = ctrl->val;
> +		break;
> +	default:
> +		v4l2_err(&ic_priv->sd, "Invalid control\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = ipu_degrees_to_rot_mode(&rot_mode, rotation, hflip, vflip);
> +	if (ret)
> +		return ret;
> +
> +	if (rot_mode != priv->rot_mode) {
> +		/* can't change rotation mid-streaming */
> +		if (priv->stream_on)
> +			return -EBUSY;
> +
> +		priv->rot_mode = rot_mode;
> +		priv->rotation = rotation;
> +		priv->hflip = hflip;
> +		priv->vflip = vflip;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ctrl_ops prpenc_ctrl_ops = {
> +	.s_ctrl = prpenc_s_ctrl,
> +};
> +
> +static const struct v4l2_ctrl_config prpenc_std_ctrl[] = {
> +	{
> +		.id = V4L2_CID_HFLIP,
> +		.name = "Horizontal Flip",
> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> +		.def =  0,
> +		.min =  0,
> +		.max =  1,
> +		.step = 1,
> +	}, {
> +		.id = V4L2_CID_VFLIP,
> +		.name = "Vertical Flip",
> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> +		.def =  0,
> +		.min =  0,
> +		.max =  1,
> +		.step = 1,
> +	}, {
> +		.id = V4L2_CID_ROTATE,
> +		.name = "Rotation",
> +		.type = V4L2_CTRL_TYPE_INTEGER,
> +		.def =   0,
> +		.min =   0,
> +		.max = 270,
> +		.step = 90,
> +	},
> +};

Use v4l2_ctrl_new_std() instead of this array: this avoids duplicating information
like the name and type.

If this is also done elsewhere, then it should be changed there as well.

Regards,

	Hans
