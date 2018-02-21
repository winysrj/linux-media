Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:49899 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751401AbeBUMIF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 07:08:05 -0500
Subject: Re: [PATCH v9 06/11] media: i2c: ov772x: Remove soc_camera
 dependencies
To: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, festevam@gmail.com,
        sakari.ailus@iki.fi, robh+dt@kernel.org, mark.rutland@arm.com,
        pombredanne@nexb.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1519059584-30844-1-git-send-email-jacopo+renesas@jmondi.org>
 <1519059584-30844-7-git-send-email-jacopo+renesas@jmondi.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d1f433c4-280c-bcfe-84a8-93767cb843a2@xs4all.nl>
Date: Wed, 21 Feb 2018 13:08:00 +0100
MIME-Version: 1.0
In-Reply-To: <1519059584-30844-7-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/19/18 17:59, Jacopo Mondi wrote:
> Remove soc_camera framework dependencies from ov772x sensor driver.
> - Handle clock and gpios
> - Register async subdevice
> - Remove soc_camera specific g/s_mbus_config operations
> - Change image format colorspace from JPEG to SRGB as the two use the
>   same colorspace information but JPEG makes assumptions on color
>   components quantization that do not apply to the sensor
> - Remove sizes crop from get_selection as driver can't scale
> - Add kernel doc to driver interface header file
> - Adjust build system
> 
> This commit does not remove the original soc_camera based driver as long
> as other platforms depends on soc_camera-based CEU driver.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/i2c/Kconfig  |  11 +++
>  drivers/media/i2c/Makefile |   1 +
>  drivers/media/i2c/ov772x.c | 172 ++++++++++++++++++++++++++++++---------------
>  include/media/i2c/ov772x.h |   6 +-
>  4 files changed, 133 insertions(+), 57 deletions(-)
> 
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index 9f18cd2..e71e968 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -645,6 +645,17 @@ config VIDEO_OV5670
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called ov5670.
>  
> +config VIDEO_OV772X
> +	tristate "OmniVision OV772x sensor support"
> +	depends on I2C && VIDEO_V4L2
> +	depends on MEDIA_CAMERA_SUPPORT
> +	---help---
> +	  This is a Video4Linux2 sensor-level driver for the OmniVision
> +	  OV772x camera.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called ov772x.
> +
>  config VIDEO_OV7640
>  	tristate "OmniVision OV7640 sensor support"
>  	depends on I2C && VIDEO_V4L2
> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> index c0f94cd..b0489a1 100644
> --- a/drivers/media/i2c/Makefile
> +++ b/drivers/media/i2c/Makefile
> @@ -68,6 +68,7 @@ obj-$(CONFIG_VIDEO_OV5670) += ov5670.o
>  obj-$(CONFIG_VIDEO_OV6650) += ov6650.o
>  obj-$(CONFIG_VIDEO_OV7640) += ov7640.o
>  obj-$(CONFIG_VIDEO_OV7670) += ov7670.o
> +obj-$(CONFIG_VIDEO_OV772X) += ov772x.o
>  obj-$(CONFIG_VIDEO_OV7740) += ov7740.o
>  obj-$(CONFIG_VIDEO_OV9650) += ov9650.o
>  obj-$(CONFIG_VIDEO_OV13858) += ov13858.o
> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> index 8063835..23106d7 100644
> --- a/drivers/media/i2c/ov772x.c
> +++ b/drivers/media/i2c/ov772x.c
> @@ -1,6 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * ov772x Camera Driver
>   *
> + * Copyright (C) 2017 Jacopo Mondi <jacopo+renesas@jmondi.org>
> + *
>   * Copyright (C) 2008 Renesas Solutions Corp.
>   * Kuninori Morimoto <morimoto.kuninori@renesas.com>
>   *
> @@ -9,27 +12,25 @@
>   * Copyright 2006-7 Jonathan Corbet <corbet@lwn.net>
>   * Copyright (C) 2008 Magnus Damm
>   * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
>   */
>  
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/gpio/consumer.h>
> +#include <linux/i2c.h>
>  #include <linux/init.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> -#include <linux/i2c.h>
>  #include <linux/slab.h>
> -#include <linux/delay.h>
>  #include <linux/v4l2-mediabus.h>
>  #include <linux/videodev2.h>
>  
>  #include <media/i2c/ov772x.h>
> -#include <media/soc_camera.h>
> -#include <media/v4l2-clk.h>
> +
>  #include <media/v4l2-ctrls.h>
> -#include <media/v4l2-subdev.h>
> +#include <media/v4l2-device.h>
>  #include <media/v4l2-image-sizes.h>
> +#include <media/v4l2-subdev.h>
>  
>  /*
>   * register offset
> @@ -393,8 +394,10 @@ struct ov772x_win_size {
>  struct ov772x_priv {
>  	struct v4l2_subdev                subdev;
>  	struct v4l2_ctrl_handler	  hdl;
> -	struct v4l2_clk			 *clk;
> +	struct clk			 *clk;
>  	struct ov772x_camera_info        *info;
> +	struct gpio_desc		 *pwdn_gpio;
> +	struct gpio_desc		 *rstb_gpio;
>  	const struct ov772x_color_format *cfmt;
>  	const struct ov772x_win_size     *win;
>  	unsigned short                    flag_vflip:1;
> @@ -409,7 +412,7 @@ struct ov772x_priv {
>  static const struct ov772x_color_format ov772x_cfmts[] = {
>  	{
>  		.code		= MEDIA_BUS_FMT_YUYV8_2X8,
> -		.colorspace	= V4L2_COLORSPACE_JPEG,
> +		.colorspace	= V4L2_COLORSPACE_SRGB,
>  		.dsp3		= 0x0,
>  		.dsp4		= DSP_OFMT_YUV,
>  		.com3		= SWAP_YUV,
> @@ -417,7 +420,7 @@ static const struct ov772x_color_format ov772x_cfmts[] = {
>  	},
>  	{
>  		.code		= MEDIA_BUS_FMT_YVYU8_2X8,
> -		.colorspace	= V4L2_COLORSPACE_JPEG,
> +		.colorspace	= V4L2_COLORSPACE_SRGB,
>  		.dsp3		= UV_ON,
>  		.dsp4		= DSP_OFMT_YUV,
>  		.com3		= SWAP_YUV,
> @@ -425,7 +428,7 @@ static const struct ov772x_color_format ov772x_cfmts[] = {
>  	},
>  	{
>  		.code		= MEDIA_BUS_FMT_UYVY8_2X8,
> -		.colorspace	= V4L2_COLORSPACE_JPEG,
> +		.colorspace	= V4L2_COLORSPACE_SRGB,
>  		.dsp3		= 0x0,
>  		.dsp4		= DSP_OFMT_YUV,
>  		.com3		= 0x0,
> @@ -550,7 +553,7 @@ static int ov772x_reset(struct i2c_client *client)
>  }
>  
>  /*
> - * soc_camera_ops function
> + * subdev ops
>   */
>  
>  static int ov772x_s_stream(struct v4l2_subdev *sd, int enable)
> @@ -650,13 +653,65 @@ static int ov772x_s_register(struct v4l2_subdev *sd,
>  }
>  #endif
>  
> +static int ov772x_power_on(struct ov772x_priv *priv)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
> +	int ret;
> +
> +	if (priv->clk) {
> +		ret = clk_prepare_enable(priv->clk);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (priv->pwdn_gpio) {
> +		gpiod_set_value(priv->pwdn_gpio, 1);
> +		usleep_range(500, 1000);
> +	}
> +
> +	/*
> +	 * FIXME: The reset signal is connected to a shared GPIO on some
> +	 * platforms (namely the SuperH Migo-R). Until a framework becomes
> +	 * available to handle this cleanly, request the GPIO temporarily
> +	 * to avoid conflicts.
> +	 */
> +	priv->rstb_gpio = gpiod_get_optional(&client->dev, "rstb",
> +					     GPIOD_OUT_LOW);
> +	if (IS_ERR(priv->rstb_gpio)) {
> +		dev_info(&client->dev, "Unable to get GPIO \"rstb\"");
> +		return PTR_ERR(priv->rstb_gpio);
> +	}
> +
> +	if (priv->rstb_gpio) {
> +		gpiod_set_value(priv->rstb_gpio, 1);
> +		usleep_range(500, 1000);
> +		gpiod_set_value(priv->rstb_gpio, 0);
> +		usleep_range(500, 1000);
> +
> +		gpiod_put(priv->rstb_gpio);
> +	}
> +
> +	return 0;
> +}
> +
> +static int ov772x_power_off(struct ov772x_priv *priv)
> +{
> +	clk_disable_unprepare(priv->clk);
> +
> +	if (priv->pwdn_gpio) {
> +		gpiod_set_value(priv->pwdn_gpio, 0);
> +		usleep_range(500, 1000);
> +	}
> +
> +	return 0;
> +}
> +
>  static int ov772x_s_power(struct v4l2_subdev *sd, int on)
>  {
> -	struct i2c_client *client = v4l2_get_subdevdata(sd);
> -	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
>  	struct ov772x_priv *priv = to_ov772x(sd);
>  
> -	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
> +	return on ? ov772x_power_on(priv) :
> +		    ov772x_power_off(priv);
>  }
>  
>  static const struct ov772x_win_size *ov772x_select_win(u32 width, u32 height)
> @@ -855,6 +910,8 @@ static int ov772x_get_selection(struct v4l2_subdev *sd,
>  		struct v4l2_subdev_pad_config *cfg,
>  		struct v4l2_subdev_selection *sel)
>  {
> +	struct ov772x_priv *priv = to_ov772x(sd);
> +
>  	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
>  		return -EINVAL;
>  
> @@ -863,12 +920,9 @@ static int ov772x_get_selection(struct v4l2_subdev *sd,
>  	switch (sel->target) {
>  	case V4L2_SEL_TGT_CROP_BOUNDS:
>  	case V4L2_SEL_TGT_CROP_DEFAULT:
> -		sel->r.width = OV772X_MAX_WIDTH;
> -		sel->r.height = OV772X_MAX_HEIGHT;
> -		return 0;
>  	case V4L2_SEL_TGT_CROP:
> -		sel->r.width = VGA_WIDTH;
> -		sel->r.height = VGA_HEIGHT;
> +		sel->r.width = priv->win->rect.width;
> +		sel->r.height = priv->win->rect.height;
>  		return 0;
>  	default:
>  		return -EINVAL;
> @@ -914,6 +968,9 @@ static int ov772x_set_fmt(struct v4l2_subdev *sd,
>  	mf->height = win->rect.height;
>  	mf->field = V4L2_FIELD_NONE;
>  	mf->colorspace = cfmt->colorspace;
> +	mf->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
> +	mf->quantization = V4L2_QUANTIZATION_DEFAULT;
> +	mf->xfer_func = V4L2_XFER_FUNC_DEFAULT;
>  
>  	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
>  		cfg->try_fmt = *mf;
> @@ -997,24 +1054,8 @@ static int ov772x_enum_mbus_code(struct v4l2_subdev *sd,
>  	return 0;
>  }
>  
> -static int ov772x_g_mbus_config(struct v4l2_subdev *sd,
> -				struct v4l2_mbus_config *cfg)
> -{
> -	struct i2c_client *client = v4l2_get_subdevdata(sd);
> -	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
> -
> -	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
> -		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
> -		V4L2_MBUS_DATA_ACTIVE_HIGH;
> -	cfg->type = V4L2_MBUS_PARALLEL;
> -	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
> -
> -	return 0;
> -}
> -
>  static const struct v4l2_subdev_video_ops ov772x_subdev_video_ops = {
>  	.s_stream	= ov772x_s_stream,
> -	.g_mbus_config	= ov772x_g_mbus_config,
>  };
>  
>  static const struct v4l2_subdev_pad_ops ov772x_subdev_pad_ops = {
> @@ -1038,12 +1079,11 @@ static int ov772x_probe(struct i2c_client *client,
>  			const struct i2c_device_id *did)
>  {
>  	struct ov772x_priv	*priv;
> -	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
> -	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
> +	struct i2c_adapter	*adapter = client->adapter;
>  	int			ret;
>  
> -	if (!ssdd || !ssdd->drv_priv) {
> -		dev_err(&client->dev, "OV772X: missing platform data!\n");
> +	if (!client->dev.platform_data) {
> +		dev_err(&client->dev, "Missing ov772x platform data\n");
>  		return -EINVAL;
>  	}
>  
> @@ -1059,7 +1099,7 @@ static int ov772x_probe(struct i2c_client *client,
>  	if (!priv)
>  		return -ENOMEM;
>  
> -	priv->info = ssdd->drv_priv;
> +	priv->info = client->dev.platform_data;
>  
>  	v4l2_i2c_subdev_init(&priv->subdev, client, &ov772x_subdev_ops);
>  	v4l2_ctrl_handler_init(&priv->hdl, 3);
> @@ -1073,22 +1113,42 @@ static int ov772x_probe(struct i2c_client *client,
>  	if (priv->hdl.error)
>  		return priv->hdl.error;
>  
> -	priv->clk = v4l2_clk_get(&client->dev, "mclk");
> +	priv->clk = clk_get(&client->dev, "xclk");
>  	if (IS_ERR(priv->clk)) {
> +		dev_err(&client->dev, "Unable to get xclk clock\n");
>  		ret = PTR_ERR(priv->clk);
> -		goto eclkget;
> +		goto error_ctrl_free;
>  	}
>  
> -	ret = ov772x_video_probe(priv);
> -	if (ret < 0) {
> -		v4l2_clk_put(priv->clk);
> -eclkget:
> -		v4l2_ctrl_handler_free(&priv->hdl);
> -	} else {
> -		priv->cfmt = &ov772x_cfmts[0];
> -		priv->win = &ov772x_win_sizes[0];
> +	priv->pwdn_gpio = gpiod_get_optional(&client->dev, "pwdn",
> +					     GPIOD_OUT_LOW);
> +	if (IS_ERR(priv->pwdn_gpio)) {
> +		dev_info(&client->dev, "Unable to get GPIO \"pwdn\"");
> +		ret = PTR_ERR(priv->pwdn_gpio);
> +		goto error_clk_put;
>  	}
>  
> +	ret = ov772x_video_probe(priv);
> +	if (ret < 0)
> +		goto error_gpio_put;
> +
> +	priv->cfmt = &ov772x_cfmts[0];
> +	priv->win = &ov772x_win_sizes[0];
> +
> +	ret = v4l2_async_register_subdev(&priv->subdev);
> +	if (ret)
> +		goto error_gpio_put;
> +
> +	return 0;
> +
> +error_gpio_put:
> +	if (priv->pwdn_gpio)
> +		gpiod_put(priv->pwdn_gpio);
> +error_clk_put:
> +	clk_put(priv->clk);
> +error_ctrl_free:
> +	v4l2_ctrl_handler_free(&priv->hdl);
> +
>  	return ret;
>  }
>  
> @@ -1096,7 +1156,9 @@ static int ov772x_remove(struct i2c_client *client)
>  {
>  	struct ov772x_priv *priv = to_ov772x(i2c_get_clientdata(client));
>  
> -	v4l2_clk_put(priv->clk);
> +	clk_put(priv->clk);
> +	if (priv->pwdn_gpio)
> +		gpiod_put(priv->pwdn_gpio);
>  	v4l2_device_unregister_subdev(&priv->subdev);
>  	v4l2_ctrl_handler_free(&priv->hdl);
>  	return 0;
> @@ -1119,6 +1181,6 @@ static struct i2c_driver ov772x_i2c_driver = {
>  
>  module_i2c_driver(ov772x_i2c_driver);
>  
> -MODULE_DESCRIPTION("SoC Camera driver for ov772x");
> +MODULE_DESCRIPTION("V4L2 driver for OV772x image sensor");
>  MODULE_AUTHOR("Kuninori Morimoto");
>  MODULE_LICENSE("GPL v2");
> diff --git a/include/media/i2c/ov772x.h b/include/media/i2c/ov772x.h
> index 00dbb7c..27d087b 100644
> --- a/include/media/i2c/ov772x.h
> +++ b/include/media/i2c/ov772x.h
> @@ -48,8 +48,10 @@ struct ov772x_edge_ctrl {
>  	.threshold = (t & OV772X_EDGE_THRESHOLD_MASK),	\
>  }
>  
> -/*
> - * ov772x camera info
> +/**
> + * ov772x_camera_info -	ov772x driver interface structure
> + * @flags:		Sensor configuration flags
> + * @edgectrl:		Sensor edge control
>   */
>  struct ov772x_camera_info {

This really should be ov772x_platform_data instead of ov772x_camera_info.
This can be changed in a follow-up patch.

For this patch:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

>  	unsigned long		flags;
> 
