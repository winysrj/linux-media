Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:36742 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750865Ab0HVQj6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Aug 2010 12:39:58 -0400
Date: Sun, 22 Aug 2010 18:40:13 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Discussion of the Amstrad E3 emailer hardware/software
	<e3-hacking@earth.li>
Subject: Re: [RFC] [PATCH 3/6] SoC Camera: add driver for OV6650 sensor
In-Reply-To: <201007180624.45693.jkrzyszt@tis.icnet.pl>
Message-ID: <Pine.LNX.4.64.1008131203310.31714@axis700.grange>
References: <201007180618.08266.jkrzyszt@tis.icnet.pl>
 <201007180624.45693.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Sun, 18 Jul 2010, Janusz Krzysztofik wrote:

> This patch provides a V4L2 SoC Camera driver for OV6650 camera sensor, found 
> on OMAP1 SoC based Amstrad Delta videophone.

Have you also had a look at drivers/media/video/gspca/sonixb.c - in also 
supports ov6650 among other sensors.

> Since I have no experience with camera sensors, and the sensor documentation I 
> was able to find was not very comprehensive, I left most settings at their 
> default (reset) values, except for:
> - those required for proper mediabus parameters and picture format setup,
> - those used by controls.
> Resulting picture quality is far from perfect, but better than nothing.
> 
> In order to be able to get / set the sensor frame rate from userspace, I 
> decided to provide two not yet SoC camera supported operations, g_parm and 
> s_parm. These can be used after applying patch 4/6 from this series, 
> "SoC Camera: add support for g_parm / s_parm operations".
> 
> Created and tested against linux-2.6.35-rc3 on Amstrad Delta.
> 
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> ---
>  drivers/media/video/Kconfig     |    6
>  drivers/media/video/Makefile    |    1
>  drivers/media/video/ov6650.c    | 1336 ++++++++++++++++++++++++++++++++++++++++
>  include/media/v4l2-chip-ident.h |    1
>  4 files changed, 1344 insertions(+)
> 
> --- linux-2.6.35-rc3.orig/drivers/media/video/Kconfig	2010-06-26 15:55:29.000000000 +0200
> +++ linux-2.6.35-rc3/drivers/media/video/Kconfig	2010-07-02 04:12:02.000000000 +0200
> @@ -913,6 +913,12 @@ config SOC_CAMERA_PLATFORM
>  	help
>  	  This is a generic SoC camera platform driver, useful for testing
>  
> +config SOC_CAMERA_OV6650
> +	tristate "ov6650 sensor support"
> +	depends on SOC_CAMERA && I2C
> +	help
> +	  This is a V4L2 SoC camera driver for the OmniVision OV6650 sensor
> +
>  config SOC_CAMERA_OV772X
>  	tristate "ov772x camera support"
>  	depends on SOC_CAMERA && I2C
> --- linux-2.6.35-rc3.orig/drivers/media/video/Makefile	2010-06-26 15:55:29.000000000 +0200
> +++ linux-2.6.35-rc3/drivers/media/video/Makefile	2010-06-26 17:28:09.000000000 +0200
> @@ -79,6 +79,7 @@ obj-$(CONFIG_SOC_CAMERA_MT9M111)	+= mt9m
>  obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= mt9t031.o
>  obj-$(CONFIG_SOC_CAMERA_MT9T112)	+= mt9t112.o
>  obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= mt9v022.o
> +obj-$(CONFIG_SOC_CAMERA_OV6650)		+= ov6650.o
>  obj-$(CONFIG_SOC_CAMERA_OV772X)		+= ov772x.o
>  obj-$(CONFIG_SOC_CAMERA_OV9640)		+= ov9640.o
>  obj-$(CONFIG_SOC_CAMERA_RJ54N1)		+= rj54n1cb0c.o
> --- linux-2.6.35-rc3.orig/drivers/media/video/ov6650.c	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.35-rc3/drivers/media/video/ov6650.c	2010-07-18 02:06:22.000000000 +0200
> @@ -0,0 +1,1336 @@
> +/*
> + * V4L2 SoC Camera driver for OmniVision OV6650 Camera Sensor
> + *
> + * Copyright (C) 2010 Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> + *
> + * Based on OmniVision OV96xx Camera Driver
> + * Copyright (C) 2009 Marek Vasut <marek.vasut@gmail.com>
> + *
> + * Based on ov772x camera driver:
> + * Copyright (C) 2008 Renesas Solutions Corp.
> + * Kuninori Morimoto <morimoto.kuninori@renesas.com>
> + *
> + * Based on ov7670 and soc_camera_platform driver,
> + * Copyright 2006-7 Jonathan Corbet <corbet@lwn.net>
> + * Copyright (C) 2008 Magnus Damm
> + * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
> + *
> + * Hardware specific bits initialy based on former work by Matt Callow
> + * drivers/media/video/omap/sensor_ov6650.c
> + * Copyright (C) 2006 Matt Callow
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/i2c.h>
> +#include <linux/slab.h>
> +#include <linux/delay.h>
> +#include <media/v4l2-chip-ident.h>
> +#include <media/soc_camera.h>

Please, sort headers alphabetically (media/ and linux/ separately, of 
course).

> +
> +
> +/* Register definitions */
> +#define	REG_GAIN		0x00	/* range 00 - 3F */
> +#define	REG_BLUE		0x01
> +#define	REG_RED			0x02
> +#define	REG_SAT			0x03	/* [7:4] saturation [0:3] reserved */
> +#define	REG_HUE			0x04	/* [7:6] rsrvd [5] hue en [4:0] hue */
> +
> +#define	REG_BRT			0x06
> +
> +#define	REG_PIDH		0x0a
> +#define	REG_PIDL		0x0b
> +
> +#define	REG_AECH		0x10
> +#define	REG_CLKRC		0x11	/* Data Format and Internal Clock */
> +					/* [7:6] Input system clock (MHz)*/
> +					/*   00=8, 01=12, 10=16, 11=24 */
> +					/* [5:0]: Internal Clock Pre-Scaler */
> +#define	REG_COMA		0x12	/* [7] Reset */
> +#define	REG_COMB		0x13
> +#define	REG_COMC		0x14
> +#define	REG_COMD		0x15
> +#define REG_COML		0x16

You used TAB in most defines and a space in this one and a few ones below. 
Please, use the same for all (I personally would just use a space).

