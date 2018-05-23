Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:54835 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754092AbeEWHih (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 May 2018 03:38:37 -0400
Date: Wed, 23 May 2018 10:38:33 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: bingbu.cao@intel.com, linux-media@vger.kernel.org,
        bingbu.cao@linux.intel.com, tian.shu.qiu@linux.intel.com,
        rajmohan.mani@intel.com, mchehab@kernel.org
Subject: Re: [PATCH v3] media: imx319: Add imx319 camera sensor driver
Message-ID: <20180523073833.onxqj72hi23qkz42@paasikivi.fi.intel.com>
References: <1526886658-14417-1-git-send-email-bingbu.cao@intel.com>
 <1526963581-28655-1-git-send-email-bingbu.cao@intel.com>
 <20180522200848.GB15035@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180522200848.GB15035@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo and Bingbu,

On Tue, May 22, 2018 at 10:08:48PM +0200, jacopo mondi wrote:
...
> > +/* Get bayer order based on flip setting. */
> > +static __u32 imx319_get_format_code(struct imx319 *imx319)
> > +{
> > +	/*
> > +	 * Only one bayer order is supported.
> > +	 * It depends on the flip settings.
> > +	 */
> > +	static const __u32 codes[2][2] = {
> > +		{ MEDIA_BUS_FMT_SRGGB10_1X10, MEDIA_BUS_FMT_SGRBG10_1X10, },
> > +		{ MEDIA_BUS_FMT_SGBRG10_1X10, MEDIA_BUS_FMT_SBGGR10_1X10, },
> > +	};
> > +
> > +	return codes[imx319->vflip->val][imx319->hflip->val];
> > +}
> 
> I don't have any major comment actually, this is pretty good for a
> first submission.
> 
> This worries me a bit though. The media bus format depends on the
> V/HFLIP value, I assume this is an hardware limitation. But if
> changing the flip changes the reported media bus format, you could
> trigger a -EPIPE error during pipeline format validation between two
> streaming sessions with different flip settings. Isn't this a bit
> dangerous?

That's how it works on raw bayer sensors; you do have to configure the
entire pipeline accordingly.

What it also means is that the two controls may not be changed during
streaming --- this needs to be prevented by the driver, and I think it's
missing at the moment.

> 
> Below some minor comments.
> 
> > +
> > +/* Read registers up to 4 at a time */
> > +static int imx319_read_reg(struct imx319 *imx319, u16 reg, u32 len, u32 *val)
> > +{
> > +	struct i2c_client *client = v4l2_get_subdevdata(&imx319->sd);
> > +	struct i2c_msg msgs[2];
> > +	u8 addr_buf[2];
> > +	u8 data_buf[4] = { 0 };
> > +	int ret;
> > +
> > +	if (len > 4)
> > +		return -EINVAL;
> > +
> > +	put_unaligned_be16(reg, addr_buf);
> > +	/* Write register address */
> > +	msgs[0].addr = client->addr;
> > +	msgs[0].flags = 0;
> > +	msgs[0].len = ARRAY_SIZE(addr_buf);
> > +	msgs[0].buf = addr_buf;
> > +
> > +	/* Read data from register */
> > +	msgs[1].addr = client->addr;
> > +	msgs[1].flags = I2C_M_RD;
> > +	msgs[1].len = len;
> > +	msgs[1].buf = &data_buf[4 - len];
> > +
> > +	ret = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
> > +	if (ret != ARRAY_SIZE(msgs))
> > +		return -EIO;
> > +
> > +	*val = get_unaligned_be32(data_buf);
> > +
> > +	return 0;
> > +}
> > +
> > +/* Write registers up to 4 at a time */
> > +static int imx319_write_reg(struct imx319 *imx319, u16 reg, u32 len, u32 val)
> > +{
> > +	struct i2c_client *client = v4l2_get_subdevdata(&imx319->sd);
> > +	u8 buf[6];
> > +
> > +	if (len > 4)
> > +		return -EINVAL;
> > +
> > +	put_unaligned_be16(reg, buf);
> > +	put_unaligned_be32(val << (8 * (4 - len)), buf + 2);
> > +	if (i2c_master_send(client, buf, len + 2) != len + 2)
> > +		return -EIO;
> > +
> > +	return 0;
> > +}
> > +
> > +/* Write a list of registers */
> > +static int imx319_write_regs(struct imx319 *imx319,
> > +			      const struct imx319_reg *regs, u32 len)
> > +{
> > +	struct i2c_client *client = v4l2_get_subdevdata(&imx319->sd);
> > +	int ret;
> > +	u32 i;
> > +
> > +	for (i = 0; i < len; i++) {
> > +		ret = imx319_write_reg(imx319, regs[i].address, 1,
> > +					regs[i].val);
> 
> Unaligned to open parenthesis
> 
> > +		if (ret) {
> > +			dev_err_ratelimited(
> > +				&client->dev,
> > +				"Failed to write reg 0x%4.4x. error = %d\n",
> > +				regs[i].address, ret);
> 
> No need to break line, align to open parenthesis, please.
> 
> > +
> > +			return ret;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/* Open sub-device */
> > +static int imx319_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> > +{
> > +	struct imx319 *imx319 = to_imx319(sd);
> > +	struct v4l2_mbus_framefmt *try_fmt =
> > +		v4l2_subdev_get_try_format(sd, fh->pad, 0);
> > +
> > +	mutex_lock(&imx319->mutex);
> > +
> > +	/* Initialize try_fmt */
> > +	try_fmt->width = imx319->cur_mode->width;
> > +	try_fmt->height = imx319->cur_mode->height;
> > +	try_fmt->code = imx319_get_format_code(imx319);

The initial try format should reflect the default, not the current
configuration.

> > +	try_fmt->field = V4L2_FIELD_NONE;
> > +
> > +	mutex_unlock(&imx319->mutex);
> > +
> > +	return 0;
> > +}
> > +
> > +static int imx319_update_digital_gain(struct imx319 *imx319, u32 d_gain)
> > +{
> > +	int ret;
> > +
> > +	ret = imx319_write_reg(imx319, IMX319_REG_DPGA_USE_GLOBAL_GAIN, 1, 1);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* Digital gain = (d_gain & 0xFF00) + (d_gain & 0xFF)/256 times */
> > +	return imx319_write_reg(imx319, IMX319_REG_DIG_GAIN_GLOBAL, 2, d_gain);
> > +}
> > +
> > +static int imx319_set_ctrl(struct v4l2_ctrl *ctrl)
> > +{
> > +	struct imx319 *imx319 = container_of(ctrl->handler,
> > +					     struct imx319, ctrl_handler);
> > +	struct i2c_client *client = v4l2_get_subdevdata(&imx319->sd);
> > +	s64 max;
> > +	int ret;
> > +
> > +	/* Propagate change of current control to all related controls */
> > +	switch (ctrl->id) {
> > +	case V4L2_CID_VBLANK:
> > +		/* Update max exposure while meeting expected vblanking */
> > +		max = imx319->cur_mode->height + ctrl->val - 18;
> > +		__v4l2_ctrl_modify_range(imx319->exposure,
> > +					 imx319->exposure->minimum,
> > +					 max, imx319->exposure->step, max);
> > +		break;
> > +	}
> > +
> > +	/*
> > +	 * Applying V4L2 control value only happens
> > +	 * when power is up for streaming
> > +	 */
> > +	if (pm_runtime_get_if_in_use(&client->dev) == 0)
> > +		return 0;
> 
> I assume powering is handled through ACPI somehow, I know nothing

Power management takes place though ACPI, indeed "somehow" is a good
description of it from a driver developer's point of view. :-) The drivers
simply use runtime PM to invoke it.

> about that, but I wonder why setting controls should be enabled only
> when streaming. I would have expected runtime_pm_get/put in subdevices
> node open/close functions not only when streaming. Am I missing something?

You can do it either way. If powering on the sensor takes a long time, then
doing that in the open callback may be helpful as the user space has a way
to keep the device powered.

> 
> > +
> > +	switch (ctrl->id) {
> > +	case V4L2_CID_ANALOGUE_GAIN:
> > +		/* Analog gain = 1024/(1024 - ctrl->val) times */
> > +		ret = imx319_write_reg(imx319, IMX319_REG_ANALOG_GAIN,
> > +				       2, ctrl->val);
> > +		break;
> > +	case V4L2_CID_DIGITAL_GAIN:
> > +		ret = imx319_update_digital_gain(imx319, ctrl->val);
> > +		break;
> > +	case V4L2_CID_EXPOSURE:
> > +		ret = imx319_write_reg(imx319, IMX319_REG_EXPOSURE,
> > +				       2, ctrl->val);
> > +		break;
> > +	case V4L2_CID_VBLANK:
> > +		/* Update FLL that meets expected vertical blanking */
> > +		ret = imx319_write_reg(imx319, IMX319_REG_FLL, 2,
> > +				       imx319->cur_mode->height + ctrl->val);
> > +		break;
> > +	case V4L2_CID_TEST_PATTERN:
> > +		ret = imx319_write_reg(imx319, IMX319_REG_TEST_PATTERN,
> > +				       2, imx319_test_pattern_val[ctrl->val]);
> > +		break;
> > +	case V4L2_CID_HFLIP:
> > +	case V4L2_CID_VFLIP:
> > +		ret = imx319_write_reg(imx319, IMX319_REG_ORIENTATION, 1,
> > +				       imx319->hflip->val |
> > +				       imx319->vflip->val << 1);
> > +		break;
> > +	default:
> > +		ret = -EINVAL;
> > +		dev_info(&client->dev,
> > +			 "ctrl(id:0x%x,val:0x%x) is not handled\n",
> > +			 ctrl->id, ctrl->val);
> > +		break;
> > +	}
> > +
> > +	pm_runtime_put(&client->dev);
> > +
> > +	return ret;
> > +}
> > +
> > +static const struct v4l2_ctrl_ops imx319_ctrl_ops = {
> > +	.s_ctrl = imx319_set_ctrl,
> > +};
> > +
> > +static int imx319_enum_mbus_code(struct v4l2_subdev *sd,
> > +				  struct v4l2_subdev_pad_config *cfg,
> > +				  struct v4l2_subdev_mbus_code_enum *code)
> > +{
> > +	struct imx319 *imx319 = to_imx319(sd);
> > +
> > +	if (code->index > 0)
> > +		return -EINVAL;
> > +
> > +	code->code = imx319_get_format_code(imx319);
> > +
> > +	return 0;
> > +}
> > +
> > +static int imx319_enum_frame_size(struct v4l2_subdev *sd,
> > +				   struct v4l2_subdev_pad_config *cfg,
> > +				   struct v4l2_subdev_frame_size_enum *fse)
> > +{
> > +	struct imx319 *imx319 = to_imx319(sd);
> > +
> > +	if (fse->index >= ARRAY_SIZE(supported_modes))
> > +		return -EINVAL;
> > +
> > +	if (fse->code != imx319_get_format_code(imx319))
> > +		return -EINVAL;
> > +
> > +	fse->min_width = supported_modes[fse->index].width;
> > +	fse->max_width = fse->min_width;
> > +	fse->min_height = supported_modes[fse->index].height;
> > +	fse->max_height = fse->min_height;
> > +
> > +	return 0;
> > +}
> > +
> > +static void imx319_update_pad_format(struct imx319 *imx319,
> > +				     const struct imx319_mode *mode,
> > +				     struct v4l2_subdev_format *fmt)
> > +{
> > +	fmt->format.width = mode->width;
> > +	fmt->format.height = mode->height;
> > +	fmt->format.code = imx319_get_format_code(imx319);
> > +	fmt->format.field = V4L2_FIELD_NONE;
> > +}
> > +
> > +static int imx319_do_get_pad_format(struct imx319 *imx319,
> > +				     struct v4l2_subdev_pad_config *cfg,
> > +				     struct v4l2_subdev_format *fmt)
> > +{
> > +	struct v4l2_mbus_framefmt *framefmt;
> > +	struct v4l2_subdev *sd = &imx319->sd;
> > +
> > +	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> > +		framefmt = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
> > +		fmt->format = *framefmt;
> > +	} else {
> > +		imx319_update_pad_format(imx319, imx319->cur_mode, fmt);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int imx319_get_pad_format(struct v4l2_subdev *sd,
> > +				  struct v4l2_subdev_pad_config *cfg,
> > +				  struct v4l2_subdev_format *fmt)
> > +{
> > +	struct imx319 *imx319 = to_imx319(sd);
> > +	int ret;
> > +
> > +	mutex_lock(&imx319->mutex);
> > +	ret = imx319_do_get_pad_format(imx319, cfg, fmt);
> > +	mutex_unlock(&imx319->mutex);
> > +
> > +	return ret;
> > +}
> > +
> > +static int
> > +imx319_set_pad_format(struct v4l2_subdev *sd,
> > +		       struct v4l2_subdev_pad_config *cfg,
> > +		       struct v4l2_subdev_format *fmt)
> > +{
> > +	struct imx319 *imx319 = to_imx319(sd);
> > +	const struct imx319_mode *mode;
> > +	struct v4l2_mbus_framefmt *framefmt;
> > +	s32 vblank_def;
> > +	s32 vblank_min;
> > +	s64 h_blank;
> > +	s64 pixel_rate;
> > +
> > +	mutex_lock(&imx319->mutex);
> > +
> > +	/*
> > +	 * Only one bayer order is supported.
> > +	 * It depends on the flip settings.
> > +	 */
> > +	fmt->format.code = imx319_get_format_code(imx319);
> > +
> > +	mode = v4l2_find_nearest_size(supported_modes,
> > +		ARRAY_SIZE(supported_modes), width, height,
> > +		fmt->format.width, fmt->format.height);
> > +	imx319_update_pad_format(imx319, mode, fmt);
> > +	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> > +		framefmt = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
> > +		*framefmt = fmt->format;
> > +	} else {
> > +		imx319->cur_mode = mode;
> > +		pixel_rate =
> > +		(link_freq_menu_items[0] * 2 * 4) / 10;
> 
> This assumes a fixed link frequency and a fixed number of data lanes,
> and a fixed bpp value (but this is ok, as all the formats you have are
> 10bpp). In OF world those parameters come from DT, what about ACPI?

I presume the driver only supports a particular number of lanes (4). ACPI
supports _DSD properties, i.e. the same can be done on ACPI.

If the driver only supports these, then it should check this matches with
what the firmware (ACPI) has. The fwnode API is the same.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
