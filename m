Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:9767 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750973AbeBINAz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Feb 2018 08:00:55 -0500
Subject: Re: [PATCHv2 06/15] v4l2-subdev: implement VIDIOC_DBG_G_CHIP_INFO
 ioctl
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20180208083655.32248-1-hverkuil@xs4all.nl>
 <20180208083655.32248-7-hverkuil@xs4all.nl>
 <20180209120136.heg43pxmrkssy5l7@valkosipuli.retiisi.org.uk>
 <8c4212b7-2171-7fa9-72d3-4ae38912f663@xs4all.nl>
 <20180209124407.sngsru4jd35iuuth@valkosipuli.retiisi.org.uk>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <e56fae29-52ba-29c4-bc2e-c328d433db8f@cisco.com>
Date: Fri, 9 Feb 2018 14:00:53 +0100
MIME-Version: 1.0
In-Reply-To: <20180209124407.sngsru4jd35iuuth@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/09/18 13:44, Sakari Ailus wrote:
> On Fri, Feb 09, 2018 at 01:18:18PM +0100, Hans Verkuil wrote:
>> On 02/09/18 13:01, Sakari Ailus wrote:
>>> Hi Hans,
>>>
>>> On Thu, Feb 08, 2018 at 09:36:46AM +0100, Hans Verkuil wrote:
>>>> The VIDIOC_DBG_G/S_REGISTER ioctls imply that VIDIOC_DBG_G_CHIP_INFO is also
>>>> present, since without that you cannot use v4l2-dbg.
>>>>
>>>> Just like the implementation in v4l2-ioctl.c this can be implemented in the
>>>> core and no drivers need to be modified.
>>>>
>>>> It also makes it possible for v4l2-compliance to properly test the
>>>> VIDIOC_DBG_G/S_REGISTER ioctls.
>>>>
>>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>> ---
>>>>  drivers/media/v4l2-core/v4l2-subdev.c | 13 +++++++++++++
>>>>  1 file changed, 13 insertions(+)
>>>>
>>>> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
>>>> index 6cabfa32d2ed..2a5b5a3fa7a3 100644
>>>> --- a/drivers/media/v4l2-core/v4l2-subdev.c
>>>> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
>>>> @@ -255,6 +255,19 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>>>>  			return -EPERM;
>>>>  		return v4l2_subdev_call(sd, core, s_register, p);
>>>>  	}
>>>> +	case VIDIOC_DBG_G_CHIP_INFO:
>>>> +	{
>>>> +		struct v4l2_dbg_chip_info *p = arg;
>>>> +
>>>> +		if (p->match.type != V4L2_CHIP_MATCH_SUBDEV || p->match.addr)
>>>> +			return -EINVAL;
>>>> +		if (sd->ops->core && sd->ops->core->s_register)
>>>> +			p->flags |= V4L2_CHIP_FL_WRITABLE;
>>>> +		if (sd->ops->core && sd->ops->core->g_register)
>>>> +			p->flags |= V4L2_CHIP_FL_READABLE;
>>>> +		strlcpy(p->name, sd->name, sizeof(p->name));
>>>> +		return 0;
>>>> +	}
>>>
>>> This is effectively doing the same as debugfs except that it's specific to
>>> V4L2. I don't think we should endorse its use, and especially not without a
>>> real use case.
>>
>> We (Cisco) use it all the time. Furthermore, this works for any bus, not just
>> i2c. Also spi, internal register busses, etc.
>>
>> It's been in use for many years. More importantly, there is no excuse to have
>> only half the API implemented.
>>
>> It's all fine to talk about debugfs, but are you going to make that? This API
>> works, it's supported by v4l2-dbg, it's in use. Now, let's at least make it
>> pass v4l2-compliance.
>>
>> I agree, if we would redesign it, we would use debugfs. But I think it didn't
>> even exist when this was made. So this API is here to stay and all it takes
>> is this ioctl of code to add the missing piece for subdevs.
>>
>> Nobody is going to make a replacement for this using debugfs. Why spend effort
>> on it if we already have an API for this?
> 
> It's not the first case when a more generic API replaces a subsystem
> specific one. We have another conversion to make, switching from
> implementing s_power() callback in drivers to runtime PM for instance.
> 
> I simply want to point out that this patch is endorsing something which is
> obsolete and not needed: no-one has complained about the lack of this for
> sub-devices, haven't they?
> 
> I'd just remove the check from v4l-compliance or make it optional. New
> drivers should use debugfs instead if something like that is needed.
> 

You are correct in one respect: we use this API, but with video devices.
So subdevices support the g/s_register ops, and they are called via /dev/videoX.

We can remove the ioctl support from v4l2-subdev.c (not the g/s_register ops!).
Without VIDIOC_DBG_G_CHIP_INFO I don't think v4l2-dbg is usable. Although it
is always possible to call the ioctl directly, of course.

So if Mauro would agree to this, the DBG ioctl support in v4l2-subdev can be
removed.

But either remove them, or add this ioctl. Don't leave it in a zombie state.

Personally I see no harm whatsoever in just adding VIDIOC_DBG_G_CHIP_INFO.
If someone ever makes a patch to switch over to debugfs then these ioctls
can be removed.

BTW, how would new drivers use debugfs for this? Does regmap provide such
access?

Regards,

	Hans
