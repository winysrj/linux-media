Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55422 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754213AbcIHMVo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:21:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mchehab@osg.samsung.com, hverkuil@xs4all.nl, geert@linux-m68k.org,
        matrandg@cisco.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v6 2/2] media: Add a driver for the ov5645 camera sensor.
Date: Thu, 08 Sep 2016 15:22:14 +0300
Message-ID: <1739314.RkalEXrcbu@avalon>
In-Reply-To: <1473326035-25228-3-git-send-email-todor.tomov@linaro.org>
References: <1473326035-25228-1-git-send-email-todor.tomov@linaro.org> <1473326035-25228-3-git-send-email-todor.tomov@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

Thank you for the patch.

On Thursday 08 Sep 2016 12:13:55 Todor Tomov wrote:
> The ov5645 sensor from Omnivision supports up to 2592x1944
> and CSI2 interface.
> 
> The driver adds support for the following modes:
> - 1280x960
> - 1920x1080
> - 2592x1944
> 
> Output format is packed 8bit UYVY.
> 
> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
> ---
>  drivers/media/i2c/Kconfig  |   12 +
>  drivers/media/i2c/Makefile |    1 +
>  drivers/media/i2c/ov5645.c | 1372 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1385 insertions(+)
>  create mode 100644 drivers/media/i2c/ov5645.c

[snip]

> diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
> new file mode 100644
> index 0000000..5e5c37e
> --- /dev/null
> +++ b/drivers/media/i2c/ov5645.c
> @@ -0,0 +1,1372 @@

[snip]

> +#define OV5645_VOLTAGE_ANALOG               2800000
> +#define OV5645_VOLTAGE_DIGITAL_CORE         1500000
> +#define OV5645_VOLTAGE_DIGITAL_IO           1800000
> +
> +#define OV5645_SYSTEM_CTRL0		0x3008
> +#define		OV5645_SYSTEM_CTRL0_START	0x02
> +#define		OV5645_SYSTEM_CTRL0_STOP	0x42
> +#define OV5645_CHIP_ID_HIGH		0x300A
> +#define		OV5645_CHIP_ID_HIGH_BYTE	0x56
> +#define OV5645_CHIP_ID_LOW		0x300B
> +#define		OV5645_CHIP_ID_LOW_BYTE		0x45
> +#define OV5645_AWB_MANUAL_CONTROL	0x3406
> +#define		OV5645_AWB_MANUAL_ENABLE	BIT(0)
> +#define OV5645_AEC_PK_MANUAL		0x3503
> +#define		OV5645_AEC_MANUAL_ENABLE	BIT(0)
> +#define		OV5645_AGC_MANUAL_ENABLE	BIT(1)
> +#define OV5645_TIMING_TC_REG20		0x3820
> +#define		OV5645_SENSOR_VFLIP		BIT(1)
> +#define		OV5645_ISP_VFLIP		BIT(2)
> +#define OV5645_TIMING_TC_REG21		0x3821
> +#define		OV5645_SENSOR_MIRROR		BIT(1)
> +#define OV5645_PRE_ISP_TEST_SETTING_1	0x503d

You're using a mix of upper and lower case hex values in the driver. I would 
standardize on lower case as that's what the majority of the kernel code uses.

> +#define		OV5645_TEST_PATTERN_MASK	0x3
> +#define		OV5645_SET_TEST_PATTERN(x)	((x) & 
OV5645_TEST_PATTERN_MASK)
> +#define		OV5645_TEST_PATTERN_ENABLE	BIT(7)
> +#define OV5645_SDE_SAT_U		0x5583
> +#define OV5645_SDE_SAT_V		0x5584
> +
> +enum ov5645_mode {
> +	OV5645_MODE_MIN = 0,

OV5645_MODE_MIN isn't used.

> +	OV5645_MODE_SXGA = 0,
> +	OV5645_MODE_1080P = 1,
> +	OV5645_MODE_FULL = 2,
> +	OV5645_MODE_MAX = 2
> +};
> +
> +struct reg_value {
> +	u16 reg;
> +	u8 val;
> +};
> +
> +struct ov5645_mode_info {
> +	enum ov5645_mode mode;

This field is never used, you can remove it.

> +	u32 width;
> +	u32 height;
> +	struct reg_value *data;
> +	u32 data_size;
> +};
> +
> +struct ov5645 {
> +	struct i2c_client *i2c_client;
> +	struct device *dev;
> +	struct v4l2_subdev sd;
> +	struct media_pad pad;
> +	struct v4l2_of_endpoint ep;
> +	struct v4l2_mbus_framefmt fmt;
> +	struct v4l2_rect crop;
> +	struct clk *xclk;
> +	/* External clock frequency currently supported is 23880000Hz */
> +	u32 xclk_freq;
> +
> +	struct regulator *io_regulator;
> +	struct regulator *core_regulator;
> +	struct regulator *analog_regulator;
> +
> +	enum ov5645_mode current_mode;

You could store a pointer to struct ov5645_mode_info instead, it would save 
the array lookup when using it.

> +	/* Cached control values */
> +	struct v4l2_ctrl_handler ctrls;
> +	struct v4l2_ctrl *saturation;
> +	struct v4l2_ctrl *hflip;
> +	struct v4l2_ctrl *vflip;
> +	struct v4l2_ctrl *autogain;
> +	struct v4l2_ctrl *autoexposure;
> +	struct v4l2_ctrl *awb;
> +	struct v4l2_ctrl *pattern;
> +
> +	struct mutex power_lock; /* lock to protect power state */
> +	bool power;
> +
> +	struct gpio_desc *enable_gpio;
> +	struct gpio_desc *rst_gpio;
> +};
> +
> +static inline struct ov5645 *to_ov5645(struct v4l2_subdev *sd)
> +{
> +	return container_of(sd, struct ov5645, sd);
> +}
> +
> +static struct reg_value ov5645_global_init_setting[] = {

You can make this static const. Same comment for the other register arrays.

> +	{ 0x3103, 0x11 },
> +	{ 0x3008, 0x82 },
> +	{ 0x3008, 0x42 },
> +	{ 0x3103, 0x03 },
> +	{ 0x3503, 0x07 },

[snip]

> +	{ 0x3503, 0x00 },

Can't you get rid of the first write to 0x3503 ?

[snip]

> +};

