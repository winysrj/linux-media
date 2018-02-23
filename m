Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:43277 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751338AbeBWOzo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Feb 2018 09:55:44 -0500
Received: by mail-wr0-f196.google.com with SMTP id u49so14367423wrc.10
        for <linux-media@vger.kernel.org>; Fri, 23 Feb 2018 06:55:43 -0800 (PST)
References: <20180222102338.28896-1-rui.silva@linaro.org> <20180222102338.28896-3-rui.silva@linaro.org> <20180223075001.hboz4urcxfzbpnwv@paasikivi.fi.intel.com>
From: Rui Miguel Silva <rui.silva@linaro.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: mchehab@kernel.org, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ryan Harkin <ryan.harkin@linaro.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: Re: [PATCH 2/2] media: ov2680: Add Omnivision OV2680 sensor driver
In-reply-to: <20180223075001.hboz4urcxfzbpnwv@paasikivi.fi.intel.com>
Date: Fri, 23 Feb 2018 14:55:39 +0000
Message-ID: <m3lgfjkb6c.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,
Thanks for your review.

On Fri 23 Feb 2018 at 07:50, Sakari Ailus wrote:
> Hi Rui,
>
> On Thu, Feb 22, 2018 at 10:23:38AM +0000, Rui Miguel Silva 
> wrote:
>> This patch adds V4L2 sub-device driver for OV2680 image sensor.
>> The OV2680 is a 1/5" CMOS color sensor from Omnivision.
>> Supports output format: 10-bit Raw RGB.
>> The OV2680 has a single lane MIPI interface.
>> 
>> The driver exposes following V4L2 controls:
>> - auto/manual exposure,
>> - exposure,
>> - auto/manual gain,
>> - gain,
>> - horizontal/vertical flip,
>> - test pattern menu.
>> Supported resolution are only: QUXGA, 720P, UXGA.
>> 
>> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
>> ---
>>  drivers/media/i2c/Kconfig  |   13 +
>>  drivers/media/i2c/Makefile |    1 +
>>  drivers/media/i2c/ov2680.c | 1189 
>>  ++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 1203 insertions(+)
>>  create mode 100644 drivers/media/i2c/ov2680.c
>> 
>> diff --git a/drivers/media/i2c/Kconfig 
>> b/drivers/media/i2c/Kconfig
>> index 9f18cd296841..089103d29171 100644
>> --- a/drivers/media/i2c/Kconfig
>> +++ b/drivers/media/i2c/Kconfig
>> @@ -586,6 +586,19 @@ config VIDEO_OV2659
>>  	  To compile this driver as a module, choose M here: the
>>  	  module will be called ov2659.
>>  
>> +config VIDEO_OV2680
>> +	tristate "OmniVision OV2680 sensor support"
>> +	depends on OF
>
> I think you can drop OF dependency here.

Agree.

>
>> +	depends on GPIOLIB && VIDEO_V4L2 && I2C && 
>> VIDEO_V4L2_SUBDEV_API
>> +	depends on MEDIA_CAMERA_SUPPORT
>> +	select V4L2_FWNODE
>> +	---help---
>> +	  This is a Video4Linux2 sensor-level driver for the 
>> OmniVision
>> +	  OV2680 camera sensor with a MIPI CSI-2 interface.
>> +
>> +	  To compile this driver as a module, choose M here: the
>> +	  module will be called ov2680.
>> +
>>  config VIDEO_OV5640
>>  	tristate "OmniVision OV5640 sensor support"
>>  	depends on OF
>> diff --git a/drivers/media/i2c/Makefile 
>> b/drivers/media/i2c/Makefile
>> index c0f94cd8d56d..d0aba4d37b8d 100644
>> --- a/drivers/media/i2c/Makefile
>> +++ b/drivers/media/i2c/Makefile
>> @@ -61,6 +61,7 @@ obj-$(CONFIG_VIDEO_SONY_BTF_MPX) += 
>> sony-btf-mpx.o
>>  obj-$(CONFIG_VIDEO_UPD64031A) += upd64031a.o
>>  obj-$(CONFIG_VIDEO_UPD64083) += upd64083.o
>>  obj-$(CONFIG_VIDEO_OV2640) += ov2640.o
>> +obj-$(CONFIG_VIDEO_OV2680) += ov2680.o
>>  obj-$(CONFIG_VIDEO_OV5640) += ov5640.o
>>  obj-$(CONFIG_VIDEO_OV5645) += ov5645.o
>>  obj-$(CONFIG_VIDEO_OV5647) += ov5647.o
>> diff --git a/drivers/media/i2c/ov2680.c 
>> b/drivers/media/i2c/ov2680.c
>> new file mode 100644
>> index 000000000000..64c1c2b03f97
>> --- /dev/null
>> +++ b/drivers/media/i2c/ov2680.c
>> @@ -0,0 +1,1189 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Omnivision OV2680 CMOS Image Sensor driver
>> + *
>> + * Copyright (C) 2018 Linaro Ltd
>> + *
>> + * Based on OV5640 Sensor Driver
>> + * Copyright (C) 2011-2013 Freescale Semiconductor, Inc. All 
>> Rights Reserved.
>> + * Copyright (C) 2014-2017 Mentor Graphics Inc.
>> + *
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/delay.h>
>> +#include <linux/err.h>
>> +#include <linux/i2c.h>
>> +#include <linux/init.h>
>> +#include <linux/module.h>
>> +#include <linux/of_device.h>
>> +#include <linux/of_gpio.h>
>
> Do you need of_gpio.h?

Yeah, I need only to include the gpio/consumer.h for the
devm_gpiod_get_optional call.

>
>> +
>> +#include <media/v4l2-common.h>
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-event.h>
>> +#include <media/v4l2-fwnode.h>
>> +#include <media/v4l2-image-sizes.h>
>> +#include <media/v4l2-mediabus.h>
>> +#include <media/v4l2-subdev.h>
>
> Do you need all of these? At least v4l2-event.h and 
> v4l2-image-sizes.h seem
> redundant.

Agree, will clean up this includes.

