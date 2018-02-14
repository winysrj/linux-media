Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:56182 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1032526AbeBNQrI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 11:47:08 -0500
Subject: Re: [PATCHv2 1/9] v4l2-common: create v4l2_g/s_parm_cap helpers
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180122123125.24709-1-hverkuil@xs4all.nl>
 <20180122123125.24709-2-hverkuil@xs4all.nl>
 <20180214135018.356ee06d@vento.lan>
 <dc7bebaa-48e8-1cbc-7a87-c3f35deebda9@xs4all.nl>
 <20180214143531.3643cc4e@vento.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9e430611-c504-4033-9b82-b298f2566ff1@xs4all.nl>
Date: Wed, 14 Feb 2018 17:47:07 +0100
MIME-Version: 1.0
In-Reply-To: <20180214143531.3643cc4e@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14/02/18 17:35, Mauro Carvalho Chehab wrote:
> Em Wed, 14 Feb 2018 17:23:51 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 14/02/18 16:50, Mauro Carvalho Chehab wrote:
>>> Em Mon, 22 Jan 2018 13:31:17 +0100
>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>   
>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>
>>>> Create helpers to handle VIDIOC_G/S_PARM by querying the
>>>> g/s_frame_interval v4l2_subdev ops.
>>>>
>>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>> ---
>>>>  drivers/media/v4l2-core/v4l2-common.c | 48 +++++++++++++++++++++++++++++++++++
>>>>  include/media/v4l2-common.h           | 26 +++++++++++++++++++
>>>>  2 files changed, 74 insertions(+)
>>>>
>>>> diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
>>>> index 8650ad92b64d..96c1b31de9e3 100644
>>>> --- a/drivers/media/v4l2-core/v4l2-common.c
>>>> +++ b/drivers/media/v4l2-core/v4l2-common.c
>>>> @@ -392,3 +392,51 @@ void v4l2_get_timestamp(struct timeval *tv)
>>>>  	tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
>>>>  }
>>>>  EXPORT_SYMBOL_GPL(v4l2_get_timestamp);
>>>> +
>>>> +int v4l2_g_parm_cap(struct video_device *vdev,
>>>> +		    struct v4l2_subdev *sd, struct v4l2_streamparm *a)
>>>> +{
>>>> +	struct v4l2_subdev_frame_interval ival = { 0 };
>>>> +	int ret;
>>>> +
>>>> +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
>>>> +	    a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
>>>> +		return -EINVAL;
>>>> +
>>>> +	if (vdev->device_caps & V4L2_CAP_READWRITE)
>>>> +		a->parm.capture.readbuffers = 2;  
>>>
>>> Hmm... why don't you also initialize readbuffers otherwise?  
>>
>> It's specifically for read(). If read() is not supported, then this
>> is meaningless and should just stay 0. v4l2-compliance checks for this.
> 
> Well, API states that:
> 
> "When an application requests zero buffers, drivers should just return the current setting rather than the minimum or an error code."
> 
> So, something should zero it, if not used and type is capture or
> capture_mplane.

All fields after the type field are zeroed by the core in v4l2-ioctl.c:

        IOCTL_INFO_FNC(VIDIOC_G_PARM, v4l_g_parm, v4l_print_streamparm, INFO_FL_CLEAR(v4l2_streamparm, type)),

> 
>> The 'readbuffers' field is completely outdated and once this is in
>> the next step is to see if we can come up with something better. I hate
>> G/S_PARM.
> 
> Yes, it is a weird ioctl, but I'm not yet convinced that we should
> increase API complexity by adding newer ioctls due to that.
> 
> Instead, I would just get rid of .g_parm/.s_parm callbacks, implementing
> a better kAPI, without bothering adding more complexity to uAPI.

I will probably do that as a second step anyway. We can discuss the pros and
cons of adding a new ioctl after that. I rather like the VIDIOC_SUBDEV_G/S_FRAME_INTERVAL
ioctls. Simple and to the point. It's really what you would expect as an
end-user.

Regards,

	Hans