> +#define	REG_HSTRT		0x17
> +#define	REG_HSTOP		0x18
> +#define	REG_VSTRT		0x19
> +#define	REG_VSTOP		0x1a
> +#define	REG_PSHFT		0x1b
> +#define	REG_MIDH		0x1c
> +#define	REG_MIDL		0x1d
> +#define	REG_HSYNS		0x1e
> +#define	REG_HSYNE		0x1f
> +#define	REG_COME		0x20
> +#define	REG_YOFF		0x21
> +#define	REG_UOFF		0x22
> +#define	REG_VOFF		0x23
> +#define	REG_AEW			0x24
> +#define	REG_AEB			0x25
> +#define	REG_COMF		0x26
> +#define	REG_COMG		0x27
> +#define	REG_COMH		0x28
> +#define REG_COMI		0x29
> +
> +#define	REG_FRARL		0x2b
> +#define	REG_COMJ		0x2c
> +#define	REG_COMK		0x2d
> +#define	REG_AVGY		0x2e
> +#define	REG_REF0		0x2f
> +#define	REG_REF1		0x30
> +#define	REG_REF2		0x31
> +#define	REG_FRAJH		0x32
> +#define	REG_FRAJL		0x33
> +#define	REG_FACT		0x34
> +#define REG_L1AEC		0x35
> +#define REG_AVGU		0x36
> +#define	REG_AVGV		0x37
> +
> +#define	REG_SPCB		0x60
> +#define	REG_SPCC		0x61
> +#define	REG_GAM1		0x62
> +#define	REG_GAM2		0x63
> +#define	REG_GAM3		0x64
> +#define	REG_SPCD		0x65
> +
> +#define	REG_SPCE		0x68
> +#define	REG_ADCL		0x69
> +
> +#define	REG_RMCO		0x6c
> +#define	REG_GMCO		0x6d
> +#define	REG_BMCO		0x6e
> +
> +#define NUM_REGS		(REG_BMCO + 1)

NUM_REGS is unused, don't need to define it.

> +
> +
> +/* Register bits, values, etc. */
> +#define OV6650_PIDH		0x66	/* high byte of product ID number */
> +#define OV6650_PIDL		0x50	/* low byte of product ID number */
> +#define OV6650_MIDH		0x7F	/* high byte of mfg ID */
> +#define OV6650_MIDL		0xA2	/* low byte of mfg ID */
> +
> +#define DEF_GAIN		0x00
> +#define DEF_BLUE		0x80
> +#define DEF_RED			0x80
> +
> +#define SAT_SHIFT		4
> +#define SAT_MASK		0xf
> +#define SET_SAT(x)		(((x) & SAT_MASK) << SAT_SHIFT)

Nitpicking, but I would

+#define SAT_SHIFT		4
+#define SAT_MASK		0xf0
+#define SET_SAT(x)		(((x) << SAT_SHIFT) & SAT_MASK)

Advantage: your SAT_MASK is already correctly shifted, so, you don't have 
to you SET_SAT(SAT_MASK) to get to the register value.

> +
> +#define HUE_EN			BIT(5)

You have to #include <linux/bitops.h> for the BIT() macro

> +#define HUE_MASK		0x1f
> +#define DEF_HUE			0x10
> +#define SET_HUE(x)		((x) == DEF_HUE ? (x) : \
> +						HUE_EN | ((x) & HUE_MASK))
> +
> +#define DEF_AECH		0x4D
> +
> +#define	CLKRC_6MHz		0x00
> +#define	CLKRC_12MHz		0x40
> +#define	CLKRC_16MHz		0x80
> +#define	CLKRC_24MHz		0xc0
> +#define	CLKRC_DIV_MASK		0x3f
> +#define	GET_CLKRC_DIV(x)	(((x) & CLKRC_DIV_MASK) + 1)
> +
> +#define COMA_RESET		BIT(7)
> +#define COMA_QCIF		BIT(5)
> +#define COMA_RAW_RGB		BIT(4)
> +#define COMA_RGB		BIT(3)
> +#define COMA_BW			BIT(2)
> +#define COMA_WORD_SWAP		BIT(1)
> +#define COMA_BYTE_SWAP		BIT(0)
> +#define DEF_COMA		0x00
> +
> +#define	COMB_FLIP_V		BIT(7)
> +#define	COMB_FLIP_H		BIT(5)
> +#define COMB_AWB		BIT(2)
> +#define COMB_AGC		BIT(1)
> +#define COMB_AEC		BIT(0)
> +
> +#define COML_ONE_CHANNEL	BIT(7)
> +
> +#define DEF_HSTRT		0x24
> +#define DEF_HSTOP		0xd4
> +#define DEF_VSTRT		0x04
> +#define DEF_VSTOP		0x94
> +
> +#define COMF_HREF_LOW		BIT(4)
> +
> +#define COMJ_PCLK_RISING	BIT(4)
> +#define COMJ_VSYNC_HIGH		BIT(0)
> +
> +/* supported resolutions */
> +#define W_QCIF			(DEF_HSTOP - DEF_HSTRT)
> +#define W_CIF			(W_QCIF << 1)
> +#define H_QCIF			(DEF_VSTOP - DEF_VSTRT)
> +#define H_CIF			(H_QCIF << 1)
> +
> +#define FRAME_RATE_MAX		30
> +
> +
> +struct ov6650_reg {
> +	u8	reg;
> +	u8	val;
> +};
> +
> +struct ov6650 {
> +	struct v4l2_subdev	subdev;
> +
> +	int			gain;
> +	int			blue;
> +	int			red;
> +	int			saturation;
> +	int			hue;
> +	int			brightness;
> +	int			exposure;
> +	int			gamma;
> +	bool			vflip;
> +	bool			hflip;
> +	bool			awb;
> +	bool			agc;
> +	int			aec;
> +	bool			hue_auto;
> +	bool			qcif;
> +	unsigned long		pclk_max;	/* from resolution and format */
> +	unsigned long		pclk_limit;	/* from host */
> +	struct v4l2_fract	timeperframe;	/* as requested with s_parm */
> +};
> +
> +
> +/* default register setup */
> +static const struct ov6650_reg ov6650_regs_dflt[] = {
> +	{ REG_COMA,	DEF_COMA },	/* ~COMA_RESET */
> +};
> +
> +static enum v4l2_mbus_pixelcode ov6650_codes[] = {
> +	V4L2_MBUS_FMT_YUYV8_2X8_LE,
> +	V4L2_MBUS_FMT_YUYV8_2X8_BE,
> +	V4L2_MBUS_FMT_YVYU8_2X8_LE,
> +	V4L2_MBUS_FMT_YVYU8_2X8_BE,
> +	V4L2_MBUS_FMT_SBGGR8_1X8,
> +	V4L2_MBUS_FMT_GREY8_1X8,
> +};
> +
> +static const struct v4l2_queryctrl ov6650_controls[] = {
> +	{
> +		.id		= V4L2_CID_AUTOGAIN,
> +		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> +		.name		= "AGC",
> +		.minimum	= 0,
> +		.maximum	= 1,
> +		.step		= 1,
> +		.default_value	= 1,
> +	},
> +	{
> +		.id		= V4L2_CID_GAIN,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "Gain",
> +		.minimum	= 0,
> +		.maximum	= 0x3f,
> +		.step		= 1,
> +		.default_value	= DEF_GAIN,
> +	},
> +	{
> +		.id		= V4L2_CID_AUTO_WHITE_BALANCE,
> +		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> +		.name		= "AWB",
> +		.minimum	= 0,
> +		.maximum	= 1,
> +		.step		= 1,
> +		.default_value	= 1,
> +	},
> +	{
> +		.id		= V4L2_CID_BLUE_BALANCE,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "Blue",
> +		.minimum	= 0,
> +		.maximum	= 0xff,
> +		.step		= 1,
> +		.default_value	= DEF_BLUE,
> +	},
> +	{
> +		.id		= V4L2_CID_RED_BALANCE,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "Red",
> +		.minimum	= 0,
> +		.maximum	= 0xff,
> +		.step		= 1,
> +		.default_value	= DEF_RED,
> +	},
> +	{
> +		.id		= V4L2_CID_SATURATION,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "Saturation",
> +		.minimum	= 0,
> +		.maximum	= 0xf,
> +		.step		= 1,
> +		.default_value	= 0x8,
> +	},
> +	{
> +		.id		= V4L2_CID_HUE_AUTO,
> +		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> +		.name		= "Auto Hue",
> +		.minimum	= 0,
> +		.maximum	= 1,
> +		.step		= 1,
> +		.default_value	= 1,
> +	},
> +	{
> +		.id		= V4L2_CID_HUE,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "Hue",
> +		.minimum	= 0,
> +		.maximum	= 0x1f,
> +		.step		= 1,
> +		.default_value	= DEF_HUE,
> +	},
> +	{
> +		.id		= V4L2_CID_BRIGHTNESS,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "Brightness",
> +		.minimum	= 0,
> +		.maximum	= 0xff,
> +		.step		= 1,
> +		.default_value	= 0x80,
> +	},
> +	{
> +		.id		= V4L2_CID_EXPOSURE_AUTO,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "AEC",
> +		.minimum	= 0,
> +		.maximum	= 3,
> +		.step		= 1,
> +		.default_value	= 0,
> +	},
> +	{
> +		.id		= V4L2_CID_EXPOSURE,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "Exposure",
> +		.minimum	= 0,
> +		.maximum	= 0xff,
> +		.step		= 1,
> +		.default_value	= DEF_AECH,
> +	},
> +	{
> +		.id		= V4L2_CID_GAMMA,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "Gamma",
> +		.minimum	= 0,
> +		.maximum	= 0xff,
> +		.step		= 1,
> +		.default_value	= 0x12,
> +	},
> +	{
> +		.id		= V4L2_CID_VFLIP,
> +		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> +		.name		= "Flip Vertically",
> +		.minimum	= 0,
> +		.maximum	= 1,
> +		.step		= 1,
> +		.default_value	= 0,
> +	},
> +	{
> +		.id		= V4L2_CID_HFLIP,
> +		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> +		.name		= "Flip Horizontally",
> +		.minimum	= 0,
> +		.maximum	= 1,
> +		.step		= 1,
> +		.default_value	= 0,
> +	},
> +};
> +
> +/* read a register */
> +static int ov6650_reg_read(struct i2c_client *client, u8 reg, u8 *val)
> +{
> +	int ret;
> +	u8 data = reg;
> +	struct i2c_msg msg = {
> +		.addr	= client->addr,
> +		.flags	= 0,
> +		.len	= 1,
> +		.buf	= &data,
> +	};
> +
> +	ret = i2c_transfer(client->adapter, &msg, 1);
> +	if (ret < 0)
> +		goto err;
> +
> +	msg.flags = I2C_M_RD;
> +	ret = i2c_transfer(client->adapter, &msg, 1);
> +	if (ret < 0)
> +		goto err;
> +
> +	*val = data;
> +	return 0;
> +
> +err:
> +	dev_err(&client->dev, "Failed reading register 0x%02x!\n", reg);
> +	return ret;
> +}
> +
> +/* write a register */
> +static int ov6650_reg_write(struct i2c_client *client, u8 reg, u8 val)
> +{
> +	int ret;
> +	u8 _val;
> +	unsigned char data[2] = { reg, val };
> +	struct i2c_msg msg = {
> +		.addr	= client->addr,
> +		.flags	= 0,
> +		.len	= 2,
> +		.buf	= data,
> +	};
> +
> +	ret = i2c_transfer(client->adapter, &msg, 1);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "Failed writing register 0x%02x!\n", reg);
> +		return ret;
> +	}
> +	msleep(1);

