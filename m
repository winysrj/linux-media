Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4009 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab0BLMGb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2010 07:06:31 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pete Eberlein <pete@sensoray.com>
Subject: Re: [PATCH 5/5] ov7640: sensor driver subdev conversion
Date: Fri, 12 Feb 2010 13:08:34 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1265934807.4626.254.camel@pete-desktop>
In-Reply-To: <1265934807.4626.254.camel@pete-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201002121308.34983.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 12 February 2010 01:33:27 Pete Eberlein wrote:
> From: Pete Eberlein <pete@sensoray.com>
> 
> This is a subdev conversion of wis-ov7640 sensor driver from the
> staging go7007 directory.  This obsoletes the wis-ov7640 driver.

Review below...

BTW: note that the gspca/ov519.c driver also has support for this sensor.
Unfortunately, the gspca subdrivers do not use v4l2_subdev. It might be
useful though as a reference. gspca should really start to use v4l2_subdev
where possible.

> 
> Priority: normal
> 
> Signed-off-by: Pete Eberlein <pete@sensoray.com>
> 
> diff -r 378d3bc9a3d6 -r 6d0a37622c1b linux/drivers/media/video/Kconfig
> --- a/linux/drivers/media/video/Kconfig	Thu Feb 11 14:48:26 2010 -0800
> +++ b/linux/drivers/media/video/Kconfig	Thu Feb 11 14:57:40 2010 -0800
> @@ -309,6 +309,13 @@
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called ks0127.
>  
> +config VIDEO_OV7640
> +	tristate "OmniVision OV7640 sensor support"
> +	depends on I2C && VIDEO_V4L2
> +	---help---
> +	  This is a Video4Linux2 sensor-level driver for the OmniVision

Replace 'Video4Linux2 sensor-level' with just 'sensor'.

> +	  OV7640 camera.  It currently only works with the GO7007 driver.

Why does it only work with go7007? Oh, I see: it's only a hardcoded list of 
registers.

> +
>  config VIDEO_OV7670
>  	tristate "OmniVision OV7670 sensor support"
>  	depends on I2C && VIDEO_V4L2
> diff -r 378d3bc9a3d6 -r 6d0a37622c1b linux/drivers/media/video/Makefile
> --- a/linux/drivers/media/video/Makefile	Thu Feb 11 14:48:26 2010 -0800
> +++ b/linux/drivers/media/video/Makefile	Thu Feb 11 14:57:40 2010 -0800
> @@ -67,6 +67,7 @@
>  obj-$(CONFIG_VIDEO_CX25840) += cx25840/
>  obj-$(CONFIG_VIDEO_UPD64031A) += upd64031a.o
>  obj-$(CONFIG_VIDEO_UPD64083) += upd64083.o
> +obj-$(CONFIG_VIDEO_OV7640) 	+= ov7640.o
>  obj-$(CONFIG_VIDEO_OV7670) 	+= ov7670.o
>  obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
>  obj-$(CONFIG_VIDEO_TVEEPROM) += tveeprom.o
> diff -r 378d3bc9a3d6 -r 6d0a37622c1b linux/drivers/media/video/ov7640.c
> --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
> +++ b/linux/drivers/media/video/ov7640.c	Thu Feb 11 14:57:40 2010 -0800
> @@ -0,0 +1,141 @@
> +/*
> + * Copyright (C) 2005-2006 Micronas USA Inc.

You probably want to add a copyright line of your own for the drivers you
worked on.

You should also clearly state in this driver that it is setup specifically
for the go7007.

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
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/i2c.h>
> +#include <linux/videodev2.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-chip-ident.h>
> +#include <media/v4l2-i2c-drv.h>
> +
> +MODULE_DESCRIPTION("OmniVision ov7640 sensor driver");
> +MODULE_LICENSE("GPL v2");
> +
> +struct ov7640_info {
> +	struct v4l2_subdev sd;
> +	int brightness;
> +	int contrast;
> +	int saturation;
> +	int hue;
> +};
> +
> +static inline struct ov7640_info *to_state(struct v4l2_subdev *sd)
> +{
> +	return container_of(sd, struct ov7640_info, sd);
> +}
> +
> +
> +static u8 initial_registers[] =

const

> +{
> +	0x12, 0x80,
> +	0x12, 0x54,
> +	0x14, 0x24,
> +	0x15, 0x01,
> +	0x28, 0x20,
> +	0x75, 0x82,
> +	0xFF, 0xFF, /* Terminator (reg 0xFF is unused) */

