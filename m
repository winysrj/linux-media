Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:46910 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750925AbeBIMSY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Feb 2018 07:18:24 -0500
Subject: Re: [PATCHv2 06/15] v4l2-subdev: implement VIDIOC_DBG_G_CHIP_INFO
 ioctl
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20180208083655.32248-1-hverkuil@xs4all.nl>
 <20180208083655.32248-7-hverkuil@xs4all.nl>
 <20180209120136.heg43pxmrkssy5l7@valkosipuli.retiisi.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8c4212b7-2171-7fa9-72d3-4ae38912f663@xs4all.nl>
Date: Fri, 9 Feb 2018 13:18:18 +0100
MIME-Version: 1.0
In-Reply-To: <20180209120136.heg43pxmrkssy5l7@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/09/18 13:01, Sakari Ailus wrote:
> Hi Hans,
> 
> On Thu, Feb 08, 2018 at 09:36:46AM +0100, Hans Verkuil wrote:
>> The VIDIOC_DBG_G/S_REGISTER ioctls imply that VIDIOC_DBG_G_CHIP_INFO is also
>> present, since without that you cannot use v4l2-dbg.
>>
>> Just like the implementation in v4l2-ioctl.c this can be implemented in the
>> core and no drivers need to be modified.
>>
>> It also makes it possible for v4l2-compliance to properly test the
>> VIDIOC_DBG_G/S_REGISTER ioctls.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/v4l2-core/v4l2-subdev.c | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
>> index 6cabfa32d2ed..2a5b5a3fa7a3 100644
>> --- a/drivers/media/v4l2-core/v4l2-subdev.c
>> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
>> @@ -255,6 +255,19 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>>  			return -EPERM;
>>  		return v4l2_subdev_call(sd, core, s_register, p);
>>  	}
>> +	case VIDIOC_DBG_G_CHIP_INFO:
>> +	{
>> +		struct v4l2_dbg_chip_info *p = arg;
>> +
>> +		if (p->match.type != V4L2_CHIP_MATCH_SUBDEV || p->match.addr)
>> +			return -EINVAL;
>> +		if (sd->ops->core && sd->ops->core->s_register)
>> +			p->flags |= V4L2_CHIP_FL_WRITABLE;
>> +		if (sd->ops->core && sd->ops->core->g_register)
>> +			p->flags |= V4L2_CHIP_FL_READABLE;
>> +		strlcpy(p->name, sd->name, sizeof(p->name));
>> +		return 0;
>> +	}
> 
> This is effectively doing the same as debugfs except that it's specific to
> V4L2. I don't think we should endorse its use, and especially not without a
> real use case.

We (Cisco) use it all the time. Furthermore, this works for any bus, not just
i2c. Also spi, internal register busses, etc.

It's been in use for many years. More importantly, there is no excuse to have
only half the API implemented.

It's all fine to talk about debugfs, but are you going to make that? This API
works, it's supported by v4l2-dbg, it's in use. Now, let's at least make it
pass v4l2-compliance.

I agree, if we would redesign it, we would use debugfs. But I think it didn't
even exist when this was made. So this API is here to stay and all it takes
is this ioctl of code to add the missing piece for subdevs.

Nobody is going to make a replacement for this using debugfs. Why spend effort
on it if we already have an API for this?

Regards,

	Hans

> 
>>  #endif
>>  
>>  	case VIDIOC_LOG_STATUS: {
>> -- 
>> 2.15.1
>>
> 
