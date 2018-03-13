Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36783 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932735AbeCMLQi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 07:16:38 -0400
Received: by mail-wr0-f196.google.com with SMTP id d10so9025755wrf.3
        for <linux-media@vger.kernel.org>; Tue, 13 Mar 2018 04:16:38 -0700 (PDT)
References: <20180228152723.26392-1-rui.silva@linaro.org> <20180228152723.26392-3-rui.silva@linaro.org> <20180309092153.psb5zcs53brlrrep@paasikivi.fi.intel.com>
From: Rui Miguel Silva <rui.silva@linaro.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Rui Miguel Silva <rui.silva@linaro.org>, mchehab@kernel.org,
        hverkuil@xs4all.nl, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ryan Harkin <ryan.harkin@linaro.org>
Subject: Re: [PATCH v2 2/2] media: ov2680: Add Omnivision OV2680 sensor driver
In-reply-to: <20180309092153.psb5zcs53brlrrep@paasikivi.fi.intel.com>
Date: Tue, 13 Mar 2018 11:16:33 +0000
Message-ID: <m3r2ootecu.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,
Thanks for the review...

On Fri 09 Mar 2018 at 09:21, Sakari Ailus wrote:
> Hi Miguel,
>
> Thanks for the update.
>
> On Wed, Feb 28, 2018 at 03:27:23PM +0000, Rui Miguel Silva 
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
>>  drivers/media/i2c/Kconfig  |   12 +
>>  drivers/media/i2c/Makefile |    1 +
>>  drivers/media/i2c/ov2680.c | 1094 
>>  ++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 1107 insertions(+)
>>  create mode 100644 drivers/media/i2c/ov2680.c
>> 
>> diff --git a/drivers/media/i2c/Kconfig 
>> b/drivers/media/i2c/Kconfig
>> index 9f18cd296841..39dc9f236ffa 100644
>> --- a/drivers/media/i2c/Kconfig
>> +++ b/drivers/media/i2c/Kconfig
>> @@ -586,6 +586,18 @@ config VIDEO_OV2659
>>  	  To compile this driver as a module, choose M here: the
>>  	  module will be called ov2659.
>>  
>> +config VIDEO_OV2680
>> +	tristate "OmniVision OV2680 sensor support"
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
>> index 000000000000..78f2be27a8f5
>> --- /dev/null
>> +++ b/drivers/media/i2c/ov2680.c
>> @@ -0,0 +1,1094 @@
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
>> +#include <linux/gpio/consumer.h>
>> +
>> +#include <media/v4l2-common.h>
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-subdev.h>
>> +
>> +#define OV2680_XVCLK_MIN	6000000
>> +#define OV2680_XVCLK_MAX	24000000
>> +
>> +#define OV2680_CHIP_ID		0x2680
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
>> +#define OV2680_REG_TIMING_HTS		0x380c
>> +#define OV2680_REG_TIMING_VTS		0x380e
>> +#define OV2680_REG_FORMAT1		0x3820
>> +#define OV2680_REG_FORMAT2		0x3821
>> +
>> +#define OV2680_REG_ISP_CTRL00		0x5080
>> +
>> +#define OV2680_FRAME_RATE		30
>> +
>> +#define OV2680_REG_VALUE_8BIT		1
>> +#define OV2680_REG_VALUE_16BIT		2
>> +#define OV2680_REG_VALUE_24BIT		3
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
>> +	const struct ov2680_mode_info	*current_mode;
>> +};
>> +
>> +static const char * const test_pattern_menu[] = {
>> +	"Disabled",
>> +	"Color Bars",
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
>> +ov2680_mode_data[OV2680_MODE_MAX] = {
>> +	{"mode_quxga_800_600", OV2680_MODE_QUXGA_800_600,
>> +	800, 600, ov2680_setting_30fps_QUXGA_800_600,
>
> Could you align this just right of the opening brace on the 
> previous line?
> The same for the rest of the struct. Using field names or a 
> macro might be
> used to make this more pretty, I'm fine with just fixing 
> indentation
> though.

sure, indentation will be fix, thanks for notice this

>
>> +	ARRAY_SIZE(ov2680_setting_30fps_QUXGA_800_600)},
>> +	{"mode_720p_1280_720", OV2680_MODE_720P_1280_720,
>> +	 1280, 720, ov2680_setting_30fps_720P_1280_720,
>> +	 ARRAY_SIZE(ov2680_setting_30fps_720P_1280_720)},
>> +	{"mode_uxga_1600_1200", OV2680_MODE_UXGA_1600_1200,
>> +	1600, 1200, ov2680_setting_30fps_UXGA_1600_1200,
>> +	 ARRAY_SIZE(ov2680_setting_30fps_UXGA_1600_1200)},
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
>> +static int __ov2680_write_reg(struct ov2680_dev *sensor, u16 
>> reg,
>> +			      unsigned int len, u32 val)
>> +{
>> +	struct i2c_client *client = sensor->i2c_client;
>> +	struct i2c_msg msg;
>> +	__be32 val_be32;
>> +	u8 *val_p;
>> +	u8 buf[6];
>> +	int ret;
>> +	int i = 0;
>> +
>> +	buf[0] = reg >> 8;
>> +	buf[1] = reg & 0xff;
>> +
>> +	val_be32 = cpu_to_be32(val);
>> +	val_p = (u8 *)&val_be32;
>> +
>> +	while (i < len) {
>> +		buf[2 + i] = val_p[(4 - len) + i];
>> +		i++;
>> +	}
>> +
>> +	msg.addr = client->addr;
>> +	msg.flags = client->flags;
>> +	msg.buf = buf;
>> +	msg.len = 2 + len;
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
>> +#define ov2680_write_reg(s, r, v) \
>> +	__ov2680_write_reg(s, r, OV2680_REG_VALUE_8BIT, v);
>> +
>> +#define ov2680_write_reg16(s, r, v) \
>> +	__ov2680_write_reg(s, r, OV2680_REG_VALUE_16BIT, v);
>> +
>> +#define ov2680_write_reg24(s, r, v) \
>> +	__ov2680_write_reg(s, r, OV2680_REG_VALUE_24BIT, v);
>> +
>> +static int __ov2680_read_reg(struct ov2680_dev *sensor, u16 
>> reg,
>> +			     unsigned int len, u32 *val)
>> +{
>> +	struct i2c_client *client = sensor->i2c_client;
>> +	struct i2c_msg msg[2];
>> +	__be32 data_be = 0;
>> +	u8 *data_be_p;
>> +	u8 buf[2];
>> +	int ret;
>> +
>> +	buf[0] = reg >> 8;
>> +	buf[1] = reg & 0xff;
>
> You could assign in variable declaration.
>
> Could you check my comments on the imx258 driver as well as the
> implementation of the similar functions in that driver?
>
> <URL:https://patchwork.linuxtv.org/patch/47768/>

V3 will have a new implementation of this functions based on this.

>
>> +
>> +	data_be_p = (u8 *)&data_be;
>> +
>> +	msg[0].addr = client->addr;
>> +	msg[0].flags = client->flags;
>> +	msg[0].buf = buf;
>> +	msg[0].len = sizeof(buf);
>> +
>> +	msg[1].addr = client->addr;
>> +	msg[1].flags = client->flags | I2C_M_RD;
>> +	msg[1].buf = &data_be_p[4 - len];
>> +	msg[1].len = len;
>> +
>> +	ret = i2c_transfer(client->adapter, msg, ARRAY_SIZE(msg));
>> +	if (ret < 0) {
>> +		dev_err(&client->dev, "read error: reg=0x%4x: 
>> %d\n", reg, ret);
>> +		return ret;
>> +	}
>> +
>> +	*val = be32_to_cpu(data_be);
>> +
>> +	return 0;
>> +}
>> +
>> +#define ov2680_read_reg(s, r, v) \
>> +	__ov2680_read_reg(s, r, OV2680_REG_VALUE_8BIT, v);
>> +
>> +#define ov2680_read_reg16(s, r, v) \
>> +	__ov2680_read_reg(s, r, OV2680_REG_VALUE_16BIT, v);
>> +
>> +#define ov2680_read_reg24(s, r, v) \
>> +	__ov2680_read_reg(s, r, OV2680_REG_VALUE_24BIT, v);
>> +
>> +static int ov2680_mod_reg(struct ov2680_dev *sensor, u16 reg, 
>> u8 mask, u8 val)
>> +{
>> +	u32 readval;
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
>> +static int ov2680_vflip_enable(struct ov2680_dev *sensor)
>> +{
>> +	return ov2680_mod_reg(sensor, OV2680_REG_FORMAT1, BIT(2), 
>> BIT(2));
>
> vflip and hflip controls change the pixel order on raw sensors. 
> Please
> either address that in the pixel order or disable the controls. 
> The flip
> controls also can't change during streaming in practice.

I will handle bayer order based on mirror and flip order and the
streaming part.

>
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
>> +	u32 gain;
>> +	int ret;
>> +
>> +	ret = ov2680_mod_reg(sensor, OV2680_REG_R_MANUAL, BIT(1),
>> +			     auto_gain ? 0 : BIT(1));
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	if (auto_gain || !ctrls->gain->is_new)
>> +		return 0;
>> +
>> +	gain = ctrls->gain->val;
>> +
>> +	ret = ov2680_write_reg16(sensor, OV2680_REG_GAIN_PK, 
>> gain);
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov2680_gain_get(struct ov2680_dev *sensor)
>> +{
>> +	u32 gain;
>> +	int ret;
>> +
>> +	ret = ov2680_read_reg16(sensor, OV2680_REG_GAIN_PK, 
>> &gain);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return gain;
>> +}
>> +
>> +static int ov2680_auto_gain_enable(struct ov2680_dev *sensor)
>> +{
>> +	return ov2680_gain_set(sensor, true);
>
> Just call ov2780_gain_set() in the caller.

Here if you do not mind I would like to have it this way, on the 
caller
side makes explicit that we are disabling/enabling the auto gain,
instead of going and search what that bool parameter means.

but, if you do mind... ;)

>
>> +}
>> +
>> +static int ov2680_auto_gain_disable(struct ov2680_dev *sensor)
>> +{
>> +	return ov2680_gain_set(sensor, false);
>
> Ditto.
>

Ditto.

>> +}
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
>> +	if (auto_exp || !ctrls->exposure->is_new)
>> +		return 0;
>> +
>> +	exp = (u32)ctrls->exposure->val;
>> +	exp <<= 4;
>> +
>> +	return ov2680_write_reg24(sensor, 
>> OV2680_REG_EXPOSURE_PK_HIGH, exp);
>> +}
>> +
>> +static int ov2680_exposure_get(struct ov2680_dev *sensor)
>> +{
>> +	int ret;
>> +	u32 exp;
>> +
>> +	ret = ov2680_read_reg24(sensor, 
>> OV2680_REG_EXPOSURE_PK_HIGH, &exp);
>> +	if (ret)
>> +		return ret;
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
>> +static int ov2680_mode_set(struct ov2680_dev *sensor)
>> +{
>> +	struct ov2680_ctrls *ctrls = &sensor->ctrls;
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
>> +	ret = ov2680_load_regs(sensor, sensor->current_mode);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	if (ctrls->auto_gain->val) {
>> +		ret = ov2680_auto_gain_enable(sensor);
>> +		if (ret < 0)
>> +			return ret;
>> +	}
>> +
>> +	if (ctrls->auto_exp->val == V4L2_EXPOSURE_AUTO) {
>> +		ret = ov2680_auto_exposure_enable(sensor);
>> +		if (ret < 0)
>> +			return ret;
>> +	}
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
>> +static int ov2680_power_off(struct ov2680_dev *sensor)
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
>> +static int ov2680_power_on(struct ov2680_dev *sensor)
>> +{
>> +	struct device *dev = ov2680_to_dev(sensor);
>> +	int ret;
>> +
>> +	if (sensor->is_enabled)
>> +		return 0;
>> +
>> +	if (!sensor->pwdn_gpio) {
>> +		ret = ov2680_write_reg(sensor, 
>> OV2680_REG_SOFT_RESET, 0x01);
>> +		if (ret != 0) {
>> +			dev_err(dev, "sensor soft reset 
>> failed\n");
>> +			return ret;
>> +		}
>> +		usleep_range(1000, 2000);
>> +	} else {
>> +
>> +		ov2680_power_down(sensor);
>> +		ov2680_power_up(sensor);
>> +	}
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
>> +	ov2680_power_off(sensor);
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
>> +		ret = ov2680_power_on(sensor);
>> +	else
>> +		ret = ov2680_power_off(sensor);
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
>> +static int ov2680_s_g_frame_interval(struct v4l2_subdev *sd,
>> +				     struct 
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
>> +	mode = v4l2_find_nearest_size(ov2680_mode_data,
>> + 
>> ARRAY_SIZE(ov2680_mode_data), width,
>> +				      height, fmt->width, 
>> fmt->height);
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
>> +	fse->min_width = ov2680_mode_data[index].width;
>> +	fse->min_height = ov2680_mode_data[index].height;
>> +	fse->max_width = ov2680_mode_data[index].width;
>> +	fse->max_height = ov2680_mode_data[index].height;
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov2680_enum_frame_interval(struct v4l2_subdev *sd,
>> +			      struct v4l2_subdev_pad_config *cfg,
>> +			      struct 
>> v4l2_subdev_frame_interval_enum *fie)
>> +{
>> +	struct v4l2_fract tpf;
>> +
>> +	tpf.denominator = OV2680_FRAME_RATE;
>> +	tpf.numerator = 1;
>> +
>> +	fie->interval = tpf;
>> +
>> +	return 0;
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
>> +	.g_frame_interval	= ov2680_s_g_frame_interval,
>> +	.s_frame_interval	= ov2680_s_g_frame_interval,
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
>> +	sensor->frame_interval.denominator = OV2680_FRAME_RATE;
>> +	sensor->frame_interval.numerator = 1;
>> +
>> +	init_mode = &ov2680_mode_init_data;
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
>> +	if (hdl->error) {
>> +		ret = hdl->error;
>> +		goto cleanup_entity;
>> +	}
>> +
>> +	ctrls->gain->flags |= V4L2_CTRL_FLAG_VOLATILE;
>> +	ctrls->exposure->flags |= V4L2_CTRL_FLAG_VOLATILE;
>> +
>> +	v4l2_ctrl_auto_cluster(2, &ctrls->auto_gain, 0, true);
>> +	v4l2_ctrl_auto_cluster(2, &ctrls->auto_exp, 1, true);
>> +
>> +	sensor->sd.ctrl_handler = hdl;
>> +
>> +	ret = v4l2_async_register_subdev(&sensor->sd);
>> +	if (ret < 0)
>> +		goto cleanup_entity;
>> +
>> +	return 0;
>> +
>> +cleanup_entity:
>> +	media_entity_cleanup(&sensor->sd.entity);
>> +	v4l2_ctrl_handler_free(hdl);
>> +
>> +	return ret;
>> +}
>> +
>> +static int ov2680_check_id(struct ov2680_dev *sensor)
>> +{
>> +	struct device *dev = ov2680_to_dev(sensor);
>> +	u32 chip_id;
>> +	int ret;
>> +
>> +	ov2680_power_on(sensor);
>> +
>> +	ret = ov2680_read_reg16(sensor, OV2680_REG_CHIP_ID_HIGH, 
>> &chip_id);
>> +	if (ret < 0) {
>> +		dev_err(dev, "failed to read chip id high\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	if (chip_id != OV2680_CHIP_ID) {
>> +		dev_err(dev, "chip id: 0x%04x does not match 
>> expected 0x%04x\n",
>> +			chip_id, OV2680_CHIP_ID);
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
>> +	ret = ov2680_check_id(sensor);
>> +	if (ret < 0)
>
> You'll need to free the control handler here, at least. Please 
> add a new
> label for that.

Ack.

>
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
>
> You can remove the i2c_device_id table if you use the probe_new 
> callback
> (instead of probe) below.

Well this one was hard to debug, so removing the device id table 
made
the module not to be auto loaded, and after some debug I found the 
root
cause and it looks it is addressed by this [0]. With that patch 
removing
the device_id and use probe_new works as expected.

I will be sending v3 soon.

---
Cheers,
	Rui

[0] https://patchwork.kernel.org/patch/10089425/
>
