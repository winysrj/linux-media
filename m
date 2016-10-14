Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:32938 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754175AbcJNL5G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 07:57:06 -0400
Received: by mail-lf0-f45.google.com with SMTP id x79so197338226lff.0
        for <linux-media@vger.kernel.org>; Fri, 14 Oct 2016 04:57:05 -0700 (PDT)
Subject: Re: [PATCH v6 2/2] media: Add a driver for the ov5645 camera sensor.
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1473326035-25228-1-git-send-email-todor.tomov@linaro.org>
 <1473326035-25228-3-git-send-email-todor.tomov@linaro.org>
 <1739314.RkalEXrcbu@avalon>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mchehab@osg.samsung.com, hverkuil@xs4all.nl, geert@linux-m68k.org,
        matrandg@cisco.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <5800C80D.4000006@linaro.org>
Date: Fri, 14 Oct 2016 14:57:01 +0300
MIME-Version: 1.0
In-Reply-To: <1739314.RkalEXrcbu@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thank you for the time spent to do this thorough review of the patch!

Below I have removed some of the comments where I agree and I'll fix.
I have left the places where I have something relevant to say or ask.


On 09/08/2016 03:22 PM, Laurent Pinchart wrote:
> Hi Todor,
> 
> Thank you for the patch.
> 
> On Thursday 08 Sep 2016 12:13:55 Todor Tomov wrote:
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
>>  drivers/media/i2c/Kconfig  |   12 +
>>  drivers/media/i2c/Makefile |    1 +
>>  drivers/media/i2c/ov5645.c | 1372 +++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 1385 insertions(+)
>>  create mode 100644 drivers/media/i2c/ov5645.c
> 
> [snip]
> 
>> diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
>> new file mode 100644
>> index 0000000..5e5c37e
>> --- /dev/null
>> +++ b/drivers/media/i2c/ov5645.c
>> @@ -0,0 +1,1372 @@
> 
> [snip]
> 

[snip]

