Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36068 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466AbcEQO6k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2016 10:58:40 -0400
Received: by mail-wm0-f50.google.com with SMTP id n129so144164785wmn.1
        for <linux-media@vger.kernel.org>; Tue, 17 May 2016 07:58:39 -0700 (PDT)
Subject: Re: [PATCH] media: Add a driver for the ov5645 camera sensor.
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
References: <1463065155-26337-1-git-send-email-todor.tomov@linaro.org>
 <57384737.30000@linaro.org>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <573B319B.40404@linaro.org>
Date: Tue, 17 May 2016 17:58:35 +0300
MIME-Version: 1.0
In-Reply-To: <57384737.30000@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stan,

Thanks for the review. My comments are inline:

On 05/15/2016 12:53 PM, Stanimir Varbanov wrote:
> Hi Todor,
> 
> On 05/12/2016 05:59 PM, Todor Tomov wrote:
>> The ov5645 sensor from Omnivision supports up to 2592x1944
>> and CSI2 interface.
>>
>> The driver adds support for the following modes:
>> - 1280x960
>> - 1920x1080
>> - 2592x1944
>>
>> Output format is packed 8bit UYVY.
>>
>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>> ---
>>  .../devicetree/bindings/media/i2c/ov5645.txt       |   54 +
>>  drivers/media/i2c/Kconfig                          |   11 +
>>  drivers/media/i2c/Makefile                         |    1 +
>>  drivers/media/i2c/ov5645.c                         | 1344 ++++++++++++++++++++
>>  4 files changed, 1410 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5645.txt
>>  create mode 100644 drivers/media/i2c/ov5645.c
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/ov5645.txt b/Documentation/devicetree/bindings/media/i2c/ov5645.txt
>> new file mode 100644
>> index 0000000..1d65fa8
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/ov5645.txt
> 
> The binding doc should be a separate patch. Also you should add
> devicetree ML in cc.
> 
Ok.

>> @@ -0,0 +1,54 @@
>> +* Omnivision 1/4-Inch 5Mp CMOS Digital Image Sensor
>> +
>> +The Omnivision OV5645 is a 1/4-Inch CMOS active pixel digital image sensor with
>> +an active array size of 2592H x 1944V. It is programmable through a serial SCCB
>> +interface.
>> +
>> +Required Properties:
>> +- compatible: value should be "ovti,ov5645"
>> +- clocks: reference to the xclk clock
>> +- clock-names: should be "xclk"
>> +- clock-rates: the xclk clock frequency
>> +
>> +Optional Properties:
>> +- reset-gpio: Chip reset GPIO
>> +- pwdn-gpio: Chip power down GPIO
>> +- DOVDD-supply: Chip IO regulator
>> +- DVDD-supply: Chip core regulator
>> +- AVDD-supply: Chip analog regulator
> 
> I'd use lower-case for the -supply properties
Ok.

