Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:46103 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab3DWEjW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Apr 2013 00:39:22 -0400
Received: by mail-la0-f53.google.com with SMTP id eg20so170572lab.12
        for <linux-media@vger.kernel.org>; Mon, 22 Apr 2013 21:39:20 -0700 (PDT)
Message-ID: <5176104B.7000401@cogentembedded.com>
Date: Tue, 23 Apr 2013 08:38:35 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Katsuya MATSUBARA <matsu@igel.co.jp>
CC: g.liakhovetski@gmx.de, mchehab@redhat.com,
	linux-media@vger.kernel.org, magnus.damm@gmail.com,
	linux-sh@vger.kernel.org, phil.edworthy@renesas.com,
	vladimir.barinov@cogentembedded.com, mukawa@igel.co.jp
Subject: Re: [PATCH v2 1/4] V4L2: soc_camera: Renesas R-Car VIN driver
References: <201304200231.31802.sergei.shtylyov@cogentembedded.com> <20130423.120834.239982915.matsu@igel.co.jp>
In-Reply-To: <20130423.120834.239982915.matsu@igel.co.jp>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 04/23/2013 07:08 AM, Katsuya MATSUBARA wrote:

> Hi Sergei,
>
> Thanks for the patch.

    It's not mine. :-)

>
>> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
>>
>> Add Renesas R-Car VIN (Video In) V4L2 driver.
>>
>> Based on the patch by Phil Edworthy <phil.edworthy@renesas.com>.
>>
>> Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
>> [Sergei: removed deprecated IRQF_DISABLED flag.]
>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

[...]

>> Index: renesas/drivers/media/platform/soc_camera/rcar_vin.c
>> ===================================================================
>> --- /dev/null
>> +++ renesas/drivers/media/platform/soc_camera/rcar_vin.c
>> @@ -0,0 +1,1784 @@
>> +/*
>> + * SoC-camera host driver for Renesas R-Car VIN unit
>> + *
>> + * Copyright (C) 2011-2013 Renesas Solutions Corp.
>> + * Copyright (C) 2013 Cogent Embedded, Inc., <source@cogentembedded.com>
>> + *
>> + * Based on V4L2 Driver for SuperH Mobile CEU interface "sh_mobile_ceu_camera.c"
>> + *
>> + * Copyright (C) 2008 Magnus Damm
>> + *
>> + * This program is free software; you can redistribute  it and/or modify it
>> + * under  the terms of  the GNU General  Public License as published by the
>> + * Free Software Foundation;  either version 2 of the  License, or (at your
>> + * option) any later version.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/slab.h>
>> +#include <linux/delay.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/pm_runtime.h>
>> +#include <linux/platform_data/camera-rcar.h>
>> +
>> +#include <media/videobuf2-dma-contig.h>
>> +#include <media/soc_camera.h>
>> +#include <media/soc_mediabus.h>
>> +
>> +#define DRV_NAME "rcar_vin"
>> +
>> +/* Register offsets for R-óar VIN */
> Are you using a 2-byte character in the string 'R-Car'?

    Hm, you have surprised me: indeed KMail chose UTF-8 and, even worse,
quoted-printable encoding. I played some with the settings, let's see what
will it do...

[...]

>
>> +
>> +/* Register bit fields for R-óar VIN */
> s/R-óar/R-Car/

     Sorry, I see no difference. :-)

>
>> +
>> +#define is_continuous_transfer(priv)	(priv->vb_count > MAX_BUFFER_NUM ? \
>> +					 true : false)
>> +

[...]

>> +
>> +	/* Number of hardware slots */
>> +	if (priv->vb_count > MAX_BUFFER_NUM)
> You can use the is_continuous_transfer() macro here.

    You're right.

[...]

>
>> +
>> +	/* input interface */
>> +	switch (icd->current_fmt->code) {
>> +	case V4L2_MBUS_FMT_YUYV8_1X16:
>> +		/* BT.601/BT.1358 16bit YCbCr422 */
>> +		vnmc |= VNMC_INF_YUV16;
>> +		input_is_yuv = 1;
>> +		break;
>> +	case V4L2_MBUS_FMT_YUYV8_2X8:
>> +		input_is_yuv = 1;
>> +		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
>> +		vnmc |= priv->pdata->flags & RCAR_VIN_BT656 ?
>> +			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
>> +	default:
>> +		break;
>> +	}
> Does this (first) implemenation unsupport RGB inputs yet
> though the h/w supports them?

    Yes, we have only tested BT.601/656 input.

> If so, 'is_input_yuv' could be useless since it must
> be set to 1 in any case.

    The *default* label doesn't set it, does it?

