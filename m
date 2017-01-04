Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:57672 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965382AbdADOzn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2017 09:55:43 -0500
Subject: Re: [PATCH v2 14/19] media: imx: Add Camera Interface subdev driver
To: Steve Longerbeam <slongerbeam@gmail.com>, <shawnguo@kernel.org>,
        <kernel@pengutronix.de>, <fabio.estevam@nxp.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <linux@armlinux.org.uk>, <mchehab@kernel.org>,
        <gregkh@linuxfoundation.org>, <p.zabel@pengutronix.de>
References: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
 <1483477049-19056-15-git-send-email-steve_longerbeam@mentor.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Message-ID: <4a893d70-f34a-9fb1-401f-bcb954e3a2cb@mentor.com>
Date: Wed, 4 Jan 2017 16:55:36 +0200
MIME-Version: 1.0
In-Reply-To: <1483477049-19056-15-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/03/2017 10:57 PM, Steve Longerbeam wrote:
> This is the camera interface driver that provides the v4l2
> user interface. Frames can be received from various sources:
> 
> - directly from SMFC for capturing unconverted images directly from
>   camera sensors.
> 
> - from the IC pre-process encode task.
> 
> - from the IC pre-process viewfinder task.
> 
> - from the IC post-process task.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/staging/media/imx/Makefile    |    2 +-
>  drivers/staging/media/imx/imx-camif.c | 1010 +++++++++++++++++++++++++++++++++
>  2 files changed, 1011 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/staging/media/imx/imx-camif.c
> 
> diff --git a/drivers/staging/media/imx/Makefile b/drivers/staging/media/imx/Makefile
> index d2a962c..fe9e992 100644
> --- a/drivers/staging/media/imx/Makefile
> +++ b/drivers/staging/media/imx/Makefile
> @@ -8,4 +8,4 @@ obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-ic.o
>  
>  obj-$(CONFIG_VIDEO_IMX_CAMERA) += imx-csi.o
>  obj-$(CONFIG_VIDEO_IMX_CAMERA) += imx-smfc.o
> -
> +obj-$(CONFIG_VIDEO_IMX_CAMERA) += imx-camif.o

obj-$(CONFIG_VIDEO_IMX_CAMERA) += imx-camif.o imx-csi.o imx-smfc.o

as an option.

> diff --git a/drivers/staging/media/imx/imx-camif.c b/drivers/staging/media/imx/imx-camif.c
> new file mode 100644
> index 0000000..3cf167e
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx-camif.c
> @@ -0,0 +1,1010 @@
> +/*
> + * Video Camera Capture Subdev for Freescale i.MX5/6 SOC
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
> +#include <linux/spinlock.h>
> +#include <linux/platform_device.h>
> +#include <linux/pinctrl/consumer.h>
> +#include <linux/of_platform.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-dma-contig.h>
> +#include <media/v4l2-subdev.h>
> +#include <media/v4l2-of.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-event.h>

Please sort the list of headers alphabetically.

> +#include <video/imx-ipu-v3.h>
> +#include <media/imx.h>
> +#include "imx-media.h"
> +
> +#define DEVICE_NAME "imx-media-camif"

I would propose to drop this macro.

> +
> +#define CAMIF_NUM_PADS 2
> +
> +#define CAMIF_DQ_TIMEOUT        5000

Add a comment about time unit?

> +
> +struct camif_priv;
> +

This is a leftover apparently.

> +struct camif_priv {
> +	struct device         *dev;
> +	struct video_device    vfd;
> +	struct media_pipeline  mp;
> +	struct imx_media_dev  *md;

[snip]

> +static int camif_probe(struct platform_device *pdev)
> +{
> +	struct imx_media_internal_sd_platformdata *pdata;
> +	struct camif_priv *priv;
> +	struct video_device *vfd;
> +	int ret;
> +
> +	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, priv);
> +	priv->dev = &pdev->dev;
> +
> +	pdata = priv->dev->platform_data;
> +
> +	mutex_init(&priv->mutex);
> +	spin_lock_init(&priv->q_lock);
> +
> +	v4l2_subdev_init(&priv->sd, &camif_subdev_ops);
> +	v4l2_set_subdevdata(&priv->sd, priv);
> +	priv->sd.internal_ops = &camif_internal_ops;
> +	priv->sd.entity.ops = &camif_entity_ops;
> +	priv->sd.entity.function = MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER;
> +	priv->sd.dev = &pdev->dev;
> +	priv->sd.owner = THIS_MODULE;
> +	/* get our group id and camif id */
> +	priv->sd.grp_id = pdata->grp_id;
> +	priv->id = (pdata->grp_id >> IMX_MEDIA_GRP_ID_CAMIF_BIT) - 1;
> +	strncpy(priv->sd.name, pdata->sd_name, sizeof(priv->sd.name));
> +	snprintf(camif_videodev.name, sizeof(camif_videodev.name),
> +		 "%s devnode", pdata->sd_name);
> +
> +	priv->sd.flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
> +
> +	vfd = &priv->vfd;
> +	*vfd = camif_videodev;
> +	vfd->lock = &priv->mutex;
> +	vfd->queue = &priv->buffer_queue;
> +
> +	video_set_drvdata(vfd, priv);
> +
> +	v4l2_ctrl_handler_init(&priv->ctrl_hdlr, 0);
> +
> +	ret = v4l2_async_register_subdev(&priv->sd);
> +	if (ret)
> +		goto free_ctrls;
> +
> +	return 0;
> +free_ctrls:
> +	v4l2_ctrl_handler_free(&priv->ctrl_hdlr);
> +	return ret;

A shorter version:

if (ret)
	v4l2_ctrl_handler_free(&priv->ctrl_hdlr);

return ret;

> +}
> +
> +static int camif_remove(struct platform_device *pdev)
> +{
> +	struct camif_priv *priv =
> +		(struct camif_priv *)platform_get_drvdata(pdev);
> +
> +	v4l2_ctrl_handler_free(&priv->ctrl_hdlr);
> +	v4l2_async_unregister_subdev(&priv->sd);
> +	media_entity_cleanup(&priv->sd.entity);
> +	v4l2_device_unregister_subdev(&priv->sd);
> +
> +	return 0;
> +}
> +
> +static const struct platform_device_id camif_ids[] = {
> +	{ .name = DEVICE_NAME },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(platform, camif_ids);
> +
> +static struct platform_driver imx_camif_driver = {
> +	.probe		= camif_probe,
> +	.remove		= camif_remove,
> +	.driver		= {
> +		.name	= DEVICE_NAME,
> +		.owner	= THIS_MODULE,

Please drop the owner assignment.

> +	},
> +};
> +
> +module_platform_driver(imx_camif_driver);
> +
> +MODULE_DESCRIPTION("i.MX camera interface subdev driver");
> +MODULE_AUTHOR("Steve Longerbeam <steve_longerbeam@mentor.com>");
> +MODULE_LICENSE("GPL");
> 

--
With best wishes,
Vladimir
