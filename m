Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9FNgo7G004613
	for <video4linux-list@redhat.com>; Wed, 15 Oct 2008 19:42:50 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9FNflYT006907
	for <video4linux-list@redhat.com>; Wed, 15 Oct 2008 19:41:47 -0400
Date: Thu, 16 Oct 2008 01:41:51 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <uskqyqg58.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0810160041250.8535@axis700.grange>
References: <uskqyqg58.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L <video4linux-list@redhat.com>
Subject: Re: [PATCH] Add ov772x driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi, and thanks for the patch! A couple of notes:

(Magnus, see a note for you at the bottom:-))

first, you didn't add an ID for your sensor to 
include/media/v4l2-chip-ident.h, it is not reqlly required for your driver 
functionality, but you can use it to provide as a reply to the 
.vidioc_g_chip_ident request (.get_chip_id in struct soc_camera_ops).

On Wed, 15 Oct 2008, Kuninori Morimoto wrote:

> This patch adds ov772x driver that use soc_camera framework.
> It was tested on SH Migo-r board.
> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
>  drivers/media/video/Kconfig  |    6 +
>  drivers/media/video/Makefile |    1 +
>  drivers/media/video/ov772x.c |  957 ++++++++++++++++++++++++++++++++++++++++++
>  include/media/ov772x.h       |   13 +
>  4 files changed, 977 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/ov772x.c
>  create mode 100644 include/media/ov772x.h
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 47102c2..d0c4152 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -750,6 +750,12 @@ config SOC_CAMERA_PLATFORM
>  	help
>  	  This is a generic SoC camera platform driver, useful for testing
>  
> +config SOC_CAMERA_OV772X
> +	tristate "ov772x camera support"
> +	depends on SOC_CAMERA

better

+	depends on SOC_CAMERA && I2C

?

> +	help
> +	  This is a ov772x camera platform driver on soc framework

This is not a platform driver, it's a i2c and an soc-camera (device) 
driver.

> +
>  config VIDEO_PXA27x
>  	tristate "PXA27x Quick Capture Interface driver"
>  	depends on VIDEO_DEV && PXA27x && SOC_CAMERA
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index 16962f3..d281330 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -134,6 +134,7 @@ obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
>  obj-$(CONFIG_SOC_CAMERA_MT9M111)	+= mt9m111.o
>  obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= mt9v022.o
>  obj-$(CONFIG_SOC_CAMERA_PLATFORM)	+= soc_camera_platform.o
> +obj-$(CONFIG_SOC_CAMERA_OV772X)		+= ov772x.o
>  
>  obj-$(CONFIG_VIDEO_AU0828) += au0828/
>  
> diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
> new file mode 100644
> index 0000000..0db0319
> --- /dev/null
> +++ b/drivers/media/video/ov772x.c
> @@ -0,0 +1,957 @@
> +/*
> + * ov772x Camera Driver
> + *
> + * Copyright (C) 2008 Renesas Solutions Corp.
> + * Kuninori Morimoto <morimoto.kuninori@renesas.com>
> + *
> + * Based on ov7670 and soc_camera_platform driver,
> + *
> + * Copyright 2006-7 Jonathan Corbet <corbet@lwn.net>
> + * Copyright (C) 2008 Magnus Damm
> + * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/i2c.h>
> +#include <linux/slab.h>
> +#include <linux/delay.h>
> +#include <linux/platform_device.h>

I don't think you need to include platform_device.h

[snip]

> +static struct regval_list ov772x_default_regs[] =
> +{
> +	{ COM3,  ZERO },
> +	{ COM4,  PLL_4x | 0x01 },
> +	{ 0x16,  0x00 },  /* Mystery */
> +	{ COM11, B4 },    /* Mystery */
> +	{ 0x28,  0x00 },  /* Mystery */
> +	{ HREF,  0x00 },
> +	{ COM13, 0xe2 },  /* Mystery */

Those "Mystery" register - are they not documented, or has the driver been 
reverse-engineered?

