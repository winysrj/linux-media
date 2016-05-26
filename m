Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:58298 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbcEZIzQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2016 04:55:16 -0400
Subject: Re: [PATCH v2 2/2] media: Add a driver for the ov5645 camera sensor.
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <1463572208-8826-1-git-send-email-todor.tomov@linaro.org>
 <1463572208-8826-3-git-send-email-todor.tomov@linaro.org>
 <5742DD2A.3010706@xs4all.nl>
Cc: Todor Tomov <todor.tomov@linaro.org>, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	devicetree@vger.kernel.org, mchehab@osg.samsung.com,
	geert@linux-m68k.org, matrandg@cisco.com,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
From: Todor Tomov <ttomov@mm-sol.com>
Message-ID: <5746B9EA.4060103@mm-sol.com>
Date: Thu, 26 May 2016 11:55:06 +0300
MIME-Version: 1.0
In-Reply-To: <5742DD2A.3010706@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the review.

On 05/23/2016 01:36 PM, Hans Verkuil wrote:
> Hi Todor,
> 
> Thanks for the patch series! I got a few comments:
> 
> On 05/18/2016 01:50 PM, Todor Tomov wrote:
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
> 
> <snip>
> 
>>
>> +static int ov5645_change_mode(struct ov5645 *ov5645, enum ov5645_mode mode)
>> +{
>> +	struct reg_value *settings;
>> +	u32 num_settings;
>> +	int ret = 0;
>> +
>> +	settings = ov5645_mode_info_data[mode].data;
>> +	num_settings = ov5645_mode_info_data[mode].data_size;
>> +	ret = ov5645_set_register_array(ov5645, settings, num_settings);
> 
> Just do 'return ov5645_set_register_array(ov5645, settings, num_settings);'
> No need for the 'ret' variable.
Ok.

> 
>> +
>> +	return ret;
>> +}
>> +
>> +static int ov5645_set_power_on(struct ov5645 *ov5645)
>> +{
>> +	int ret = 0;
>> +
>> +	dev_dbg(ov5645->dev, "%s: Enter\n", __func__);
>> +
>> +	ret = clk_prepare_enable(ov5645->xclk);
>> +	if (ret < 0) {
>> +		dev_err(ov5645->dev, "clk prepare enable failed\n");
>> +		return ret;
>> +	}
>> +
>> +	ret = ov5645_regulators_enable(ov5645);
>> +	if (ret < 0) {
>> +		clk_disable_unprepare(ov5645->xclk);
>> +		return ret;
>> +	}
>> +
>> +	usleep_range(5000, 15000);
>> +	if (ov5645->pwdn_gpio)
>> +		gpiod_set_value_cansleep(ov5645->pwdn_gpio, 1);
>> +
>> +	usleep_range(1000, 2000);
>> +	if (ov5645->rst_gpio)
>> +		gpiod_set_value_cansleep(ov5645->rst_gpio, 1);
>> +	msleep(20);
>> +
>> +	return ret;
>> +}
>> +
>> +static void ov5645_set_power_off(struct ov5645 *ov5645)
>> +{
>> +	dev_dbg(ov5645->dev, "%s: Enter\n", __func__);
>> +
>> +	if (ov5645->rst_gpio)
>> +		gpiod_set_value_cansleep(ov5645->rst_gpio, 0);
>> +	if (ov5645->pwdn_gpio)
>> +		gpiod_set_value_cansleep(ov5645->pwdn_gpio, 0);
>> +	ov5645_regulators_disable(ov5645);
>> +	clk_disable_unprepare(ov5645->xclk);
>> +}
>> +
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
>> +		} else {
>> +			ov5645_set_power_off(ov5645);
>> +		}
>> +
>> +		/* Update the power count. */
>> +		ov5645->power += on ? 1 : -1;
> 
> Huh? Is ov5645->power a bool or a counter? If it is a counter then this line
> should be outside this 'if'. If it is a bool, then the comments (and the
> power field itself!) should be updated.
> 
> As far as I can tell, the 'power' field should be a bool and everything should
> be updated accordingly.
Yes, I'll change it to bool.

