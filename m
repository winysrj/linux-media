Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:34840 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbcE0L7z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 07:59:55 -0400
Received: by mail-wm0-f54.google.com with SMTP id a136so69381470wme.0
        for <linux-media@vger.kernel.org>; Fri, 27 May 2016 04:59:55 -0700 (PDT)
From: Todor Tomov <todor.tomov@linaro.org>
Subject: Re: [PATCH v2 2/2] media: Add a driver for the ov5645 camera sensor.
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
References: <1463572208-8826-1-git-send-email-todor.tomov@linaro.org>
 <1463572208-8826-3-git-send-email-todor.tomov@linaro.org>
 <573F2B31.1070807@linaro.org>
Cc: Todor Tomov <todor.tomov@linaro.org>, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	devicetree@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, geert@linux-m68k.org, matrandg@cisco.com,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Message-ID: <574836B6.30607@linaro.org>
Date: Fri, 27 May 2016 14:59:50 +0300
MIME-Version: 1.0
In-Reply-To: <573F2B31.1070807@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stan,

Thanks for the review.

On 05/20/2016 06:20 PM, Stanimir Varbanov wrote:
> Hi Todor,
> 
> Thanks for the patch, few comments below.
> 
> On 05/18/2016 02:50 PM, Todor Tomov wrote:
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
>>  drivers/media/i2c/Kconfig  |   11 +
>>  drivers/media/i2c/Makefile |    1 +
>>  drivers/media/i2c/ov5645.c | 1425 ++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 1437 insertions(+)
>>  create mode 100644 drivers/media/i2c/ov5645.c
>>
>> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
>> index 521bbf1..aa17eba 100644
>> --- a/drivers/media/i2c/Kconfig
>> +++ b/drivers/media/i2c/Kconfig
>> @@ -490,6 +490,17 @@ config VIDEO_OV2659
>>  	  To compile this driver as a module, choose M here: the
>>  	  module will be called ov2659.
>>  
>> +config VIDEO_OV5645
>> +	tristate "OmniVision OV5645 sensor support"
>> +	depends on I2C && VIDEO_V4L2
>> +	depends on MEDIA_CAMERA_SUPPORT
> 
> depends on OF ?
Yes, the driver expects to be able to parse data from DT, so I'll add "depends on OF".