>
>> +
>> +#define OV2680_XVCLK_MIN	6000000
>> +#define OV2680_XVCLK_MAX	24000000
>> +
>> +#define OV2680_CHIP_ID_HIGH	0x26
>> +#define OV2680_CHIP_ID_LOW	0x80
>> +
>> +#define OV2680_REG_STREAM_CTRL		0x0100
>> +#define OV2680_REG_SOFT_RESET		0x0103
>> +
>> +#define OV2680_REG_CHIP_ID_HIGH		0x300a
>> +#define OV2680_REG_CHIP_ID_LOW		0x300b
>> +
>> +#define OV2680_REG_R_MANUAL		0x3503
>> +#define OV2680_REG_GAIN_PK		0x350a
>> +#define OV2680_REG_EXPOSURE_PK_HIGH	0x3500
>> +#define OV2680_REG_EXPOSURE_PK_MED	0x3501
>> +#define OV2680_REG_EXPOSURE_PK_LOW	0x3502
>> +#define OV2680_REG_TIMING_HTS		0x380c
>> +#define OV2680_REG_TIMING_VTS		0x380e
>> +#define OV2680_REG_FORMAT1		0x3820
>> +#define OV2680_REG_FORMAT2		0x3821
>> +
>> +#define OV2680_REG_ISP_CTRL00		0x5080
>> +
>> +enum ov2680_frame_rate {
>> +	OV2680_30_FPS,
>> +	OV2680_FRAMERATES_MAX,
>> +};
>> +
>> +static const int ov2680_framerates[] = {
>> +	[OV2680_30_FPS] = 30,
>> +};
>> +
>> +enum ov2680_mode_id {
>> +	OV2680_MODE_QUXGA_800_600,
>> +	OV2680_MODE_720P_1280_720,
>> +	OV2680_MODE_UXGA_1600_1200,
>> +	OV2680_MODE_MAX,
>> +};
>> +
>> +struct reg_value {
>> +	u16 reg_addr;
>> +	u8 val;
>> +};
>> +
>> +struct ov2680_mode_info {
>> +	const char *name;
>> +	enum ov2680_mode_id id;
>> +	u32 width;
>> +	u32 height;
>> +	const struct reg_value *reg_data;
>> +	u32 reg_data_size;
>> +};
>> +
>> +struct ov2680_ctrls {
>> +	struct v4l2_ctrl_handler handler;
>> +	struct {
>> +		struct v4l2_ctrl *auto_exp;
>> +		struct v4l2_ctrl *exposure;
>> +	};
>> +	struct {
>> +		struct v4l2_ctrl *auto_gain;
>> +		struct v4l2_ctrl *gain;
>> +	};
>> +
>> +	struct v4l2_ctrl *hflip;
>> +	struct v4l2_ctrl *vflip;
>> +	struct v4l2_ctrl *test_pattern;
>> +};
>> +
>> +struct ov2680_dev {
>> +	struct i2c_client		*i2c_client;
>> +	struct v4l2_subdev		sd;
>> +
>> +	struct media_pad		pad;
>> +	struct v4l2_fwnode_endpoint	ep;
>> +	struct clk			*xvclk;
>> +	u32				xvclk_freq;
>> +
>> +	struct gpio_desc		*pwdn_gpio;
>> +	struct mutex			lock; /* protect members 
>> */
>> +
>> +	bool				mode_pending_changes;
>> +	bool				is_enabled;
>> +	bool				is_streaming;
>> +
>> +	struct ov2680_ctrls		ctrls;
>> +	struct v4l2_mbus_framefmt	fmt;
>> +	struct v4l2_fract		frame_interval;
>> +
>> +	enum ov2680_frame_rate		current_fps;
>> +	const struct ov2680_mode_info	*current_mode;
>> +};
>> +
>> +static const char * const test_pattern_menu[] = {
>> +	"Disabled",
>> +	"Color bars",
>
> "Color Bars",

right.

>
>> +	"Random Data",
>> +	"Square",
>> +	"Black Image",
>> +};
>> +
>> +static const struct reg_value 
>> ov2680_setting_30fps_QUXGA_800_600[] = {
>> +	{0x3086, 0x01}, {0x370a, 0x23}, {0x3808, 0x03}, {0x3809, 
>> 0x20},
>> +	{0x380a, 0x02}, {0x380b, 0x58}, {0x380c, 0x06}, {0x380d, 
>> 0xac},
>> +	{0x380e, 0x02}, {0x380f, 0x84}, {0x3811, 0x04}, {0x3813, 
>> 0x04},
>> +	{0x3814, 0x31}, {0x3815, 0x31}, {0x3820, 0xc0}, {0x4008, 
>> 0x00},
>> +	{0x4009, 0x03}, {0x4837, 0x1e}, {0x3501, 0x4e}, {0x3502, 
>> 0xe0},
>> +};
>> +
>> +static const struct reg_value 
>> ov2680_setting_30fps_720P_1280_720[] = {
>> +	{0x3086, 0x00}, {0x3808, 0x05}, {0x3809, 0x00}, {0x380a, 
>> 0x02},
>> +	{0x380b, 0xd0}, {0x380c, 0x06}, {0x380d, 0xa8}, {0x380e, 
>> 0x05},
>> +	{0x380f, 0x0e}, {0x3811, 0x08}, {0x3813, 0x06}, {0x3814, 
>> 0x11},
>> +	{0x3815, 0x11}, {0x3820, 0xc0}, {0x4008, 0x00},
>> +};
>> +
>> +static const struct reg_value 
>> ov2680_setting_30fps_UXGA_1600_1200[] = {
>> +	{0x3086, 0x00}, {0x3501, 0x4e}, {0x3502, 0xe0}, {0x3808, 
>> 0x06},
>> +	{0x3809, 0x40}, {0x380a, 0x04}, {0x380b, 0xb0}, {0x380c, 
>> 0x06},
>> +	{0x380d, 0xa8}, {0x380e, 0x05}, {0x380f, 0x0e}, {0x3811, 
>> 0x00},
>> +	{0x3813, 0x00}, {0x3814, 0x11}, {0x3815, 0x11}, {0x3820, 
>> 0xc0},
>> +	{0x4008, 0x00}, {0x4837, 0x18}
>> +};
>> +
>> +static const struct ov2680_mode_info ov2680_mode_init_data = {
>> +	"mode_quxga_800_600", OV2680_MODE_QUXGA_800_600, 800, 600,
>> +	ov2680_setting_30fps_QUXGA_800_600,
>> +	ARRAY_SIZE(ov2680_setting_30fps_QUXGA_800_600),
>> +};
>> +
>> +static const struct ov2680_mode_info
>> +ov2680_mode_data[OV2680_FRAMERATES_MAX][OV2680_MODE_MAX] = {
>
> You only have a single frame rate. Do you plan to support more?

Not for now.

>
> As the frame rate is specific to a mode rather than the other 
> way around, I
> think you should probably swap the array dimensions. You could 
> even remove
> this as frame rate selection clearly isn't implemented in the 
> driver.

I was thinking to have this more generic to add afterwards others
frame rate, but i will drop it for now.

>
>> +	{
>> +		{"mode_quxga_800_600", OV2680_MODE_QUXGA_800_600,
>> +		 800, 600, ov2680_setting_30fps_QUXGA_800_600,
>> +		 ARRAY_SIZE(ov2680_setting_30fps_QUXGA_800_600)},
>> +		{"mode_720p_1280_720", OV2680_MODE_720P_1280_720,
>> +		 1280, 720, ov2680_setting_30fps_720P_1280_720,
>> +		 ARRAY_SIZE(ov2680_setting_30fps_720P_1280_720)},
>> +		{"mode_uxga_1600_1200", 
>> OV2680_MODE_UXGA_1600_1200,
>> +		 1600, 1200, ov2680_setting_30fps_UXGA_1600_1200,
>> +		 ARRAY_SIZE(ov2680_setting_30fps_UXGA_1600_1200)},
>> +	},
>> +};
>> +
>> +static struct ov2680_dev *to_ov2680_dev(struct v4l2_subdev 
>> *sd)
>> +{
>> +	return container_of(sd, struct ov2680_dev, sd);
>> +}
>> +
>> +static struct device *ov2680_to_dev(struct ov2680_dev *sensor)
>> +{
>> +	return &sensor->i2c_client->dev;
>> +}
>> +
>> +static inline struct v4l2_subdev *ctrl_to_sd(struct v4l2_ctrl 
>> *ctrl)
>> +{
>> +	return &container_of(ctrl->handler, struct ov2680_dev,
>> +			     ctrls.handler)->sd;
>> +}
>> +
>> +static int ov2680_write_reg(struct ov2680_dev *sensor, u16 
>> reg, u8 val)
>> +{
>> +	struct i2c_client *client = sensor->i2c_client;
>> +	struct i2c_msg msg;
>> +	u8 buf[3];
>> +	int ret;
>> +
>> +	buf[0] = reg >> 8;
>> +	buf[1] = reg & 0xff;
>> +	buf[2] = val;
>> +
>> +	msg.addr = client->addr;
>> +	msg.flags = client->flags;
>> +	msg.buf = buf;
>> +	msg.len = sizeof(buf);
>> +
>> +	ret = i2c_transfer(client->adapter, &msg, 1);
>> +	if (ret < 0) {
>> +		dev_err(&client->dev, "write error: reg=0x%4x: 
>> %d\n", reg, ret);
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov2680_write_reg16(struct ov2680_dev *sensor, u16 
>> reg, u16 val)
>> +{
>> +	int ret;
>> +
>> +	ret = ov2680_write_reg(sensor, reg, val >> 8);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return ov2680_write_reg(sensor, reg + 1, val & 0xff);
>> +}
>> +
>> +static int ov2680_read_reg(struct ov2680_dev *sensor, u16 reg, 
>> u8 *val)
>> +{
>> +	struct i2c_client *client = sensor->i2c_client;
>> +	struct i2c_msg msg[2];
>> +	u8 buf[2];
>> +	int ret;
>> +
>> +	buf[0] = reg >> 8;
>> +	buf[1] = reg & 0xff;
>> +
>> +	msg[0].addr = client->addr;
>> +	msg[0].flags = client->flags;
>> +	msg[0].buf = buf;
>> +	msg[0].len = sizeof(buf);
>> +
>> +	msg[1].addr = client->addr;
>> +	msg[1].flags = client->flags | I2C_M_RD;
>> +	msg[1].buf = buf;
>> +	msg[1].len = 1;
>> +
>> +	ret = i2c_transfer(client->adapter, msg, 2);
>> +	if (ret < 0) {
>> +		dev_err(&client->dev, "read error: reg=0x%4x: 
>> %d\n", reg, ret);
>> +		return ret;
>> +	}
>> +
>> +	*val = buf[0];
>> +	return 0;
>> +}
>> +
>> +static int ov2680_read_reg16(struct ov2680_dev *sensor, u16 
>> reg, u16 *val)
>> +{
>> +	u8 hi, lo;
>> +	int ret;
>> +
>> +	ret = ov2680_read_reg(sensor, reg, &hi);
>> +	if (ret)
>> +		return ret;
>> +	ret = ov2680_read_reg(sensor, reg + 1, &lo);
>> +	if (ret)
>> +		return ret;
>
> You shouldn't implement accessing 16-bit registers like this 
> neither for
> reading or writing unless there's a specific reason to do so. 
> Just access
> the high and low octet in the same transaction.

Agree.

>
>> +
>> +	*val = ((u16)hi << 8) | (u16)lo;
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov2680_mod_reg(struct ov2680_dev *sensor, u16 reg, 
>> u8 mask, u8 val)
>> +{
>> +	u8 readval;
>> +	int ret;
>> +
>> +	ret = ov2680_read_reg(sensor, reg, &readval);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	readval &= ~mask;
>> +	val &= mask;
>> +	val |= readval;
>> +
>> +	return ov2680_write_reg(sensor, reg, val);
>> +}
>> +
>> +static int ov2680_load_regs(struct ov2680_dev *sensor,
>> +			    const struct ov2680_mode_info *mode)
>> +{
>> +	const struct reg_value *regs = mode->reg_data;
>> +	unsigned int i;
>> +	int ret = 0;
>> +	u16 reg_addr;
>> +	u8 val;
>> +
>> +	for (i = 0; i < mode->reg_data_size; ++i, ++regs) {
>> +		reg_addr = regs->reg_addr;
>> +		val = regs->val;
>> +
>> +		ret = ov2680_write_reg(sensor, reg_addr, val);
>> +		if (ret)
>> +			break;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static void ov2680_power_up(struct ov2680_dev *sensor)
>> +{
>> +	if (!sensor->pwdn_gpio)
>> +		return;
>> +
>> +	gpiod_set_value(sensor->pwdn_gpio, 1);
>> +	usleep_range(5000, 10000);
>> +}
>
> Even if you're using GPIO only right now, the power up and power 
> down
> may not be executed before the corresponding power up sequence.
>
>> +
>> +static void ov2680_power_down(struct ov2680_dev *sensor)
>> +{
>> +	if (!sensor->pwdn_gpio)
>> +		return;
>> +
>> +	gpiod_set_value(sensor->pwdn_gpio, 0);
>> +	usleep_range(5000, 10000);
>> +}
>> +
>> +static int ov2680_soft_reset(struct ov2680_dev *sensor)
>> +{
>> +	struct device *dev = ov2680_to_dev(sensor);
>> +	int ret;
>> +
>> +	ret = ov2680_write_reg(sensor, OV2680_REG_SOFT_RESET, 
>> 0x01);
>> +	if (ret != 0) {
>> +		dev_err(dev, "sensor soft reset failed\n");
>> +		return ret;
>> +	}
>> +	usleep_range(1000, 2000);
>> +	return 0;
>> +}
>> +
>> +static void ov2680_reset(struct ov2680_dev *sensor)
>> +{
>> +	if (!sensor->pwdn_gpio) {
>> +		ov2680_soft_reset(sensor);
>> +		return;
>> +	}
>> +
>> +	ov2680_power_down(sensor);
>> +	ov2680_power_up(sensor);
>
> Please merge the two above functions to ov2670_enable. That 
> might be better
> called e.g. ov2670_power_on. Likewise ov2670_disable could be
> ov2670_power_off. These functions are implementing power on and 
> power off
> sequences after all.

Other than s/ov2670/ov2680/ in your comment ;), I agree and will 
merge the
power/enable sequences.

>
>> +}
>> +
>> +static int ov2680_vflip_enable(struct ov2680_dev *sensor)
>> +{
>> +	return ov2680_mod_reg(sensor, OV2680_REG_FORMAT1, BIT(2), 
>> BIT(2));
>> +}
>> +
>> +static int ov2680_vflip_disable(struct ov2680_dev *sensor)
>> +{
>> +	return ov2680_mod_reg(sensor, OV2680_REG_FORMAT1, BIT(2), 
>> 0);
>> +}
>> +
>> +static int ov2680_hflip_enable(struct ov2680_dev *sensor)
>> +{
>> +	return ov2680_mod_reg(sensor, OV2680_REG_FORMAT2, BIT(2), 
>> BIT(2));
>> +}
>> +
>> +static int ov2680_hflip_disable(struct ov2680_dev *sensor)
>> +{
>> +	return ov2680_mod_reg(sensor, OV2680_REG_FORMAT2, BIT(2), 
>> 0);
>> +}
>> +
>> +static int ov2680_test_pattern_set(struct ov2680_dev *sensor, 
>> int value)
>> +{
>> +	int ret;
>> +
>> +	if (!value)
>> +		return ov2680_mod_reg(sensor, 
>> OV2680_REG_ISP_CTRL00, BIT(7), 0);
>> +
>> +	ret = ov2680_mod_reg(sensor, OV2680_REG_ISP_CTRL00, 0x03, 
>> value - 1);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = ov2680_mod_reg(sensor, OV2680_REG_ISP_CTRL00, 
>> BIT(7), BIT(7));
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov2680_gain_set(struct ov2680_dev *sensor, bool 
>> auto_gain)
>> +{
>> +	struct ov2680_ctrls *ctrls = &sensor->ctrls;
>> +	u16 gain;
>> +	int ret;
>> +
>> +	ret = ov2680_mod_reg(sensor, OV2680_REG_R_MANUAL, BIT(1),
>> +			     auto_gain ? 0 : BIT(1));
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	if (auto_gain)
>> +		return 0;
>> +
>> +	gain = (u16)ctrls->gain->val;
>> +
>> +	ret = ov2680_write_reg16(sensor, OV2680_REG_GAIN_PK, gain 
>> & 0x7ff);
>
> I think you could just use ctrls->gain->val here.
>
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov2680_gain_get(struct ov2680_dev *sensor)
>> +{
>> +	u16 gain;
>> +	int ret;
>> +
>> +	ret = ov2680_read_reg16(sensor, OV2680_REG_GAIN_PK, 
>> &gain);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return gain & 0x3ff;
>
> Why 3ff here but 7ff when setting the gain?

is 0x7ff in both.

>
>> +}
>> +
>> +static int ov2680_auto_gain_enable(struct ov2680_dev *sensor)
>> +{
>> +	return ov2680_gain_set(sensor, true);
>> +}
>> +
>> +static int ov2680_auto_gain_disable(struct ov2680_dev *sensor)
>> +{
>> +	return ov2680_gain_set(sensor, false);
>> +}
>
> Could you use ov2680_gain_set() from the caller instead? Perhaps 
> rename it
> as ov2680_autogain_set()?

Ack.

>
>> +
>> +static int ov2680_exposure_set(struct ov2680_dev *sensor, bool 
>> auto_exp)
>> +{
>> +	struct ov2680_ctrls *ctrls = &sensor->ctrls;
>> +	u32 exp;
>> +	int ret;
>> +
>> +	ret = ov2680_mod_reg(sensor, OV2680_REG_R_MANUAL, BIT(0),
>> +			     auto_exp ? 0 : BIT(0));
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	if (auto_exp)
>> +		return 0;
>> +
>> +	exp = (u32)ctrls->exposure->val;
>> +	exp <<= 4;
>> +
>> +	ret = ov2680_write_reg(sensor, OV2680_REG_EXPOSURE_PK_LOW, 
>> exp & 0xf0);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = ov2680_write_reg(sensor, OV2680_REG_EXPOSURE_PK_MED,
>> +			       (exp >> 8) & 0xff);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return ov2680_write_reg(sensor, 
>> OV2680_REG_EXPOSURE_PK_HIGH,
>> +				(exp >> 16) & 0x0f);
>
> I'd suppose you'll get interesting effects if the exposure 
> latching point
> happens to be in between these updates.
>
> A single read would avoid that. Or is there a particular reason 
> to perform
> a read of a single register in three transactions?

No, I will implement a single transaction.

>
>> +}
>> +
>> +static int ov2680_exposure_get(struct ov2680_dev *sensor)
>> +{
>> +	int exp, ret;
>> +	u8 temp;
>> +
>> +	ret = ov2680_read_reg(sensor, OV2680_REG_EXPOSURE_PK_HIGH, 
>> &temp);
>> +	if (ret)
>> +		return ret;
>> +	exp = ((int)temp & 0x0f) << 16;
>> +
>> +	ret = ov2680_read_reg(sensor, OV2680_REG_EXPOSURE_PK_MED, 
>> &temp);
>> +	if (ret)
>> +		return ret;
>> +	exp |= ((int)temp & 0xff) << 8;
>> +
>> +	ret = ov2680_read_reg(sensor, OV2680_REG_EXPOSURE_PK_LOW, 
>> &temp);
>> +	if (ret)
>> +		return ret;
>> +	exp |= ((int)temp & 0xf0);
>> +
>> +	return exp >> 4;
>> +}
>> +
>> +static int ov2680_auto_exposure_enable(struct ov2680_dev 
>> *sensor)
>> +{
>> +	return ov2680_exposure_set(sensor, true);
>> +}
>> +
>> +static int ov2680_auto_exposure_disable(struct ov2680_dev 
>> *sensor)
>> +{
>> +	return ov2680_exposure_set(sensor, false);
>> +}
>
> Same for exposure.

ditto.

>
>> +
>> +static int ov2680_stream_enable(struct ov2680_dev *sensor)
>> +{
>> +	return ov2680_write_reg(sensor, OV2680_REG_STREAM_CTRL, 
>> 1);
>> +}
>> +
>> +static int ov2680_stream_disable(struct ov2680_dev *sensor)
>> +{
>> +	return ov2680_write_reg(sensor, OV2680_REG_STREAM_CTRL, 
>> 0);
>> +}
>> +
>> +static int ov2680_mode_set_direct(struct ov2680_dev *sensor)
>> +{
>> +	int ret;
>> +
>> +	if (!sensor->current_mode->reg_data)
>> +		return -EINVAL;
>> +
>> +	ret = ov2680_load_regs(sensor, sensor->current_mode);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov2680_mode_set(struct ov2680_dev *sensor)
>> +{
>> +	int ret;
>> +
>> +	ret = ov2680_auto_gain_disable(sensor);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = ov2680_auto_exposure_disable(sensor);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = ov2680_mode_set_direct(sensor);
>
> ov2680_mode_set_direct() is only used here. How about moving the 
> contents
> here?

LGTM

>
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = ov2680_auto_gain_enable(sensor);
>
> This should be based on the control value, shouldn't it?

Yup.

>
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = ov2680_auto_exposure_enable(sensor);
>> +	if (ret < 0)
>> +		return ret;
>
> As well as the exposure.

ditto.

>
>> +
>> +	sensor->mode_pending_changes = false;
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov2680_mode_restore(struct ov2680_dev *sensor)
>> +{
>> +	int ret;
>> +
>> +	ret = ov2680_load_regs(sensor, &ov2680_mode_init_data);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	return ov2680_mode_set(sensor);
>> +}
>> +
>> +static int ov2680_disable(struct ov2680_dev *sensor)
>> +{
>> +	if (!sensor->is_enabled)
>> +		return 0;
>> +
>> +	clk_disable_unprepare(sensor->xvclk);
>> +	ov2680_power_down(sensor);
>> +	sensor->is_enabled = false;
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov2680_enable(struct ov2680_dev *sensor)
>> +{
>> +	struct device *dev = ov2680_to_dev(sensor);
>> +	int ret;
>> +
>> +	if (sensor->is_enabled)
>> +		return 0;
>> +
>> +	ov2680_reset(sensor);
>> +
>> +	ret = clk_prepare_enable(sensor->xvclk);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = ov2680_mode_restore(sensor);
>> +	if (ret < 0)
>> +		goto disable;
>> +
>> +	sensor->is_enabled = true;
>> +
>> +	/* Set clock lane into LP-11 state */
>> +	ov2680_stream_enable(sensor);
>> +	usleep_range(1000, 2000);
>> +	ov2680_stream_disable(sensor);
>> +
>> +	return 0;
>> +
>> +disable:
>> +	dev_err(dev, "failed to enable sensor: %d\n", ret);
>> +	ov2680_disable(sensor);
>> +
>> +	return ret;
>> +}
>> +
>> +static int ov2680_s_power(struct v4l2_subdev *sd, int on)
>> +{
>> +	struct ov2680_dev *sensor = to_ov2680_dev(sd);
>> +	int ret = 0;
>> +
>> +	mutex_lock(&sensor->lock);
>> +
>> +	if (on)
>> +		ret = ov2680_enable(sensor);
>> +	else
>> +		ret = ov2680_disable(sensor);
>> +
>> +	mutex_unlock(&sensor->lock);
>> +
>> +	if (on && ret == 0) {
>> +		ret = 
>> v4l2_ctrl_handler_setup(&sensor->ctrls.handler);
>> +		if (ret < 0)
>> +			return ret;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static int ov2680_g_frame_interval(struct v4l2_subdev *sd,
>> +				   struct 
>> v4l2_subdev_frame_interval *fi)
>> +{
>> +	struct ov2680_dev *sensor = to_ov2680_dev(sd);
>> +
>> +	mutex_lock(&sensor->lock);
>> +	fi->interval = sensor->frame_interval;
>> +	mutex_unlock(&sensor->lock);
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov2680_s_frame_interval(struct v4l2_subdev *sd,
>> +				   struct 
>> v4l2_subdev_frame_interval *fi)
>> +{
>> +	struct ov2680_dev *sensor = to_ov2680_dev(sd);
>> +
>> +	if (fi->interval.denominator != 
>> sensor->frame_interval.denominator ||
>> +	    fi->interval.numerator != 
>> sensor->frame_interval.numerator)
>
> You only support 30 frames per second. Even then, you need to 
> modify the
> request to match with what the driver supports, so the 
> implementation can
> be the same than for g_frame_interval.

Ack.

>
>> +		return -EINVAL;
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov2680_s_stream(struct v4l2_subdev *sd, int enable)
>> +{
>> +	struct ov2680_dev *sensor = to_ov2680_dev(sd);
>> +	int ret = 0;
>> +
>> +	mutex_lock(&sensor->lock);
>> +
>> +	if (sensor->is_streaming == !!enable)
>> +		goto unlock;
>> +
>> +	if (enable && sensor->mode_pending_changes) {
>> +		ret = ov2680_mode_set(sensor);
>> +		if (ret < 0)
>> +			goto unlock;
>> +	}
>> +
>> +	if (enable)
>> +		ret = ov2680_stream_enable(sensor);
>> +	else
>> +		ret = ov2680_stream_disable(sensor);
>> +
>> +	sensor->is_streaming = !!enable;
>> +
>> +unlock:
>> +	mutex_unlock(&sensor->lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static int ov2680_enum_mbus_code(struct v4l2_subdev *sd,
>> +				 struct v4l2_subdev_pad_config 
>> *cfg,
>> +				 struct v4l2_subdev_mbus_code_enum 
>> *code)
>> +{
>> +	struct ov2680_dev *sensor = to_ov2680_dev(sd);
>> +
>> +	if (code->pad != 0 || code->index != 0)
>> +		return -EINVAL;
>> +
>> +	code->code = sensor->fmt.code;
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov2680_get_fmt(struct v4l2_subdev *sd,
>> +			  struct v4l2_subdev_pad_config *cfg,
>> +			  struct v4l2_subdev_format *format)
>> +{
>> +	struct ov2680_dev *sensor = to_ov2680_dev(sd);
>> +	struct v4l2_mbus_framefmt *fmt;
>> +
>> +	if (format->pad != 0)
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&sensor->lock);
>> +
>> +	if (format->which == V4L2_SUBDEV_FORMAT_TRY)
>> +		fmt = v4l2_subdev_get_try_format(&sensor->sd, cfg, 
>> format->pad);
>> +	else
>> +		fmt = &sensor->fmt;
>> +
>> +	format->format = *fmt;
>> +
>> +	mutex_unlock(&sensor->lock);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct ov2680_mode_info *
>> +ov2680_mode_find(struct ov2680_dev *sensor, enum 
>> ov2680_frame_rate fps,
>> +		 int width, int height)
>> +{
>> +	const struct ov2680_mode_info *mode = NULL;
>> +	bool mode_found = false;
>> +	int i;
>> +
>> +	for (i = OV2680_MODE_MAX - 1; i >= 0; i--) {
>> +		mode = &ov2680_mode_data[fps][i];
>> +
>> +		if (!mode->reg_data)
>> +			continue;
>> +
>> +		if (mode->width == width && mode->height == 
>> height) {
>
> The closest match would be better. Can you use this? I'm 
> planning to send a
> pull request on the set soon.
>
> <URL:https://patchwork.linuxtv.org/patch/46975/>

Yeah, I saw your patch in list already, I was waiting to be 
pulled. I
will use it, makes sense.

>
>> +			mode_found = true;
>> +			break;
>> +		}
>> +	}
>> +
>> +	return mode_found ? mode : NULL;
>> +}
>> +
>> +static int ov2680_set_fmt(struct v4l2_subdev *sd,
>> +			  struct v4l2_subdev_pad_config *cfg,
>> +			  struct v4l2_subdev_format *format)
>> +{
>> +	struct ov2680_dev *sensor = to_ov2680_dev(sd);
>> +	struct v4l2_mbus_framefmt *fmt = &format->format;
>> +	const struct ov2680_mode_info *mode;
>> +	int ret = 0;
>> +
>> +	if (format->pad != 0)
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&sensor->lock);
>> +
>> +	if (sensor->is_streaming) {
>> +		ret = -EBUSY;
>> +		goto unlock;
>> +	}
>> +
>> +	mode = ov2680_mode_find(sensor, sensor->current_fps, 
>> fmt->width,
>> +				fmt->height);
>> +	if (!mode) {
>> +		ret = -EINVAL;
>> +		goto unlock;
>> +	}
>> +
>> +	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
>> +		fmt = v4l2_subdev_get_try_format(sd, cfg, 0);
>> +
>> +		*fmt = format->format;
>> +		goto unlock;
>> +	}
>> +
>> +	fmt->width = mode->width;
>> +	fmt->height = mode->height;
>> +	fmt->code = sensor->fmt.code;
>> +	fmt->colorspace = sensor->fmt.colorspace;
>> +
>> +	sensor->current_mode = mode;
>> +	sensor->fmt = format->format;
>> +	sensor->mode_pending_changes = true;
>> +
>> +unlock:
>> +	mutex_unlock(&sensor->lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static int ov2680_enum_frame_size(struct v4l2_subdev *sd,
>> +				  struct v4l2_subdev_pad_config 
>> *cfg,
>> +				  struct 
>> v4l2_subdev_frame_size_enum *fse)
>> +{
>> +	int index = fse->index;
>> +
>> +	if (index >= OV2680_MODE_MAX)
>> +		return -EINVAL;
>> +
>> +	fse->min_width = ov2680_mode_data[0][index].width;
>> +	fse->min_height = ov2680_mode_data[0][index].height;
>> +	fse->max_width = ov2680_mode_data[0][index].width;
>> +	fse->max_height = ov2680_mode_data[0][index].height;
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov2680_enum_frame_interval(struct v4l2_subdev *sd,
>> +			      struct v4l2_subdev_pad_config *cfg,
>> +			      struct 
>> v4l2_subdev_frame_interval_enum *fie)
>> +{
>> +	struct ov2680_dev *sensor = to_ov2680_dev(sd);
>> +	const struct ov2680_mode_info *mode;
>> +	struct v4l2_fract tpf;
>> +
>> +	if (fie->index >= OV2680_FRAMERATES_MAX)
>> +		return -EINVAL;
>> +
>> +	tpf.denominator = ov2680_framerates[fie->index];
>> +	tpf.numerator = 1;
>> +
>> +	fie->interval = tpf;
>> +
>> +	mode = ov2680_mode_find(sensor, sensor->current_fps, 
>> fie->width,
>> +				fie->height);
>> +
>> +	return mode ? 0 : -EINVAL;
>> +}
>> +
>> +static int ov2680_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
>> +{
>> +	struct v4l2_subdev *sd = ctrl_to_sd(ctrl);
>> +	struct ov2680_dev *sensor = to_ov2680_dev(sd);
>> +	int val;
>> +
>> +	if (!sensor->is_enabled)
>> +		return 0;
>> +
>> +	switch (ctrl->id) {
>> +	case V4L2_CID_AUTOGAIN:
>> +		if (!ctrl->val)
>> +			return 0;
>> +		val = ov2680_gain_get(sensor);
>> +		if (val < 0)
>> +			return val;
>> +		sensor->ctrls.gain->val = val;
>> +		break;
>> +	case V4L2_CID_EXPOSURE_AUTO:
>> +		if (ctrl->val == V4L2_EXPOSURE_MANUAL)
>> +			return 0;
>> +		val = ov2680_exposure_get(sensor);
>> +		if (val < 0)
>> +			return val;
>> +		sensor->ctrls.exposure->val = val;
>> +		break;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov2680_s_ctrl(struct v4l2_ctrl *ctrl)
>> +{
>> +	struct v4l2_subdev *sd = ctrl_to_sd(ctrl);
>> +	struct ov2680_dev *sensor = to_ov2680_dev(sd);
>> +
>> +	if (!sensor->is_enabled)
>> +		return 0;
>> +
>> +	switch (ctrl->id) {
>> +	case V4L2_CID_AUTOGAIN:
>> +		return ov2680_gain_set(sensor, !!ctrl->val);
>> +	case V4L2_CID_EXPOSURE_AUTO:
>> +		return ov2680_exposure_set(sensor, !!ctrl->val);
>> +	case V4L2_CID_VFLIP:
>> +		if (ctrl->val)
>> +			return ov2680_vflip_enable(sensor);
>> +		else
>> +			return ov2680_vflip_disable(sensor);
>> +	case V4L2_CID_HFLIP:
>> +		if (ctrl->val)
>> +			return ov2680_hflip_enable(sensor);
>> +		else
>> +			return ov2680_hflip_disable(sensor);
>> +	case V4L2_CID_TEST_PATTERN:
>> +		return ov2680_test_pattern_set(sensor, ctrl->val);
>> +	default:
>> +		break;
>> +	}
>> +
>> +	return -EINVAL;
>> +}
>> +
>> +static const struct v4l2_ctrl_ops ov2680_ctrl_ops = {
>> +	.g_volatile_ctrl = ov2680_g_volatile_ctrl,
>> +	.s_ctrl = ov2680_s_ctrl,
>> +};
>> +
>> +static const struct v4l2_subdev_core_ops ov2680_core_ops = {
>> +	.s_power = ov2680_s_power,
>> +};
>> +
>> +static const struct v4l2_subdev_video_ops ov2680_video_ops = {
>> +	.g_frame_interval	= ov2680_g_frame_interval,
>> +	.s_frame_interval	= ov2680_s_frame_interval,
>> +	.s_stream		= ov2680_s_stream,
>> +};
>> +
>> +static const struct v4l2_subdev_pad_ops ov2680_pad_ops = {
>> +	.enum_mbus_code		= ov2680_enum_mbus_code,
>> +	.get_fmt		= ov2680_get_fmt,
>> +	.set_fmt		= ov2680_set_fmt,
>> +	.enum_frame_size	= ov2680_enum_frame_size,
>> +	.enum_frame_interval	= ov2680_enum_frame_interval,
>> +};
>> +
>> +static const struct v4l2_subdev_ops ov2680_subdev_ops = {
>> +	.core	= &ov2680_core_ops,
>> +	.video	= &ov2680_video_ops,
>> +	.pad	= &ov2680_pad_ops,
>> +};
>> +
>> +static int ov2680_mode_init(struct ov2680_dev *sensor)
>> +{
>> +	const struct ov2680_mode_info *init_mode;
>> +
>> +	/* set initial mode */
>> +	sensor->fmt.code = MEDIA_BUS_FMT_SBGGR10_1X10;
>> +	sensor->fmt.width = 800;
>> +	sensor->fmt.height = 600;
>> +	sensor->fmt.field = V4L2_FIELD_NONE;
>> +	sensor->fmt.colorspace = V4L2_COLORSPACE_SRGB;
>> +
>> +	sensor->frame_interval.denominator = 
>> ov2680_framerates[OV2680_30_FPS];
>> +	sensor->frame_interval.numerator = 1;
>> +
>> +	sensor->current_fps = OV2680_30_FPS;
>> +	init_mode = 
>> &ov2680_mode_data[OV2680_30_FPS][OV2680_MODE_QUXGA_800_600];
>> +
>> +	sensor->current_mode = init_mode;
>> +
>> +	sensor->mode_pending_changes = true;
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov2680_v4l2_init(struct ov2680_dev *sensor)
>> +{
>> +	const struct v4l2_ctrl_ops *ops = &ov2680_ctrl_ops;
>> +	struct ov2680_ctrls *ctrls = &sensor->ctrls;
>> +	struct v4l2_ctrl_handler *hdl = &ctrls->handler;
>> +	int ret = 0;
>> +
>> +	v4l2_i2c_subdev_init(&sensor->sd, sensor->i2c_client,
>> +			     &ov2680_subdev_ops);
>> +
>> +	sensor->sd.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
>> +	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
>> +	sensor->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
>> +
>> +	ret = media_entity_pads_init(&sensor->sd.entity, 1, 
>> &sensor->pad);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	v4l2_ctrl_handler_init(hdl, 32);
>> +
>> +	hdl->lock = &sensor->lock;
>> +
>> +	ctrls->vflip = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_VFLIP, 
>> 0, 1, 1, 0);
>> +	ctrls->hflip = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_HFLIP, 
>> 0, 1, 1, 0);
>> +
>> +	ctrls->test_pattern = v4l2_ctrl_new_std_menu_items(hdl,
>> +					&ov2680_ctrl_ops,
>> +					V4L2_CID_TEST_PATTERN,
>> + 
>> ARRAY_SIZE(test_pattern_menu) - 1,
>> +					0, 0, test_pattern_menu);
>> +
>> +	ctrls->auto_exp = v4l2_ctrl_new_std_menu(hdl, ops,
>> + 
>> V4L2_CID_EXPOSURE_AUTO,
>> + 
>> V4L2_EXPOSURE_MANUAL, 0,
>> + 
>> V4L2_EXPOSURE_AUTO);
>> +
>> +	ctrls->exposure = v4l2_ctrl_new_std(hdl, ops, 
>> V4L2_CID_EXPOSURE,
>> +					    0, 32767, 1, 0);
>> +
>> +	ctrls->auto_gain = v4l2_ctrl_new_std(hdl, ops, 
>> V4L2_CID_AUTOGAIN,
>> +					     0, 1, 1, 1);
>> +	ctrls->gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_GAIN, 
>> 0, 2047, 1, 0);
>> +
>> +	ctrls->gain->flags |= V4L2_CTRL_FLAG_VOLATILE;
>> +	ctrls->exposure->flags |= V4L2_CTRL_FLAG_VOLATILE;
>
> v4l2_ctrl_new_std() may return NULL. Please check gain and 
> exposure are
> non-NULL before dereferencing them. The error handling seems 
> fine
> otherwise.

Ack.

>
>> +
>> +	v4l2_ctrl_auto_cluster(2, &ctrls->auto_gain, 1, true);
>> +	v4l2_ctrl_auto_cluster(2, &ctrls->auto_exp, 1, true);
>> +
>> +	sensor->sd.ctrl_handler = hdl;
>> +
>> +	ret = v4l2_async_register_subdev(&sensor->sd);
>> +	if (ret < 0) {
>> +		media_entity_cleanup(&sensor->sd.entity);
>> +		v4l2_ctrl_handler_free(hdl);
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static int ov2680_check_id(struct ov2680_dev *sensor)
>> +{
>> +	struct device *dev = ov2680_to_dev(sensor);
>> +	u8 chip_id_high;
>> +	u8 chip_id_low;
>> +	int ret;
>> +
>> +	ov2680_reset(sensor);
>
> I don't have the sensor datasheet, but practically everywhere 
> you'll need
> execute the power up sequence before accessing the sensor 
> registers.

Agree.

>
>> +
>> +	ret = ov2680_read_reg(sensor, OV2680_REG_CHIP_ID_HIGH, 
>> &chip_id_high);
>> +	if (ret < 0) {
>> +		dev_err(dev, "failed to read chip id high\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	ret = ov2680_read_reg(sensor, OV2680_REG_CHIP_ID_LOW, 
>> &chip_id_low);
>> +	if (ret < 0) {
>> +		dev_err(dev, "failed to read chip id low\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	if (chip_id_high != OV2680_CHIP_ID_HIGH ||
>> +	    chip_id_low != OV2680_CHIP_ID_LOW) {
>> +		dev_err(dev, "chip id: 0x%02x%02x does not match 
>> expected: 0x%02x%02x\n",
>> +			chip_id_high, chip_id_low, 
>> OV2680_CHIP_ID_HIGH,
>> +			OV2680_CHIP_ID_LOW);
>> +		return -ENODEV;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov2860_parse_dt(struct ov2680_dev *sensor)
>> +{
>> +	struct device *dev = ov2680_to_dev(sensor);
>> +	int ret;
>> +
>> +	sensor->pwdn_gpio = devm_gpiod_get_optional(dev, 
>> "powerdown",
>> + 
>> GPIOD_OUT_HIGH);
>> +	ret = PTR_ERR_OR_ZERO(sensor->pwdn_gpio);
>> +	if (ret < 0) {
>> +		dev_dbg(dev, "error while getting powerdown gpio: 
>> %d\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	sensor->xvclk = devm_clk_get(dev, "xvclk");
>> +	if (IS_ERR(sensor->xvclk)) {
>> +		dev_err(dev, "xvclk clock missing or invalid\n");
>> +		return PTR_ERR(sensor->xvclk);
>> +	}
>> +
>> +	sensor->xvclk_freq = clk_get_rate(sensor->xvclk);
>> +	if (sensor->xvclk_freq < OV2680_XVCLK_MIN ||
>> +	    sensor->xvclk_freq > OV2680_XVCLK_MAX) {
>
> I believe the register lists are intended for a particular 
> frequency and do
> not work for others. What is this frequency?

24MHz

I will prepare v2 with the above reviews. Once again many thanks.

---
Cheers,
	Rui


>
>> +		dev_err(dev, "xvclk frequency out of range: %d 
>> Hz\n",
>> +			sensor->xvclk_freq);
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov2680_probe(struct i2c_client *client,
>> +			const struct i2c_device_id *id)
>> +{
>> +	struct device *dev = &client->dev;
>> +	struct ov2680_dev *sensor;
>> +	int ret;
>> +
>> +	sensor = devm_kzalloc(dev, sizeof(*sensor), GFP_KERNEL);
>> +	if (!sensor)
>> +		return -ENOMEM;
>> +
>> +	sensor->i2c_client = client;
>> +
>> +	ret = ov2860_parse_dt(sensor);
>> +	if (ret < 0)
>> +		return -EINVAL;
>> +
>> +	ret = ov2680_check_id(sensor);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = ov2680_mode_init(sensor);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	mutex_init(&sensor->lock);
>> +
>> +	ret = ov2680_v4l2_init(sensor);
>> +	if (ret < 0)
>> +		goto lock_destroy;
>> +
>> +	dev_info(dev, "ov2680 init correctly\n");
>> +
>> +	return 0;
>> +
>> +lock_destroy:
>> +	mutex_destroy(&sensor->lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static int ov2680_remove(struct i2c_client *client)
>> +{
>> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
>> +	struct ov2680_dev *sensor = to_ov2680_dev(sd);
>> +
>> +	v4l2_async_unregister_subdev(&sensor->sd);
>> +	mutex_destroy(&sensor->lock);
>> +	media_entity_cleanup(&sensor->sd.entity);
>> +	v4l2_ctrl_handler_free(&sensor->ctrls.handler);
>> +
>> +	return 0;
>> +}
>> +
>> +static int __maybe_unused ov2680_suspend(struct device *dev)
>> +{
>> +	struct i2c_client *client = to_i2c_client(dev);
>> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
>> +	struct ov2680_dev *sensor = to_ov2680_dev(sd);
>> +
>> +	if (sensor->is_streaming)
>> +		ov2680_stream_disable(sensor);
>> +
>> +	return 0;
>> +}
>> +
>> +static int __maybe_unused ov2680_resume(struct device *dev)
>> +{
>> +	struct i2c_client *client = to_i2c_client(dev);
>> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
>> +	struct ov2680_dev *sensor = to_ov2680_dev(sd);
>> +	int ret;
>> +
>> +	if (sensor->is_streaming) {
>> +		ret = ov2680_stream_enable(sensor);
>> +		if (ret < 0)
>> +			goto stream_disable;
>> +	}
>> +
>> +	return 0;
>> +
>> +stream_disable:
>> +	ov2680_stream_disable(sensor);
>> +	sensor->is_streaming = false;
>> +
>> +	return ret;
>> +}
>> +
>> +static const struct dev_pm_ops ov2680_pm_ops = {
>> +	SET_SYSTEM_SLEEP_PM_OPS(ov2680_suspend, ov2680_resume)
>> +};
>> +
>> +static const struct i2c_device_id ov2680_id[] = {
>> +	{"ov2680", 0},
>> +	{ },
>> +};
>> +MODULE_DEVICE_TABLE(i2c, ov2680_id);
>> +
>> +static const struct of_device_id ov2680_dt_ids[] = {
>> +	{ .compatible = "ovti,ov2680" },
>> +	{ /* sentinel */ },
>> +};
>> +MODULE_DEVICE_TABLE(of, ov2680_dt_ids);
>> +
>> +static struct i2c_driver ov2680_i2c_driver = {
>> +	.driver = {
>> +		.name  = "ovti,ov2680",
>> +		.of_match_table	= ov2680_dt_ids,
>> +	},
>> +	.id_table = ov2680_id,
>> +	.probe    = ov2680_probe,
>> +	.remove   = ov2680_remove,
>> +};
>> +module_i2c_driver(ov2680_i2c_driver);
>> +
>> +MODULE_AUTHOR("Rui Miguel Silva <rui.silva@linaro.org>");
>> +MODULE_DESCRIPTION("OV2680 CMOS Image Sensor driver");
>> +MODULE_LICENSE("GPL v2");
