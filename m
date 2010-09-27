Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:53195 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758167Ab0I0DOc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Sep 2010 23:14:32 -0400
To: linux-media@vger.kernel.org
Subject: [PATCH v3 3/6] SoC Camera: add driver for OV6650 sensor
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"Discussion of the Amstrad E3 emailer hardware/software"
	<e3-hacking@earth.li>
Content-Disposition: inline
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Date: Mon, 27 Sep 2010 05:14:00 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009270514.01865.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch provides a V4L2 SoC Camera driver for OV6650 camera sensor, found 
on OMAP1 SoC based Amstrad Delta videophone.

Since I have no experience with camera sensors, and the sensor documentation I 
was able to find was not very comprehensive, I left most settings at their 
default (reset) values, except for:
- those required for proper mediabus parameters and picture geometry and 
  format setup,
- those used by controls.
Resulting picture quality may be far from perfect, but better than nothing.

In order to be able to get / set the sensor frame rate from userspace, I 
decided to provide two not yet SoC camera supported operations, g_parm and 
s_parm. These can be used after applying patch 4/6 from this series, 
"SoC Camera: add support for g_parm / s_parm operations".

Created and tested against linux-2.6.36-rc5 on Amstrad Delta.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---

Guennadi,
I decided to submit the updated version of the sensor driver first to ensure 
it is OK before I submit the host interface driver, which I've been able to 
simplify a lot now when I think I better understand how v4l2 sensors work. 
Moreover, the OMAP bits are already applied in part by Tony, so there is no 
need to resubmit the whole set.

Thanks,
Janusz


v2 -> v3 changes:

requested, suggested or inspired by Guennadi Liakhovetski (thanks again!):
- no reason to use msleep_interruptible(1), use a udelay(1000) or even try 
  whether a udelay(100) suffices too (it does); ended up with usleep_range() 
  to better satisfy checkpatch,
- drop superfluous parenthesis,
- coml_mask and coml_set are only set here and only used once below, so, 
  dropping initialisation to 0 in variable definitions and use a more readable 
  code pattern,
- cropcap shouldn't depend on any dynamic (configured by S_FMT) setting, put 
  the full sensor resolution in cropcap,
- in struct ov6650 definition, select a better name for the .qcif member,
  like .half_scale, add comments to both .rect and .half_scale memeber 
  declrations,
- use false/true, not 0/1, in boolean asignments,
- drop ov6650_reset() and ov6650_prog_dflt() calls from the s_fmt completely, 
  move them over into the ov6650_video_probe(),
- in s_crop, also ensure that rect->left and rect->top are within limits,
- in s_mbus_fmt, select an input rectangle _closest_ to the currently 
  configured one that would allow to possibly exactly configure the requested 
  output format, then set ->rect and ->half_scale with new values,
- in g_fmt, return ->rect scaled with ->half_scale

other:
- in unscaled mode, align all rect members by 2,
- don't fail if requested rectangle is out of limits, adjust it instead,
- add support for geometry only change to s_fmt,
- don't overwrite s_parm requested timeperframe value with the one calculated
  from platform requested pixel clock limit, use it as another limit,
- convert reusable code used for clock divisor calculation into a helper 
  funtion, use it also in g_parm instead of reading the CLKRC register,
- no need to copy rect members one by one, use a single assignment of the 
  whole structure,
- still a few cosmetic changes.


v1 -> v2 changes:

requested by Guennadi Liakhovetski (thanks!):
- include <linux/bitops.h> if using BIT() macro,
- sort headers alphabetically,
- don't mix tabs with spaces (preferred) when separating symbols from 
  #define keywords,
- drop unused NUM_REGS definition,
- optimize SET_SAT() and SAT_MASK macros,
- reuse no longer needed function argument instead of declaring a new local 
  variable,
- don't touch auto controls when changing their correspondig manual settings, 
  and vice versa,
- drop probably unsupported auto-hue control,
- initialize sensor by writing registers explicitly instead of using a "magic" 
  initialization array,
- avoid gotos, don't use them other than in failure cases,
- make pclk computation more readable,
- implement g_mbus_fmt() callback,
- correct a few obvious mistakes,
- remove a few extra whitespaces,

suggested by Ralph Corderoy (thanks!):
- use one common format when hex printing register addresses and values,
- optimize if(ret) vs. if(!ret) constructs usage,
- replace a few if-else constructs with more compact, conditional 
  expression based, when translating controls to register bits,
- optimize ov6650_res_roundup(),
- drop redundant cast of index from ov6650_enum_fmt(),
- use variable identifiers rather than their types as sizeof() arguments,

other:
- disable band filter, auto exposure control seems working more effectively 
  without it,
- refresh against linux-2.6.36-rc3.


 drivers/media/video/Kconfig     |    6
 drivers/media/video/Makefile    |    1
 drivers/media/video/ov6650.c    | 1224 ++++++++++++++++++++++++++++++++++++++++
 include/media/v4l2-chip-ident.h |    1
 4 files changed, 1232 insertions(+)


diff -upr linux-2.6.36-rc5.orig/drivers/media/video/Kconfig linux-2.6.36-rc5/drivers/media/video/Kconfig
--- linux-2.6.36-rc5.orig/drivers/media/video/Kconfig	2010-09-24 15:39:05.000000000 +0200
+++ linux-2.6.36-rc5/drivers/media/video/Kconfig	2010-09-24 21:18:29.000000000 +0200
@@ -835,6 +835,12 @@ config SOC_CAMERA_PLATFORM
 	help
 	  This is a generic SoC camera platform driver, useful for testing
 
+config SOC_CAMERA_OV6650
+	tristate "ov6650 sensor support"
+	depends on SOC_CAMERA && I2C
+	---help---
+	  This is a V4L2 SoC camera driver for the OmniVision OV6650 sensor
+
 config SOC_CAMERA_OV772X
 	tristate "ov772x camera support"
 	depends on SOC_CAMERA && I2C
diff -upr linux-2.6.36-rc5.orig/drivers/media/video/Makefile linux-2.6.36-rc5/drivers/media/video/Makefile
--- linux-2.6.36-rc5.orig/drivers/media/video/Makefile	2010-09-24 15:39:05.000000000 +0200
+++ linux-2.6.36-rc5/drivers/media/video/Makefile	2010-09-24 21:18:29.000000000 +0200
@@ -79,6 +79,7 @@ obj-$(CONFIG_SOC_CAMERA_MT9M111)	+= mt9m
 obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= mt9t031.o
 obj-$(CONFIG_SOC_CAMERA_MT9T112)	+= mt9t112.o
 obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= mt9v022.o
