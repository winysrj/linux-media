Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52660 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932128AbeBSUlr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 15:41:47 -0500
Date: Mon, 19 Feb 2018 22:41:43 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Todor Tomov <todor.tomov@linaro.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] media: Add a driver for the ov7251 camera sensor
Message-ID: <20180219204143.grx5rcjtp4zjpiyy@valkosipuli.retiisi.org.uk>
References: <1518080018-10403-1-git-send-email-todor.tomov@linaro.org>
 <1518080018-10403-2-git-send-email-todor.tomov@linaro.org>
 <20180216100500.GB14911@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180216100500.GB14911@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Fri, Feb 16, 2018 at 11:05:00AM +0100, jacopo mondi wrote:
...
> > +	/* Update the power count. */
> > +	ov7251->power_count += on ? 1 : -1;
> > +	WARN_ON(ov7251->power_count < 0);
> 
> Is this 'reference counting' necessary? If you receive three
> s_power(1) you would need three s_power(0) to turn the sensor off.
> Is this better than a simple "if it's on, turn it off" and viceversa?

Some drivers did this as the drivers themselves controlled the power state
of the device through open / release callbacks.

> 
> Also, it should not happen that you receive multiple s_power(1) or
> s_power(0), but I may be wrong...

Agreed.

...

> > +static int ov7251_enum_frame_ival(struct v4l2_subdev *subdev,
> > +				  struct v4l2_subdev_pad_config *cfg,
> > +				  struct v4l2_subdev_frame_interval_enum *fie)
> > +{
> > +	int index = fie->index;
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(ov7251_mode_info_data); i++) {
> > +		if (fie->width != ov7251_mode_info_data[i].width ||
> > +		    fie->height != ov7251_mode_info_data[i].height)
> > +			continue;
> 
> You only support 640x480 and you can return immediately
> if provided sizes do not match.
> 
> > +
> > +		if (index-- == 0) {
> > +			fie->interval = ov7251_mode_info_data[i].timeperframe;
> > +			return 0;
> > +		}
> > +	}
> > +
> > +	return -EINVAL;
> > +}
> > +
> > +static struct v4l2_mbus_framefmt *
> > +__ov7251_get_pad_format(struct ov7251 *ov7251,
> > +			struct v4l2_subdev_pad_config *cfg,
> > +			unsigned int pad,
> > +			enum v4l2_subdev_format_whence which)
> > +{
> > +	switch (which) {
> > +	case V4L2_SUBDEV_FORMAT_TRY:
> > +		return v4l2_subdev_get_try_format(&ov7251->sd, cfg, pad);
> > +	case V4L2_SUBDEV_FORMAT_ACTIVE:
> > +		return &ov7251->fmt;
> > +	default:
> > +		return NULL;
> > +	}
> > +}
> > +
> > +static int ov7251_get_format(struct v4l2_subdev *sd,
> > +			     struct v4l2_subdev_pad_config *cfg,
> > +			     struct v4l2_subdev_format *format)
> > +{
> > +	struct ov7251 *ov7251 = to_ov7251(sd);
> > +
> > +	format->format = *__ov7251_get_pad_format(ov7251, cfg, format->pad,
> > +						  format->which);
> > +	return 0;
> > +}
> > +
> > +static struct v4l2_rect *
> > +__ov7251_get_pad_crop(struct ov7251 *ov7251, struct v4l2_subdev_pad_config *cfg,
> > +		      unsigned int pad, enum v4l2_subdev_format_whence which)
> > +{
> > +	switch (which) {
> > +	case V4L2_SUBDEV_FORMAT_TRY:
> > +		return v4l2_subdev_get_try_crop(&ov7251->sd, cfg, pad);
> > +	case V4L2_SUBDEV_FORMAT_ACTIVE:
> > +		return &ov7251->crop;
> > +	default:
> > +		return NULL;
> > +	}
> > +}
> > +
> > +static const struct ov7251_mode_info *
> > +ov7251_find_mode_by_size(unsigned int width, unsigned int height)
> > +{
> > +	unsigned int max_dist_match = (unsigned int) -1;
> > +	int i, n = 0;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(ov7251_mode_info_data); i++) {
> > +		unsigned int dist = min(width, ov7251_mode_info_data[i].width)
> > +				* min(height, ov7251_mode_info_data[i].height);
> > +
> > +		dist = ov7251_mode_info_data[i].width *
> > +				ov7251_mode_info_data[i].height +
> > +			width * height - 2 * dist;
> 
> I didn't get why you assign dist twice here..
> 
> > +
> > +		if (dist < max_dist_match) {
> > +			n = i;
> > +			max_dist_match = dist;
> > +		}
> > +	}
> > +
> > +	return &ov7251_mode_info_data[n];
> > +}
> 
> I do not find that much value in this function, as being all
> ov7251_mode_info_data[] sizes equal you end up returning always the
> first one...

