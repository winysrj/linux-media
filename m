Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:57046 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab0JTMZd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 08:25:33 -0400
Message-ID: <4CBEDFB5.9010001@infradead.org>
Date: Wed, 20 Oct 2010 10:25:25 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Daniel Drake <dsd@laptop.org>
CC: corbet@lwn.net, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] ov7670: allow configuration of image size, clock
 speed, and I/O method
References: <20101019212405.85C279D401B@zog.reactivated.net>
In-Reply-To: <20101019212405.85C279D401B@zog.reactivated.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 19-10-2010 19:24, Daniel Drake escreveu:
> These parameters need to be configurable based on the host system.
> They can now be communicated through the s_config call.
> 
> The old CONFIG_OLPC_XO_1 selector was not correct; this kind of
> arrangement wouldn't allow for a universal kernel that would work on both
> laptops.
> 
> Certain parts of the probe routine had to be moved later (into s_config),
> because we can't do any I/O until we know which I/O method has been
> selected through this mechanism.

Both patches 1 and 2 seem to be doing the right thing, passing the board-specific
parameters via s_config call.

ACK.

PS.: I'll wait for Jon's comments before merging it on my tree.

> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---
>  drivers/media/video/ov7670.c |  133 ++++++++++++++++++++++++++++++------------
>  drivers/media/video/ov7670.h |   20 ++++++
>  2 files changed, 115 insertions(+), 38 deletions(-)
>  create mode 100644 drivers/media/video/ov7670.h
> 
> diff --git a/drivers/media/video/ov7670.c b/drivers/media/video/ov7670.c
> index 0b78f33..c881a64 100644
> --- a/drivers/media/video/ov7670.c
> +++ b/drivers/media/video/ov7670.c
> @@ -20,6 +20,7 @@
>  #include <media/v4l2-chip-ident.h>
>  #include <media/v4l2-mediabus.h>
>  
> +#include "ov7670.h"
>  
>  MODULE_AUTHOR("Jonathan Corbet <corbet@lwn.net>");
>  MODULE_DESCRIPTION("A low-level driver for OmniVision ov7670 sensors");
> @@ -43,11 +44,6 @@ MODULE_PARM_DESC(debug, "Debug level (0-1)");
>  #define	QCIF_HEIGHT	144
>  
>  /*
> - * Our nominal (default) frame rate.
> - */
> -#define OV7670_FRAME_RATE 30
> -
> -/*
>   * The 7670 sits on i2c with ID 0x42
>   */
>  #define OV7670_I2C_ADDR 0x42
> @@ -198,7 +194,11 @@ struct ov7670_info {
>  	struct ov7670_format_struct *fmt;  /* Current format */
>  	unsigned char sat;		/* Saturation value */
>  	int hue;			/* Hue value */
> +	int min_width;			/* Filter out smaller sizes */
> +	int min_height;			/* Filter out smaller sizes */
> +	int clock_speed;		/* External clock speed (MHz) */
>  	u8 clkrc;			/* Clock divider value */
> +	bool use_smbus;			/* Use smbus I/O instead of I2C */
>  };
>  
>  static inline struct ov7670_info *to_state(struct v4l2_subdev *sd)
> @@ -415,8 +415,7 @@ static struct regval_list ov7670_fmt_raw[] = {
>   * ov7670 is not really an SMBUS device, though, so the communication
>   * is not always entirely reliable.
>   */
> -#ifdef CONFIG_OLPC_XO_1
> -static int ov7670_read(struct v4l2_subdev *sd, unsigned char reg,
> +static int ov7670_read_smbus(struct v4l2_subdev *sd, unsigned char reg,
>  		unsigned char *value)
>  {
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> @@ -431,7 +430,7 @@ static int ov7670_read(struct v4l2_subdev *sd, unsigned char reg,
>  }
>  
>  
> -static int ov7670_write(struct v4l2_subdev *sd, unsigned char reg,
> +static int ov7670_write_smbus(struct v4l2_subdev *sd, unsigned char reg,
>  		unsigned char value)
>  {
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> @@ -442,11 +441,10 @@ static int ov7670_write(struct v4l2_subdev *sd, unsigned char reg,
>  	return ret;
>  }
>  
> -#else /* ! CONFIG_OLPC_XO_1 */
>  /*
>   * On most platforms, we'd rather do straight i2c I/O.
>   */
> -static int ov7670_read(struct v4l2_subdev *sd, unsigned char reg,
> +static int ov7670_read_i2c(struct v4l2_subdev *sd, unsigned char reg,
>  		unsigned char *value)
>  {
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> @@ -479,7 +477,7 @@ static int ov7670_read(struct v4l2_subdev *sd, unsigned char reg,
>  }
>  
>  
> -static int ov7670_write(struct v4l2_subdev *sd, unsigned char reg,
> +static int ov7670_write_i2c(struct v4l2_subdev *sd, unsigned char reg,
>  		unsigned char value)
>  {
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> @@ -498,8 +496,26 @@ static int ov7670_write(struct v4l2_subdev *sd, unsigned char reg,
>  		msleep(5);  /* Wait for reset to run */
>  	return ret;
>  }
> -#endif /* CONFIG_OLPC_XO_1 */
>  
> +static int ov7670_read(struct v4l2_subdev *sd, unsigned char reg,
> +		unsigned char *value)
> +{
> +	struct ov7670_info *info = to_state(sd);
> +	if (info->use_smbus)
> +		return ov7670_read_smbus(sd, reg, value);
> +	else
> +		return ov7670_read_i2c(sd, reg, value);
> +}
> +
> +static int ov7670_write(struct v4l2_subdev *sd, unsigned char reg,
> +		unsigned char value)
> +{
> +	struct ov7670_info *info = to_state(sd);
> +	if (info->use_smbus)
> +		return ov7670_write_smbus(sd, reg, value);
> +	else
> +		return ov7670_write_i2c(sd, reg, value);
> +}
>  
>  /*
>   * Write a list of register settings; ff/ff stops the process.
> @@ -854,7 +870,7 @@ static int ov7670_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
>  	memset(cp, 0, sizeof(struct v4l2_captureparm));
>  	cp->capability = V4L2_CAP_TIMEPERFRAME;
>  	cp->timeperframe.numerator = 1;
> -	cp->timeperframe.denominator = OV7670_FRAME_RATE;
> +	cp->timeperframe.denominator = info->clock_speed;
>  	if ((info->clkrc & CLK_EXT) == 0 && (info->clkrc & CLK_SCALE) > 1)
>  		cp->timeperframe.denominator /= (info->clkrc & CLK_SCALE);
>  	return 0;
> @@ -875,14 +891,14 @@ static int ov7670_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
>  	if (tpf->numerator == 0 || tpf->denominator == 0)
>  		div = 1;  /* Reset to full rate */
>  	else
> -		div = (tpf->numerator*OV7670_FRAME_RATE)/tpf->denominator;
> +		div = (tpf->numerator * info->clock_speed) / tpf->denominator;
>  	if (div == 0)
>  		div = 1;
>  	else if (div > CLK_SCALE)
>  		div = CLK_SCALE;
>  	info->clkrc = (info->clkrc & 0x80) | div;
>  	tpf->numerator = 1;
> -	tpf->denominator = OV7670_FRAME_RATE/div;
> +	tpf->denominator = info->clock_speed / div;
>  	return ov7670_write(sd, REG_CLKRC, info->clkrc);
>  }
>  
> @@ -912,14 +928,30 @@ static int ov7670_enum_frameintervals(struct v4l2_subdev *sd,
>  static int ov7670_enum_framesizes(struct v4l2_subdev *sd,
>  		struct v4l2_frmsizeenum *fsize)
>  {
> +	struct ov7670_info *info = to_state(sd);
> +	int i;
> +	int num_valid = -1;
>  	__u32 index = fsize->index;
> -	if (index >= N_WIN_SIZES)
> -		return -EINVAL;
>  
> -	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
> -	fsize->discrete.width = ov7670_win_sizes[index].width;
> -	fsize->discrete.height = ov7670_win_sizes[index].height;
> -	return 0;
> +	/*
> +	 * If a minimum width/height was requested, filter out the capture
> +	 * windows that fall outside that.
> +	 */
> +	for (i = 0; i < N_WIN_SIZES; i++) {
> +		struct ov7670_win_size *win = &ov7670_win_sizes[index];
> +		if (info->min_width && win->width < info->min_width)
> +			continue;
> +		if (info->min_height && win->height < info->min_height)
> +			continue;
> +		if (index == ++num_valid) {
> +			fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
> +			fsize->discrete.width = win->width;
> +			fsize->discrete.height = win->height;
> +			return 0;
> +		}
> +	}
> +
> +	return -EINVAL;
>  }
>  
>  /*
> @@ -1417,6 +1449,47 @@ static int ov7670_g_chip_ident(struct v4l2_subdev *sd,
>  	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_OV7670, 0);
>  }
>  
> +static int ov7670_s_config(struct v4l2_subdev *sd, int dumb, void *data)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct ov7670_config *config = data;
> +	struct ov7670_info *info = to_state(sd);
> +	int ret;
> +
> +	info->clock_speed = 30; /* default: a guess */
> +
> +	/*
> +	 * Must apply configuration before initializing device, because it
> +	 * selects I/O method.
> +	 */
> +	if (config) {
> +		info->min_width = config->min_width;
> +		info->min_height = config->min_height;
> +		info->use_smbus = config->use_smbus;
> +
> +		if (config->clock_speed)
> +			info->clock_speed = config->clock_speed;
> +	}
> +
> +	/* Make sure it's an ov7670 */
> +	ret = ov7670_detect(sd);
> +	if (ret) {
> +		v4l_dbg(1, debug, client,
> +			"chip found @ 0x%x (%s) is not an ov7670 chip.\n",
> +			client->addr << 1, client->adapter->name);
> +		kfree(info);
> +		return ret;
> +	}
> +	v4l_info(client, "chip found @ 0x%02x (%s)\n",
> +			client->addr << 1, client->adapter->name);
> +
> +	info->fmt = &ov7670_formats[0];
> +	info->sat = 128;	/* Review this */
> +	info->clkrc = info->clock_speed / 30;
> +
> +	return 0;
> +}
> +
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>  static int ov7670_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
>  {
> @@ -1455,6 +1528,7 @@ static const struct v4l2_subdev_core_ops ov7670_core_ops = {
>  	.s_ctrl = ov7670_s_ctrl,
>  	.queryctrl = ov7670_queryctrl,
>  	.reset = ov7670_reset,
> +	.s_config = ov7670_s_config,
>  	.init = ov7670_init,
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>  	.g_register = ov7670_g_register,
> @@ -1484,7 +1558,6 @@ static int ov7670_probe(struct i2c_client *client,
>  {
>  	struct v4l2_subdev *sd;
>  	struct ov7670_info *info;
> -	int ret;
>  
>  	info = kzalloc(sizeof(struct ov7670_info), GFP_KERNEL);
>  	if (info == NULL)
> @@ -1492,22 +1565,6 @@ static int ov7670_probe(struct i2c_client *client,
>  	sd = &info->sd;
>  	v4l2_i2c_subdev_init(sd, client, &ov7670_ops);
>  
> -	/* Make sure it's an ov7670 */
> -	ret = ov7670_detect(sd);
> -	if (ret) {
> -		v4l_dbg(1, debug, client,
> -			"chip found @ 0x%x (%s) is not an ov7670 chip.\n",
> -			client->addr << 1, client->adapter->name);
> -		kfree(info);
> -		return ret;
> -	}
> -	v4l_info(client, "chip found @ 0x%02x (%s)\n",
> -			client->addr << 1, client->adapter->name);
> -
> -	info->fmt = &ov7670_formats[0];
> -	info->sat = 128;	/* Review this */
> -	info->clkrc = 1;	/* 30fps */
> -
>  	return 0;
>  }
>  
> diff --git a/drivers/media/video/ov7670.h b/drivers/media/video/ov7670.h
> new file mode 100644
> index 0000000..b133bc1
> --- /dev/null
> +++ b/drivers/media/video/ov7670.h
> @@ -0,0 +1,20 @@
> +/*
> + * A V4L2 driver for OmniVision OV7670 cameras.
> + *
> + * Copyright 2010 One Laptop Per Child
> + *
> + * This file may be distributed under the terms of the GNU General
> + * Public License, version 2.
> + */
> +
> +#ifndef __OV7670_H
> +#define __OV7670_H
> +
> +struct ov7670_config {
> +	int min_width;			/* Filter out smaller sizes */
> +	int min_height;			/* Filter out smaller sizes */
> +	int clock_speed;		/* External clock speed (MHz) */
> +	bool use_smbus;			/* Use smbus I/O instead of I2C */
> +};
> +
> +#endif

