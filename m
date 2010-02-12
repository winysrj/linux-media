Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4556 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab0BLLxB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2010 06:53:01 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pete Eberlein <pete@sensoray.com>
Subject: Re: [PATCH 4/5]
Date: Fri, 12 Feb 2010 12:55:09 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1265934800.4626.253.camel@pete-desktop>
In-Reply-To: <1265934800.4626.253.camel@pete-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201002121255.09862.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 12 February 2010 01:33:20 Pete Eberlein wrote:
> From: Pete Eberlein <pete@sensoray.com>
> 
> This is a subdev conversion of wis-tw9903 video decoder from the
> staging go7007 directory.  This obsoletes the wis-tw9903 driver.

Review below...

> 
> Priority: normal
> 
> Signed-off-by: Pete Eberlein <pete@sensoray.com>
> 
> diff -r 024987c00f06 -r 378d3bc9a3d6 linux/drivers/media/video/Kconfig
> --- a/linux/drivers/media/video/Kconfig	Thu Feb 11 14:34:39 2010 -0800
> +++ b/linux/drivers/media/video/Kconfig	Thu Feb 11 14:48:26 2010 -0800
> @@ -374,6 +374,12 @@
>  	---help---
>  	  Support for the Techwell 2804 video decoder.
>  
> +config VIDEO_TW9903
> +	tristate "Techwell 9903 video decoder"
> +	depends on VIDEO_V4L2 && I2C
> +	---help---
> +	  Support for the Techwell 9903 video decoder.
> +
>  config VIDEO_TVP514X
>  	tristate "Texas Instruments TVP514x video decoder"
>  	depends on VIDEO_V4L2 && I2C
> diff -r 024987c00f06 -r 378d3bc9a3d6 linux/drivers/media/video/Makefile
> --- a/linux/drivers/media/video/Makefile	Thu Feb 11 14:34:39 2010 -0800
> +++ b/linux/drivers/media/video/Makefile	Thu Feb 11 14:48:26 2010 -0800
> @@ -72,6 +72,7 @@
>  obj-$(CONFIG_VIDEO_TVEEPROM) += tveeprom.o
>  obj-$(CONFIG_VIDEO_MT9V011) += mt9v011.o
>  obj-$(CONFIG_VIDEO_TW2804) += tw2804.o
> +obj-$(CONFIG_VIDEO_TW9903) += tw9903.o
>  
>  obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
>  obj-$(CONFIG_SOC_CAMERA_MT9M111)	+= mt9m111.o
> diff -r 024987c00f06 -r 378d3bc9a3d6 linux/drivers/media/video/tw9903.c
> --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
> +++ b/linux/drivers/media/video/tw9903.c	Thu Feb 11 14:48:26 2010 -0800
> @@ -0,0 +1,370 @@
> +/*
> + * Copyright (C) 2005-2006 Micronas USA Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License (Version 2) as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software Foundation,
> + * Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/i2c.h>
> +#include <linux/videodev2.h>
> +#include <linux/ioctl.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-i2c-drv.h>
> +
> +MODULE_DESCRIPTION("TW9903 I2C subdev driver");
> +MODULE_LICENSE("GPL v2");
> +
> +struct tw9903 {
> +	struct v4l2_subdev sd;
> +	v4l2_std_id norm;
> +	int brightness;
> +	int contrast;
> +#if 0 /* keep */
> +	int saturation;
> +#endif
> +	int hue;
> +};
> +
> +static inline struct tw9903 *to_state(struct v4l2_subdev *sd)
> +{
> +	return container_of(sd, struct tw9903, sd);
> +}
> +
> +static u8 initial_registers[] =

const