+obj-$(CONFIG_SOC_CAMERA_OV6650)		+= ov6650.o
 obj-$(CONFIG_SOC_CAMERA_OV772X)		+= ov772x.o
 obj-$(CONFIG_SOC_CAMERA_OV9640)		+= ov9640.o
 obj-$(CONFIG_SOC_CAMERA_RJ54N1)		+= rj54n1cb0c.o
diff -upr linux-2.6.36-rc5.orig/drivers/media/video/ov6650.c linux-2.6.36-rc5/drivers/media/video/ov6650.c
--- linux-2.6.36-rc5.orig/drivers/media/video/ov6650.c	2010-09-24 15:39:07.000000000 +0200
+++ linux-2.6.36-rc5/drivers/media/video/ov6650.c	2010-09-26 23:41:09.000000000 +0200
@@ -0,0 +1,1224 @@
+/*
+ * V4L2 SoC Camera driver for OmniVision OV6650 Camera Sensor
+ *
+ * Copyright (C) 2010 Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
+ *
+ * Based on OmniVision OV96xx Camera Driver
+ * Copyright (C) 2009 Marek Vasut <marek.vasut@gmail.com>
+ *
+ * Based on ov772x camera driver:
+ * Copyright (C) 2008 Renesas Solutions Corp.
+ * Kuninori Morimoto <morimoto.kuninori@renesas.com>
+ *
+ * Based on ov7670 and soc_camera_platform driver,
+ * Copyright 2006-7 Jonathan Corbet <corbet@lwn.net>
+ * Copyright (C) 2008 Magnus Damm
+ * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
+ *
+ * Hardware specific bits initialy based on former work by Matt Callow
+ * drivers/media/video/omap/sensor_ov6650.c
+ * Copyright (C) 2006 Matt Callow
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/bitops.h>
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <media/soc_camera.h>
+#include <media/v4l2-chip-ident.h>
+
+
+/* Register definitions */
+#define REG_GAIN		0x00	/* range 00 - 3F */
+#define REG_BLUE		0x01
+#define REG_RED			0x02
+#define REG_SAT			0x03	/* [7:4] saturation [0:3] reserved */
+#define REG_HUE			0x04	/* [7:6] rsrvd [5] hue en [4:0] hue */
+
+#define REG_BRT			0x06
+
+#define REG_PIDH		0x0a
+#define REG_PIDL		0x0b
+
+#define REG_AECH		0x10
+#define REG_CLKRC		0x11	/* Data Format and Internal Clock */
+					/* [7:6] Input system clock (MHz)*/
+					/*   00=8, 01=12, 10=16, 11=24 */
+					/* [5:0]: Internal Clock Pre-Scaler */
+#define REG_COMA		0x12	/* [7] Reset */
+#define REG_COMB		0x13
+#define REG_COMC		0x14
+#define REG_COMD		0x15
+#define REG_COML		0x16
+#define REG_HSTRT		0x17
+#define REG_HSTOP		0x18
+#define REG_VSTRT		0x19
+#define REG_VSTOP		0x1a
+#define REG_PSHFT		0x1b
+#define REG_MIDH		0x1c
+#define REG_MIDL		0x1d
+#define REG_HSYNS		0x1e
+#define REG_HSYNE		0x1f
+#define REG_COME		0x20
+#define REG_YOFF		0x21
+#define REG_UOFF		0x22
+#define REG_VOFF		0x23
+#define REG_AEW			0x24
+#define REG_AEB			0x25
+#define REG_COMF		0x26
+#define REG_COMG		0x27
+#define REG_COMH		0x28
+#define REG_COMI		0x29
+
+#define REG_FRARL		0x2b
+#define REG_COMJ		0x2c
+#define REG_COMK		0x2d
+#define REG_AVGY		0x2e
+#define REG_REF0		0x2f
+#define REG_REF1		0x30
+#define REG_REF2		0x31
+#define REG_FRAJH		0x32
+#define REG_FRAJL		0x33
+#define REG_FACT		0x34
+#define REG_L1AEC		0x35
+#define REG_AVGU		0x36
+#define REG_AVGV		0x37
+
+#define REG_SPCB		0x60
+#define REG_SPCC		0x61
+#define REG_GAM1		0x62
+#define REG_GAM2		0x63
+#define REG_GAM3		0x64
+#define REG_SPCD		0x65
+
+#define REG_SPCE		0x68
+#define REG_ADCL		0x69
+
+#define REG_RMCO		0x6c
+#define REG_GMCO		0x6d
+#define REG_BMCO		0x6e
+
+
+/* Register bits, values, etc. */
+#define OV6650_PIDH		0x66	/* high byte of product ID number */
+#define OV6650_PIDL		0x50	/* low byte of product ID number */
+#define OV6650_MIDH		0x7F	/* high byte of mfg ID */
+#define OV6650_MIDL		0xA2	/* low byte of mfg ID */
+
+#define DEF_GAIN		0x00
+#define DEF_BLUE		0x80
+#define DEF_RED			0x80
+
+#define SAT_SHIFT		4
+#define SAT_MASK		(0xf << SAT_SHIFT)
+#define SET_SAT(x)		(((x) << SAT_SHIFT) & SAT_MASK)
+
+#define HUE_EN			BIT(5)
+#define HUE_MASK		0x1f
+#define DEF_HUE			0x10
+#define SET_HUE(x)		(HUE_EN | ((x) & HUE_MASK))
+
+#define DEF_AECH		0x4D
+
+#define CLKRC_6MHz		0x00
+#define CLKRC_12MHz		0x40
+#define CLKRC_16MHz		0x80
+#define CLKRC_24MHz		0xc0
+#define CLKRC_DIV_MASK		0x3f
+#define GET_CLKRC_DIV(x)	(((x) & CLKRC_DIV_MASK) + 1)
+
+#define COMA_RESET		BIT(7)
+#define COMA_QCIF		BIT(5)
+#define COMA_RAW_RGB		BIT(4)
+#define COMA_RGB		BIT(3)
+#define COMA_BW			BIT(2)
+#define COMA_WORD_SWAP		BIT(1)
+#define COMA_BYTE_SWAP		BIT(0)
+#define DEF_COMA		0x00
+
+#define COMB_FLIP_V		BIT(7)
+#define COMB_FLIP_H		BIT(5)
+#define COMB_BAND_FILTER	BIT(4)
+#define COMB_AWB		BIT(2)
+#define COMB_AGC		BIT(1)
+#define COMB_AEC		BIT(0)
+#define DEF_COMB		0x5f
+
+#define COML_ONE_CHANNEL	BIT(7)
+
+#define DEF_HSTRT		0x24
+#define DEF_HSTOP		0xd4
+#define DEF_VSTRT		0x04
+#define DEF_VSTOP		0x94
+
+#define COMF_HREF_LOW		BIT(4)
+
+#define COMJ_PCLK_RISING	BIT(4)
+#define COMJ_VSYNC_HIGH		BIT(0)
+
+/* supported resolutions */
+#define W_QCIF			(DEF_HSTOP - DEF_HSTRT)
+#define W_CIF			(W_QCIF << 1)
+#define H_QCIF			(DEF_VSTOP - DEF_VSTRT)
+#define H_CIF			(H_QCIF << 1)
+
+#define FRAME_RATE_MAX		30
+
+
+struct ov6650_reg {
+	u8	reg;
+	u8	val;
+};
+
+struct ov6650 {
+	struct v4l2_subdev	subdev;
+
+	int			gain;
+	int			blue;
+	int			red;
+	int			saturation;
+	int			hue;
+	int			brightness;
+	int			exposure;
+	int			gamma;
+	int			aec;
+	bool			vflip;
+	bool			hflip;
+	bool			awb;
+	bool			agc;
+	bool			half_scale;	/* scale down output by 2 */
+	struct v4l2_rect	rect;		/* sensor cropping window */
+	unsigned long		pclk_limit;	/* from host */
+	unsigned long		pclk_max;	/* from resolution and format */
+	struct v4l2_fract	tpf;		/* as requested with s_parm */
+	enum v4l2_mbus_pixelcode code;
+	enum v4l2_colorspace	colorspace;
+};
+
+
+static enum v4l2_mbus_pixelcode ov6650_codes[] = {
+	V4L2_MBUS_FMT_YUYV8_2X8,
+	V4L2_MBUS_FMT_UYVY8_2X8,
+	V4L2_MBUS_FMT_YVYU8_2X8,
+	V4L2_MBUS_FMT_VYUY8_2X8,
+	V4L2_MBUS_FMT_SBGGR8_1X8,
+	V4L2_MBUS_FMT_GREY8_1X8,
+};
+
+static const struct v4l2_queryctrl ov6650_controls[] = {
+	{
+		.id		= V4L2_CID_AUTOGAIN,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "AGC",
+		.minimum	= 0,
+		.maximum	= 1,
+		.step		= 1,
+		.default_value	= 1,
+	},
+	{
+		.id		= V4L2_CID_GAIN,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Gain",
+		.minimum	= 0,
+		.maximum	= 0x3f,
+		.step		= 1,
+		.default_value	= DEF_GAIN,
+	},
+	{
+		.id		= V4L2_CID_AUTO_WHITE_BALANCE,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "AWB",
+		.minimum	= 0,
+		.maximum	= 1,
+		.step		= 1,
+		.default_value	= 1,
+	},
+	{
+		.id		= V4L2_CID_BLUE_BALANCE,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Blue",
+		.minimum	= 0,
+		.maximum	= 0xff,
+		.step		= 1,
+		.default_value	= DEF_BLUE,
+	},
+	{
+		.id		= V4L2_CID_RED_BALANCE,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Red",
+		.minimum	= 0,
+		.maximum	= 0xff,
+		.step		= 1,
+		.default_value	= DEF_RED,
+	},
+	{
+		.id		= V4L2_CID_SATURATION,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Saturation",
+		.minimum	= 0,
+		.maximum	= 0xf,
+		.step		= 1,
+		.default_value	= 0x8,
+	},
+	{
+		.id		= V4L2_CID_HUE,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Hue",
+		.minimum	= 0,
+		.maximum	= HUE_MASK,
+		.step		= 1,
+		.default_value	= DEF_HUE,
+	},
+	{
+		.id		= V4L2_CID_BRIGHTNESS,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Brightness",
+		.minimum	= 0,
+		.maximum	= 0xff,
+		.step		= 1,
+		.default_value	= 0x80,
+	},
+	{
+		.id		= V4L2_CID_EXPOSURE_AUTO,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "AEC",
+		.minimum	= 0,
+		.maximum	= 3,
+		.step		= 1,
+		.default_value	= 0,
+	},
+	{
+		.id		= V4L2_CID_EXPOSURE,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Exposure",
+		.minimum	= 0,
+		.maximum	= 0xff,
+		.step		= 1,
+		.default_value	= DEF_AECH,
+	},
+	{
+		.id		= V4L2_CID_GAMMA,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Gamma",
+		.minimum	= 0,
+		.maximum	= 0xff,
+		.step		= 1,
+		.default_value	= 0x12,
+	},
+	{
+		.id		= V4L2_CID_VFLIP,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "Flip Vertically",
+		.minimum	= 0,
+		.maximum	= 1,
+		.step		= 1,
+		.default_value	= 0,
+	},
+	{
+		.id		= V4L2_CID_HFLIP,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "Flip Horizontally",
+		.minimum	= 0,
+		.maximum	= 1,
+		.step		= 1,
+		.default_value	= 0,
+	},
+};
+
+/* read a register */
+static int ov6650_reg_read(struct i2c_client *client, u8 reg, u8 *val)
+{
+	int ret;
+	u8 data = reg;
+	struct i2c_msg msg = {
+		.addr	= client->addr,
+		.flags	= 0,
+		.len	= 1,
+		.buf	= &data,
+	};
+
+	ret = i2c_transfer(client->adapter, &msg, 1);
+	if (ret < 0)
+		goto err;
+
+	msg.flags = I2C_M_RD;
+	ret = i2c_transfer(client->adapter, &msg, 1);
+	if (ret < 0)
+		goto err;
+
+	*val = data;
+	return 0;
+
+err:
+	dev_err(&client->dev, "Failed reading register 0x%02x!\n", reg);
+	return ret;
+}
+
+/* write a register */
+static int ov6650_reg_write(struct i2c_client *client, u8 reg, u8 val)
+{
+	int ret;
+	unsigned char data[2] = { reg, val };
+	struct i2c_msg msg = {
+		.addr	= client->addr,
+		.flags	= 0,
+		.len	= 2,
+		.buf	= data,
+	};
+
+	ret = i2c_transfer(client->adapter, &msg, 1);
+	usleep_range(100, 1000);
+
+	if (ret < 0) {
+		dev_err(&client->dev, "Failed writing register 0x%02x!\n", reg);
+		return ret;
+	}
+	return 0;
+}
+
+
+/* Read a register, alter its bits, write it back */
+static int ov6650_reg_rmw(struct i2c_client *client, u8 reg, u8 set, u8 mask)
+{
+	u8 val;
+	int ret;
+
+	ret = ov6650_reg_read(client, reg, &val);
+	if (ret) {
+		dev_err(&client->dev,
+			"[Read]-Modify-Write of register 0x%02x failed!\n",
+			reg);
+		return ret;
+	}
+
+	val &= ~mask;
+	val |= set;
+
+	ret = ov6650_reg_write(client, reg, val);
+	if (ret)
+		dev_err(&client->dev,
+			"Read-Modify-[Write] of register 0x%02x failed!\n",
+			reg);
+
+	return ret;
+}
+
+static struct ov6650 *to_ov6650(const struct i2c_client *client)
+{
+	return container_of(i2c_get_clientdata(client), struct ov6650, subdev);
+}
+
+/* Start/Stop streaming from the device */
+static int ov6650_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	return 0;
+}
+
+/* Alter bus settings on camera side */
+static int ov6650_set_bus_param(struct soc_camera_device *icd,
+				unsigned long flags)
+{
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
+	int ret;
+
+	flags = soc_camera_apply_sensor_flags(icl, flags);
+
+	if (flags & SOCAM_PCLK_SAMPLE_RISING)
+		ret = ov6650_reg_rmw(client, REG_COMJ, COMJ_PCLK_RISING, 0);
+	else
+		ret = ov6650_reg_rmw(client, REG_COMJ, 0, COMJ_PCLK_RISING);
+	if (ret)
+		return ret;
+
+	if (flags & SOCAM_HSYNC_ACTIVE_LOW)
+		ret = ov6650_reg_rmw(client, REG_COMF, COMF_HREF_LOW, 0);
+	else
+		ret = ov6650_reg_rmw(client, REG_COMF, 0, COMF_HREF_LOW);
+	if (ret)
+		return ret;
+
+	if (flags & SOCAM_VSYNC_ACTIVE_HIGH)
+		ret = ov6650_reg_rmw(client, REG_COMJ, COMJ_VSYNC_HIGH, 0);
+	else
+		ret = ov6650_reg_rmw(client, REG_COMJ, 0, COMJ_VSYNC_HIGH);
+
+	return ret;
+}
+
+/* Request bus settings on camera side */
+static unsigned long ov6650_query_bus_param(struct soc_camera_device *icd)
+{
+	struct soc_camera_link *icl = to_soc_camera_link(icd);
+
+	unsigned long flags = SOCAM_MASTER |
+		SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING |
+		SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_LOW |
+		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_LOW |
+		SOCAM_DATA_ACTIVE_HIGH | SOCAM_DATAWIDTH_8;
+
+	return soc_camera_apply_sensor_flags(icl, flags);
+}
+
+/* Get status of additional camera capabilities */
+static int ov6650_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+{
+	struct i2c_client *client = sd->priv;
+	struct ov6650 *priv = to_ov6650(client);
+	uint8_t reg;
+	int ret = 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUTOGAIN:
+		ctrl->value = priv->agc;
+		break;
+	case V4L2_CID_GAIN:
+		if (priv->agc) {
+			ret = ov6650_reg_read(client, REG_GAIN, &reg);
+			ctrl->value = reg;
+		} else {
+			ctrl->value = priv->gain;
+		}
+		break;
+	case V4L2_CID_AUTO_WHITE_BALANCE:
+		ctrl->value = priv->awb;
+		break;
+	case V4L2_CID_BLUE_BALANCE:
+		if (priv->awb) {
+			ret = ov6650_reg_read(client, REG_BLUE, &reg);
+			ctrl->value = reg;
+		} else {
+			ctrl->value = priv->blue;
+		}
+		break;
+	case V4L2_CID_RED_BALANCE:
+		if (priv->awb) {
+			ret = ov6650_reg_read(client, REG_RED, &reg);
+			ctrl->value = reg;
+		} else {
+			ctrl->value = priv->red;
+		}
+		break;
+	case V4L2_CID_SATURATION:
+		ctrl->value = priv->saturation;
+		break;
+	case V4L2_CID_HUE:
+		ctrl->value = priv->hue;
+		break;
+	case V4L2_CID_BRIGHTNESS:
+		ctrl->value = priv->brightness;
+		break;
+	case V4L2_CID_EXPOSURE_AUTO:
+		ctrl->value = priv->aec;
+		break;
+	case V4L2_CID_EXPOSURE:
+		if (priv->aec) {
+			ret = ov6650_reg_read(client, REG_AECH, &reg);
+			ctrl->value = reg;
+		} else {
+			ctrl->value = priv->exposure;
+		}
+		break;
+	case V4L2_CID_GAMMA:
+		ctrl->value = priv->gamma;
+		break;
+	case V4L2_CID_VFLIP:
+		ctrl->value = priv->vflip;
+		break;
+	case V4L2_CID_HFLIP:
+		ctrl->value = priv->hflip;
+		break;
+	}
+	return ret;
+}
+
+/* Set status of additional camera capabilities */
+static int ov6650_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+{
+	struct i2c_client *client = sd->priv;
+	struct ov6650 *priv = to_ov6650(client);
+	int ret = 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUTOGAIN:
+		ret = ov6650_reg_rmw(client, REG_COMB,
+				ctrl->value ? COMB_AGC : 0, COMB_AGC);
+		if (!ret)
+			priv->agc = ctrl->value;
+		break;
+	case V4L2_CID_GAIN:
+		ret = ov6650_reg_write(client, REG_GAIN, ctrl->value);
+		if (!ret)
+			priv->gain = ctrl->value;
+		break;
+	case V4L2_CID_AUTO_WHITE_BALANCE:
+		ret = ov6650_reg_rmw(client, REG_COMB,
+				ctrl->value ? COMB_AWB : 0, COMB_AWB);
+		if (!ret)
+			priv->awb = ctrl->value;
+		break;
+	case V4L2_CID_BLUE_BALANCE:
+		ret = ov6650_reg_write(client, REG_BLUE, ctrl->value);
+		if (!ret)
+			priv->blue = ctrl->value;
+		break;
+	case V4L2_CID_RED_BALANCE:
+		ret = ov6650_reg_write(client, REG_RED, ctrl->value);
+		if (!ret)
+			priv->red = ctrl->value;
+		break;
+	case V4L2_CID_SATURATION:
+		ret = ov6650_reg_rmw(client, REG_SAT, SET_SAT(ctrl->value),
+				SAT_MASK);
+		if (!ret)
+			priv->saturation = ctrl->value;
+		break;
+	case V4L2_CID_HUE:
+		ret = ov6650_reg_rmw(client, REG_HUE, SET_HUE(ctrl->value),
+				HUE_MASK);
+		if (!ret)
+			priv->hue = ctrl->value;
+		break;
+	case V4L2_CID_BRIGHTNESS:
+		ret = ov6650_reg_write(client, REG_BRT, ctrl->value);
+		if (!ret)
+			priv->brightness = ctrl->value;
+		break;
+	case V4L2_CID_EXPOSURE_AUTO:
+		switch (ctrl->value) {
+		case V4L2_EXPOSURE_AUTO:
+			ret = ov6650_reg_rmw(client, REG_COMB, COMB_AEC, 0);
+			break;
+		default:
+			ret = ov6650_reg_rmw(client, REG_COMB, 0, COMB_AEC);
+			break;
+		}
+		if (!ret)
+			priv->aec = ctrl->value;
+		break;
+	case V4L2_CID_EXPOSURE:
+		ret = ov6650_reg_write(client, REG_AECH, ctrl->value);
+		if (!ret)
+			priv->exposure = ctrl->value;
+		break;
+	case V4L2_CID_GAMMA:
+		ret = ov6650_reg_write(client, REG_GAM1, ctrl->value);
+		if (!ret)
+			priv->gamma = ctrl->value;
+		break;
+	case V4L2_CID_VFLIP:
+		ret = ov6650_reg_rmw(client, REG_COMB,
+				ctrl->value ? COMB_FLIP_V : 0, COMB_FLIP_V);
+		if (!ret)
+			priv->vflip = ctrl->value;
+		break;
+	case V4L2_CID_HFLIP:
+		ret = ov6650_reg_rmw(client, REG_COMB,
+				ctrl->value ? COMB_FLIP_H : 0, COMB_FLIP_H);
+		if (!ret)
+			priv->hflip = ctrl->value;
+		break;
+	}
+
+	return ret;
+}
+
+/* Get chip identification */
+static int ov6650_g_chip_ident(struct v4l2_subdev *sd,
+				struct v4l2_dbg_chip_ident *id)
+{
+	id->ident	= V4L2_IDENT_OV6650;
+	id->revision	= 0;
+
+	return 0;
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int ov6650_get_register(struct v4l2_subdev *sd,
+				struct v4l2_dbg_register *reg)
+{
+	struct i2c_client *client = sd->priv;
+	int ret;
+	u8 val;
+
+	if (reg->reg & ~0xff)
+		return -EINVAL;
+
+	reg->size = 1;
+
+	ret = ov6650_reg_read(client, reg->reg, &val);
+	if (!ret)
+		reg->val = (__u64)val;
+
+	return ret;
+}
+
+static int ov6650_set_register(struct v4l2_subdev *sd,
+				struct v4l2_dbg_register *reg)
+{
+	struct i2c_client *client = sd->priv;
+
+	if (reg->reg & ~0xff || reg->val & ~0xff)
+		return -EINVAL;
+
+	return ov6650_reg_write(client, reg->reg, reg->val);
+}
+#endif
+
+static int ov6650_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+{
+	struct i2c_client *client = sd->priv;
+	struct ov6650 *priv = to_ov6650(client);
+
+	a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	a->c = priv->rect;
+
+	return 0;
+}
+
+static int ov6650_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+{
+	struct i2c_client *client = sd->priv;
+	struct ov6650 *priv = to_ov6650(client);
+	struct v4l2_rect *rect = &a->c;
+	int ret;
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	rect->left   = ALIGN(rect->left,   2);
+	rect->width  = ALIGN(rect->width,  2);
+	rect->top    = ALIGN(rect->top,    2);
+	rect->height = ALIGN(rect->height, 2);
+	soc_camera_limit_side(&rect->left, &rect->width,
+			DEF_HSTRT << 1, 2, W_CIF);
+	soc_camera_limit_side(&rect->top, &rect->height,
+			DEF_VSTRT << 1, 2, H_CIF);
+
+	ret = ov6650_reg_write(client, REG_HSTRT, rect->left >> 1);
+	if (!ret) {
+		priv->rect.left = rect->left;
+		ret = ov6650_reg_write(client, REG_HSTOP,
+				(rect->left + rect->width) >> 1);
+	}
+	if (!ret) {
+		priv->rect.width = rect->width;
+		ret = ov6650_reg_write(client, REG_VSTRT, rect->top >> 1);
+	}
+	if (!ret) {
+		priv->rect.top = rect->top;
+		ret = ov6650_reg_write(client, REG_VSTOP,
+				(rect->top + rect->height) >> 1);
+	}
+	if (!ret)
+		priv->rect.height = rect->height;
+
+	return ret;
+}
+
+static int ov6650_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
+{
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	a->bounds.left			= DEF_HSTRT << 1;
+	a->bounds.top			= DEF_VSTRT << 1;
+	a->bounds.width			= W_CIF;
+	a->bounds.height		= H_CIF;
+	a->defrect			= a->bounds;
+	a->pixelaspect.numerator	= 1;
+	a->pixelaspect.denominator	= 1;
+
+	return 0;
+}
+
+static int ov6650_g_fmt(struct v4l2_subdev *sd,
+			 struct v4l2_mbus_framefmt *mf)
+{
+	struct i2c_client *client = sd->priv;
+	struct ov6650 *priv = to_ov6650(client);
+
+	mf->width	= priv->rect.width >> priv->half_scale;
+	mf->height	= priv->rect.height >> priv->half_scale;
+	mf->code	= priv->code;
+	mf->colorspace	= priv->colorspace;
+	mf->field	= V4L2_FIELD_NONE;
+
+	return 0;
+}
+
+static bool is_unscaled_ok(int width, int height, struct v4l2_rect *rect)
+{
+	return (width > rect->width >> 1 || height > rect->height >> 1);
+}
+
+static u8 to_clkrc(struct v4l2_fract *timeperframe,
+		unsigned long pclk_limit, unsigned long pclk_max)
+{
+	unsigned long pclk;
+
+	if (timeperframe->numerator && timeperframe->denominator)
+		pclk = pclk_max * timeperframe->denominator /
+				(FRAME_RATE_MAX * timeperframe->numerator);
+	else
+		pclk = pclk_max;
+
+	if (pclk_limit && pclk_limit < pclk)
+		pclk = pclk_limit;
+
+	return (pclk_max - 1) / pclk;
+}
+
+/* set the format we will capture in */
+static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
+{
+	struct i2c_client *client = sd->priv;
+	struct soc_camera_device *icd = client->dev.platform_data;
+	struct soc_camera_sense *sense = icd->sense;
+	struct ov6650 *priv = to_ov6650(client);
+	bool half_scale = !is_unscaled_ok(mf->width, mf->height, &priv->rect);
+	struct v4l2_crop a = {
+		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
+		.c = {
+			.left	= priv->rect.left + (priv->rect.width >> 1) -
+					(mf->width >> (1 - half_scale)),
+			.top	= priv->rect.top + (priv->rect.height >> 1) -
+					(mf->height >> (1 - half_scale)),
+			.width	= mf->width << half_scale,
+			.height	= mf->height << half_scale,
+		},
+	};
+	enum v4l2_mbus_pixelcode code = mf->code;
+	unsigned long mclk, pclk;
+	u8 coma_set = 0, coma_mask = 0, coml_set, coml_mask, clkrc;
+	int ret;
+
+	/* select color matrix configuration for given color encoding */
+	switch (code) {
+	case V4L2_MBUS_FMT_GREY8_1X8:
+		dev_dbg(&client->dev, "pixel format GREY8_1X8\n");
+		coma_mask |= COMA_RGB | COMA_WORD_SWAP | COMA_BYTE_SWAP;
+		coma_set |= COMA_BW;
+		break;
+	case V4L2_MBUS_FMT_YUYV8_2X8:
+		dev_dbg(&client->dev, "pixel format YUYV8_2X8_LE\n");
+		coma_mask |= COMA_RGB | COMA_BW | COMA_BYTE_SWAP;
+		coma_set |= COMA_WORD_SWAP;
+		break;
+	case V4L2_MBUS_FMT_YVYU8_2X8:
+		dev_dbg(&client->dev, "pixel format YVYU8_2X8_LE (untested)\n");
+		coma_mask |= COMA_RGB | COMA_BW | COMA_WORD_SWAP |
+				COMA_BYTE_SWAP;
+		break;
+	case V4L2_MBUS_FMT_UYVY8_2X8:
+		dev_dbg(&client->dev, "pixel format YUYV8_2X8_BE\n");
+		if (half_scale) {
+			coma_mask |= COMA_RGB | COMA_BW | COMA_WORD_SWAP;
+			coma_set |= COMA_BYTE_SWAP;
+		} else {
+			coma_mask |= COMA_RGB | COMA_BW;
+			coma_set |= COMA_BYTE_SWAP | COMA_WORD_SWAP;
+		}
+		break;
+	case V4L2_MBUS_FMT_VYUY8_2X8:
+		dev_dbg(&client->dev, "pixel format YVYU8_2X8_BE (untested)\n");
+		if (half_scale) {
+			coma_mask |= COMA_RGB | COMA_BW;
+			coma_set |= COMA_BYTE_SWAP | COMA_WORD_SWAP;
+		} else {
+			coma_mask |= COMA_RGB | COMA_BW | COMA_WORD_SWAP;
+			coma_set |= COMA_BYTE_SWAP;
+		}
+		break;
+	case V4L2_MBUS_FMT_SBGGR8_1X8:
+		dev_dbg(&client->dev, "pixel format SBGGR8_1X8 (untested)\n");
+		coma_mask |= COMA_BW | COMA_BYTE_SWAP | COMA_WORD_SWAP;
+		coma_set |= COMA_RAW_RGB | COMA_RGB;
+		break;
+	case 0:
+		break;
+	default:
+		dev_err(&client->dev, "Pixel format not handled: 0x%x\n", code);
+		return -EINVAL;
+	}
+	priv->code = code;
+
+	if (code == V4L2_MBUS_FMT_GREY8_1X8 ||
+			code == V4L2_MBUS_FMT_SBGGR8_1X8) {
+		coml_mask = COML_ONE_CHANNEL;
+		coml_set = 0;
+		priv->pclk_max = 4000000;
+	} else {
+		coml_mask = 0;
+		coml_set = COML_ONE_CHANNEL;
+		priv->pclk_max = 8000000;
+	}
+
+	if (code == V4L2_MBUS_FMT_SBGGR8_1X8)
+		priv->colorspace = V4L2_COLORSPACE_SRGB;
+	else if (code != 0)
+		priv->colorspace = V4L2_COLORSPACE_JPEG;
+
+	if (half_scale) {
+		dev_dbg(&client->dev, "max resolution: QCIF\n");
+		coma_set |= COMA_QCIF;
+		priv->pclk_max /= 2;
+	} else {
+		dev_dbg(&client->dev, "max resolution: CIF\n");
+		coma_mask |= COMA_QCIF;
+	}
+	priv->half_scale = half_scale;
+
+	if (sense) {
+		if (sense->master_clock == 8000000) {
+			dev_dbg(&client->dev, "8MHz input clock\n");
+			clkrc = CLKRC_6MHz;
+		} else if (sense->master_clock == 12000000) {
+			dev_dbg(&client->dev, "12MHz input clock\n");
+			clkrc = CLKRC_12MHz;
+		} else if (sense->master_clock == 16000000) {
+			dev_dbg(&client->dev, "16MHz input clock\n");
+			clkrc = CLKRC_16MHz;
+		} else if (sense->master_clock == 24000000) {
+			dev_dbg(&client->dev, "24MHz input clock\n");
+			clkrc = CLKRC_24MHz;
+		} else {
+			dev_err(&client->dev,
+				"unspported input clock, check platform data\n");
+			return -EINVAL;
+		}
+		mclk = sense->master_clock;
+		priv->pclk_limit = sense->pixel_clock_max;
+	} else {
+		clkrc = CLKRC_24MHz;
+		mclk = 24000000;
+		priv->pclk_limit = 0;
+		dev_dbg(&client->dev, "using default 24MHz input clock\n");
+	}
+
+	clkrc |= to_clkrc(&priv->tpf, priv->pclk_limit, priv->pclk_max);
+
+	pclk = priv->pclk_max / GET_CLKRC_DIV(clkrc);
+	dev_dbg(&client->dev, "pixel clock divider: %ld.%ld\n",
+			mclk / pclk, 10 * mclk % pclk / pclk);
+
+	ret = ov6650_s_crop(sd, &a);
+	if (!ret)
+		ret = ov6650_reg_rmw(client, REG_COMA, coma_set, coma_mask);
+	if (!ret)
+		ret = ov6650_reg_write(client, REG_CLKRC, clkrc);
+	if (!ret)
+		ret = ov6650_reg_rmw(client, REG_COML, coml_set, coml_mask);
+
+	if (!ret) {
+		mf->colorspace	= priv->colorspace;
+		mf->width = priv->rect.width >> half_scale;
+		mf->height = priv->rect.height >> half_scale;
+	}
+
+	return ret;
+}
+
+static int ov6650_try_fmt(struct v4l2_subdev *sd,
+			  struct v4l2_mbus_framefmt *mf)
+{
+	struct i2c_client *client = sd->priv;
+	struct ov6650 *priv = to_ov6650(client);
+
+	if (is_unscaled_ok(mf->width, mf->height, &priv->rect))
+		v4l_bound_align_image(&mf->width, 2, W_CIF, 1,
+				&mf->height, 2, H_CIF, 1, 0);
+
+	mf->field = V4L2_FIELD_NONE;
+
+	switch (mf->code) {
+	case V4L2_MBUS_FMT_Y10_1X10:
+		mf->code = V4L2_MBUS_FMT_GREY8_1X8;
+	case V4L2_MBUS_FMT_GREY8_1X8:
+	case V4L2_MBUS_FMT_YVYU8_2X8:
+	case V4L2_MBUS_FMT_YUYV8_2X8:
+	case V4L2_MBUS_FMT_VYUY8_2X8:
+	case V4L2_MBUS_FMT_UYVY8_2X8:
+		mf->colorspace = V4L2_COLORSPACE_JPEG;
+		break;
+	default:
+		mf->code = V4L2_MBUS_FMT_SBGGR8_1X8;
+	case V4L2_MBUS_FMT_SBGGR8_1X8:
+		mf->colorspace = V4L2_COLORSPACE_SRGB;
+		break;
+	}
+
+	return 0;
+}
+
+static int ov6650_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
+			   enum v4l2_mbus_pixelcode *code)
+{
+	if (index >= ARRAY_SIZE(ov6650_codes))
+		return -EINVAL;
+
+	*code = ov6650_codes[index];
+	return 0;
+}
+
+static int ov6650_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
+{
+	struct i2c_client *client = sd->priv;
+	struct ov6650 *priv = to_ov6650(client);
+	struct v4l2_captureparm *cp = &parms->parm.capture;
+
+	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	memset(cp, 0, sizeof(*cp));
+	cp->capability = V4L2_CAP_TIMEPERFRAME;
+	cp->timeperframe.numerator = GET_CLKRC_DIV(to_clkrc(&priv->tpf,
+			priv->pclk_limit, priv->pclk_max));
+	cp->timeperframe.denominator = FRAME_RATE_MAX;
+
+	dev_dbg(&client->dev, "Frame interval: %u/%u s\n",
+		cp->timeperframe.numerator, cp->timeperframe.denominator);
+
+	return 0;
+}
+
+static int ov6650_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
+{
+	struct i2c_client *client = sd->priv;
+	struct ov6650 *priv = to_ov6650(client);
+	struct v4l2_captureparm *cp = &parms->parm.capture;
+	struct v4l2_fract *tpf = &cp->timeperframe;
+	int div, ret;
+	u8 clkrc;
+
+	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	if (cp->extendedmode != 0)
+		return -EINVAL;
+
+	if (tpf->numerator == 0 || tpf->denominator == 0)
+		div = 1;  /* Reset to full rate */
+	else
+		div = (tpf->numerator * FRAME_RATE_MAX) / tpf->denominator;
+
+	if (div == 0)
+		div = 1;
+	else if (div > GET_CLKRC_DIV(CLKRC_DIV_MASK))
+		div = GET_CLKRC_DIV(CLKRC_DIV_MASK);
+
+	/*
+	 * Keep result to be used as tpf limit
+	 * for subseqent clock divider calculations
+	 */
+	priv->tpf.numerator = div;
+	priv->tpf.denominator = FRAME_RATE_MAX;
+
+	clkrc = to_clkrc(&priv->tpf, priv->pclk_limit, priv->pclk_max);
+
+	ret = ov6650_reg_rmw(client, REG_CLKRC, clkrc, CLKRC_DIV_MASK);
+	if (!ret) {
+		tpf->numerator = GET_CLKRC_DIV(clkrc);
+		tpf->denominator = FRAME_RATE_MAX;
+	}
+
+	return ret;
+}
+
+/* Soft reset the camera. This has nothing to do with the RESET pin! */
+static int ov6650_reset(struct i2c_client *client)
+{
+	int ret;
+
+	dev_dbg(&client->dev, "reset\n");
+
+	ret = ov6650_reg_rmw(client, REG_COMA, COMA_RESET, 0);
+	if (ret)
+		dev_err(&client->dev,
+			"An error occured while entering soft reset!\n");
+
+	return ret;
+}
+
+/* program default register values */
+static int ov6650_prog_dflt(struct i2c_client *client)
+{
+	int ret;
+
+	dev_dbg(&client->dev, "initializing\n");
+
+	ret = ov6650_reg_write(client, REG_COMA, 0);	/* ~COMA_RESET */
+	if (!ret)
+		ret = ov6650_reg_rmw(client, REG_COMB, 0, COMB_BAND_FILTER);
+
+	return ret;
+}
+
+static int ov6650_video_probe(struct soc_camera_device *icd,
+				struct i2c_client *client)
+{
+	u8		pidh, pidl, midh, midl;
+	int		ret = 0;
+
+	/*
+	 * check and show product ID and manufacturer ID
+	 */
+	ret = ov6650_reg_read(client, REG_PIDH, &pidh);
+	if (!ret)
+		ret = ov6650_reg_read(client, REG_PIDL, &pidl);
+	if (!ret)
+		ret = ov6650_reg_read(client, REG_MIDH, &midh);
+	if (!ret)
+		ret = ov6650_reg_read(client, REG_MIDL, &midl);
+
+	if (ret)
+		return ret;
+
+	if ((pidh != OV6650_PIDH) || (pidl != OV6650_PIDL)) {
+		dev_err(&client->dev, "Product ID error 0x%02x:0x%02x\n",
+				pidh, pidl);
+		return -ENODEV;
+	}
+
+	dev_info(&client->dev,
+		"ov6650 Product ID 0x%02x:0x%02x Manufacturer ID 0x%02x:0x%02x\n",
+		pidh, pidl, midh, midl);
+
+	ret = ov6650_reset(client);
+	if (!ret)
+		ret = ov6650_prog_dflt(client);
+
+	return ret;
+}
+
+static struct soc_camera_ops ov6650_ops = {
+	.set_bus_param		= ov6650_set_bus_param,
+	.query_bus_param	= ov6650_query_bus_param,
+	.controls		= ov6650_controls,
+	.num_controls		= ARRAY_SIZE(ov6650_controls),
+};
+
+static struct v4l2_subdev_core_ops ov6650_core_ops = {
+	.g_ctrl			= ov6650_g_ctrl,
+	.s_ctrl			= ov6650_s_ctrl,
+	.g_chip_ident		= ov6650_g_chip_ident,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.g_register		= ov6650_get_register,
+	.s_register		= ov6650_set_register,
+#endif
+};
+
+static struct v4l2_subdev_video_ops ov6650_video_ops = {
+	.s_stream	= ov6650_s_stream,
+	.g_mbus_fmt	= ov6650_g_fmt,
+	.s_mbus_fmt	= ov6650_s_fmt,
+	.try_mbus_fmt	= ov6650_try_fmt,
+	.enum_mbus_fmt	= ov6650_enum_fmt,
+	.cropcap	= ov6650_cropcap,
+	.g_crop		= ov6650_g_crop,
+	.s_crop		= ov6650_s_crop,
+	.g_parm		= ov6650_g_parm,
+	.s_parm		= ov6650_s_parm,
+};
+
+static struct v4l2_subdev_ops ov6650_subdev_ops = {
+	.core	= &ov6650_core_ops,
+	.video	= &ov6650_video_ops,
+};
+
+/*
+ * i2c_driver function
+ */
+static int ov6650_probe(struct i2c_client *client,
+			const struct i2c_device_id *did)
+{
+	struct ov6650 *priv;
+	struct soc_camera_device *icd = client->dev.platform_data;
+	struct soc_camera_link *icl;
+	int ret;
+
+	if (!icd) {
+		dev_err(&client->dev, "Missing soc-camera data!\n");
+		return -EINVAL;
+	}
+
+	icl = to_soc_camera_link(icd);
+	if (!icl) {
+		dev_err(&client->dev, "Missing platform_data for driver\n");
+		return -EINVAL;
+	}
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		dev_err(&client->dev,
+			"Failed to allocate memory for private data!\n");
+		return -ENOMEM;
+	}
+
+	v4l2_i2c_subdev_init(&priv->subdev, client, &ov6650_subdev_ops);
+
+	icd->ops = &ov6650_ops;
+
+	priv->rect.left	  = DEF_HSTRT << 1;
+	priv->rect.top	  = DEF_VSTRT << 1;
+	priv->rect.width  = W_CIF;
+	priv->rect.height = H_CIF;
+	priv->half_scale  = false;
+	priv->code	  = V4L2_MBUS_FMT_YUYV8_2X8;
+	priv->colorspace  = V4L2_COLORSPACE_JPEG;
+
+	ret = ov6650_video_probe(icd, client);
+
+	if (ret) {
+		icd->ops = NULL;
+		i2c_set_clientdata(client, NULL);
+		kfree(priv);
+	}
+
+	return ret;
+}
+
+static int ov6650_remove(struct i2c_client *client)
+{
+	struct ov6650 *priv = to_ov6650(client);
+
+	i2c_set_clientdata(client, NULL);
+	kfree(priv);
+	return 0;
+}
+
+static const struct i2c_device_id ov6650_id[] = {
+	{ "ov6650", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, ov6650_id);
+
+static struct i2c_driver ov6650_i2c_driver = {
+	.driver = {
+		.name = "ov6650",
+	},
+	.probe    = ov6650_probe,
+	.remove   = ov6650_remove,
+	.id_table = ov6650_id,
+};
+
+static int __init ov6650_module_init(void)
+{
+	return i2c_add_driver(&ov6650_i2c_driver);
+}
+
+static void __exit ov6650_module_exit(void)
+{
+	i2c_del_driver(&ov6650_i2c_driver);
+}
+
+module_init(ov6650_module_init);
+module_exit(ov6650_module_exit);
+
+MODULE_DESCRIPTION("SoC Camera driver for OmniVision OV6650");
+MODULE_AUTHOR("Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>");
+MODULE_LICENSE("GPL v2");
diff -upr linux-2.6.36-rc5.orig/include/media/v4l2-chip-ident.h linux-2.6.36-rc5/include/media/v4l2-chip-ident.h
--- linux-2.6.36-rc5.orig/include/media/v4l2-chip-ident.h	2010-09-24 15:35:58.000000000 +0200
+++ linux-2.6.36-rc5/include/media/v4l2-chip-ident.h	2010-09-24 21:18:29.000000000 +0200
@@ -70,6 +70,7 @@ enum {
 	V4L2_IDENT_OV9655 = 255,
 	V4L2_IDENT_SOI968 = 256,
 	V4L2_IDENT_OV9640 = 257,
+	V4L2_IDENT_OV6650 = 258,
 
 	/* module saa7146: reserved range 300-309 */
 	V4L2_IDENT_SAA7146 = 300,
