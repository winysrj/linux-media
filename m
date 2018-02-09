Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:51034 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750924AbeBINga (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Feb 2018 08:36:30 -0500
Subject: Re: [PATCHv2 06/15] v4l2-subdev: implement VIDIOC_DBG_G_CHIP_INFO
 ioctl
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hansverk@cisco.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180208083655.32248-1-hverkuil@xs4all.nl>
 <2001099.VTHt2F8In2@avalon> <fa7f13c7-cf71-5314-884d-b82c2744b0ca@cisco.com>
 <5425572.7qW1Nz09jW@avalon>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <571534c6-e228-9175-13cb-dc16f69eba0b@xs4all.nl>
Date: Fri, 9 Feb 2018 14:36:25 +0100
MIME-Version: 1.0
In-Reply-To: <5425572.7qW1Nz09jW@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/09/18 14:21, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Friday, 9 February 2018 15:13:26 EET Hans Verkuil wrote:
>> On 02/09/18 14:04, Laurent Pinchart wrote:
>>> On Friday, 9 February 2018 15:00:53 EET Hans Verkuil wrote:
>>>> On 02/09/18 13:44, Sakari Ailus wrote:
>>>>> On Fri, Feb 09, 2018 at 01:18:18PM +0100, Hans Verkuil wrote:
>>>>>> On 02/09/18 13:01, Sakari Ailus wrote:
>>>>>>> On Thu, Feb 08, 2018 at 09:36:46AM +0100, Hans Verkuil wrote:
>>>>>>>> The VIDIOC_DBG_G/S_REGISTER ioctls imply that VIDIOC_DBG_G_CHIP_INFO
>>>>>>>> is also present, since without that you cannot use v4l2-dbg.
>>>>>>>>
>>>>>>>> Just like the implementation in v4l2-ioctl.c this can be implemented
>>>>>>>> in the core and no drivers need to be modified.
>>>>>>>>
>>>>>>>> It also makes it possible for v4l2-compliance to properly test the
>>>>>>>> VIDIOC_DBG_G/S_REGISTER ioctls.
>>>>>>>>
>>>>>>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>>>>>> ---
>>>>>>>>
>>>>>>>>  drivers/media/v4l2-core/v4l2-subdev.c | 13 +++++++++++++
>>>>>>>>  1 file changed, 13 insertions(+)
>>>>>>>>
>>>>>>>> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c
>>>>>>>> b/drivers/media/v4l2-core/v4l2-subdev.c index
>>>>>>>> 6cabfa32d2ed..2a5b5a3fa7a3 100644
>>>>>>>> --- a/drivers/media/v4l2-core/v4l2-subdev.c
>>>>>>>> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
>>>>>>>> @@ -255,6 +255,19 @@ static long subdev_do_ioctl(struct file *file,
>>>>>>>> unsigned int cmd, void *arg)>>>>
>>>>>>>>
>>>>>>>>  			return -EPERM;
>>>>>>>>  		return v4l2_subdev_call(sd, core, s_register, p);
>>>>>>>>  	}
>>>>>>>> +	case VIDIOC_DBG_G_CHIP_INFO:
>>>>>>>> +	{
>>>>>>>> +		struct v4l2_dbg_chip_info *p = arg;
>>>>>>>> +
>>>>>>>> +		if (p->match.type != V4L2_CHIP_MATCH_SUBDEV || p->match.addr)
>>>>>>>> +			return -EINVAL;
>>>>>>>> +		if (sd->ops->core && sd->ops->core->s_register)
>>>>>>>> +			p->flags |= V4L2_CHIP_FL_WRITABLE;
>>>>>>>> +		if (sd->ops->core && sd->ops->core->g_register)
>>>>>>>> +			p->flags |= V4L2_CHIP_FL_READABLE;
>>>>>>>> +		strlcpy(p->name, sd->name, sizeof(p->name));
>>>>>>>> +		return 0;
>>>>>>>> +	}
>>>>>>>
>>>>>>> This is effectively doing the same as debugfs except that it's
>>>>>>> specific to V4L2. I don't think we should endorse its use, and
>>>>>>> especially not without a real use case.
>>>>>>
>>>>>> We (Cisco) use it all the time. Furthermore, this works for any bus,
>>>>>> not just i2c. Also spi, internal register busses, etc.
>>>>>>
>>>>>> It's been in use for many years. More importantly, there is no excuse
>>>>>> to have only half the API implemented.
>>>>>>
>>>>>> It's all fine to talk about debugfs, but are you going to make that?
>>>>>> This API works, it's supported by v4l2-dbg, it's in use. Now, let's at
>>>>>> least make it pass v4l2-compliance.
>>>>>>
>>>>>> I agree, if we would redesign it, we would use debugfs. But I think it
>>>>>> didn't even exist when this was made. So this API is here to stay and
>>>>>> all it takes is this ioctl of code to add the missing piece for
>>>>>> subdevs.
>>>>>>
>>>>>> Nobody is going to make a replacement for this using debugfs. Why spend
>>>>>> effort on it if we already have an API for this?
>>>>>
>>>>> It's not the first case when a more generic API replaces a subsystem
>>>>> specific one. We have another conversion to make, switching from
>>>>> implementing s_power() callback in drivers to runtime PM for instance.
>>>>>
>>>>> I simply want to point out that this patch is endorsing something which
>>>>> is obsolete and not needed: no-one has complained about the lack of this
>>>>> for sub-devices, haven't they?
>>>>>
>>>>> I'd just remove the check from v4l-compliance or make it optional. New
>>>>> drivers should use debugfs instead if something like that is needed.
>>>>
>>>> You are correct in one respect: we use this API, but with video devices.
>>>> So subdevices support the g/s_register ops, and they are called via
>>>> /dev/videoX.
>>>>
>>>> We can remove the ioctl support from v4l2-subdev.c (not the g/s_register
>>>> ops!). Without VIDIOC_DBG_G_CHIP_INFO I don't think v4l2-dbg is usable.
>>>> Although it is always possible to call the ioctl directly, of course.
>>>>
>>>> So if Mauro would agree to this, the DBG ioctl support in v4l2-subdev can
>>>> be removed.
>>>
>>> That would be my preferred option.
>>>
>>>> But either remove them, or add this ioctl. Don't leave it in a zombie
>>>> state.
>>>>
>>>> Personally I see no harm whatsoever in just adding
>>>> VIDIOC_DBG_G_CHIP_INFO. If someone ever makes a patch to switch over to
>>>> debugfs then these ioctls can be removed.
>>>>
>>>> BTW, how would new drivers use debugfs for this? Does regmap provide such
>>>> access?
>>>
>>> Before attempting to provide an answer, as I've never used those ioctls
>>> myself, could you please give us a bit more information about the use
>>> cases you have at Cisco for this ?
>>
>> Exactly what it was made for: debugging issues by reading/writing registers
>> on the fly. It's very similar to using i2cget/set for i2c devices, except it
>> can also be used for registers in e.g. an IP block. It's also a bit safer
>> since you can filter (if needed) which addresses can be written.
> 
> We're talking about debugging during development, not in production, right ?

Sometimes you need to debug issues even when it is in production.

A major difference between sensors and video receivers is that you (generally)
know what the sensor sends you, but for video receivers you have no control
whatsoever of what it is being sent by a source. Being able to read and in
rare cases write registers can be very helpful to get to the bottom of the
problem.

So yes, this is important functionality. Hardly something you use every day,
but it's great that you have the option.

Regards,

	Hans
