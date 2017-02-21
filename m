Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.60.111]:42095 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752039AbdBUQm0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 11:42:26 -0500
Subject: Re: [PATCH v9 2/2] Add support for OV5647 sensor.
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>
References: <cover.1487334912.git.roliveir@synopsys.com>
 <412e51e695630281d2084a77c0329fd273ea00d7.1487334912.git.roliveir@synopsys.com>
 <cea82e22-07eb-dd8a-c781-7384ac27823e@mentor.com>
CC: <CARLOS.PALMINHA@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        "Hans Verkuil" <hans.verkuil@cisco.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali.rohar@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Rob Herring <robh+dt@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
From: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Message-ID: <c39814c2-20a0-db08-38c1-ce95ccc49738@synopsys.com>
Date: Tue, 21 Feb 2017 16:42:13 +0000
MIME-Version: 1.0
In-Reply-To: <cea82e22-07eb-dd8a-c781-7384ac27823e@mentor.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vladimir,

Thank you for your feedback

On 2/21/2017 3:54 PM, Vladimir Zapolskiy wrote:
> Hi Ramiro,
> 
> please find some review comments below.
> 
> On 02/17/2017 03:14 PM, Ramiro Oliveira wrote:
>> The OV5647 sensor from Omnivision supports up to 2592x1944 @ 15 fps, RAW 8
>> and RAW 10 output formats, and MIPI CSI-2 interface.
>>
>> The driver adds support for 640x480 RAW 8.
>>
>> Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>
>> ---
> 
> [snip]
> 
>> +
>> +struct ov5647 {
>> +	struct v4l2_subdev		sd;
>> +	struct media_pad		pad;
>> +	struct mutex			lock;
>> +	struct v4l2_mbus_framefmt	format;
>> +	unsigned int			width;
>> +	unsigned int			height;
>> +	int				power_count;
>> +	struct clk			*xclk;
>> +	/* External clock frequency currently supported is 30MHz */
>> +	u32				xclk_freq;
> 
> See a comment about 25MHz vs 30MHz below.
> 
> Also I assume you can remove 'xclk_freq' from the struct fields,
> it can be replaced by a local variable.
> 

I'll do that.

>> +};
> 
> [snip]
> 
>> +
>> +static int ov5647_read(struct v4l2_subdev *sd, u16 reg, u8 *val)
>> +{
>> +	int ret;
>> +	unsigned char data_w[2] = { reg >> 8, reg & 0xff };
>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +
>> +	ret = i2c_master_send(client, data_w, 2);
>> +	if (ret < 0) {
>> +		dev_dbg(&client->dev, "%s: i2c read error, reg: %x\n",
> 
> s/i2c read error/i2c write error/
> 

I'm not sure I understand what you mean.

>> +			__func__, reg);
>> +		return ret;
>> +	}
>> +
>> +	ret = i2c_master_recv(client, val, 1);
>> +	if (ret < 0)
>> +		dev_dbg(&client->dev, "%s: i2c read error, reg: %x\n",
>> +				__func__, reg);
>> +
>> +	return ret;
>> +
> 
> Please remove the empty line above.
> 

Ok.

>> +}
>> +
>> +static int ov5647_write_array(struct v4l2_subdev *sd,
>> +				struct regval_list *regs, int array_size)
>> +{
>> +	int i = 0, ret;
> 
> Assignment of 'i' on declaration is not needed, please remove.
> 

Ok.

>> +
>> +	for (i = 0; i < array_size; i++) {
>> +		ret = ov5647_write(sd, regs[i].addr, regs[i].data);
>> +		if (ret < 0)
>> +			return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int ov5647_set_virtual_channel(struct v4l2_subdev *sd, int channel)
>> +{
>> +	u8 channel_id;
>> +	int ret;
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
> 
> Should you add a check of the returned value?
> 

I'll add it.

>> +
>> +	dev_dbg(&client->dev, "Stream on");
> 
> I would suggest to remove dev_dbg(), because ftrace will report to a user,
> when this function is called.
> 
> Also dev_dbg() in the middle of two I2C transfers in a row looks as being
> placed improperly.
> 

I'll remove it.

>> +
>> +	return ov5647_write(sd, 0x300D, 0x00);
>> +}
>> +
>> +static int ov5647_stream_off(struct v4l2_subdev *sd)
>> +{
>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +
>> +	ov5647_write(sd, 0x4202, 0x0f);
> 
> Should you add a check of the returned value?
> 

I'll add it.

>> +
>> +	dev_dbg(&client->dev, "Stream off");
> 
> I would suggest to remove dev_dbg(), because ftrace will report to a user,
> when this function is called.
> 
> Also dev_dbg() in the middle of two I2C transfers in a row looks as being
> placed improperly.
> 

I'll remove it.

>> +
>> +	return ov5647_write(sd, 0x300D, 0x01);
>> +}
>> +
>> +static int set_sw_standby(struct v4l2_subdev *sd, bool standby)
>> +{
>> +	int ret;
>> +	u8 rdval;
>> +
>> +	ret = ov5647_read(sd, 0x0100, &rdval);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	if (standby)
>> +		rdval &= ~0x01;
>> +	else
>> +		rdval |= 0x01;
>> +
>> +	return ov5647_write(sd, 0x0100, rdval);
>> +}
>> +
>> +static int __sensor_init(struct v4l2_subdev *sd)
>> +{
>> +	int ret;
>> +	u8 resetval;
>> +	u8 rdval;
> 
> It could be possible to put declarations of 'resetval' and 'rdval' on the same line.
> 

Sure.

>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +
>> +	dev_dbg(&client->dev, "sensor init\n");
>> +
>> +	ret = ov5647_read(sd, 0x0100, &rdval);
>> +	if (ret < 0)
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
> 
> Now clk_set_rate() is redundant, please remove it.
> 
> If once it is needed again, please move it to the .probe function, so
> it is called only once in the runtime.
> 

Ok. I'll remove it for now.

>> +
>> +		ret = clk_prepare_enable(ov5647->xclk);
> 
> I wonder would it be possible to unload the driver or to unbind the device
> and leave the clock unintentionally enabled? If yes, then this is a bug.
> 

You're saying that if the driver was unloaded and the clock was left enabled
when the driver was loaded again this line would cause an error?

Should I disable the clock when the driver is removed?

>> +		if (ret < 0) {
>> +			dev_err(&client->dev, "clk prepare enable failed\n");
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
> 
> One of two dev_dbg()'s above is apparently redundant.
> 

I'll remove one.

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
> 
> [snip]
> 
>> +
>> +static int ov5647_probe(struct i2c_client *client,
>> +			const struct i2c_device_id *id)
>> +{
>> +	struct device *dev = &client->dev;
>> +	struct ov5647 *sensor;
>> +	int ret;
>> +	struct v4l2_subdev *sd;
>> +
>> +	sensor = devm_kzalloc(dev, sizeof(*sensor), GFP_KERNEL);
>> +	if (sensor == NULL)
> 
> if (!sensor) is a bit shorter.
> 

I'll change it.

>> +		return -ENOMEM;
>> +
>> +	/* get system clock (xclk) */
>> +	sensor->xclk = devm_clk_get(dev, "xclk");
>> +	if (IS_ERR(sensor->xclk)) {
>> +		dev_err(dev, "could not get xclk");
>> +		return PTR_ERR(sensor->xclk);
>> +	}
>> +
>> +	sensor->xclk_freq = clk_get_rate(sensor->xclk);
>> +	if (sensor->xclk_freq != 25000000) {
> 
> A comment in "struct ov5647" declaration says about 30MHz, which one is correct?
> 

25 MHz is the correct one.

>> +		dev_err(dev, "Unsupported clock frequency: %u\n",
>> +			sensor->xclk_freq);
>> +		return -EINVAL;
>> +	}
>> +
>> +	mutex_init(&sensor->lock);
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
>> +	dev_dbg(&client->dev, "OmniVision OV5647 camera driver probed\n");
>> +	return 0;
>> +error:
>> +	media_entity_cleanup(&sd->entity);
>> +mutex_remove:
>> +	mutex_destroy(&sensor->lock);
>> +	return ret;
>> +}
>> +
> 
> [snip]
> 
> The driver looks good in general IMO.
> 
> --
> With best wishes,
> Vladimir
> 

-- 
Best Regards

Ramiro Oliveira
Ramiro.Oliveira@synopsys.com