Hm, interesting... Is this really needed?

> +
> +	/* we have to read the register back ... no idea why, maybe HW bug */
> +	ret = ov6650_reg_read(client, reg, &_val);

You can also use "val" - it is not needed any more - and drop "_val."

> +	if (ret)
> +		dev_err(&client->dev,
> +			"Failed reading back register 0x%02x!\n", reg);
> +
> +	return 0;
> +}
> +
> +
> +/* Read a register, alter its bits, write it back */
> +static int ov6650_reg_rmw(struct i2c_client *client, u8 reg, u8 set, u8 mask)
> +{
> +	u8 val;
> +	int ret;
> +
> +	ret = ov6650_reg_read(client, reg, &val);
> +	if (ret) {
> +		dev_err(&client->dev,
> +			"[Read]-Modify-Write of register %02x failed!\n", reg);
> +		return val;

You mean "return ret"

> +	}
> +
> +	val &= ~mask;
> +	val |= set;
> +
> +	ret = ov6650_reg_write(client, reg, val);
> +	if (ret)
> +		dev_err(&client->dev,
> +			"Read-Modify-[Write] of register %02x failed!\n", reg);
> +
> +	return ret;
> +}
> +
> +/* Soft reset the camera. This has nothing to do with the RESET pin! */
> +static int ov6650_reset(struct i2c_client *client)
> +{
> +	int ret;
> +
> +	dev_dbg(&client->dev, "reset\n");
> +
> +	ret = ov6650_reg_rmw(client, REG_COMA, COMA_RESET, 0);
> +	if (ret)
> +		dev_err(&client->dev,
> +			"An error occured while entering soft reset!\n");
> +
> +	return ret;
> +}
> +
> +static struct ov6650 *to_ov6650(const struct i2c_client *client)
> +{
> +	return container_of(i2c_get_clientdata(client), struct ov6650, subdev);
> +}
> +
> +/* Start/Stop streaming from the device */
> +static int ov6650_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	return 0;
> +}
> +
> +/* Alter bus settings on camera side */
> +static int ov6650_set_bus_param(struct soc_camera_device *icd,
> +				unsigned long flags)
> +{
> +	struct soc_camera_link *icl = to_soc_camera_link(icd);
> +	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
> +	int ret;
> +
> +	flags = soc_camera_apply_sensor_flags(icl, flags);
> +
> +	if (flags & SOCAM_PCLK_SAMPLE_RISING)
> +		ret = ov6650_reg_rmw(client, REG_COMJ, COMJ_PCLK_RISING, 0);
> +	else
> +		ret = ov6650_reg_rmw(client, REG_COMJ, 0, COMJ_PCLK_RISING);
> +	if (ret)
> +		goto out;
> +
> +	if (flags & SOCAM_HSYNC_ACTIVE_LOW)
> +		ret = ov6650_reg_rmw(client, REG_COMF, COMF_HREF_LOW, 0);
> +	else
> +		ret = ov6650_reg_rmw(client, REG_COMF, 0, COMF_HREF_LOW);
> +	if (ret)
> +		goto out;
> +
> +	if (flags & SOCAM_VSYNC_ACTIVE_HIGH)
> +		ret = ov6650_reg_rmw(client, REG_COMJ, COMJ_VSYNC_HIGH, 0);
> +	else
> +		ret = ov6650_reg_rmw(client, REG_COMJ, 0, COMJ_VSYNC_HIGH);
> +out:
> +	return ret;
> +}
> +
> +/* Request bus settings on camera side */
> +static unsigned long ov6650_query_bus_param(struct soc_camera_device *icd)
> +{
> +	struct soc_camera_link *icl = to_soc_camera_link(icd);
> +
> +	unsigned long flags = SOCAM_MASTER | \
> +		SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING | \
> +		SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_LOW | \
> +		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_LOW | \
> +		SOCAM_DATA_ACTIVE_HIGH | SOCAM_DATAWIDTH_8;
> +
> +	return soc_camera_apply_sensor_flags(icl, flags);
> +}
> +
> +/* Get status of additional camera capabilities */
> +static int ov6650_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> +{
> +	struct i2c_client *client = sd->priv;
> +	struct ov6650 *priv = to_ov6650(client);
> +	uint8_t reg;
> +	int ret = 0;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_AUTOGAIN:
> +		ctrl->value = priv->agc;
> +		break;
> +	case V4L2_CID_GAIN:
> +		if (priv->agc) {
> +			ret = ov6650_reg_read(client, REG_GAIN, &reg);
> +			ctrl->value = reg;
> +		} else {
> +			ctrl->value = priv->gain;
> +		}
> +		break;
> +	case V4L2_CID_AUTO_WHITE_BALANCE:
> +		ctrl->value = priv->awb;
> +		break;
> +	case V4L2_CID_BLUE_BALANCE:
> +		if (priv->awb) {
> +			ret = ov6650_reg_read(client, REG_BLUE, &reg);
> +			ctrl->value = reg;
> +		} else {
> +			ctrl->value = priv->blue;
> +		}
> +		break;
> +	case V4L2_CID_RED_BALANCE:
> +		if (priv->awb) {
> +			ret = ov6650_reg_read(client, REG_RED, &reg);
> +			ctrl->value = reg;
> +		} else {
> +			ctrl->value = priv->red;
> +		}
> +		break;
> +	case V4L2_CID_SATURATION:
> +		ctrl->value = priv->saturation;
> +		break;
> +	case V4L2_CID_HUE_AUTO:
> +		ctrl->value = priv->hue_auto;
> +		break;
> +	case V4L2_CID_HUE:
> +		if (priv->hue_auto) {
> +			ret = ov6650_reg_read(client, REG_HUE, &reg);
> +			ctrl->value = reg & 0x1f;
> +		} else {
> +			ctrl->value = priv->hue;
> +		}
> +		break;
> +	case V4L2_CID_BRIGHTNESS:
> +		ctrl->value = priv->brightness;
> +		break;
> +	case V4L2_CID_EXPOSURE_AUTO:
> +		ctrl->value = priv->aec;
> +		break;
> +	case V4L2_CID_EXPOSURE:
> +		if (priv->aec) {
> +			ret = ov6650_reg_read(client, REG_AECH, &reg);
> +			ctrl->value = reg;
> +		} else {
> +			ctrl->value = priv->exposure;
> +		}
> +		break;
> +	case V4L2_CID_GAMMA:
> +		ctrl->value = priv->gamma;
> +		break;
> +	case V4L2_CID_VFLIP:
> +		ctrl->value = priv->vflip;
> +		break;
> +	case V4L2_CID_HFLIP:
> +		ctrl->value = priv->hflip;
> +		break;
> +	}
> +	return ret;
> +}
> +
> +/* Set status of additional camera capabilities */
> +static int ov6650_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> +{
> +	struct i2c_client *client = sd->priv;
> +	struct ov6650 *priv = to_ov6650(client);
> +	bool automatic;
> +	int ret = 0;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_AUTOGAIN:
> +		if (ctrl->value) {
> +			ret = ov6650_reg_write(client, REG_GAIN, DEF_GAIN);
> +			if (ret)
> +				break;
> +			priv->gain = DEF_GAIN;
> +			ret = ov6650_reg_rmw(client, REG_COMB, COMB_AGC, 0);
> +		} else {
> +			ret = ov6650_reg_rmw(client, REG_COMB, 0, COMB_AGC);
> +		}
> +		if (ret)
> +			break;
> +		priv->agc = ctrl->value;
> +		break;
> +	case V4L2_CID_GAIN:
> +		ret = ov6650_reg_write(client, REG_GAIN, ctrl->value);
> +		if (ret)
> +			break;
> +		priv->gain = ctrl->value;
> +		automatic = (priv->gain == DEF_GAIN);
> +		if (automatic)
> +			ret = ov6650_reg_rmw(client, REG_COMB, COMB_AGC, 0);
> +		else
> +			ret = ov6650_reg_rmw(client, REG_COMB, 0, COMB_AGC);
> +		if (ret)
> +			break;
> +		priv->agc = automatic;

I wouldn't touch autogain here. You have V4L2_CID_AUTOGAIN for that. 
Setting gain to a value, that happens to be equal default, doesn't have to 
turn autogain on, does it?

> +		break;
> +	case V4L2_CID_AUTO_WHITE_BALANCE:
> +		if (ctrl->value) {
> +			ret = ov6650_reg_write(client, REG_BLUE, DEF_BLUE);
> +			if (ret)
> +				break;
> +			priv->blue = DEF_BLUE;
> +			ret = ov6650_reg_write(client, REG_RED, DEF_RED);
> +			if (ret)
> +				break;
> +			priv->red = DEF_RED;
> +			ret = ov6650_reg_rmw(client, REG_COMB, COMB_AWB, 0);
> +		} else {
> +			ret = ov6650_reg_rmw(client, REG_COMB, 0, COMB_AWB);
> +		}
> +		if (ret)
> +			break;
> +		priv->awb = ctrl->value;
> +		break;
> +	case V4L2_CID_BLUE_BALANCE:
> +		ret = ov6650_reg_write(client, REG_BLUE, ctrl->value);
> +		if (ret)
> +			break;
> +		priv->blue = ctrl->value;
> +		automatic = (priv->blue == DEF_BLUE &&
> +				priv->red == DEF_RED);
> +		if (automatic)
> +			ret = ov6650_reg_rmw(client, REG_COMB, COMB_AWB, 0);
> +		else
> +			ret = ov6650_reg_rmw(client, REG_COMB, 0, COMB_AWB);
> +		if (ret)
> +			break;
> +		priv->awb = automatic;
> +		break;
> +	case V4L2_CID_RED_BALANCE:
> +		ret = ov6650_reg_write(client, REG_RED, ctrl->value);
> +		if (ret)
> +			break;
> +		priv->red = ctrl->value;
> +		automatic = (priv->blue == DEF_BLUE &&
> +				priv->red == DEF_RED);
> +		if (automatic)
> +			ret = ov6650_reg_rmw(client, REG_COMB, COMB_AWB, 0);
> +		else
> +			ret = ov6650_reg_rmw(client, REG_COMB, 0, COMB_AWB);
> +		if (ret)
> +			break;
> +		priv->awb = automatic;

Same here, I wouldn't touch AWB in the above two controls. You have 
V4L2_CID_AUTO_WHITE_BALANCE for that.

> +		break;
> +	case V4L2_CID_SATURATION:
> +		ret = ov6650_reg_rmw(client, REG_SAT, SET_SAT(ctrl->value),
> +				SET_SAT(SAT_MASK));

With the proposed change it would look like

+		ret = ov6650_reg_rmw(client, REG_SAT, SET_SAT(ctrl->value),
+				SAT_MASK);

which I personally find a bit more pleasant to the eyes;)

