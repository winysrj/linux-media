Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.47.9]:60452 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753954AbcKUPBG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Nov 2016 10:01:06 -0500
Subject: Re: [PATCH v4 2/2] Add support for OV5647 sensor
To: Pavel Machek <pavel@ucw.cz>,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
References: <cover.1479129004.git.roliveir@synopsys.com>
 <36447f1f102f648057eb9038a693941794a6c344.1479129004.git.roliveir@synopsys.com>
 <20161115121032.GB7018@amd>
CC: <mchehab@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>, <davem@davemloft.net>,
        <gregkh@linuxfoundation.org>, <geert+renesas@glider.be>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <hverkuil@xs4all.nl>, <dheitmueller@kernellabs.com>,
        <slongerbeam@gmail.com>, <lars@metafoo.de>,
        <robert.jarzmik@free.fr>, <pali.rohar@gmail.com>,
        <sakari.ailus@linux.intel.com>, <mark.rutland@arm.com>,
        <CARLOS.PALMINHA@synopsys.com>
From: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Message-ID: <9992afb4-d0a4-6101-6381-aaef0c09b9df@synopsys.com>
Date: Mon, 21 Nov 2016 15:00:40 +0000
MIME-Version: 1.0
In-Reply-To: <20161115121032.GB7018@amd>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel!

On 11/15/2016 12:10 PM, Pavel Machek wrote:
> Hi!
> 
>> Add support for OV5647 sensor.
>>
> 
>> +static int ov5647_write(struct v4l2_subdev *sd, u16 reg, u8 val)
>> +{
>> +	int ret;
>> +	unsigned char data[3] = { reg >> 8, reg & 0xff, val};
>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +
>> +	ret = i2c_master_send(client, data, 3);
>> +	if (ret != 3) {
>> +		dev_dbg(&client->dev, "%s: i2c write error, reg: %x\n",
>> +				__func__, reg);
>> +		return ret < 0 ? ret : -EIO;
>> +	}
>> +	return 0;
>> +}
> 
> Sorry, this is wrong. It should something <0 any time error is detected.
> 
>> +static int ov5647_write_array(struct v4l2_subdev *sd,
>> +				struct regval_list *regs, int array_size)
>> +{
>> +	int i = 0;
>> +	int ret = 0;
>> +
>> +	if (!regs)
>> +		return -EINVAL;
>> +
>> +	while (i < array_size) {
>> +		ret = ov5647_write(sd, regs->addr, regs->data);
>> +		if (ret < 0)
>> +			return ret;
>> +		i++;
>> +		regs++;
>> +	}
>> +	return 0;
>> +}
> 
> For example this expects <0 on error.
> 
>> +static int set_sw_standby(struct v4l2_subdev *sd, bool standby)
>> +{
>> +	int ret;
>> +	unsigned char rdval;
>> +
>> +	ret = ov5647_read(sd, 0x0100, &rdval);
>> +	if (ret != 0)
>> +		return ret;
>> +
>> +	if (standby)
>> +		ret = ov5647_write(sd, 0x0100, rdval&0xfe);
>> +	else
>> +		ret = ov5647_write(sd, 0x0100, rdval|0x01);
>> +
>> +	return ret;
> 
> if (standby)
>      rdval &= 0xfe;
> else
>      rdval |= 0x01;
> 
> ret = ov5647_write(sd, 0x0100, rdval);
> 
> ?
> 
> 
>> +/**
>> + * @short Store information about the video data format.
>> + */
>> +static struct sensor_format_struct {
>> +	__u8 *desc;
>> +	u32 mbus_code;
> 
> u8 is suitable here.
> 
> 
>> +	ov5647_read(sd, 0x0100, &resetval);
>> +		if (!resetval&0x01) {
> 
> add ()s here.
> 
>> +static int sensor_power(struct v4l2_subdev *sd, int on)
>> +{
>> +	int ret;
>> +	struct ov5647 *ov5647 = to_state(sd);
>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +
>> +	ret = 0;
>> +	mutex_lock(&ov5647->lock);
>> +
>> +	if (on)	{
>> +		dev_dbg(&client->dev, "OV5647 power on!\n");
>> +
>> +		ret = ov5647_write_array(sd, sensor_oe_enable_regs,
>> +				ARRAY_SIZE(sensor_oe_enable_regs));
>> +
>> +		ret = __sensor_init(sd);
>> +
>> +		if (ret < 0)
>> +			dev_err(&client->dev,
>> +				"Camera not available! Check Power!\n");
>> +	} else {
>> +		dev_dbg(&client->dev, "OV5647 power off!\n");
>> +
>> +		dev_dbg(&client->dev, "disable oe\n");
>> +		ret = ov5647_write_array(sd, sensor_oe_disable_regs,
>> +				ARRAY_SIZE(sensor_oe_disable_regs));
>> +
>> +		if (ret < 0)
>> +			dev_dbg(&client->dev, "disable oe failed!\n");
>> +
>> +		ret = set_sw_standby(sd, true);
>> +
>> +		if (ret < 0)
>> +			dev_dbg(&client->dev, "soft stby failed!\n");
> 
> dev_err for errors? Little less "!"s in the output?
> 
>> +static int sensor_get_register(struct v4l2_subdev *sd,
>> +				struct v4l2_dbg_register *reg)
>> +{
>> +	unsigned char val = 0;
>> +	int ret;
>> +
>> +	ret = ov5647_read(sd, reg->reg & 0xff, &val);
>> +	reg->val = val;
>> +	reg->size = 1;
>> +	return ret;
>> +}
> 
> Filling reg->* when read failed is strange.
> 
>> +static int sensor_set_register(struct v4l2_subdev *sd,
>> +				const struct v4l2_dbg_register *reg)
>> +{
>> +	ov5647_write(sd, reg->reg & 0xff, reg->val & 0xff);
>> +	return 0;
>> +}
> 
> error handling?
> 
> Best regards,
> 									Pavel
> 

Thanks for the feedback, I've corrected all the issues you pointed out, except
the one regarding the error handling in the ov5647_write function.

Best Regards,
Ramiro
