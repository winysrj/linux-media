Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33079 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750914AbeC0Mjn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 08:39:43 -0400
Received: by mail-wr0-f193.google.com with SMTP id z73so22276358wrb.0
        for <linux-media@vger.kernel.org>; Tue, 27 Mar 2018 05:39:43 -0700 (PDT)
References: <20180313113311.8617-1-rui.silva@linaro.org> <20180313113311.8617-3-rui.silva@linaro.org> <20180324105748.nwrw2grdqq2hrjlh@valkosipuli.retiisi.org.uk>
From: Rui Miguel Silva <rui.silva@linaro.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Rui Miguel Silva <rui.silva@linaro.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ryan Harkin <ryan.harkin@linaro.org>
Subject: Re: [PATCH v3 2/2] media: ov2680: Add Omnivision OV2680 sensor driver
In-reply-to: <20180324105748.nwrw2grdqq2hrjlh@valkosipuli.retiisi.org.uk>
Date: Tue, 27 Mar 2018 13:39:40 +0100
Message-ID: <m3efk5r8tv.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,
On Sat 24 Mar 2018 at 10:57, Sakari Ailus wrote:
> Hi Rui,
>
> I wanted to go through the code the last time and I'd have a few 
> review
> comments below...

Thanks for the review.

>
> On Tue, Mar 13, 2018 at 11:33:11AM +0000, Rui Miguel Silva 
> wrote:
> ...
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
>> +}
>> +
>> +static int ov2680_auto_gain_disable(struct ov2680_dev *sensor)
>> +{
>> +	return ov2680_gain_set(sensor, false);
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
>
> I still think you could call the function actually doing the 
> work, and pass
> the bool parameter. That'd be much clearer. Please see the 
> comments below,
> too; they're related. Same for gain.

Ok, no problem, will change that in v4.

>
> ...
>
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
>
> I reckon the purpose of implementing volatile controls here 
> would be to
> provide the exposure and gain values to the user. But the 
> controls here are
> the ones enabling or disabling the automatic behaviour, not the 
> value of
> those settings themselves.
>
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
>
> With this, you can enable or disable automatic exposure and 
> gain, but you
> cannot manually set the values. Are such controls useful?
>
> Unless I'm mistaken, exposure or gain are not settable, so you 
> should make
> them read-only controls. Or better, allow setting them if 
> automatic control
> is disabled.

Yeah, I could definitely change the values of exposure and gain 
also,
but that may came how the ctrl group work internally. But I will 
change
and add them.

>
>> +	case V4L2_CID_VFLIP:
>> +		if (sensor->is_streaming)
>> +			return -EBUSY;
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
>
> You have only 7 controls.

Yes, good catch.

>
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
>
> What's the frequency the register configuration requires? I 
> think you
> should check the exact frequency here, rather than a wide range. 
> The
> register lists would need to be adapted for other frequencies.

Makes sense, will change also in v4  that will go shortly.

---
Cheers,
	Rui