> +		if (ret)
> +			break;
> +		priv->saturation = ctrl->value;
> +		break;
> +	case V4L2_CID_HUE_AUTO:
> +		if (ctrl->value) {
> +			ret = ov6650_reg_rmw(client, REG_HUE,
> +					SET_HUE(DEF_HUE), SET_HUE(HUE_MASK));
> +			if (ret)
> +				break;
> +			priv->hue = DEF_HUE;
> +		} else {
> +			ret = ov6650_reg_rmw(client, REG_HUE, HUE_EN, 0);
> +		}
> +		if (ret)
> +			break;
> +		priv->hue_auto = ctrl->value;

Hm, sorry, don't understand. If the user sets auto-hue to ON, you set the 
hue enable bit and hue value to default. If the user sets auto-hue to OFF, 
you just set the hue enable bit on and don't change the value. Does ov6650 
actually support auto-hue?

> +		break;
> +	case V4L2_CID_HUE:
> +		ret = ov6650_reg_rmw(client, REG_HUE, SET_HUE(ctrl->value),
> +				SET_HUE(HUE_MASK));
> +		if (ret)
> +			break;
> +		priv->hue = ctrl->value;
> +		priv->hue_auto = (priv->hue == DEF_HUE);

Here it seems like in order to adjust hue you always have to set the 
enable bit. Again, I wouldn't touch hue_auto here - default and auto are 
different things.

