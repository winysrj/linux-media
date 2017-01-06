Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36503 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032204AbdAFSe7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2017 13:34:59 -0500
Subject: Re: [PATCH v2 13/19] media: imx: Add IC subdev drivers
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        shawnguo@kernel.org, kernel@pengutronix.de, fabio.estevam@nxp.com,
        robh+dt@kernel.org, mark.rutland@arm.com, linux@armlinux.org.uk,
        mchehab@kernel.org, gregkh@linuxfoundation.org,
        p.zabel@pengutronix.de
References: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
 <1483477049-19056-14-git-send-email-steve_longerbeam@mentor.com>
 <96684048-c5ad-3e64-0fbc-61dcaf184519@mentor.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <b5bd5807-2db4-8677-0891-11ad74c1de7f@gmail.com>
Date: Fri, 6 Jan 2017 10:34:56 -0800
MIME-Version: 1.0
In-Reply-To: <96684048-c5ad-3e64-0fbc-61dcaf184519@mentor.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/04/2017 06:48 AM, Vladimir Zapolskiy wrote:
> On 01/03/2017 10:57 PM, Steve Longerbeam wrote:
>
>> +
>> +	ret = ic_ops[priv->task_id]->init(priv);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = v4l2_async_register_subdev(&priv->sd);
>> +	if (ret)
>> +		goto remove;
>> +
>> +	return 0;
>> +remove:
>> +	ic_ops[priv->task_id]->remove(priv);
>> +	return ret;
> if (ret)
> 	ic_ops[priv->task_id]->remove(priv);
>
> return ret;
>
> as an alternative.

done.

