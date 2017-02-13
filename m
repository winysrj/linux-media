Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay2.synopsys.com ([198.182.60.111]:35680 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752199AbdBMTPB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 14:15:01 -0500
Subject: Re: [PATCH v8 2/2] Add support for OV5647 sensor.
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>
References: <cover.1486984040.git.roliveir@synopsys.com>
 <6b023e996ec7bcfc84b489f8d700eeff328bef7b.1486984040.git.roliveir@synopsys.com>
 <b947bd60-b08b-1841-eb8c-ee275a234ef3@mentor.com>
CC: <CARLOS.PALMINHA@synopsys.com>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Kamil Debski <k.debski@samsung.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        "Rob Herring" <robh+dt@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
From: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Message-ID: <b44432b0-34aa-dd36-db4c-f154c98932e4@synopsys.com>
Date: Mon, 13 Feb 2017 19:14:48 +0000
MIME-Version: 1.0
In-Reply-To: <b947bd60-b08b-1841-eb8c-ee275a234ef3@mentor.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vladimir,

Thank you for your feedback.

On 2/13/2017 12:21 PM, Vladimir Zapolskiy wrote:
> Hello Ramiro,
> 
> On 02/13/2017 01:25 PM, Ramiro Oliveira wrote:
>> Modes supported:
>>  - 640x480 RAW 8
>>
> 
> It is a pretty short commit message, please consider to write a couple
> of words about the sensor.
> 

Sure, I can do that.

>> Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>
>> ---
> 
> [snip]
> 
>> +
>> +struct cfg_array {
>> +	struct regval_list *regs;
>> +	int size;
>> +};
> 
> struct cfg_array is apparently unused.
> 

You're right. It's left-over code.

>> +
>> +/**
>> + * @short I2C Write operation
>> + * @param[in] i2c_client I2C client
>> + * @param[in] reg register address
>> + * @param[in] val value to write
>> + * @return Error code
>> + */
>> +static int ov5647_write(struct v4l2_subdev *sd, u16 reg, u8 val)
>> +{
> 
> The comment contents is probably outdated, because it does not describe
> the function input arguments properly.
> 

I'll remove the comments since the function is self-explanatory, I believe.

>> +	int ret;
>> +	unsigned char data[3] = { reg >> 8, reg & 0xff, val};
>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +
>> +	ret = i2c_master_send(client, data, 3);
>> +	if (ret != 3) {
>> +		dev_dbg(&client->dev, "%s: i2c write error, reg: %x\n",
>> +				__func__, reg);
>> +		return ret < 0 ? ret : -EIO;
> 
> Here i2c_master_send() returns only to a negative error or '3', thus
> the check is redundant.
> 
> Please do 'return ret';
> 

I'll do that.

>> +	}
>> +	return 0;
>> +}
>> +
>> +/**
>> + * @short I2C Read operation
>> + * @param[in] i2c_client I2C client
>> + * @param[in] reg register address
>> + * @param[out] val value read
>> + * @return Error code
>> + */
>> +static int ov5647_read(struct v4l2_subdev *sd, u16 reg, u8 *val)
>> +{
> 
> Same as above, the comment must be updated.
> 

I'll remove the comments since the function is self-explanatory, I believe.

>> +	int ret;
>> +	unsigned char data_w[2] = { reg >> 8, reg & 0xff };
>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +
>> +	ret = i2c_master_send(client, data_w, 2);
>> +
>> +	if (ret < 2) {
>> +		dev_dbg(&client->dev, "%s: i2c read error, reg: %x\n",
>> +			__func__, reg);
>> +		return ret < 0 ? ret : -EIO;
> 
> 
> Here i2c_master_send() returns only to a negative error or '2', thus
> the check is redundant.
> 
> Please do 'return ret';
> 

I'll do that.

>> +	}
>> +
>> +	ret = i2c_master_recv(client, val, 1);
>> +
>> +	if (ret < 1) {
>> +		dev_dbg(&client->dev, "%s: i2c read error, reg: %x\n",
>> +				__func__, reg);
>> +		return ret < 0 ? ret : -EIO;
> 
> Here i2c_master_recv() returns only to a negative error or '1', thus
> the check is redundant.
> 
> Please do 'return ret';
> 

I'll do that.

>> +	}
>> +	return 0;
>> +}
>> +
>> +static int ov5647_write_array(struct v4l2_subdev *sd,
>> +				struct regval_list *regs, int array_size)
>> +{
>> +	int i = 0;
>> +	int ret = 0;
> 
> Please don't assign a value to 'ret' and please do declarations on a single line.
> 

Ok.

>> +
>> +	if (!regs)
>> +		return -EINVAL;
> 
> !regs is a dead code check, please remove it.
> 

I'll do that.

>> +
>> +	while (i < array_size) {
>> +		ret = ov5647_write(sd, regs->addr, regs->data);
>> +		if (ret < 0)
>> +			return ret;
>> +		i++;
>> +		regs++;
>> +	}
> 
> Please do a for-loop, it will save two lines of code:
> 
> 	for (i = 0; i < array_size; i++) {
> 		ret = ov5647_write(sd, regs[i].addr, regs[i].data);
> 		if (ret < 0)
> 			return ret;
> 	}
> 

Sure, I can do that.

>> +	return 0;
>> +}
>> +
>> +static int ov5647_set_virtual_channel(struct v4l2_subdev *sd, int channel)
>> +{
>> +	u8 channel_id;
>> +	int ret = 0;
> 
> Please don't assign a value to 'ret' on declaration here.
> 

Ok.

>> +
>> +	ret = ov5647_read(sd, 0x4814, &channel_id);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	channel_id &= ~(3 << 6);
>> +	return ov5647_write(sd, 0x4814, channel_id | (channel << 6));
>> +}
>> +
>> +static int ov5647_stream_on(struct v4l2_subdev *sd)
>> +{
>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +
>> +	ov5647_write(sd, 0x4202, 0x00);
>> +
>> +	dev_dbg(&client->dev, "Stream on");
>> +
>> +	return ov5647_write(sd, 0x300D, 0x00);
>> +}
>> +
>> +static int ov5647_stream_off(struct v4l2_subdev *sd)
>> +{
>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +
>> +	ov5647_write(sd, 0x4202, 0x0f);
>> +
>> +	dev_dbg(&client->dev, "Stream off");
>> +
>> +	return ov5647_write(sd, 0x300D, 0x01);
>> +}
>> +
>> +/**
>> + * @short Set SW standby
>> + * @param[in] sd v4l2 sd
>> + * @param[in] stanby standby mode status (on or off)
>> + * @return Error code
>> + */
>> +static int set_sw_standby(struct v4l2_subdev *sd, bool standby)
>> +{
>> +	int ret;
>> +	unsigned char rdval;
> 
> ov5647_read() return value type is 'u8', please change it here and
> everywhere else in the code.
> 

Ok.

>> +
>> +	ret = ov5647_read(sd, 0x0100, &rdval);
>> +	if (ret != 0)
> 
> if (ret < 0)
> 

I'll change it.

>> +		return ret;
>> +
>> +	if (standby)
>> +		rdval &= 0xfe;
> 
> Here 'rdval &= ~0x01' would be preferred to emphasize symmetry.
> 

Sure, it makes sense.

>> +	else
>> +		rdval |= 0x01;
>> +
>> +	return ov5647_write(sd, 0x0100, rdval);
>> +}
>> +
>> +/**
>> + * @short Initialize sensor
>> + * @param[in] sd v4l2 subdev
>> + * @param[in] val not used
>> + * @return Error code
>> + */
>> +static int __sensor_init(struct v4l2_subdev *sd)
> 
> Same as above, the comment must be updated.
> 

I'll remove the comments since the function is self-explanatory, I believe.

>> +{
>> +	int ret;
>> +	u8 resetval;
>> +	u8 rdval;
>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +
>> +	dev_dbg(&client->dev, "sensor init\n");
>> +
>> +	ret = ov5647_read(sd, 0x0100, &rdval);
>> +	if (ret != 0)
> 
> if (ret < 0)
> 

I'll change it.

>> +		return ret;
>> +
>> +	ret = ov5647_write_array(sd, ov5647_640x480,
>> +					ARRAY_SIZE(ov5647_640x480));
>> +	if (ret < 0) {
>> +		dev_err(&client->dev, "write sensor default regs error\n");
>> +		return ret;
>> +	}
>> +
>> +	ret = ov5647_set_virtual_channel(sd, 0);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = ov5647_read(sd, 0x0100, &resetval);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	if (!(resetval & 0x01)) {
>> +		dev_err(&client->dev, "Device was in SW standby");
>> +		ret = ov5647_write(sd, 0x0100, 0x01);
>> +		if (ret < 0)
>> +			return ret;
>> +	}
>> +
>> +	return ov5647_write(sd, 0x4800, 0x04);
>> +}
>> +
>> +/**
>> + * @short Control sensor power state
>> + * @param[in] sd v4l2 subdev
>> + * @param[in] on Sensor power
>> + * @return Error code
>> + */
>> +static int sensor_power(struct v4l2_subdev *sd, int on)
>> +{
>> +	int ret;
>> +	struct ov5647 *ov5647 = to_state(sd);
>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +
>> +	ret = 0;
>> +	mutex_lock(&ov5647->lock);
>> +
>> +	if (on && !ov5647->power_count)	{
>> +		dev_dbg(&client->dev, "OV5647 power on\n");
>> +
>> +		clk_set_rate(ov5647->xclk, ov5647->xclk_freq);
>> +
>> +		ret = clk_prepare_enable(ov5647->xclk);
>> +		if (ret < 0) {
>> +			dev_err(ov5647->dev, "clk prepare enable failed\n");
>> +			goto out;
>> +		}
>> +
>> +		ret = ov5647_write_array(sd, sensor_oe_enable_regs,
>> +				ARRAY_SIZE(sensor_oe_enable_regs));
>> +		if (ret < 0) {
>> +			clk_disable_unprepare(ov5647->xclk);
>> +			dev_err(&client->dev,
>> +				"write sensor_oe_enable_regs error\n");
>> +			goto out;
>> +		}
>> +
>> +		ret = __sensor_init(sd);
>> +		if (ret < 0) {
>> +			clk_disable_unprepare(ov5647->xclk);
>> +			dev_err(&client->dev,
>> +				"Camera not available, check Power\n");
>> +			goto out;
>> +		}
>> +	} else if (!on && ov5647->power_count == 1) {
>> +		dev_dbg(&client->dev, "OV5647 power off\n");
>> +
>> +		dev_dbg(&client->dev, "disable oe\n");
>> +		ret = ov5647_write_array(sd, sensor_oe_disable_regs,
>> +				ARRAY_SIZE(sensor_oe_disable_regs));
>> +
>> +		if (ret < 0)
>> +			dev_dbg(&client->dev, "disable oe failed\n");
>> +
>> +		ret = set_sw_standby(sd, true);
>> +
>> +		if (ret < 0)
>> +			dev_dbg(&client->dev, "soft stby failed\n");
>> +
>> +		clk_disable_unprepare(ov5647->xclk);
>> +	}
>> +
>> +	/* Update the power count. */
>> +	ov5647->power_count += on ? 1 : -1;
>> +	WARN_ON(ov5647->power_count < 0);
>> +
>> +out:
>> +	mutex_unlock(&ov5647->lock);
>> +
>> +	return ret;
>> +}
>> +
>> +#ifdef CONFIG_VIDEO_ADV_DEBUG
>> +/**
>> + * @short Get register value
>> + * @param[in] sd v4l2 subdev
>> + * @param[in] reg register struct
>> + * @return Error code
>> + */
>> +static int sensor_get_register(struct v4l2_subdev *sd,
>> +				struct v4l2_dbg_register *reg)
>> +{
>> +	unsigned char val = 0;
> 
> ov5647_read() return value type is 'u8', please change it here and
> everywhere else in the code.
> 
> Also please don't assign a value to 'val' n declaration.
> 

Ok.

>> +	int ret;
>> +
>> +	ret = ov5647_read(sd, reg->reg & 0xff, &val);
>> +	if (ret != 0)
> 
> if (ret < 0)
> 

I'll change it.

>> +		return ret;
>> +
>> +	reg->val = val;
>> +	reg->size = 1;
>> +
>> +	return ret;
> 
> return 0;
> 

Ok.

>> +}
>> +
>> +/**
>> + * @short Set register value
>> + * @param[in] sd v4l2 subdev
>> + * @param[in] reg register struct
>> + * @return Error code
>> + */
>> +static int sensor_set_register(struct v4l2_subdev *sd,
>> +				const struct v4l2_dbg_register *reg)
>> +{
>> +	return ov5647_write(sd, reg->reg & 0xff, reg->val & 0xff);
>> +}
>> +#endif
>> +
>> +/**
>> + * @short Subdev core operations registration
>> + */
>> +static const struct v4l2_subdev_core_ops subdev_core_ops = {
>> +	.s_power		= sensor_power,
>> +#ifdef CONFIG_VIDEO_ADV_DEBUG
>> +	.g_register		= sensor_get_register,
>> +	.s_register		= sensor_set_register,
>> +#endif
>> +};
>> +
>> +static int s_stream(struct v4l2_subdev *sd, int enable)
>> +{
>> +	if (!enable)
>> +		return ov5647_stream_off(sd);
>> +	else
>> +		return ov5647_stream_on(sd);
> 
> To avoid a negation please do
> 
> 	if (enable)
> 		return ov5647_stream_on(sd);
> 	else
> 		return ov5647_stream_off(sd);
> 

No problem, I'll do that.

>> +}
>> +
>> +static const struct v4l2_subdev_video_ops subdev_video_ops = {
>> +	.s_stream =		s_stream,
>> +};
>> +
>> +
> 
> Please remove one of two empty lines in a row.
> 

Ok.

>> +static int enum_mbus_code(struct v4l2_subdev *sd,
>> +				struct v4l2_subdev_pad_config *cfg,
>> +				struct v4l2_subdev_mbus_code_enum *code)
>> +{
>> +	if (code->index > 0)
>> +		return -EINVAL;
>> +
>> +	code->code = MEDIA_BUS_FMT_SBGGR8_1X8;
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct v4l2_subdev_pad_ops subdev_pad_ops = {
>> +	.enum_mbus_code =	enum_mbus_code,
>> +};
>> +
>> +/**
>> + * @short Subdev operations registration
>> + *
>> + */
>> +static const struct v4l2_subdev_ops subdev_ops = {
>> +	.core		= &subdev_core_ops,
>> +	.video		= &subdev_video_ops,
>> +	.pad		= &subdev_pad_ops,
>> +};
>> +
>> +/**
>> + * @short Detect camera version and model
>> + * @param[in] sd v4l2 subdev
>> + * @return Error code
>> + */
>> +static int ov5647_detect(struct v4l2_subdev *sd)
>> +{
>> +	unsigned char read;
> 
> ov5647_read() return value type is 'u8', please change it here and
> everywhere else in the code.
> 

OK.

>> +	int ret;
>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +
>> +	ret = ov5647_write(sd, OV5647_SW_RESET, 0x01);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = ov5647_read(sd, OV5647_REG_CHIPID_H, &read);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	if (read != 0x56) {
>> +		dev_err(&client->dev, "Wrong model version detected");
>> +		return -ENODEV;
>> +	}
>> +
>> +	ret = ov5647_read(sd, OV5647_REG_CHIPID_L, &read);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	if (read != 0x47) {
>> +		dev_err(&client->dev, "Wrong model version detected");
>> +		return -ENODEV;
>> +	}
>> +
>> +	return ov5647_write(sd, OV5647_SW_RESET, 0x00);
>> +}
>> +
>> +/**
>> + * @short Detect if camera is registered
>> + * @param[in] sd v4l2 subdev
>> + * @return Error code
>> + */
>> +static int ov5647_registered(struct v4l2_subdev *sd)
>> +{
>> +	return 0;
>> +}
>> +
>> +/**
>> + * @short Open device
>> + * @param[in] sd v4l2 subdev
>> + * @param[in] fh v4l2 file handler
>> + * @return Error code
>> + */
>> +static int ov5647_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
>> +{
>> +	struct v4l2_mbus_framefmt *format =
>> +				v4l2_subdev_get_try_format(sd, fh->pad, 0);
>> +	struct v4l2_rect *crop =
>> +				v4l2_subdev_get_try_crop(sd, fh->pad, 0);
>> +
>> +	crop->left = OV5647_COLUMN_START_DEF;
>> +	crop->top = OV5647_ROW_START_DEF;
>> +	crop->width = OV5647_WINDOW_WIDTH_DEF;
>> +	crop->height = OV5647_WINDOW_HEIGHT_DEF;
>> +
>> +	format->code = MEDIA_BUS_FMT_SBGGR8_1X8;
>> +
>> +	format->width = OV5647_WINDOW_WIDTH_DEF;
>> +	format->height = OV5647_WINDOW_HEIGHT_DEF;
>> +	format->field = V4L2_FIELD_NONE;
>> +	format->colorspace = V4L2_COLORSPACE_SRGB;
>> +
>> +	return sensor_power(sd, true);
>> +}
>> +
>> +/**
>> + * @short Open device
>> + * @param[in] sd v4l2 subdev
>> + * @param[in] fh v4l2 file handler
>> + * @return Error code
>> + */
>> +static int ov5647_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
>> +{
>> +	return sensor_power(sd, false);
>> +}
>> +
>> +/**
>> + * @short Subdev internal operations registration
>> + *
>> + */
>> +static const struct v4l2_subdev_internal_ops ov5647_subdev_internal_ops = {
>> +	.registered = ov5647_registered,
>> +	.open = ov5647_open,
>> +	.close = ov5647_close,
>> +};
>> +
>> +/**
>> + * @short Initialization routine - Entry point of the driver
>> + * @param[in] client pointer to the i2c client structure
>> + * @param[in] id pointer to the i2c device id structure
>> + * @return 0 on success and a negative number on failure
>> + */
>> +static int ov5647_probe(struct i2c_client *client,
>> +			const struct i2c_device_id *id)
>> +{
>> +	struct device *dev = &client->dev;
>> +	struct ov5647 *sensor;
>> +	int ret;
>> +	struct v4l2_subdev *sd;
>> +
>> +	dev_info(&client->dev, "Installing OmniVision OV5647 camera driver\n");
> 
> Please remove the informational line, it will pollute the kernel log for no
> good reason.
> 

Is it okay if I change it to debug?

>> +
>> +	sensor = devm_kzalloc(dev, sizeof(*sensor), GFP_KERNEL);
>> +	if (sensor == NULL)
>> +		return -ENOMEM;
>> +
>> +	/* get system clock (xclk) */
>> +	sensor->xclk = devm_clk_get(dev, "xclk");
>> +	if (IS_ERR(sensor->xclk)) {
>> +		dev_err(dev, "could not get xclk");
>> +		return PTR_ERR(sensor->xclk);
>> +	}
>> +
>> +	ret = of_property_read_u32(dev->of_node, "clock-frequency",
>> +				    &sensor->xclk_freq);
>> +	if (ret) {
>> +		dev_err(dev, "could not get xclk frequency\n");
>> +		return ret;
>> +	}
>> +
>> +	mutex_init(&sensor->lock);
>> +	sensor->dev = dev;
> 
> sensor->dev is unused, please remove it from the 'struct ov5647' declaration.
> 

Ok.

>> +
>> +	sd = &sensor->sd;
>> +	v4l2_i2c_subdev_init(sd, client, &subdev_ops);
>> +	sensor->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>> +
>> +	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
>> +	sd->entity.function = MEDIA_ENT_F_CAM_SENSOR;
>> +	ret = media_entity_pads_init(&sd->entity, 1, &sensor->pad);
>> +	if (ret < 0)
>> +		goto mutex_remove;
>> +
>> +	ret = ov5647_detect(sd);
>> +	if (ret < 0)
>> +		goto error;
>> +
>> +	ret = v4l2_async_register_subdev(sd);
>> +	if (ret < 0)
>> +		goto error;
>> +
>> +	return 0;
>> +error:
>> +	media_entity_cleanup(&sd->entity);
>> +mutex_remove:
>> +	mutex_destroy(&sensor->lock);
>> +	return ret;
>> +}
>> +
>> +/**
>> + * @short Exit routine - Exit point of the driver
>> + * @param[in] client pointer to the i2c client structure
>> + * @return 0 on success and a negative number on failure
>> + */
>> +static int ov5647_remove(struct i2c_client *client)
>> +{
>> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
>> +	struct ov5647 *ov5647 = to_state(sd);
>> +
>> +	v4l2_async_unregister_subdev(&ov5647->sd);
>> +	media_entity_cleanup(&ov5647->sd.entity);
>> +	v4l2_device_unregister_subdev(sd);
>> +	mutex_destroy(&ov5647->lock);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct i2c_device_id ov5647_id[] = {
>> +	{ "ov5647", 0 },
>> +	{ }
>> +};
>> +MODULE_DEVICE_TABLE(i2c, ov5647_id);
>> +
>> +#if IS_ENABLED(CONFIG_OF)
> 
> From Kconfig the driver depends on OF.
> 

You're right. Do you think I should remove the dependency in Kconfig or the
check here?

>> +static const struct of_device_id ov5647_of_match[] = {
>> +	{ .compatible = "ovti,ov5647" },
>> +	{ /* sentinel */ },
>> +};
>> +MODULE_DEVICE_TABLE(of, ov5647_of_match);
>> +#endif
>> +
>> +/**
>> + * @short i2c driver structure
>> + */
>> +static struct i2c_driver ov5647_driver = {
>> +	.driver = {
>> +		.of_match_table = of_match_ptr(ov5647_of_match),
> 
> Same comment as above, from Kconfig the driver depends on OF.
> 

I'm sorry but I'm not understanding what you're trying to say.

>> +		.owner	= THIS_MODULE,
> 
> .owner is set by the core, please remove it.
> 

Ok.

>> +		.name	= "ov5647",
> 
> May be .name = SENSOR_NAME, ?
> 
> Otherwise SENSOR_NAME macro is unused and it should be removed.
> 

I'll change it to .name = SENSOR_NAME,

>> +	},
>> +	.probe		= ov5647_probe,
>> +	.remove		= ov5647_remove,
>> +	.id_table	= ov5647_id,
>> +};
>> +
>> +module_i2c_driver(ov5647_driver);
>> +
>> +MODULE_AUTHOR("Ramiro Oliveira <roliveir@synopsys.com>");
>> +MODULE_DESCRIPTION("A low-level driver for OmniVision ov5647 sensors");
>> +MODULE_LICENSE("GPL v2");
>>
> 
> --
> With best wishes,
> Vladimir
> 

-- 
Best Regards

Ramiro Oliveira
Ramiro.Oliveira@synopsys.com