> +		break;
> +	case V4L2_CID_BRIGHTNESS:
> +		ret = ov6650_reg_write(client, REG_BRT, ctrl->value);
> +		if (ret)
> +			break;
> +		priv->brightness = ctrl->value;
> +		break;
> +	case V4L2_CID_EXPOSURE_AUTO:
> +		switch (ctrl->value) {
> +		case V4L2_EXPOSURE_AUTO:
> +			ret = ov6650_reg_write(client, REG_AECH, DEF_AECH);

Is this a requirement for auto-exposure, that you have to set the (analog 
manual) exposure to the default value?

> +			if (ret)
> +				break;
> +			priv->exposure = DEF_AECH;
> +			ret = ov6650_reg_rmw(client, REG_COMB, COMB_AEC, 0);
> +			break;
> +		default:
> +			ret = ov6650_reg_rmw(client, REG_COMB, 0, COMB_AEC);
> +			break;
> +		}
> +		if (ret)
> +			break;
> +		priv->aec = ctrl->value;
> +		break;
> +	case V4L2_CID_EXPOSURE:
> +		ret = ov6650_reg_write(client, REG_AECH, ctrl->value);
> +		if (ret)
> +			break;
> +		priv->exposure = ctrl->value;
> +		automatic = (priv->exposure == DEF_AECH);
> +		if (automatic)
> +			ret = ov6650_reg_rmw(client, REG_COMB, COMB_AEC, 0);
> +		else
> +			ret = ov6650_reg_rmw(client, REG_COMB, 0, COMB_AEC);
> +		if (ret)
> +			break;
> +		priv->aec = automatic ? V4L2_EXPOSURE_AUTO :
> +				V4L2_EXPOSURE_MANUAL;

Again - don't see why you need to touch the auto setting here.

> +		break;
> +	case V4L2_CID_GAMMA:
> +		ret = ov6650_reg_write(client, REG_GAM1, ctrl->value);
> +		if (ret)
> +			break;
> +		priv->gamma = ctrl->value;
> +		break;
> +	case V4L2_CID_VFLIP:
> +		if (ctrl->value)
> +			ret = ov6650_reg_rmw(client, REG_COMB,
> +							COMB_FLIP_V, 0);
> +		else
> +			ret = ov6650_reg_rmw(client, REG_COMB,
> +							0, COMB_FLIP_V);
> +		if (ret)
> +			break;
> +		priv->vflip = ctrl->value;
> +		break;
> +	case V4L2_CID_HFLIP:
> +		if (ctrl->value)
> +			ret = ov6650_reg_rmw(client, REG_COMB,
> +							COMB_FLIP_H, 0);
> +		else
> +			ret = ov6650_reg_rmw(client, REG_COMB,
> +							0, COMB_FLIP_H);
> +		if (ret)
> +			break;
> +		priv->hflip = ctrl->value;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +/* Get chip identification */
> +static int ov6650_g_chip_ident(struct v4l2_subdev *sd,
> +				struct v4l2_dbg_chip_ident *id)
> +{
> +	id->ident	= V4L2_IDENT_OV6650;
> +	id->revision	= 0;
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +static int ov6650_get_register(struct v4l2_subdev *sd,
> +				struct v4l2_dbg_register *reg)
> +{
> +	struct i2c_client *client = sd->priv;
> +	int ret;
> +	u8 val;
> +
> +	if (reg->reg & ~0xff)
> +		return -EINVAL;
> +
> +	reg->size = 1;
> +
> +	ret = ov6650_reg_read(client, reg->reg, &val);
> +	if (ret)
> +		return ret;
> +
> +	reg->val = (__u64)val;
> +
> +	return 0;
> +}
> +
> +static int ov6650_set_register(struct v4l2_subdev *sd,
> +				struct v4l2_dbg_register *reg)
> +{
> +	struct i2c_client *client = sd->priv;
> +
> +	if (reg->reg & ~0xff || reg->val & ~0xff)
> +		return -EINVAL;
> +
> +	return ov6650_reg_write(client, reg->reg, reg->val);
> +}
> +#endif
> +
> +/* select nearest higher resolution for capture */
> +static void ov6650_res_roundup(u32 *width, u32 *height)
> +{
> +	int i;
> +	enum { QCIF, CIF };
> +	int res_x[] = { 176, 352 };
> +	int res_y[] = { 144, 288 };
> +
> +	for (i = 0; i < ARRAY_SIZE(res_x); i++) {
> +		if (res_x[i] >= *width && res_y[i] >= *height) {
> +			*width = res_x[i];
> +			*height = res_y[i];
> +			return;
> +		}
> +	}
> +
> +	*width = res_x[CIF];
> +	*height = res_y[CIF];
> +}

This can be replaced by a version of

http://www.spinics.net/lists/linux-media/msg21893.html

when it is fixed and accepted;) I'll try to send an updated version of 
that patch tomorrow.

