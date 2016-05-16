Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:50780 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753138AbcEPIiS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2016 04:38:18 -0400
Subject: Re: [PATCH] media: Add a driver for the ov5645 camera sensor.
To: Todor Tomov <ttomov@mm-sol.com>
References: <1463065155-26337-1-git-send-email-todor.tomov@linaro.org>
 <57357BFE.3090509@xs4all.nl> <5739838A.3070405@mm-sol.com>
Cc: Todor Tomov <todor.tomov@linaro.org>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <573986F1.1070109@xs4all.nl>
Date: Mon, 16 May 2016 10:38:09 +0200
MIME-Version: 1.0
In-Reply-To: <5739838A.3070405@mm-sol.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/16/2016 10:23 AM, Todor Tomov wrote:
> Hello Hans,
> 
> Thank you for your review. Please see my comments below.
> 
> On 05/13/2016 10:02 AM, Hans Verkuil wrote:
>> On 05/12/2016 04:59 PM, Todor Tomov wrote:
>>> The ov5645 sensor from Omnivision supports up to 2592x1944
>>> and CSI2 interface.
>>>
>>> The driver adds support for the following modes:
>>> - 1280x960
>>> - 1920x1080
>>> - 2592x1944
>>>
>>> Output format is packed 8bit UYVY.
>>>
>>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>>> ---
>>>  .../devicetree/bindings/media/i2c/ov5645.txt       |   54 +
>>>  drivers/media/i2c/Kconfig                          |   11 +
>>>  drivers/media/i2c/Makefile                         |    1 +
>>>  drivers/media/i2c/ov5645.c                         | 1344 ++++++++++++++++++++
>>>  4 files changed, 1410 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5645.txt
>>>  create mode 100644 drivers/media/i2c/ov5645.c
>>>
>>> +static int ov5645_open(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
>>> +{
>>> +	return ov5645_s_power(subdev, true);
>>> +}
>>> +
>>> +static int ov5645_close(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
>>> +{
>>> +	return ov5645_s_power(subdev, false);
>>> +}
>>
>> This won't work: you can open the v4l-subdev node multiple times, so if I open it twice then
>> the next close will power down the chip and the last remaining open is in a bad state.
>>
> 
> Multiple power up/down are handled inside ov5645_s_power. There is power_count reference
> counting variable. Do you see any problem with this?
> 
>>> +
>>> +static int ov5645_s_stream(struct v4l2_subdev *subdev, int enable)
>>> +{
>>> +	struct ov5645 *ov5645 = to_ov5645(subdev);
>>> +	int ret;
>>> +
>>> +	dev_dbg(ov5645->dev, "%s: enable = %d\n", __func__, enable);
>>> +
>>> +	if (enable) {
>>> +		ret = ov5645_change_mode(ov5645, ov5645->current_mode);
>>> +		if (ret < 0) {
>>> +			dev_err(ov5645->dev, "could not set mode %d\n",
>>> +				ov5645->current_mode);
>>> +			return ret;
>>> +		}
>>> +		ret = v4l2_ctrl_handler_setup(&ov5645->ctrls);
>>> +		if (ret < 0) {
>>> +			dev_err(ov5645->dev, "could not sync v4l2 controls\n");
>>> +			return ret;
>>> +		}
>>> +		ov5645_write_reg(ov5645, OV5645_SYSTEM_CTRL0,
>>> +				 OV5645_SYSTEM_CTRL0_START);
>>> +	} else {
>>> +		ov5645_write_reg(ov5645, OV5645_SYSTEM_CTRL0,
>>> +				 OV5645_SYSTEM_CTRL0_STOP);
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>
>> It might make more sense to power up on s_stream(true) or off on s_stream(false).
>>
> 
> When the sensor is powered up on open, it allows to open the subdev, set any
> controls and have the result from configuring these controls in hardware
> (without starting streaming). This is my reasoning behind this.

It's fairly pointless. If you open the device, set controls, then close it, they
are all lost again. You are already setting everything up again in s_stream anyway.

Just don't bother with s_power in the open and close (or with refcounting for
that matter).

BTW, if I am not mistaken a bridge driver that calls this subdev and wants to
start streaming also has to call s_power before s_stream. So to answer my own
question: there is no need to call s_power in s_stream.

Regards,

	Hans

> 
>>> +
>>> +static struct v4l2_subdev_core_ops ov5645_core_ops = {
>>> +	.s_power = ov5645_s_power,
>>> +};
>>> +
>>> +static struct v4l2_subdev_video_ops ov5645_video_ops = {
>>> +	.s_stream = ov5645_s_stream,
>>> +};
>>> +
>>> +static struct v4l2_subdev_pad_ops ov5645_subdev_pad_ops = {
>>> +	.enum_mbus_code = ov5645_enum_mbus_code,
>>> +	.enum_frame_size = ov5645_enum_frame_size,
>>> +	.get_fmt = ov5645_get_format,
>>> +	.set_fmt = ov5645_set_format,
>>> +	.get_selection = ov5645_get_selection,
>>> +};
>>> +
>>> +static struct v4l2_subdev_ops ov5645_subdev_ops = {
>>> +	.core = &ov5645_core_ops,
>>> +	.video = &ov5645_video_ops,
>>> +	.pad = &ov5645_subdev_pad_ops,
>>> +};
>>> +
>>> +static const struct v4l2_subdev_internal_ops ov5645_subdev_internal_ops = {
>>> +	.registered = ov5645_registered,
>>> +	.open = ov5645_open,
>>> +	.close = ov5645_close,
>>> +};
>>> +
>>> +static int ov5645_probe(struct i2c_client *client,
>>> +			const struct i2c_device_id *id)
>>> +{
>>> +	struct device *dev = &client->dev;
>>> +	struct device_node *endpoint;
>>> +	struct ov5645 *ov5645;
>>> +	int ret = 0;
>>> +
>>> +	ov5645 = devm_kzalloc(dev, sizeof(struct ov5645), GFP_KERNEL);
>>> +	if (!ov5645)
>>> +		return -ENOMEM;
>>> +
>>> +	ov5645->i2c_client = client;
>>> +	ov5645->dev = dev;
>>> +	ov5645->fmt.code = MEDIA_BUS_FMT_UYVY8_2X8;
>>> +	ov5645->fmt.width = 1920;
>>> +	ov5645->fmt.height = 1080;
>>> +	ov5645->fmt.field = V4L2_FIELD_NONE;
>>
>> You need to set the colorspace as well. Probably _SRGB or _RAW.
>>
> 
> Yes, I'll do. Thank you.
> 
>>> +	ov5645->current_mode = ov5645_mode_1080p_1920_1080;
>>> +
>>> +	endpoint = of_graph_get_next_endpoint(dev->of_node, NULL);
>>> +	if (!endpoint) {
>>> +		dev_err(dev, "endpoint node not found\n");
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	v4l2_of_parse_endpoint(endpoint, &ov5645->ep);
>>> +	if (ov5645->ep.bus_type != V4L2_MBUS_CSI2) {
>>> +		dev_err(dev, "invalid bus type, must be CSI2\n");
>>> +		of_node_put(endpoint);
>>> +		return -EINVAL;
>>> +	}
>>> +	of_node_put(endpoint);
>>> +
>>> +	/* get system clock (xclk) frequency */
>>> +	ret = of_property_read_u32(dev->of_node, "clock-rates",
>>> +				   &ov5645->xclk_freq);
>>> +	if (!ret) {
>>> +		if (ov5645->xclk_freq < OV5645_XCLK_MIN ||
>>> +		    ov5645->xclk_freq > OV5645_XCLK_MAX) {
>>> +			dev_err(dev, "invalid xclk frequency: %d\n",
>>> +				ov5645->xclk_freq);
>>> +			return -EINVAL;
>>> +		}
>>> +	}
>>> +
>>> +	/* get system clock (xclk) */
>>> +	ov5645->xclk = devm_clk_get(dev, "xclk");
>>> +	if (IS_ERR(ov5645->xclk)) {
>>> +		dev_err(dev, "could not get xclk");
>>> +		return -EINVAL;
>>> +	}
>>> +	clk_set_rate(ov5645->xclk, ov5645->xclk_freq);
>>> +
>>> +	ov5645_regulators_get(ov5645);
>>> +
>>> +	ret = of_get_named_gpio(dev->of_node, "reset-gpio", 0);
>>> +	if (!gpio_is_valid(ret)) {
>>> +		dev_dbg(dev, "no reset pin available\n");
>>> +		ov5645->rst_gpio = 0;
>>> +	} else {
>>> +		ov5645->rst_gpio = ret;
>>> +	}
>>> +
>>> +	if (ov5645->rst_gpio) {
>>> +		ret = devm_gpio_request_one(dev, ov5645->rst_gpio,
>>> +			GPIOF_OUT_INIT_LOW, "ov5645-reset");
>>> +		if (ret < 0) {
>>> +			dev_err(dev, "could not request reset gpio\n");
>>> +			return ret;
>>> +		}
>>> +	}
>>> +
>>> +	ret = of_get_named_gpio(dev->of_node, "pwdn-gpio", 0);
>>> +	if (!gpio_is_valid(ret)) {
>>> +		dev_dbg(dev, "no powerdown pin available\n");
>>> +		ov5645->pwdn_gpio = 0;
>>> +	} else {
>>> +		ov5645->pwdn_gpio = ret;
>>> +	}
>>> +
>>> +	if (ov5645->pwdn_gpio) {
>>> +		ret = devm_gpio_request_one(dev, ov5645->pwdn_gpio,
>>> +			 GPIOF_OUT_INIT_LOW, "ov5645-pwdn");
>>> +		if (ret < 0) {
>>> +			dev_err(dev, "could not request powerdown gpio\n");
>>> +			return ret;
>>> +		}
>>> +	}
>>> +
>>> +	mutex_init(&ov5645->power_lock);
>>> +
>>> +	v4l2_ctrl_handler_init(&ov5645->ctrls, 7);
>>> +	ov5645->saturation = v4l2_ctrl_new_std(&ov5645->ctrls, &ov5645_ctrl_ops,
>>> +				V4L2_CID_SATURATION, -4, 4, 1, 0);
>>> +	ov5645->hflip = v4l2_ctrl_new_std(&ov5645->ctrls, &ov5645_ctrl_ops,
>>> +				V4L2_CID_HFLIP, 0, 1, 1, 0);
>>> +	ov5645->vflip = v4l2_ctrl_new_std(&ov5645->ctrls, &ov5645_ctrl_ops,
>>> +				V4L2_CID_VFLIP, 0, 1, 1, 0);
>>> +	ov5645->autogain = v4l2_ctrl_new_std(&ov5645->ctrls, &ov5645_ctrl_ops,
>>> +				V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
>>> +	ov5645->autoexposure = v4l2_ctrl_new_std_menu(&ov5645->ctrls,
>>> +				&ov5645_ctrl_ops, V4L2_CID_EXPOSURE_AUTO,
>>> +				V4L2_EXPOSURE_MANUAL, 0, V4L2_EXPOSURE_AUTO);
>>> +	ov5645->awb = v4l2_ctrl_new_std(&ov5645->ctrls, &ov5645_ctrl_ops,
>>> +				V4L2_CID_AUTO_WHITE_BALANCE, 0, 1, 1, 1);
>>> +	ov5645->pattern = v4l2_ctrl_new_std_menu_items(&ov5645->ctrls,
>>> +				&ov5645_ctrl_ops, V4L2_CID_TEST_PATTERN,
>>> +				ARRAY_SIZE(ov5645_test_pattern_menu) - 1, 0, 0,
>>> +				ov5645_test_pattern_menu);
>>> +
>>> +	ov5645->sd.ctrl_handler = &ov5645->ctrls;
>>> +
>>> +	if (ov5645->ctrls.error) {
>>> +		dev_err(dev, "%s: control initialization error %d\n",
>>> +		       __func__, ov5645->ctrls.error);
>>> +		ret = ov5645->ctrls.error;
>>> +		goto free_ctrl;
>>> +	}
>>> +
>>> +	v4l2_i2c_subdev_init(&ov5645->sd, client, &ov5645_subdev_ops);
>>> +	ov5645->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>>> +	ov5645->pad.flags = MEDIA_PAD_FL_SOURCE;
>>> +	ov5645->sd.internal_ops = &ov5645_subdev_internal_ops;
>>> +
>>> +	ret = media_entity_init(&ov5645->sd.entity, 1, &ov5645->pad, 0);
>>> +	if (ret < 0) {
>>> +		dev_err(dev, "could not register media entity\n");
>>> +		goto free_ctrl;
>>> +	}
>>> +
>>> +	ov5645->sd.dev = &client->dev;
>>> +	ret = v4l2_async_register_subdev(&ov5645->sd);
>>> +	if (ret < 0) {
>>> +		dev_err(dev, "could not register v4l2 device\n");
>>> +		goto free_entity;
>>> +	}
>>> +
>>> +	return 0;
>>> +
>>> +free_entity:
>>> +	media_entity_cleanup(&ov5645->sd.entity);
>>> +free_ctrl:
>>> +	v4l2_ctrl_handler_free(&ov5645->ctrls);
>>> +
>>> +	return ret;
>>> +}
>>> +
>>> +
>>> +static int ov5645_remove(struct i2c_client *client)
>>> +{
>>> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
>>> +	struct ov5645 *ov5645 = to_ov5645(sd);
>>> +
>>> +	v4l2_async_unregister_subdev(&ov5645->sd);
>>> +	media_entity_cleanup(&ov5645->sd.entity);
>>> +	v4l2_ctrl_handler_free(&ov5645->ctrls);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +
>>> +static const struct i2c_device_id ov5645_id[] = {
>>> +	{ "ov5645", 0 },
>>> +	{}
>>> +};
>>> +MODULE_DEVICE_TABLE(i2c, ov5645_id);
>>> +
>>> +#if IS_ENABLED(CONFIG_OF)
>>> +static const struct of_device_id ov5645_of_match[] = {
>>> +	{ .compatible = "ovti,ov5645" },
>>> +	{ /* sentinel */ }
>>> +};
>>> +MODULE_DEVICE_TABLE(of, ov5645_of_match);
>>> +#endif
>>> +
>>> +static struct i2c_driver ov5645_i2c_driver = {
>>> +	.driver = {
>>> +		.of_match_table = of_match_ptr(ov5645_of_match),
>>> +		.name  = "ov5645",
>>> +	},
>>> +	.probe  = ov5645_probe,
>>> +	.remove = ov5645_remove,
>>> +	.id_table = ov5645_id,
>>> +};
>>> +
>>> +module_i2c_driver(ov5645_i2c_driver);
>>> +
>>> +MODULE_DESCRIPTION("Omnivision OV5645 Camera Driver");
>>> +MODULE_AUTHOR("Todor Tomov <todor.tomov@linaro.org>");
>>> +MODULE_LICENSE("GPL v2");
>>>
>>
>> Regards,
>>
>> 	Hans
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