> 
> <cut>
> 
>> +
>> +struct ov5645 {
>> +	struct i2c_client *i2c_client;
>> +	struct device *dev;
>> +	struct v4l2_subdev sd;
>> +	struct media_pad pad;
>> +	struct v4l2_of_endpoint ep;
>> +	struct v4l2_mbus_framefmt fmt;
>> +	struct v4l2_rect crop;
>> +	struct clk *xclk;
>> +	u32 xclk_freq;
> 
> this become unused?
Yes, I'll remove it.

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
>> +	struct mutex power_lock; /* lock to protect power state */
>> +	int power;
>> +
>> +	struct gpio_desc *pwdn_gpio;
>> +	struct gpio_desc *rst_gpio;
>> +};
>> +
>> +static inline struct ov5645 *to_ov5645(struct v4l2_subdev *sd)
>> +{
>> +	return container_of(sd, struct ov5645, sd);
>> +}
> 
> <cut>
> 
>> +static int ov5645_s_power(struct v4l2_subdev *sd, int on)
>> +{
>> +	struct ov5645 *ov5645 = to_ov5645(sd);
>> +	int ret = 0;
>> +
>> +	dev_dbg(ov5645->dev, "%s: on = %d\n", __func__, on);
>> +
>> +	mutex_lock(&ov5645->power_lock);
>> +
>> +	/* If the power count is modified from 0 to != 0 or from != 0 to 0,
>> +	 * update the power state.
>> +	 */
>> +	if (ov5645->power == !on) {
>> +		if (on) {
>> +			ret = ov5645_set_power_on(ov5645);
>> +			if (ret < 0) {
>> +				dev_err(ov5645->dev, "could not set power %s\n",
>> +					on ? "on" : "off");
>> +				goto exit;
>> +			}
>> +
>> +			ret = ov5645_init(ov5645);
>> +			if (ret < 0) {
>> +				dev_err(ov5645->dev,
>> +					"could not set init registers\n");
>> +				goto exit;
>> +			}
>> +
>> +			ov5645_write_reg(ov5645, OV5645_SYSTEM_CTRL0,
>> +					 OV5645_SYSTEM_CTRL0_STOP);
> 
> please check the error code.
Ok.

> 
>> +		} else {
>> +			ov5645_set_power_off(ov5645);
>> +		}
>> +
>> +		/* Update the power count. */
>> +		ov5645->power += on ? 1 : -1;
>> +		WARN_ON(ov5645->power < 0);
>> +	}
>> +
>> +exit:
>> +	mutex_unlock(&ov5645->power_lock);
>> +
>> +	return ret;
>> +}
>> +
> 
> <cut>
> 
>> +
>> +static int ov5645_registered(struct v4l2_subdev *subdev)
>> +{
>> +	struct i2c_client *client = v4l2_get_subdevdata(subdev);
>> +	struct ov5645 *ov5645 = to_ov5645(subdev);
>> +	u8 chip_id_high, chip_id_low;
>> +	int ret;
>> +
>> +	ov5645_s_power(&ov5645->sd, true);
> 
> check for error here and on the other places where call s_power.
Ok.

> 
>> +
>> +	ret = ov5645_read_reg(ov5645, OV5645_CHIP_ID_HIGH_REG, &chip_id_high);
>> +	if (ret < 0 || chip_id_high != OV5645_CHIP_ID_HIGH) {
>> +		dev_err(ov5645->dev, "could not read ID high\n");
>> +		ret = -ENODEV;
>> +		goto reg_power_off;
>> +	}
>> +	ret = ov5645_read_reg(ov5645, OV5645_CHIP_ID_LOW_REG, &chip_id_low);
>> +	if (ret < 0 || chip_id_low != OV5645_CHIP_ID_LOW) {
>> +		dev_err(ov5645->dev, "could not read ID low\n");
>> +		ret = -ENODEV;
>> +		goto reg_power_off;
>> +	}
>> +
>> +	dev_info(&client->dev, "OV5645 detected at address 0x%02x\n",
>> +		 client->addr);
>> +
>> +	ov5645_s_power(&ov5645->sd, false);
>> +
>> +	return 0;
>> +
>> +reg_power_off:
>> +	ov5645_s_power(&ov5645->sd, false);
>> +	return ret;
>> +}
>> +
>> +static int ov5645_s_stream(struct v4l2_subdev *subdev, int enable)
>> +{
>> +	struct ov5645 *ov5645 = to_ov5645(subdev);
>> +	int ret;
>> +
>> +	dev_dbg(ov5645->dev, "%s: enable = %d\n", __func__, enable);
>> +
>> +	if (enable) {
>> +		ret = ov5645_change_mode(ov5645, ov5645->current_mode);
>> +		if (ret < 0) {
>> +			dev_err(ov5645->dev, "could not set mode %d\n",
>> +				ov5645->current_mode);
>> +			return ret;
>> +		}
>> +		ret = v4l2_ctrl_handler_setup(&ov5645->ctrls);
>> +		if (ret < 0) {
>> +			dev_err(ov5645->dev, "could not sync v4l2 controls\n");
>> +			return ret;
>> +		}
>> +		ov5645_write_reg(ov5645, OV5645_SYSTEM_CTRL0,
>> +				 OV5645_SYSTEM_CTRL0_START);
> 
> Error code check here and below.
Ok.

> 
>> +	} else {
>> +		ov5645_write_reg(ov5645, OV5645_SYSTEM_CTRL0,
>> +				 OV5645_SYSTEM_CTRL0_STOP);
>> +	}
>> +
>> +	return 0;
>> +}
> 
> <cut>
> 
>> +static int ov5645_probe(struct i2c_client *client,
>> +			const struct i2c_device_id *id)
>> +{
>> +	struct device *dev = &client->dev;
>> +	struct device_node *endpoint;
>> +	struct ov5645 *ov5645;
>> +	int ret = 0;
> 
> no need to initialize
Ok.

> 
> <cut>
> 
>> +
>> +	ov5645->io_regulator = devm_regulator_get(dev, "dovdd");
>> +	if (IS_ERR(ov5645->io_regulator)) {
>> +		switch(PTR_ERR(ov5645->io_regulator)) {
>> +		case -ENODEV:
>> +			/* Regulator is optional so this is ok - continue */
> 
> if the regulator is optional then use devm_regulator_get_optional, thus
> you can avoid checking ov5645->io_regulator for NULL.
> 
> and the error handling will be simply
> 
> if (IS_ERR(ret_reg))
> 	return PTR_ERR(ret_reg);
As discussed in private, the regulators and gpios should not be optional
but required. I'll fix it and resend.

> 
> <cut>
> 
>> +
>> +	ov5645->pwdn_gpio = devm_gpiod_get(dev, "pwdn", GPIOD_OUT_LOW);
>> +	if (IS_ERR(ov5645->pwdn_gpio)) {
>> +		switch(PTR_ERR(ov5645->pwdn_gpio)) {
>> +		case -ENOENT:
>> +			/* GPIO is optional so this is ok - continue */
> 
> you can use devm_gpiod_get_optional then.
> 
>> +			ov5645->pwdn_gpio = NULL;
>> +			dev_dbg(dev, "power down gpio not present\n");
>> +			break;
>> +		case -EPROBE_DEFER:
>> +			dev_dbg(dev, "power down gpio probe defered\n");
>> +			return -EPROBE_DEFER;
>> +		default:
>> +			dev_err(dev, "cannot get power down gpio\n");
>> +			return PTR_ERR(ov5645->pwdn_gpio);
>> +		}
>> +	}
> 
> 

-- 
Best regards,
Todor Tomov
