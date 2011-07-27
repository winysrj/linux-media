Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58212 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab1G0Rem (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 13:34:42 -0400
Received: by ewy4 with SMTP id 4so1419612ewy.19
        for <linux-media@vger.kernel.org>; Wed, 27 Jul 2011 10:34:41 -0700 (PDT)
Message-ID: <4E304C2C.6070505@gmail.com>
Date: Wed, 27 Jul 2011 19:34:36 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, javier.martin@vista-silicon.com,
	shotty317@gmail.com
Subject: Re: [PATCH] mt9p031: Aptina (Micron) MT9P031 5MP sensor driver
References: <CACKLOr1veNZ_6E3V_m1Tf+mxxUAKiRKDbboW-fMbRGUrLns_XA@mail.gmail.com> <1311757981-6968-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1311757981-6968-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent, Javier,

On 07/27/2011 11:13 AM, Laurent Pinchart wrote:
> From: Javier Martin<javier.martin@vista-silicon.com>
> 
> The MT9P031 is a parallel 12-bit 5MP sensor from Aptina (formerly
> Micron) controlled through I2C.
> 
> The driver creates a V4L2 subdevice. It currently supports skipping,
> cropping, automatic binning, and gain, exposure, h/v flip and test
> pattern controls.
> 
> Signed-off-by: Javier Martin<javier.martin@vista-silicon.com>
> Signed-off-by: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
> ---
>   drivers/media/video/Kconfig   |    7 +
>   drivers/media/video/Makefile  |    1 +
>   drivers/media/video/mt9p031.c |  961 +++++++++++++++++++++++++++++++++++++++++
>   include/media/mt9p031.h       |   19 +
>   4 files changed, 988 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/media/video/mt9p031.c
>   create mode 100644 include/media/mt9p031.h
> 
> Hi Javier,
> 
> I've finally been able to spend some time on your MT9P031 driver, and here is
> the result. I would like to push the driver to mainline for v3.2. Could you
> please review it ?
> 
> I still need to have a look at the PLL code to see if we can compute the PLL
> registers values at runtime instead of using a table-based approach.
> 
> BTW, do you plan to maintain the driver ?
> 
...
> diff --git a/drivers/media/video/mt9p031.c b/drivers/media/video/mt9p031.c
> new file mode 100644
> index 0000000..18e9a3c
> --- /dev/null
> +++ b/drivers/media/video/mt9p031.c
> @@ -0,0 +1,961 @@
> +/*
> + * Driver for MT9P031 CMOS Image Sensor from Aptina
> + *
> + * Copyright (C) 2011, Laurent Pinchart<laurent.pinchart@ideasonboard.com>
> + * Copyright (C) 2011, Javier Martin<javier.martin@vista-silicon.com>
> + * Copyright (C) 2011, Guennadi Liakhovetski<g.liakhovetski@gmx.de>
> + *
> + * Based on the MT9V032 driver and Bastian Hecht's code.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +

...

> +
> +struct mt9p031 {
> +	struct v4l2_subdev subdev;
> +	struct media_pad pad;
> +	struct v4l2_rect crop;  /* Sensor window */
> +	struct v4l2_mbus_framefmt format;
> +	struct v4l2_ctrl_handler ctrls;
> +	struct mt9p031_platform_data *pdata;
> +	struct mutex power_lock; /* lock to protect power_count */
> +	int power_count;
> +	u16 xskip;
> +	u16 yskip;
> +	u32 ext_freq;
> +	/* pll dividers */
> +	u8 m;
> +	u8 n;
> +	u8 p1;
> +
> +	/* Registers cache */
> +	u16 output_control;
> +	u16 mode2;
> +};

...

