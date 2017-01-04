Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:56643 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759037AbdADOsV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2017 09:48:21 -0500
Subject: Re: [PATCH v2 13/19] media: imx: Add IC subdev drivers
To: Steve Longerbeam <slongerbeam@gmail.com>, <shawnguo@kernel.org>,
        <kernel@pengutronix.de>, <fabio.estevam@nxp.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <linux@armlinux.org.uk>, <mchehab@kernel.org>,
        <gregkh@linuxfoundation.org>, <p.zabel@pengutronix.de>
References: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
 <1483477049-19056-14-git-send-email-steve_longerbeam@mentor.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Message-ID: <96684048-c5ad-3e64-0fbc-61dcaf184519@mentor.com>
Date: Wed, 4 Jan 2017 16:48:13 +0200
MIME-Version: 1.0
In-Reply-To: <1483477049-19056-14-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/03/2017 10:57 PM, Steve Longerbeam wrote:
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

[snip]

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
> +		goto remove;
> +
> +	return 0;
> +remove:
> +	ic_ops[priv->task_id]->remove(priv);
> +	return ret;

if (ret)
	ic_ops[priv->task_id]->remove(priv);

return ret;

as an alternative.

[snip]

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
> +		.owner = THIS_MODULE,

Please drop .owner assignment.

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
> index 0000000..5ef0581
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
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/fs.h>
> +#include <linux/timer.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <linux/pinctrl/consumer.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-dma-contig.h>
> +#include <media/v4l2-subdev.h>
> +#include <media/v4l2-of.h>
> +#include <media/v4l2-ctrls.h>

Please sort the list of headers alphabetically.

> +#include <media/imx.h>
> +#include <video/imx-ipu-image-convert.h>
> +#include "imx-media.h"
> +#include "imx-ic.h"
> +

[snip]

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

In OOM situation the core will report it, probably you can drop the message.

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

[snip]

> diff --git a/drivers/staging/media/imx/imx-ic-prpenc.c b/drivers/staging/media/imx/imx-ic-prpenc.c
> new file mode 100644
> index 0000000..e17216b
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx-ic-prpenc.c
> @@ -0,0 +1,1037 @@
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
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/fs.h>
> +#include <linux/timer.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +#include <linux/interrupt.h>
> +#include <linux/spinlock.h>
> +#include <linux/platform_device.h>
> +#include <linux/pinctrl/consumer.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-dma-contig.h>
> +#include <media/v4l2-subdev.h>
> +#include <media/v4l2-of.h>
> +#include <media/v4l2-ctrls.h>

Please sort the list of headers alphabetically.

> +#include <media/imx.h>
> +#include "imx-media.h"
> +#include "imx-ic.h"
> +

[snip]

> +static irqreturn_t prpenc_eof_interrupt(int irq, void *dev_id)
> +{
> +	struct prpenc_priv *priv = dev_id;
> +	struct imx_media_dma_buf *done, *next;
> +	struct ipuv3_channel *channel;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&priv->irqlock, flags);

Here spin_lock(&priv->irqlock) should be sufficient.

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
> +	spin_unlock_irqrestore(&priv->irqlock, flags);
> +	return IRQ_HANDLED;
> +}

[snip]

