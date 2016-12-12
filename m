Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41120 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750696AbcLLLyN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 06:54:13 -0500
Date: Mon, 12 Dec 2016 13:54:07 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Cc: mchehab@kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, geert+renesas@glider.be,
        akpm@linux-foundation.org, linux@roeck-us.net, hverkuil@xs4all.nl,
        dheitmueller@kernellabs.com, slongerbeam@gmail.com,
        lars@metafoo.de, robert.jarzmik@free.fr, pavel@ucw.cz,
        pali.rohar@gmail.com, sakari.ailus@linux.intel.com,
        mark.rutland@arm.com, CARLOS.PALMINHA@synopsys.com
Subject: Re: [PATCH v5 2/2] Add support for OV5647 sensor
Message-ID: <20161212115407.GT16630@valkosipuli.retiisi.org.uk>
References: <cover.1480958609.git.roliveir@synopsys.com>
 <3e6262362f9961d2cf861353f32dbcd5bcc5a879.1480958609.git.roliveir@synopsys.com>
 <20161207230138.GA16630@valkosipuli.retiisi.org.uk>
 <936d4f19-9a1a-0873-121e-b9471449f70d@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <936d4f19-9a1a-0873-121e-b9471449f70d@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramiro,

On Mon, Dec 12, 2016 at 11:39:13AM +0000, Ramiro Oliveira wrote:
> Hi Sakari
> 
> On 12/7/2016 11:01 PM, Sakari Ailus wrote:
> > Hi Ramiro,
> > 
> > On Mon, Dec 05, 2016 at 05:36:34PM +0000, Ramiro Oliveira wrote:
> >> Add support for OV5647 sensor.
> >>
> >> Modes supported:
> >>  - 640x480 RAW 8
> >>
> >> Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>
> >> ---
> >>  MAINTAINERS                |   7 +
> >>  drivers/media/i2c/Kconfig  |  12 +
> >>  drivers/media/i2c/Makefile |   1 +
> >>  drivers/media/i2c/ov5647.c | 866 +++++++++++++++++++++++++++++++++++++++++++++
> >>  4 files changed, 886 insertions(+)
> >>  create mode 100644 drivers/media/i2c/ov5647.c
> >>
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> >> index 52cc077..72e828a 100644
> >> --- a/MAINTAINERS
> >> +++ b/MAINTAINERS
> >> @@ -8923,6 +8923,13 @@ M:	Harald Welte <laforge@gnumonks.org>
> >>  S:	Maintained
> >>  F:	drivers/char/pcmcia/cm4040_cs.*
> >>  
> >> +OMNIVISION OV5647 SENSOR DRIVER
> >> +M:	Ramiro Oliveira <roliveir@synopsys.com>
> >> +L:	linux-media@vger.kernel.org
> >> +T:	git git://linuxtv.org/media_tree.git
> >> +S:	Maintained
> >> +F:	drivers/media/i2c/ov5647.c
> >> +
> >>  OMNIVISION OV7670 SENSOR DRIVER
> >>  M:	Jonathan Corbet <corbet@lwn.net>
> >>  L:	linux-media@vger.kernel.org
> >> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> >> index b31fa6f..c1b78e5 100644
> >> --- a/drivers/media/i2c/Kconfig
> >> +++ b/drivers/media/i2c/Kconfig
> >> @@ -531,6 +531,18 @@ config VIDEO_OV2659
> >>  	  To compile this driver as a module, choose M here: the
> >>  	  module will be called ov2659.
> >>  
> >> +config VIDEO_OV5647
> >> +	tristate "OmniVision OV5647 sensor support"
> >> +	depends on OF
> > 
> > How does this driver depend on OF, other than matching the compatible
> > string?
> > 
> 
> It doesn't, should I proceed diferently?

You should drop the dependency if you don't need it. But I bet you will
actually need it.

