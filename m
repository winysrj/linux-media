Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:56367 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756102Ab1KOP7h (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 10:59:37 -0500
Message-ID: <4EC28C63.4060301@maxwell.research.nokia.com>
Date: Tue, 15 Nov 2011 17:59:31 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, andriy.shevchenko@linux.intel.com
Subject: Re: [PATCH v2 2/2] as3645a: Add driver for LED flash controller
References: <1321229950-31451-1-git-send-email-laurent.pinchart@ideasonboard.com> <201111151412.39333.laurent.pinchart@ideasonboard.com> <4EC28506.9080500@maxwell.research.nokia.com> <201111151653.53565.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201111151653.53565.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Hi Sakari,

Heippa,

> On Tuesday 15 November 2011 16:28:06 Sakari Ailus wrote:
>> Laurent Pinchart wrote:
>>> On Monday 14 November 2011 10:34:57 Sakari Ailus wrote:
> 
> [snip]
> 
>>>>> +	if (rval & ~AS_FAULT_INFO_INDICATOR_LED)
>>>>> +		dev_dbg(&client->dev, "No faults, nice\n");
>>>>> +
>>>>> +	return rval;
>>>>> +}
>>>>> +
>>>>> +static int as3645a_get_ctrl(struct v4l2_ctrl *ctrl)
>>>>> +{
>>>>> +	struct as3645a *flash =
>>>>> +		container_of(ctrl->handler, struct as3645a, ctrls);
>>>>> +	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
>>>>> +	int fault;
>>>>> +
>>>>> +	switch (ctrl->id) {
>>>>> +	case V4L2_CID_FLASH_FAULT:
>>>>> +		fault = as3645a_read_fault(flash);
>>>>> +		if (fault < 0)
>>>>> +			return fault;
>>>>
>>>> ctrl->cur.val = 0 here?
>>>
>>> fault being negative means that reading the fault register failed. In
>>> that case I don't think we should update ctrl->cur.val.
>>
>> I thought that ctrl->cur.val should be assigned to zero before settings
>> bits in it. Does that sound better? :-)
> 
> Oops, my bad, I misunderstood your comment. I'll fix that.

Thanks.

>>>>> +static int as3645a_registered(struct v4l2_subdev *sd)
>>>>> +{
>>>>> +	struct as3645a *flash = to_as3645a(sd);
>>>>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>>>>> +	int rval, man, model, rfu, version;
>>>>> +	const char *factory;
>>>>> +
>>>>> +	/* Power up the flash driver and read manufacturer ID, model ID, RFU
>>>>> +	 * and version.
>>>>> +	 */
>>>>> +	as3645a_set_power(&flash->subdev, 1);
>>>>> +
>>>>> +	rval = as3645a_read(flash, AS_DESIGN_INFO_REG);
>>>>> +	if (rval < 0)
>>>>> +		goto power_off;
>>>>> +
>>>>> +	man = AS_DESIGN_INFO_FACTORY(rval);
>>>>> +	model = AS_DESIGN_INFO_MODEL(rval);
>>>>> +
>>>>> +	rval = as3645a_read(flash, AS_VERSION_CONTROL_REG);
>>>>> +	if (rval < 0)
>>>>> +		goto power_off;
>>>>> +
>>>>> +	rfu = AS_VERSION_CONTROL_RFU(rval);
>>>>> +	version = AS_VERSION_CONTROL_VERSION(rval);
>>>>> +
>>>>> +	/* Verify the chip model and version. */
>>>>> +	if (model != 0x0001 || rfu != 0x0000) {
>>>>> +		dev_err(&client->dev, "AS3645A not detected "
>>>>> +			"(model %d rfu %d)\n", model, rfu);
>>>>> +		rval = -ENODEV;
>>>>
>>>> Is this so grave issue we should discontinue? I'd perhaps print a
>>>> warning if even that.
>>>
>>> This could mean that the chip isn't an AS3645A/LM3555 at all. Many I2C
>>> drivers perform the same check, they read the ID register and fail if it
>>> doesn't contain the expected value.
>>
>> Shouldn't we instead check the design info register has a valid id in it
>> only? The spec I have doesn't say anything about the version of the
>> chip.
> 
> I agree that checking the model shoudl be enough. However, if a new chip comes 
> out with an RFU value != 0, it will probably mean that the driver will need to 
> be adapted anyway. Isn't it better to catch that instead of ignoring it ?

Ok. I'm fine with that.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
