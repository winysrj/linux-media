Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53158 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751623AbdBUMJu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 07:09:50 -0500
Date: Tue, 21 Feb 2017 14:09:14 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, vladimir_zapolskiy@mentor.com,
        CARLOS.PALMINHA@synopsys.com,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Rob Herring <robh+dt@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH v9 2/2] Add support for OV5647 sensor.
Message-ID: <20170221120914.GG16975@valkosipuli.retiisi.org.uk>
References: <cover.1487334912.git.roliveir@synopsys.com>
 <412e51e695630281d2084a77c0329fd273ea00d7.1487334912.git.roliveir@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <412e51e695630281d2084a77c0329fd273ea00d7.1487334912.git.roliveir@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramiro,

A few minor comments below.

On Fri, Feb 17, 2017 at 01:14:16PM +0000, Ramiro Oliveira wrote:
> The OV5647 sensor from Omnivision supports up to 2592x1944 @ 15 fps, RAW 8
> and RAW 10 output formats, and MIPI CSI-2 interface.
> 
> The driver adds support for 640x480 RAW 8.
> 
> Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>
> ---
>  MAINTAINERS                |   7 +
>  drivers/media/i2c/Kconfig  |  11 +
>  drivers/media/i2c/Makefile |   1 +
>  drivers/media/i2c/ov5647.c | 638 +++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 657 insertions(+)
>  create mode 100644 drivers/media/i2c/ov5647.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8e7e8d7855ee..7bbca271acc8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9109,6 +9109,13 @@ M:	Harald Welte <laforge@gnumonks.org>
>  S:	Maintained
>  F:	drivers/char/pcmcia/cm4040_cs.*
>  
> +OMNIVISION OV5647 SENSOR DRIVER
> +M:	Ramiro Oliveira <roliveir@synopsys.com>
> +L:	linux-media@vger.kernel.org
> +T:	git git://linuxtv.org/media_tree.git
> +S:	Maintained
> +F:	drivers/media/i2c/ov5647.c
> +
>  OMNIVISION OV7670 SENSOR DRIVER
>  M:	Jonathan Corbet <corbet@lwn.net>
>  L:	linux-media@vger.kernel.org
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index cee1dae6e014..8435b99f38bc 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -531,6 +531,17 @@ config VIDEO_OV2659
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called ov2659.
>  
> +config VIDEO_OV5647
> +	tristate "OmniVision OV5647 sensor support"
> +	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> +	depends on MEDIA_CAMERA_SUPPORT
> +	---help---
> +	  This is a Video4Linux2 sensor-level driver for the OmniVision
> +	  OV5647 camera.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called ov5647.
> +
>  config VIDEO_OV7640
>  	tristate "OmniVision OV7640 sensor support"
>  	depends on I2C && VIDEO_V4L2
> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> index 5bc7bbeb5499..ef2ccf65f94c 100644
> --- a/drivers/media/i2c/Makefile
> +++ b/drivers/media/i2c/Makefile
> @@ -83,3 +83,4 @@ obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
>  obj-$(CONFIG_VIDEO_ML86V7667)	+= ml86v7667.o
>  obj-$(CONFIG_VIDEO_OV2659)	+= ov2659.o
>  obj-$(CONFIG_VIDEO_TC358743)	+= tc358743.o
> +obj-$(CONFIG_VIDEO_OV5647)	+= ov5647.o
> diff --git a/drivers/media/i2c/ov5647.c b/drivers/media/i2c/ov5647.c
> new file mode 100644
> index 000000000000..34e620fabbaf
> --- /dev/null
> +++ b/drivers/media/i2c/ov5647.c
> @@ -0,0 +1,638 @@
> +/*
> + * A V4L2 driver for OmniVision OV5647 cameras.
> + *
> + * Based on Samsung S5K6AAFX SXGA 1/6" 1.3M CMOS Image Sensor driver
> + * Copyright (C) 2011 Sylwester Nawrocki <s.nawrocki@samsung.com>
> + *
> + * Based on Omnivision OV7670 Camera Driver
> + * Copyright (C) 2006-7 Jonathan Corbet <corbet@lwn.net>
> + *
> + * Copyright (C) 2016, Synopsys, Inc.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed .as is. WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/i2c.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/videodev2.h>
> +#include <media/v4l2-ctrls.h>

You don't seem to implement any controls.

The sensor likely supports exposure time (and maybe also gain) the user
might want to control. Is there an intent to add that? Otherwise the header
should be removed.

> +#include <media/v4l2-device.h>
> +#include <media/v4l2-image-sizes.h>
> +#include <media/v4l2-mediabus.h>
> +#include <media/v4l2-of.h>
> +
> +#define SENSOR_NAME "ov5647"
> +
> +#define OV5647_SW_RESET		0x1003
> +#define OV5647_REG_CHIPID_H	0x300A
> +#define OV5647_REG_CHIPID_L	0x300B
> +
> +#define REG_TERM 0xfffe
> +#define VAL_TERM 0xfe
> +#define REG_DLY  0xffff
> +
> +#define OV5647_ROW_START		0x01
> +#define OV5647_ROW_START_MIN		0
> +#define OV5647_ROW_START_MAX		2004
> +#define OV5647_ROW_START_DEF		54
> +
> +#define OV5647_COLUMN_START		0x02
> +#define OV5647_COLUMN_START_MIN		0
> +#define OV5647_COLUMN_START_MAX		2750
> +#define OV5647_COLUMN_START_DEF		16
> +
> +#define OV5647_WINDOW_HEIGHT		0x03
> +#define OV5647_WINDOW_HEIGHT_MIN	2
> +#define OV5647_WINDOW_HEIGHT_MAX	2006
> +#define OV5647_WINDOW_HEIGHT_DEF	1944
> +
> +#define OV5647_WINDOW_WIDTH		0x04
> +#define OV5647_WINDOW_WIDTH_MIN		2
> +#define OV5647_WINDOW_WIDTH_MAX		2752
> +#define OV5647_WINDOW_WIDTH_DEF		2592
> +
> +struct regval_list {
> +	u16 addr;
> +	u8 data;
> +};
> +
> +struct ov5647 {
> +	struct v4l2_subdev		sd;
> +	struct media_pad		pad;
> +	struct mutex			lock;
> +	struct v4l2_mbus_framefmt	format;
> +	unsigned int			width;
> +	unsigned int			height;
> +	int				power_count;
> +	struct clk			*xclk;
> +	/* External clock frequency currently supported is 30MHz */
> +	u32				xclk_freq;
> +};
> +
> +static inline struct ov5647 *to_state(struct v4l2_subdev *sd)
> +{
> +	return container_of(sd, struct ov5647, sd);
> +}
> +
> +static struct regval_list sensor_oe_disable_regs[] = {
> +	{0x3000, 0x00},
> +	{0x3001, 0x00},
> +	{0x3002, 0x00},
> +};
> +
> +static struct regval_list sensor_oe_enable_regs[] = {
> +	{0x3000, 0x0f},
> +	{0x3001, 0xff},
> +	{0x3002, 0xe4},
> +};
> +
> +static struct regval_list ov5647_640x480[] = {
> +	{0x0100, 0x00},
> +	{0x0103, 0x01},
> +	{0x3034, 0x08},
> +	{0x3035, 0x21},
> +	{0x3036, 0x46},
> +	{0x303c, 0x11},
> +	{0x3106, 0xf5},
> +	{0x3821, 0x07},
> +	{0x3820, 0x41},
> +	{0x3827, 0xec},
> +	{0x370c, 0x0f},
> +	{0x3612, 0x59},
> +	{0x3618, 0x00},
> +	{0x5000, 0x06},
> +	{0x5001, 0x01},
> +	{0x5002, 0x41},
> +	{0x5003, 0x08},
> +	{0x5a00, 0x08},
> +	{0x3000, 0x00},
> +	{0x3001, 0x00},
> +	{0x3002, 0x00},
> +	{0x3016, 0x08},
> +	{0x3017, 0xe0},
> +	{0x3018, 0x44},
> +	{0x301c, 0xf8},
> +	{0x301d, 0xf0},
> +	{0x3a18, 0x00},
> +	{0x3a19, 0xf8},
> +	{0x3c01, 0x80},
> +	{0x3b07, 0x0c},
> +	{0x380c, 0x07},
> +	{0x380d, 0x68},
> +	{0x380e, 0x03},
> +	{0x380f, 0xd8},
> +	{0x3814, 0x31},
> +	{0x3815, 0x31},
> +	{0x3708, 0x64},
> +	{0x3709, 0x52},
> +	{0x3808, 0x02},
> +	{0x3809, 0x80},
> +	{0x380a, 0x01},
> +	{0x380b, 0xE0},
> +	{0x3801, 0x00},
> +	{0x3802, 0x00},
> +	{0x3803, 0x00},
> +	{0x3804, 0x0a},
> +	{0x3805, 0x3f},
> +	{0x3806, 0x07},
> +	{0x3807, 0xa1},
> +	{0x3811, 0x08},
> +	{0x3813, 0x02},
> +	{0x3630, 0x2e},
> +	{0x3632, 0xe2},
> +	{0x3633, 0x23},
> +	{0x3634, 0x44},
> +	{0x3636, 0x06},
> +	{0x3620, 0x64},
> +	{0x3621, 0xe0},
> +	{0x3600, 0x37},
> +	{0x3704, 0xa0},
> +	{0x3703, 0x5a},
> +	{0x3715, 0x78},
> +	{0x3717, 0x01},
> +	{0x3731, 0x02},
> +	{0x370b, 0x60},
> +	{0x3705, 0x1a},
> +	{0x3f05, 0x02},
> +	{0x3f06, 0x10},
> +	{0x3f01, 0x0a},
> +	{0x3a08, 0x01},
> +	{0x3a09, 0x27},
> +	{0x3a0a, 0x00},
> +	{0x3a0b, 0xf6},
> +	{0x3a0d, 0x04},
> +	{0x3a0e, 0x03},
> +	{0x3a0f, 0x58},
> +	{0x3a10, 0x50},
> +	{0x3a1b, 0x58},
> +	{0x3a1e, 0x50},
> +	{0x3a11, 0x60},
> +	{0x3a1f, 0x28},
> +	{0x4001, 0x02},
> +	{0x4004, 0x02},
> +	{0x4000, 0x09},
> +	{0x4837, 0x24},
> +	{0x4050, 0x6e},
> +	{0x4051, 0x8f},
> +	{0x0100, 0x01},
> +};
> +
> +static int ov5647_write(struct v4l2_subdev *sd, u16 reg, u8 val)
> +{
> +	int ret;
> +	unsigned char data[3] = { reg >> 8, reg & 0xff, val};
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +	ret = i2c_master_send(client, data, 3);
> +	if (ret < 0)
> +		dev_dbg(&client->dev, "%s: i2c write error, reg: %x\n",
> +				__func__, reg);
> +
> +	return ret;
> +}
> +
> +static int ov5647_read(struct v4l2_subdev *sd, u16 reg, u8 *val)
> +{
> +	int ret;
> +	unsigned char data_w[2] = { reg >> 8, reg & 0xff };
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +	ret = i2c_master_send(client, data_w, 2);
> +	if (ret < 0) {
> +		dev_dbg(&client->dev, "%s: i2c read error, reg: %x\n",
> +			__func__, reg);
> +		return ret;
> +	}
> +
> +	ret = i2c_master_recv(client, val, 1);
> +	if (ret < 0)
> +		dev_dbg(&client->dev, "%s: i2c read error, reg: %x\n",
> +				__func__, reg);
> +
> +	return ret;
> +
> +}
> +
> +static int ov5647_write_array(struct v4l2_subdev *sd,
> +				struct regval_list *regs, int array_size)
> +{
> +	int i = 0, ret;
> +
> +	for (i = 0; i < array_size; i++) {
> +		ret = ov5647_write(sd, regs[i].addr, regs[i].data);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int ov5647_set_virtual_channel(struct v4l2_subdev *sd, int channel)
> +{
> +	u8 channel_id;
> +	int ret;
> +
> +	ret = ov5647_read(sd, 0x4814, &channel_id);
> +	if (ret < 0)
> +		return ret;
> +
> +	channel_id &= ~(3 << 6);
> +	return ov5647_write(sd, 0x4814, channel_id | (channel << 6));
> +}
> +
> +static int ov5647_stream_on(struct v4l2_subdev *sd)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +	ov5647_write(sd, 0x4202, 0x00);
> +
> +	dev_dbg(&client->dev, "Stream on");
> +
> +	return ov5647_write(sd, 0x300D, 0x00);
> +}
> +
> +static int ov5647_stream_off(struct v4l2_subdev *sd)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +	ov5647_write(sd, 0x4202, 0x0f);
> +
> +	dev_dbg(&client->dev, "Stream off");
> +
> +	return ov5647_write(sd, 0x300D, 0x01);
> +}
> +
> +static int set_sw_standby(struct v4l2_subdev *sd, bool standby)
> +{
> +	int ret;
> +	u8 rdval;
> +
> +	ret = ov5647_read(sd, 0x0100, &rdval);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (standby)
> +		rdval &= ~0x01;
> +	else
> +		rdval |= 0x01;
> +
> +	return ov5647_write(sd, 0x0100, rdval);
> +}
> +
> +static int __sensor_init(struct v4l2_subdev *sd)
> +{
> +	int ret;
> +	u8 resetval;
> +	u8 rdval;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +	dev_dbg(&client->dev, "sensor init\n");
> +
> +	ret = ov5647_read(sd, 0x0100, &rdval);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = ov5647_write_array(sd, ov5647_640x480,
> +					ARRAY_SIZE(ov5647_640x480));
> +	if (ret < 0) {
> +		dev_err(&client->dev, "write sensor default regs error\n");
> +		return ret;
> +	}
> +
> +	ret = ov5647_set_virtual_channel(sd, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = ov5647_read(sd, 0x0100, &resetval);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (!(resetval & 0x01)) {
> +		dev_err(&client->dev, "Device was in SW standby");
> +		ret = ov5647_write(sd, 0x0100, 0x01);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return ov5647_write(sd, 0x4800, 0x04);
> +}
> +
> +static int sensor_power(struct v4l2_subdev *sd, int on)
> +{
> +	int ret;
> +	struct ov5647 *ov5647 = to_state(sd);
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +	ret = 0;

You can assign in variable declaration.

> +	mutex_lock(&ov5647->lock);
> +
> +	if (on && !ov5647->power_count)	{
> +		dev_dbg(&client->dev, "OV5647 power on\n");
> +
> +		clk_set_rate(ov5647->xclk, ov5647->xclk_freq);
> +
> +		ret = clk_prepare_enable(ov5647->xclk);
> +		if (ret < 0) {
> +			dev_err(&client->dev, "clk prepare enable failed\n");
> +			goto out;
> +		}
> +
> +		ret = ov5647_write_array(sd, sensor_oe_enable_regs,
> +				ARRAY_SIZE(sensor_oe_enable_regs));
> +		if (ret < 0) {
> +			clk_disable_unprepare(ov5647->xclk);
> +			dev_err(&client->dev,
> +				"write sensor_oe_enable_regs error\n");
> +			goto out;
> +		}
> +
> +		ret = __sensor_init(sd);
> +		if (ret < 0) {
> +			clk_disable_unprepare(ov5647->xclk);
> +			dev_err(&client->dev,
> +				"Camera not available, check Power\n");
> +			goto out;
> +		}
> +	} else if (!on && ov5647->power_count == 1) {
> +		dev_dbg(&client->dev, "OV5647 power off\n");
> +
> +		dev_dbg(&client->dev, "disable oe\n");
> +		ret = ov5647_write_array(sd, sensor_oe_disable_regs,
> +				ARRAY_SIZE(sensor_oe_disable_regs));
> +
> +		if (ret < 0)
> +			dev_dbg(&client->dev, "disable oe failed\n");
> +
> +		ret = set_sw_standby(sd, true);
> +
> +		if (ret < 0)
> +			dev_dbg(&client->dev, "soft stby failed\n");
> +
> +		clk_disable_unprepare(ov5647->xclk);
> +	}
> +
> +	/* Update the power count. */
> +	ov5647->power_count += on ? 1 : -1;
> +	WARN_ON(ov5647->power_count < 0);
> +
> +out:
> +	mutex_unlock(&ov5647->lock);
> +
> +	return ret;
> +}
> +
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +static int sensor_get_register(struct v4l2_subdev *sd,
> +				struct v4l2_dbg_register *reg)
> +{
> +	u8 val;
> +	int ret;
> +
> +	ret = ov5647_read(sd, reg->reg & 0xff, &val);
> +	if (ret < 0)
> +		return ret;
> +
> +	reg->val = val;
> +	reg->size = 1;
> +
> +	return 0;
> +}
> +
> +static int sensor_set_register(struct v4l2_subdev *sd,
> +				const struct v4l2_dbg_register *reg)
> +{
> +	return ov5647_write(sd, reg->reg & 0xff, reg->val & 0xff);
> +}
> +#endif
> +
> +/**
> + * @short Subdev core operations registration
> + */
> +static const struct v4l2_subdev_core_ops subdev_core_ops = {
> +	.s_power		= sensor_power,
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +	.g_register		= sensor_get_register,
> +	.s_register		= sensor_set_register,
> +#endif
> +};
> +
> +static int s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	if (enable)
> +		return ov5647_stream_on(sd);
> +	else
> +		return ov5647_stream_off(sd);
> +}
> +
> +static const struct v4l2_subdev_video_ops subdev_video_ops = {
> +	.s_stream =		s_stream,
> +};
> +
> +static int enum_mbus_code(struct v4l2_subdev *sd,
> +				struct v4l2_subdev_pad_config *cfg,
> +				struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	if (code->index > 0)
> +		return -EINVAL;
> +
> +	code->code = MEDIA_BUS_FMT_SBGGR8_1X8;
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_pad_ops subdev_pad_ops = {
> +	.enum_mbus_code =	enum_mbus_code,
> +};
> +
> +/**
> + * @short Subdev operations registration
> + *
> + */
> +static const struct v4l2_subdev_ops subdev_ops = {
> +	.core		= &subdev_core_ops,
> +	.video		= &subdev_video_ops,
> +	.pad		= &subdev_pad_ops,
> +};
> +
> +static int ov5647_detect(struct v4l2_subdev *sd)
> +{
> +	u8 read;
> +	int ret;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +	ret = ov5647_write(sd, OV5647_SW_RESET, 0x01);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = ov5647_read(sd, OV5647_REG_CHIPID_H, &read);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (read != 0x56) {
> +		dev_err(&client->dev, "Wrong model version detected");

You might want to tell whether it's high or low ID register that fails the
check. And possibly the bad value. Up to you.

> +		return -ENODEV;
> +	}
> +
> +	ret = ov5647_read(sd, OV5647_REG_CHIPID_L, &read);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (read != 0x47) {
> +		dev_err(&client->dev, "Wrong model version detected");
> +		return -ENODEV;
> +	}
> +
> +	return ov5647_write(sd, OV5647_SW_RESET, 0x00);
> +}
> +
> +static int ov5647_registered(struct v4l2_subdev *sd)
> +{
> +	return 0;
> +}

The registered() callback is optional, i.e. you can drop an empty callback.

> +
> +static int ov5647_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +	struct v4l2_mbus_framefmt *format =
> +				v4l2_subdev_get_try_format(sd, fh->pad, 0);
> +	struct v4l2_rect *crop =
> +				v4l2_subdev_get_try_crop(sd, fh->pad, 0);
> +
> +	crop->left = OV5647_COLUMN_START_DEF;
> +	crop->top = OV5647_ROW_START_DEF;
> +	crop->width = OV5647_WINDOW_WIDTH_DEF;
> +	crop->height = OV5647_WINDOW_HEIGHT_DEF;
> +
> +	format->code = MEDIA_BUS_FMT_SBGGR8_1X8;
> +
> +	format->width = OV5647_WINDOW_WIDTH_DEF;
> +	format->height = OV5647_WINDOW_HEIGHT_DEF;
> +	format->field = V4L2_FIELD_NONE;
> +	format->colorspace = V4L2_COLORSPACE_SRGB;
> +
> +	return sensor_power(sd, true);
> +}
> +
> +static int ov5647_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +	return sensor_power(sd, false);
> +}
> +
> +/**
> + * @short Subdev internal operations registration
> + *
> + */
> +static const struct v4l2_subdev_internal_ops ov5647_subdev_internal_ops = {
> +	.registered = ov5647_registered,
> +	.open = ov5647_open,
> +	.close = ov5647_close,
> +};
> +
> +static int ov5647_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct device *dev = &client->dev;
> +	struct ov5647 *sensor;
> +	int ret;
> +	struct v4l2_subdev *sd;
> +
> +	sensor = devm_kzalloc(dev, sizeof(*sensor), GFP_KERNEL);
> +	if (sensor == NULL)
> +		return -ENOMEM;
> +
> +	/* get system clock (xclk) */
> +	sensor->xclk = devm_clk_get(dev, "xclk");
> +	if (IS_ERR(sensor->xclk)) {
> +		dev_err(dev, "could not get xclk");
> +		return PTR_ERR(sensor->xclk);
> +	}
> +
> +	sensor->xclk_freq = clk_get_rate(sensor->xclk);
> +	if (sensor->xclk_freq != 25000000) {
> +		dev_err(dev, "Unsupported clock frequency: %u\n",
> +			sensor->xclk_freq);
> +		return -EINVAL;
> +	}
> +
> +	mutex_init(&sensor->lock);
> +
> +	sd = &sensor->sd;
> +	v4l2_i2c_subdev_init(sd, client, &subdev_ops);
> +	sensor->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	sd->entity.function = MEDIA_ENT_F_CAM_SENSOR;
> +	ret = media_entity_pads_init(&sd->entity, 1, &sensor->pad);
> +	if (ret < 0)
> +		goto mutex_remove;
> +
> +	ret = ov5647_detect(sd);
> +	if (ret < 0)
> +		goto error;
> +
> +	ret = v4l2_async_register_subdev(sd);
> +	if (ret < 0)
> +		goto error;
> +
> +	dev_dbg(&client->dev, "OmniVision OV5647 camera driver probed\n");
> +	return 0;
> +error:
> +	media_entity_cleanup(&sd->entity);
> +mutex_remove:
> +	mutex_destroy(&sensor->lock);
> +	return ret;
> +}
> +
> +static int ov5647_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct ov5647 *ov5647 = to_state(sd);
> +
> +	v4l2_async_unregister_subdev(&ov5647->sd);
> +	media_entity_cleanup(&ov5647->sd.entity);
> +	v4l2_device_unregister_subdev(sd);
> +	mutex_destroy(&ov5647->lock);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id ov5647_id[] = {
> +	{ "ov5647", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, ov5647_id);
> +
> +#if IS_ENABLED(CONFIG_OF)
> +static const struct of_device_id ov5647_of_match[] = {
> +	{ .compatible = "ovti,ov5647" },
> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(of, ov5647_of_match);
> +#endif
> +
> +static struct i2c_driver ov5647_driver = {
> +	.driver = {
> +		.of_match_table = of_match_ptr(ov5647_of_match),
> +		.name	= SENSOR_NAME,
> +	},
> +	.probe		= ov5647_probe,
> +	.remove		= ov5647_remove,
> +	.id_table	= ov5647_id,
> +};
> +
> +module_i2c_driver(ov5647_driver);
> +
> +MODULE_AUTHOR("Ramiro Oliveira <roliveir@synopsys.com>");
> +MODULE_DESCRIPTION("A low-level driver for OmniVision ov5647 sensors");
> +MODULE_LICENSE("GPL v2");

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
