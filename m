Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44825 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758248Ab3DSI4U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Apr 2013 04:56:20 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLH00FN4VEVGPB0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 19 Apr 2013 09:56:18 +0100 (BST)
Message-id: <517106A5.5040801@samsung.com>
Date: Fri, 19 Apr 2013 10:56:05 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: Re: [PATCH RFC] s5k5baf: add camera sensor driver
References: <1366119522-29291-1-git-send-email-a.hajda@samsung.com>
 <516EA64C.9000404@samsung.com>
In-reply-to: <516EA64C.9000404@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thank you for the review.
I will prepare v2 of the patch according to your comments.
My comments to your comments below...

On 17.04.2013 15:40, Sylwester Nawrocki wrote:
> Hi Andrzej,
>
> On 04/16/2013 03:38 PM, Andrzej Hajda wrote:
>> Driver for Samsung S5K5BAF UXGA 1/5" 2M CMOS Image Sensor
>> with embedded SoC ISP.
>> The driver exposes the sensor as two V4L2 subdevices:
>> - S5K5BAF-CIS - pure CMOS Image Sensor, fixed 1600x1200 format,
>>    no controls.
>> - S5K5BAF-ISP - Image Signal Processor, formats up to 1600x1200,
>>    pre/post ISP cropping, downscaling via selection API, controls.
>>
>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
> It's worth to note that this driver currently doesn't use the asynchronous
> sub-device probing API [1] but the intention is to switch to it once it's
> settled.
>
> [1] http://www.spinics.net/lists/linux-sh/msg18565.html
>
> A few more comments below...
>
>>   .../devicetree/bindings/media/samsung-s5k5baf.txt  |   50 +
>>   MAINTAINERS                                        |    8 +
>>   drivers/media/i2c/Kconfig                          |    7 +
>>   drivers/media/i2c/Makefile                         |    1 +
>>   drivers/media/i2c/s5k5baf.c                        | 1962 ++++++++++++++++++++
>>   include/media/s5k5baf.h                            |   48 +
>>   6 files changed, 2076 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/media/samsung-s5k5baf.txt
>>   create mode 100644 drivers/media/i2c/s5k5baf.c
>>   create mode 100644 include/media/s5k5baf.h
>>
>> diff --git a/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt b/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt
>> new file mode 100644
>> index 0000000..1099c1d
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt
>> @@ -0,0 +1,50 @@
>> +Samsung S5K5BAF UXGA 1/5" 2M CMOS Image Sensor with embedded SoC ISP
>> +-------------------------------------------------------------
>> +
>> +Required properties:
>> +
>> +- compatible	  : "samsung,s5k5baf";
>> +- reg		  : i2c slave address of the sensor;
>> +- vdda-supply	  : analog power supply 2.8V (2.6V to 3.0V);
>> +- vdd_reg-supply  : regulator input power 1.8V (1.7V to 1.9V)
> s/power/power supply ?
>
> Underscores should be avoided in the regulator supply names AFAIK, so
>
> s/vdd_reg/vddreg
>
>> +                    or 2.8V (2.6V to 3.0);
>> +- vddio-supply	  : I/O supply 1.8V (1.65V to 1.95V)
> s/supply/power supply ?
>
>> +                    or 2.8V (2.5V to 3.1V);
>> +- gpios		  : standby and reset gpios;
> You are not clear about the order, how about
>
> - gpios	: GPIOs connected to STDBYN and RSTN pins, in order: STBYN, RSTN;
>
> ?
>> +- clock-frequency : master clock frequency in Hz;
>> +
>> +Optional properties:
>> +
>> +- samsung,hflip	  : horizontal image flip
>> +- samsung,vflip	  : vertical image flip
> Optional clock properties are missing:
>
>   clocks : contains the sensor's master clock specifier;
>   clock-names : contains "mclk" entry;
>
> MCLK happens to be the clock input pin name in the datasheet.
>
>> +The device node should contain one 'port' child node with one child 'endpoint'
>> +node, according to the bindings defined in Documentation/devicetree/bindings/
>> +media/video-interfaces.txt. The following are properties specific to those nodes.
>> +
>> +endpoint node
>> +-------------
>> +
>> +- data-lanes	  : (optional) an array specifying active physical MIPI-CSI2
>> +		    data output lanes and their mapping to logical lanes; the
>> +		    array's content is unused, only its length is meaningful;
>> +
>> +Example:
>> +
>> +s5k5bafx@2d {
>> +	compatible = "samsung,s5k5baf";
>> +	reg = <0x2d>;
>> +	vdda-supply = <&cam_io_en_reg>;
>> +	vdd_reg-supply = <&vt_core_15v_reg>;
>> +	vddio-supply = <&vtcam_reg>;
>> +	gpios = <&gpl2 0 1>,
>> +		<&gpl2 1 1>;
>> +	clock-frequency = <24000000>;
>> +
>> +	port {
>> +		s5k5bafx_ep: endpoint {
>> +			remote-endpoint = <&csis1_ep>;
>> +			data-lanes = <1>;
>> +		};
>> +	};
>> +};
>> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
>> index 9e7ce8b..e487f7d 100644
>> --- a/drivers/media/i2c/Kconfig
>> +++ b/drivers/media/i2c/Kconfig
>> @@ -553,6 +553,13 @@ config VIDEO_S5K4ECGX
>>             This is a V4L2 sensor-level driver for Samsung S5K4ECGX 5M
>>             camera sensor with an embedded SoC image signal processor.
>>   
>> +config VIDEO_S5K5BAF
>> +	tristate "Samsung S5K5BAF sensor support"
>> +	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
>> +	---help---
>> +	  This is a V4L2 sensor-level driver for Samsung S5K5BAF 2M
>> +	  camera sensor with an embedded SoC image signal processor.
>> +
>>   source "drivers/media/i2c/smiapp/Kconfig"
>>   
>>   config VIDEO_S5C73M3
>> diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
>> new file mode 100644
>> index 0000000..0bae2d3
>> --- /dev/null
>> +++ b/drivers/media/i2c/s5k5baf.c
>> @@ -0,0 +1,1962 @@
>> +/*
>> + * Driver for Samsung S5K5BAF UXGA 1/5" 2M CMOS Image Sensor
>> + * with embedded SoC ISP.
>> + *
>> + * Copyright (C) 2013, Samsung Electronics Co., Ltd.
>> + * Andrzej Hajda <a.hajda@samsung.com>
>> + *
>> + * Based on S5K6AA driver authored by Sylwester Nawrocki
>> + * Sylwester Nawrocki <s.nawrocki@samsung.com>
> I would rephrase it to:
>
>    + * Based on S5K6AA driver authored by Sylwester Nawrocki
>    + * Copyright (C) 2013, Samsung Electronics Co., Ltd.
>
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +
>> +static const char * const s5k5baf_supply_names[] = {
>> +	"vdda",		/* Analog power supply 2.8V (2.6V to 3.0V) */
>> +	"vdd_reg",	/* Regulator input power 1.8V (1.7V to 1.9V)
> "vddreg"
>
>> +			   or 2.8V (2.6V to 3.0) */
>> +	"vddio",	/* I/O supply 1.8V (1.65V to 1.95V)
>> +			   or 2.8V (2.5V to 3.1V) */
>> +};
>> +#define S5K5BAF_NUM_SUPPLIES ARRAY_SIZE(s5k5baf_supply_names)
>> +struct s5k5baf_ctrls {
>> +	struct v4l2_ctrl_handler handler;
>> +	/* Auto / manual white balance cluster */
>> +	struct v4l2_ctrl *awb;
>> +	struct v4l2_ctrl *gain_red;
>> +	struct v4l2_ctrl *gain_blue;
>> +	struct v4l2_ctrl *gain_green;
>> +	/* Mirror cluster */
>> +	struct v4l2_ctrl *hflip;
>> +	struct v4l2_ctrl *vflip;
>> +	/* Auto exposure / manual exposure and gain cluster */
>> +	struct v4l2_ctrl *auto_exp;
>> +	struct v4l2_ctrl *exposure;
>> +	struct v4l2_ctrl *gain;
> Let's put each cluster in separate anonymous struct, so e.g.
>
> +	struct { /* Auto exposure / manual exposure and gain cluster */
> +		struct v4l2_ctrl *auto_exp;
> +		struct v4l2_ctrl *exposure;
> +		struct v4l2_ctrl *gain;
> +	};
>
>> +};
>> +
>> +/*
>> + * V4L2 subdev controls
>> + */
>> +static int s5k5baf_log_status(struct v4l2_subdev *sd)
>> +{
>> +	v4l2_ctrl_handler_log_status(sd->ctrl_handler, sd->name);
>> +	return 0;
>> +}
> This function is not needed, you could use now v4l2_ctrl_subdev_log_status()
> directly.
>
>> +#define V4L2_CID_RED_GAIN	(V4L2_CTRL_CLASS_CAMERA | 0x1001)
>> +#define V4L2_CID_GREEN_GAIN	(V4L2_CTRL_CLASS_CAMERA | 0x1002)
>> +#define V4L2_CID_BLUE_GAIN	(V4L2_CTRL_CLASS_CAMERA | 0x1003)
> A range should be reserved for the private controls in
> include/uapi/linux/v4l2-controls.h and used as a base here, so control
> IDs of various drivers are not overlapping.
>
>> +/*
>> + * V4L2 subdev internal operations
>> + */
>> +static void s5k5baf_check_fw_revision(struct s5k5baf *state)
>> +{
>> +	u16 api_ver = 0, fw_rev = 0, s_id = 0;
>> +
>> +	api_ver = s5k5baf_read(state, REG_FW_APIVER);
>> +	fw_rev = s5k5baf_read(state, REG_FW_REVISION) & 0xff;
>> +	s_id = s5k5baf_read(state, REG_FW_SENSOR_ID);
>> +	if (state->error)
>> +		return;
>> +
>> +	v4l2_info(&state->sd, "FW API=%#x, revision=%#x sensor_id=%#x\n",
>> +		  api_ver, fw_rev, s_id);
>> +
>> +	if (api_ver == S5K5BAF_FW_APIVER)
>> +		return;
>> +
>> +	v4l2_err(&state->sd, "FW API version not supported\n");
>> +	state->error = -ENODEV;
> When we initially discussed it in private my intention was to use
> 'state->error' mainly to ease handling of multiple I2C write calls.
> I have a feeling that the code would be easier to follow if it would
> be returning here the error value explicitly.
I have different feelings :). In my opinion typical code is highly
polluted with error checking code.
In usual case for every line of function call we have at least
two lines of error checking. Ex.:

     ret = call(...);
     if (ret)
         return ret;