> 
> 
>> +		WARN_ON(ov5645->power < 0);
>> +	}
>> +
>> +exit:
>> +	mutex_unlock(&ov5645->power_lock);
>> +
>> +	return ret;
>> +}
>> +
>> +
>> +static int ov5645_set_saturation(struct ov5645 *ov5645, s32 value)
>> +{
>> +	u32 reg_value = (value * 0x10) + 0x40;
>> +	int ret = 0;
>> +
>> +	ret |= ov5645_write_reg(ov5645, OV5645_SDE_SAT_U, reg_value);
>> +	ret |= ov5645_write_reg(ov5645, OV5645_SDE_SAT_V, reg_value);
>> +
>> +	dev_dbg(ov5645->dev, "%s: value = %d\n", __func__, value);
>> +
>> +	return ret;
>> +}
>> +
>> +static int ov5645_set_hflip(struct ov5645 *ov5645, s32 value)
>> +{
>> +	u8 val;
>> +
>> +	ov5645_read_reg(ov5645, OV5645_TIMING_TC_REG21, &val);
>> +	if (value == 0)
>> +		val &= ~(OV5645_SENSOR_MIRROR);
>> +	else
>> +		val |= (OV5645_SENSOR_MIRROR);
>> +
>> +	dev_dbg(ov5645->dev, "%s: value = %d\n", __func__, value);
>> +
>> +	return ov5645_write_reg(ov5645, OV5645_TIMING_TC_REG21, val);
>> +}
>> +
>> +static int ov5645_set_vflip(struct ov5645 *ov5645, s32 value)
>> +{
>> +	u8 val;
>> +
>> +	ov5645_read_reg(ov5645, OV5645_TIMING_TC_REG20, &val);
>> +	if (value == 0)
>> +		val |= (OV5645_SENSOR_VFLIP | OV5645_ISP_VFLIP);
>> +	else
>> +		val &= ~(OV5645_SENSOR_VFLIP | OV5645_ISP_VFLIP);
>> +
>> +	dev_dbg(ov5645->dev, "%s: value = %d\n", __func__, value);
>> +
>> +	return ov5645_write_reg(ov5645, OV5645_TIMING_TC_REG20, val);
>> +}
>> +
>> +static int ov5645_set_test_pattern(struct ov5645 *ov5645, s32 value)
>> +{
>> +	u8 val;
>> +
>> +	ov5645_read_reg(ov5645, OV5645_PRE_ISP_TEST_SETTING_1, &val);
>> +
>> +	if (value) {
>> +		val &= ~OV5645_SET_TEST_PATTERN(OV5645_TEST_PATTERN_MASK);
>> +		val |= OV5645_SET_TEST_PATTERN(value - 1);
>> +		val |= OV5645_TEST_PATTERN_ENABLE;
>> +	} else {
>> +		val &= ~OV5645_TEST_PATTERN_ENABLE;
>> +	}
>> +
>> +	dev_dbg(ov5645->dev, "%s: value = %d\n", __func__, value);
>> +
>> +	return ov5645_write_reg(ov5645, OV5645_PRE_ISP_TEST_SETTING_1, val);
>> +}
>> +
>> +static const char * const ov5645_test_pattern_menu[] = {
>> +	"Disabled",
>> +	"Vertical Color Bars",
>> +	"Random Data",
>> +	"Color Square",
>> +	"Black Image",
>> +};
>> +
>> +static int ov5645_set_awb(struct ov5645 *ov5645, s32 enable_auto)
>> +{
>> +	u8 val;
>> +
>> +	ov5645_read_reg(ov5645, OV5645_AWB_MANUAL_CONTROL, &val);
>> +	if (enable_auto)
>> +		val &= ~OV5645_AWB_MANUAL_ENABLE;
>> +	else
>> +		val |= OV5645_AWB_MANUAL_ENABLE;
>> +
>> +	dev_dbg(ov5645->dev, "%s: enable_auto = %d\n", __func__, enable_auto);
>> +
>> +	return ov5645_write_reg(ov5645, OV5645_AWB_MANUAL_CONTROL, val);
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
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov5645_enum_frame_size(struct v4l2_subdev *subdev,
>> +				  struct v4l2_subdev_pad_config *cfg,
>> +				  struct v4l2_subdev_frame_size_enum *fse)
>> +{
>> +	if (fse->index >= OV5645_MODE_MAX)
>> +		return -EINVAL;
>> +
>> +	fse->min_width = ov5645_mode_info_data[fse->index].width;
>> +	fse->max_width = ov5645_mode_info_data[fse->index].width;
>> +	fse->min_height = ov5645_mode_info_data[fse->index].height;
>> +	fse->max_height = ov5645_mode_info_data[fse->index].height;
>> +
>> +	return 0;
>> +}
>> +
>> +static struct v4l2_mbus_framefmt *
>> +__ov5645_get_pad_format(struct ov5645 *ov5645,
>> +			struct v4l2_subdev_pad_config *cfg,
>> +			unsigned int pad,
>> +			enum v4l2_subdev_format_whence which)
>> +{
>> +	switch (which) {
>> +	case V4L2_SUBDEV_FORMAT_TRY:
>> +		return v4l2_subdev_get_try_format(&ov5645->sd, cfg, pad);
>> +	case V4L2_SUBDEV_FORMAT_ACTIVE:
>> +		return &ov5645->fmt;
>> +	default:
>> +		return NULL;
>> +	}
>> +}
>> +
>> +static int ov5645_get_format(struct v4l2_subdev *sd,
>> +			     struct v4l2_subdev_pad_config *cfg,
>> +			     struct v4l2_subdev_format *format)
>> +{
>> +	struct ov5645 *ov5645 = to_ov5645(sd);
>> +
>> +	format->format = *__ov5645_get_pad_format(ov5645, cfg, format->pad,
>> +						  format->which);
>> +	return 0;
>> +}
>> +
>> +static struct v4l2_rect *
>> +__ov5645_get_pad_crop(struct ov5645 *ov5645, struct v4l2_subdev_pad_config *cfg,
>> +		      unsigned int pad, enum v4l2_subdev_format_whence which)
>> +{
>> +	switch (which) {
>> +	case V4L2_SUBDEV_FORMAT_TRY:
>> +		return v4l2_subdev_get_try_crop(&ov5645->sd, cfg, pad);
>> +	case V4L2_SUBDEV_FORMAT_ACTIVE:
>> +		return &ov5645->crop;
>> +	default:
>> +		return NULL;
>> +	}
>> +}
>> +
>> +static enum ov5645_mode ov5645_find_nearest_mode(struct ov5645 *ov5645,
>> +						 int width, int height)
>> +{
>> +	int i;
>> +
>> +	for (i = OV5645_MODE_MAX; i >= 0; i--) {
>> +		if (ov5645_mode_info_data[i].width <= width &&
>> +		    ov5645_mode_info_data[i].height <= height)
>> +			break;
>> +	}
>> +
>> +	if (i < 0)
>> +		i = 0;
>> +
>> +	return (enum ov5645_mode)i;
>> +}
>> +
>> +static int ov5645_set_format(struct v4l2_subdev *sd,
>> +			     struct v4l2_subdev_pad_config *cfg,
>> +			     struct v4l2_subdev_format *format)
>> +{
>> +	struct ov5645 *ov5645 = to_ov5645(sd);
>> +	struct v4l2_mbus_framefmt *__format;
>> +	struct v4l2_rect *__crop;
>> +	enum ov5645_mode new_mode;
>> +
>> +	__crop = __ov5645_get_pad_crop(ov5645, cfg, format->pad,
>> +			format->which);
>> +
>> +	new_mode = ov5645_find_nearest_mode(ov5645,
>> +			format->format.width, format->format.height);
>> +	__crop->width = ov5645_mode_info_data[new_mode].width;
>> +	__crop->height = ov5645_mode_info_data[new_mode].height;
>> +
>> +	ov5645->current_mode = new_mode;
>> +
>> +	__format = __ov5645_get_pad_format(ov5645, cfg, format->pad,
>> +			format->which);
>> +	__format->width = __crop->width;
>> +	__format->height = __crop->height;
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov5645_get_selection(struct v4l2_subdev *sd,
>> +			   struct v4l2_subdev_pad_config *cfg,
>> +			   struct v4l2_subdev_selection *sel)
>> +{
>> +	struct ov5645 *ov5645 = to_ov5645(sd);
>> +
>> +	if (sel->target != V4L2_SEL_TGT_CROP)
>> +		return -EINVAL;
>> +
>> +	sel->r = *__ov5645_get_pad_crop(ov5645, cfg, sel->pad,
>> +					    sel->which);
>> +	return 0;
>> +}
>> +
>> +static int ov5645_registered(struct v4l2_subdev *subdev)
>> +{
>> +	struct i2c_client *client = v4l2_get_subdevdata(subdev);
>> +	struct ov5645 *ov5645 = to_ov5645(subdev);
>> +	u8 chip_id_high, chip_id_low;
>> +	int ret;
>> +
>> +	ov5645_s_power(&ov5645->sd, true);
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
> 
> Why do this here instead of in the probe() function? I see no reason for
> having a ov5645_registered() function.
Ok, I'll move it to the probe.

> 
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
>> +	} else {
>> +		ov5645_write_reg(ov5645, OV5645_SYSTEM_CTRL0,
>> +				 OV5645_SYSTEM_CTRL0_STOP);
>> +	}
>> +
>> +	return 0;
>> +}
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
>> +
>> +static const struct v4l2_subdev_internal_ops ov5645_subdev_internal_ops = {
>> +	.registered = ov5645_registered,
>> +};
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
>> +	ov5645->fmt.colorspace = V4L2_COLORSPACE_SRGB;
>> +	ov5645->current_mode = OV5645_MODE_1080P;
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
>> +	ov5645->io_regulator = devm_regulator_get(dev, "dovdd");
>> +	if (IS_ERR(ov5645->io_regulator)) {
>> +		switch(PTR_ERR(ov5645->io_regulator)) {
>> +		case -ENODEV:
>> +			/* Regulator is optional so this is ok - continue */
>> +			ov5645->io_regulator = NULL;
>> +			dev_dbg(dev, "io regulator not present\n");
>> +			break;
>> +		case -EPROBE_DEFER:
>> +			dev_dbg(dev, "io regulator probe defered\n");
>> +			return -EPROBE_DEFER;
>> +		default:
>> +			dev_err(dev, "cannot get io regulator\n");
>> +			return PTR_ERR(ov5645->io_regulator);
>> +		}
>> +	} else {
>> +		ret = regulator_set_voltage(ov5645->io_regulator,
>> +					     OV5645_VOLTAGE_DIGITAL_IO,
>> +					     OV5645_VOLTAGE_DIGITAL_IO);
>> +		if (ret < 0) {
>> +			dev_err(dev, "cannot set io voltage\n");
>> +			return ret;
>> +		}
>> +	}
>> +
>> +	ov5645->core_regulator = devm_regulator_get(dev, "dvdd");
>> +	if (IS_ERR(ov5645->core_regulator)) {
>> +		switch(PTR_ERR(ov5645->core_regulator)) {
>> +		case -ENODEV:
>> +			/* Regulator is optional so this is ok - continue */
>> +			ov5645->core_regulator = NULL;
>> +			dev_dbg(dev, "core regulator not present\n");
>> +			break;
>> +		case -EPROBE_DEFER:
>> +			dev_dbg(dev, "core regulator probe defered\n");
>> +			return -EPROBE_DEFER;
>> +		default:
>> +			dev_err(dev, "cannot get core regulator\n");
>> +			return PTR_ERR(ov5645->core_regulator);
>> +		}
>> +	} else {
>> +		ret = regulator_set_voltage(ov5645->core_regulator,
>> +					     OV5645_VOLTAGE_DIGITAL_CORE,
>> +					     OV5645_VOLTAGE_DIGITAL_CORE);
>> +		if (ret < 0) {
>> +			dev_err(dev, "cannot set core voltage\n");
>> +			return ret;
>> +		}
>> +	}
>> +
>> +	ov5645->analog_regulator = devm_regulator_get(dev, "avdd");
>> +	if (IS_ERR(ov5645->analog_regulator)) {
>> +		switch(PTR_ERR(ov5645->analog_regulator)) {
>> +		case -ENODEV:
>> +			/* Regulator is optional so this is ok - continue */
>> +			ov5645->analog_regulator = NULL;
>> +			dev_dbg(dev, "analog regulator not present\n");
>> +			break;
>> +		case -EPROBE_DEFER:
>> +			dev_dbg(dev, "analog regulator probe defered\n");
>> +			return -EPROBE_DEFER;
>> +		default:
>> +			dev_err(dev, "cannot get analog regulator\n");
>> +			return PTR_ERR(ov5645->analog_regulator);
>> +		}
>> +	} else {
>> +		ret = regulator_set_voltage(ov5645->analog_regulator,
>> +					     OV5645_VOLTAGE_ANALOG,
>> +					     OV5645_VOLTAGE_ANALOG);
>> +		if (ret < 0) {
>> +			dev_err(dev, "cannot set analog voltage\n");
>> +			return ret;
>> +		}
>> +	}
>> +
>> +	ov5645->pwdn_gpio = devm_gpiod_get(dev, "pwdn", GPIOD_OUT_LOW);
>> +	if (IS_ERR(ov5645->pwdn_gpio)) {
>> +		switch(PTR_ERR(ov5645->pwdn_gpio)) {
>> +		case -ENOENT:
>> +			/* GPIO is optional so this is ok - continue */
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
>> +
>> +	ov5645->rst_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_LOW);
>> +	if (IS_ERR(ov5645->rst_gpio)) {
>> +		switch(PTR_ERR(ov5645->rst_gpio)) {
>> +		case -ENOENT:
>> +			/* GPIO is optional so this is ok - continue */
>> +			ov5645->rst_gpio = NULL;
>> +			dev_dbg(dev, "reset gpio not present\n");
>> +			break;
>> +		case -EPROBE_DEFER:
>> +			dev_dbg(dev, "reset gpio probe defered\n");
>> +			return -EPROBE_DEFER;
>> +		default:
>> +			dev_err(dev, "cannot get reset gpio\n");
>> +			return PTR_ERR(ov5645->rst_gpio);
>> +		}
>> +	}
>> +
>> +	mutex_init(&ov5645->power_lock);
>> +
>> +	v4l2_ctrl_handler_init(&ov5645->ctrls, 7);
>> +	ov5645->saturation = v4l2_ctrl_new_std(&ov5645->ctrls, &ov5645_ctrl_ops,
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
>> +				ARRAY_SIZE(ov5645_test_pattern_menu) - 1, 0, 0,
>> +				ov5645_test_pattern_menu);
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
>> +	ret = media_entity_init(&ov5645->sd.entity, 1, &ov5645->pad, 0);
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
>> +	return 0;
>> +
>> +free_entity:
>> +	media_entity_cleanup(&ov5645->sd.entity);
>> +free_ctrl:
>> +	v4l2_ctrl_handler_free(&ov5645->ctrls);
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
>> +#if IS_ENABLED(CONFIG_OF)
>> +static const struct of_device_id ov5645_of_match[] = {
>> +	{ .compatible = "ovti,ov5645" },
>> +	{ /* sentinel */ }
>> +};
>> +MODULE_DEVICE_TABLE(of, ov5645_of_match);
>> +#endif
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
>>
> 
> Regards,
> 
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Best regards,
Todor Tomov