>
>
> +
> +static struct platform_driver imx_ic_driver = {
> +	.probe = imx_ic_probe,
> +	.remove = imx_ic_remove,
> +	.id_table = imx_ic_ids,
> +	.driver = {
> +		.name = "imx-ipuv3-ic",
> +		.owner = THIS_MODULE,
> Please drop .owner assignment.

done.

>> diff --git a/drivers/staging/media/imx/imx-ic-pp.c b/drivers/staging/media/imx/imx-ic-pp.c
>> new file mode 100644
>> index 0000000..5ef0581
>> --- /dev/null
>> +++ b/drivers/staging/media/imx/imx-ic-pp.c
>> @@ -0,0 +1,636 @@
>> +/*
>> + * V4L2 IC Post-Processor Subdev for Freescale i.MX5/6 SOC
>> + *
>> + * Copyright (c) 2014-2016 Mentor Graphics Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +#include <linux/module.h>
>> +#include <linux/delay.h>
>> +#include <linux/fs.h>
>> +#include <linux/timer.h>
>> +#include <linux/sched.h>
>> +#include <linux/slab.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/pinctrl/consumer.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-ioctl.h>
>> +#include <media/videobuf2-dma-contig.h>
>> +#include <media/v4l2-subdev.h>
>> +#include <media/v4l2-of.h>
>> +#include <media/v4l2-ctrls.h>
> Please sort the list of headers alphabetically.

done.

>
>>
>> +
>> +	priv->out_run = kzalloc(IMX_MEDIA_MAX_RING_BUFS *
>> +				sizeof(*priv->out_run), GFP_KERNEL);
>> +	if (!priv->out_run) {
>> +		v4l2_err(&ic_priv->sd, "failed to alloc src ring runs\n");
> In OOM situation the core will report it, probably you can drop the message.

with a backtrace? I can't remember, if not I'd like to keep this.

>> diff --git a/drivers/staging/media/imx/imx-ic-prpenc.c b/drivers/staging/media/imx/imx-ic-prpenc.c
>> new file mode 100644
>> index 0000000..e17216b
>> --- /dev/null
>> +++ b/drivers/staging/media/imx/imx-ic-prpenc.c
>> @@ -0,0 +1,1037 @@
>> +/*
>> + * V4L2 Capture IC Encoder Subdev for Freescale i.MX5/6 SOC
>> + *
>> + * This subdevice handles capture of video frames from the CSI, which
>> + * are routed directly to the Image Converter preprocess encode task,
>> + * for resizing, colorspace conversion, and rotation.
>> + *
>> + * Copyright (c) 2012-2016 Mentor Graphics Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +#include <linux/module.h>
>> +#include <linux/delay.h>
>> +#include <linux/fs.h>
>> +#include <linux/timer.h>
>> +#include <linux/sched.h>
>> +#include <linux/slab.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/spinlock.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/pinctrl/consumer.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-ioctl.h>
>> +#include <media/videobuf2-dma-contig.h>
>> +#include <media/v4l2-subdev.h>
>> +#include <media/v4l2-of.h>
>> +#include <media/v4l2-ctrls.h>
> Please sort the list of headers alphabetically.

done.

>
>> +static irqreturn_t prpenc_eof_interrupt(int irq, void *dev_id)
>> +{
>> +	struct prpenc_priv *priv = dev_id;
>> +	struct imx_media_dma_buf *done, *next;
>> +	struct ipuv3_channel *channel;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&priv->irqlock, flags);
> Here spin_lock(&priv->irqlock) should be sufficient.

done.

>> +
>> +	ret = media_entity_pads_init(&sd->entity, PRPENC_NUM_PADS, priv->pad);
>> +	if (ret)
>> +		goto free_ctrls;
>> +
>> +	return 0;
>> +free_ctrls:
>> +	v4l2_ctrl_handler_free(&priv->ctrl_hdlr);
>> +	return ret;
> if (ret)
> 	v4l2_ctrl_handler_free(&priv->ctrl_hdlr);
>
> return ret;
>
> version is shorter.

done.

>
> diff --git a/drivers/staging/media/imx/imx-ic-prpvf.c 
> b/drivers/staging/media/imx/imx-ic-prpvf.c
>> new file mode 100644
>> index 0000000..53ce006
>> --- /dev/null
>> +++ b/drivers/staging/media/imx/imx-ic-prpvf.c
>> @@ -0,0 +1,1180 @@
>> +/*
>> + * V4L2 IC Deinterlacer Subdev for Freescale i.MX5/6 SOC
>> + *
>> + * Copyright (c) 2014-2016 Mentor Graphics Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +#include <linux/module.h>
>> +#include <linux/delay.h>
>> +#include <linux/fs.h>
>> +#include <linux/timer.h>
>> +#include <linux/sched.h>
>> +#include <linux/slab.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/pinctrl/consumer.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-ioctl.h>
>> +#include <media/videobuf2-dma-contig.h>
>> +#include <media/v4l2-subdev.h>
>> +#include <media/v4l2-of.h>
>> +#include <media/v4l2-ctrls.h>
> Please sort the list of headers alphabetically.

done.

>
>> +/* prpvf_out_ch EOF interrupt (progressive frame ready) */
>> +static irqreturn_t prpvf_out_eof_interrupt(int irq, void *dev_id)
>> +{
>> +	struct prpvf_priv *priv = dev_id;
>> +	struct imx_media_dma_buf *done;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&priv->irqlock, flags);
>
> Here spin_lock(&priv->irqlock) should be sufficient.

done.

>
>> diff --git a/drivers/staging/media/imx/imx-ic.h b/drivers/staging/media/imx/imx-ic.h
>> new file mode 100644
>> index 0000000..9aed5f5
>> --- /dev/null
>> +++ b/drivers/staging/media/imx/imx-ic.h
>> @@ -0,0 +1,36 @@
>> +/*
>> + * V4L2 Image Converter Subdev for Freescale i.MX5/6 SOC
>> + *
>> + * Copyright (c) 2016 Mentor Graphics Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +#ifndef _IMX_IC_H
>> +#define _IMX_IC_H
>> +
> Please add header files or declarations of all used structs.

done (it only needs v4l2-subdev.h).

Steve