> +/* -----------------------------------------------------------------------------
> + * Driver initialization and probing
> + */
> +
> +static int mt9p031_probe(struct i2c_client *client,
> +				const struct i2c_device_id *did)
> +{
> +	struct mt9p031_platform_data *pdata = client->dev.platform_data;
> +	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
> +	struct mt9p031 *mt9p031;
> +	unsigned int i;
> +	int ret;
> +
> +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
> +		dev_warn(&adapter->dev,
> +			"I2C-Adapter doesn't support I2C_FUNC_SMBUS_WORD\n");
> +		return -EIO;
> +	}
> +
> +	mt9p031 = kzalloc(sizeof(*mt9p031), GFP_KERNEL);
> +	if (mt9p031 == NULL)
> +		return -ENOMEM;
> +
> +	mt9p031->pdata = pdata;
> +	mt9p031->output_control	= MT9P031_OUTPUT_CONTROL_DEF;
> +	mt9p031->mode2 = MT9P031_READ_MODE_2_ROW_BLC;
> +
> +	v4l2_ctrl_handler_init(&mt9p031->ctrls, ARRAY_SIZE(mt9p031_ctrls) + 4);
> +
> +	v4l2_ctrl_new_std(&mt9p031->ctrls,&mt9p031_ctrl_ops,
> +			  V4L2_CID_EXPOSURE, MT9P031_SHUTTER_WIDTH_MIN,
> +			  MT9P031_SHUTTER_WIDTH_MAX, 1,
> +			  MT9P031_SHUTTER_WIDTH_DEF);
> +	v4l2_ctrl_new_std(&mt9p031->ctrls,&mt9p031_ctrl_ops,
> +			  V4L2_CID_GAIN, MT9P031_GLOBAL_GAIN_MIN,
> +			  MT9P031_GLOBAL_GAIN_MAX, 1, MT9P031_GLOBAL_GAIN_DEF);
> +	v4l2_ctrl_new_std(&mt9p031->ctrls,&mt9p031_ctrl_ops,
> +			  V4L2_CID_HFLIP, 0, 1, 1, 0);
> +	v4l2_ctrl_new_std(&mt9p031->ctrls,&mt9p031_ctrl_ops,
> +			  V4L2_CID_VFLIP, 0, 1, 1, 0);
> +
> +	for (i = 0; i<  ARRAY_SIZE(mt9p031_ctrls); ++i)
> +		v4l2_ctrl_new_custom(&mt9p031->ctrls,&mt9p031_ctrls[i], NULL);
> +
> +	mt9p031->subdev.ctrl_handler =&mt9p031->ctrls;
> +
> +	if (mt9p031->ctrls.error)
> +		printk(KERN_INFO "%s: control initialization error %d\n",
> +		       __func__, mt9p031->ctrls.error);
> +
> +	mutex_init(&mt9p031->power_lock);
> +	v4l2_i2c_subdev_init(&mt9p031->subdev, client,&mt9p031_subdev_ops);
> +	mt9p031->subdev.internal_ops =&mt9p031_subdev_internal_ops;
> +
> +	mt9p031->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	ret = media_entity_init(&mt9p031->subdev.entity, 1,&mt9p031->pad, 0);
> +	if (ret<  0)
> +		goto done;
> +
> +	mt9p031->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +	mt9p031->crop.width = MT9P031_WINDOW_WIDTH_DEF;
> +	mt9p031->crop.height = MT9P031_WINDOW_HEIGHT_DEF;
> +	mt9p031->crop.left = MT9P031_COLUMN_START_DEF;
> +	mt9p031->crop.top = MT9P031_ROW_START_DEF;
> +
> +	if (mt9p031->pdata->version == MT9P031_MONOCHROME_VERSION)
> +		mt9p031->format.code = V4L2_MBUS_FMT_Y12_1X12;
> +	else
> +		mt9p031->format.code = V4L2_MBUS_FMT_SGRBG12_1X12;
> +
> +	mt9p031->format.width = MT9P031_WINDOW_WIDTH_DEF;
> +	mt9p031->format.height = MT9P031_WINDOW_HEIGHT_DEF;
> +	mt9p031->format.field = V4L2_FIELD_NONE;
> +	mt9p031->format.colorspace = V4L2_COLORSPACE_SRGB;
> +
> +	ret = mt9p031_pll_get_divs(mt9p031);
> +
> +done:
> +	if (ret<  0)

It seems there is a v4l2_ctrl_handler_free() missing here...

> +		kfree(mt9p031);
> +
> +	return ret;
> +}
> +
> +static int mt9p031_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
> +	struct mt9p031 *mt9p031 = to_mt9p031(subdev);
> +
> +	v4l2_device_unregister_subdev(subdev);
> +	media_entity_cleanup(&subdev->entity);

... and here.

> +	kfree(mt9p031);
> +
> +	return 0;
> +}

--
Regards,
Sylwester