[snip]

> +static struct ov5645_mode_info ov5645_mode_info_data[OV5645_MODE_MAX + 1] =

static const here too.

You can leave the array size out here (ov5645_mode_info_data[]), use 
ARRAY_SIZE(ov5645_mode_info_data) instead of OV5645_MODE_MAX below, and drop 
the OV5645_MODE_MAX enum value completely. I might even go as far as dropping 
enum ov5645_mode completely and use an unsigned int array index instead.

> { +	{
> +		.mode = OV5645_MODE_SXGA,
> +		.width = 1280,
> +		.height = 960,
> +		.data = ov5645_setting_sxga,
> +		.data_size = ARRAY_SIZE(ov5645_setting_sxga)
> +	},
> +	{
> +		.mode = OV5645_MODE_1080P,
> +		.width = 1920,
> +		.height = 1080,
> +		.data = ov5645_setting_1080p,
> +		.data_size = ARRAY_SIZE(ov5645_setting_1080p)
> +	},
> +	{
> +		.mode = OV5645_MODE_FULL,
> +		.width = 2592,
> +		.height = 1944,
> +		.data = ov5645_setting_full,
> +		.data_size = ARRAY_SIZE(ov5645_setting_full)
> +	},
> +};
> +
> +static int ov5645_regulators_enable(struct ov5645 *ov5645)
> +{
> +	int ret;
> +
> +	ret = regulator_enable(ov5645->io_regulator);
> +	if (ret < 0) {
> +		dev_err(ov5645->dev, "set io voltage failed\n");
> +		return ret;
> +	}
> +
> +	ret = regulator_enable(ov5645->core_regulator);
> +	if (ret) {
> +		dev_err(ov5645->dev, "set core voltage failed\n");
> +		goto err_disable_io;
> +	}
> +
> +	ret = regulator_enable(ov5645->analog_regulator);
> +	if (ret) {
> +		dev_err(ov5645->dev, "set analog voltage failed\n");
> +		goto err_disable_core;
> +	}

How about using the regulator bulk API ? This would simplify the enable and 
disable functions.

> +	return 0;
> +
> +err_disable_core:
> +	regulator_disable(ov5645->core_regulator);
> +err_disable_io:
> +	regulator_disable(ov5645->io_regulator);
> +
> +	return ret;
> +}
> +
> +static void ov5645_regulators_disable(struct ov5645 *ov5645)
> +{
> +	int ret;
> +
> +	ret = regulator_disable(ov5645->analog_regulator);
> +	if (ret < 0)
> +		dev_err(ov5645->dev, "analog regulator disable failed\n");
> +
> +	ret = regulator_disable(ov5645->core_regulator);
> +	if (ret < 0)
> +		dev_err(ov5645->dev, "core regulator disable failed\n");
> +
> +	ret = regulator_disable(ov5645->io_regulator);
> +	if (ret < 0)
> +		dev_err(ov5645->dev, "io regulator disable failed\n");
> +}
> +
> +static int ov5645_write_reg(struct ov5645 *ov5645, u16 reg, u8 val)
> +{
> +	u8 regbuf[3];
> +	int ret;
> +
> +	regbuf[0] = reg >> 8;
> +	regbuf[1] = reg & 0xff;
> +	regbuf[2] = val;
> +
> +	ret = i2c_master_send(ov5645->i2c_client, regbuf, 3);
> +	if (ret < 0)
> +		dev_err(ov5645->dev, "%s: write reg error %d: reg=%x, 
val=%x\n",
> +			__func__, ret, reg, val);
> +
> +	return ret;
> +}
> +
> +static int ov5645_read_reg(struct ov5645 *ov5645, u16 reg, u8 *val)
> +{
> +	u8 regbuf[2];
> +	u8 tmpval;
> +	int ret;
> +
> +	regbuf[0] = reg >> 8;
> +	regbuf[1] = reg & 0xff;
> +
> +	ret = i2c_master_send(ov5645->i2c_client, regbuf, 2);
> +	if (ret < 0) {
> +		dev_err(ov5645->dev, "%s: write reg error %d: reg=%x\n",
> +			__func__, ret, reg);
> +		return ret;
> +	}
> +
> +	ret = i2c_master_recv(ov5645->i2c_client, &tmpval, 1);

You can use val directly here and remove the tmpval local variable.

> +	if (ret < 0) {
> +		dev_err(ov5645->dev, "%s: read reg error %d: reg=%x\n",
> +			__func__, ret, reg);
> +		return ret;
> +	}
> +
> +	*val = tmpval;
> +
> +	return 0;
> +}
> +
> +static int ov5645_set_aec_mode(struct ov5645 *ov5645, u32 mode)
> +{
> +	u8 val;
> +	int ret;
> +
> +	ret = ov5645_read_reg(ov5645, OV5645_AEC_PK_MANUAL, &val);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (mode == V4L2_EXPOSURE_AUTO)
> +		val &= ~OV5645_AEC_MANUAL_ENABLE;
> +	else /* V4L2_EXPOSURE_MANUAL */
> +		val |= OV5645_AEC_MANUAL_ENABLE;
> +
> +	return ov5645_write_reg(ov5645, OV5645_AEC_PK_MANUAL, val);

I2C read operations being expensive, how about caching the 
OV5645_AEC_PK_MANUAL value in struct ov5645 to avoid reading it back from the 
hardware ?

> +}
> +
> +static int ov5645_set_agc_mode(struct ov5645 *ov5645, u32 enable)
> +{
> +	u8 val;
> +	int ret;
> +
> +	ret = ov5645_read_reg(ov5645, OV5645_AEC_PK_MANUAL, &val);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (enable)
> +		val &= ~OV5645_AGC_MANUAL_ENABLE;
> +	else
> +		val |= OV5645_AGC_MANUAL_ENABLE;
> +
> +	return ov5645_write_reg(ov5645, OV5645_AEC_PK_MANUAL, val);
> +}
> +
> +static int ov5645_set_register_array(struct ov5645 *ov5645,
> +				     struct reg_value *settings,

settings is never modified, you can make it const.

> +				     u32 num_settings)