> 
> <cut>
> 
>> diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
>> new file mode 100644
>> index 0000000..bae07e4
>> --- /dev/null
>> +++ b/drivers/media/i2c/ov5645.c
>> @@ -0,0 +1,1344 @@
>> +/*
>> + * Driver for the OV5645 camera sensor.
>> + *
>> + * Copyright (c) 2011-2015, The Linux Foundation. All rights reserved.
>> + * Copyright (C) 2015 By Tech Design S.L. All Rights Reserved.
>> + * Copyright (C) 2012-2013 Freescale Semiconductor, Inc. All Rights Reserved.
>> + *
>> + * Based on:
>> + * - the OV5645 driver from QC msm-3.10 kernel on codeaurora.org:
>> + *   https://us.codeaurora.org/cgit/quic/la/kernel/msm-3.10/tree/drivers/
>> + *       media/platform/msm/camera_v2/sensor/ov5645.c?h=LA.BR.1.2.4_rb1.41
>> + * - the OV5640 driver posted on linux-media:
>> + *   https://www.mail-archive.com/linux-media%40vger.kernel.org/msg92671.html
>> + */
>> +
>> +/*
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> +
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/init.h>
>> +#include <linux/slab.h>
>> +#include <linux/ctype.h>
> 
> do you need ctype.h really ?
No :)

> 
>> +#include <linux/types.h>
>> +#include <linux/gpio.h>
>> +#include <linux/delay.h>
>> +#include <linux/device.h>
>> +#include <linux/i2c.h>
>> +#include <linux/of_device.h>
>> +#include <linux/of_gpio.h>
>> +#include <linux/regulator/consumer.h>
>> +#include <linux/clk.h>
>> +#include <linux/clk-provider.h>
>> +#include <linux/clkdev.h>
> 
> those two includes are useless.
Ok, removing them.

> 
>> +#include <media/v4l2-subdev.h>
>> +#include <media/v4l2-of.h>
>> +#include <media/v4l2-ctrls.h>
>> +
>> +#define OV5645_VOLTAGE_ANALOG               2800000
>> +#define OV5645_VOLTAGE_DIGITAL_CORE         1500000
>> +#define OV5645_VOLTAGE_DIGITAL_IO           1800000
>> +
>> +#define OV5645_XCLK_MIN 6000000
>> +#define OV5645_XCLK_MAX 24000000
>> +
>> +#define OV5645_SYSTEM_CTRL0		0x3008
>> +#define		OV5645_SYSTEM_CTRL0_START	0x02
>> +#define		OV5645_SYSTEM_CTRL0_STOP	0x42
>> +#define OV5645_CHIP_ID_HIGH_REG		0x300A
>> +#define		OV5645_CHIP_ID_HIGH		0x56
>> +#define OV5645_CHIP_ID_LOW_REG		0x300B
>> +#define		OV5645_CHIP_ID_LOW		0x45
>> +#define OV5645_AWB_MANUAL_CONTROL	0x3406
>> +#define		OV5645_AWB_MANUAL_ENABLE	(1 << 0)
> 
> use BIT(x) here and below for bit operations
Ok.

> 
>> +#define OV5645_AEC_PK_MANUAL		0x3503
>> +#define		OV5645_AEC_MANUAL_ENABLE	(1 << 0)
>> +#define		OV5645_AGC_MANUAL_ENABLE	(1 << 1)
>> +#define OV5645_TIMING_TC_REG20		0x3820
>> +#define		OV5645_SENSOR_VFLIP		(1 << 1)
>> +#define		OV5645_ISP_VFLIP		(1 << 2)
>> +#define OV5645_TIMING_TC_REG21		0x3821
>> +#define		OV5645_SENSOR_MIRROR		(1 << 1)
>> +#define OV5645_PRE_ISP_TEST_SETTING_1	0x503d
>> +#define		OV5645_TEST_PATTERN_MASK	0x3
>> +#define		OV5645_SET_TEST_PATTERN(x)	((x) & OV5645_TEST_PATTERN_MASK)
>> +#define		OV5645_TEST_PATTERN_ENABLE	(1 << 7)
>> +#define OV5645_SDE_SAT_U		0x5583
>> +#define OV5645_SDE_SAT_V		0x5584
>> +
>> +enum ov5645_mode {
>> +	ov5645_mode_min = 0,
>> +	ov5645_mode_sxga_1280_960 = 0,
>> +	ov5645_mode_1080p_1920_1080 = 1,
>> +	ov5645_mode_full_2592_1944 = 2,
>> +	ov5645_mode_max = 2,
> 
> I'd make enums upper-case and rename them to OV5645_MODE_SXGA,
> OV5645_FULLHD, OV5645_FULL or something similar ?
Ok.

> 
>> +};
>> +
>> +struct reg_value {
>> +	u16 reg;
>> +	u8 val;
>> +};
>> +
>> +struct ov5645_mode_info {
>> +	enum ov5645_mode mode;
>> +	u32 width;
>> +	u32 height;
>> +	struct reg_value *init_data_ptr;
>> +	u32 init_data_size;
>> +};
>> +
>> +struct ov5645 {
>> +	struct i2c_client *i2c_client;
>> +	struct device *dev;
>> +	struct v4l2_subdev sd;
>> +	struct media_pad pad;
>> +	struct v4l2_of_endpoint ep;
>> +	struct v4l2_mbus_framefmt fmt;
>> +	struct v4l2_rect crop;
> 
> just rect?
I don't see a lot of a difference. I would keep it.

> 
>> +	struct clk *xclk;
>> +	int xclk_freq;
> 
> unsigned long xclk_freq
u32 xclk_freq ?

> 
>> +
>> +	struct regulator *io_regulator;
>> +	struct regulator *core_regulator;
>> +	struct regulator *analog_regulator;
>> +
>> +	enum ov5645_mode current_mode;
>> +
>> +	/* Cached control values */
>> +	struct v4l2_ctrl_handler ctrls;
>> +	struct v4l2_ctrl *saturation;
>> +	struct v4l2_ctrl *hflip;
>> +	struct v4l2_ctrl *vflip;
>> +	struct v4l2_ctrl *autogain;
>> +	struct v4l2_ctrl *autoexposure;
>> +	struct v4l2_ctrl *awb;
>> +	struct v4l2_ctrl *pattern;
>> +
>> +	struct mutex power_lock; /* lock to protect power_count */
>> +	int power_count;
>> +
>> +	int pwdn_gpio;
>> +	int rst_gpio;
>> +};
>> +
>> +static inline struct ov5645 *to_ov5645(struct v4l2_subdev *sd)
>> +{
>> +	return container_of(sd, struct ov5645, sd);
>> +}
>> +
>> +static struct reg_value ov5645_global_init_setting[] = {
>> +	{0x3103, 0x11,},
> 
> could you add spaces and remove trailing comma?
Sure.

> 
> <cut>
> 
>> +static struct ov5645_mode_info ov5645_mode_info_data[ov5645_mode_max + 1] = {
>> +	{ov5645_mode_sxga_1280_960, 1280, 960,
>> +	 ov5645_setting_sxga,
>> +	 ARRAY_SIZE(ov5645_setting_sxga)},
>> +	{ov5645_mode_1080p_1920_1080, 1920, 1080,
>> +	 ov5645_setting_1080P,
>> +	 ARRAY_SIZE(ov5645_setting_1080P)},
>> +	{ov5645_mode_full_2592_1944, 2592, 1944,
>> +	 ov5645_setting_full,
>> +	 ARRAY_SIZE(ov5645_setting_full)},
>> +};
>> +
> 
> could you format this better.
Ok.

> 
>> +static void ov5645_regulators_get(struct ov5645 *ov5645)
>> +{
>> +	ov5645->io_regulator = devm_regulator_get(ov5645->dev, "DOVDD");
> 
> could you move all devm_regulator_get calls in .probe
Ok.

> 
>> +	if (IS_ERR(ov5645->io_regulator)) {
>> +		ov5645->io_regulator = NULL;
> 
> this can be EPROBE_DEFER, so you should take care and check the exact
> error code.
Ok, will check.

> 
>> +		dev_dbg(ov5645->dev, "cannot get io voltage\n");
>> +	} else {
>> +		regulator_set_voltage(ov5645->io_regulator,
>> +				OV5645_VOLTAGE_DIGITAL_IO,
>> +				OV5645_VOLTAGE_DIGITAL_IO);
> 
> error check for regulator_set_voltage?
Ok.

> 
> <cut>
> 
> 
>> +
>> +static void ov5645_regulators_disable(struct ov5645 *ov5645)
>> +{
>> +	if (ov5645->analog_regulator)
>> +		regulator_disable(ov5645->analog_regulator);
> 
> regulator_disable return error, check it
I can check it but if error happens the only thing to do is to
print a message, right?

> 
>> +	if (ov5645->core_regulator)
>> +		regulator_disable(ov5645->core_regulator);
>> +	if (ov5645->io_regulator)
>> +		regulator_disable(ov5645->io_regulator);
>> +}
>> +
>> +static s32 ov5645_write_reg(struct ov5645 *ov5645, u16 reg, u8 val)
>> +{
>> +	u8 regbuf[3] = {0};
> 
> you set all elements below, so no need to zeroing.
Ok.

> 
>> +
>> +	regbuf[0] = reg >> 8;
>> +	regbuf[1] = reg & 0xff;
>> +	regbuf[2] = val;
>> +
>> +	if (i2c_master_send(ov5645->i2c_client, regbuf, 3) < 0) {
>> +		dev_err(ov5645->dev, "%s:write reg error:reg=%x,val=%x\n",
>> +			__func__, reg, val);
>> +		return -1;
> 
> return the exact error from i2c_master_send()
Ok.

> 
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static s32 ov5645_read_reg(struct ov5645 *ov5645, u16 reg, u8 *val)
>> +{
>> +	u8 regbuf[2] = {0};
> 
> no need to zero the array
Ok.

> 
>> +	u8 tmpval = 0;
>> +
>> +	regbuf[0] = reg >> 8;
>> +	regbuf[1] = reg & 0xff;
>> +
>> +	if (i2c_master_send(ov5645->i2c_client, regbuf, 2) != 2) {
>> +		dev_err(ov5645->dev, "%s:write reg error:reg=%x\n",
>> +			__func__, reg);
>> +		return -1;
>> +	}
>> +
>> +	if (i2c_master_recv(ov5645->i2c_client, &tmpval, 1) != 1) {
>> +		dev_err(ov5645->dev, "%s:read reg error:reg=%x,val=%x\n",
>> +			__func__, reg, tmpval);
>> +		return -1;
>> +	}
>> +
> 
> again, return the exact error from i2c_master
Ok.

> 
>> +	*val = tmpval;
>> +
>> +	return tmpval;
> 
> return zero or the i2c_master error code.
Ok.

> 
>> +}
>> +
>> +static int ov5645_set_aec_mode(struct ov5645 *ov5645, u32 mode)
>> +{
>> +	u8 val;
>> +
>> +	ov5645_read_reg(ov5645, OV5645_AEC_PK_MANUAL, &val);
>> +	if (mode == V4L2_EXPOSURE_AUTO) {
>> +		val |= OV5645_AEC_MANUAL_ENABLE;
>> +	} else { /* V4L2_EXPOSURE_MANUAL */
> 
> wrong comment, just remove it
The comment is actually correct but the code is not... I'll fix it.

> 
>> +		val &= ~OV5645_AEC_MANUAL_ENABLE;
>> +	}
>> +
>> +	dev_dbg(ov5645->dev, "%s: mode = %d\n", __func__, mode);
>> +
>> +	return ov5645_write_reg(ov5645, OV5645_AEC_PK_MANUAL, val);
>> +}
>> +
>> +static int ov5645_set_agc_mode(struct ov5645 *ov5645, u32 enable)
>> +{
>> +	u8 val;
>> +
>> +	ov5645_read_reg(ov5645, OV5645_AEC_PK_MANUAL, &val);
>> +	if (!enable)
>> +		val |= OV5645_AGC_MANUAL_ENABLE;
>> +	else
>> +		val &= ~OV5645_AGC_MANUAL_ENABLE;
>> +
>> +	dev_dbg(ov5645->dev, "%s: enable = %d\n", __func__, enable);
>> +
>> +	return ov5645_write_reg(ov5645, OV5645_AEC_PK_MANUAL, val);
>> +}
>> +
>> +static int ov5645_set_register_array(struct ov5645 *ov5645,
>> +				     struct reg_value *settings,
>> +				     s32 num_settings)
> 
> unsigned int num_settings
u32?

> 
>> +{
>> +	register u16 reg = 0;
> 
> 'register' ? The compiler is smart enough.
Ok.

> 
>> +	register u8 val = 0;
> 
> no need to init val variable
Ok.

> 
>> +	int i, ret = 0;
> 
> unsigned int i
Ok.

> 
>> +
>> +	for (i = 0; i < num_settings; ++i, ++settings) {
>> +		reg = settings->reg;
>> +		val = settings->val;
>> +
>> +		ret = ov5645_write_reg(ov5645, reg, val);
>> +		if (ret < 0)
>> +			goto err;
>> +	}
>> +err:
>> +	return ret;
>> +}
>> +
>> +static int ov5645_init(struct ov5645 *ov5645)
>> +{
>> +	struct reg_value *settings = NULL;
>> +	int num_settings = 0;
> 
> no need to initialize *settings and num_settings variables
Ok.

> 
>> +	int ret;
>> +
>> +	settings = ov5645_global_init_setting;
>> +	num_settings = ARRAY_SIZE(ov5645_global_init_setting);
>> +	ret = ov5645_set_register_array(ov5645, settings, num_settings);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov5645_change_mode(struct ov5645 *ov5645, enum ov5645_mode mode)
>> +{
>> +	struct reg_value *settings = NULL;
>> +	s32 num_settings = 0;
>> +	int ret = 0;
>> +
>> +	settings = ov5645_mode_info_data[mode].init_data_ptr;
>> +	num_settings = ov5645_mode_info_data[mode].init_data_size;
>> +	ret = ov5645_set_register_array(ov5645, settings, num_settings);
>> +
>> +	return ret;
>> +}
>> +
>> +static void __ov5645_set_power(struct ov5645 *ov5645, bool on)
> 
> I personally do not like __* prefix for functions in drivers.
Ok.

> 
>> +{
>> +	dev_dbg(ov5645->dev, "%s: on = %d\n", __func__, on);
>> +
>> +	if (on) {
>> +		clk_prepare_enable(ov5645->xclk);
>> +		ov5645_regulators_enable(ov5645);
> 
> check for errors, please.
Ok.

> 
>> +		usleep_range(5000, 15000);
>> +		if (ov5645->pwdn_gpio)
>> +			gpio_set_value(ov5645->pwdn_gpio, 1);
>> +		usleep_range(1000, 2000);
>> +		if (ov5645->rst_gpio)
>> +			gpio_set_value(ov5645->rst_gpio, 1);
>> +		msleep(20);
>> +	} else {
>> +		if (ov5645->rst_gpio)
>> +			gpio_set_value(ov5645->rst_gpio, 0);
>> +		if (ov5645->pwdn_gpio)
>> +			gpio_set_value(ov5645->pwdn_gpio, 0);
>> +		ov5645_regulators_disable(ov5645);
>> +		clk_disable_unprepare(ov5645->xclk);
>> +	}
>> +}
>> +
> 
> <cut>
> 
>> +
>> +static int ov5645_probe(struct i2c_client *client,
>> +			const struct i2c_device_id *id)
>> +{
>> +	struct device *dev = &client->dev;
>> +	struct device_node *endpoint;
>> +	struct ov5645 *ov5645;
>> +	int ret = 0;
>> +
>> +	ov5645 = devm_kzalloc(dev, sizeof(struct ov5645), GFP_KERNEL);
>> +	if (!ov5645)
>> +		return -ENOMEM;
>> +
>> +	ov5645->i2c_client = client;
>> +	ov5645->dev = dev;
>> +	ov5645->fmt.code = MEDIA_BUS_FMT_UYVY8_2X8;
>> +	ov5645->fmt.width = 1920;
>> +	ov5645->fmt.height = 1080;
>> +	ov5645->fmt.field = V4L2_FIELD_NONE;
>> +	ov5645->current_mode = ov5645_mode_1080p_1920_1080;
>> +
>> +	endpoint = of_graph_get_next_endpoint(dev->of_node, NULL);
>> +	if (!endpoint) {
>> +		dev_err(dev, "endpoint node not found\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	v4l2_of_parse_endpoint(endpoint, &ov5645->ep);
> 
> check for errors?
Ok.

> 
>> +	if (ov5645->ep.bus_type != V4L2_MBUS_CSI2) {
>> +		dev_err(dev, "invalid bus type, must be CSI2\n");
>> +		of_node_put(endpoint);
>> +		return -EINVAL;
>> +	}
>> +	of_node_put(endpoint);
>> +
>> +	/* get system clock (xclk) frequency */
>> +	ret = of_property_read_u32(dev->of_node, "clock-rates",
>> +				   &ov5645->xclk_freq);
>> +	if (!ret) {
>> +		if (ov5645->xclk_freq < OV5645_XCLK_MIN ||
>> +		    ov5645->xclk_freq > OV5645_XCLK_MAX) {
>> +			dev_err(dev, "invalid xclk frequency: %d\n",
>> +				ov5645->xclk_freq);
>> +			return -EINVAL;
> 
> why not just clamp the xclk_freq, and contunue ...
I'm going to change this to use assigned-clock-rates instead so
this will be removed.

> 
>> +		}
>> +	}
>> +
>> +	/* get system clock (xclk) */
>> +	ov5645->xclk = devm_clk_get(dev, "xclk");
>> +	if (IS_ERR(ov5645->xclk)) {
>> +		dev_err(dev, "could not get xclk");
>> +		return -EINVAL;
> 
> just return the error from devm_clk_get
Ok.

> 
>> +	}
>> +	clk_set_rate(ov5645->xclk, ov5645->xclk_freq);
> 
> set rate can fail, check the error code
Removing this as rate will be handled with assigned-clock-rates in dt.

> 
>> +
>> +	ov5645_regulators_get(ov5645);
> 
> check for errors.
Ok.
> 
>> +
>> +	ret = of_get_named_gpio(dev->of_node, "reset-gpio", 0);
> 
> use the right api for gpios devm_gpiod_get here and below.
Ok.

> 
>> +	if (!gpio_is_valid(ret)) {
>> +		dev_dbg(dev, "no reset pin available\n");
>> +		ov5645->rst_gpio = 0;
>> +	} else {
>> +		ov5645->rst_gpio = ret;
>> +	}
>> +
>> +	if (ov5645->rst_gpio) {
>> +		ret = devm_gpio_request_one(dev, ov5645->rst_gpio,
>> +			GPIOF_OUT_INIT_LOW, "ov5645-reset");
>> +		if (ret < 0) {
>> +			dev_err(dev, "could not request reset gpio\n");
>> +			return ret;
>> +		}
>> +	}
> 
> regards,
> Stan
> 

-- 
Best regards,
Todor Tomov