> 
> >> +	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> >> +	depends on MEDIA_CAMERA_SUPPORT
> >> +	---help---
> >> +	  This is a Video4Linux2 sensor-level driver for the OmniVision
> >> +	  OV5647 camera.
> >> +
> >> +	  To compile this driver as a module, choose M here: the
> >> +	  module will be called ov5647.
> >> +
> >>  config VIDEO_OV7640
> >>  	tristate "OmniVision OV7640 sensor support"
> >>  	depends on I2C && VIDEO_V4L2
> >> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> >> index 92773b2..0d9014c 100644
> >> --- a/drivers/media/i2c/Makefile
> >> +++ b/drivers/media/i2c/Makefile
> >> @@ -82,3 +82,4 @@ obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
> >>  obj-$(CONFIG_VIDEO_ML86V7667)	+= ml86v7667.o
> >>  obj-$(CONFIG_VIDEO_OV2659)	+= ov2659.o
> >>  obj-$(CONFIG_VIDEO_TC358743)	+= tc358743.o
> >> +obj-$(CONFIG_VIDEO_OV5647)	+= ov5647.o
> >> diff --git a/drivers/media/i2c/ov5647.c b/drivers/media/i2c/ov5647.c
> >> new file mode 100644
> >> index 0000000..2aae806
> >> --- /dev/null
> >> +++ b/drivers/media/i2c/ov5647.c
> >> @@ -0,0 +1,866 @@
> >> +/*
> >> + * A V4L2 driver for OmniVision OV5647 cameras.
> >> + *
> >> + * Based on Samsung S5K6AAFX SXGA 1/6" 1.3M CMOS Image Sensor driver
> >> + * Copyright (C) 2011 Sylwester Nawrocki <s.nawrocki@samsung.com>
> >> + *
> >> + * Based on Omnivision OV7670 Camera Driver
> >> + * Copyright (C) 2006-7 Jonathan Corbet <corbet@lwn.net>
> >> + *
> >> + * Copyright (C) 2016, Synopsys, Inc.
> >> + *
> >> + * This program is free software; you can redistribute it and/or
> >> + * modify it under the terms of the GNU General Public License as
> >> + * published by the Free Software Foundation version 2.
> >> + *
> >> + * This program is distributed .as is. WITHOUT ANY WARRANTY of any
> >> + * kind, whether express or implied; without even the implied warranty
> >> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >> + * GNU General Public License for more details.
> >> + */
> >> +#include <linux/init.h>
> >> +#include <linux/module.h>
> >> +#include <linux/slab.h>
> >> +#include <linux/i2c.h>
> >> +#include <linux/delay.h>
> >> +#include <linux/videodev2.h>
> >> +#include <media/v4l2-device.h>
> >> +#include <media/v4l2-ctrls.h>
> >> +#include <media/v4l2-mediabus.h>
> >> +#include <media/v4l2-image-sizes.h>
> >> +#include <media/v4l2-of.h>
> >> +#include <linux/io.h>
> > 
> > Alphabetical order, please.
> > 
> >> +
> >> +#define SENSOR_NAME "ov5647"
> >> +
> >> +#define OV5647_SW_RESET		0x1003
> >> +#define OV5647_REG_CHIPID_H	0x300A
> >> +#define OV5647_REG_CHIPID_L	0x300B
> >> +
> >> +#define REG_TERM 0xfffe
> >> +#define VAL_TERM 0xfe
> >> +#define REG_DLY  0xffff
> >> +
> >> +#define OV5647_ROW_START		0x01
> >> +#define OV5647_ROW_START_MIN		0
> >> +#define OV5647_ROW_START_MAX		2004
> >> +#define OV5647_ROW_START_DEF		54
> >> +
> >> +#define OV5647_COLUMN_START		0x02
> >> +#define OV5647_COLUMN_START_MIN		0
> >> +#define OV5647_COLUMN_START_MAX		2750
> >> +#define OV5647_COLUMN_START_DEF		16
> >> +
> >> +#define OV5647_WINDOW_HEIGHT		0x03
> >> +#define OV5647_WINDOW_HEIGHT_MIN	2
> >> +#define OV5647_WINDOW_HEIGHT_MAX	2006
> >> +#define OV5647_WINDOW_HEIGHT_DEF	1944
> >> +
> >> +#define OV5647_WINDOW_WIDTH		0x04
> >> +#define OV5647_WINDOW_WIDTH_MIN		2
> >> +#define OV5647_WINDOW_WIDTH_MAX		2752
> >> +#define OV5647_WINDOW_WIDTH_DEF		2592
> >> +
> >> +struct regval_list {
> >> +	u16 addr;
> >> +	u8 data;
> >> +};
> >> +
> >> +struct cfg_array {
> >> +	struct regval_list *regs;
> >> +	int size;
> >> +};
> >> +
> >> +struct sensor_win_size {
> >> +	int width;
> >> +	int height;
> >> +	unsigned int hoffset;
> >> +	unsigned int voffset;
> >> +	unsigned int hts;
> >> +	unsigned int vts;
> >> +	unsigned int pclk;
> >> +	unsigned int mipi_bps;
> >> +	unsigned int fps_fixed;
> >> +	unsigned int bin_factor;
> >> +	unsigned int intg_min;
> >> +	unsigned int intg_max;
> >> +	void *regs;
> >> +	int regs_size;
> >> +	int (*set_size)(struct v4l2_subdev *sd);
> >> +};
> >> +
> >> +
> >> +struct ov5647 {
> >> +	struct device			*dev;
> >> +	struct v4l2_subdev		sd;
> >> +	struct media_pad		pad;
> >> +	struct mutex			lock;
> >> +	struct v4l2_mbus_framefmt	format;
> >> +	struct sensor_format_struct	*fmt;
> >> +	unsigned int			width;
> >> +	unsigned int			height;
> >> +	unsigned int			capture_mode;
> >> +	int				hue;
> > 
> > At least capture_mode and hue are unused. Please remove unused fields.
> > 
> >> +	struct v4l2_fract		tpf;
> >> +	struct sensor_win_size		*current_wins;
> >> +};
> >> +
> >> +static inline struct ov5647 *to_state(struct v4l2_subdev *sd)
> >> +{
> >> +	return container_of(sd, struct ov5647, sd);
> >> +}
> >> +
> >> +static struct regval_list sensor_oe_disable_regs[] = {
> >> +	{0x3000, 0x00},
> >> +	{0x3001, 0x00},
> >> +	{0x3002, 0x00},
> >> +};
> >> +
> >> +static struct regval_list sensor_oe_enable_regs[] = {
> >> +	{0x3000, 0x0f},
> >> +	{0x3001, 0xff},
> >> +	{0x3002, 0xe4},
> >> +};
> >> +
> >> +static struct regval_list ov5647_640x480[] = {
> > 
> > Does this list expect a certain external clock frequency? If it does, should
> > you check that the actual frequency matches with the expectation?
> > 
> 
> Yes. But like I said in the DT patch the external clock has a fixed frequency. I
> can add a check if you thinks it's better.
> 
> >> +	{0x0100, 0x00},
> >> +	{0x0103, 0x01},
> >> +	{0x3034, 0x08},
> >> +	{0x3035, 0x21},
> >> +	{0x3036, 0x46},
> >> +	{0x303c, 0x11},
> >> +	{0x3106, 0xf5},
> >> +	{0x3821, 0x07},
> >> +	{0x3820, 0x41},
> >> +	{0x3827, 0xec},
> >> +	{0x370c, 0x0f},
> >> +	{0x3612, 0x59},
> >> +	{0x3618, 0x00},
> >> +	{0x5000, 0x06},
> >> +	{0x5001, 0x01},
> >> +	{0x5002, 0x41},
> >> +	{0x5003, 0x08},
> >> +	{0x5a00, 0x08},
> >> +	{0x3000, 0x00},
> >> +	{0x3001, 0x00},
> >> +	{0x3002, 0x00},
> >> +	{0x3016, 0x08},
> >> +	{0x3017, 0xe0},
> >> +	{0x3018, 0x44},
> >> +	{0x301c, 0xf8},
> >> +	{0x301d, 0xf0},
> >> +	{0x3a18, 0x00},
> >> +	{0x3a19, 0xf8},
> >> +	{0x3c01, 0x80},
> >> +	{0x3b07, 0x0c},
> >> +	{0x380c, 0x07},
> >> +	{0x380d, 0x68},
> >> +	{0x380e, 0x03},
> >> +	{0x380f, 0xd8},
> >> +	{0x3814, 0x31},
> >> +	{0x3815, 0x31},
> >> +	{0x3708, 0x64},
> >> +	{0x3709, 0x52},
> >> +	{0x3808, 0x02},
> >> +	{0x3809, 0x80},
> >> +	{0x380a, 0x01},
> >> +	{0x380b, 0xE0},
> >> +	{0x3801, 0x00},
> >> +	{0x3802, 0x00},
> >> +	{0x3803, 0x00},
> >> +	{0x3804, 0x0a},
> >> +	{0x3805, 0x3f},
> >> +	{0x3806, 0x07},
> >> +	{0x3807, 0xa1},
> >> +	{0x3811, 0x08},
> >> +	{0x3813, 0x02},
> >> +	{0x3630, 0x2e},
> >> +	{0x3632, 0xe2},
> >> +	{0x3633, 0x23},
> >> +	{0x3634, 0x44},
> >> +	{0x3636, 0x06},
> >> +	{0x3620, 0x64},
> >> +	{0x3621, 0xe0},
> >> +	{0x3600, 0x37},
> >> +	{0x3704, 0xa0},
> >> +	{0x3703, 0x5a},
> >> +	{0x3715, 0x78},
> >> +	{0x3717, 0x01},
> >> +	{0x3731, 0x02},
> >> +	{0x370b, 0x60},
> >> +	{0x3705, 0x1a},
> >> +	{0x3f05, 0x02},
> >> +	{0x3f06, 0x10},
> >> +	{0x3f01, 0x0a},
> >> +	{0x3a08, 0x01},
> >> +	{0x3a09, 0x27},
> >> +	{0x3a0a, 0x00},
> >> +	{0x3a0b, 0xf6},
> >> +	{0x3a0d, 0x04},
> >> +	{0x3a0e, 0x03},
> >> +	{0x3a0f, 0x58},
> >> +	{0x3a10, 0x50},
> >> +	{0x3a1b, 0x58},
> >> +	{0x3a1e, 0x50},
> >> +	{0x3a11, 0x60},
> >> +	{0x3a1f, 0x28},
> >> +	{0x4001, 0x02},
> >> +	{0x4004, 0x02},
> >> +	{0x4000, 0x09},
> >> +	{0x4837, 0x24},
> >> +	{0x4050, 0x6e},
> >> +	{0x4051, 0x8f},
> >> +	{0x0100, 0x01},
> >> +};
> >> +
> >> +struct sensor_format_struct;
> >> +
> >> +/**
> >> + * @short I2C Write operation
> >> + * @param[in] i2c_client I2C client
> >> + * @param[in] reg register address
> >> + * @param[in] val value to write
> >> + * @return Error code
> >> + */
> >> +static int ov5647_write(struct v4l2_subdev *sd, u16 reg, u8 val)
> >> +{
> >> +	int ret;
> >> +	unsigned char data[3] = { reg >> 8, reg & 0xff, val};
> >> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> >> +
> >> +	ret = i2c_master_send(client, data, 3);
> >> +	if (ret != 3) {
> >> +		dev_dbg(&client->dev, "%s: i2c write error, reg: %x\n",
> >> +				__func__, reg);
> >> +		return ret < 0 ? ret : -EIO;
> >> +	}
> >> +	return 0;
> >> +}
> >> +
> >> +/**
> >> + * @short I2C Read operation
> >> + * @param[in] i2c_client I2C client
> >> + * @param[in] reg register address
> >> + * @param[out] val value read
> >> + * @return Error code
> >> + */
> >> +static int ov5647_read(struct v4l2_subdev *sd, u16 reg, u8 *val)
> >> +{
> >> +	int ret;
> >> +	unsigned char data_w[2] = { reg >> 8, reg & 0xff };
> >> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> >> +
> >> +
> >> +	ret = i2c_master_send(client, data_w, 2);
> >> +
> >> +	if (ret < 2) {
> >> +		dev_dbg(&client->dev, "%s: i2c read error, reg: %x\n",
> >> +			__func__, reg);
> >> +		return ret < 0 ? ret : -EIO;
> >> +	}
> >> +
> >> +
> >> +	ret = i2c_master_recv(client, val, 1);
> >> +
> >> +	if (ret < 1) {
> >> +		dev_dbg(&client->dev, "%s: i2c read error, reg: %x\n",
> >> +				__func__, reg);
> >> +		return ret < 0 ? ret : -EIO;
> >> +	}
> >> +	return 0;
> >> +}
> >> +
> >> +static int ov5647_write_array(struct v4l2_subdev *sd,
> >> +				struct regval_list *regs, int array_size)
> >> +{
> >> +	int i = 0;
> >> +	int ret = 0;
> >> +
> >> +	if (!regs)
> >> +		return -EINVAL;
> >> +
> >> +	while (i < array_size) {
> >> +		ret = ov5647_write(sd, regs->addr, regs->data);
> >> +		if (ret < 0)
> >> +			return ret;
> >> +		i++;
> >> +		regs++;
> >> +	}
> >> +	return 0;
> >> +}
> >> +
> >> +static void ov5647_set_virtual_channel(struct v4l2_subdev *sd, int channel)
> >> +{
> >> +	u8 channel_id;
> >> +
> >> +	ov5647_read(sd, 0x4814, &channel_id);
> >> +	channel_id &= ~(3 << 6);
> >> +	ov5647_write(sd, 0x4814, channel_id | (channel << 6));
> >> +}
> >> +
> >> +void ov5647_stream_on(struct v4l2_subdev *sd)
> >> +{
> >> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> >> +
> >> +	ov5647_write(sd, 0x4202, 0x00);
> >> +	dev_dbg(&client->dev, "Stream on");
> >> +	ov5647_write(sd, 0x300D, 0x00);
> >> +}
> >> +
> >> +void ov5647_stream_off(struct v4l2_subdev *sd)
> >> +{
> >> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> >> +
> >> +	ov5647_write(sd, 0x4202, 0x0f);
> >> +	dev_dbg(&client->dev, "Stream off");
> >> +	ov5647_write(sd, 0x300D, 0x01);
> >> +}
> >> +
> >> +/****************************************************************************/
> >> +
> >> +/**
> >> + * @short Set SW standby
> >> + * @param[in] sd v4l2 sd
> >> + * @param[in] stanby standby mode status (on or off)
> >> + * @return Error code
> >> + */
> >> +static int set_sw_standby(struct v4l2_subdev *sd, bool standby)
> >> +{
> >> +	int ret;
> >> +	unsigned char rdval;
> >> +
> >> +	ret = ov5647_read(sd, 0x0100, &rdval);
> >> +	if (ret != 0)
> >> +		return ret;
> >> +
> >> +	if (standby)
> >> +		rdval &= 0xfe;
> >> +	else
> >> +		rdval |= 0x01;
> >> +
> >> +	ret = ov5647_write(sd, 0x0100, rdval);
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +/**
> >> + * @short Store information about the video data format.
> >> + */
> >> +static struct sensor_format_struct {
> >> +	u8 *desc;
> >> +	u32 mbus_code;
> >> +	struct regval_list *regs;
> >> +	int regs_size;
> >> +	int bpp;
> > 
> > At least desc and bpp are unused.
> > 
> >> +} sensor_formats[] = {
> >> +	{
> >> +		.desc		= "Raw RGB Bayer",
> >> +		.mbus_code	= MEDIA_BUS_FMT_SBGGR8_1X8,
> >> +		.regs		= ov5647_640x480,
> >> +		.regs_size	= ARRAY_SIZE(ov5647_640x480),
> >> +		.bpp		= 1
> >> +	},
> >> +};
> >> +#define N_FMTS ARRAY_SIZE(sensor_formats)
> >> +
> >> +/* ----------------------------------------------------------------------- */
> >> +
> >> +/**
> >> + * @short Initialize sensor
> >> + * @param[in] sd v4l2 subdev
> >> + * @param[in] val not used
> >> + * @return Error code
> >> + */
> >> +static int __sensor_init(struct v4l2_subdev *sd)
> >> +{
> >> +	int ret;
> >> +	u8 resetval;
> >> +	u8 rdval;
> >> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> >> +
> >> +	dev_dbg(&client->dev, "sensor init\n");
> >> +
> >> +	ret = ov5647_read(sd, 0x0100, &rdval);
> >> +	if (ret != 0)
> >> +		return ret;
> >> +
> >> +	ov5647_write(sd, 0x4800, 0x25);
> >> +	ov5647_stream_off(sd);
> >> +
> >> +	ret = ov5647_write_array(sd, ov5647_640x480,
> >> +					ARRAY_SIZE(ov5647_640x480));
> >> +	if (ret < 0) {
> >> +		dev_err(&client->dev, "write sensor_default_regs error\n");
> >> +		return ret;
> >> +	}
> >> +
> >> +	ov5647_set_virtual_channel(sd, 0);
> >> +
> >> +	ov5647_read(sd, 0x0100, &resetval);
> >> +	if (!(resetval & 0x01)) {
> >> +		dev_err(&client->dev, "Device was in SW standby");
> >> +		ov5647_write(sd, 0x0100, 0x01);
> >> +	}
> >> +
> >> +	ov5647_write(sd, 0x4800, 0x04);
> >> +	ov5647_stream_on(sd);
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +/**
> >> + * @short Control sensor power state
> >> + * @param[in] sd v4l2 subdev
> >> + * @param[in] on Sensor power
> >> + * @return Error code
> >> + */
> >> +static int sensor_power(struct v4l2_subdev *sd, int on)
> >> +{
> >> +	int ret;
> >> +	struct ov5647 *ov5647 = to_state(sd);
> >> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> >> +
> >> +	ret = 0;
> >> +	mutex_lock(&ov5647->lock);
> >> +
> >> +	if (on)	{
> >> +		dev_dbg(&client->dev, "OV5647 power on\n");
> >> +
> >> +		ret = ov5647_write_array(sd, sensor_oe_enable_regs,
> >> +				ARRAY_SIZE(sensor_oe_enable_regs));
> >> +
> >> +		ret = __sensor_init(sd);
> >> +
> >> +		if (ret < 0)
> >> +			dev_err(&client->dev,
> >> +				"Camera not available, check Power\n");
> >> +	} else {
> >> +		dev_dbg(&client->dev, "OV5647 power off\n");
> >> +
> >> +		dev_dbg(&client->dev, "disable oe\n");
> >> +		ret = ov5647_write_array(sd, sensor_oe_disable_regs,
> >> +				ARRAY_SIZE(sensor_oe_disable_regs));
> >> +
> >> +		if (ret < 0)
> >> +			dev_dbg(&client->dev, "disable oe failed\n");
> >> +
> >> +		ret = set_sw_standby(sd, true);
> >> +
> >> +		if (ret < 0)
> >> +			dev_dbg(&client->dev, "soft stby failed\n");
> >> +
> >> +	}
> >> +
> >> +	mutex_unlock(&ov5647->lock);
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> >> +/**
> >> + * @short Get register value
> >> + * @param[in] sd v4l2 subdev
> >> + * @param[in] reg register struct
> >> + * @return Error code
> >> + */
> >> +static int sensor_get_register(struct v4l2_subdev *sd,
> >> +				struct v4l2_dbg_register *reg)
> >> +{
> >> +	unsigned char val = 0;
> >> +	int ret;
> >> +
> >> +	ret = ov5647_read(sd, reg->reg & 0xff, &val);
> >> +	if (ret != 0)
> >> +		return ret;
> >> +
> >> +	reg->val = val;
> >> +	reg->size = 1;
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +/**
> >> + * @short Set register value
> >> + * @param[in] sd v4l2 subdev
> >> + * @param[in] reg register struct
> >> + * @return Error code
> >> + */
> >> +static int sensor_set_register(struct v4l2_subdev *sd,
> >> +				const struct v4l2_dbg_register *reg)
> >> +{
> >> +	return ov5647_write(sd, reg->reg & 0xff, reg->val & 0xff);
> >> +}
> >> +#endif
> >> +
> >> +/* ----------------------------------------------------------------------- */
> >> +
> >> +/**
> >> + * @short Subdev core operations registration
> >> + */
> >> +static const struct v4l2_subdev_core_ops sensor_core_ops = {
> >> +	.s_power		= sensor_power,
> > 
> > The s_power() op will be called by the bridge (ISP) driver as well. You
> > should expect that it may be enabled more than once before being disabled
> > equal number of times.
> > 
> 
> Should I add an IF check to verify if the sensor is powered on before running
> the power on/off routine.

You need a counter. One way to do that is in the driver itself, or you can
do what I recently did in the smiapp driver, using runtime PM so you don't
explicitly need to manage it:

<URL:https://git.linuxtv.org/sailus/media_tree.git/tree/drivers/media/i2c/smiapp/smiapp-core.c?h=smiapp-pm&id=c29df33f9ec94226eab8ee92d8c66ab83c76659a>

Or, before the runtime PM conversion:

<URL:https://git.linuxtv.org/sailus/media_tree.git/tree/drivers/media/i2c/smiapp/smiapp-core.c?h=smiapp-pm&id=c8d2bc9bc39ebea8437fd974fdbc21847bb897a3>

The use of runtime PM in sub-device drivers is new and I'm not entirely
happy how it's implemented in the smiapp driver right now, hence it might be
better not to use it (yet). Up to you.

> 
> >> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> >> +	.g_register		= sensor_get_register,
> >> +	.s_register		= sensor_set_register,
> >> +#endif
> >> +};
> >> +
> >> +/* ----------------------------------------------------------------------- */
> >> +
> >> +
> >> +
> >> +/**
> >> + * @short Enumerate available image formats
> >> + * @param[in] sd v4l2 subdev
> >> + * @param[in] index index
> >> + * @param[in] code MBUS Pixel code
> >> + * @return Error code
> >> + */
> >> +static int sensor_enum_fmt(struct v4l2_subdev *sd,
> >> +		struct v4l2_subdev_pad_config *cfg,
> >> +		struct v4l2_subdev_mbus_code_enum *code)
> >> +{
> >> +	if (code->pad || code->index >= N_FMTS)
> >> +		return -EINVAL;
> >> +
> >> +	code->code = sensor_formats[code->index].mbus_code;
> >> +	return 0;
> >> +}
> >> +
> >> +/**
> >> + * @short Try frame format internal function
> >> + * @param[in] sd v4l2 subdev
> >> + * @param[in] fmt frame format
> >> + * @return Error code
> >> + */
> >> +static int sensor_try_fmt_internal(struct v4l2_subdev *sd,
> >> +	struct v4l2_mbus_framefmt *fmt, struct sensor_format_struct **ret_fmt,
> >> +	struct sensor_win_size **ret_wsize)
> >> +{
> >> +	int index;
> >> +
> >> +	for (index = 0; index < N_FMTS; index++)
> >> +		if (sensor_formats[index].mbus_code == fmt->code)
> >> +			break;
> >> +
> >> +	if (index >= N_FMTS)
> >> +		return -EINVAL;
> >> +
> >> +	if (ret_fmt != NULL)
> >> +		*ret_fmt = sensor_formats + index;
> >> +
> >> +	fmt->field = V4L2_FIELD_NONE;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +/**
> >> + * @short Set frame format
> >> + * @param[in] sd v4l2 subdev
> >> + * @param[in] fmt frame format
> >> + * @return Error code
> >> + */
> >> +static int sensor_s_fmt(struct v4l2_subdev *sd,
> >> +		struct v4l2_subdev_pad_config *cfg,
> >> +		struct v4l2_subdev_format *fmt)
> >> +{
> >> +	int ret;
> >> +	struct sensor_format_struct *sensor_fmt;
> >> +	struct sensor_win_size *wsize;
> >> +	struct ov5647 *info = to_state(sd);
> >> +
> >> +	ov5647_write_array(sd, sensor_oe_disable_regs,
> >> +					ARRAY_SIZE(sensor_oe_disable_regs));
> > 
> > Should you check the error code here?
> > 
> >> +
> >> +	ret = sensor_try_fmt_internal(sd, &fmt->format,
> >> +					&sensor_fmt, &wsize);
> > 
> > Do you set wsize somewhere?
> > 
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	ov5647_write_array(sd, sensor_fmt->regs, sensor_fmt->regs_size);
> > 
> > And here.
> > 
> >> +
> >> +	ret = 0;
> > 
> > ret was already zero.
> > 
> >> +
> >> +	if (wsize->regs)
> >> +		ov5647_write_array(sd, wsize->regs, wsize->regs_size);
> >> +
> >> +	if (wsize->set_size)
> >> +		wsize->set_size(sd);
> >> +
> >> +	info->fmt = sensor_fmt;
> >> +	info->width = wsize->width;
> >> +	info->height = wsize->height;
> >> +
> >> +	ov5647_write_array(sd, sensor_oe_enable_regs,
> >> +				ARRAY_SIZE(sensor_oe_enable_regs));
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +/**
> >> + * @short Set stream parameters
> >> + * @param[in] sd v4l2 subdev
> >> + * @param[in] parms stream parameters
> >> + * @return Error code
> >> + */
> >> +static int sensor_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
> >> +{
> >> +	struct v4l2_captureparm *cp = &parms->parm.capture;
> >> +	struct ov5647 *info = to_state(sd);
> >> +
> >> +	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> >> +		return -EINVAL;
> >> +
> >> +	if (info->tpf.numerator == 0)
> >> +		return -EINVAL;
> >> +
> >> +	info->capture_mode = cp->capturemode;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +/**
> >> + * @short Get stream parameters
> >> + * @param[in] sd v4l2 subdev
> >> + * @param[in] parms stream parameters
> >> + * @return Error code
> >> + */
> >> +static int sensor_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
> >> +{
> >> +	struct v4l2_captureparm *cp = &parms->parm.capture;
> >> +	struct ov5647 *info = to_state(sd);
> >> +
> >> +	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> >> +		return -EINVAL;
> >> +
> >> +	memset(cp, 0, sizeof(struct v4l2_captureparm));
> >> +	cp->capability = V4L2_CAP_TIMEPERFRAME;
> >> +	cp->capturemode = info->capture_mode;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +/**
> >> + * @short Subdev video operations registration
> >> + *
> >> + */
> >> +static const struct v4l2_subdev_video_ops sensor_video_ops = {
> >> +	.s_parm		= sensor_s_parm,
> >> +	.g_parm		= sensor_g_parm,
> > 
> > Please use the g/s_frame_interval() instead. That's what sub-device drivers
> > generally use for the purpose.
> > 
> >> +};
> >> +
> >> +/* ----------------------------------------------------------------------- */
> >> +
> >> +/**
> >> + * @short Subdev operations registration
> >> + *
> >> + */
> >> +static const struct v4l2_subdev_ops subdev_ops = {
> >> +	.core			= &sensor_core_ops,
> >> +	.video			= &sensor_video_ops,
> >> +};
> >> +
> >> +/* -----------------------------------------------------------------------------
> >> + * V4L2 subdev internal operations
> >> + */
> >> +
> >> +/**
> >> + * @short Detect camera version and model
> >> + * @param[in] sd v4l2 subdev
> >> + * @return Error code
> >> + */
> >> +int ov5647_detect(struct v4l2_subdev *sd)
> >> +{
> >> +	unsigned char v;
> >> +	int ret;
> >> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> >> +
> >> +	ret = ov5647_write(sd, OV5647_SW_RESET, 0x01);
> >> +	if (ret < 0)
> >> +		return ret;
> >> +	ret = ov5647_read(sd, OV5647_REG_CHIPID_H, &v);
> >> +	if (ret < 0)
> >> +		return ret;
> >> +	if (v != 0x56) {
> >> +		dev_err(&client->dev, "Wrong model version detected");
> >> +		return -ENODEV;
> >> +	}
> >> +	ret = ov5647_read(sd, OV5647_REG_CHIPID_L, &v);
> >> +	if (ret < 0)
> >> +		return ret;
> >> +	if (v != 0x47) {
> >> +		dev_err(&client->dev, "Wrong model version detected");
> >> +		return -ENODEV;
> >> +	}
> >> +
> >> +	ret = ov5647_write(sd, OV5647_SW_RESET, 0x00);
> >> +	if (ret < 0)
> >> +		return ret;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +/**
> >> + * @short Detect if camera is registered
> >> + * @param[in] sd v4l2 subdev
> >> + * @return Error code
> >> + */
> >> +static int ov5647_registered(struct v4l2_subdev *sd)
> >> +{
> >> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> >> +
> >> +	dev_info(&client->dev, "OV5647 detected at address 0x%02x\n",
> >> +				client->addr);
> > 
> > I might omit this. If there's a need to debug this then the information
> > should be printed by the framework instead using debug level messages.
> > 
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +/**
> >> + * @short Open device
> >> + * @param[in] sd v4l2 subdev
> >> + * @param[in] fh v4l2 file handler
> >> + * @return Error code
> >> + */
> >> +static int ov5647_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> >> +{
> >> +	struct v4l2_mbus_framefmt *format =
> >> +				v4l2_subdev_get_try_format(sd, fh->pad, 0);
> >> +	struct v4l2_rect *crop =
> >> +				v4l2_subdev_get_try_crop(sd, fh->pad, 0);
> >> +
> >> +	crop->left = OV5647_COLUMN_START_DEF;
> >> +	crop->top = OV5647_ROW_START_DEF;
> >> +	crop->width = OV5647_WINDOW_WIDTH_DEF;
> >> +	crop->height = OV5647_WINDOW_HEIGHT_DEF;
> >> +
> >> +	format->code = MEDIA_BUS_FMT_SBGGR8_1X8;
> >> +
> >> +	format->width = OV5647_WINDOW_WIDTH_DEF;
> >> +	format->height = OV5647_WINDOW_HEIGHT_DEF;
> >> +	format->field = V4L2_FIELD_NONE;
> >> +	format->colorspace = V4L2_COLORSPACE_SRGB;
> >> +
> >> +	return sensor_power(sd, true);
> >> +}
> >> +
> >> +/**
> >> + * @short Open device
> >> + * @param[in] sd v4l2 subdev
> >> + * @param[in] fh v4l2 file handler
> >> + * @return Error code
> >> + */
> >> +static int ov5647_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> >> +{
> >> +	return sensor_power(sd, false);
> >> +}
> >> +
> >> +/**
> >> + * @short Subdev internal operations registration
> >> + *
> >> + */
> >> +static const struct v4l2_subdev_internal_ops ov5647_subdev_internal_ops = {
> >> +	.registered = ov5647_registered,
> >> +	.open = ov5647_open,
> >> +	.close = ov5647_close,
> >> +};
> >> +
> >> +/**
> >> + * @short Initialization routine - Entry point of the driver
> >> + * @param[in] client pointer to the i2c client structure
> >> + * @param[in] id pointer to the i2c device id structure
> >> + * @return 0 on success and a negative number on failure
> >> + */
> >> +static int ov5647_probe(struct i2c_client *client,
> >> +			const struct i2c_device_id *id)
> >> +{
> >> +	struct device *dev = &client->dev;
> >> +	struct ov5647 *sensor;
> >> +	int ret = 0;
> > 
> > No need to initialise ret here.
> > 
> >> +	struct v4l2_subdev *sd;
> >> +
> >> +	dev_info(&client->dev, "Installing OmniVision OV5647 camera driver\n");
> >> +
> >> +	sensor = devm_kzalloc(dev, sizeof(*sensor), GFP_KERNEL);
> >> +	if (sensor == NULL)
> >> +		return -ENOMEM;
> >> +
> >> +	mutex_init(&sensor->lock);
> >> +	sensor->dev = dev;
> >> +
> >> +	sd = &sensor->sd;
> >> +	v4l2_i2c_subdev_init(sd, client, &subdev_ops);
> >> +	sensor->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> >> +
> >> +	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
> >> +	sd->entity.function = MEDIA_ENT_F_CAM_SENSOR;
> >> +	ret = media_entity_pads_init(&sd->entity, 1, &sensor->pad);
> >> +	if (ret < 0)
> >> +		goto mutex_remove;
> >> +
> >> +	ret = ov5647_detect(sd);
> >> +	if (ret < 0)
> >> +		goto error;
> >> +
> >> +	ret = v4l2_async_register_subdev(sd);
> >> +	if (ret < 0)
> >> +		goto error;
> >> +
> >> +	return 0;
> >> +error:
> >> +	media_entity_cleanup(&sd->entity);
> >> +mutex_remove:
> >> +	mutex_destroy(&sensor->lock);
> >> +	return ret;
> >> +}
> >> +
> >> +/**
> >> + * @short Exit routine - Exit point of the driver
> >> + * @param[in] client pointer to the i2c client structure
> >> + * @return 0 on success and a negative number on failure
> >> + */
> >> +static int ov5647_remove(struct i2c_client *client)
> >> +{
> >> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> >> +	struct ov5647 *ov5647 = to_state(sd);
> >> +
> >> +	v4l2_async_unregister_subdev(&ov5647->sd);
> >> +	media_entity_cleanup(&ov5647->sd.entity);
> >> +	v4l2_device_unregister_subdev(sd);
> >> +	mutex_destroy(&ov5647->lock);
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static const struct i2c_device_id ov5647_id[] = {
> >> +	{ "ov5647", 0 },
> >> +	{ }
> >> +};
> >> +MODULE_DEVICE_TABLE(i2c, ov5647_id);
> >> +
> >> +#if IS_ENABLED(CONFIG_OF)
> >> +static const struct of_device_id ov5647_of_match[] = {
> >> +	{ .compatible = "ovti,ov5647" },
> >> +	{ /* sentinel */ },
> >> +};
> >> +MODULE_DEVICE_TABLE(of, ov5647_of_match);
> >> +#endif
> >> +
> >> +/**
> >> + * @short i2c driver structure
> >> + */
> >> +static struct i2c_driver ov5647_driver = {
> >> +	.driver = {
> >> +		.of_match_table = of_match_ptr(ov5647_of_match),
> >> +		.owner	= THIS_MODULE,
> >> +		.name	= "ov5647",
> >> +	},
> >> +	.probe		= ov5647_probe,
> >> +	.remove		= ov5647_remove,
> >> +	.id_table	= ov5647_id,
> >> +};
> >> +
> >> +module_i2c_driver(ov5647_driver);
> >> +
> >> +MODULE_AUTHOR("Ramiro Oliveira <roliveir@synopsys.com>");
> >> +MODULE_DESCRIPTION("A low-level driver for OmniVision ov5647 sensors");
> >> +MODULE_LICENSE("GPL v2");
> > 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