> +{
> +	0x02, 0x44, /* input 1, composite */
> +	0x03, 0x92, /* correct digital format */
> +	0x04, 0x00,
> +	0x05, 0x80, /* or 0x00 for PAL */
> +	0x06, 0x40, /* second internal current reference */
> +	0x07, 0x02, /* window */
> +	0x08, 0x14, /* window */
> +	0x09, 0xf0, /* window */
> +	0x0a, 0x81, /* window */
> +	0x0b, 0xd0, /* window */
> +	0x0c, 0x8c,
> +	0x0d, 0x00, /* scaling */
> +	0x0e, 0x11, /* scaling */
> +	0x0f, 0x00, /* scaling */
> +	0x10, 0x00, /* brightness */
> +	0x11, 0x60, /* contrast */
> +	0x12, 0x01, /* sharpness */
> +	0x13, 0x7f, /* U gain */
> +	0x14, 0x5a, /* V gain */
> +	0x15, 0x00, /* hue */
> +	0x16, 0xc3, /* sharpness */
> +	0x18, 0x00,
> +	0x19, 0x58, /* vbi */
> +	0x1a, 0x80,
> +	0x1c, 0x0f, /* video norm */
> +	0x1d, 0x7f, /* video norm */
> +	0x20, 0xa0, /* clamping gain (working 0x50) */
> +	0x21, 0x22,
> +	0x22, 0xf0,
> +	0x23, 0xfe,
> +	0x24, 0x3c,
> +	0x25, 0x38,
> +	0x26, 0x44,
> +	0x27, 0x20,
> +	0x28, 0x00,
> +	0x29, 0x15,
> +	0x2a, 0xa0,
> +	0x2b, 0x44,
> +	0x2c, 0x37,
> +	0x2d, 0x00,
> +	0x2e, 0xa5, /* burst PLL control (working: a9) */
> +	0x2f, 0xe0, /* 0xea is blue test frame -- 0xe0 for normal */
> +	0x31, 0x00,
> +	0x33, 0x22,
> +	0x34, 0x11,
> +	0x35, 0x35,
> +	0x3b, 0x05,
> +	0x06, 0xc0, /* reset device */
> +	0x00, 0x00, /* Terminator (reg 0x00 is read-only) */
> +};
> +
> +static int write_reg(struct v4l2_subdev *sd, u8 reg, u8 value)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +	return i2c_smbus_write_byte_data(client, reg, value);
> +}
> +
> +static int write_regs(struct v4l2_subdev *sd, u8 *regs)
> +{
> +	int i;
> +
> +	for (i = 0; regs[i] != 0x00; i += 2)
> +		if (write_reg(sd, regs[i], regs[i + 1]) < 0)
> +			return -1;
> +	return 0;
> +}
> +
> +static int tw9903_s_video_routing(struct v4l2_subdev *sd, u32 input,
> +				      u32 output, u32 config)
> +{
> +	write_reg(sd, 0x02, 0x40 | (input << 1));
> +	return 0;
> +}
> +
> +#if 0 /* keep */
> +   /* The scaler on this thing seems to be horribly broken */
> +	case DECODER_SET_RESOLUTION:
> +	{
> +		struct video_decoder_resolution *res = arg;
> +		/*int hscale = 256 * 720 / res->width;*/
> +		int hscale = 256 * 720 / (res->width - (res->width > 704 ? 0 : 8));
> +		int vscale = 256 * (dec->norm & V4L2_STD_NTSC ?  240 : 288)
> +				/ res->height;
> +		u8 regs[] = {
> +			0x0d, vscale & 0xff,
> +			0x0f, hscale & 0xff,
> +			0x0e, ((vscale & 0xf00) >> 4) | ((hscale & 0xf00) >> 8),
> +			0x06, 0xc0, /* reset device */
> +			0,	0,
> +		};
> +		printk(KERN_DEBUG "vscale is %04x, hscale is %04x\n",
> +				vscale, hscale);
> +		/*write_regs(client, regs);*/
> +		break;
> +	}
> +#endif
> +
> +static int tw9903_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
> +{
> +	struct tw9903 *dec = to_state(sd);
> +	u8 regs[] = {
> +		0x05, norm & V4L2_STD_NTSC ? 0x80 : 0x00,
> +		0x07, norm & V4L2_STD_NTSC ? 0x02 : 0x12,
> +		0x08, norm & V4L2_STD_NTSC ? 0x14 : 0x18,
> +		0x09, norm & V4L2_STD_NTSC ? 0xf0 : 0x20,
> +		0,	0,
> +	};

Use two const arrays and select the right one in the next line.

> +	write_regs(sd, regs);
> +	dec->norm = norm;
> +	return 0;
> +}
> +
> +static int tw9903_queryctrl(struct v4l2_subdev *sd,
> +				 struct v4l2_queryctrl *query)
> +{
> +	static const u32 user_ctrls[] = {
> +		V4L2_CID_BRIGHTNESS,
> +		V4L2_CID_CONTRAST,
> +		V4L2_CID_SATURATION,
> +		V4L2_CID_HUE,
> +		0
> +	};
> +	static const u32 *ctrl_classes[] = {
> +		user_ctrls,
> +		NULL
> +	};
> +
> +	query->id = v4l2_ctrl_next(ctrl_classes, query->id);

v4l2_ctrl_next not needed in i2c drivers.

> +	switch (query->id) {
> +	case V4L2_CID_BRIGHTNESS:
> +		return v4l2_ctrl_query_fill(query, -128, 127, 1, 0);
> +	case V4L2_CID_CONTRAST:
> +		return v4l2_ctrl_query_fill(query, 0, 255, 1, 0x60);
> +#if 0 /* keep */
> +	/* I don't understand how the Chroma Gain registers work... */
> +	case V4L2_CID_SATURATION:
> +		return v4l2_ctrl_query_fill(query, 0, 127, 1, 64);
> +#endif
> +	case V4L2_CID_HUE:
> +		return v4l2_ctrl_query_fill(query, -128, 127, 1, 0);
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +
> +static int tw9903_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> +{
> +	struct tw9903 *dec = to_state(sd);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_BRIGHTNESS:
> +		if (ctrl->value > 127)
> +			dec->brightness = 127;
> +		else if (ctrl->value < -128)
> +			dec->brightness = -128;
> +		else
> +			dec->brightness = ctrl->value;
> +		write_reg(sd, 0x10, dec->brightness);
> +		break;
> +	case V4L2_CID_CONTRAST:
> +		if (ctrl->value > 255)
> +			dec->contrast = 255;
> +		else if (ctrl->value < 0)
> +			dec->contrast = 0;
> +		else
> +			dec->contrast = ctrl->value;
> +		write_reg(sd, 0x11, dec->contrast);
> +		break;
> +#if 0 /* keep */
> +	case V4L2_CID_SATURATION:
> +		if (ctrl->value > 127)
> +			dec->saturation = 127;
> +		else if (ctrl->value < 0)
> +			dec->saturation = 0;
> +		else
> +			dec->saturation = ctrl->value;
> +		/*write_reg(sd, 0x0c, dec->saturation);*/
> +		break;
> +#endif
> +	case V4L2_CID_HUE:
> +		if (ctrl->value > 127)
> +			dec->hue = 127;
> +		else if (ctrl->value < -128)
> +			dec->hue = -128;
> +		else
> +			dec->hue = ctrl->value;
> +		write_reg(sd, 0x15, dec->hue);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static int tw9903_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> +{
> +	struct tw9903 *dec = to_state(sd);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_BRIGHTNESS:
> +		ctrl->value = dec->brightness;
> +		break;
> +	case V4L2_CID_CONTRAST:
> +		ctrl->value = dec->contrast;
> +		break;
> +#if 0 /* keep */
> +	case V4L2_CID_SATURATION:
> +		ctrl->value = dec->saturation;
> +		break;
> +#endif
> +	case V4L2_CID_HUE:
> +		ctrl->value = dec->hue;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static int tw9903_log_status(struct v4l2_subdev *sd)
> +{
> +	struct tw9903 *dec = to_state(sd);
> +
> +	v4l2_info(sd, "Standard: %s\n", dec->norm == V4L2_STD_NTSC ? "NTSC" :
> +					dec->norm == V4L2_STD_PAL ? "PAL" :
> +					dec->norm == V4L2_STD_SECAM ? "SECAM" :
> +					"unknown");
> +	v4l2_info(sd, "Brightness: %d\n", dec->brightness);
> +	v4l2_info(sd, "Contrast: %d\n", dec->contrast);
> +#if 0 /* keep */
> +	v4l2_info(sd, "Saturation: %d\n", dec->saturation);
> +#endif
> +	v4l2_info(sd, "Hue: %d\n", dec->hue);
> +	return 0;
> +}
> +
> +/* --------------------------------------------------------------------------*/
> +
> +static const struct v4l2_subdev_core_ops tw9903_core_ops = {
> +	.log_status = tw9903_log_status,
> +	.g_ctrl = tw9903_g_ctrl,
> +	.s_ctrl = tw9903_s_ctrl,
> +	.queryctrl = tw9903_queryctrl,
> +	.s_std = tw9903_s_std,
> +};
> +
> +static const struct v4l2_subdev_video_ops tw9903_video_ops = {
> +	.s_routing = tw9903_s_video_routing,
> +};
> +
> +static const struct v4l2_subdev_ops tw9903_ops = {
> +	.core = &tw9903_core_ops,
> +	.video = &tw9903_video_ops,
> +};
> +
> +/* --------------------------------------------------------------------------*/
> +
> +static int tw9903_probe(struct i2c_client *client,
> +			     const struct i2c_device_id *id)
> +{
> +	struct tw9903 *dec;
> +	struct v4l2_subdev *sd;
> +
> +	/* Check if the adapter supports the needed features */
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
> +		return -EIO;
> +
> +	v4l2_info(client, "initializing TW9903 at address 0x%x on %s\n",
> +		client->addr, client->adapter->name);

Use this instead:

        v4l_info(client, "chip found @ 0x%x (%s)\n",
                        client->addr << 1, client->adapter->name);


> +
> +	dec = kmalloc(sizeof(struct tw9903), GFP_KERNEL);

kzalloc

> +	if (dec == NULL)
> +		return -ENOMEM;
> +	sd = &dec->sd;
> +	v4l2_i2c_subdev_init(sd, client, &tw9903_ops);
> +
> +	/* Initialize tw9903 */
> +	dec->norm = V4L2_STD_NTSC;
> +	dec->brightness = 0;
> +	dec->contrast = 0x60;
> +#if 0 /* keep */
> +	dec->saturation = 64;
> +#endif
> +	dec->hue = 0;
> +
> +	if (write_regs(sd, initial_registers) < 0) {
> +		v4l2_err(client, "error initializing TW9903\n");
> +		kfree(dec);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int tw9903_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +
> +	v4l2_device_unregister_subdev(sd);
> +	kfree(to_state(sd));
> +	return 0;
> +}
> +
> +/* ----------------------------------------------------------------------- */
> +
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
> +static const struct i2c_device_id tw9903_id[] = {
> +	{ "tw9903", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, tw9903_id);
> +#endif
> +
> +static struct v4l2_i2c_driver_data v4l2_i2c_data = {
> +	.name = "tw9903",
> +	.probe = tw9903_probe,
> +	.remove = tw9903_remove,
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
> +	.id_table = tw9903_id,
> +#endif
> +};
> diff -r 024987c00f06 -r 378d3bc9a3d6 linux/drivers/staging/go7007/go7007-usb.c
> --- a/linux/drivers/staging/go7007/go7007-usb.c	Thu Feb 11 14:34:39 2010 -0800
> +++ b/linux/drivers/staging/go7007/go7007-usb.c	Thu Feb 11 14:48:26 2010 -0800
> @@ -297,7 +297,7 @@
>  		.num_i2c_devs	 = 1,
>  		.i2c_devs	 = {
>  			{
> -				.type	= "wis_tw9903",
> +				.type	= "tw9903",
>  				.addr	= 0x44,
>  			},
>  		},
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
