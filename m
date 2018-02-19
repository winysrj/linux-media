Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:36852 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753012AbeBSRXv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 12:23:51 -0500
Received: by mail-wr0-f171.google.com with SMTP id u15so10443874wrg.3
        for <linux-media@vger.kernel.org>; Mon, 19 Feb 2018 09:23:50 -0800 (PST)
Subject: Re: [PATCH 2/2] media: Add a driver for the ov7251 camera sensor
To: jacopo mondi <jacopo@jmondi.org>, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1518080018-10403-1-git-send-email-todor.tomov@linaro.org>
 <1518080018-10403-2-git-send-email-todor.tomov@linaro.org>
 <20180216100500.GB14911@w540>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <249955f0-b8a0-dd4d-5c44-65ab2ff930e6@linaro.org>
Date: Mon, 19 Feb 2018 19:23:46 +0200
MIME-Version: 1.0
In-Reply-To: <20180216100500.GB14911@w540>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On 16.02.2018 12:05, jacopo mondi wrote:
> Hi Todor,
>     thanks for the patch.
> 
> Is the datsheet for this sensor public? I failed to find any reference
> to it online, am I wrong?

Thank you for the review!
The datasheet is not public.

> 
> On Thu, Feb 08, 2018 at 10:53:38AM +0200, Todor Tomov wrote:
>> The ov7251 sensor is a 1/7.5-Inch B&W VGA (640x480) CMOS Digital Image
>> Sensor from Omnivision.
>>
>> The driver supports the following modes:
>> - 640x480 30fps
>> - 640x480 60fps
>> - 640x480 90fps
>>
>> Output format is MIPI RAW 10.
>>
>> The driver supports configuration via user controls for:
>> - exposure and gain;
>> - horizontal and vertical flip;
>> - test pattern.
>>
>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>> ---
>>  drivers/media/i2c/Kconfig  |   13 +
>>  drivers/media/i2c/Makefile |    1 +
>>  drivers/media/i2c/ov7251.c | 1523 ++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 1537 insertions(+)
>>  create mode 100644 drivers/media/i2c/ov7251.c
>>
>> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
>> index 9f18cd2..bfa9aab 100644
>> --- a/drivers/media/i2c/Kconfig
>> +++ b/drivers/media/i2c/Kconfig
>> @@ -645,6 +645,19 @@ config VIDEO_OV5670
>>  	  To compile this driver as a module, choose M here: the
>>  	  module will be called ov5670.
>>
>> +config VIDEO_OV7251
>> +	tristate "OmniVision OV7251 sensor support"
>> +	depends on OF
>> +	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
>> +	depends on MEDIA_CAMERA_SUPPORT
>> +	select V4L2_FWNODE
>> +	---help---
>> +	  This is a Video4Linux2 sensor-level driver for the OmniVision
>> +	  OV7251 camera.
>> +
>> +	  To compile this driver as a module, choose M here: the
>> +	  module will be called ov7251.
>> +
>>  config VIDEO_OV7640
>>  	tristate "OmniVision OV7640 sensor support"
>>  	depends on I2C && VIDEO_V4L2
>> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
>> index c0f94cd..be6b3d3 100644
>> --- a/drivers/media/i2c/Makefile
>> +++ b/drivers/media/i2c/Makefile
>> @@ -66,6 +66,7 @@ obj-$(CONFIG_VIDEO_OV5645) += ov5645.o
>>  obj-$(CONFIG_VIDEO_OV5647) += ov5647.o
>>  obj-$(CONFIG_VIDEO_OV5670) += ov5670.o
>>  obj-$(CONFIG_VIDEO_OV6650) += ov6650.o
>> +obj-$(CONFIG_VIDEO_OV7251) += ov7251.o
>>  obj-$(CONFIG_VIDEO_OV7640) += ov7640.o
>>  obj-$(CONFIG_VIDEO_OV7670) += ov7670.o
>>  obj-$(CONFIG_VIDEO_OV7740) += ov7740.o
>> diff --git a/drivers/media/i2c/ov7251.c b/drivers/media/i2c/ov7251.c
>> new file mode 100644
>> index 0000000..f217177
>> --- /dev/null
>> +++ b/drivers/media/i2c/ov7251.c
>> @@ -0,0 +1,1523 @@
>> +/*
>> + * Driver for the OV7251 camera sensor.
>> + *
>> + * Copyright (c) 2017-2018, The Linux Foundation. All rights reserved.
>> + * Copyright (c) 2017-2018, Linaro Ltd.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
> 
> Please use SPDX identifiers instead of the license text
> 
> // SPDX-License-Identifier: GPL-2.0
> 

Ok.

>> +
>> +#include <linux/bitops.h>
>> +#include <linux/clk.h>
>> +#include <linux/delay.h>
>> +#include <linux/device.h>
>> +#include <linux/gpio/consumer.h>
>> +#include <linux/i2c.h>
>> +#include <linux/init.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/of_graph.h>
>> +#include <linux/regulator/consumer.h>
>> +#include <linux/slab.h>
>> +#include <linux/types.h>
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-fwnode.h>
>> +#include <media/v4l2-subdev.h>
>> +
>> +#define OV7251_VOLTAGE_ANALOG               2800000
>> +#define OV7251_VOLTAGE_DIGITAL_CORE         1500000
>> +#define OV7251_VOLTAGE_DIGITAL_IO           1800000
>> +
>> +#define OV7251_SC_MODE_SELECT		0x0100
>> +#define OV7251_SC_MODE_SELECT_SW_STANDBY	0x0
>> +#define OV7251_SC_MODE_SELECT_STREAMING		0x1
>> +
>> +#define OV7251_CHIP_ID_HIGH		0x300a
>> +#define		OV7251_CHIP_ID_HIGH_BYTE	0x77
>> +#define OV7251_CHIP_ID_LOW		0x300b
>> +#define		OV7251_CHIP_ID_LOW_BYTE		0x50
>> +#define OV7251_SC_GP_IO_IN1		0x3029
>> +#define OV7251_AEC_EXPO_0		0x3500
>> +#define OV7251_AEC_EXPO_1		0x3501
>> +#define OV7251_AEC_EXPO_2		0x3502
>> +#define OV7251_AEC_AGC_ADJ_0		0x350a
>> +#define OV7251_AEC_AGC_ADJ_1		0x350b
>> +#define OV7251_TIMING_FORMAT1		0x3820
>> +#define		OV7251_SENSOR_VFLIP		BIT(2)
>> +#define OV7251_TIMING_FORMAT2		0x3821
>> +#define		OV7251_SENSOR_MIRROR		BIT(2)
>> +#define OV7251_PRE_ISP_00		0x5e00
>> +#define		OV7251_TEST_PATTERN_BAR_ENABLE	BIT(7)
> 
> Are those tabs between the define and the macro name there by purpose?

Yes, but it will be better to include the register name instead
as you suggest, I'll do it.

> 
> If they are bits in the register address defined above them, wouldn't
> it be better to capture there in the name?
> 
> Eg.
> OV7251_TIMING_FMT1              0x3820
> OV7251_TIMING_FMT1_VFLIP        BIT(2)
> 
>> +
>> +struct reg_value {
>> +	u16 reg;
>> +	u8 val;
>> +};
>> +
>> +struct ov7251_mode_info {
>> +	u32 width;
>> +	u32 height;
>> +	const struct reg_value *data;
>> +	u32 data_size;
>> +	u32 pixel_clock;
>> +	u32 link_freq;
>> +	u16 exposure_max;
>> +	u16 exposure_def;
>> +	struct v4l2_fract timeperframe;
>> +};
>> +
>> +struct ov7251 {
>> +	struct i2c_client *i2c_client;
>> +	struct device *dev;
>> +	struct v4l2_subdev sd;
>> +	struct media_pad pad;
>> +	struct v4l2_fwnode_endpoint ep;
>> +	struct v4l2_mbus_framefmt fmt;
>> +	struct v4l2_rect crop;
>> +	struct clk *xclk;
>> +
>> +	struct regulator *io_regulator;
>> +	struct regulator *core_regulator;
>> +	struct regulator *analog_regulator;
>> +
>> +	const struct ov7251_mode_info *current_mode;
>> +
>> +	struct v4l2_ctrl_handler ctrls;
>> +	struct v4l2_ctrl *pixel_clock;
>> +	struct v4l2_ctrl *link_freq;
>> +	struct v4l2_ctrl *exposure;
>> +	struct v4l2_ctrl *gain;
>> +
>> +	/* Cached register values */
>> +	u8 aec_pk_manual;
>> +	u8 pre_isp_00;
>> +	u8 timing_format1;
>> +	u8 timing_format2;
>> +
>> +	struct mutex power_lock; /* lock to protect power state */
>> +	int power_count;
>> +
>> +	struct gpio_desc *enable_gpio;
>> +};
>> +
>> +static inline struct ov7251 *to_ov7251(struct v4l2_subdev *sd)
>> +{
>> +	return container_of(sd, struct ov7251, sd);
>> +}
>> +
>> +static const struct reg_value ov7251_global_init_setting[] = {
>> +	{ 0x0103, 0x01 },
>> +	{ 0x303b, 0x02 },
>> +};
>> +
> 
> [snip] big tables of registers
> 
>> +
>> +static const s64 link_freq[] = {
>> +	240000000,
>> +};
>> +
>> +static const struct ov7251_mode_info ov7251_mode_info_data[] = {
>> +	{
>> +		.width = 640,
>> +		.height = 480,
>> +		.data = ov7251_setting_vga_30fps,
>> +		.data_size = ARRAY_SIZE(ov7251_setting_vga_30fps),
>> +		.pixel_clock = 48000000,
>> +		.link_freq = 0, /* an index in link_freq[] */
>> +		.exposure_max = 1704,
>> +		.exposure_def = 504,
>> +		.timeperframe = {
>> +			.numerator = 100,
>> +			.denominator = 3000
>> +		}
>> +	},
>> +	{
>> +		.width = 640,
>> +		.height = 480,
>> +		.data = ov7251_setting_vga_60fps,
>> +		.data_size = ARRAY_SIZE(ov7251_setting_vga_60fps),
>> +		.pixel_clock = 48000000,
>> +		.link_freq = 0, /* an index in link_freq[] */
>> +		.exposure_max = 840,
>> +		.exposure_def = 504,
>> +		.timeperframe = {
>> +			.numerator = 100,
>> +			.denominator = 6014
>> +		}
>> +	},
>> +	{
>> +		.width = 640,
>> +		.height = 480,
>> +		.data = ov7251_setting_vga_90fps,
>> +		.data_size = ARRAY_SIZE(ov7251_setting_vga_90fps),
>> +		.pixel_clock = 48000000,
>> +		.link_freq = 0, /* an index in link_freq[] */
>> +		.exposure_max = 552,
>> +		.exposure_def = 504,
>> +		.timeperframe = {
>> +			.numerator = 100,
>> +			.denominator = 9043
>> +		}
>> +	},
>> +};
>> +
>> +static int ov7251_regulators_enable(struct ov7251 *ov7251)
>> +{
>> +	int ret;
>> +
>> +	ret = regulator_enable(ov7251->io_regulator);
>> +	if (ret < 0) {
>> +		dev_err(ov7251->dev, "set io voltage failed\n");
>> +		return ret;
>> +	}
>> +
>> +	ret = regulator_enable(ov7251->analog_regulator);
>> +	if (ret) {
>> +		dev_err(ov7251->dev, "set analog voltage failed\n");
>> +		goto err_disable_io;
>> +	}
>> +
>> +	ret = regulator_enable(ov7251->core_regulator);
>> +	if (ret) {
>> +		dev_err(ov7251->dev, "set core voltage failed\n");
>> +		goto err_disable_analog;
>> +	}
>> +
>> +	return 0;
>> +
>> +err_disable_analog:
>> +	regulator_disable(ov7251->analog_regulator);
>> +err_disable_io:
>> +	regulator_disable(ov7251->io_regulator);
>> +
>> +	return ret;
>> +}
>> +
>> +static void ov7251_regulators_disable(struct ov7251 *ov7251)
>> +{
>> +	int ret;
>> +
>> +	ret = regulator_disable(ov7251->core_regulator);
>> +	if (ret < 0)
>> +		dev_err(ov7251->dev, "core regulator disable failed\n");
>> +
>> +	ret = regulator_disable(ov7251->analog_regulator);
>> +	if (ret < 0)
>> +		dev_err(ov7251->dev, "analog regulator disable failed\n");
>> +
>> +	ret = regulator_disable(ov7251->io_regulator);
>> +	if (ret < 0)
>> +		dev_err(ov7251->dev, "io regulator disable failed\n");
>> +}
>> +
>> +static int ov7251_write_reg(struct ov7251 *ov7251, u16 reg, u8 val)
>> +{
>> +	u8 regbuf[3];
>> +	int ret;
>> +
>> +	regbuf[0] = reg >> 8;
>> +	regbuf[1] = reg & 0xff;
>> +	regbuf[2] = val;
>> +
>> +	ret = i2c_master_send(ov7251->i2c_client, regbuf, 3);
>> +	if (ret < 0) {
>> +		dev_err(ov7251->dev, "%s: write reg error %d: reg=%x, val=%x\n",
>> +			__func__, ret, reg, val);
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov7251_read_reg(struct ov7251 *ov7251, u16 reg, u8 *val)
>> +{
>> +	u8 regbuf[2];
>> +	int ret;
>> +
>> +	regbuf[0] = reg >> 8;
>> +	regbuf[1] = reg & 0xff;
>> +
>> +	ret = i2c_master_send(ov7251->i2c_client, regbuf, 2);
>> +	if (ret < 0) {
>> +		dev_err(ov7251->dev, "%s: write reg error %d: reg=%x\n",
>> +			__func__, ret, reg);
>> +		return ret;
>> +	}
>> +
>> +	ret = i2c_master_recv(ov7251->i2c_client, val, 1);
>> +	if (ret < 0) {
>> +		dev_err(ov7251->dev, "%s: read reg error %d: reg=%x\n",
>> +			__func__, ret, reg);
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov7251_set_exposure(struct ov7251 *ov7251, s32 exposure)
>> +{
>> +	int ret;
>> +
>> +	ret = ov7251_write_reg(ov7251, OV7251_AEC_EXPO_0,
>> +			       (exposure & 0xf000) >> 12);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = ov7251_write_reg(ov7251, OV7251_AEC_EXPO_1,
>> +			       (exposure & 0x0ff0) >> 4);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	return ov7251_write_reg(ov7251, OV7251_AEC_EXPO_2,
>> +				(exposure & 0x000f) << 4);
>> +}
>> +
>> +static int ov7251_set_gain(struct ov7251 *ov7251, s32 gain)
>> +{
>> +	int ret;
>> +
>> +	ret = ov7251_write_reg(ov7251, OV7251_AEC_AGC_ADJ_0,
>> +			       (gain & 0x0300) >> 8);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	return ov7251_write_reg(ov7251, OV7251_AEC_AGC_ADJ_1, gain & 0xff);
>> +}
>> +
>> +static int ov7251_set_register_array(struct ov7251 *ov7251,
>> +				     const struct reg_value *settings,
>> +				     unsigned int num_settings)
>> +{
>> +	unsigned int i;
>> +	int ret;
>> +
>> +	for (i = 0; i < num_settings; ++i, ++settings) {
>> +		ret = ov7251_write_reg(ov7251, settings->reg, settings->val);
>> +		if (ret < 0)
>> +			return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov7251_set_power_on(struct ov7251 *ov7251)
>> +{
>> +	int ret;
>> +
>> +	ret = ov7251_regulators_enable(ov7251);
>> +	if (ret < 0) {
>> +		return ret;
>> +	}
>> +
>> +	ret = clk_prepare_enable(ov7251->xclk);
>> +	if (ret < 0) {
>> +		dev_err(ov7251->dev, "clk prepare enable failed\n");
>> +		ov7251_regulators_disable(ov7251);
>> +		return ret;
>> +	}
>> +
>> +	gpiod_set_value_cansleep(ov7251->enable_gpio, 1);
>> +
>> +	usleep_range(3000, 4000); /* 65536 / 24MHz = 2.73ms */
>> +
>> +	return 0;
>> +}
>> +
>> +static void ov7251_set_power_off(struct ov7251 *ov7251)
>> +{
>> +	clk_disable_unprepare(ov7251->xclk);
>> +	gpiod_set_value_cansleep(ov7251->enable_gpio, 0);
>> +	ov7251_regulators_disable(ov7251);
>> +}
>> +
>> +static int ov7251_s_power(struct v4l2_subdev *sd, int on)
>> +{
>> +	struct ov7251 *ov7251 = to_ov7251(sd);
>> +	int ret = 0;
>> +
>> +	mutex_lock(&ov7251->power_lock);
>> +
>> +	/* If the power count is modified from 0 to != 0 or from != 0 to 0,
>> +	 * update the power state.
>> +	 */
>> +	if (ov7251->power_count == !on) {
>> +		if (on) {
>> +			ret = ov7251_set_power_on(ov7251);
>> +			if (ret < 0)
>> +				goto exit;
>> +
>> +			ret = ov7251_set_register_array(ov7251,
>> +					ov7251_global_init_setting,
>> +					ARRAY_SIZE(ov7251_global_init_setting));
>> +			if (ret < 0) {
>> +				dev_err(ov7251->dev,
>> +					"could not set init registers\n");
>> +				ov7251_set_power_off(ov7251);
>> +				goto exit;
>> +			}
>> +		} else {
>> +			ov7251_set_power_off(ov7251);
>> +		}
>> +	}
>> +
>> +	/* Update the power count. */
>> +	ov7251->power_count += on ? 1 : -1;
>> +	WARN_ON(ov7251->power_count < 0);
> 
> Is this 'reference counting' necessary? If you receive three
> s_power(1) you would need three s_power(0) to turn the sensor off.
> Is this better than a simple "if it's on, turn it off" and viceversa?

If you receive three s_power(1), you'd want to power off the device
when the last user calls s_power(0), not before that. However...

> 
> Also, it should not happen that you receive multiple s_power(1) or
> s_power(0), but I may be wrong...

...it seems to me that it really should not happen to receive
multiple s_power(1). As far as I can see the s_power is called
from pipeline_pm_power_one() only and it implements a use count and
will call it once only. If this is true, I think we can remove
the reference counting in the driver.

It would be nice if someone can confirm this - Hans, Laurent,
Sakari?

We'll still need to track the current power on/off state though
if we want to skip unnecessary control handling in s_ctrl when
the sensor is not powered on. So the benfit will not be great -
switch form a reference count to on/off state, keep the locking..

> 
>> +
>> +exit:
>> +	mutex_unlock(&ov7251->power_lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static int ov7251_set_hflip(struct ov7251 *ov7251, s32 value)
>> +{
>> +	u8 val = ov7251->timing_format2;
>> +	int ret;
>> +
>> +	if (value)
>> +		val |= OV7251_SENSOR_MIRROR;
>> +	else
>> +		val &= ~OV7251_SENSOR_MIRROR;
>> +
>> +	ret = ov7251_write_reg(ov7251, OV7251_TIMING_FORMAT2, val);
>> +	if (!ret)
>> +		ov7251->timing_format2 = val;
>> +
>> +	return ret;
>> +}
>> +
>> +static int ov7251_set_vflip(struct ov7251 *ov7251, s32 value)
>> +{
>> +	u8 val = ov7251->timing_format1;
>> +	int ret;
>> +
>> +	if (value)
>> +		val |= OV7251_SENSOR_VFLIP;
>> +	else
>> +		val &= ~OV7251_SENSOR_VFLIP;
>> +
>> +	ret = ov7251_write_reg(ov7251, OV7251_TIMING_FORMAT1, val);
>> +	if (!ret)
>> +		ov7251->timing_format1 = val;
>> +
>> +	return ret;
>> +}
>> +
>> +static int ov7251_set_test_pattern(struct ov7251 *ov7251, s32 value)
>> +{
>> +	u8 val = ov7251->pre_isp_00;
>> +	int ret;
>> +
>> +	if (value)
>> +		val |= OV7251_TEST_PATTERN_BAR_ENABLE;
>> +	else
>> +		val &= ~OV7251_TEST_PATTERN_BAR_ENABLE;
>> +
>> +	ret = ov7251_write_reg(ov7251, OV7251_PRE_ISP_00, val);
>> +	if (!ret)
>> +		ov7251->pre_isp_00 = val;
>> +
>> +	return ret;
>> +}
>> +
>> +static const char * const ov7251_test_pattern_menu[] = {
>> +	"Disabled",
>> +	"Vertical Patern Bars",
>> +};
>> +
>> +static int ov7251_s_ctrl(struct v4l2_ctrl *ctrl)
>> +{
>> +	struct ov7251 *ov7251 = container_of(ctrl->handler,
>> +					     struct ov7251, ctrls);
>> +	int ret;
>> +
>> +	mutex_lock(&ov7251->power_lock);
>> +	if (!ov7251->power_count) {
>> +		mutex_unlock(&ov7251->power_lock);
>> +		return 0;
>> +	}
>> +
>> +	switch (ctrl->id) {
>> +	case V4L2_CID_EXPOSURE:
>> +		ret = ov7251_set_exposure(ov7251, ctrl->val);
>> +		break;
>> +	case V4L2_CID_GAIN:
>> +		ret = ov7251_set_gain(ov7251, ctrl->val);
>> +		break;
>> +	case V4L2_CID_TEST_PATTERN:
>> +		ret = ov7251_set_test_pattern(ov7251, ctrl->val);
>> +		break;
>> +	case V4L2_CID_HFLIP:
>> +		ret = ov7251_set_hflip(ov7251, ctrl->val);
>> +		break;
>> +	case V4L2_CID_VFLIP:
>> +		ret = ov7251_set_vflip(ov7251, ctrl->val);
>> +		break;
>> +	default:
>> +		ret = -EINVAL;
> 
> As commented in probe() you return -EINVAL for pixel clock and link
> frequencies if I'm not wrong...

They are read-only controls, s_ctrl is not allowed for them.

> 
>> +		break;
>> +	}
>> +
>> +	mutex_unlock(&ov7251->power_lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static const struct v4l2_ctrl_ops ov7251_ctrl_ops = {
>> +	.s_ctrl = ov7251_s_ctrl,
>> +};
>> +
>> +static int ov7251_enum_mbus_code(struct v4l2_subdev *sd,
>> +				 struct v4l2_subdev_pad_config *cfg,
>> +				 struct v4l2_subdev_mbus_code_enum *code)
>> +{
>> +	if (code->index > 0)
>> +		return -EINVAL;
>> +
>> +	code->code = MEDIA_BUS_FMT_SBGGR10_1X10;
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov7251_enum_frame_size(struct v4l2_subdev *subdev,
>> +				  struct v4l2_subdev_pad_config *cfg,
>> +				  struct v4l2_subdev_frame_size_enum *fse)
>> +{
>> +	if (fse->code != MEDIA_BUS_FMT_SBGGR10_1X10)
>> +		return -EINVAL;
>> +
>> +	if (fse->index >= ARRAY_SIZE(ov7251_mode_info_data))
>> +		return -EINVAL;
>> +
>> +	fse->min_width = ov7251_mode_info_data[fse->index].width;
>> +	fse->max_width = ov7251_mode_info_data[fse->index].width;
>> +	fse->min_height = ov7251_mode_info_data[fse->index].height;
>> +	fse->max_height = ov7251_mode_info_data[fse->index].height;
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov7251_enum_frame_ival(struct v4l2_subdev *subdev,
>> +				  struct v4l2_subdev_pad_config *cfg,
>> +				  struct v4l2_subdev_frame_interval_enum *fie)
>> +{
>> +	int index = fie->index;
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(ov7251_mode_info_data); i++) {
>> +		if (fie->width != ov7251_mode_info_data[i].width ||
>> +		    fie->height != ov7251_mode_info_data[i].height)
>> +			continue;
> 
> You only support 640x480 and you can return immediately
> if provided sizes do not match.

Yes, but the sensor supports other modes even though I don't have the
settings and the driver now only implements 640x480. I'd prefer to keep
the sensor modes usage generic so others could be added easily. This is
not performance expensive neither time critical.

> 
>> +
>> +		if (index-- == 0) {
>> +			fie->interval = ov7251_mode_info_data[i].timeperframe;
>> +			return 0;
>> +		}
>> +	}
>> +
>> +	return -EINVAL;
>> +}
>> +
>> +static struct v4l2_mbus_framefmt *
>> +__ov7251_get_pad_format(struct ov7251 *ov7251,
>> +			struct v4l2_subdev_pad_config *cfg,
>> +			unsigned int pad,
>> +			enum v4l2_subdev_format_whence which)
>> +{
>> +	switch (which) {
>> +	case V4L2_SUBDEV_FORMAT_TRY:
>> +		return v4l2_subdev_get_try_format(&ov7251->sd, cfg, pad);
>> +	case V4L2_SUBDEV_FORMAT_ACTIVE:
>> +		return &ov7251->fmt;
>> +	default:
>> +		return NULL;
>> +	}
>> +}
>> +
>> +static int ov7251_get_format(struct v4l2_subdev *sd,
>> +			     struct v4l2_subdev_pad_config *cfg,
>> +			     struct v4l2_subdev_format *format)
>> +{
>> +	struct ov7251 *ov7251 = to_ov7251(sd);
>> +
>> +	format->format = *__ov7251_get_pad_format(ov7251, cfg, format->pad,
>> +						  format->which);
>> +	return 0;
>> +}
>> +
>> +static struct v4l2_rect *
>> +__ov7251_get_pad_crop(struct ov7251 *ov7251, struct v4l2_subdev_pad_config *cfg,
>> +		      unsigned int pad, enum v4l2_subdev_format_whence which)
>> +{
>> +	switch (which) {
>> +	case V4L2_SUBDEV_FORMAT_TRY:
>> +		return v4l2_subdev_get_try_crop(&ov7251->sd, cfg, pad);
>> +	case V4L2_SUBDEV_FORMAT_ACTIVE:
>> +		return &ov7251->crop;
>> +	default:
>> +		return NULL;
>> +	}
>> +}
>> +
>> +static const struct ov7251_mode_info *
>> +ov7251_find_mode_by_size(unsigned int width, unsigned int height)
>> +{
>> +	unsigned int max_dist_match = (unsigned int) -1;
>> +	int i, n = 0;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(ov7251_mode_info_data); i++) {
>> +		unsigned int dist = min(width, ov7251_mode_info_data[i].width)
>> +				* min(height, ov7251_mode_info_data[i].height);
>> +
>> +		dist = ov7251_mode_info_data[i].width *
>> +				ov7251_mode_info_data[i].height +
>> +			width * height - 2 * dist;
> 
> I didn't get why you assign dist twice here..

dist is used in the evaluation of the second expression.

> 
>> +
>> +		if (dist < max_dist_match) {
>> +			n = i;
>> +			max_dist_match = dist;
>> +		}
>> +	}
>> +
>> +	return &ov7251_mode_info_data[n];
>> +}
> 
> I do not find that much value in this function, as being all
> ov7251_mode_info_data[] sizes equal you end up returning always the
> first one...

Keeping it generic, as explained above.

> 
>> +
>> +#define TIMEPERFRAME_AVG_FPS(t)						\
>> +	(((t).denominator + ((t).numerator >> 1)) / (t).numerator)
>> +
>> +static const struct ov7251_mode_info *
>> +ov7251_find_mode_by_ival(struct ov7251 *ov7251, struct v4l2_fract *timeperframe)
>> +{
>> +	const struct ov7251_mode_info *mode = ov7251->current_mode;
>> +	int fps_req = TIMEPERFRAME_AVG_FPS(*timeperframe);
>> +	unsigned int max_dist_match = (unsigned int) -1;
>> +	int i, n = 0;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(ov7251_mode_info_data); i++) {
>> +		unsigned int dist;
>> +		int fps_tmp;
>> +
>> +		if (mode->width != ov7251_mode_info_data[i].width ||
>> +		    mode->height != ov7251_mode_info_data[i].height)
>> +			continue;
> 
> If the requested sizes do not match any of your supported ones you return the
> first available mode unconditionally (n == 0 at the end of this loop). As this
> device driver only supports 640x480, if mode->width and mode->height do not match
> that, you can force them and then actually match mode on the closest fps in the loop

It will always match at least one of the supported modes. The driver compares the
current mode with all the supported modes to find the closest frame interval for
the width and height currently set.

> 
>> +
>> +		fps_tmp = TIMEPERFRAME_AVG_FPS(
>> +					ov7251_mode_info_data[i].timeperframe);
>> +
>> +		if (fps_req > fps_tmp)
>> +			dist = fps_req - fps_tmp;
>> +		else
>> +			dist = fps_tmp - fps_req;
> 
> You can use abs(fps_req, fps_tmp)

Yes.

> 
>> +
>> +		if (dist < max_dist_match) {
>> +			n = i;
>> +			max_dist_match = dist;
>> +		}
>> +	}
>> +
>> +	return &ov7251_mode_info_data[n];
>> +}
>> +
>> +static int ov7251_set_format(struct v4l2_subdev *sd,
>> +			     struct v4l2_subdev_pad_config *cfg,
>> +			     struct v4l2_subdev_format *format)
>> +{
>> +	struct ov7251 *ov7251 = to_ov7251(sd);
>> +	struct v4l2_mbus_framefmt *__format;
>> +	struct v4l2_rect *__crop;
>> +	const struct ov7251_mode_info *new_mode;
>> +	int ret;
>> +
>> +	__crop = __ov7251_get_pad_crop(ov7251, cfg, format->pad,
>> +			format->which);
>> +
>> +	new_mode = ov7251_find_mode_by_size(format->format.width,
>> +					    format->format.height);
>> +	__crop->width = new_mode->width;
>> +	__crop->height = new_mode->height;
> 
> This will always be 640x480 (see comment on
> ov7251_find_mode_by_size())

Keeping it generic...

> 
>> +
>> +	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
>> +		ret = v4l2_ctrl_s_ctrl_int64(ov7251->pixel_clock,
>> +					     new_mode->pixel_clock);
>> +		if (ret < 0)
>> +			return ret;
>> +
>> +		ret = v4l2_ctrl_s_ctrl(ov7251->link_freq,
>> +				       new_mode->link_freq);
>> +		if (ret < 0)
>> +			return ret;
>> +
>> +		ret = v4l2_ctrl_modify_range(ov7251->exposure,
>> +					     1, new_mode->exposure_max,
>> +					     1, new_mode->exposure_def);
>> +		if (ret < 0)
>> +			return ret;
>> +
>> +		ret = v4l2_ctrl_s_ctrl(ov7251->exposure,
>> +				       new_mode->exposure_def);
>> +		if (ret < 0)
>> +			return ret;
>> +
>> +
>> +		ret = v4l2_ctrl_s_ctrl(ov7251->gain, 16);
>> +		if (ret < 0)
>> +			return ret;
>> +
>> +		ov7251->current_mode = new_mode;
>> +	}
>> +
>> +	__format = __ov7251_get_pad_format(ov7251, cfg, format->pad,
>> +			format->which);
>> +	__format->width = __crop->width;
>> +	__format->height = __crop->height;
>> +	__format->code = MEDIA_BUS_FMT_SBGGR10_1X10;
>> +	__format->field = V4L2_FIELD_NONE;
>> +	__format->colorspace = V4L2_COLORSPACE_SRGB;
> 
> What about ycbcr_enc, quantization and xfer_func fields? Seems like
> you are returning a raw bayer format and I'm not sure if they actually
> applies here...

Yes, I can add these and use the V4L2_MAP_* macros to set the values.
However I'm starting to wonder if colorspace SRGB will be correct for
a black & white sensor, but I don't see anything other appropriate.
Any suggestions for this?

> 
>> +
>> +	format->format = *__format;
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov7251_entity_init_cfg(struct v4l2_subdev *subdev,
>> +				  struct v4l2_subdev_pad_config *cfg)
>> +{
>> +	struct v4l2_subdev_format fmt = { 0 };
>> +
>> +	fmt.which = cfg ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
>> +	fmt.format.width = 640;
>> +	fmt.format.height = 480;
>> +
>> +	ov7251_set_format(subdev, cfg, &fmt);
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov7251_get_selection(struct v4l2_subdev *sd,
>> +			   struct v4l2_subdev_pad_config *cfg,
>> +			   struct v4l2_subdev_selection *sel)
>> +{
>> +	struct ov7251 *ov7251 = to_ov7251(sd);
>> +
>> +	if (sel->target != V4L2_SEL_TGT_CROP)
>> +		return -EINVAL;
>> +
>> +	sel->r = *__ov7251_get_pad_crop(ov7251, cfg, sel->pad,
>> +					sel->which);
>> +	return 0;
>> +}
>> +
>> +static int ov7251_s_stream(struct v4l2_subdev *subdev, int enable)
>> +{
>> +	struct ov7251 *ov7251 = to_ov7251(subdev);
>> +	int ret;
>> +
>> +	if (enable) {
>> +		ret = ov7251_set_register_array(ov7251,
>> +					ov7251->current_mode->data,
>> +					ov7251->current_mode->data_size);
>> +		if (ret < 0) {
>> +			dev_err(ov7251->dev, "could not set mode %dx%d\n",
>> +				ov7251->current_mode->width,
>> +				ov7251->current_mode->height);
>> +			return ret;
>> +		}
>> +		ret = v4l2_ctrl_handler_setup(&ov7251->ctrls);
>> +		if (ret < 0) {
>> +			dev_err(ov7251->dev, "could not sync v4l2 controls\n");
>> +			return ret;
>> +		}
>> +		ret = ov7251_write_reg(ov7251, OV7251_SC_MODE_SELECT,
>> +				       OV7251_SC_MODE_SELECT_STREAMING);
>> +		if (ret < 0)
>> +			return ret;
>> +	} else {
>> +		ret = ov7251_write_reg(ov7251, OV7251_SC_MODE_SELECT,
>> +				       OV7251_SC_MODE_SELECT_SW_STANDBY);
>> +		if (ret < 0)
>> +			return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov7251_get_frame_interval(struct v4l2_subdev *subdev,
>> +				     struct v4l2_subdev_frame_interval *fi)
>> +{
>> +	struct ov7251 *ov7251 = to_ov7251(subdev);
>> +
>> +	fi->interval = ov7251->current_mode->timeperframe;
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov7251_set_frame_interval(struct v4l2_subdev *subdev,
>> +				     struct v4l2_subdev_frame_interval *fi)
>> +{
>> +	struct ov7251 *ov7251 = to_ov7251(subdev);
>> +	const struct ov7251_mode_info *new_mode;
>> +
>> +	new_mode = ov7251_find_mode_by_ival(ov7251, &fi->interval);
>> +
>> +	if (new_mode != ov7251->current_mode) {
>> +		int ret;
>> +
>> +		ret = v4l2_ctrl_s_ctrl_int64(ov7251->pixel_clock,
>> +					     new_mode->pixel_clock);
>> +		if (ret < 0)
>> +			return ret;
>> +
>> +		ret = v4l2_ctrl_s_ctrl(ov7251->link_freq,
>> +				       new_mode->link_freq);
>> +		if (ret < 0)
>> +			return ret;
>> +
>> +		ret = v4l2_ctrl_modify_range(ov7251->exposure,
>> +					     1, new_mode->exposure_max,
>> +					     1, new_mode->exposure_def);
>> +		if (ret < 0)
>> +			return ret;
>> +
>> +		ret = v4l2_ctrl_s_ctrl(ov7251->exposure,
>> +				       new_mode->exposure_def);
>> +		if (ret < 0)
>> +			return ret;
>> +
>> +		ret = v4l2_ctrl_s_ctrl(ov7251->gain, 16);
>> +		if (ret < 0)
>> +			return ret;
>> +
>> +		ov7251->current_mode = new_mode;
>> +	}
>> +
>> +	fi->interval = ov7251->current_mode->timeperframe;
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct v4l2_subdev_core_ops ov7251_core_ops = {
>> +	.s_power = ov7251_s_power,
>> +};
>> +
>> +static const struct v4l2_subdev_video_ops ov7251_video_ops = {
>> +	.s_stream = ov7251_s_stream,
>> +	.g_frame_interval = ov7251_get_frame_interval,
>> +	.s_frame_interval = ov7251_set_frame_interval,
>> +};
>> +
>> +static const struct v4l2_subdev_pad_ops ov7251_subdev_pad_ops = {
>> +	.init_cfg = ov7251_entity_init_cfg,
>> +	.enum_mbus_code = ov7251_enum_mbus_code,
>> +	.enum_frame_size = ov7251_enum_frame_size,
>> +	.enum_frame_interval = ov7251_enum_frame_ival,
>> +	.get_fmt = ov7251_get_format,
>> +	.set_fmt = ov7251_set_format,
>> +	.get_selection = ov7251_get_selection,
>> +};
>> +
>> +static const struct v4l2_subdev_ops ov7251_subdev_ops = {
>> +	.core = &ov7251_core_ops,
>> +	.video = &ov7251_video_ops,
>> +	.pad = &ov7251_subdev_pad_ops,
>> +};
>> +
>> +static int ov7251_probe(struct i2c_client *client,
>> +			const struct i2c_device_id *id)
>> +{
>> +	struct device *dev = &client->dev;
>> +	struct device_node *endpoint;
>> +	struct ov7251 *ov7251;
>> +	u8 chip_id_high, chip_id_low, chip_rev;
>> +	u32 xclk_freq;
>> +	int ret;
>> +
>> +	ov7251 = devm_kzalloc(dev, sizeof(struct ov7251), GFP_KERNEL);
>> +	if (!ov7251)
>> +		return -ENOMEM;
>> +
>> +	ov7251->i2c_client = client;
>> +	ov7251->dev = dev;
>> +
>> +	endpoint = of_graph_get_next_endpoint(dev->of_node, NULL);
> 
> My understanding is that it is preferred to use fwnode_ library when
> possible, even if this driver is OF compatible only at the moment:
> 
> fwnode_graph_get_next_endpoint(dev_fwnode(dev), NULL)
> 
>> +	if (!endpoint) {
>> +		dev_err(dev, "endpoint node not found\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(endpoint),
> 
> And then you can remove conversion to fwnode_handle here.

Yes, I'll switch to fwnode.

> 
> Also consider v4l2_fwnode_endpoint_alloc_parse() that allows parsing
> of variable sizes data such as the CSI-2 link frequencies (which you
> handle as controls in this driver, so I'm not sure you actually need
> it here)

I think I don't need it.

> 
> 
>> +					 &ov7251->ep);
>> +	if (ret < 0) {
>> +		dev_err(dev, "parsing endpoint node failed\n");
> 
> Decrement the endpoint refcount in the error path

Ok.

> 
>> +		return ret;
>> +	}
>> +
>> +	of_node_put(endpoint);
>> +
>> +	if (ov7251->ep.bus_type != V4L2_MBUS_CSI2) {
>> +		dev_err(dev, "invalid bus type, must be CSI2\n");
> 
> Maybe print the returned bus_type?

Yes.

> 
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* get system clock (xclk) */
>> +	ov7251->xclk = devm_clk_get(dev, "xclk");
>> +	if (IS_ERR(ov7251->xclk)) {
>> +		dev_err(dev, "could not get xclk");
>> +		return PTR_ERR(ov7251->xclk);
>> +	}
>> +
>> +	ret = of_property_read_u32(dev->of_node, "clock-frequency", &xclk_freq);
>> +	if (ret) {
>> +		dev_err(dev, "could not get xclk frequency\n");
>> +		return ret;
>> +	}
>> +
>> +	if (xclk_freq != 24000000) {
>> +		dev_err(dev, "external clock frequency %u is not supported\n",
>> +			xclk_freq);
>> +		return -EINVAL;
>> +	}
> 
> If 24MHz is the only allowed frequency, maybe it should be documented
> in the device tree bindings?

Yes, I'll add a comment here and also state it in the device tree binding
document. I'll allow 1% tollerance of that frequency though.

> 
>> +
>> +	ret = clk_set_rate(ov7251->xclk, xclk_freq);
>> +	if (ret) {
>> +		dev_err(dev, "could not set xclk frequency\n");
>> +		return ret;
>> +	}
>> +
>> +	ov7251->io_regulator = devm_regulator_get(dev, "vdddo");
>> +	if (IS_ERR(ov7251->io_regulator)) {
>> +		dev_err(dev, "cannot get io regulator\n");
>> +		return PTR_ERR(ov7251->io_regulator);
>> +	}
>> +
>> +	ret = regulator_set_voltage(ov7251->io_regulator,
>> +				    OV7251_VOLTAGE_DIGITAL_IO,
>> +				    OV7251_VOLTAGE_DIGITAL_IO);
>> +	if (ret < 0) {
>> +		dev_err(dev, "cannot set io voltage\n");
>> +		return ret;
>> +	}
>> +
>> +	ov7251->core_regulator = devm_regulator_get(dev, "vddd");
>> +	if (IS_ERR(ov7251->core_regulator)) {
>> +		dev_err(dev, "cannot get core regulator\n");
>> +		return PTR_ERR(ov7251->core_regulator);
>> +	}
>> +
>> +	ret = regulator_set_voltage(ov7251->core_regulator,
>> +				    OV7251_VOLTAGE_DIGITAL_CORE,
>> +				    OV7251_VOLTAGE_DIGITAL_CORE);
>> +	if (ret < 0) {
>> +		dev_err(dev, "cannot set core voltage\n");
>> +		return ret;
>> +	}
>> +
>> +	ov7251->analog_regulator = devm_regulator_get(dev, "vdda");
>> +	if (IS_ERR(ov7251->analog_regulator)) {
>> +		dev_err(dev, "cannot get analog regulator\n");
>> +		return PTR_ERR(ov7251->analog_regulator);
>> +	}
>> +
>> +	ret = regulator_set_voltage(ov7251->analog_regulator,
>> +				    OV7251_VOLTAGE_ANALOG,
>> +				    OV7251_VOLTAGE_ANALOG);
>> +	if (ret < 0) {
>> +		dev_err(dev, "cannot set analog voltage\n");
>> +		return ret;
>> +	}
>> +
>> +	ov7251->enable_gpio = devm_gpiod_get(dev, "enable", GPIOD_OUT_HIGH);
>> +	if (IS_ERR(ov7251->enable_gpio)) {
>> +		dev_err(dev, "cannot get enable gpio\n");
>> +		return PTR_ERR(ov7251->enable_gpio);
>> +	}
>> +
>> +	mutex_init(&ov7251->power_lock);
>> +
>> +	v4l2_ctrl_handler_init(&ov7251->ctrls, 7);
>> +	v4l2_ctrl_new_std(&ov7251->ctrls, &ov7251_ctrl_ops,
>> +			  V4L2_CID_HFLIP, 0, 1, 1, 0);
>> +	v4l2_ctrl_new_std(&ov7251->ctrls, &ov7251_ctrl_ops,
>> +			  V4L2_CID_VFLIP, 0, 1, 1, 0);
>> +	ov7251->exposure = v4l2_ctrl_new_std(&ov7251->ctrls, &ov7251_ctrl_ops,
>> +					     V4L2_CID_EXPOSURE, 1, 32, 1, 32);
>> +	ov7251->gain = v4l2_ctrl_new_std(&ov7251->ctrls, &ov7251_ctrl_ops,
>> +					 V4L2_CID_GAIN, 16, 1023, 1, 16);
>> +	v4l2_ctrl_new_std_menu_items(&ov7251->ctrls, &ov7251_ctrl_ops,
>> +				     V4L2_CID_TEST_PATTERN,
>> +				     ARRAY_SIZE(ov7251_test_pattern_menu) - 1,
>> +				     0, 0, ov7251_test_pattern_menu);
>> +	ov7251->pixel_clock = v4l2_ctrl_new_std(&ov7251->ctrls,
>> +						&ov7251_ctrl_ops,
>> +						V4L2_CID_PIXEL_RATE,
>> +						1, INT_MAX, 1, 1);
> 
> It seems to me that your ov7251_s_ctrl() does not handle
> V4L2_CID_PIXEL_RATE (same for V4L2_CID_LINK_FREQ) and return -EINVAL
> for them. Am I missing some pieces here?

They are read-only controls.

> 
>> +	ov7251->link_freq = v4l2_ctrl_new_int_menu(&ov7251->ctrls,
>> +						   &ov7251_ctrl_ops,
>> +						   V4L2_CID_LINK_FREQ,
>> +						   ARRAY_SIZE(link_freq) - 1,
>> +						   0, link_freq);
>> +	if (ov7251->link_freq)
>> +		ov7251->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
>> +
>> +	ov7251->sd.ctrl_handler = &ov7251->ctrls;
>> +
>> +	if (ov7251->ctrls.error) {
>> +		dev_err(dev, "%s: control initialization error %d\n",
>> +		       __func__, ov7251->ctrls.error);
>> +		ret = ov7251->ctrls.error;
>> +		goto free_ctrl;
>> +	}
>> +
>> +	v4l2_i2c_subdev_init(&ov7251->sd, client, &ov7251_subdev_ops);
>> +	ov7251->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>> +	ov7251->pad.flags = MEDIA_PAD_FL_SOURCE;
>> +	ov7251->sd.dev = &client->dev;
>> +	ov7251->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
>> +
>> +	ret = media_entity_pads_init(&ov7251->sd.entity, 1, &ov7251->pad);
>> +	if (ret < 0) {
>> +		dev_err(dev, "could not register media entity\n");
>> +		goto free_ctrl;
>> +	}
>> +
>> +	ret = ov7251_s_power(&ov7251->sd, true);
>> +	if (ret < 0) {
>> +		dev_err(dev, "could not power up OV7251\n");
>> +		goto free_entity;
>> +	}
>> +
>> +	ret = ov7251_read_reg(ov7251, OV7251_CHIP_ID_HIGH, &chip_id_high);
>> +	if (ret < 0 || chip_id_high != OV7251_CHIP_ID_HIGH_BYTE) {
>> +		dev_err(dev, "could not read ID high\n");
>> +		ret = -ENODEV;
>> +		goto power_down;
>> +	}
>> +	ret = ov7251_read_reg(ov7251, OV7251_CHIP_ID_LOW, &chip_id_low);
>> +	if (ret < 0 || chip_id_low != OV7251_CHIP_ID_LOW_BYTE) {
>> +		dev_err(dev, "could not read ID low\n");
>> +		ret = -ENODEV;
>> +		goto power_down;
>> +	}
>> +
>> +	ret = ov7251_read_reg(ov7251, OV7251_SC_GP_IO_IN1, &chip_rev);
>> +	if (ret < 0) {
>> +		dev_err(dev, "could not read revision\n");
>> +		ret = -ENODEV;
>> +		goto power_down;
>> +	}
>> +	chip_rev >>= 4;
>> +
>> +	dev_info(dev, "OV7251 revision %x (%s) detected at address 0x%02x\n",
>> +		 chip_rev,
>> +		 chip_rev == 0x4 ? "1A / 1B" :
>> +		 chip_rev == 0x5 ? "1C / 1D" :
>> +		 chip_rev == 0x6 ? "1E" :
>> +		 chip_rev == 0x7 ? "1F" : "unknown",
>> +		 client->addr);
>> +
>> +	ret = ov7251_read_reg(ov7251, OV7251_PRE_ISP_00,
>> +			      &ov7251->pre_isp_00);
>> +	if (ret < 0) {
>> +		dev_err(dev, "could not read test pattern value\n");
>> +		ret = -ENODEV;
>> +		goto power_down;
>> +	}
>> +
>> +	ret = ov7251_read_reg(ov7251, OV7251_TIMING_FORMAT1,
>> +			      &ov7251->timing_format1);
>> +	if (ret < 0) {
>> +		dev_err(dev, "could not read vflip value\n");
>> +		ret = -ENODEV;
>> +		goto power_down;
>> +	}
>> +
>> +	ret = ov7251_read_reg(ov7251, OV7251_TIMING_FORMAT2,
>> +			      &ov7251->timing_format2);
>> +	if (ret < 0) {
>> +		dev_err(dev, "could not read hflip value\n");
>> +		ret = -ENODEV;
>> +		goto power_down;
>> +	}
>> +
>> +	ov7251_s_power(&ov7251->sd, false);
> 
> I am not sure if using pm_runtime is the preferred way to handle
> sensor power management, I just noticed just a few bridge drivers actually
> call s_power() on their subdevices.

I've left this to the media framework - when a video node is opened,
the pipeline connected to that video node (active media links) is powered up.

Best regards,
Todor

> 
> Thanks
>    j
> 
> 
>> +
>> +	ret = v4l2_async_register_subdev(&ov7251->sd);
>> +	if (ret < 0) {
>> +		dev_err(dev, "could not register v4l2 device\n");
>> +		goto free_entity;
>> +	}
>> +
>> +	ov7251_entity_init_cfg(&ov7251->sd, NULL);
>> +
>> +	return 0;
>> +
>> +power_down:
>> +	ov7251_s_power(&ov7251->sd, false);
>> +free_entity:
>> +	media_entity_cleanup(&ov7251->sd.entity);
>> +free_ctrl:
>> +	v4l2_ctrl_handler_free(&ov7251->ctrls);
>> +	mutex_destroy(&ov7251->power_lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static int ov7251_remove(struct i2c_client *client)
>> +{
>> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
>> +	struct ov7251 *ov7251 = to_ov7251(sd);
>> +
>> +	v4l2_async_unregister_subdev(&ov7251->sd);
>> +	media_entity_cleanup(&ov7251->sd.entity);
>> +	v4l2_ctrl_handler_free(&ov7251->ctrls);
>> +	mutex_destroy(&ov7251->power_lock);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct i2c_device_id ov7251_id[] = {
>> +	{ "ov7251", 0 },
>> +	{}
>> +};
>> +MODULE_DEVICE_TABLE(i2c, ov7251_id);
>> +
>> +static const struct of_device_id ov7251_of_match[] = {
>> +	{ .compatible = "ovti,ov7251" },
>> +	{ /* sentinel */ }
>> +};
>> +MODULE_DEVICE_TABLE(of, ov7251_of_match);
>> +
>> +static struct i2c_driver ov7251_i2c_driver = {
>> +	.driver = {
>> +		.of_match_table = of_match_ptr(ov7251_of_match),
>> +		.name  = "ov7251",
>> +	},
>> +	.probe  = ov7251_probe,
>> +	.remove = ov7251_remove,
>> +	.id_table = ov7251_id,
>> +};
>> +
>> +module_i2c_driver(ov7251_i2c_driver);
>> +
>> +MODULE_DESCRIPTION("Omnivision OV7251 Camera Driver");
>> +MODULE_AUTHOR("Todor Tomov <todor.tomov@linaro.org>");
>> +MODULE_LICENSE("GPL v2");
>> --
>> 2.7.4
>>
