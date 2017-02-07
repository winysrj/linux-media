Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41530 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754541AbdBGRbZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Feb 2017 12:31:25 -0500
Date: Tue, 7 Feb 2017 19:31:16 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, CARLOS.PALMINHA@synopsys.com,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Rob Herring <robh+dt@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH RESEND v7 2/2] Add support for OV5647 sensor.
Message-ID: <20170207173116.GC13854@valkosipuli.retiisi.org.uk>
References: <cover.1486136893.git.roliveir@synopsys.com>
 <26e5a587f1ba9e2fbbc04284408305bc8cf8c5c0.1486136893.git.roliveir@synopsys.com>
 <20170203201729.GA18086@kekkonen.localdomain>
 <f23e76ff-326a-c4df-601d-6b12b644bff7@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f23e76ff-326a-c4df-601d-6b12b644bff7@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramiro,

On Mon, Feb 06, 2017 at 11:38:28AM +0000, Ramiro Oliveira wrote:
...
> >> +	ret = ov5647_write_array(sd, ov5647_640x480,
> >> +					ARRAY_SIZE(ov5647_640x480));
> >> +	if (ret < 0) {
> >> +		dev_err(&client->dev, "write sensor_default_regs error\n");
> >> +		return ret;
> >> +	}
> >> +
> >> +	ov5647_set_virtual_channel(sd, 0);
> >> +
> >> +	ov5647_read(sd, 0x0100, &resetval);
> >> +	if (!(resetval & 0x01)) {
> > 
> > Can this ever happen? Streaming start is at the end of the register list.
> > 
> 
> I'm not sure it can happen. It was just a safeguard, but I can remove it if you
> think it's not necessary

You're not reading back the other registers either, albeit I'd check that
the I2C accesses actually succeed. Generally the return values are ignored.

> 
> >> +		dev_err(&client->dev, "Device was in SW standby");
> >> +		ov5647_write(sd, 0x0100, 0x01);
> >> +	}
> >> +
> >> +	ov5647_write(sd, 0x4800, 0x04);
> >> +	ov5647_stream_on(sd);
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +/**
> >> + * @short Control sensor power state
> >> + * @param[in] sd v4l2 subdev
> >> + * @param[in] on Sensor power
> >> + * @return Error code
> >> + */
> >> +static int sensor_power(struct v4l2_subdev *sd, int on)
> >> +{
> >> +	int ret;
> >> +	struct ov5647 *ov5647 = to_state(sd);
> >> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> >> +
> >> +	ret = 0;
> >> +	mutex_lock(&ov5647->lock);
> >> +
> >> +	if (on && !ov5647->power_count)	{
> >> +		dev_dbg(&client->dev, "OV5647 power on\n");
> >> +
> >> +		clk_set_rate(ov5647->xclk, ov5647->xclk_freq);
> >> +
> >> +		ret = clk_prepare_enable(ov5647->xclk);
> >> +		if (ret < 0) {
> >> +			dev_err(ov5647->dev, "clk prepare enable failed\n");
> >> +			goto out;
> >> +		}
> >> +
> >> +		ret = ov5647_write_array(sd, sensor_oe_enable_regs,
> >> +				ARRAY_SIZE(sensor_oe_enable_regs));
> >> +		if (ret < 0) {
> >> +			clk_disable_unprepare(ov5647->xclk);
> >> +			dev_err(&client->dev,
> >> +				"write sensor_oe_enable_regs error\n");
> >> +			goto out;
> >> +		}
> >> +
> >> +		ret = __sensor_init(sd);
> >> +		if (ret < 0) {
> >> +			clk_disable_unprepare(ov5647->xclk);
> >> +			dev_err(&client->dev,
> >> +				"Camera not available, check Power\n");
> >> +			goto out;
> >> +		}
> >> +	} else if (!on && ov5647->power_count == 1) {
> >> +		dev_dbg(&client->dev, "OV5647 power off\n");
> >> +
> >> +		dev_dbg(&client->dev, "disable oe\n");
> >> +		ret = ov5647_write_array(sd, sensor_oe_disable_regs,
> >> +				ARRAY_SIZE(sensor_oe_disable_regs));
> >> +
> >> +		if (ret < 0)
> >> +			dev_dbg(&client->dev, "disable oe failed\n");
> >> +
> >> +		ret = set_sw_standby(sd, true);
> >> +
> >> +		if (ret < 0)
> >> +			dev_dbg(&client->dev, "soft stby failed\n");
> >> +
> >> +		clk_disable_unprepare(ov5647->xclk);
> >> +	}
> >> +
> >> +	/* Update the power count. */
> >> +	ov5647->power_count += on ? 1 : -1;
> >> +	WARN_ON(ov5647->power_count < 0);
> >> +
> >> +out:
> >> +	mutex_unlock(&ov5647->lock);
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> >> +/**
> >> + * @short Get register value
> >> + * @param[in] sd v4l2 subdev
> >> + * @param[in] reg register struct
> >> + * @return Error code
> >> + */
> >> +static int sensor_get_register(struct v4l2_subdev *sd,
> >> +				struct v4l2_dbg_register *reg)
> >> +{
> >> +	unsigned char val = 0;
> >> +	int ret;
> >> +
> >> +	ret = ov5647_read(sd, reg->reg & 0xff, &val);
> >> +	if (ret != 0)
> >> +		return ret;
> >> +
> >> +	reg->val = val;
> >> +	reg->size = 1;
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +/**
> >> + * @short Set register value
> >> + * @param[in] sd v4l2 subdev
> >> + * @param[in] reg register struct
> >> + * @return Error code
> >> + */
> >> +static int sensor_set_register(struct v4l2_subdev *sd,
> >> +				const struct v4l2_dbg_register *reg)
> >> +{
> >> +	return ov5647_write(sd, reg->reg & 0xff, reg->val & 0xff);
> >> +}
> >> +#endif
> >> +
> >> +/**
> >> + * @short Subdev core operations registration
> >> + */
> >> +static const struct v4l2_subdev_core_ops sensor_core_ops = {
> >> +	.s_power		= sensor_power,
> >> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> >> +	.g_register		= sensor_get_register,
> >> +	.s_register		= sensor_set_register,
> >> +#endif
> >> +};
> >> +
> >> +static int enum_mbus_code(struct v4l2_subdev *sd,
> >> +				struct v4l2_subdev_pad_config *cfg,
> >> +				struct v4l2_subdev_mbus_code_enum *code)
> >> +{
> >> +	if (code->index > 0)
> >> +		return -EINVAL;
> >> +
> >> +	code->code = MEDIA_BUS_FMT_SBGGR8_1X8;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static const struct v4l2_subdev_pad_ops subdev_pad_ops = {
> >> +	.enum_mbus_code = enum_mbus_code,
> >> +};
> >> +
> >> +
> >> +/**
> >> + * @short Subdev operations registration
> >> + *
> >> + */
> >> +static const struct v4l2_subdev_ops subdev_ops = {
> >> +	.core		= &sensor_core_ops,
> >> +	.pad		= &subdev_pad_ops,
> > 
> > You should implement s_stream() in video ops to control the streaming state.
> > 
> > I don't know about this particular sensor, but on SMIA compliant sensors
> > the SW standby means streaming is disabled. There seem to be additional
> > registers as well; my educated guess is that writing all those to control
> > streaming would be the right thing to do.
> > 
> > The CSI-2 bus initialisation could fail if you start streaming right away
> > when the sensor is powered on.
> > 
> 
> I haven't had any error yet, but I'll add set_stream() and start streaming video
> there, just to be sure.

It depends on the receiver. Some might work whereas some definitely don't.

Please see Documentation/media/kapi/csi2.rst .

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
