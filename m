Return-path: <linux-media-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.133]:59463 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753379AbeAIOxA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Jan 2018 09:53:00 -0500
Reply-To: zhengsq@rock-chips.com
Subject: Re: [PATCH v3 1/4] media: ov5695: add support for OV5695 sensor
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        ddl@rock-chips.com, tfiga@chromium.org
References: <1515418567-14406-1-git-send-email-zhengsq@rock-chips.com>
 <20180108222022.4hvo7pax4wunnf22@valkosipuli.retiisi.org.uk>
From: Shunqian Zheng <zhengsq@rock-chips.com>
Message-ID: <c4e639fc-7650-5f00-3e70-8f2bd37f1262@rock-chips.com>
Date: Tue, 9 Jan 2018 22:52:30 +0800
MIME-Version: 1.0
In-Reply-To: <20180108222022.4hvo7pax4wunnf22@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,


On 2018年01月09日 06:20, Sakari Ailus wrote:
> Hi Shunqian,
>
> Could you next time add a cover page to the patchset that details the
> changes from the previous version?
>
> Please also add a MAINTAINERS entry. DT binding files should also precede
> the driver.
Done.
By the way, why DT binding files should precede the driver?
>
> On Mon, Jan 08, 2018 at 09:36:04PM +0800, Shunqian Zheng wrote:
>> This patch adds driver for Omnivision's ov5695 sensor,
>> the driver supports following features:
>>   - supported resolutions
>>     + 2592x1944 at 30fps
>>     + 1920x1080 at 30fps
>>     + 1296x972 at 60fps
>>     + 1280x720 at 30fps
>>     + 640x480 at 120fps
>>   - test patterns
>>   - manual exposure/gain(analog and digital) control
>>   - vblank and hblank
>>   - media controller
>>   - runtime pm
>>
>> Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
>> ---
>>   drivers/media/i2c/Kconfig  |   11 +
>>   drivers/media/i2c/Makefile |    1 +
>>   drivers/media/i2c/ov5695.c | 1392 ++++++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 1404 insertions(+)
>>   create mode 100644 drivers/media/i2c/ov5695.c
>>
>> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
>> index 3c6d642..55b37c8 100644
>> --- a/drivers/media/i2c/Kconfig
>> +++ b/drivers/media/i2c/Kconfig
>> @@ -645,6 +645,17 @@ config VIDEO_OV5670
>>   	  To compile this driver as a module, choose M here: the
>>   	  module will be called ov5670.
>>   
>> +config VIDEO_OV5695
>> +	tristate "OmniVision OV5695 sensor support"
>> +	depends on I2C && VIDEO_V4L2
>> +	depends on MEDIA_CAMERA_SUPPORT
>> +	---help---
>> +	  This is a Video4Linux2 sensor-level driver for the OmniVision
>> +	  OV5695 camera.
>> +
>> +	  To compile this driver as a module, choose M here: the
>> +	  module will be called ov5695.
>> +
>>   config VIDEO_OV7640
>>   	tristate "OmniVision OV7640 sensor support"
>>   	depends on I2C && VIDEO_V4L2
>> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
>> index 548a9ef..a063030 100644
>> --- a/drivers/media/i2c/Makefile
>> +++ b/drivers/media/i2c/Makefile
>> @@ -65,6 +65,7 @@ obj-$(CONFIG_VIDEO_OV5640) += ov5640.o
>>   obj-$(CONFIG_VIDEO_OV5645) += ov5645.o
>>   obj-$(CONFIG_VIDEO_OV5647) += ov5647.o
>>   obj-$(CONFIG_VIDEO_OV5670) += ov5670.o
>> +obj-$(CONFIG_VIDEO_OV5695) += ov5695.o
>>   obj-$(CONFIG_VIDEO_OV6650) += ov6650.o
>>   obj-$(CONFIG_VIDEO_OV7640) += ov7640.o
>>   obj-$(CONFIG_VIDEO_OV7670) += ov7670.o
>> diff --git a/drivers/media/i2c/ov5695.c b/drivers/media/i2c/ov5695.c
>> new file mode 100644
>> index 0000000..7e8bd82
>> --- /dev/null
>> +++ b/drivers/media/i2c/ov5695.c
>> @@ -0,0 +1,1392 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * ov5695 driver
>> + *
>> + * Copyright (C) 2017 Fuzhou Rockchip Electronics Co., Ltd.
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/device.h>
>> +#include <linux/delay.h>
>> +#include <linux/gpio/consumer.h>
>> +#include <linux/i2c.h>
>> +#include <linux/module.h>
>> +#include <linux/pm_runtime.h>
>> +#include <linux/regulator/consumer.h>
>> +#include <linux/sysfs.h>
>> +#include <media/media-entity.h>
>> +#include <media/v4l2-async.h>
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-subdev.h>
>> +
>> +#ifndef V4L2_CID_DIGITAL_GAIN
>> +#define V4L2_CID_DIGITAL_GAIN		V4L2_CID_GAIN
>> +#endif
>> +
>> +/* 45Mhz * 4 Binning */
>> +#define OV5695_PIXEL_RATE		(45 * 1000 * 1000 * 4)
>> +#define CHIP_ID				0x005695
>> +#define OV5695_REG_CHIP_ID		0x300a
>> +
>> +#define OV5695_REG_CTRL_MODE		0x0100
>> +#define OV5695_MODE_SW_STANDBY		0x0
>> +#define OV5695_MODE_STREAMING		BIT(0)
>> +
>> +#define OV5695_REG_EXPOSURE		0x3500
>> +#define	OV5695_EXPOSURE_MIN		4
>> +#define	OV5695_EXPOSURE_STEP		1
>> +#define OV5695_VTS_MAX			0x7fff
>> +
>> +#define OV5695_REG_ANALOG_GAIN		0x3509
>> +#define	ANALOG_GAIN_MIN			0x10
>> +#define	ANALOG_GAIN_MAX			0xf8
>> +#define	ANALOG_GAIN_STEP		1
>> +#define	ANALOG_GAIN_DEFAULT		0xf8
>> +
>> +#define OV5695_REG_DIGI_GAIN_H		0x350a
>> +#define OV5695_REG_DIGI_GAIN_L		0x350b
>> +#define OV5695_DIGI_GAIN_L_MASK		0x3f
>> +#define OV5695_DIGI_GAIN_H_SHIFT	6
>> +#define OV5695_DIGI_GAIN_MIN		0
>> +#define OV5695_DIGI_GAIN_MAX		(0x4000 - 1)
>> +#define OV5695_DIGI_GAIN_STEP		1
>> +#define OV5695_DIGI_GAIN_DEFAULT	1024
>> +
>> +#define OV5695_REG_TEST_PATTERN		0x4503
>> +#define	OV5695_TEST_PATTERN_ENABLE	0x80
>> +#define	OV5695_TEST_PATTERN_DISABLE	0x0
>> +
>> +#define OV5695_REG_VTS			0x380e
>> +
>> +#define REG_NULL			0xFFFF
>> +
>> +#define OV5695_REG_VALUE_08BIT		1
>> +#define OV5695_REG_VALUE_16BIT		2
>> +#define OV5695_REG_VALUE_24BIT		3
>> +
>> +#define OV5695_LANES			2
>> +#define OV5695_BITS_PER_SAMPLE		10
>> +
>> +struct regval {
>> +	u16 addr;
>> +	u8 val;
>> +};
>> +
>> +struct ov5695_mode {
>> +	u32 width;
>> +	u32 height;
>> +	u32 max_fps;
>> +	u32 hts_def;
>> +	u32 vts_def;
>> +	u32 exp_def;
>> +	const struct regval *reg_list;
>> +};
>> +
>> +struct ov5695 {
>> +	struct i2c_client	*client;
>> +	struct clk		*xvclk;
>> +	struct regulator        *avdd_regulator;
>> +	struct regulator        *dovdd_regulator;
>> +	struct regulator        *dvdd_regulator;
>> +	struct gpio_desc	*reset_gpio;
>> +
>> +	struct v4l2_subdev	subdev;
>> +	struct media_pad	pad;
>> +	struct v4l2_ctrl_handler ctrl_handler;
>> +	struct v4l2_ctrl	*exposure;
>> +	struct v4l2_ctrl	*anal_gain;
>> +	struct v4l2_ctrl	*digi_gain;
>> +	struct v4l2_ctrl	*hblank;
>> +	struct v4l2_ctrl	*vblank;
>> +	struct v4l2_ctrl	*test_pattern;
>> +	struct mutex		mutex;
>> +	bool			streaming;
>> +	const struct ov5695_mode *cur_mode;
>> +};
>> +
>> +#define to_ov5695(sd) container_of(sd, struct ov5695, subdev)
>> +
<snip>
>> +
>> +#define OV5695_LINK_FREQ_420MHZ		420000000
>> +static const s64 link_freq_menu_items[] = {
>> +	OV5695_LINK_FREQ_420MHZ
>> +};
>> +
>> +static const char * const ov5695_test_pattern_menu[] = {
>> +	"Disabled",
>> +	"Vertical Color Bar Type 1",
>> +	"Vertical Color Bar Type 2",
>> +	"Vertical Color Bar Type 3",
>> +	"Vertical Color Bar Type 4"
>> +};
>> +
>> +/* Write registers up to 4 at a time */
>> +static int ov5695_write_reg(struct i2c_client *client, u16 reg,
>> +			    u32 len, u32 val)
>> +{
>> +	u32 buf_i, val_i;
>> +	u8 buf[6];
>> +	u8 *val_p;
>> +	__be32 val_be;
>> +
>> +	if (len > 4)
>> +		return -EINVAL;
>> +
>> +	buf[0] = reg >> 8;
>> +	buf[1] = reg & 0xff;
>> +
>> +	val_be = cpu_to_be32(val);
>> +	val_p = (u8 *)&val_be;
>> +	buf_i = 2;
>> +	val_i = 4 - len;
>> +
>> +	while (val_i < 4)
>> +		buf[buf_i++] = val_p[val_i++];
>> +
>> +	if (i2c_master_send(client, buf, len + 2) != len + 2)
>> +		return -EIO;
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov5695_write_array(struct i2c_client *client,
>> +			      const struct regval *regs)
>> +{
>> +	u32 i;
>> +	int ret = 0;
>> +
>> +	for (i = 0; ret == 0 && regs[i].addr != REG_NULL; i++)
>> +		ret = ov5695_write_reg(client, regs[i].addr,
>> +				       OV5695_REG_VALUE_08BIT, regs[i].val);
>> +
>> +	return ret;
>> +}
>> +
>> +/* Read registers up to 4 at a time */
>> +static int ov5695_read_reg(struct i2c_client *client, u16 reg, unsigned int len,
>> +			   u32 *val)
>> +{
>> +	struct i2c_msg msgs[2];
>> +	u8 *data_be_p;
>> +	__be32 data_be = 0;
>> +	__be16 reg_addr_be = cpu_to_be16(reg);
>> +	int ret;
>> +
>> +	if (len > 4)
>> +		return -EINVAL;
>> +
>> +	data_be_p = (u8 *)&data_be;
>> +	/* Write register address */
>> +	msgs[0].addr = client->addr;
>> +	msgs[0].flags = 0;
>> +	msgs[0].len = 2;
>> +	msgs[0].buf = (u8 *)&reg_addr_be;
>> +
>> +	/* Read data from register */
>> +	msgs[1].addr = client->addr;
>> +	msgs[1].flags = I2C_M_RD;
>> +	msgs[1].len = len;
>> +	msgs[1].buf = &data_be_p[4 - len];
>> +
>> +	ret = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
>> +	if (ret != ARRAY_SIZE(msgs))
>> +		return -EIO;
>> +
>> +	*val = be32_to_cpu(data_be);
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov5695_get_reso_dist(const struct ov5695_mode *mode,
>> +				struct v4l2_mbus_framefmt *framefmt)
>> +{
>> +	return abs(mode->width - framefmt->width) +
>> +	       abs(mode->height - framefmt->height);
>> +}
>> +
>> +static const struct ov5695_mode *
>> +ov5695_find_best_fit(struct v4l2_subdev_format *fmt)
>> +{
>> +	struct v4l2_mbus_framefmt *framefmt = &fmt->format;
>> +	int dist;
>> +	int cur_best_fit = 0;
>> +	int cur_best_fit_dist = -1;
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(supported_modes); i++) {
>> +		dist = ov5695_get_reso_dist(&supported_modes[i], framefmt);
>> +		if (cur_best_fit_dist == -1 || dist < cur_best_fit_dist) {
>> +			cur_best_fit_dist = dist;
>> +			cur_best_fit = i;
>> +		}
>> +	}
>> +
>> +	return &supported_modes[cur_best_fit];
>> +}
>> +
>> +static int ov5695_set_fmt(struct v4l2_subdev *sd,
>> +			  struct v4l2_subdev_pad_config *cfg,
>> +			  struct v4l2_subdev_format *fmt)
>> +{
>> +	struct ov5695 *ov5695 = to_ov5695(sd);
>> +	const struct ov5695_mode *mode;
>> +	s64 h_blank, vblank_def;
>> +
>> +	mutex_lock(&ov5695->mutex);
>> +
>> +	mode = ov5695_find_best_fit(fmt);
>> +	fmt->format.code = MEDIA_BUS_FMT_SBGGR10_1X10;
>> +	fmt->format.width = mode->width;
>> +	fmt->format.height = mode->height;
>> +	fmt->format.field = V4L2_FIELD_NONE;
>> +	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
>> +#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
>> +		*v4l2_subdev_get_try_format(sd, cfg, fmt->pad) = fmt->format;
>> +#else
>> +		mutex_unlock(&ov5695->mutex);
>> +		return -ENOTTY;
>> +#endif
>> +	} else {
>> +		ov5695->cur_mode = mode;
>> +		h_blank = mode->hts_def - mode->width;
>> +		__v4l2_ctrl_modify_range(ov5695->hblank, h_blank,
>> +					 h_blank, 1, h_blank);
>> +		vblank_def = mode->vts_def - mode->height;
>> +		__v4l2_ctrl_modify_range(ov5695->vblank, vblank_def,
>> +					 OV5695_VTS_MAX - mode->height,
>> +					 1, vblank_def);
>> +	}
>> +
>> +	mutex_unlock(&ov5695->mutex);
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov5695_get_fmt(struct v4l2_subdev *sd,
>> +			  struct v4l2_subdev_pad_config *cfg,
>> +			  struct v4l2_subdev_format *fmt)
>> +{
>> +	struct ov5695 *ov5695 = to_ov5695(sd);
>> +	const struct ov5695_mode *mode = ov5695->cur_mode;
>> +
>> +	mutex_lock(&ov5695->mutex);
>> +	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
>> +#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
>> +		fmt->format = *v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
>> +#else
>> +		mutex_unlock(&ov5695->mutex);
>> +		return -ENOTTY;
>> +#endif
>> +	} else {
>> +		fmt->format.width = mode->width;
>> +		fmt->format.height = mode->height;
>> +		fmt->format.code = MEDIA_BUS_FMT_SBGGR10_1X10;
>> +		fmt->format.field = V4L2_FIELD_NONE;
>> +	}
>> +	mutex_unlock(&ov5695->mutex);
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov5695_enum_mbus_code(struct v4l2_subdev *sd,
>> +				 struct v4l2_subdev_pad_config *cfg,
>> +				 struct v4l2_subdev_mbus_code_enum *code)
>> +{
>> +	if (code->index != 0)
>> +		return -EINVAL;
>> +	code->code = MEDIA_BUS_FMT_SBGGR10_1X10;
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov5695_enum_frame_sizes(struct v4l2_subdev *sd,
>> +				   struct v4l2_subdev_pad_config *cfg,
>> +				   struct v4l2_subdev_frame_size_enum *fse)
>> +{
>> +	if (fse->index > ARRAY_SIZE(supported_modes))
>> +		return -EINVAL;
>> +
>> +	if (fse->code != MEDIA_BUS_FMT_SBGGR10_1X10)
>> +		return -EINVAL;
>> +
>> +	fse->min_width  = supported_modes[fse->index].width;
>> +	fse->max_width  = supported_modes[fse->index].width;
>> +	fse->max_height = supported_modes[fse->index].height;
>> +	fse->min_height = supported_modes[fse->index].height;
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov5695_enable_test_pattern(struct ov5695 *ov5695, u32 pattern)
>> +{
>> +	u32 val;
>> +
>> +	if (pattern)
>> +		val = (pattern - 1) | OV5695_TEST_PATTERN_ENABLE;
>> +	else
>> +		val = OV5695_TEST_PATTERN_DISABLE;
>> +
>> +	return ov5695_write_reg(ov5695->client, OV5695_REG_TEST_PATTERN,
>> +				OV5695_REG_VALUE_08BIT, val);
>> +}
>> +
>> +static int __ov5695_start_stream(struct ov5695 *ov5695)
>> +{
>> +	int ret;
>> +
>> +	ret = ov5695_write_array(ov5695->client, ov5695_global_regs);
>> +	if (ret)
>> +		return ret;
>> +	ret = ov5695_write_array(ov5695->client, ov5695->cur_mode->reg_list);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* In case these controls are set before streaming */
>> +	ret = __v4l2_ctrl_handler_setup(&ov5695->ctrl_handler);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return ov5695_write_reg(ov5695->client, OV5695_REG_CTRL_MODE,
>> +				OV5695_REG_VALUE_08BIT, OV5695_MODE_STREAMING);
>> +}
>> +
>> +static int __ov5695_stop_stream(struct ov5695 *ov5695)
>> +{
>> +	return ov5695_write_reg(ov5695->client, OV5695_REG_CTRL_MODE,
>> +				OV5695_REG_VALUE_08BIT, OV5695_MODE_SW_STANDBY);
>> +}
>> +
>> +static int ov5695_s_stream(struct v4l2_subdev *sd, int on)
>> +{
>> +	struct ov5695 *ov5695 = to_ov5695(sd);
>> +	struct i2c_client *client = ov5695->client;
>> +	int ret = 0;
>> +
>> +	mutex_lock(&ov5695->mutex);
>> +	on = !!on;
>> +	if (on == ov5695->streaming)
>> +		goto unlock_and_return;
>> +
>> +	if (on) {
>> +		ret = pm_runtime_get_sync(&client->dev);
>> +		if (ret < 0) {
>> +			pm_runtime_put_noidle(&client->dev);
>> +			goto unlock_and_return;
>> +		}
>> +
>> +		ret = __ov5695_start_stream(ov5695);
>> +		if (ret) {
>> +			v4l2_err(sd, "start stream failed while write regs\n");
>> +			pm_runtime_put(&client->dev);
>> +			goto unlock_and_return;
>> +		}
>> +	} else {
>> +		__ov5695_stop_stream(ov5695);
>> +		ret = pm_runtime_put(&client->dev);
>> +	}
>> +
>> +	ov5695->streaming = on;
>> +
>> +unlock_and_return:
>> +	mutex_unlock(&ov5695->mutex);
>> +
>> +	return ret;
>> +}
>> +
>> +/* Calculate the delay in us by clock rate and clock cycles */
>> +static inline u32 ov5695_cal_delay(struct ov5695 *ov5695, u32 cycles)
>> +{
>> +	return DIV_ROUND_UP(cycles, clk_get_rate(ov5695->xvclk) / 1000 / 1000);
> I think you should ensure you don't end up dividing by zero here. Your mode
> definitions are for a 24 MHz clock --- should the driver check for 24 MHz
> in probe perhaps? You could pass the frequency here.
Warn if the clk != 24MHz in .probe()
>
> Hmm. Perhaps a constant wouldn't be a bad idea either. It'd be good to use
> a #define for that though, so it's easy to figure out where it's used if
> someone later on adds support for different frequencies.
>
> E.g.
>
> #define OV6595_XCLK_FREQ	24000000
Done.
>
>> +}
>> +
>> +static int __ov5695_power_on(struct ov5695 *ov5695)
>> +{
>> +	int ret;
>> +	u32 delay_us;
>> +	struct device *dev = &ov5695->client->dev;
>> +
>> +	ret = clk_prepare_enable(ov5695->xvclk);
>> +	if (ret < 0) {
>> +		dev_err(dev, "Failed to enable xvclk\n");
>> +		return ret;
>> +	}
>> +
>> +	gpiod_set_value_cansleep(ov5695->reset_gpio, 1);
>> +
>> +	/* AVDD and DOVDD may rise in any order */
>> +	ret = regulator_enable(ov5695->avdd_regulator);
>> +	if (ret < 0) {
>> +		dev_err(dev, "Failed to enable regulator\n");
>> +		goto disable_clk;
>> +	}
>> +	ret = regulator_enable(ov5695->dovdd_regulator);
>> +	if (ret < 0) {
>> +		dev_err(dev, "Failed to enable DOVDD regulator\n");
>> +		goto disable_avdd;
>> +	}
>> +	/* DVDD must rise after AVDD and DOVDD */
>> +	ret = regulator_enable(ov5695->dvdd_regulator);
>> +	if (ret < 0) {
>> +		dev_err(dev, "Failed to enable DVDD regulator\n");
>> +		goto disable_dovdd;
>> +	}
> You could use regulator_bulk_enable(), too.
Done
>
>> +
>> +	gpiod_set_value_cansleep(ov5695->reset_gpio, 0);
>> +	/* 8192 cycles prior to first SCCB transaction */
>> +	delay_us = ov5695_cal_delay(ov5695, 8192);
>> +	usleep_range(delay_us, delay_us * 2);
>> +
>> +	return 0;
>> +
>> +disable_dovdd:
>> +	regulator_disable(ov5695->dovdd_regulator);
>> +disable_avdd:
>> +	regulator_disable(ov5695->avdd_regulator);
>> +disable_clk:
>> +	clk_disable_unprepare(ov5695->xvclk);
>> +
>> +	return ret;
>> +}
>> +
>> +static void __ov5695_power_off(struct ov5695 *ov5695)
>> +{
>> +	clk_disable_unprepare(ov5695->xvclk);
> I don't know the sensor but usually the clock is stopped after resetting
> the device. Not sure if that matters though.
 From the 'power down sequence', the clk is gated before shutting down 
the device.
It also can be in free running mode, so I think either of them is fine.
>
>> +	gpiod_set_value_cansleep(ov5695->reset_gpio, 1);
>> +	regulator_disable(ov5695->dvdd_regulator);
>> +	regulator_disable(ov5695->dovdd_regulator);
>> +	regulator_disable(ov5695->avdd_regulator);
> regulator_bulk_disable()?
Done.
>
>> +}
>> +
>> +static int ov5695_runtime_resume(struct device *dev)
>> +{
>> +	struct i2c_client *client = to_i2c_client(dev);
>> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
>> +	struct ov5695 *ov5695 = to_ov5695(sd);
>> +
>> +	return __ov5695_power_on(ov5695);
>> +}
>> +
>> +static int ov5695_runtime_suspend(struct device *dev)
>> +{
>> +	struct i2c_client *client = to_i2c_client(dev);
>> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
>> +	struct ov5695 *ov5695 = to_ov5695(sd);
>> +
>> +	__ov5695_power_off(ov5695);
>> +
>> +	return 0;
>> +}
>> +
>> +#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
>> +static int ov5695_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
>> +{
>> +	struct ov5695 *ov5695 = to_ov5695(sd);
>> +	struct v4l2_mbus_framefmt *try_fmt =
>> +				v4l2_subdev_get_try_format(sd, fh->pad, 0);
>> +
>> +	mutex_lock(&ov5695->mutex);
>> +	/* Initialize try_fmt */
>> +	try_fmt->width = ov5695->cur_mode->width;
>> +	try_fmt->height = ov5695->cur_mode->height;
> This should be the default resolution, not depedent on the sensor
> configuration.
Done. Set to supported_modes[0], because .probe() sets it as default.
>> +	try_fmt->code = MEDIA_BUS_FMT_SBGGR10_1X10;
>> +	try_fmt->field = V4L2_FIELD_NONE;
>> +
>> +	mutex_unlock(&ov5695->mutex);
>> +	/* No crop or compose */
>> +
>> +	return 0;
>> +}
>> +#endif
>> +
>> +static const struct dev_pm_ops ov5695_pm_ops = {
>> +	SET_RUNTIME_PM_OPS(ov5695_runtime_suspend,
>> +			   ov5695_runtime_resume, NULL)
>> +};
>> +
>> +#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
>> +static const struct v4l2_subdev_internal_ops ov5695_internal_ops = {
>> +	.open = ov5695_open,
>> +};
>> +#endif
>> +
>> +static const struct v4l2_subdev_video_ops ov5695_video_ops = {
>> +	.s_stream = ov5695_s_stream,
>> +};
>> +
>> +static const struct v4l2_subdev_pad_ops ov5695_pad_ops = {
>> +	.enum_mbus_code = ov5695_enum_mbus_code,
>> +	.enum_frame_size = ov5695_enum_frame_sizes,
>> +	.get_fmt = ov5695_get_fmt,
>> +	.set_fmt = ov5695_set_fmt,
>> +};
>> +
>> +static const struct v4l2_subdev_ops ov5695_subdev_ops = {
>> +	.video	= &ov5695_video_ops,
>> +	.pad	= &ov5695_pad_ops,
>> +};
>> +
>> +static int ov5695_set_ctrl(struct v4l2_ctrl *ctrl)
>> +{
>> +	struct ov5695 *ov5695 = container_of(ctrl->handler,
>> +					     struct ov5695, ctrl_handler);
>> +	struct i2c_client *client = ov5695->client;
>> +	s64 max;
>> +	int ret = 0;
>> +
>> +	/* Propagate change of current control to all related controls */
>> +	switch (ctrl->id) {
>> +	case V4L2_CID_VBLANK:
>> +		/* Update max exposure while meeting expected vblanking */
>> +		max = ov5695->cur_mode->height + ctrl->val - 4;
>> +		__v4l2_ctrl_modify_range(ov5695->exposure,
>> +					 ov5695->exposure->minimum, max,
>> +					 ov5695->exposure->step,
>> +					 ov5695->exposure->default_value);
>> +		break;
>> +	}
>> +
>> +	if (pm_runtime_get_if_in_use(&client->dev) <= 0)
>> +		return 0;
>> +
>> +	switch (ctrl->id) {
>> +	case V4L2_CID_EXPOSURE:
>> +		/* 4 least significant bits of expsoure are fractional part */
>> +		ret = ov5695_write_reg(ov5695->client, OV5695_REG_EXPOSURE,
>> +				       OV5695_REG_VALUE_24BIT, ctrl->val << 4);
>> +		break;
>> +	case V4L2_CID_ANALOGUE_GAIN:
>> +		ret = ov5695_write_reg(ov5695->client, OV5695_REG_ANALOG_GAIN,
>> +				       OV5695_REG_VALUE_08BIT, ctrl->val);
>> +		break;
>> +	case V4L2_CID_DIGITAL_GAIN:
>> +		ret = ov5695_write_reg(ov5695->client, OV5695_REG_DIGI_GAIN_L,
>> +				       OV5695_REG_VALUE_08BIT,
>> +				       ctrl->val & OV5695_DIGI_GAIN_L_MASK);
>> +		ret = ov5695_write_reg(ov5695->client, OV5695_REG_DIGI_GAIN_H,
>> +				       OV5695_REG_VALUE_08BIT,
>> +				       ctrl->val >> OV5695_DIGI_GAIN_H_SHIFT);
>> +		break;
>> +	case V4L2_CID_VBLANK:
>> +		ret = ov5695_write_reg(ov5695->client, OV5695_REG_VTS,
>> +				       OV5695_REG_VALUE_16BIT,
>> +				       ctrl->val + ov5695->cur_mode->height);
>> +		break;
>> +	case V4L2_CID_TEST_PATTERN:
>> +		ret = ov5695_enable_test_pattern(ov5695, ctrl->val);
>> +		break;
>> +	default:
>> +		dev_warn(&client->dev, "%s Unhandled id:0x%x, val:0x%x\n",
>> +			 __func__, ctrl->id, ctrl->val);
>> +		break;
>> +	};
>> +
>> +	pm_runtime_put(&client->dev);
>> +
>> +	return ret;
>> +}
>> +
>> +static const struct v4l2_ctrl_ops ov5695_ctrl_ops = {
>> +	.s_ctrl = ov5695_set_ctrl,
>> +};
>> +
>> +static int ov5695_initialize_controls(struct ov5695 *ov5695)
>> +{
>> +	const struct ov5695_mode *mode;
>> +	struct v4l2_ctrl_handler *handler;
>> +	struct v4l2_ctrl *ctrl;
>> +	s64 exposure_max, vblank_def;
>> +	u32 h_blank;
>> +	int ret;
>> +
>> +	handler = &ov5695->ctrl_handler;
>> +	mode = ov5695->cur_mode;
>> +	ret = v4l2_ctrl_handler_init(handler, 8);
>> +	if (ret)
>> +		return ret;
>> +	handler->lock = &ov5695->mutex;
>> +
>> +	ctrl = v4l2_ctrl_new_int_menu(handler, NULL, V4L2_CID_LINK_FREQ,
>> +				      0, 0, link_freq_menu_items);
>> +	if (ctrl)
>> +		ctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;
>> +
>> +	v4l2_ctrl_new_std(handler, NULL, V4L2_CID_PIXEL_RATE,
>> +			  0, OV5695_PIXEL_RATE, 1, OV5695_PIXEL_RATE);
>> +
>> +	h_blank = mode->hts_def - mode->width;
>> +	ov5695->hblank = v4l2_ctrl_new_std(handler, NULL, V4L2_CID_HBLANK,
>> +				h_blank, h_blank, 1, h_blank);
>> +	if (ov5695->hblank)
>> +		ov5695->hblank->flags |= V4L2_CTRL_FLAG_READ_ONLY;
>> +
>> +	vblank_def = mode->vts_def - mode->height;
>> +	ov5695->vblank = v4l2_ctrl_new_std(handler, &ov5695_ctrl_ops,
>> +				V4L2_CID_VBLANK, vblank_def,
>> +				OV5695_VTS_MAX - mode->height,
>> +				1, vblank_def);
>> +
>> +	exposure_max = mode->vts_def - 4;
>> +	ov5695->exposure = v4l2_ctrl_new_std(handler, &ov5695_ctrl_ops,
>> +				V4L2_CID_EXPOSURE, OV5695_EXPOSURE_MIN,
>> +				exposure_max, OV5695_EXPOSURE_STEP,
>> +				mode->exp_def);
>> +
>> +	ov5695->anal_gain = v4l2_ctrl_new_std(handler, &ov5695_ctrl_ops,
>> +				V4L2_CID_ANALOGUE_GAIN, ANALOG_GAIN_MIN,
>> +				ANALOG_GAIN_MAX, ANALOG_GAIN_STEP,
>> +				ANALOG_GAIN_DEFAULT);
>> +
>> +	/* Digital gain */
>> +	ov5695->digi_gain = v4l2_ctrl_new_std(handler, &ov5695_ctrl_ops,
>> +				V4L2_CID_DIGITAL_GAIN, OV5695_DIGI_GAIN_MIN,
>> +				OV5695_DIGI_GAIN_MAX, OV5695_DIGI_GAIN_STEP,
>> +				OV5695_DIGI_GAIN_DEFAULT);
>> +
>> +	ov5695->test_pattern = v4l2_ctrl_new_std_menu_items(handler,
>> +				&ov5695_ctrl_ops, V4L2_CID_TEST_PATTERN,
>> +				ARRAY_SIZE(ov5695_test_pattern_menu) - 1,
>> +				0, 0, ov5695_test_pattern_menu);
>> +
>> +	if (handler->error) {
>> +		ret = handler->error;
>> +		dev_err(&ov5695->client->dev,
>> +			"Failed to init controls(%d)\n", ret);
>> +		goto err_free_handler;
>> +	}
>> +
>> +	ov5695->subdev.ctrl_handler = handler;
>> +
>> +	return 0;
>> +
>> +err_free_handler:
>> +	v4l2_ctrl_handler_free(handler);
>> +
>> +	return ret;
>> +}
>> +
>> +static int ov5695_check_sensor_id(struct ov5695 *ov5695,
>> +				  struct i2c_client *client)
>> +{
>> +	struct device *dev = &ov5695->client->dev;
>> +	u32 id;
>> +	int ret;
>> +
>> +	ret = __ov5695_power_on(ov5695);
>> +	if (ret)
>> +		return ret;
>> +	ret = ov5695_read_reg(client, OV5695_REG_CHIP_ID,
>> +			      OV5695_REG_VALUE_24BIT, &id);
>> +	__ov5695_power_off(ov5695);
>> +
>> +	if (id != CHIP_ID) {
>> +		dev_err(dev, "Unexpected sensor id(%06x), ret(%d)\n", id, ret);
>> +		return ret;
>> +	}
>> +
>> +	dev_info(dev, "Detected OV%06x sensor\n", CHIP_ID);
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov5695_probe(struct i2c_client *client,
>> +			const struct i2c_device_id *id)
>> +{
>> +	struct device *dev = &client->dev;
>> +	struct ov5695 *ov5695;
>> +	struct v4l2_subdev *sd;
>> +	int ret;
>> +
>> +	ov5695 = devm_kzalloc(dev, sizeof(*ov5695), GFP_KERNEL);
>> +	if (!ov5695)
>> +		return -ENOMEM;
>> +
>> +	ov5695->client = client;
>> +	ov5695->cur_mode = &supported_modes[0];
>> +
>> +	ov5695->xvclk = devm_clk_get(dev, "xvclk");
>> +	if (IS_ERR(ov5695->xvclk)) {
>> +		dev_err(dev, "Failed to get xvclk\n");
>> +		return -EINVAL;
>> +	}
>> +	ret = clk_set_rate(ov5695->xvclk, 24000000);
>> +	if (ret < 0) {
>> +		dev_err(dev, "Failed to set xvclk rate (24M)\n");
>> +		return ret;
>> +	}
>> +
>> +	ov5695->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_LOW);
>> +	if (IS_ERR(ov5695->reset_gpio)) {
>> +		dev_err(dev, "Failed to get reset-gpios\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	ov5695->avdd_regulator = devm_regulator_get(dev, "avdd");
>> +	if (IS_ERR(ov5695->avdd_regulator)) {
>> +		dev_err(dev, "Failed to get avdd-supply\n");
>> +		return -EINVAL;
>> +	}
>> +	ov5695->dovdd_regulator = devm_regulator_get(dev, "dovdd");
>> +	if (IS_ERR(ov5695->dovdd_regulator)) {
>> +		dev_err(dev, "Failed to get dovdd-supply\n");
>> +		return -EINVAL;
>> +	}
>> +	ov5695->dvdd_regulator = devm_regulator_get(dev, "dvdd");
>> +	if (IS_ERR(ov5695->dvdd_regulator)) {
>> +		dev_err(dev, "Failed to get dvdd-supply\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	mutex_init(&ov5695->mutex);
>> +
>> +	sd = &ov5695->subdev;
>> +	v4l2_i2c_subdev_init(sd, client, &ov5695_subdev_ops);
>> +#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
>> +	sd->internal_ops = &ov5695_internal_ops;
>> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>> +#endif
>> +
>> +	ret = ov5695_initialize_controls(ov5695);
>> +	if (ret)
>> +		return ret;
>> +	ret = ov5695_check_sensor_id(ov5695, client);
>> +	if (ret)
> Error handling needs to include v4l2_ctrl_free_controls here.
Done.
>
>> +		return ret;
>> +
>> +#if defined(CONFIG_MEDIA_CONTROLLER)
>> +	ov5695->pad.flags = MEDIA_PAD_FL_SOURCE;
>> +	sd->entity.function = MEDIA_ENT_F_CAM_SENSOR;
>> +	ret = media_entity_pads_init(&sd->entity, 1, &ov5695->pad);
>> +	if (ret < 0)
>> +		return ret;
> Same here.
Done.
>
>> +#endif
>> +
>> +	ret = v4l2_async_register_subdev(sd);
>> +	if (ret) {
>> +		dev_err(dev, "v4l2 async register subdev failed\n");
>> +		goto clean_entity;
>> +	}
>> +
>> +	pm_runtime_enable(dev);
> This isn't enough; see e.g. the smiapp driver. On its probe --- it uses
> autosuspend, so you can ignore the autosuspend stuff and get_noresume.
> pm_runtime_idle() needs to follow pm_runtime_enable here (as it would in
> smiapp, if it did not use autosuspend).
Done.
>
>> +	dev_info(dev, "Probe successfully\n");
> How about removing this? It's hardly useful.
Done.
>
>> +
>> +	return 0;
>> +
>> +clean_entity:
>> +#if defined(CONFIG_MEDIA_CONTROLLER)
>> +	media_entity_cleanup(&sd->entity);
>> +#endif
>> +
>> +	return ret;
>> +}
>> +
>> +static int ov5695_remove(struct i2c_client *client)
>> +{
>> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
>> +	struct ov5695 *ov5695 = to_ov5695(sd);
>> +
>> +	v4l2_async_unregister_subdev(sd);
>> +#if defined(CONFIG_MEDIA_CONTROLLER)
>> +	media_entity_cleanup(&sd->entity);
>> +#endif
>> +	v4l2_ctrl_handler_free(&ov5695->ctrl_handler);
>> +	mutex_destroy(&ov5695->mutex);
>> +
>> +	pm_runtime_disable(&client->dev);
>> +	if (!pm_runtime_status_suspended(&client->dev))
>> +		__ov5695_power_off(ov5695);
>> +	pm_runtime_set_suspended(&client->dev);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct of_device_id ov5695_of_match[] = {
>> +	{ .compatible = "ovti,ov5695" },
>> +	{},
>> +};
>> +
>> +static struct i2c_driver ov5695_i2c_driver = {
>> +	.driver = {
>> +		.name = "ov5695",
>> +		.owner = THIS_MODULE,
>> +		.pm = &ov5695_pm_ops,
>> +		.of_match_table = ov5695_of_match
>> +	},
>> +	.probe		= &ov5695_probe,
>> +	.remove		= &ov5695_remove,
>> +};
>> +
>> +module_i2c_driver(ov5695_i2c_driver);
>> +
>> +MODULE_DESCRIPTION("OmniVision ov5695 sensor driver");
>> +MODULE_LICENSE("GPL v2");
