Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46056 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab2CJONe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Mar 2012 09:13:34 -0500
Received: by wibhq7 with SMTP id hq7so1666392wib.1
        for <linux-media@vger.kernel.org>; Sat, 10 Mar 2012 06:13:33 -0800 (PST)
Message-ID: <4F5B6189.907@gmail.com>
Date: Sat, 10 Mar 2012 15:13:29 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, sakari.ailus@iki.fi,
	Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: Re: [PATCH v5 1/1] v4l: Add driver for Micron MT9M032 camera sensor
References: <1331305285-10781-6-git-send-email-laurent.pinchart@ideasonboard.com> <1331324481-9926-1-git-send-email-laurent.pinchart@ideasonboard.com> <4F5A7667.4000709@gmail.com> <1859441.NBMQGniVTr@avalon>
In-Reply-To: <1859441.NBMQGniVTr@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 03/10/2012 01:17 PM, Laurent Pinchart wrote:
> Hi Sylwester,
> 
> On Friday 09 March 2012 22:30:15 Sylwester Nawrocki wrote:
>> Hi Laurent,
>>
>> I have a few minor comments, if you don't mind. :)
> 
> Sure, thanks for the review.
> 
>> On 03/09/2012 09:21 PM, Laurent Pinchart wrote:
>>> From: Martin Hostettler<martin@neutronstar.dyndns.org>
>>>
>>> The MT9M032 is a parallel 1.6MP sensor from Micron controlled through I2C.
>>>
>>> The driver creates a V4L2 subdevice. It currently supports cropping, gain,
>>> exposure and v/h flipping controls in monochrome mode with an
>>> external pixel clock.
>>>
>>> Signed-off-by: Martin Hostettler<martin@neutronstar.dyndns.org>
>>> [Lots of clean up, fixes and enhancements]
>>> Signed-off-by: Laurent Pinchart<laurent.pinchart@ideasonboard.com>

If it helps, you can add my:

   Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

...
>>> +static int mt9m032_set_ctrl(struct v4l2_ctrl *ctrl)
>>> +{
>>> +	struct mt9m032 *sensor =
>>> +		container_of(ctrl->handler, struct mt9m032, ctrls);
>>> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
>>> +	int ret;
>>> +
>>> +	switch (ctrl->id) {
>>> +	case V4L2_CID_GAIN:
>>> +		return mt9m032_set_gain(sensor, ctrl->val);
>>> +
>>> +	case V4L2_CID_HFLIP:
>>> +	case V4L2_CID_VFLIP:
>>
>> mt9m032_set_ctrl() will never be called with V4L2_CID_VFLIP control id,
>> since the first control in the cluster is HFLIP.
> 
> I agree that V4L2_CID_VFLIP will never be seen here, but I find it more
> explicit to list all controls in the cluster. What do you think of something
> like the following ?
> 
>          case V4L2_CID_HFLIP:
>          /* case V4L2_CID_VFLIP: -- In the same cluster */

Yeah, sounds better, than just removing VFLIP. It might make things 
easier to understand at first sight.

>>> +		return update_read_mode2(sensor, sensor->vflip->val,
>>> +					 sensor->hflip->val);
>>> +
>>> +	case V4L2_CID_EXPOSURE:
>>> +		ret = mt9m032_write(client, MT9M032_SHUTTER_WIDTH_HIGH,
>>> +				    (ctrl->val>>   16)&   0xffff);
>>> +		if (ret<   0)
>>> +			return ret;
>>> +
>>> +		return mt9m032_write(client, MT9M032_SHUTTER_WIDTH_LOW,
>>> +				     ctrl->val&   0xffff);
>>> +
>>
>>> +	default:
>> This is an impossible case, isn't it ? The control framework won't call
>> s_ctrl op for controls that were never registered to the control handler,
>> AFAIK. So it should be safe to omit the "default" case. OTOH some rules say
>> that it is a good practice to always have the "default" case with a switch
>> statement.
> 
> I'll remove it.
> 
>>> +		return -EINVAL;
>>> +	}
>>> +}
> 
> [snip]
> 
>>> +static int mt9m032_probe(struct i2c_client *client,
>>> +			 const struct i2c_device_id *devid)
>>> +{
>>> +	struct i2c_adapter *adapter = client->adapter;
>>> +	struct mt9m032 *sensor;
>>> +	int chip_version;
>>> +	int ret;
>>> +
>>> +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
>>> +		dev_warn(&client->dev,
>>> +			 "I2C-Adapter doesn't support I2C_FUNC_SMBUS_WORD\n");
>>> +		return -EIO;
>>> +	}
>>> +
>>> +	if (!client->dev.platform_data)
>>> +		return -ENODEV;
>>> +
>>> +	sensor = kzalloc(sizeof(*sensor), GFP_KERNEL);
>>
>> Haven't you consider using devm_kzalloc() ?
>> (http://www.kernel.org/doc/htmldocs/device-drivers/API-devm-kzalloc.html)
>> It would slightly simplify the code, however it will use a couple of bytes
>> of memory for the resource tracking.
> 
> I came across that recently and haven't made my mind up yet :-) I'll need to
> try it.

Maybe benefits in this case are not that significant, but as more and more 
kernel subsystems support the dynamically managed resources, error handling
in drivers becomes much simpler than before.

--

Regards,
Sylwester