Could you check "[PATCH 1/5] v4l: common: Add a function to obtain best
size from a list" I've sent recently to the list? You could also make use
of that in frame interval enumeration if you change the driver's data
structures a little. Same for ov7251_find_mode_by_ival below.

> 
> > +
> > +#define TIMEPERFRAME_AVG_FPS(t)						\
> > +	(((t).denominator + ((t).numerator >> 1)) / (t).numerator)
> > +
> > +static const struct ov7251_mode_info *
> > +ov7251_find_mode_by_ival(struct ov7251 *ov7251, struct v4l2_fract *timeperframe)
> > +{
> > +	const struct ov7251_mode_info *mode = ov7251->current_mode;
> > +	int fps_req = TIMEPERFRAME_AVG_FPS(*timeperframe);
> > +	unsigned int max_dist_match = (unsigned int) -1;
> > +	int i, n = 0;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(ov7251_mode_info_data); i++) {
> > +		unsigned int dist;
> > +		int fps_tmp;
> > +
> > +		if (mode->width != ov7251_mode_info_data[i].width ||
> > +		    mode->height != ov7251_mode_info_data[i].height)
> > +			continue;
> 
> If the requested sizes do not match any of your supported ones you return the
> first available mode unconditionally (n == 0 at the end of this loop). As this
> device driver only supports 640x480, if mode->width and mode->height do not match
> that, you can force them and then actually match mode on the closest fps in the loop
> 
> > +
> > +		fps_tmp = TIMEPERFRAME_AVG_FPS(
> > +					ov7251_mode_info_data[i].timeperframe);
> > +
> > +		if (fps_req > fps_tmp)
> > +			dist = fps_req - fps_tmp;
> > +		else
> > +			dist = fps_tmp - fps_req;
> 
> You can use abs(fps_req, fps_tmp)
> 
> > +
> > +		if (dist < max_dist_match) {
> > +			n = i;
> > +			max_dist_match = dist;
> > +		}
> > +	}
> > +
> > +	return &ov7251_mode_info_data[n];
> > +}
> > +
> > +static int ov7251_set_format(struct v4l2_subdev *sd,
> > +			     struct v4l2_subdev_pad_config *cfg,
> > +			     struct v4l2_subdev_format *format)
> > +{
> > +	struct ov7251 *ov7251 = to_ov7251(sd);
> > +	struct v4l2_mbus_framefmt *__format;
> > +	struct v4l2_rect *__crop;
> > +	const struct ov7251_mode_info *new_mode;
> > +	int ret;
> > +
> > +	__crop = __ov7251_get_pad_crop(ov7251, cfg, format->pad,
> > +			format->which);
> > +
> > +	new_mode = ov7251_find_mode_by_size(format->format.width,
> > +					    format->format.height);
> > +	__crop->width = new_mode->width;
> > +	__crop->height = new_mode->height;
> 
> This will always be 640x480 (see comment on
> ov7251_find_mode_by_size())
> 
> > +
> > +	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> > +		ret = v4l2_ctrl_s_ctrl_int64(ov7251->pixel_clock,
> > +					     new_mode->pixel_clock);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		ret = v4l2_ctrl_s_ctrl(ov7251->link_freq,
> > +				       new_mode->link_freq);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		ret = v4l2_ctrl_modify_range(ov7251->exposure,
> > +					     1, new_mode->exposure_max,
> > +					     1, new_mode->exposure_def);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		ret = v4l2_ctrl_s_ctrl(ov7251->exposure,
> > +				       new_mode->exposure_def);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +
> > +		ret = v4l2_ctrl_s_ctrl(ov7251->gain, 16);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		ov7251->current_mode = new_mode;
> > +	}
> > +
> > +	__format = __ov7251_get_pad_format(ov7251, cfg, format->pad,
> > +			format->which);
> > +	__format->width = __crop->width;
> > +	__format->height = __crop->height;
> > +	__format->code = MEDIA_BUS_FMT_SBGGR10_1X10;
> > +	__format->field = V4L2_FIELD_NONE;
> > +	__format->colorspace = V4L2_COLORSPACE_SRGB;
> 
> What about ycbcr_enc, quantization and xfer_func fields? Seems like
> you are returning a raw bayer format and I'm not sure if they actually
> applies here...
> 
> > +
> > +	format->format = *__format;
> > +
> > +	return 0;
> > +}
> > +
> > +static int ov7251_entity_init_cfg(struct v4l2_subdev *subdev,
> > +				  struct v4l2_subdev_pad_config *cfg)
> > +{
> > +	struct v4l2_subdev_format fmt = { 0 };
> > +
> > +	fmt.which = cfg ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
> > +	fmt.format.width = 640;
> > +	fmt.format.height = 480;
> > +
> > +	ov7251_set_format(subdev, cfg, &fmt);
> > +
> > +	return 0;
> > +}
> > +
> > +static int ov7251_get_selection(struct v4l2_subdev *sd,
> > +			   struct v4l2_subdev_pad_config *cfg,
> > +			   struct v4l2_subdev_selection *sel)
> > +{
> > +	struct ov7251 *ov7251 = to_ov7251(sd);
> > +
> > +	if (sel->target != V4L2_SEL_TGT_CROP)
> > +		return -EINVAL;
> > +
> > +	sel->r = *__ov7251_get_pad_crop(ov7251, cfg, sel->pad,
> > +					sel->which);
> > +	return 0;
> > +}
> > +
> > +static int ov7251_s_stream(struct v4l2_subdev *subdev, int enable)
> > +{
> > +	struct ov7251 *ov7251 = to_ov7251(subdev);
> > +	int ret;
> > +
> > +	if (enable) {
> > +		ret = ov7251_set_register_array(ov7251,
> > +					ov7251->current_mode->data,
> > +					ov7251->current_mode->data_size);
> > +		if (ret < 0) {
> > +			dev_err(ov7251->dev, "could not set mode %dx%d\n",
> > +				ov7251->current_mode->width,
> > +				ov7251->current_mode->height);
> > +			return ret;
> > +		}
> > +		ret = v4l2_ctrl_handler_setup(&ov7251->ctrls);
> > +		if (ret < 0) {
> > +			dev_err(ov7251->dev, "could not sync v4l2 controls\n");
> > +			return ret;
> > +		}
> > +		ret = ov7251_write_reg(ov7251, OV7251_SC_MODE_SELECT,
> > +				       OV7251_SC_MODE_SELECT_STREAMING);
> > +		if (ret < 0)
> > +			return ret;
> > +	} else {
> > +		ret = ov7251_write_reg(ov7251, OV7251_SC_MODE_SELECT,
> > +				       OV7251_SC_MODE_SELECT_SW_STANDBY);
> > +		if (ret < 0)
> > +			return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int ov7251_get_frame_interval(struct v4l2_subdev *subdev,
> > +				     struct v4l2_subdev_frame_interval *fi)
> > +{
> > +	struct ov7251 *ov7251 = to_ov7251(subdev);
> > +
> > +	fi->interval = ov7251->current_mode->timeperframe;
> > +
> > +	return 0;
> > +}
> > +
> > +static int ov7251_set_frame_interval(struct v4l2_subdev *subdev,
> > +				     struct v4l2_subdev_frame_interval *fi)
> > +{
> > +	struct ov7251 *ov7251 = to_ov7251(subdev);
> > +	const struct ov7251_mode_info *new_mode;
> > +
> > +	new_mode = ov7251_find_mode_by_ival(ov7251, &fi->interval);
> > +
> > +	if (new_mode != ov7251->current_mode) {
> > +		int ret;
> > +
> > +		ret = v4l2_ctrl_s_ctrl_int64(ov7251->pixel_clock,
> > +					     new_mode->pixel_clock);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		ret = v4l2_ctrl_s_ctrl(ov7251->link_freq,
> > +				       new_mode->link_freq);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		ret = v4l2_ctrl_modify_range(ov7251->exposure,
> > +					     1, new_mode->exposure_max,
> > +					     1, new_mode->exposure_def);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		ret = v4l2_ctrl_s_ctrl(ov7251->exposure,
> > +				       new_mode->exposure_def);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		ret = v4l2_ctrl_s_ctrl(ov7251->gain, 16);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		ov7251->current_mode = new_mode;
> > +	}
> > +
> > +	fi->interval = ov7251->current_mode->timeperframe;
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct v4l2_subdev_core_ops ov7251_core_ops = {
> > +	.s_power = ov7251_s_power,
> > +};
> > +
> > +static const struct v4l2_subdev_video_ops ov7251_video_ops = {
> > +	.s_stream = ov7251_s_stream,
> > +	.g_frame_interval = ov7251_get_frame_interval,
> > +	.s_frame_interval = ov7251_set_frame_interval,
> > +};
> > +
> > +static const struct v4l2_subdev_pad_ops ov7251_subdev_pad_ops = {
> > +	.init_cfg = ov7251_entity_init_cfg,
> > +	.enum_mbus_code = ov7251_enum_mbus_code,
> > +	.enum_frame_size = ov7251_enum_frame_size,
> > +	.enum_frame_interval = ov7251_enum_frame_ival,
> > +	.get_fmt = ov7251_get_format,
> > +	.set_fmt = ov7251_set_format,
> > +	.get_selection = ov7251_get_selection,
> > +};
> > +
> > +static const struct v4l2_subdev_ops ov7251_subdev_ops = {
> > +	.core = &ov7251_core_ops,
> > +	.video = &ov7251_video_ops,
> > +	.pad = &ov7251_subdev_pad_ops,
> > +};
> > +
> > +static int ov7251_probe(struct i2c_client *client,
> > +			const struct i2c_device_id *id)
> > +{
> > +	struct device *dev = &client->dev;
> > +	struct device_node *endpoint;
> > +	struct ov7251 *ov7251;
> > +	u8 chip_id_high, chip_id_low, chip_rev;
> > +	u32 xclk_freq;
> > +	int ret;
> > +
> > +	ov7251 = devm_kzalloc(dev, sizeof(struct ov7251), GFP_KERNEL);
> > +	if (!ov7251)
> > +		return -ENOMEM;
> > +
> > +	ov7251->i2c_client = client;
> > +	ov7251->dev = dev;
> > +
> > +	endpoint = of_graph_get_next_endpoint(dev->of_node, NULL);
> 
> My understanding is that it is preferred to use fwnode_ library when
> possible, even if this driver is OF compatible only at the moment:
> 
> fwnode_graph_get_next_endpoint(dev_fwnode(dev), NULL)
> 
> > +	if (!endpoint) {
> > +		dev_err(dev, "endpoint node not found\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(endpoint),
> 
> And then you can remove conversion to fwnode_handle here.
> 
> Also consider v4l2_fwnode_endpoint_alloc_parse() that allows parsing
> of variable sizes data such as the CSI-2 link frequencies (which you
> handle as controls in this driver, so I'm not sure you actually need
> it here)
> 
> 
> > +					 &ov7251->ep);
> > +	if (ret < 0) {
> > +		dev_err(dev, "parsing endpoint node failed\n");
> 
> Decrement the endpoint refcount in the error path
> 
> > +		return ret;
> > +	}
> > +
> > +	of_node_put(endpoint);
> > +
> > +	if (ov7251->ep.bus_type != V4L2_MBUS_CSI2) {
> > +		dev_err(dev, "invalid bus type, must be CSI2\n");
> 
> Maybe print the returned bus_type?
> 
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* get system clock (xclk) */
> > +	ov7251->xclk = devm_clk_get(dev, "xclk");
> > +	if (IS_ERR(ov7251->xclk)) {
> > +		dev_err(dev, "could not get xclk");
> > +		return PTR_ERR(ov7251->xclk);
> > +	}
> > +
> > +	ret = of_property_read_u32(dev->of_node, "clock-frequency", &xclk_freq);
> > +	if (ret) {
> > +		dev_err(dev, "could not get xclk frequency\n");
> > +		return ret;
> > +	}
> > +
> > +	if (xclk_freq != 24000000) {
> > +		dev_err(dev, "external clock frequency %u is not supported\n",
> > +			xclk_freq);
> > +		return -EINVAL;
> > +	}
> 
> If 24MHz is the only allowed frequency, maybe it should be documented
> in the device tree bindings?

This is a driver property at the moment; the bindings are not related to
the driver. So if support for other frequencies are needed, then that'll
only require a driver change.

> 
> > +
> > +	ret = clk_set_rate(ov7251->xclk, xclk_freq);
> > +	if (ret) {
> > +		dev_err(dev, "could not set xclk frequency\n");
> > +		return ret;
> > +	}
> > +
> > +	ov7251->io_regulator = devm_regulator_get(dev, "vdddo");
> > +	if (IS_ERR(ov7251->io_regulator)) {
> > +		dev_err(dev, "cannot get io regulator\n");
> > +		return PTR_ERR(ov7251->io_regulator);
> > +	}
> > +
> > +	ret = regulator_set_voltage(ov7251->io_regulator,
> > +				    OV7251_VOLTAGE_DIGITAL_IO,
> > +				    OV7251_VOLTAGE_DIGITAL_IO);
> > +	if (ret < 0) {
> > +		dev_err(dev, "cannot set io voltage\n");
> > +		return ret;
> > +	}
> > +
> > +	ov7251->core_regulator = devm_regulator_get(dev, "vddd");
> > +	if (IS_ERR(ov7251->core_regulator)) {
> > +		dev_err(dev, "cannot get core regulator\n");
> > +		return PTR_ERR(ov7251->core_regulator);
> > +	}
> > +
> > +	ret = regulator_set_voltage(ov7251->core_regulator,
> > +				    OV7251_VOLTAGE_DIGITAL_CORE,
> > +				    OV7251_VOLTAGE_DIGITAL_CORE);
> > +	if (ret < 0) {
> > +		dev_err(dev, "cannot set core voltage\n");
> > +		return ret;
> > +	}
> > +
> > +	ov7251->analog_regulator = devm_regulator_get(dev, "vdda");
> > +	if (IS_ERR(ov7251->analog_regulator)) {
> > +		dev_err(dev, "cannot get analog regulator\n");
> > +		return PTR_ERR(ov7251->analog_regulator);
> > +	}
> > +
> > +	ret = regulator_set_voltage(ov7251->analog_regulator,
> > +				    OV7251_VOLTAGE_ANALOG,
> > +				    OV7251_VOLTAGE_ANALOG);
> > +	if (ret < 0) {
> > +		dev_err(dev, "cannot set analog voltage\n");
> > +		return ret;
> > +	}
> > +
> > +	ov7251->enable_gpio = devm_gpiod_get(dev, "enable", GPIOD_OUT_HIGH);
> > +	if (IS_ERR(ov7251->enable_gpio)) {
> > +		dev_err(dev, "cannot get enable gpio\n");
> > +		return PTR_ERR(ov7251->enable_gpio);
> > +	}
> > +
> > +	mutex_init(&ov7251->power_lock);
> > +
> > +	v4l2_ctrl_handler_init(&ov7251->ctrls, 7);
> > +	v4l2_ctrl_new_std(&ov7251->ctrls, &ov7251_ctrl_ops,
> > +			  V4L2_CID_HFLIP, 0, 1, 1, 0);
> > +	v4l2_ctrl_new_std(&ov7251->ctrls, &ov7251_ctrl_ops,
> > +			  V4L2_CID_VFLIP, 0, 1, 1, 0);
> > +	ov7251->exposure = v4l2_ctrl_new_std(&ov7251->ctrls, &ov7251_ctrl_ops,
> > +					     V4L2_CID_EXPOSURE, 1, 32, 1, 32);
> > +	ov7251->gain = v4l2_ctrl_new_std(&ov7251->ctrls, &ov7251_ctrl_ops,
> > +					 V4L2_CID_GAIN, 16, 1023, 1, 16);
> > +	v4l2_ctrl_new_std_menu_items(&ov7251->ctrls, &ov7251_ctrl_ops,
> > +				     V4L2_CID_TEST_PATTERN,
> > +				     ARRAY_SIZE(ov7251_test_pattern_menu) - 1,
> > +				     0, 0, ov7251_test_pattern_menu);
> > +	ov7251->pixel_clock = v4l2_ctrl_new_std(&ov7251->ctrls,
> > +						&ov7251_ctrl_ops,
> > +						V4L2_CID_PIXEL_RATE,
> > +						1, INT_MAX, 1, 1);
> 
> It seems to me that your ov7251_s_ctrl() does not handle
> V4L2_CID_PIXEL_RATE (same for V4L2_CID_LINK_FREQ) and return -EINVAL
> for them. Am I missing some pieces here?

The two controls are read-only, so the control framework won't call s_ctrl
callback on them.

> 
> > +	ov7251->link_freq = v4l2_ctrl_new_int_menu(&ov7251->ctrls,
> > +						   &ov7251_ctrl_ops,
> > +						   V4L2_CID_LINK_FREQ,
> > +						   ARRAY_SIZE(link_freq) - 1,
> > +						   0, link_freq);
> > +	if (ov7251->link_freq)
> > +		ov7251->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
> > +
> > +	ov7251->sd.ctrl_handler = &ov7251->ctrls;
> > +
> > +	if (ov7251->ctrls.error) {
> > +		dev_err(dev, "%s: control initialization error %d\n",
> > +		       __func__, ov7251->ctrls.error);
> > +		ret = ov7251->ctrls.error;
> > +		goto free_ctrl;
> > +	}
> > +
> > +	v4l2_i2c_subdev_init(&ov7251->sd, client, &ov7251_subdev_ops);
> > +	ov7251->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> > +	ov7251->pad.flags = MEDIA_PAD_FL_SOURCE;
> > +	ov7251->sd.dev = &client->dev;
> > +	ov7251->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
> > +
> > +	ret = media_entity_pads_init(&ov7251->sd.entity, 1, &ov7251->pad);
> > +	if (ret < 0) {
> > +		dev_err(dev, "could not register media entity\n");
> > +		goto free_ctrl;
> > +	}
> > +
> > +	ret = ov7251_s_power(&ov7251->sd, true);
> > +	if (ret < 0) {
> > +		dev_err(dev, "could not power up OV7251\n");
> > +		goto free_entity;
> > +	}
> > +
> > +	ret = ov7251_read_reg(ov7251, OV7251_CHIP_ID_HIGH, &chip_id_high);
> > +	if (ret < 0 || chip_id_high != OV7251_CHIP_ID_HIGH_BYTE) {
> > +		dev_err(dev, "could not read ID high\n");
> > +		ret = -ENODEV;
> > +		goto power_down;
> > +	}
> > +	ret = ov7251_read_reg(ov7251, OV7251_CHIP_ID_LOW, &chip_id_low);
> > +	if (ret < 0 || chip_id_low != OV7251_CHIP_ID_LOW_BYTE) {
> > +		dev_err(dev, "could not read ID low\n");
> > +		ret = -ENODEV;
> > +		goto power_down;
> > +	}
> > +
> > +	ret = ov7251_read_reg(ov7251, OV7251_SC_GP_IO_IN1, &chip_rev);
> > +	if (ret < 0) {
> > +		dev_err(dev, "could not read revision\n");
> > +		ret = -ENODEV;
> > +		goto power_down;
> > +	}
> > +	chip_rev >>= 4;
> > +
> > +	dev_info(dev, "OV7251 revision %x (%s) detected at address 0x%02x\n",
> > +		 chip_rev,
> > +		 chip_rev == 0x4 ? "1A / 1B" :
> > +		 chip_rev == 0x5 ? "1C / 1D" :
> > +		 chip_rev == 0x6 ? "1E" :
> > +		 chip_rev == 0x7 ? "1F" : "unknown",
> > +		 client->addr);
> > +
> > +	ret = ov7251_read_reg(ov7251, OV7251_PRE_ISP_00,
> > +			      &ov7251->pre_isp_00);
> > +	if (ret < 0) {
> > +		dev_err(dev, "could not read test pattern value\n");
> > +		ret = -ENODEV;
> > +		goto power_down;
> > +	}
> > +
> > +	ret = ov7251_read_reg(ov7251, OV7251_TIMING_FORMAT1,
> > +			      &ov7251->timing_format1);
> > +	if (ret < 0) {
> > +		dev_err(dev, "could not read vflip value\n");
> > +		ret = -ENODEV;
> > +		goto power_down;
> > +	}
> > +
> > +	ret = ov7251_read_reg(ov7251, OV7251_TIMING_FORMAT2,
> > +			      &ov7251->timing_format2);
> > +	if (ret < 0) {
> > +		dev_err(dev, "could not read hflip value\n");
> > +		ret = -ENODEV;
> > +		goto power_down;
> > +	}
> > +
> > +	ov7251_s_power(&ov7251->sd, false);
> 
> I am not sure if using pm_runtime is the preferred way to handle
> sensor power management, I just noticed just a few bridge drivers actually
> call s_power() on their subdevices.
> 
> Thanks
>    j
> 
> 
> > +
> > +	ret = v4l2_async_register_subdev(&ov7251->sd);
> > +	if (ret < 0) {
> > +		dev_err(dev, "could not register v4l2 device\n");
> > +		goto free_entity;
> > +	}
> > +
> > +	ov7251_entity_init_cfg(&ov7251->sd, NULL);
> > +
> > +	return 0;
> > +
> > +power_down:
> > +	ov7251_s_power(&ov7251->sd, false);
> > +free_entity:
> > +	media_entity_cleanup(&ov7251->sd.entity);
> > +free_ctrl:
> > +	v4l2_ctrl_handler_free(&ov7251->ctrls);
> > +	mutex_destroy(&ov7251->power_lock);
> > +
> > +	return ret;
> > +}
> > +
> > +static int ov7251_remove(struct i2c_client *client)
> > +{
> > +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> > +	struct ov7251 *ov7251 = to_ov7251(sd);
> > +
> > +	v4l2_async_unregister_subdev(&ov7251->sd);
> > +	media_entity_cleanup(&ov7251->sd.entity);
> > +	v4l2_ctrl_handler_free(&ov7251->ctrls);
> > +	mutex_destroy(&ov7251->power_lock);
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct i2c_device_id ov7251_id[] = {
> > +	{ "ov7251", 0 },
> > +	{}
> > +};
> > +MODULE_DEVICE_TABLE(i2c, ov7251_id);
> > +
> > +static const struct of_device_id ov7251_of_match[] = {
> > +	{ .compatible = "ovti,ov7251" },
> > +	{ /* sentinel */ }
> > +};
> > +MODULE_DEVICE_TABLE(of, ov7251_of_match);
> > +
> > +static struct i2c_driver ov7251_i2c_driver = {
> > +	.driver = {
> > +		.of_match_table = of_match_ptr(ov7251_of_match),
> > +		.name  = "ov7251",
> > +	},
> > +	.probe  = ov7251_probe,
> > +	.remove = ov7251_remove,
> > +	.id_table = ov7251_id,
> > +};
> > +
> > +module_i2c_driver(ov7251_i2c_driver);
> > +
> > +MODULE_DESCRIPTION("Omnivision OV7251 Camera Driver");
> > +MODULE_AUTHOR("Todor Tomov <todor.tomov@linaro.org>");
> > +MODULE_LICENSE("GPL v2");
> > --
> > 2.7.4
> >

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