> +
> +/* program default register values */
> +static int ov6650_prog_dflt(struct i2c_client *client)
> +{
> +	int i, ret;
> +
> +	dev_dbg(&client->dev, "reinitializing\n");
> +
> +	for (i = 0; i < ARRAY_SIZE(ov6650_regs_dflt); i++) {
> +		ret = ov6650_reg_write(client, ov6650_regs_dflt[i].reg,
> +						ov6650_regs_dflt[i].val);
> +		if (ret)
> +			return ret;
> +	}

Hm, please, don't. I generally don't like such register - value array 
magic for a number of reasons, and in your case it's just one (!) register 
write operation - please, remove this array and just write the register 
explicitly. You also don't need DEF_COMA - writing an explicit "0" and 
adding a comment - "clear all flags, including reset" would be perfect!

> +
> +	return 0;
> +}
> +
> +/* set the format we will capture in */
> +static int ov6650_s_fmt(struct v4l2_subdev *sd,
> +			struct v4l2_mbus_framefmt *mf)
> +{
> +	struct i2c_client *client = sd->priv;
> +	struct soc_camera_device *icd	= client->dev.platform_data;
> +	struct soc_camera_sense *sense = icd->sense;
> +	struct ov6650 *priv = to_ov6650(client);
> +	enum v4l2_colorspace cspace;
> +	enum v4l2_mbus_pixelcode code = mf->code;
> +	unsigned long pclk;
> +	u8 coma_set = 0, coma_mask = 0, coml_set = 0, coml_mask = 0, clkrc;
> +	int ret;
> +
> +	/* select color matrix configuration for given color encoding */
> +	switch (code) {
> +	case V4L2_MBUS_FMT_GREY8_1X8:
> +		dev_dbg(&client->dev, "pixel format GREY8_1X8\n");
> +		coma_set |= COMA_BW;
> +		coma_mask |= COMA_RGB | COMA_WORD_SWAP | COMA_BYTE_SWAP;
> +		coml_mask |= COML_ONE_CHANNEL;
> +		cspace = V4L2_COLORSPACE_JPEG;
> +		priv->pclk_max = 4000000;
> +		break;
> +	case V4L2_MBUS_FMT_YUYV8_2X8_LE:
> +		dev_dbg(&client->dev, "pixel format YUYV8_2X8_LE\n");
> +		coma_set |= COMA_WORD_SWAP;
> +		coma_mask |= COMA_RGB | COMA_BW | COMA_BYTE_SWAP;
> +		goto yuv;

Well, this doesn't look critical to me, i.e., eventually I would accept 
this, but, as you know, goto's in the kernel are (almost) only used for 
failure cases, besides, what makes this use even less pretty, this is a 
goto into a switch statement... I would set a "yuv = 1" variable instead 
of goto's, and use a "if (yuv) after the switch.

> +	case V4L2_MBUS_FMT_YVYU8_2X8_LE:
> +		dev_dbg(&client->dev, "pixel format YVYU8_2X8_LE (untested)\n");
> +		coma_mask |= COMA_RGB | COMA_BW | COMA_WORD_SWAP |
> +				COMA_BYTE_SWAP;
> +		goto yuv;
> +	case V4L2_MBUS_FMT_YUYV8_2X8_BE:
> +		dev_dbg(&client->dev, "pixel format YUYV8_2X8_BE\n");
> +		if (mf->width == W_CIF) {
> +			coma_set |= COMA_BYTE_SWAP | COMA_WORD_SWAP;
> +			coma_mask |= COMA_RGB | COMA_BW;
> +		} else {
> +			coma_set |= COMA_BYTE_SWAP;
> +			coma_mask |= COMA_RGB | COMA_BW | COMA_WORD_SWAP;
> +		}
> +		goto yuv;
> +	case V4L2_MBUS_FMT_YVYU8_2X8_BE:
> +		dev_dbg(&client->dev, "pixel format YVYU8_2X8_BE (untested)\n");
> +		if (mf->width == W_CIF) {
> +			coma_set |= COMA_BYTE_SWAP;
> +			coma_mask |= COMA_RGB | COMA_BW | COMA_WORD_SWAP;
> +		} else {
> +			coma_set |= COMA_BYTE_SWAP | COMA_WORD_SWAP;
> +			coma_mask |= COMA_RGB | COMA_BW;
> +		}
> +yuv:
> +		coml_set |= COML_ONE_CHANNEL;
> +		cspace = V4L2_COLORSPACE_JPEG;
> +		priv->pclk_max = 8000000;
> +		break;
> +	case V4L2_MBUS_FMT_SBGGR8_1X8:
> +		dev_dbg(&client->dev, "pixel format SBGGR8_1X8 (untested)\n");
> +		coma_set |= COMA_RAW_RGB | COMA_RGB;
> +		coma_mask |= COMA_BW | COMA_BYTE_SWAP | COMA_WORD_SWAP;
> +		coml_mask |= COML_ONE_CHANNEL;
> +		cspace = V4L2_COLORSPACE_SRGB;
> +		priv->pclk_max = 4000000;
> +		break;
> +	default:
> +		dev_err(&client->dev, "Pixel format not handled : %x\n", code);
> +		return -EINVAL;
> +	}
> +
> +	/* select register configuration for given resolution */
> +	ov6650_res_roundup(&mf->width, &mf->height);
> +
> +	switch (mf->width) {
> +	case W_QCIF:
> +		dev_dbg(&client->dev, "resolution QCIF\n");
> +		priv->qcif = 1;
> +		coma_set |= COMA_QCIF;
> +		priv->pclk_max /= 2;
> +		break;
> +	case W_CIF:
> +		dev_dbg(&client->dev, "resolution CIF\n");
> +		priv->qcif = 0;
> +		coma_mask |= COMA_QCIF;
> +		break;
> +	default:
> +		dev_err(&client->dev, "unspported resolution!\n");
> +		return -EINVAL;
> +	}
> +
> +	if (priv->timeperframe.numerator && priv->timeperframe.denominator)
> +		pclk = priv->pclk_max * priv->timeperframe.denominator /
> +				(FRAME_RATE_MAX * priv->timeperframe.numerator);
> +	else
> +		pclk = priv->pclk_max;
> +
> +	if (sense) {
> +		if (sense->master_clock == 8000000) {
> +			dev_dbg(&client->dev, "8MHz input clock\n");
> +			clkrc = CLKRC_6MHz;
> +		} else if (sense->master_clock == 12000000) {
> +			dev_dbg(&client->dev, "12MHz input clock\n");
> +			clkrc = CLKRC_12MHz;
> +		} else if (sense->master_clock == 16000000) {
> +			dev_dbg(&client->dev, "16MHz input clock\n");
> +			clkrc = CLKRC_16MHz;
> +		} else if (sense->master_clock == 24000000) {
> +			dev_dbg(&client->dev, "24MHz input clock\n");
> +			clkrc = CLKRC_24MHz;
> +		} else {
> +			dev_err(&client->dev,
> +				"unspported input clock, check platform data"
> +				"\n");
> +			return -EINVAL;
> +		}
> +		priv->pclk_limit = sense->pixel_clock_max;
> +		if (priv->pclk_limit &&
> +				(priv->pclk_limit < pclk))

This can go on one line.

> +			pclk = priv->pclk_limit;
> +	} else {
> +		priv->pclk_limit = 0;
> +		clkrc = 0xc0;
> +		dev_dbg(&client->dev, "using default 24MHz input clock\n");
> +	}
> +
> +	clkrc |= (priv->pclk_max - 1) / pclk;
> +	pclk = priv->pclk_max / GET_CLKRC_DIV(clkrc);

This would look better as

	clkrc_div = (priv->pclk_max - 1) / pclk;
	clkrc |= clkrc_div;
	pclk = priv->pclk_max / clkrc_div;

> +	dev_dbg(&client->dev, "pixel clock divider: %ld.%ld\n",
> +			sense->master_clock / pclk,
> +			10 * sense->master_clock % pclk / pclk);
> +
> +	ov6650_reset(client);
> +
> +	ret = ov6650_prog_dflt(client);
> +	if (ret)
> +		return ret;
> +
> +

Superfluous empty line;)

