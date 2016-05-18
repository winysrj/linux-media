Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:37414 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbcERJct (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2016 05:32:49 -0400
Received: by mail-wm0-f52.google.com with SMTP id a17so69835821wme.0
        for <linux-media@vger.kernel.org>; Wed, 18 May 2016 02:32:48 -0700 (PDT)
Subject: Re: [PATCH] media: Add a driver for the ov5645 camera sensor.
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <1463065155-26337-1-git-send-email-todor.tomov@linaro.org>
 <5739838A.3070405@mm-sol.com> <573986F1.1070109@xs4all.nl>
 <1755291.v0jfUP1x0u@avalon>
Cc: linux-media@vger.kernel.org
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <573C36BC.5070401@linaro.org>
Date: Wed, 18 May 2016 12:32:44 +0300
MIME-Version: 1.0
In-Reply-To: <1755291.v0jfUP1x0u@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans, Laurent,

On 05/16/2016 03:13 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Monday 16 May 2016 10:38:09 Hans Verkuil wrote:
>> On 05/16/2016 10:23 AM, Todor Tomov wrote:
>>> On 05/13/2016 10:02 AM, Hans Verkuil wrote:
>>>> On 05/12/2016 04:59 PM, Todor Tomov wrote:
>>>>> The ov5645 sensor from Omnivision supports up to 2592x1944
>>>>> and CSI2 interface.
>>>>>
>>>>> The driver adds support for the following modes:
>>>>> - 1280x960
>>>>> - 1920x1080
>>>>> - 2592x1944
>>>>>
>>>>> Output format is packed 8bit UYVY.
>>>>>
>>>>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>>>>> ---
>>>>>
>>>>>  .../devicetree/bindings/media/i2c/ov5645.txt       |   54 +
>>>>>  drivers/media/i2c/Kconfig                          |   11 +
>>>>>  drivers/media/i2c/Makefile                         |    1 +
>>>>>  drivers/media/i2c/ov5645.c                         | 1344 +++++++++++++
>>>>>  4 files changed, 1410 insertions(+)
>>>>>  create mode 100644
>>>>>  Documentation/devicetree/bindings/media/i2c/ov5645.txt
>>>>>  create mode 100644 drivers/media/i2c/ov5645.c
>>>>>
>>>>> +static int ov5645_open(struct v4l2_subdev *subdev, struct
>>>>> v4l2_subdev_fh *fh) +{
>>>>> +	return ov5645_s_power(subdev, true);
>>>>> +}
>>>>> +
>>>>> +static int ov5645_close(struct v4l2_subdev *subdev, struct
>>>>> v4l2_subdev_fh *fh) +{
>>>>> +	return ov5645_s_power(subdev, false);
>>>>> +}
>>>>
>>>> This won't work: you can open the v4l-subdev node multiple times, so if I
>>>> open it twice then the next close will power down the chip and the last
>>>> remaining open is in a bad state.
>>>
>>> Multiple power up/down are handled inside ov5645_s_power. There is
>>> power_count reference counting variable. Do you see any problem with
>>> this?
>>>
>>>>> +
>>>>> +static int ov5645_s_stream(struct v4l2_subdev *subdev, int enable)
>>>>> +{
>>>>> +	struct ov5645 *ov5645 = to_ov5645(subdev);
>>>>> +	int ret;
>>>>> +
>>>>> +	dev_dbg(ov5645->dev, "%s: enable = %d\n", __func__, enable);
>>>>> +
>>>>> +	if (enable) {
>>>>> +		ret = ov5645_change_mode(ov5645, ov5645->current_mode);
>>>>> +		if (ret < 0) {
>>>>> +			dev_err(ov5645->dev, "could not set mode %d\n",
>>>>> +				ov5645->current_mode);
>>>>> +			return ret;
>>>>> +		}
>>>>> +		ret = v4l2_ctrl_handler_setup(&ov5645->ctrls);
>>>>> +		if (ret < 0) {
>>>>> +			dev_err(ov5645->dev, "could not sync v4l2 controls\n");
>>>>> +			return ret;
>>>>> +		}
>>>>> +		ov5645_write_reg(ov5645, OV5645_SYSTEM_CTRL0,
>>>>> +				 OV5645_SYSTEM_CTRL0_START);
>>>>> +	} else {
>>>>> +		ov5645_write_reg(ov5645, OV5645_SYSTEM_CTRL0,
>>>>> +				 OV5645_SYSTEM_CTRL0_STOP);
>>>>> +	}
>>>>> +
>>>>> +	return 0;
>>>>> +}
>>>>
>>>> It might make more sense to power up on s_stream(true) or off on
>>>> s_stream(false).
>>>
>>> When the sensor is powered up on open, it allows to open the subdev, set
>>> any controls and have the result from configuring these controls in
>>> hardware (without starting streaming). This is my reasoning behind this.
>>
>> It's fairly pointless. If you open the device, set controls, then close it,
>> they are all lost again. You are already setting everything up again in
>> s_stream anyway.
>>
>> Just don't bother with s_power in the open and close (or with refcounting
>> for that matter).
> 
> In which case the .s_ctrl() handler will need to bail out early if power isn't 
> applied, with locking to ensure there's no race condition. Having a 
> .s_power(1) call in .open() solves that, and also allows userspace to power 
> the device on and set controls early if needed, as long as the file handle is 
> kept open.

Ok, I'm convinced now that there is no benefit to set the controls early -
at least for this driver and the available controls I don't see any benefit.
I'm going to remove the s_power on open/close and will resend.

> 
>> BTW, if I am not mistaken a bridge driver that calls this subdev and wants
>> to start streaming also has to call s_power before s_stream. So to answer
>> my own question: there is no need to call s_power in s_stream.
> 
> That I agree with.
> 

-- 
Best regards,
Todor Tomov