>
>> +
>> +	/* output format */
>> +	switch (icd->current_fmt->host_fmt->fourcc) {
>> +	case V4L2_PIX_FMT_NV16:
>> +		iowrite32(((cam->width * cam->height) + 0x7f) & ~0x7f,
>> +			  priv->base + VNUVAOF_REG);
>> +		dmr = VNDMR_DTMD_YCSEP;
>> +		output_is_yuv = 1;
>> +		break;
>> +	case V4L2_PIX_FMT_YUYV:
>> +		dmr = VNDMR_BPSM;
>> +		output_is_yuv = 1;
>> +		break;
>> +	case V4L2_PIX_FMT_UYVY:
>> +		dmr = 0;
>> +		output_is_yuv = 1;
>> +		break;
>> +	case V4L2_PIX_FMT_RGB555X:
>> +		dmr = VNDMR_DTMD_ARGB1555;
>> +		break;
>> +	case V4L2_PIX_FMT_RGB565:
>> +		dmr = 0;
>> +		break;
>> +	case V4L2_PIX_FMT_RGB32:
>> +		dmr = VNDMR_EXRGB;
>> +		break;
> VIN in R8A7778(R-CarM1A) does not support the RGB32 output,
> but R8A7779(R-CarH1) and uPD35004(R-CarE1) ones support it.

    Indeed...

>
>> +
>> +	if (!priv->request_to_stop) {
>> +		if (is_continuous_transfer(priv))
>> +			slot = (ioread32(priv->base + VNMS_REG) &
>> +				VNMS_FBS_MASK) >> VNMS_FBS_SHIFT;
>> +		else
>> +			slot = 0;
>> +
>> +		priv->queue_buf[slot]->v4l2_buf.field = priv->field;
>> +		priv->queue_buf[slot]->v4l2_buf.sequence = priv->sequence++;
>> +		do_gettimeofday(&priv->queue_buf[slot]->v4l2_buf.timestamp);
>> +		vb2_buffer_done(priv->queue_buf[slot], VB2_BUF_STATE_DONE);
>> +		priv->queue_buf[slot] = NULL;
>> +
>> +		if (priv->state != STOPPING)
>> +			can_run = rcar_vin_fill_hw_slot(priv);
>> +
>> +		if (hw_stopped || !can_run)
>> +			priv->state = STOPPED;
> The continuous capturing should require an explicit stop
> operation when there is no buffer to be set into the MBx
> register because the h/w can keep running even if no more
> buffers are supplied.

     Understood. I'll defer this to Vladimir though...

>
>> +/* rect is guaranteed to not exceed the scaled camera rectangle */
>> +static int rcar_vin_set_rect(struct soc_camera_device *icd)
>> +{
>> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>> +	struct rcar_vin_cam *cam = icd->host_priv;
>> +	struct rcar_vin_priv *priv = ici->priv;
>> +	unsigned int left_offset, top_offset;
>> +	unsigned char dsize;
>> +	struct v4l2_rect *cam_subrect = &cam->subrect;
>> +
>> +	dev_dbg(icd->parent, "Crop %ux%u@%u:%u\n",
>> +		icd->user_width, icd->user_height, cam->vin_left, cam->vin_top);
>> +
>> +	left_offset = cam->vin_left;
>> +	top_offset = cam->vin_top;
>> +
>> +	dsize = priv->data_through ? true : false;
>> +
>> +	dev_dbg(icd->parent, "Cam %ux%u@%u:%u\n",
>> +		cam->width, cam->height, cam->vin_left, cam->vin_top);
>> +	dev_dbg(icd->parent, "Cam subrect %ux%u@%u:%u\n",
>> +		cam_subrect->width, cam_subrect->height,
>> +		cam_subrect->left, cam_subrect->top);
>> +
>> +	/* Set Start/End Pixel/Line Pre-Clip */
>> +	iowrite32(left_offset << dsize, priv->base + VNSPPRC_REG);
>> +	iowrite32((left_offset + cam->width - 1) << dsize,
>> +		  priv->base + VNEPPRC_REG);
> The 'data through' mode could exist only in R-CarE1's VIN.
> So values for clipping do not have to be doubled
> in case of M1A and H1.

     Ideed, seems so. I'll defer this to Vladimir...

> > +
> > +	data_through = pixfmt == V4L2_PIX_FMT_RGB32;
> > +	can_scale = !data_through && pixfmt != V4L2_PIX_FMT_NV16;
> As mentioned above, there must be no such restriction for scaling
> in case of M1A and H1.

    OK.

>
>> Index: renesas/include/linux/platform_data/camera-rcar.h
>> ===================================================================
>> --- /dev/null
>> +++ renesas/include/linux/platform_data/camera-rcar.h
>> @@ -0,0 +1,25 @@
>> +/*
>> + * Platform data for Renesas R-Car VIN soc-camera driver
>> + *
>> + * Copyright (C) 2011-2013 Renesas Solutions Corp.
>> + * Copyright (C) 2013 Cogent Embedded, Inc., <source@cogentembedded.com>
>> + *
>> + * This program is free software; you can redistribute  it and/or modify it
>> + * under  the terms of  the GNU General  Public License as published by the
>> + * Free Software Foundation;  either version 2 of the  License, or (at your
>> + * option) any later version.
>> + */
>> +
>> +#ifndef __CAMERA_RCAR_H_
>> +#define __CAMERA_RCAR_H_
>> +
>> +#define RCAR_VIN_HSYNC_ACTIVE_LOW	(1 << 0)
>> +#define RCAR_VIN_VSYNC_ACTIVE_LOW	(1 << 1)
>> +#define RCAR_VIN_BT601			(1 << 2)
>> +#define RCAR_VIN_BT656			(1 << 3)
>> +
>> +struct rcar_vin_platform_data {
>> +	unsigned int flags;
>> +};
>> +
>> +#endif /* __CAMERA_RCAR_H_ */
> I am concern that there could be some difference of VIN
> functionalities that I mentioned above in between R-Car SoC series;
> uPD35004(R-CarE1), R8A7778(R-CarM1A), and R8A7779(R-CarH1).
> Some flags can be added for the platform data to let the driver
> know such the difference.

    Platform data flags is not the best solution for this case.
The driver should instead match on several device names.
It should be possible with the platform devices.

PS: I'll be thankful to you if in the future you cut out the parts of the
patch you're not replying to, not to have me scrolling the large
mail for your remarks, and cutting out the unrelated code myself.

WBR, Sergei