> +static int prpenc_registered(struct v4l2_subdev *sd)
> +{
> +	struct prpenc_priv *priv = sd_to_priv(sd);
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
> +	for (i = 0; i < PRPENC_NUM_PADS; i++) {
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
> +	ret = prpenc_init_controls(priv);
> +	if (ret)
> +		return ret;
> +
> +	ret = media_entity_pads_init(&sd->entity, PRPENC_NUM_PADS, priv->pad);
> +	if (ret)
> +		goto free_ctrls;
> +
> +	return 0;
> +free_ctrls:
> +	v4l2_ctrl_handler_free(&priv->ctrl_hdlr);
> +	return ret;

if (ret)
	v4l2_ctrl_handler_free(&priv->ctrl_hdlr);

return ret;

version is shorter.

> +}

[snip]

> diff --git a/drivers/staging/media/imx/imx-ic-prpvf.c b/drivers/staging/media/imx/imx-ic-prpvf.c
> new file mode 100644
> index 0000000..53ce006
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx-ic-prpvf.c
> @@ -0,0 +1,1180 @@
> +/*
> + * V4L2 IC Deinterlacer Subdev for Freescale i.MX5/6 SOC
> + *
> + * Copyright (c) 2014-2016 Mentor Graphics Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/fs.h>
> +#include <linux/timer.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <linux/pinctrl/consumer.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-dma-contig.h>
> +#include <media/v4l2-subdev.h>
> +#include <media/v4l2-of.h>
> +#include <media/v4l2-ctrls.h>

Please sort the list of headers alphabetically.

> +#include <media/imx.h>
> +#include "imx-media.h"
> +#include "imx-ic.h"
> +
> +/*

[snip]

> +/* prpvf_out_ch EOF interrupt (progressive frame ready) */
> +static irqreturn_t prpvf_out_eof_interrupt(int irq, void *dev_id)
> +{
> +	struct prpvf_priv *priv = dev_id;
> +	struct imx_media_dma_buf *done;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&priv->irqlock, flags);


Here spin_lock(&priv->irqlock) should be sufficient.

> +
> +	if (priv->last_eof) {
> +		complete(&priv->last_eof_comp);
> +		priv->last_eof = false;
> +		goto unlock;
> +	}
> +
> +	if (priv->csi_direct) {
> +		/* inform CSI of this EOF so it can monitor frame intervals */
> +		/* FIXME: frames are coming in twice as fast in direct path! */
> +		v4l2_subdev_call(priv->src_sd, core, interrupt_service_routine,
> +				 0, NULL);
> +	}
> +
> +	done = imx_media_dma_buf_get_active(priv->out_ring);
> +	/* give the completed buffer to the sink  */
> +	if (!WARN_ON(!done))
> +		imx_media_dma_buf_done(done, IMX_MEDIA_BUF_STATUS_DONE);
> +
> +	if (!priv->csi_direct) {
> +		/* we're done with the input buffer, queue it back */
> +		imx_media_dma_buf_queue(priv->in_ring,
> +					priv->curr_in_buf->index);
> +
> +		/* current input buffer is now last */
> +		priv->last_in_buf = priv->curr_in_buf;
> +	} else {
> +		/*
> +		 * priv->next buffer is now the active one due
> +		 * to IPU double-buffering
> +		 */
> +		imx_media_dma_buf_set_active(priv->next_out_buf);
> +	}
> +
> +	/* bump the EOF timeout timer */
> +	mod_timer(&priv->eof_timeout_timer,
> +		  jiffies + msecs_to_jiffies(IMX_MEDIA_EOF_TIMEOUT));
> +
> +	if (priv->csi_direct) {
> +		prepare_prpvf_out_buffer(priv);
> +		/* toggle IPU double-buffer index */
> +		priv->ipu_buf_num ^= 1;
> +	}
> +
> +unlock:
> +	spin_unlock_irqrestore(&priv->irqlock, flags);
> +	return IRQ_HANDLED;
> +}
> +

[snip]

> diff --git a/drivers/staging/media/imx/imx-ic.h b/drivers/staging/media/imx/imx-ic.h
> new file mode 100644
> index 0000000..9aed5f5
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx-ic.h
> @@ -0,0 +1,36 @@
> +/*
> + * V4L2 Image Converter Subdev for Freescale i.MX5/6 SOC
> + *
> + * Copyright (c) 2016 Mentor Graphics Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#ifndef _IMX_IC_H
> +#define _IMX_IC_H
> +

Please add header files or declarations of all used structs.

> +struct imx_ic_priv {
> +	struct device *dev;
> +	struct v4l2_subdev sd;
> +	int    ipu_id;
> +	int    task_id;
> +	void   *task_priv;
> +};
> +
> +struct imx_ic_ops {
> +	struct v4l2_subdev_ops *subdev_ops;
> +	struct v4l2_subdev_internal_ops *internal_ops;
> +	struct media_entity_operations *entity_ops;
> +
> +	int (*init)(struct imx_ic_priv *ic_priv);
> +	void (*remove)(struct imx_ic_priv *ic_priv);
> +};
> +
> +extern struct imx_ic_ops imx_ic_prpenc_ops;
> +extern struct imx_ic_ops imx_ic_prpvf_ops;
> +extern struct imx_ic_ops imx_ic_pp_ops;
> +
> +#endif
> +
> 

--
With best wishes,
Vladimir
