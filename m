Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:45889 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965493AbdADNok (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2017 08:44:40 -0500
Subject: Re: [PATCH v2 11/19] media: imx: Add CSI subdev driver
To: Steve Longerbeam <slongerbeam@gmail.com>, <shawnguo@kernel.org>,
        <kernel@pengutronix.de>, <fabio.estevam@nxp.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <linux@armlinux.org.uk>, <mchehab@kernel.org>,
        <gregkh@linuxfoundation.org>, <p.zabel@pengutronix.de>
References: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
 <1483477049-19056-12-git-send-email-steve_longerbeam@mentor.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Message-ID: <21b54a7b-1254-a14f-767c-c92feed7433d@mentor.com>
Date: Wed, 4 Jan 2017 15:44:33 +0200
MIME-Version: 1.0
In-Reply-To: <1483477049-19056-12-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/03/2017 10:57 PM, Steve Longerbeam wrote:
> This is a media entity subdevice for the i.MX Camera
> Serial Interface module.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---

[snip]

> diff --git a/drivers/staging/media/imx/imx-csi.c b/drivers/staging/media/imx/imx-csi.c
> new file mode 100644
> index 0000000..975eafb
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx-csi.c
> @@ -0,0 +1,638 @@
> +/*
> + * V4L2 Capture CSI Subdev for Freescale i.MX5/6 SOC
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
> +#include <media/videobuf2-dma-contig.h>
> +#include <media/v4l2-of.h>
> +#include <media/v4l2-ctrls.h>

Please add the headers alphabetically ordered.

> +#include <video/imx-ipu-v3.h>
> +#include "imx-media.h"
> +
> +#define CSI_NUM_PADS 2
> +
> +struct csi_priv {
> +	struct device *dev;
> +	struct ipu_soc *ipu;
> +	struct imx_media_dev *md;
> +	struct v4l2_subdev sd;
> +	struct media_pad pad[CSI_NUM_PADS];
> +	struct v4l2_mbus_framefmt format_mbus[CSI_NUM_PADS];
> +	struct v4l2_mbus_config sensor_mbus_cfg;
> +	struct v4l2_rect crop;
> +	struct ipu_csi *csi;
> +	int csi_id;
> +	int input_pad;
> +	int output_pad;
> +	bool power_on;  /* power is on */
> +	bool stream_on; /* streaming is on */
> +
> +	/* the sink for the captured frames */
> +	struct v4l2_subdev *sink_sd;
> +	enum ipu_csi_dest dest;
> +	struct v4l2_subdev *src_sd;
> +
> +	struct v4l2_ctrl_handler ctrl_hdlr;
> +	struct imx_media_fim *fim;
> +
> +	/* the attached sensor at stream on */
> +	struct imx_media_subdev *sensor;
> +};
> +
> +static inline struct csi_priv *sd_to_dev(struct v4l2_subdev *sdev)
> +{
> +	return container_of(sdev, struct csi_priv, sd);
> +}
> +
> +/* Update the CSI whole sensor and active windows */
> +static int csi_setup(struct csi_priv *priv)
> +{
> +	struct v4l2_mbus_framefmt infmt;
> +
> +	ipu_csi_set_window(priv->csi, &priv->crop);
> +
> +	/*
> +	 * the ipu-csi doesn't understand ALTERNATE, but it only
> +	 * needs to know whether the stream is interlaced, so set
> +	 * to INTERLACED if infmt field is ALTERNATE.
> +	 */
> +	infmt = priv->format_mbus[priv->input_pad];
> +	if (infmt.field == V4L2_FIELD_ALTERNATE)
> +		infmt.field = V4L2_FIELD_INTERLACED;
> +
> +	ipu_csi_init_interface(priv->csi, &priv->sensor_mbus_cfg, &infmt);
> +
> +	ipu_csi_set_dest(priv->csi, priv->dest);
> +
> +	ipu_csi_dump(priv->csi);
> +
> +	return 0;
> +}
> +
> +static int csi_start(struct csi_priv *priv)
> +{
> +	int ret;
> +
> +	if (!priv->sensor) {
> +		v4l2_err(&priv->sd, "no sensor attached\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = csi_setup(priv);
> +	if (ret)
> +		return ret;
> +
> +	/* start the frame interval monitor */
> +	ret = imx_media_fim_set_stream(priv->fim, priv->sensor, true);
> +	if (ret)
> +		return ret;
> +
> +	ret = ipu_csi_enable(priv->csi);
> +	if (ret) {
> +		v4l2_err(&priv->sd, "CSI enable error: %d\n", ret);
> +		return ret;
> +	}
> +
> +	return 0;

if (ret)
	v4l2_err(&priv->sd, "CSI enable error: %d\n", ret);

return ret;

> +}
> +
> +static void csi_stop(struct csi_priv *priv)
> +{
> +	/* stop the frame interval monitor */
> +	imx_media_fim_set_stream(priv->fim, priv->sensor, false);
> +
> +	ipu_csi_disable(priv->csi);
> +}
> +
> +static int csi_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct csi_priv *priv = v4l2_get_subdevdata(sd);
> +	int ret = 0;
> +
> +	if (!priv->src_sd || !priv->sink_sd)
> +		return -EPIPE;
> +
> +	v4l2_info(sd, "stream %s\n", enable ? "ON" : "OFF");
> +
> +	if (enable && !priv->stream_on)
> +		ret = csi_start(priv);
> +	else if (!enable && priv->stream_on)
> +		csi_stop(priv);
> +
> +	if (!ret)
> +		priv->stream_on = enable;
> +	return ret;
> +}
> +
> +static int csi_s_power(struct v4l2_subdev *sd, int on)
> +{
> +	struct csi_priv *priv = v4l2_get_subdevdata(sd);
> +	int ret = 0;
> +
> +	v4l2_info(sd, "power %s\n", on ? "ON" : "OFF");
> +
> +	if (on != priv->power_on)
> +		ret = imx_media_fim_set_power(priv->fim, on);
> +
> +	if (!ret)
> +		priv->power_on = on;
> +	return ret;
> +}
> +
> +static int csi_link_setup(struct media_entity *entity,
> +			  const struct media_pad *local,
> +			  const struct media_pad *remote, u32 flags)
> +{
> +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
> +	struct csi_priv *priv = v4l2_get_subdevdata(sd);
> +	struct v4l2_subdev *remote_sd;
> +
> +	dev_dbg(priv->dev, "link setup %s -> %s", remote->entity->name,
> +		local->entity->name);
> +
> +	remote_sd = media_entity_to_v4l2_subdev(remote->entity);
> +
> +	if (local->flags & MEDIA_PAD_FL_SINK) {
> +		if (flags & MEDIA_LNK_FL_ENABLED) {
> +			if (priv->src_sd)
> +				return -EBUSY;
> +			priv->src_sd = remote_sd;
> +		} else {
> +			priv->src_sd = NULL;
> +			return 0;

You can remove the return above.

> +		}
> +
> +		return 0;
> +	}
> +

[snip]

> +
> +static int imx_csi_probe(struct platform_device *pdev)
> +{
> +	struct ipu_client_platformdata *pdata;
> +	struct csi_priv *priv;
> +	int ret;
> +
> +	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, &priv->sd);
> +	priv->dev = &pdev->dev;
> +
> +	/* get parent IPU */
> +	priv->ipu = dev_get_drvdata(priv->dev->parent);
> +
> +	/* get our CSI id */
> +	pdata = priv->dev->platform_data;
> +	priv->csi_id = pdata->csi;
> +
> +	v4l2_subdev_init(&priv->sd, &csi_subdev_ops);
> +	v4l2_set_subdevdata(&priv->sd, priv);
> +	priv->sd.internal_ops = &csi_internal_ops;
> +	priv->sd.entity.ops = &csi_entity_ops;
> +	/* FIXME: this the right function? */
> +	priv->sd.entity.function = MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER;
> +	priv->sd.grp_id = priv->csi_id ?
> +		IMX_MEDIA_GRP_ID_CSI1 : IMX_MEDIA_GRP_ID_CSI0;
> +	priv->sd.dev = &pdev->dev;
> +	priv->sd.owner = THIS_MODULE;
> +	priv->sd.flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
> +	imx_media_grp_id_to_sd_name(priv->sd.name, sizeof(priv->sd.name),
> +				    priv->sd.grp_id, ipu_get_num(priv->ipu));
> +
> +	v4l2_ctrl_handler_init(&priv->ctrl_hdlr, 0);
> +	priv->sd.ctrl_handler = &priv->ctrl_hdlr;
> +
> +	ret = v4l2_async_register_subdev(&priv->sd);
> +	if (ret)
> +		goto free_ctrls;
> +
> +	return 0;
> +free_ctrls:
> +	v4l2_ctrl_handler_free(&priv->ctrl_hdlr);
> +	return ret;

This is a functionally equal and simplified version:

if (ret)
	v4l2_ctrl_handler_free(&priv->ctrl_hdlr);

return ret;

> +}
> +
> +static int imx_csi_remove(struct platform_device *pdev)
> +{
> +	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
> +	struct csi_priv *priv = sd_to_dev(sd);
> +
> +	imx_media_fim_free(priv->fim);
> +	v4l2_async_unregister_subdev(&priv->sd);
> +	media_entity_cleanup(&priv->sd.entity);
> +	v4l2_device_unregister_subdev(sd);
> +
> +	if (!IS_ERR_OR_NULL(priv->csi))
> +		ipu_csi_put(priv->csi);
> +
> +	return 0;
> +}
> +
> +static const struct platform_device_id imx_csi_ids[] = {
> +	{ .name = "imx-ipuv3-csi" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(platform, imx_csi_ids);
> +
> +static struct platform_driver imx_csi_driver = {
> +	.probe = imx_csi_probe,
> +	.remove = imx_csi_remove,
> +	.id_table = imx_csi_ids,
> +	.driver = {
> +		.name = "imx-ipuv3-csi",
> +		.owner = THIS_MODULE,

Please drop .owner.

> +	},
> +};
> +module_platform_driver(imx_csi_driver);
> +
> +MODULE_DESCRIPTION("i.MX CSI subdev driver");
> +MODULE_AUTHOR("Steve Longerbeam <steve_longerbeam@mentor.com>");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:imx-ipuv3-csi");
> 

--
With best wishes,
Vladimir