> +static int ov772x_start_capture(struct soc_camera_device *icd)
> +{
> +	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
> +	int    ret ;

Please, no space before ";" - this is just a single occurrence, must by a 
typo.

> +
> +
> +	if (!priv->win)
> +		priv->win = &ov772x_win_vga;
> +	if (!priv->fmt)
> +		priv->fmt = &ov772x_cfmts[T_YUYV];
> +
> +	/*
> +	 * reset hardware
> +	 */
> +	ov772x_reset(priv->client);
> +	ret = ov772x_write_array(priv->client, ov772x_default_regs);
> +	if (ret < 0)
> +		goto start_end;
> +
> +	/*
> +	 * set color format
> +	 */
> +	ret = ov772x_write_array(priv->client, priv->fmt->regs);
> +	if (ret < 0)
> +		goto start_end;
> +
> +	/*
> +	 * set size format
> +	 */
> +	ret = ov772x_write_array(priv->client, priv->win->regs);
> +	if (ret < 0)
> +		goto start_end;
> +
> +	/*
> +	 * set COM7 bit ( QVGA or VGA )
> +	 */
> +	ret = ov772x_mask_set(priv->client,
> +			      COM7, SLCT_MASK, priv->win->com7_bit);
> +	if (ret < 0)
> +		goto start_end;
> +
> +	/*
> +	 * set UV setting
> +	 */
> +	if (priv->fmt->option & OP_UV) {
> +		ret = ov772x_mask_set(priv->client,
> +				      DSP_CTRL3, UV_MASK , UV_ON);
> +		if (ret < 0)
> +			goto start_end;
> +	}
> +
> +	/*
> +	 * set SWAP setting
> +	 */
> +	if (priv->fmt->option & OP_SWAP_RGB) {
> +		ret = ov772x_mask_set(priv->client,
> +				      COM3, SWAP_MASK , SWAP_RGB);
> +		if (ret < 0)
> +			goto start_end;
> +	}
> +
> +	/*
> +	 * color bar mode
> +	 */
> +	if (priv->info->color_bar) {
> +		ret = ov772x_mask_set(priv->client,
> +				DSP_CTRL3, CBAR_MASK  , CBAR_ON);
> +		if (ret < 0)
> +			goto start_end;
> +	}

What is this "color bar mode" and why do you think you need it to be 
specified by the platform data (also see below)?

> +
> +	dev_info(&icd->dev,
> +		 "format %s, win %s\n" , priv->fmt->name, priv->win->name);
> +
> +start_end:
> +	priv->fmt = NULL;
> +	priv->win = NULL;
> +
> +	return ret;
> +}
> +
> +static int ov772x_stop_capture(struct soc_camera_device *icd)
> +{
> +	return 0;
> +}
> +
> +static int ov772x_set_bus_param(struct soc_camera_device *icd,
> +				unsigned long		  flags)
> +{
> +	int ret = 0;
> +
> +	/*
> +	 * check bus width
> +	 */
> +	switch (flags & SOCAM_DATAWIDTH_MASK) {
> +	case SOCAM_DATAWIDTH_10:
> +	case SOCAM_DATAWIDTH_8:

How does it work in both 8- and 10-bit modes without any reconfiguration? 
Are then just the upper 8 bits connected to the interface? Is it 
hard-wired, or software-switchable at runtime?

> +		break;
> +	default:
> +		dev_err(&icd->dev, "it is not 8 or 10 bit bus width\n");
> +		ret = -EINVAL;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static unsigned long
> +ov772x_query_bus_param(struct soc_camera_device *icd)

In most of your function definitions you put the type and the name on one 
line, but a few you split, even though it wouldn't exceed 80 characters on 
one line either. Please put them all on one line.

> +{
> +	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
> +
> +	return  SOCAM_PCLK_SAMPLE_RISING |
> +		SOCAM_HSYNC_ACTIVE_HIGH  |
> +		SOCAM_VSYNC_ACTIVE_HIGH  |
> +		SOCAM_MASTER             |
> +		priv->info->buswidth;
> +}
> +
> +static int ov772x_set_fmt_cap(struct soc_camera_device *icd   ,

Please, no spaces before commas - there are multiple places like this, 
please, fix them all.

> +			      __u32                     pixfmt,
> +			      struct v4l2_rect         *rect)
> +{
> +	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
> +	int ret = -EINVAL;
> +	int i   = 0;

Superfluous initialisation of "i", please, remove. Same in 
ov772x_try_fmt_cap() for "priv".

[snip]

> +static int ov772x_probe(struct i2c_client          *client,
> +			const struct i2c_device_id *did)
> +
> +{
> +	struct ov772x_priv         *priv = NULL;
> +	struct ov772x_camera_info  *info = NULL;
> +	struct soc_camera_device   *icd  = NULL;
> +	int                         ret  = -ENODEV;

Ditto - for all four variables.

> +static int __init ov772x_module_init(void)
> +{
> +	printk(KERN_NOTICE "ov772x driver (soc framework)\n");

KERN_INFO would be quite enough:-) And it's soc-camera, just "soc" is too 
generic, and would have to be written SoC.

> +	return i2c_add_driver(&ov772x_i2c_driver);
> +}
> +
> +static void __exit ov772x_module_exit(void)
> +{
> +	i2c_del_driver(&ov772x_i2c_driver);
> +}
> +
> +module_init(ov772x_module_init);
> +module_exit(ov772x_module_exit);
> +
> +MODULE_DESCRIPTION("SoC Camera Platform driver for ov772x");

No "Platform".

Also in multiple places like

> +	if ((pix->width  <= ov772x_win_qvga.width) ||
> +	    (pix->height <= ov772x_win_qvga.height)) {

the internal parenthesis are not needed, but that's not really critical, 
might be characterised as a matter of personal preference:-)

> +MODULE_AUTHOR("Kuninori Morimoto");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/media/ov772x.h b/include/media/ov772x.h
> new file mode 100644
> index 0000000..2fe3a1a
> --- /dev/null
> +++ b/include/media/ov772x.h
> @@ -0,0 +1,13 @@
> +#ifndef __SOC_CAMERA_H__
> +#define __SOC_CAMERA_H__

Wrong protective __SOC_CAMERA_H__ macro... You're lucky I didn't use that 
many underscores:-) Also Copyright / license header missing.

> +
> +#include <linux/videodev2.h>

Include not needed.

> +
> +struct ov772x_camera_info {
> +	int             iface;
> +	unsigned long   buswidth;
> +	int             color_bar;
> +	void (*power)(int);
> +};

Now, this one. Please, use struct soc_camera_link. It also provides bus_id 
(your iface), power, ok, I admit, the inclusion of the "gpio" member in it 
was a mistake of mine, it is too specific, we might remove it at some 
point. I am not sure you really need color_bar and bus_width. I think, 
cameras are more or less exchangeable parts, and if they need some 
parameters, that cannot be autoprobed and do not belong to the camera 
itself, it might be better to make them module parameters, like the 
sensor_type parameter in mt9v022. Even if in your case the sensor chip is 
soldered on the board, in another configuration it might not be.

Magnus, I think, we should switch soc_camera_platform to use 
soc_camera_link too.

In both ov772x and soc_camera_platform cases, if you do need extra 
platform information, just embed soc_camera_link in your struct.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