> +	ret = ov6650_reg_rmw(client, REG_COMA, coma_set, coma_mask);
> +	if (!ret)
> +		ret = ov6650_reg_write(client, REG_CLKRC, clkrc);
> +	if (!ret)
> +		ret = ov6650_reg_rmw(client, REG_COML, coml_set, coml_mask);
> +
> +	if (!ret) {
> +		mf->code	= code;
> +		mf->colorspace	= cspace;
> +	}
> +
> +	return ret;
> +}
> +
> +static int ov6650_try_fmt(struct v4l2_subdev *sd,
> +			  struct v4l2_mbus_framefmt *mf)
> +{
> +	ov6650_res_roundup(&mf->width, &mf->height);
> +
> +	mf->field = V4L2_FIELD_NONE;
> +
> +	switch (mf->code) {
> +	case V4L2_MBUS_FMT_Y10_1X10:
> +		mf->code = V4L2_MBUS_FMT_GREY8_1X8;
> +	case V4L2_MBUS_FMT_GREY8_1X8:
> +	case V4L2_MBUS_FMT_YVYU8_2X8_LE:
> +	case V4L2_MBUS_FMT_YUYV8_2X8_LE:
> +	case V4L2_MBUS_FMT_YVYU8_2X8_BE:
> +	case V4L2_MBUS_FMT_YUYV8_2X8_BE:
> +		mf->colorspace = V4L2_COLORSPACE_JPEG;
> +		break;
> +	default:
> +		mf->code = V4L2_MBUS_FMT_SBGGR8_1X8;
> +	case V4L2_MBUS_FMT_SBGGR8_1X8:
> +		mf->colorspace = V4L2_COLORSPACE_SRGB;
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static int ov6650_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
> +			   enum v4l2_mbus_pixelcode *code)
> +{
> +	if ((unsigned int)index >= ARRAY_SIZE(ov6650_codes))
> +		return -EINVAL;
> +
> +	*code = ov6650_codes[index];
> +	return 0;
> +}
> +
> +static int ov6650_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
> +{
> +	struct i2c_client *client = sd->priv;
> +	struct ov6650 *priv = to_ov6650(client);
> +	int shift = !priv->qcif;
> +
> +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	/* Crop limits depend on selected frame format (CIF/QCIF) */
> +	a->bounds.left			= DEF_HSTRT << shift;
> +	a->bounds.top			= DEF_VSTRT << shift;
> +	a->bounds.width			= W_QCIF << shift;
> +	a->bounds.height		= H_QCIF << shift;
> +	/* REVISIT: should defrect provide actual or default geometry? */

default

> +	a->defrect			= a->bounds;
> +	a->pixelaspect.numerator	= 1;
> +	a->pixelaspect.denominator	= 1;
> +
> +	return 0;
> +}
> +
> +static int ov6650_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
> +{
> +	struct i2c_client *client = sd->priv;
> +	struct ov6650 *priv = to_ov6650(client);
> +	struct v4l2_rect *rect = &a->c;
> +	int shift = !priv->qcif;
> +	u8 hstrt, vstrt, hstop, vstop;
> +	int ret;
> +
> +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	ret = ov6650_reg_read(client, REG_HSTRT, &hstrt);
> +	if (!ret)
> +		ret = ov6650_reg_read(client, REG_HSTOP, &hstop);
> +	if (!ret)
> +		ret = ov6650_reg_read(client, REG_VSTRT, &vstrt);
> +	if (!ret)
> +		ret = ov6650_reg_read(client, REG_VSTOP, &vstop);
> +
> +	if (!ret) {
> +		rect->left	= hstrt << shift;
> +		rect->top	= vstrt << shift;
> +		rect->width	= (hstop - hstrt) << shift;
> +		rect->height	= (vstop - vstrt) << shift;
> +	}
> +
> +	return ret;
> +}
> +
> +static int ov6650_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
> +{
> +	struct i2c_client *client = sd->priv;
> +	struct ov6650 *priv = to_ov6650(client);
> +	struct v4l2_rect *rect = &a->c;
> +	int shift = !priv->qcif;
> +	u8 hstrt, vstrt, hstop, vstop;
> +	int ret;
> +
> +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	hstrt = rect->left >> shift;
> +	vstrt = rect->top >> shift;
> +	hstop = hstrt + (rect->width >> shift);
> +	vstop = vstrt + (rect->height >> shift);
> +
> +	if ((hstop > DEF_HSTOP) || (vstop > DEF_VSTOP)) {
> +		dev_err(&client->dev, "Invalid window geometry!\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = ov6650_reg_write(client, REG_HSTRT, hstrt);
> +	if (!ret)
> +		ret = ov6650_reg_write(client, REG_HSTOP, hstop);
> +	if (!ret)
> +		ret = ov6650_reg_write(client, REG_VSTRT, vstrt);
> +	if (!ret)
> +		ret = ov6650_reg_write(client, REG_VSTOP, vstop);

Are cropping and scaling on this camera absolutely independent? I.e., you 
can set any output format (CIF or QCIF) and it will just scale whatever 
rectangle has been configured? And the other way round - you set arbitrary 
cropping and output format stays the same?

> +
> +	return ret;
> +}
> +
> +static int ov6650_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
> +{
> +	struct i2c_client *client = sd->priv;
> +	struct v4l2_captureparm *cp = &parms->parm.capture;
> +	u8 clkrc;
> +	int ret;
> +
> +	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	ret = ov6650_reg_read(client, REG_CLKRC, &clkrc);
> +	if (ret < 0)
> +		return ret;
> +
> +	memset(cp, 0, sizeof(struct v4l2_captureparm));
> +	cp->capability = V4L2_CAP_TIMEPERFRAME;
> +	cp->timeperframe.numerator = GET_CLKRC_DIV(clkrc);
> +	cp->timeperframe.denominator = FRAME_RATE_MAX;
> +
> +	dev_dbg(&client->dev, "Frame interval: %u/%u\n",
> +		cp->timeperframe.numerator, cp->timeperframe.denominator);
> +
> +	return 0;
> +}
> +
> +static int ov6650_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
> +{
> +	struct i2c_client *client = sd->priv;
> +	struct ov6650 *priv = to_ov6650(client);
> +	struct v4l2_captureparm *cp = &parms->parm.capture;
> +	struct v4l2_fract *tpf = &cp->timeperframe;
> +	int div, ret;
> +
> +	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	if (cp->extendedmode != 0)
> +		return -EINVAL;
> +
> +	if (tpf->numerator == 0 || tpf->denominator == 0)
> +		div = 1;  /* Reset to full rate */
> +	else
> +		div = (tpf->numerator * FRAME_RATE_MAX) / tpf->denominator;
> +
> +	if (div == 0)
> +		div = 1;
> +	else if (div > CLKRC_DIV_MASK + 1)
> +		div = CLKRC_DIV_MASK + 1;
> +
> +	if (priv->pclk_max && priv->pclk_limit) {
> +		ret = (priv->pclk_max - 1) / priv->pclk_limit;
> +		if (div < ret)
> +			div = ret;
> +	}
> +
> +	ret = ov6650_reg_rmw(client, REG_CLKRC, div - 1, CLKRC_DIV_MASK);
> +	if (!ret) {
> +		priv->timeperframe.numerator = tpf->numerator = FRAME_RATE_MAX;
> +		priv->timeperframe.denominator = tpf->denominator = div;
> +	}
> +
> +	return ret;
> +}
> +
> +static int ov6650_video_probe(struct soc_camera_device *icd,
> +				struct i2c_client *client)
> +{
> +	u8		pidh, pidl, midh, midl;
> +	int		ret = 0;
> +
> +	/*
> +	 * check and show product ID and manufacturer ID
> +	 */
> +	ret = ov6650_reg_read(client, REG_PIDH, &pidh);
> +	if (!ret)
> +		ret = ov6650_reg_read(client, REG_PIDL, &pidl);
> +	if (!ret)
> +		ret = ov6650_reg_read(client, REG_MIDH, &midh);
> +	if (!ret)
> +		ret = ov6650_reg_read(client, REG_MIDL, &midl);
> +
> +	if (ret)
> +		goto err;
> +
> +	if ((pidh != OV6650_PIDH) || (pidl != OV6650_PIDL)) {
> +		dev_err(&client->dev, "Product ID error %x:%x\n", pidh, pidl);
> +		ret = -ENODEV;
> +		goto err;
> +	}
> +
> +	dev_info(&client->dev, "ov6650 Product ID %0x:%0x Manufacturer ID %x:%x"
> +			"\n", pidh, pidl, midh, midl);
> +
> +err:
> +	return ret;
> +}
> +
> +static struct soc_camera_ops ov6650_ops = {
> +	.set_bus_param		= ov6650_set_bus_param,
> +	.query_bus_param	= ov6650_query_bus_param,
> +	.controls		= ov6650_controls,
> +	.num_controls		= ARRAY_SIZE(ov6650_controls),
> +};
> +
> +static struct v4l2_subdev_core_ops ov6650_core_ops = {
> +	.g_ctrl			= ov6650_g_ctrl,
> +	.s_ctrl			= ov6650_s_ctrl,
> +	.g_chip_ident		= ov6650_g_chip_ident,
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +	.g_register		= ov6650_get_register,
> +	.s_register		= ov6650_set_register,
> +#endif
> +

Superfluous empty line

> +};
> +
> +static struct v4l2_subdev_video_ops ov6650_video_ops = {
> +	.s_stream	= ov6650_s_stream,
> +	.s_mbus_fmt	= ov6650_s_fmt,
> +	.try_mbus_fmt	= ov6650_try_fmt,

Please, implement.g_mbus_fmt.

> +	.enum_mbus_fmt	= ov6650_enum_fmt,
> +	.cropcap	= ov6650_cropcap,
> +	.g_crop		= ov6650_g_crop,
> +	.s_crop		= ov6650_s_crop,
> +	.g_parm		= ov6650_g_parm,
> +	.s_parm		= ov6650_s_parm,
> +

Superfluous empty line

> +};
> +
> +static struct v4l2_subdev_ops ov6650_subdev_ops = {
> +	.core	= &ov6650_core_ops,
> +	.video	= &ov6650_video_ops,
> +};
> +
> +/*
> + * i2c_driver function
> + */
> +static int ov6650_probe(struct i2c_client *client,
> +			const struct i2c_device_id *did)
> +{
> +	struct ov6650 *priv;
> +	struct soc_camera_device *icd	= client->dev.platform_data;

Nothing to align here, a space before "=" would suffice;)

> +	struct soc_camera_link *icl;
> +	int ret;
> +
> +	if (!icd) {
> +		dev_err(&client->dev, "Missing soc-camera data!\n");
> +		return -EINVAL;
> +	}
> +
> +	icl = to_soc_camera_link(icd);
> +	if (!icl) {
> +		dev_err(&client->dev, "Missing platform_data for driver\n");
> +		return -EINVAL;
> +	}
> +
> +	priv = kzalloc(sizeof(struct ov6650), GFP_KERNEL);
> +	if (!priv) {
> +		dev_err(&client->dev,
> +			"Failed to allocate memory for private data!\n");
> +		return -ENOMEM;
> +	}
> +
> +	v4l2_i2c_subdev_init(&priv->subdev, client, &ov6650_subdev_ops);
> +
> +	icd->ops	= &ov6650_ops;

A matter of taste, eventually, but I'd use a space.

> +
> +	ret = ov6650_video_probe(icd, client);
> +
> +	if (ret) {
> +		icd->ops = NULL;
> +		i2c_set_clientdata(client, NULL);
> +		kfree(priv);
> +	}
> +
> +	return ret;
> +}
> +
> +static int ov6650_remove(struct i2c_client *client)
> +{
> +	struct ov6650 *priv = to_ov6650(client);
> +
> +	i2c_set_clientdata(client, NULL);
> +	kfree(priv);
> +	return 0;
> +}
> +
> +static const struct i2c_device_id ov6650_id[] = {
> +	{ "ov6650", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, ov6650_id);
> +
> +static struct i2c_driver ov6650_i2c_driver = {
> +	.driver = {
> +		.name = "ov6650",
> +	},
> +	.probe    = ov6650_probe,
> +	.remove   = ov6650_remove,
> +	.id_table = ov6650_id,
> +};
> +
> +static int __init ov6650_module_init(void)
> +{
> +	return i2c_add_driver(&ov6650_i2c_driver);
> +}
> +
> +static void __exit ov6650_module_exit(void)
> +{
> +	i2c_del_driver(&ov6650_i2c_driver);
> +}
> +
> +module_init(ov6650_module_init);
> +module_exit(ov6650_module_exit);
> +
> +MODULE_DESCRIPTION("SoC Camera driver for OmniVision OV6650");
> +MODULE_AUTHOR("Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>");
> +MODULE_LICENSE("GPL v2");
> --- linux-2.6.35-rc3.orig/include/media/v4l2-chip-ident.h	2010-06-26 15:56:15.000000000 +0200
> +++ linux-2.6.35-rc3/include/media/v4l2-chip-ident.h	2010-06-26 17:28:09.000000000 +0200
> @@ -70,6 +70,7 @@ enum {
>  	V4L2_IDENT_OV9655 = 255,
>  	V4L2_IDENT_SOI968 = 256,
>  	V4L2_IDENT_OV9640 = 257,
> +	V4L2_IDENT_OV6650 = 258,
>  
>  	/* module saa7146: reserved range 300-309 */
>  	V4L2_IDENT_SAA7146 = 300,
> 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