"state->error" pattern allows to significantly decrease number
of error checks without sacrificing code correctness.

By the way similar pattern is already used in struct v4l2_ctrl_handler.

If there is no strong objection about it I would like to keep this pattern.
>
>> +}
>> +
>> +static int s5k5baf_registered(struct v4l2_subdev *sd)
>> +{
>> +	struct s5k5baf *state = to_s5k5baf(sd);
>> +	int ret;
>> +
>> +	ret = v4l2_device_register_subdev(sd->v4l2_dev, &state->cis_sd);
>> +	if (ret) {
>> +		v4l2_err(sd, "failed to register subdev %s\n",
>> +			 state->cis_sd.name);
>> +		return ret;
>> +	}
>> +
>> +	ret = media_entity_create_link(&state->cis_sd.entity,
>> +			0, &state->sd.entity, 0,
>> +			MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED);
>> +
>> +	mutex_lock(&state->lock);
>> +
>> +	s5k5baf_power_on(state);
>> +	s5k5baf_hw_init(state);
>> +	s5k5baf_check_fw_revision(state);
>> +	s5k5baf_power_off(state);
>> +
>> +	ret = state->error;
>> +	state->error = 0;
> Probably makes sense to create a helper function that would get and
> clear state->error, e.g. s5k5baf_error_get_clear() ?
>
>> +
>> +	mutex_unlock(&state->lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static const struct v4l2_subdev_ops s5k5baf_cis_subdev_ops = {
>> +	.pad	= &s5k5baf_cis_pad_ops,
>> +};
>> +
>> +static const struct v4l2_subdev_internal_ops s5k5baf_cis_subdev_internal_ops = {
>> +	.open = s5k5baf_open,
>> +};
>> +
>> +static const struct v4l2_subdev_internal_ops s5k5baf_subdev_internal_ops = {
>> +	.registered = s5k5baf_registered,
> The 'unregistered' callback is missing, it should undo anything what's
> done in s5k5baf_registered() or s5k5baf_registered() should be protected
> against multiple calls.
>
>> +	.open = s5k5baf_open,
>> +};
>> +
>> +static const struct v4l2_subdev_core_ops s5k5baf_core_ops = {
>> +	.s_power = s5k5baf_set_power,
>> +	.log_status = s5k5baf_log_status,
> 	.log_status = v4l2_ctrl_subdev_log_status,
>
>> +};
>> +
>> +static const struct v4l2_subdev_ops s5k5baf_subdev_ops = {
>> +	.core = &s5k5baf_core_ops,
>> +	.pad = &s5k5baf_pad_ops,
>> +	.video = &s5k5baf_video_ops,
>> +};
>> +
>> +static void s5k5baf_configure_gpios(struct s5k5baf *state)
>> +{
>> +	static const char const *name[] = { "S5K5BAF_STBY", "S5K5BAF_RST" };
>> +	struct i2c_client *c = v4l2_get_subdevdata(&state->sd);
>> +	struct s5k5baf_gpio *g = state->pdata.gpios;
>> +	int ret, i;
>> +
>> +	if (state->error)
>> +		return;
>> +
>> +	for (i = 0; i < GPIO_NUM; ++i) {
>> +		int flags = GPIOF_EXPORT | GPIOF_DIR_OUT;
>> +		if (g[i].level)
>> +			flags |= GPIOF_INIT_HIGH;
>> +		ret = devm_gpio_request_one(&c->dev, g[i].gpio, flags, name[i]);
>> +		if (ret) {
>> +			v4l2_err(c, "failed to request gpio %s\n", name[i]);
>> +			state->error = ret;
>> +			return;
>> +		}
>> +	}
>> +	return;
> Not needed, but anyway would be better to change the return value type to 'int'.
>
>> +}
>> +
>> +static void s5k5baf_get_platform_data(struct s5k5baf *state, struct device *dev)
>> +{
>> +	struct device_node *node = dev->of_node;
>> +	struct s5k5baf_platform_data *pd;
>> +	struct device_node *node_ep;
>> +	struct v4l2_of_endpoint ep;
>> +	enum of_gpio_flags of_flags;
>> +
>> +	if (state->error)
>> +		return;
>> +
>> +	if (!node) {
>> +		pd = dev->platform_data;
>> +		if (!pd) {
>> +			dev_err(dev, "No platform data\n");
>> +			state->error = -EINVAL;
>> +		}
>> +		state->pdata = *pd;
>> +		return;
>> +	}
>> +
>> +	pd = &state->pdata;
>> +
>> +	of_property_read_u32(node, "clock-frequency", &pd->mclk_frequency);
>> +	pd->hflip = of_property_read_bool(node, "samsung,hflip");
>> +	pd->vflip = of_property_read_bool(node, "samsung,vflip");
>> +	pd->gpios[STBY].gpio = of_get_gpio_flags(node, STBY, &of_flags);
>> +	pd->gpios[STBY].level = !(of_flags & OF_GPIO_ACTIVE_LOW);
>> +	pd->gpios[RST].gpio = of_get_gpio_flags(node, RST, &of_flags);
>> +	pd->gpios[RST].level = !(of_flags & OF_GPIO_ACTIVE_LOW);
>> +
>> +	node_ep = v4l2_of_get_next_endpoint(node, NULL);
>> +	if (!node_ep) {
>> +		dev_err(dev, "no endpoint defined\n");
>> +		state->error = -EINVAL;
>> +		return;
>> +	}
>> +	v4l2_of_parse_endpoint(node_ep, &ep);
>> +	of_node_put(node_ep);
>> +	pd->bus_type = ep.bus_type;
>> +	if (pd->bus_type == V4L2_MBUS_CSI2)
>> +		pd->nlanes = ep.bus.mipi_csi2.num_data_lanes;
>> +}
>> +
>> +static void s5k5baf_configure_subdevs(struct s5k5baf *state,
>> +				     struct i2c_client *c)
>> +{
>> +	struct v4l2_subdev *sd;
>> +
>> +	if (state->error)
>> +		return;
>> +
>> +	sd = &state->cis_sd;
>> +	v4l2_subdev_init(sd, &s5k5baf_cis_subdev_ops);
>> +	sd->owner = c->driver->driver.owner;
>> +	v4l2_set_subdevdata(sd, state);
>> +	strlcpy(sd->name, "S5K5BAF-CIS", sizeof(sd->name));
>> +
>> +	sd->internal_ops = &s5k5baf_cis_subdev_internal_ops;
>> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>> +
>> +	state->cis_pad.flags = MEDIA_PAD_FL_SOURCE;
>> +	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
>> +	state->error = media_entity_init(&sd->entity, 1, &state->cis_pad, 0);
>> +	if (state->error)
>> +		goto err;
>> +
>> +	sd = &state->sd;
>> +	v4l2_i2c_subdev_init(sd, c, &s5k5baf_subdev_ops);
>> +	strlcpy(sd->name, "S5K5BAF-ISP", sizeof(sd->name));
>> +
>> +	sd->internal_ops = &s5k5baf_subdev_internal_ops;
>> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>> +
>> +	state->pads[0].flags = MEDIA_PAD_FL_SINK;
>> +	state->pads[1].flags = MEDIA_PAD_FL_SOURCE;
>> +	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
>> +	state->error = media_entity_init(&sd->entity, 2, state->pads, 0);
>> +	if (!state->error)
>> +		return;
>> +
>> +	media_entity_cleanup(&state->cis_sd.entity);
>> +err:
>> +	dev_err(&c->dev, "cannot init media entity %s\n", sd->name);
> Not sure if this error log is needed. Might be better to log this
> upon return from this function, so 'goto' can be avoided.
But here we log exactly which subdev failed.
>
>> +}
>> +
>> +static void s5k5baf_configure_regulators(struct s5k5baf *state)
>> +{
>> +	struct i2c_client *c = v4l2_get_subdevdata(&state->sd);
>> +	int i;
>> +
>> +	if (state->error)
>> +		return;
>> +
>> +	for (i = 0; i < S5K5BAF_NUM_SUPPLIES; i++)
>> +		state->supplies[i].supply = s5k5baf_supply_names[i];
>> +
>> +	state->error = devm_regulator_bulk_get(&c->dev, S5K5BAF_NUM_SUPPLIES,
>> +				      state->supplies);
>> +	if (state->error)
>> +		v4l2_err(c, "failed to get regulators\n");
>> +}
>> +
>> +static int s5k5baf_probe(struct i2c_client *c,
>> +			const struct i2c_device_id *id)
>> +{
>> +	struct s5k5baf *state;
>> +
>> +	state = devm_kzalloc(&c->dev, sizeof(*state), GFP_KERNEL);
>> +	if (!state)
>> +		return -ENOMEM;
>> +
>> +	s5k5baf_get_platform_data(state, &c->dev);
>> +	s5k5baf_configure_subdevs(state, c);
>> +	s5k5baf_configure_gpios(state);
>> +	s5k5baf_configure_regulators(state);
>> +	s5k5baf_initialize_ctrls(state);
>> +
>> +	mutex_init(&state->lock);
> Might make sense to do this as one of first steps, right after the
> private driver data structure allocation.
>
> Some cleanup steps are missing here on the error paths, e.g.
> media_entity_cleanup(&sd->entity);
>
> What about changing the return value of all above functions used in
> probe() to 'int' so we can better track the error paths ?
As I explained before I would like to keep the 'state->error' pattern if 
possible.
Of course missing cleanup code will be added.
>
>> +	return state->error;
>> +}
>> +
>> +static int s5k5baf_remove(struct i2c_client *c)
>> +{
>> +	struct v4l2_subdev *sd = i2c_get_clientdata(c);
>> +	struct s5k5baf *state = to_s5k5baf(sd);
>> +
>> +	v4l2_device_unregister_subdev(sd);
>> +	v4l2_ctrl_handler_free(sd->ctrl_handler);
>> +	media_entity_cleanup(&sd->entity);
>> +
>> +	sd = &state->cis_sd;
>> +	v4l2_device_unregister_subdev(sd);
>> +	media_entity_cleanup(&sd->entity);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct i2c_device_id s5k5baf_id[] = {
>> +	{ DRIVER_NAME, 0 },
>> +	{ },
>> +};
>> +MODULE_DEVICE_TABLE(i2c, s5k5baf_id);
>> +
>> +static const struct of_device_id s5k5baf_of_match[] = {
>> +	{ .compatible = "samsung," DRIVER_NAME },
> Hmm, it looks a bit obfuscated to me, how about writing whole compatible
> string explicitly ?
>
>> +	{ }
>> +};
>> +MODULE_DEVICE_TABLE(of, s5k5baf_of_match);
>> +
>> +static struct i2c_driver s5k5baf_i2c_driver = {
>> +	.driver = {
>> +		.of_match_table = s5k5baf_of_match,
>> +		.name = DRIVER_NAME
>> +	},
>> +	.probe		= s5k5baf_probe,
>> +	.remove		= s5k5baf_remove,
>> +	.id_table	= s5k5baf_id,
>> +};
>> +
>> +module_i2c_driver(s5k5baf_i2c_driver);
>> +
>> +MODULE_DESCRIPTION("Samsung S5K5BAF(X) UXGA camera driver");
>> +MODULE_AUTHOR("Andrzej Hajda <a.hajda@samsung.com>");
>> +MODULE_LICENSE("GPL");
>> diff --git a/include/media/s5k5baf.h b/include/media/s5k5baf.h
>> new file mode 100644
>> index 0000000..957e708
>> --- /dev/null
>> +++ b/include/media/s5k5baf.h
>> @@ -0,0 +1,48 @@
>> +/*
>> + * S5K5BAF camera sensor driver header
>> + *
>> + * Copyright (C) 2011 Samsung Electronics Co., Ltd.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +
>> +#ifndef S5K5BAF_H
>> +#define S5K5BAF_H
>> +
>> +#include <media/v4l2-mediabus.h>
>> +
>> +/**
>> + * struct s5k5baf_gpio - data structure describing a GPIO
>> + * @gpio:  GPIO number
>> + * @level: indicates active state of the @gpio
>> + */
>> +struct s5k5baf_gpio {
>> +	int gpio;
>> +	int level;
>> +};
>> +
>> +/**
>> + * struct s5k5baf_platform_data - s5k5baf driver platform data
>> + * @set_power:   an additional callback to the board code, called
>> + *               after enabling the regulators and before switching
>> + *               the sensor off
>> + * @mclk_frequency: sensor's master clock frequency in Hz
>> + * @gpios:       GPIOs driving pins: STBY, RESET
>> + * @nlanes:      maximum number of MIPI-CSI lanes used
>> + * @hflip:       default horizontal image flip value, non zero to enable
>> + * @vflip:       default vertical image flip value, non zero to enable
>> + */
>> +
>> +struct s5k5baf_platform_data {
>> +	u32 mclk_frequency;
>> +	struct s5k5baf_gpio gpios[2];
>> +	enum v4l2_mbus_type bus_type;
>> +	u8 nlanes;
>> +	u8 hflip:1;
>> +	u8 vflip:1;
>> +};
>> +
>> +#endif /* S5K5BAF_H */
> Since we are not going to be using platform_data, I think this whole
> header file could be removed for now. Let's not add a dead code. If it
> happens someone ever needs platform_data I think it can be added then.
>
>
> Thanks,
> Sylwester
>

Thanks,
Andrzej