Please document at least how this sensor is set up for the go7007.

> +};
> +
> +static int write_regs(struct i2c_client *client, u8 *regs)
> +{
> +	int i;
> +
> +	for (i = 0; regs[i] != 0xFF; i += 2)
> +		if (i2c_smbus_write_byte_data(client, regs[i], regs[i + 1]) < 0)
> +			return -1;
> +	return 0;
> +}
> +
> +
> +static int ov7640_g_chip_ident(struct v4l2_subdev *sd,
> +		struct v4l2_dbg_chip_ident *chip)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_OV7640, 0);
> +}

I recommend added g_chip_ident as well to the tw???? drivers.

> +
> +/* ----------------------------------------------------------------------- */
> +
> +static const struct v4l2_subdev_core_ops ov7640_core_ops = {
> +	.g_chip_ident = ov7640_g_chip_ident,
> +};
> +
> +static const struct v4l2_subdev_ops ov7640_ops = {
> +	.core = &ov7640_core_ops,
> +};
> +
> +/* ----------------------------------------------------------------------- */
> +
> +static int ov7640_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct i2c_adapter *adapter = client->adapter;
> +	struct v4l2_subdev *sd;
> +	struct ov7640_info *info;
> +
> +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
> +		return -ENODEV;
> +
> +	info = kzalloc(sizeof(struct ov7640_info), GFP_KERNEL);
> +	if (info == NULL)
> +		return -ENOMEM;
> +	sd = &info->sd;
> +	v4l2_i2c_subdev_init(sd, client, &ov7640_ops);
> +
> +	client->flags = 0x10; /* I2C_CLIENT_SCCB from wis-i2c.h */
> +
> +	v4l_info(client, "chip found @ 0x%02x (%s)\n",
> +			client->addr << 1, client->adapter->name);
> +
> +	if (write_regs(client, initial_registers) < 0) {
> +		v4l_err(client, "error initializing OV7640\n");
> +		kfree(info);
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
> +
> +static int ov7640_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +
> +	v4l2_device_unregister_subdev(sd);
> +	kfree(to_state(sd));
> +	return 0;
> +}
> +
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
> +static const struct i2c_device_id ov7640_id[] = {
> +	{ "ov7640", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, ov7640_id);
> +
> +#endif
> +static struct v4l2_i2c_driver_data v4l2_i2c_data = {
> +	.name = "ov7640",
> +	.probe = ov7640_probe,
> +	.remove = ov7640_remove,
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
> +	.id_table = ov7640_id,
> +#endif
> +};
> +
> diff -r 378d3bc9a3d6 -r 6d0a37622c1b linux/drivers/staging/go7007/go7007-usb.c
> --- a/linux/drivers/staging/go7007/go7007-usb.c	Thu Feb 11 14:48:26 2010 -0800
> +++ b/linux/drivers/staging/go7007/go7007-usb.c	Thu Feb 11 14:57:40 2010 -0800
> @@ -265,7 +265,7 @@
>  		.num_i2c_devs	  = 1,
>  		.i2c_devs	  = {
>  			{
> -				.type	= "wis_ov7640",
> +				.type	= "ov7640",
>  				.addr	= 0x21,
>  			},
>  		},
> diff -r 378d3bc9a3d6 -r 6d0a37622c1b linux/include/media/v4l2-chip-ident.h
> --- a/linux/include/media/v4l2-chip-ident.h	Thu Feb 11 14:48:26 2010 -0800
> +++ b/linux/include/media/v4l2-chip-ident.h	Thu Feb 11 14:57:40 2010 -0800
> @@ -65,6 +65,7 @@
>  	V4L2_IDENT_OV9655 = 255,
>  	V4L2_IDENT_SOI968 = 256,
>  	V4L2_IDENT_OV9640 = 257,
> +	V4L2_IDENT_OV7640 = 258,
>  
>  	/* module saa7146: reserved range 300-309 */
>  	V4L2_IDENT_SAA7146 = 300,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Frankly I am wondering whether this driver shouldn't remain in staging a bit
longer. I'm a bit concerned about the fact that it is hardcoded for the go7007.

Are you able to test the go7007 with this sensor? If so, would it be possible
to use what is in gspca/ov519.c and copy it to this driver to make it more
general?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