I'd use unsigned int (same for the i variable below) as you don't really care 
about the exact number of bits.

> +{
> +	u16 reg;
> +	u8 val;
> +	u32 i;
> +	int ret;
> +
> +	for (i = 0; i < num_settings; ++i, ++settings) {
> +		reg = settings->reg;
> +		val = settings->val;
> +
> +		ret = ov5645_write_reg(ov5645, reg, val);

I'd write this

		ret = ov5645_write_reg(ov5645, settings->reg, settins->val);

and remove the reg and val local variables, they don't really improve 
readability in my opinion.

> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int ov5645_init(struct ov5645 *ov5645)
> +{
> +	struct reg_value *settings;
> +	u32 num_settings;
> +
> +	settings = ov5645_global_init_setting;
> +	num_settings = ARRAY_SIZE(ov5645_global_init_setting);
> +
> +	return ov5645_set_register_array(ov5645, settings, num_settings);

I'd drop the local variables here too.

> +}
> +
> +static int ov5645_change_mode(struct ov5645 *ov5645, enum ov5645_mode mode)
> +{
> +	struct reg_value *settings;
> +	u32 num_settings;
> +
> +	settings = ov5645_mode_info_data[mode].data;
> +	num_settings = ov5645_mode_info_data[mode].data_size;
> +
> +	return ov5645_set_register_array(ov5645, settings, num_settings);

And here too.

> +}
> +
> +static int ov5645_set_power_on(struct ov5645 *ov5645)
> +{
> +	int ret;
> +
> +	clk_set_rate(ov5645->xclk, ov5645->xclk_freq);

Is this needed every time you power the sensor on or could you do it just once 
at probe time ?

> +	ret = clk_prepare_enable(ov5645->xclk);
> +	if (ret < 0) {
> +		dev_err(ov5645->dev, "clk prepare enable failed\n");
> +		return ret;
> +	}

Is it safe to start the clock before the regulators ? Driving an input of an 
unpowered chip can lead to latch-up issues.

> +	ret = ov5645_regulators_enable(ov5645);
> +	if (ret < 0) {
> +		clk_disable_unprepare(ov5645->xclk);
> +		return ret;
> +	}
> +
> +	usleep_range(5000, 15000);
> +	gpiod_set_value_cansleep(ov5645->enable_gpio, 1);
> +
> +	usleep_range(1000, 2000);
> +	gpiod_set_value_cansleep(ov5645->rst_gpio, 0);
> +
> +	msleep(20);
> +
> +	return ret;

You can return 0.

> +}
> +
> +static void ov5645_set_power_off(struct ov5645 *ov5645)
> +{
> +	gpiod_set_value_cansleep(ov5645->rst_gpio, 1);
> +	gpiod_set_value_cansleep(ov5645->enable_gpio, 0);
> +	ov5645_regulators_disable(ov5645);
> +	clk_disable_unprepare(ov5645->xclk);
> +}
> +
> +static int ov5645_s_power(struct v4l2_subdev *sd, int on)
> +{
> +	struct ov5645 *ov5645 = to_ov5645(sd);
> +	int ret = 0;
> +
> +	mutex_lock(&ov5645->power_lock);
> +
> +	if (ov5645->power == !on) {

Power handling needs to be reference-counted, see the mt0p031 driver for an 
example.

> +		/* Power state changes. */
> +		if (on) {
> +			ret = ov5645_set_power_on(ov5645);
> +			if (ret < 0) {
> +				dev_err(ov5645->dev, "could not set power 
%s\n",
> +					on ? "on" : "off");

on is alway true here, you can hardcode the debug message.

Furthermore I think ov5645_set_power_on() or the functions it calls already 
print an error message on failure, so you could drop this one.

> +				goto exit;
> +			}
> +
> +			ret = ov5645_init(ov5645);
> +			if (ret < 0) {
> +				dev_err(ov5645->dev,
> +					"could not set init registers\n");
> +				ov5645_set_power_off(ov5645);
> +				goto exit;
> +			}
> +
> +			ret = ov5645_write_reg(ov5645, OV5645_SYSTEM_CTRL0,
> +					       OV5645_SYSTEM_CTRL0_STOP);
> +			if (ret < 0) {
> +				ov5645_set_power_off(ov5645);
> +				goto exit;
> +			}
> +		} else {
> +			ov5645_set_power_off(ov5645);
> +		}
> +
> +		/* Update the power state. */
> +		ov5645->power = on ? true : false;
> +	}
> +
> +exit:
> +	mutex_unlock(&ov5645->power_lock);
> +
> +	return ret;
> +}
> +
> +

Extra blank line.

> +static int ov5645_set_saturation(struct ov5645 *ov5645, s32 value)
> +{
> +	u32 reg_value = (value * 0x10) + 0x40;
> +	int ret;
> +
> +	ret = ov5645_write_reg(ov5645, OV5645_SDE_SAT_U, reg_value);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = ov5645_write_reg(ov5645, OV5645_SDE_SAT_V, reg_value);
> +
> +	return ret;

return ov5645_write_reg(ov5645, OV5645_SDE_SAT_V, reg_value);

> +}
> +
> +static int ov5645_set_hflip(struct ov5645 *ov5645, s32 value)
> +{
> +	u8 val;
> +	int ret;
> +
> +	ret = ov5645_read_reg(ov5645, OV5645_TIMING_TC_REG21, &val);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (value == 0)
> +		val &= ~(OV5645_SENSOR_MIRROR);
> +	else
> +		val |= (OV5645_SENSOR_MIRROR);
> +
> +	return ov5645_write_reg(ov5645, OV5645_TIMING_TC_REG21, val);

You could cache this register too.

> +}
> +
> +static int ov5645_set_vflip(struct ov5645 *ov5645, s32 value)
> +{
> +	u8 val;
> +	int ret;
> +
> +	ret = ov5645_read_reg(ov5645, OV5645_TIMING_TC_REG20, &val);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (value == 0)
> +		val |= (OV5645_SENSOR_VFLIP | OV5645_ISP_VFLIP);
> +	else
> +		val &= ~(OV5645_SENSOR_VFLIP | OV5645_ISP_VFLIP);
> +
> +	return ov5645_write_reg(ov5645, OV5645_TIMING_TC_REG20, val);

And this one as well.

How about using regmap by the way ?

> +}
> +
> +static int ov5645_set_test_pattern(struct ov5645 *ov5645, s32 value)
> +{
> +	u8 val;
> +	int ret;
> +
> +	ret = ov5645_read_reg(ov5645, OV5645_PRE_ISP_TEST_SETTING_1, &val);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (value) {
> +		val &= ~OV5645_SET_TEST_PATTERN(OV5645_TEST_PATTERN_MASK);
> +		val |= OV5645_SET_TEST_PATTERN(value - 1);
> +		val |= OV5645_TEST_PATTERN_ENABLE;
> +	} else {
> +		val &= ~OV5645_TEST_PATTERN_ENABLE;
> +	}
> +
> +	return ov5645_write_reg(ov5645, OV5645_PRE_ISP_TEST_SETTING_1, val);

Are there other bits that need to be preserved in this register ?

> +}
> +
> +static const char * const ov5645_test_pattern_menu[] = {
> +	"Disabled",
> +	"Vertical Color Bars",
> +	"Pseudo-Random Data",
> +	"Color Square",
> +	"Black Image",
> +};
> +
> +static int ov5645_set_awb(struct ov5645 *ov5645, s32 enable_auto)
> +{
> +	u8 val;
> +	int ret;
> +
> +	ret = ov5645_read_reg(ov5645, OV5645_AWB_MANUAL_CONTROL, &val);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (enable_auto)
> +		val &= ~OV5645_AWB_MANUAL_ENABLE;
> +	else
> +		val |= OV5645_AWB_MANUAL_ENABLE;
> +
> +	return ov5645_write_reg(ov5645, OV5645_AWB_MANUAL_CONTROL, val);

Same here, are there other bits that need to be preserved ?

> +}
> +
> +static int ov5645_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct ov5645 *ov5645 = container_of(ctrl->handler,
> +					     struct ov5645, ctrls);
> +	int ret = -EINVAL;
> +
> +	mutex_lock(&ov5645->power_lock);
> +	if (ov5645->power == 0) {

power is a bool, I'd thus write this

	if (!ov5645->power) {

> +		mutex_unlock(&ov5645->power_lock);
> +		return 0;
> +	}
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_SATURATION:
> +		ret = ov5645_set_saturation(ov5645, ctrl->val);
> +		break;
> +	case V4L2_CID_AUTO_WHITE_BALANCE:
> +		ret = ov5645_set_awb(ov5645, ctrl->val);
> +		break;
> +	case V4L2_CID_AUTOGAIN:
> +		ret = ov5645_set_agc_mode(ov5645, ctrl->val);
> +		break;
> +	case V4L2_CID_EXPOSURE_AUTO:
> +		ret = ov5645_set_aec_mode(ov5645, ctrl->val);
> +		break;
> +	case V4L2_CID_TEST_PATTERN:
> +		ret = ov5645_set_test_pattern(ov5645, ctrl->val);
> +		break;
> +	case V4L2_CID_HFLIP:
> +		ret = ov5645_set_hflip(ov5645, ctrl->val);
> +		break;
> +	case V4L2_CID_VFLIP:
> +		ret = ov5645_set_vflip(ov5645, ctrl->val);
> +		break;

Instead of initializing ret to -EINVAL you could add a default case here, it 
would avoid the unnecessary initialization in the common case where ctrl->id 
is valid.

> +	}
> +
> +	mutex_unlock(&ov5645->power_lock);
> +
> +	return ret;
> +}
> +
> +static struct v4l2_ctrl_ops ov5645_ctrl_ops = {
> +	.s_ctrl = ov5645_s_ctrl,
> +};
> +
> +static int ov5645_entity_init_cfg(struct v4l2_subdev *subdev,
> +				  struct v4l2_subdev_pad_config *cfg)
> +{
> +	struct v4l2_subdev_format fmt = { 0 };
> +
> +	fmt.which = cfg ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;

The function will always be called with cfg != NULL.

> +	fmt.format.width = 1920;
> +	fmt.format.height = 1080;
> +
> +	v4l2_subdev_call(subdev, pad, set_fmt, cfg, &fmt);

You can call ov5645_set_format directly.

> +	return 0;
> +}
> +
> +static int ov5645_enum_mbus_code(struct v4l2_subdev *sd,
> +				 struct v4l2_subdev_pad_config *cfg,
> +				 struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	struct ov5645 *ov5645 = to_ov5645(sd);
> +
> +	if (code->index > 0)
> +		return -EINVAL;
> +
> +	code->code = ov5645->fmt.code;

Given that ov5645->fmt.code is always equal to MEDIA_BUS_FMT_UYVY8_2X8, you 
can hardcode the value here. Returning the current code works when only a 
single one is supported, but is conceptually the wrong thing to do in the code 
enumeration handler.

> +
> +	return 0;
> +}
> +
> +static int ov5645_enum_frame_size(struct v4l2_subdev *subdev,
> +				  struct v4l2_subdev_pad_config *cfg,
> +				  struct v4l2_subdev_frame_size_enum *fse)
> +{

You should return -EINVAL if fse->code != MEDIA_BUS_FMT_UYVY8_2X8.

> +	if (fse->index > OV5645_MODE_MAX)
> +		return -EINVAL;
> +
> +	fse->min_width = ov5645_mode_info_data[fse->index].width;
> +	fse->max_width = ov5645_mode_info_data[fse->index].width;
> +	fse->min_height = ov5645_mode_info_data[fse->index].height;
> +	fse->max_height = ov5645_mode_info_data[fse->index].height;
> +
> +	return 0;
> +}
> +
> +static struct v4l2_mbus_framefmt *
> +__ov5645_get_pad_format(struct ov5645 *ov5645,
> +			struct v4l2_subdev_pad_config *cfg,
> +			unsigned int pad,
> +			enum v4l2_subdev_format_whence which)
> +{
> +	switch (which) {
> +	case V4L2_SUBDEV_FORMAT_TRY:
> +		return v4l2_subdev_get_try_format(&ov5645->sd, cfg, pad);
> +	case V4L2_SUBDEV_FORMAT_ACTIVE:
> +		return &ov5645->fmt;
> +	default:
> +		return NULL;
> +	}
> +}
> +
> +static int ov5645_get_format(struct v4l2_subdev *sd,
> +			     struct v4l2_subdev_pad_config *cfg,
> +			     struct v4l2_subdev_format *format)
> +{
> +	struct ov5645 *ov5645 = to_ov5645(sd);
> +
> +	format->format = *__ov5645_get_pad_format(ov5645, cfg, format->pad,
> +						  format->which);
> +	return 0;
> +}
> +
> +static struct v4l2_rect *
> +__ov5645_get_pad_crop(struct ov5645 *ov5645, struct v4l2_subdev_pad_config
> *cfg,
> +		      unsigned int pad, enum v4l2_subdev_format_whence which)
> +{
> +	switch (which) {
> +	case V4L2_SUBDEV_FORMAT_TRY:
> +		return v4l2_subdev_get_try_crop(&ov5645->sd, cfg, pad);
> +	case V4L2_SUBDEV_FORMAT_ACTIVE:
> +		return &ov5645->crop;
> +	default:
> +		return NULL;
> +	}
> +}
> +
> +static enum ov5645_mode ov5645_find_nearest_mode(struct ov5645 *ov5645,
> +						 int width, int height)
> +{

width and height only takes positive values, you can make them unsigned int.

> +	int i;
> +
> +	for (i = OV5645_MODE_MAX; i >= 0; i--) {
> +		if (ov5645_mode_info_data[i].width <= width &&
> +		    ov5645_mode_info_data[i].height <= height)
> +			break;
> +	}
> +
> +	if (i < 0)
> +		i = 0;
> +
> +	return (enum ov5645_mode)i;
> +}
> +
> +static int ov5645_set_format(struct v4l2_subdev *sd,
> +			     struct v4l2_subdev_pad_config *cfg,
> +			     struct v4l2_subdev_format *format)
> +{
> +	struct ov5645 *ov5645 = to_ov5645(sd);
> +	struct v4l2_mbus_framefmt *__format;
> +	struct v4l2_rect *__crop;
> +	enum ov5645_mode new_mode;
> +
> +	__crop = __ov5645_get_pad_crop(ov5645, cfg, format->pad,
> +			format->which);
> +
> +	new_mode = ov5645_find_nearest_mode(ov5645,
> +			format->format.width, format->format.height);
> +	__crop->width = ov5645_mode_info_data[new_mode].width;
> +	__crop->height = ov5645_mode_info_data[new_mode].height;
> +
> +	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +		ov5645->current_mode = new_mode;
> +
> +	__format = __ov5645_get_pad_format(ov5645, cfg, format->pad,
> +			format->which);
> +	__format->width = __crop->width;
> +	__format->height = __crop->height;
> +	__format->code = MEDIA_BUS_FMT_UYVY8_2X8;
> +	__format->field = V4L2_FIELD_NONE;
> +	__format->colorspace = V4L2_COLORSPACE_SRGB;
> +
> +	format->format = *__format;
> +
> +	return 0;
> +}
> +
> +static int ov5645_get_selection(struct v4l2_subdev *sd,
> +			   struct v4l2_subdev_pad_config *cfg,
> +			   struct v4l2_subdev_selection *sel)
> +{
> +	struct ov5645 *ov5645 = to_ov5645(sd);
> +
> +	if (sel->target != V4L2_SEL_TGT_CROP)
> +		return -EINVAL;
> +
> +	sel->r = *__ov5645_get_pad_crop(ov5645, cfg, sel->pad,
> +					sel->which);
> +	return 0;
> +}
> +
> +static int ov5645_s_stream(struct v4l2_subdev *subdev, int enable)
> +{
> +	struct ov5645 *ov5645 = to_ov5645(subdev);
> +	int ret;
> +
> +	if (enable) {
> +		ret = ov5645_change_mode(ov5645, ov5645->current_mode);
> +		if (ret < 0) {
> +			dev_err(ov5645->dev, "could not set mode %d\n",
> +				ov5645->current_mode);
> +			return ret;
> +		}
> +		ret = v4l2_ctrl_handler_setup(&ov5645->ctrls);
> +		if (ret < 0) {
> +			dev_err(ov5645->dev, "could not sync v4l2 
controls\n");
> +			return ret;
> +		}
> +		ret = ov5645_write_reg(ov5645, OV5645_SYSTEM_CTRL0,
> +				       OV5645_SYSTEM_CTRL0_START);
> +		if (ret < 0)
> +			return ret;
> +	} else {
> +		ret = ov5645_write_reg(ov5645, OV5645_SYSTEM_CTRL0,
> +				       OV5645_SYSTEM_CTRL0_STOP);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static struct v4l2_subdev_core_ops ov5645_core_ops = {
> +	.s_power = ov5645_s_power,
> +};
> +
> +static struct v4l2_subdev_video_ops ov5645_video_ops = {
> +	.s_stream = ov5645_s_stream,
> +};
> +
> +static struct v4l2_subdev_pad_ops ov5645_subdev_pad_ops = {
> +	.init_cfg = ov5645_entity_init_cfg,
> +	.enum_mbus_code = ov5645_enum_mbus_code,
> +	.enum_frame_size = ov5645_enum_frame_size,
> +	.get_fmt = ov5645_get_format,
> +	.set_fmt = ov5645_set_format,
> +	.get_selection = ov5645_get_selection,
> +};
> +
> +static struct v4l2_subdev_ops ov5645_subdev_ops = {
> +	.core = &ov5645_core_ops,
> +	.video = &ov5645_video_ops,
> +	.pad = &ov5645_subdev_pad_ops,
> +};

You can make all those structures static const.

> +
> +static const struct v4l2_subdev_internal_ops ov5645_subdev_internal_ops = {
> +};
> +
> +static int ov5645_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct device *dev = &client->dev;
> +	struct device_node *endpoint;
> +	struct ov5645 *ov5645;
> +	u8 chip_id_high, chip_id_low;
> +	int ret;
> +
> +	ov5645 = devm_kzalloc(dev, sizeof(struct ov5645), GFP_KERNEL);
> +	if (!ov5645)
> +		return -ENOMEM;
> +
> +	ov5645->i2c_client = client;
> +	ov5645->dev = dev;
> +
> +	endpoint = of_graph_get_next_endpoint(dev->of_node, NULL);
> +	if (!endpoint) {
> +		dev_err(dev, "endpoint node not found\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = v4l2_of_parse_endpoint(endpoint, &ov5645->ep);
> +	if (ret < 0) {
> +		dev_err(dev, "parsing endpoint node failed\n");
> +		return ret;
> +	}

You can call of_node_put(endpoint) here instead of twice below.

> +	if (ov5645->ep.bus_type != V4L2_MBUS_CSI2) {
> +		dev_err(dev, "invalid bus type, must be CSI2\n");
> +		of_node_put(endpoint);
> +		return -EINVAL;
> +	}
> +	of_node_put(endpoint);
> +
> +	/* get system clock (xclk) */
> +	ov5645->xclk = devm_clk_get(dev, "xclk");
> +	if (IS_ERR(ov5645->xclk)) {
> +		dev_err(dev, "could not get xclk");
> +		return PTR_ERR(ov5645->xclk);
> +	}
> +
> +	ret = of_property_read_u32(dev->of_node, "clock-frequency",
> +				    &ov5645->xclk_freq);
> +	if (ret) {
> +		dev_err(dev, "could not get xclk frequency\n");
> +		return ret;
> +	}

Shouldn't you return an error if the frequency is different than the only one 
supported by the driver (for which the register values have been computed and 
hardcoded) ?

> +	ov5645->io_regulator = devm_regulator_get(dev, "vdddo");
> +	if (IS_ERR(ov5645->io_regulator)) {
> +		dev_err(dev, "cannot get io regulator\n");
> +		return PTR_ERR(ov5645->io_regulator);
> +	}
> +
> +	ret = regulator_set_voltage(ov5645->io_regulator,
> +				    OV5645_VOLTAGE_DIGITAL_IO,
> +				    OV5645_VOLTAGE_DIGITAL_IO);
> +	if (ret < 0) {
> +		dev_err(dev, "cannot set io voltage\n");
> +		return ret;
> +	}
> +
> +	ov5645->core_regulator = devm_regulator_get(dev, "vddd");
> +	if (IS_ERR(ov5645->core_regulator)) {
> +		dev_err(dev, "cannot get core regulator\n");
> +		return PTR_ERR(ov5645->core_regulator);
> +	}
> +
> +	ret = regulator_set_voltage(ov5645->core_regulator,
> +				    OV5645_VOLTAGE_DIGITAL_CORE,
> +				    OV5645_VOLTAGE_DIGITAL_CORE);
> +	if (ret < 0) {
> +		dev_err(dev, "cannot set core voltage\n");
> +		return ret;
> +	}
> +
> +	ov5645->analog_regulator = devm_regulator_get(dev, "vdda");
> +	if (IS_ERR(ov5645->analog_regulator)) {
> +		dev_err(dev, "cannot get analog regulator\n");
> +		return PTR_ERR(ov5645->analog_regulator);
> +	}
> +
> +	ret = regulator_set_voltage(ov5645->analog_regulator,
> +				    OV5645_VOLTAGE_ANALOG,
> +				    OV5645_VOLTAGE_ANALOG);
> +	if (ret < 0) {
> +		dev_err(dev, "cannot set analog voltage\n");
> +		return ret;
> +	}
> +
> +	ov5645->enable_gpio = devm_gpiod_get(dev, "enable", GPIOD_OUT_HIGH);
> +	if (IS_ERR(ov5645->enable_gpio)) {
> +		dev_err(dev, "cannot get enable gpio\n");
> +		return PTR_ERR(ov5645->enable_gpio);
> +	}
> +
> +	ov5645->rst_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_HIGH);
> +	if (IS_ERR(ov5645->rst_gpio)) {
> +		dev_err(dev, "cannot get reset gpio\n");
> +		return PTR_ERR(ov5645->rst_gpio);
> +	}
> +
> +	mutex_init(&ov5645->power_lock);
> +
> +	v4l2_ctrl_handler_init(&ov5645->ctrls, 7);
> +	ov5645->saturation = v4l2_ctrl_new_std(&ov5645->ctrls, 
&ov5645_ctrl_ops,
> +				V4L2_CID_SATURATION, -4, 4, 1, 0);
> +	ov5645->hflip = v4l2_ctrl_new_std(&ov5645->ctrls, &ov5645_ctrl_ops,
> +				V4L2_CID_HFLIP, 0, 1, 1, 0);
> +	ov5645->vflip = v4l2_ctrl_new_std(&ov5645->ctrls, &ov5645_ctrl_ops,
> +				V4L2_CID_VFLIP, 0, 1, 1, 0);
> +	ov5645->autogain = v4l2_ctrl_new_std(&ov5645->ctrls, &ov5645_ctrl_ops,
> +				V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
> +	ov5645->autoexposure = v4l2_ctrl_new_std_menu(&ov5645->ctrls,
> +				&ov5645_ctrl_ops, V4L2_CID_EXPOSURE_AUTO,
> +				V4L2_EXPOSURE_MANUAL, 0, V4L2_EXPOSURE_AUTO);
> +	ov5645->awb = v4l2_ctrl_new_std(&ov5645->ctrls, &ov5645_ctrl_ops,
> +				V4L2_CID_AUTO_WHITE_BALANCE, 0, 1, 1, 1);
> +	ov5645->pattern = v4l2_ctrl_new_std_menu_items(&ov5645->ctrls,
> +				&ov5645_ctrl_ops, V4L2_CID_TEST_PATTERN,
> +				ARRAY_SIZE(ov5645_test_pattern_menu) - 1, 0, 
0,
> +				ov5645_test_pattern_menu);

You don't need to store all these in the ov5645 structure as they are never 
used.

> +
> +	ov5645->sd.ctrl_handler = &ov5645->ctrls;
> +
> +	if (ov5645->ctrls.error) {
> +		dev_err(dev, "%s: control initialization error %d\n",
> +		       __func__, ov5645->ctrls.error);
> +		ret = ov5645->ctrls.error;
> +		goto free_ctrl;
> +	}
> +
> +	v4l2_i2c_subdev_init(&ov5645->sd, client, &ov5645_subdev_ops);
> +	ov5645->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	ov5645->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	ov5645->sd.internal_ops = &ov5645_subdev_internal_ops;
> +
> +	ret = media_entity_pads_init(&ov5645->sd.entity, 1, &ov5645->pad);
> +	if (ret < 0) {
> +		dev_err(dev, "could not register media entity\n");
> +		goto free_ctrl;
> +	}
> +
> +	ov5645->sd.dev = &client->dev;
> +	ret = v4l2_async_register_subdev(&ov5645->sd);
> +	if (ret < 0) {
> +		dev_err(dev, "could not register v4l2 device\n");
> +		goto free_entity;
> +	}
> +
> +	ret = ov5645_s_power(&ov5645->sd, true);
> +	if (ret < 0) {
> +		dev_err(dev, "could not power up OV5645\n");
> +		goto unregister_subdev;
> +	}
> +
> +	ret = ov5645_read_reg(ov5645, OV5645_CHIP_ID_HIGH, &chip_id_high);
> +	if (ret < 0 || chip_id_high != OV5645_CHIP_ID_HIGH_BYTE) {
> +		dev_err(dev, "could not read ID high\n");
> +		ret = -ENODEV;
> +		goto power_down;
> +	}
> +	ret = ov5645_read_reg(ov5645, OV5645_CHIP_ID_LOW, &chip_id_low);
> +	if (ret < 0 || chip_id_low != OV5645_CHIP_ID_LOW_BYTE) {
> +		dev_err(dev, "could not read ID low\n");
> +		ret = -ENODEV;
> +		goto power_down;
> +	}

I would do this before registering the subdev, as you don't want to make it 
available to the system if the ID doesn't match.

> +
> +	dev_info(dev, "OV5645 detected at address 0x%02x\n", client->addr);
> +
> +	ov5645_s_power(&ov5645->sd, false);
> +
> +	return 0;
> +
> +power_down:
> +	ov5645_s_power(&ov5645->sd, false);
> +unregister_subdev:
> +	v4l2_async_unregister_subdev(&ov5645->sd);
> +free_entity:
> +	media_entity_cleanup(&ov5645->sd.entity);
> +free_ctrl:
> +	v4l2_ctrl_handler_free(&ov5645->ctrls);
> +	mutex_destroy(&ov5645->power_lock);
> +
> +	return ret;
> +}
> +
> +
> +static int ov5645_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct ov5645 *ov5645 = to_ov5645(sd);
> +
> +	v4l2_async_unregister_subdev(&ov5645->sd);
> +	media_entity_cleanup(&ov5645->sd.entity);
> +	v4l2_ctrl_handler_free(&ov5645->ctrls);
> +	mutex_destroy(&ov5645->power_lock);
> +
> +	return 0;
> +}
> +
> +
> +static const struct i2c_device_id ov5645_id[] = {
> +	{ "ov5645", 0 },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(i2c, ov5645_id);
> +
> +static const struct of_device_id ov5645_of_match[] = {
> +	{ .compatible = "ovti,ov5645" },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, ov5645_of_match);
> +
> +static struct i2c_driver ov5645_i2c_driver = {
> +	.driver = {
> +		.of_match_table = of_match_ptr(ov5645_of_match),
> +		.name  = "ov5645",
> +	},
> +	.probe  = ov5645_probe,
> +	.remove = ov5645_remove,
> +	.id_table = ov5645_id,
> +};
> +
> +module_i2c_driver(ov5645_i2c_driver);
> +
> +MODULE_DESCRIPTION("Omnivision OV5645 Camera Driver");
> +MODULE_AUTHOR("Todor Tomov <todor.tomov@linaro.org>");
> +MODULE_LICENSE("GPL v2");

-- 
Regards,

Laurent Pinchart