>> +static inline struct ov5645 *to_ov5645(struct v4l2_subdev *sd)
>> +{
>> +	return container_of(sd, struct ov5645, sd);
>> +}
>> +
>> +static struct reg_value ov5645_global_init_setting[] = {
> 
> You can make this static const. Same comment for the other register arrays.
Ok.

> 
>> +	{ 0x3103, 0x11 },
>> +	{ 0x3008, 0x82 },
>> +	{ 0x3008, 0x42 },
>> +	{ 0x3103, 0x03 },
>> +	{ 0x3503, 0x07 },
> 
> [snip]
> 
>> +	{ 0x3503, 0x00 },
> 
> Can't you get rid of the first write to 0x3503 ?
No, this is a startup sequence from the vendor so I'm following it as it is.

[snip]

>> +static int ov5645_regulators_enable(struct ov5645 *ov5645)
>> +{
>> +	int ret;
>> +
>> +	ret = regulator_enable(ov5645->io_regulator);
>> +	if (ret < 0) {
>> +		dev_err(ov5645->dev, "set io voltage failed\n");
>> +		return ret;
>> +	}
>> +
>> +	ret = regulator_enable(ov5645->core_regulator);
>> +	if (ret) {
>> +		dev_err(ov5645->dev, "set core voltage failed\n");
>> +		goto err_disable_io;
>> +	}
>> +
>> +	ret = regulator_enable(ov5645->analog_regulator);
>> +	if (ret) {
>> +		dev_err(ov5645->dev, "set analog voltage failed\n");
>> +		goto err_disable_core;
>> +	}
> 
> How about using the regulator bulk API ? This would simplify the enable and 
> disable functions.
The driver must enable the regulators in this order. I can see in the
implementation of the bulk api that they are enabled again in order
but I don't see stated anywhere that it is guaranteed to follow the
same order in future. I'd prefer to keep it explicit as it is now. 

[snip]

>> +static int ov5645_set_power_on(struct ov5645 *ov5645)
>> +{
>> +	int ret;
>> +
>> +	clk_set_rate(ov5645->xclk, ov5645->xclk_freq);
> 
> Is this needed every time you power the sensor on or could you do it just once 
> at probe time ?
I'll move it at probe time.

> 
>> +	ret = clk_prepare_enable(ov5645->xclk);
>> +	if (ret < 0) {
>> +		dev_err(ov5645->dev, "clk prepare enable failed\n");
>> +		return ret;
>> +	}
> 
> Is it safe to start the clock before the regulators ? Driving an input of an 
> unpowered chip can lead to latch-up issues.
Correct, power should be enabled first. I'll fix this.

> 
>> +	ret = ov5645_regulators_enable(ov5645);
>> +	if (ret < 0) {
>> +		clk_disable_unprepare(ov5645->xclk);
>> +		return ret;
>> +	}
>> +
>> +	usleep_range(5000, 15000);
>> +	gpiod_set_value_cansleep(ov5645->enable_gpio, 1);
>> +
>> +	usleep_range(1000, 2000);
>> +	gpiod_set_value_cansleep(ov5645->rst_gpio, 0);
>> +
>> +	msleep(20);
>> +
>> +	return ret;
> 
> You can return 0.
Ok.

[snip]

>> +static int ov5645_set_hflip(struct ov5645 *ov5645, s32 value)
>> +{
>> +	u8 val;
>> +	int ret;
>> +
>> +	ret = ov5645_read_reg(ov5645, OV5645_TIMING_TC_REG21, &val);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	if (value == 0)
>> +		val &= ~(OV5645_SENSOR_MIRROR);
>> +	else
>> +		val |= (OV5645_SENSOR_MIRROR);
>> +
>> +	return ov5645_write_reg(ov5645, OV5645_TIMING_TC_REG21, val);
> 
> You could cache this register too.
Ok.

> 
>> +}
>> +
>> +static int ov5645_set_vflip(struct ov5645 *ov5645, s32 value)
>> +{
>> +	u8 val;
>> +	int ret;
>> +
>> +	ret = ov5645_read_reg(ov5645, OV5645_TIMING_TC_REG20, &val);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	if (value == 0)
>> +		val |= (OV5645_SENSOR_VFLIP | OV5645_ISP_VFLIP);
>> +	else
>> +		val &= ~(OV5645_SENSOR_VFLIP | OV5645_ISP_VFLIP);
>> +
>> +	return ov5645_write_reg(ov5645, OV5645_TIMING_TC_REG20, val);
> 
> And this one as well.
Yes.

> 
> How about using regmap by the way ?
I'd prefer to keep it as is for now.

> 
>> +}
>> +
>> +static int ov5645_set_test_pattern(struct ov5645 *ov5645, s32 value)
>> +{
>> +	u8 val;
>> +	int ret;
>> +
>> +	ret = ov5645_read_reg(ov5645, OV5645_PRE_ISP_TEST_SETTING_1, &val);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	if (value) {
>> +		val &= ~OV5645_SET_TEST_PATTERN(OV5645_TEST_PATTERN_MASK);
>> +		val |= OV5645_SET_TEST_PATTERN(value - 1);
>> +		val |= OV5645_TEST_PATTERN_ENABLE;
>> +	} else {
>> +		val &= ~OV5645_TEST_PATTERN_ENABLE;
>> +	}
>> +
>> +	return ov5645_write_reg(ov5645, OV5645_PRE_ISP_TEST_SETTING_1, val);
> 
> Are there other bits that need to be preserved in this register ?
This driver is based on the driver for OV5645 from QC and the driver for OV5640
that was sent to linux-media. I cannot add additional functionality so I preserve
the rest of the bits. But I'll add caching in a variable here too.

> 
>> +}
>> +
>> +static const char * const ov5645_test_pattern_menu[] = {
>> +	"Disabled",
>> +	"Vertical Color Bars",
>> +	"Pseudo-Random Data",
>> +	"Color Square",
>> +	"Black Image",
>> +};
>> +
>> +static int ov5645_set_awb(struct ov5645 *ov5645, s32 enable_auto)
>> +{
>> +	u8 val;
>> +	int ret;
>> +
>> +	ret = ov5645_read_reg(ov5645, OV5645_AWB_MANUAL_CONTROL, &val);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	if (enable_auto)
>> +		val &= ~OV5645_AWB_MANUAL_ENABLE;
>> +	else
>> +		val |= OV5645_AWB_MANUAL_ENABLE;
>> +
>> +	return ov5645_write_reg(ov5645, OV5645_AWB_MANUAL_CONTROL, val);
> 
> Same here, are there other bits that need to be preserved ?
Same as above.

> 
>> +}
>> +
>> +static int ov5645_s_ctrl(struct v4l2_ctrl *ctrl)
>> +{
>> +	struct ov5645 *ov5645 = container_of(ctrl->handler,
>> +					     struct ov5645, ctrls);
>> +	int ret = -EINVAL;
>> +
>> +	mutex_lock(&ov5645->power_lock);
>> +	if (ov5645->power == 0) {
> 
> power is a bool, I'd thus write this
power will be int now (for ref-counting) but I'll write it like this.

> 
> 	if (!ov5645->power) {
> 
>> +		mutex_unlock(&ov5645->power_lock);
>> +		return 0;
>> +	}
>> +
>> +	switch (ctrl->id) {
>> +	case V4L2_CID_SATURATION:
>> +		ret = ov5645_set_saturation(ov5645, ctrl->val);
>> +		break;
>> +	case V4L2_CID_AUTO_WHITE_BALANCE:
>> +		ret = ov5645_set_awb(ov5645, ctrl->val);
>> +		break;
>> +	case V4L2_CID_AUTOGAIN:
>> +		ret = ov5645_set_agc_mode(ov5645, ctrl->val);
>> +		break;
>> +	case V4L2_CID_EXPOSURE_AUTO:
>> +		ret = ov5645_set_aec_mode(ov5645, ctrl->val);
>> +		break;
>> +	case V4L2_CID_TEST_PATTERN:
>> +		ret = ov5645_set_test_pattern(ov5645, ctrl->val);
>> +		break;
>> +	case V4L2_CID_HFLIP:
>> +		ret = ov5645_set_hflip(ov5645, ctrl->val);
>> +		break;
>> +	case V4L2_CID_VFLIP:
>> +		ret = ov5645_set_vflip(ov5645, ctrl->val);
>> +		break;
> 
> Instead of initializing ret to -EINVAL you could add a default case here, it 
> would avoid the unnecessary initialization in the common case where ctrl->id 
> is valid.
Ok.

> 
>> +	}
>> +
>> +	mutex_unlock(&ov5645->power_lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static struct v4l2_ctrl_ops ov5645_ctrl_ops = {
>> +	.s_ctrl = ov5645_s_ctrl,
>> +};
>> +
>> +static int ov5645_entity_init_cfg(struct v4l2_subdev *subdev,
>> +				  struct v4l2_subdev_pad_config *cfg)
>> +{
>> +	struct v4l2_subdev_format fmt = { 0 };
>> +
>> +	fmt.which = cfg ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
> 
> The function will always be called with cfg != NULL.
I intend to call this function from probe to init the active format. Will this be ok?

> 
>> +	fmt.format.width = 1920;
>> +	fmt.format.height = 1080;
>> +
>> +	v4l2_subdev_call(subdev, pad, set_fmt, cfg, &fmt);
> 
> You can call ov5645_set_format directly.
Ok.

> 
>> +	return 0;
>> +}
>> +
>> +static int ov5645_enum_mbus_code(struct v4l2_subdev *sd,
>> +				 struct v4l2_subdev_pad_config *cfg,
>> +				 struct v4l2_subdev_mbus_code_enum *code)
>> +{
>> +	struct ov5645 *ov5645 = to_ov5645(sd);
>> +
>> +	if (code->index > 0)
>> +		return -EINVAL;
>> +
>> +	code->code = ov5645->fmt.code;
> 
> Given that ov5645->fmt.code is always equal to MEDIA_BUS_FMT_UYVY8_2X8, you 
> can hardcode the value here. Returning the current code works when only a 
> single one is supported, but is conceptually the wrong thing to do in the code 
> enumeration handler.
Agree.

> 
>> +
>> +	return 0;
>> +}
>> +

[snip]


>> +
>> +static struct v4l2_subdev_core_ops ov5645_core_ops = {
>> +	.s_power = ov5645_s_power,
>> +};
>> +
>> +static struct v4l2_subdev_video_ops ov5645_video_ops = {
>> +	.s_stream = ov5645_s_stream,
>> +};
>> +
>> +static struct v4l2_subdev_pad_ops ov5645_subdev_pad_ops = {
>> +	.init_cfg = ov5645_entity_init_cfg,
>> +	.enum_mbus_code = ov5645_enum_mbus_code,
>> +	.enum_frame_size = ov5645_enum_frame_size,
>> +	.get_fmt = ov5645_get_format,
>> +	.set_fmt = ov5645_set_format,
>> +	.get_selection = ov5645_get_selection,
>> +};
>> +
>> +static struct v4l2_subdev_ops ov5645_subdev_ops = {
>> +	.core = &ov5645_core_ops,
>> +	.video = &ov5645_video_ops,
>> +	.pad = &ov5645_subdev_pad_ops,
>> +};
> 
> You can make all those structures static const.
Ok.

> 
>> +
>> +static const struct v4l2_subdev_internal_ops ov5645_subdev_internal_ops = {
>> +};
>> +
>> +static int ov5645_probe(struct i2c_client *client,
>> +			const struct i2c_device_id *id)
>> +{
>> +	struct device *dev = &client->dev;
>> +	struct device_node *endpoint;
>> +	struct ov5645 *ov5645;
>> +	u8 chip_id_high, chip_id_low;
>> +	int ret;
>> +
>> +	ov5645 = devm_kzalloc(dev, sizeof(struct ov5645), GFP_KERNEL);
>> +	if (!ov5645)
>> +		return -ENOMEM;
>> +
>> +	ov5645->i2c_client = client;
>> +	ov5645->dev = dev;
>> +
>> +	endpoint = of_graph_get_next_endpoint(dev->of_node, NULL);
>> +	if (!endpoint) {
>> +		dev_err(dev, "endpoint node not found\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	ret = v4l2_of_parse_endpoint(endpoint, &ov5645->ep);
>> +	if (ret < 0) {
>> +		dev_err(dev, "parsing endpoint node failed\n");
>> +		return ret;
>> +	}
> 
> You can call of_node_put(endpoint) here instead of twice below.
Yes.

> 
>> +	if (ov5645->ep.bus_type != V4L2_MBUS_CSI2) {
>> +		dev_err(dev, "invalid bus type, must be CSI2\n");
>> +		of_node_put(endpoint);
>> +		return -EINVAL;
>> +	}
>> +	of_node_put(endpoint);
>> +
>> +	/* get system clock (xclk) */
>> +	ov5645->xclk = devm_clk_get(dev, "xclk");
>> +	if (IS_ERR(ov5645->xclk)) {
>> +		dev_err(dev, "could not get xclk");
>> +		return PTR_ERR(ov5645->xclk);
>> +	}
>> +
>> +	ret = of_property_read_u32(dev->of_node, "clock-frequency",
>> +				    &ov5645->xclk_freq);
>> +	if (ret) {
>> +		dev_err(dev, "could not get xclk frequency\n");
>> +		return ret;
>> +	}
> 
> Shouldn't you return an error if the frequency is different than the only one 
> supported by the driver (for which the register values have been computed and 
> hardcoded) ?
Yes, this will be useful.

> 
>> +	ov5645->io_regulator = devm_regulator_get(dev, "vdddo");
>> +	if (IS_ERR(ov5645->io_regulator)) {
>> +		dev_err(dev, "cannot get io regulator\n");
>> +		return PTR_ERR(ov5645->io_regulator);
>> +	}
>> +
>> +	ret = regulator_set_voltage(ov5645->io_regulator,
>> +				    OV5645_VOLTAGE_DIGITAL_IO,
>> +				    OV5645_VOLTAGE_DIGITAL_IO);
>> +	if (ret < 0) {
>> +		dev_err(dev, "cannot set io voltage\n");
>> +		return ret;
>> +	}
>> +
>> +	ov5645->core_regulator = devm_regulator_get(dev, "vddd");
>> +	if (IS_ERR(ov5645->core_regulator)) {
>> +		dev_err(dev, "cannot get core regulator\n");
>> +		return PTR_ERR(ov5645->core_regulator);
>> +	}
>> +
>> +	ret = regulator_set_voltage(ov5645->core_regulator,
>> +				    OV5645_VOLTAGE_DIGITAL_CORE,
>> +				    OV5645_VOLTAGE_DIGITAL_CORE);
>> +	if (ret < 0) {
>> +		dev_err(dev, "cannot set core voltage\n");
>> +		return ret;
>> +	}
>> +
>> +	ov5645->analog_regulator = devm_regulator_get(dev, "vdda");
>> +	if (IS_ERR(ov5645->analog_regulator)) {
>> +		dev_err(dev, "cannot get analog regulator\n");
>> +		return PTR_ERR(ov5645->analog_regulator);
>> +	}
>> +
>> +	ret = regulator_set_voltage(ov5645->analog_regulator,
>> +				    OV5645_VOLTAGE_ANALOG,
>> +				    OV5645_VOLTAGE_ANALOG);
>> +	if (ret < 0) {
>> +		dev_err(dev, "cannot set analog voltage\n");
>> +		return ret;
>> +	}
>> +
>> +	ov5645->enable_gpio = devm_gpiod_get(dev, "enable", GPIOD_OUT_HIGH);
>> +	if (IS_ERR(ov5645->enable_gpio)) {
>> +		dev_err(dev, "cannot get enable gpio\n");
>> +		return PTR_ERR(ov5645->enable_gpio);
>> +	}
>> +
>> +	ov5645->rst_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_HIGH);
>> +	if (IS_ERR(ov5645->rst_gpio)) {
>> +		dev_err(dev, "cannot get reset gpio\n");
>> +		return PTR_ERR(ov5645->rst_gpio);
>> +	}
>> +
>> +	mutex_init(&ov5645->power_lock);
>> +
>> +	v4l2_ctrl_handler_init(&ov5645->ctrls, 7);
>> +	ov5645->saturation = v4l2_ctrl_new_std(&ov5645->ctrls, 
> &ov5645_ctrl_ops,
>> +				V4L2_CID_SATURATION, -4, 4, 1, 0);
>> +	ov5645->hflip = v4l2_ctrl_new_std(&ov5645->ctrls, &ov5645_ctrl_ops,
>> +				V4L2_CID_HFLIP, 0, 1, 1, 0);
>> +	ov5645->vflip = v4l2_ctrl_new_std(&ov5645->ctrls, &ov5645_ctrl_ops,
>> +				V4L2_CID_VFLIP, 0, 1, 1, 0);
>> +	ov5645->autogain = v4l2_ctrl_new_std(&ov5645->ctrls, &ov5645_ctrl_ops,
>> +				V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
>> +	ov5645->autoexposure = v4l2_ctrl_new_std_menu(&ov5645->ctrls,
>> +				&ov5645_ctrl_ops, V4L2_CID_EXPOSURE_AUTO,
>> +				V4L2_EXPOSURE_MANUAL, 0, V4L2_EXPOSURE_AUTO);
>> +	ov5645->awb = v4l2_ctrl_new_std(&ov5645->ctrls, &ov5645_ctrl_ops,
>> +				V4L2_CID_AUTO_WHITE_BALANCE, 0, 1, 1, 1);
>> +	ov5645->pattern = v4l2_ctrl_new_std_menu_items(&ov5645->ctrls,
>> +				&ov5645_ctrl_ops, V4L2_CID_TEST_PATTERN,
>> +				ARRAY_SIZE(ov5645_test_pattern_menu) - 1, 0, 
> 0,
>> +				ov5645_test_pattern_menu);
> 
> You don't need to store all these in the ov5645 structure as they are never 
> used.
Ok.

> 
>> +
>> +	ov5645->sd.ctrl_handler = &ov5645->ctrls;
>> +
>> +	if (ov5645->ctrls.error) {
>> +		dev_err(dev, "%s: control initialization error %d\n",
>> +		       __func__, ov5645->ctrls.error);
>> +		ret = ov5645->ctrls.error;
>> +		goto free_ctrl;
>> +	}
>> +
>> +	v4l2_i2c_subdev_init(&ov5645->sd, client, &ov5645_subdev_ops);
>> +	ov5645->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>> +	ov5645->pad.flags = MEDIA_PAD_FL_SOURCE;
>> +	ov5645->sd.internal_ops = &ov5645_subdev_internal_ops;
>> +
>> +	ret = media_entity_pads_init(&ov5645->sd.entity, 1, &ov5645->pad);
>> +	if (ret < 0) {
>> +		dev_err(dev, "could not register media entity\n");
>> +		goto free_ctrl;
>> +	}
>> +
>> +	ov5645->sd.dev = &client->dev;
>> +	ret = v4l2_async_register_subdev(&ov5645->sd);
>> +	if (ret < 0) {
>> +		dev_err(dev, "could not register v4l2 device\n");
>> +		goto free_entity;
>> +	}
>> +
>> +	ret = ov5645_s_power(&ov5645->sd, true);
>> +	if (ret < 0) {
>> +		dev_err(dev, "could not power up OV5645\n");
>> +		goto unregister_subdev;
>> +	}
>> +
>> +	ret = ov5645_read_reg(ov5645, OV5645_CHIP_ID_HIGH, &chip_id_high);
>> +	if (ret < 0 || chip_id_high != OV5645_CHIP_ID_HIGH_BYTE) {
>> +		dev_err(dev, "could not read ID high\n");
>> +		ret = -ENODEV;
>> +		goto power_down;
>> +	}
>> +	ret = ov5645_read_reg(ov5645, OV5645_CHIP_ID_LOW, &chip_id_low);
>> +	if (ret < 0 || chip_id_low != OV5645_CHIP_ID_LOW_BYTE) {
>> +		dev_err(dev, "could not read ID low\n");
>> +		ret = -ENODEV;
>> +		goto power_down;
>> +	}
> 
> I would do this before registering the subdev, as you don't want to make it 
> available to the system if the ID doesn't match.
Agree, I'll move the registering.

> 
>> +
>> +	dev_info(dev, "OV5645 detected at address 0x%02x\n", client->addr);
>> +
>> +	ov5645_s_power(&ov5645->sd, false);
>> +
>> +	return 0;
>> +
>> +power_down:
>> +	ov5645_s_power(&ov5645->sd, false);
>> +unregister_subdev:
>> +	v4l2_async_unregister_subdev(&ov5645->sd);
>> +free_entity:
>> +	media_entity_cleanup(&ov5645->sd.entity);
>> +free_ctrl:
>> +	v4l2_ctrl_handler_free(&ov5645->ctrls);
>> +	mutex_destroy(&ov5645->power_lock);
>> +
>> +	return ret;
>> +}
>> +
>> +
>> +static int ov5645_remove(struct i2c_client *client)
>> +{
>> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
>> +	struct ov5645 *ov5645 = to_ov5645(sd);
>> +
>> +	v4l2_async_unregister_subdev(&ov5645->sd);
>> +	media_entity_cleanup(&ov5645->sd.entity);
>> +	v4l2_ctrl_handler_free(&ov5645->ctrls);
>> +	mutex_destroy(&ov5645->power_lock);
>> +
>> +	return 0;
>> +}
>> +
>> +
>> +static const struct i2c_device_id ov5645_id[] = {
>> +	{ "ov5645", 0 },
>> +	{}
>> +};
>> +MODULE_DEVICE_TABLE(i2c, ov5645_id);
>> +
>> +static const struct of_device_id ov5645_of_match[] = {
>> +	{ .compatible = "ovti,ov5645" },
>> +	{ /* sentinel */ }
>> +};
>> +MODULE_DEVICE_TABLE(of, ov5645_of_match);
>> +
>> +static struct i2c_driver ov5645_i2c_driver = {
>> +	.driver = {
>> +		.of_match_table = of_match_ptr(ov5645_of_match),
>> +		.name  = "ov5645",
>> +	},
>> +	.probe  = ov5645_probe,
>> +	.remove = ov5645_remove,
>> +	.id_table = ov5645_id,
>> +};
>> +
>> +module_i2c_driver(ov5645_i2c_driver);
>> +
>> +MODULE_DESCRIPTION("Omnivision OV5645 Camera Driver");
>> +MODULE_AUTHOR("Todor Tomov <todor.tomov@linaro.org>");
>> +MODULE_LICENSE("GPL v2");
> 

-- 
Best regards,
Todor Tomov
