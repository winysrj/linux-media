Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:52308 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031021AbdADOXy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2017 09:23:54 -0500
Subject: Re: [PATCH v2 12/19] media: imx: Add SMFC subdev driver
To: Steve Longerbeam <slongerbeam@gmail.com>, <shawnguo@kernel.org>,
        <kernel@pengutronix.de>, <fabio.estevam@nxp.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <linux@armlinux.org.uk>, <mchehab@kernel.org>,
        <gregkh@linuxfoundation.org>, <p.zabel@pengutronix.de>
References: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
 <1483477049-19056-13-git-send-email-steve_longerbeam@mentor.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Message-ID: <13ff9579-ce8e-9272-ee44-9b597631f6b5@mentor.com>
Date: Wed, 4 Jan 2017 16:23:47 +0200
MIME-Version: 1.0
In-Reply-To: <1483477049-19056-13-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/03/2017 10:57 PM, Steve Longerbeam wrote:
> This is a media entity subdevice driver for the i.MX Sensor Multi-FIFO
> Controller module. Video frames are received from the CSI and can
> be routed to various sinks including the i.MX Image Converter for
> scaling, color-space conversion, motion compensated deinterlacing,
> and image rotation.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/staging/media/imx/Makefile   |   1 +
>  drivers/staging/media/imx/imx-smfc.c | 739 +++++++++++++++++++++++++++++++++++
>  2 files changed, 740 insertions(+)
>  create mode 100644 drivers/staging/media/imx/imx-smfc.c
> 
> diff --git a/drivers/staging/media/imx/Makefile b/drivers/staging/media/imx/Makefile
> index 133672a..3559d7b 100644
> --- a/drivers/staging/media/imx/Makefile
> +++ b/drivers/staging/media/imx/Makefile
> @@ -5,4 +5,5 @@ obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media.o
>  obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media-common.o
>  
>  obj-$(CONFIG_VIDEO_IMX_CAMERA) += imx-csi.o
> +obj-$(CONFIG_VIDEO_IMX_CAMERA) += imx-smfc.o

May be

obj-$(CONFIG_VIDEO_IMX_CAMERA) += imx-csi.o imx-smfc.o

>  
> diff --git a/drivers/staging/media/imx/imx-smfc.c b/drivers/staging/media/imx/imx-smfc.c
> new file mode 100644
> index 0000000..565048c
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx-smfc.c
> @@ -0,0 +1,739 @@
> +/*
> + * V4L2 Capture SMFC Subdev for Freescale i.MX5/6 SOC
> + *
> + * This subdevice handles capture of raw/unconverted video frames
> + * from the CSI, directly to memory via the Sensor Multi-FIFO Controller.
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
> +

[snip]

> +static irqreturn_t imx_smfc_eof_interrupt(int irq, void *dev_id)
> +{
> +	struct imx_smfc_priv *priv = dev_id;
> +	struct imx_media_dma_buf *done, *next;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&priv->irqlock, flags);

spin_lock(&priv->irqlock) should be sufficient.

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
> +	if (ipu_idmac_buffer_is_ready(priv->smfc_ch, priv->ipu_buf_num))
> +		ipu_idmac_clear_buffer(priv->smfc_ch, priv->ipu_buf_num);
> +
> +	/* get next queued buffer */
> +	next = imx_media_dma_buf_get_next_queued(priv->out_ring);
> +
> +	ipu_cpmem_set_buffer(priv->smfc_ch, priv->ipu_buf_num, next->phys);
> +	ipu_idmac_select_buffer(priv->smfc_ch, priv->ipu_buf_num);
> +
> +	/* toggle IPU double-buffer index */
> +	priv->ipu_buf_num ^= 1;
> +	priv->next = next;
> +
> +unlock:
> +	spin_unlock_irqrestore(&priv->irqlock, flags);
> +	return IRQ_HANDLED;
> +}
> +

[snip]

> +
> +static const struct platform_device_id imx_smfc_ids[] = {
> +	{ .name = "imx-ipuv3-smfc" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(platform, imx_smfc_ids);
> +
> +static struct platform_driver imx_smfc_driver = {
> +	.probe = imx_smfc_probe,
> +	.remove = imx_smfc_remove,
> +	.id_table = imx_smfc_ids,
> +	.driver = {
> +		.name = "imx-ipuv3-smfc",
> +		.owner = THIS_MODULE,

You can drop owner assignment.

> +	},
> +};
> +module_platform_driver(imx_smfc_driver);
> +
> +MODULE_DESCRIPTION("i.MX SMFC subdev driver");
> +MODULE_AUTHOR("Steve Longerbeam <steve_longerbeam@mentor.com>");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:imx-ipuv3-smfc");
> 

--
With best wishes,
Vladimir
