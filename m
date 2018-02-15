Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:48442 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967918AbeBOL4q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Feb 2018 06:56:46 -0500
Subject: Re: [PATCH v2] videodev2.h: add helper to validate colorspace
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20180214103643.8245-1-niklas.soderlund+renesas@ragnatech.se>
 <3434065.V6QgqqWRc5@avalon> <ecea7e97-de20-6d11-3ad4-680bab4628f0@xs4all.nl>
 <2053928.E9OymEAqzL@avalon>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0f0adb80-7af7-9fd4-319f-faa6b45ef1a4@xs4all.nl>
Date: Thu, 15 Feb 2018 12:56:44 +0100
MIME-Version: 1.0
In-Reply-To: <2053928.E9OymEAqzL@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15/02/18 12:08, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Thursday, 15 February 2018 12:57:44 EET Hans Verkuil wrote:
>> On 14/02/18 16:16, Laurent Pinchart wrote:
>>> On Wednesday, 14 February 2018 12:36:43 EET Niklas Söderlund wrote:
>>>> There is no way for drivers to validate a colorspace value, which could
>>>> be provided by user-space by VIDIOC_S_FMT for example. Add a helper to
>>>> validate that the colorspace value is part of enum v4l2_colorspace.
>>>>
>>>> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
>>>> ---
>>>>
>>>>  include/uapi/linux/videodev2.h | 4 ++++
>>>>  1 file changed, 4 insertions(+)
>>>>
>>>> Hi,
>>>>
>>>> I hope this is the correct header to add this helper to. I think it's
>>>> since if it's in uapi not only can v4l2 drivers use it but tools like
>>>> v4l-compliance gets access to it and can be updated to use this instead
>>>> of the hard-coded check of just < 0xff as it was last time I checked.
>>>>
>>>> * Changes since v1
>>>> - Cast colorspace to u32 as suggested by Sakari and only check the upper
>>>>
>>>>   boundary to address a potential issue brought up by Laurent if the
>>>>   
>>>>   data type tested is u32 which is not uncommon:
>>>>     enum.c:30:16: warning: comparison of unsigned expression >= 0 is
>>>>     always
>>>>
>>>> true [-Wtype-limits]
>>>>
>>>>       return V4L2_COLORSPACE_IS_VALID(colorspace);
>>>>
>>>> diff --git a/include/uapi/linux/videodev2.h
>>>> b/include/uapi/linux/videodev2.h index
>>>> 9827189651801e12..1f27c0f4187cbded 100644
>>>> --- a/include/uapi/linux/videodev2.h
>>>> +++ b/include/uapi/linux/videodev2.h
>>>> @@ -238,6 +238,10 @@ enum v4l2_colorspace {
>>>>
>>>>  	V4L2_COLORSPACE_DCI_P3        = 12,
>>>>  
>>>>  };
>>>>
>>>> +/* Determine if a colorspace is defined in enum v4l2_colorspace */
>>>> +#define V4L2_COLORSPACE_IS_VALID(colorspace)		\
>>>> +	((u32)(colorspace) <= V4L2_COLORSPACE_DCI_P3)
>>
>> Sorry, this won't work. Use __u32. u32 is only available in the kernel, not
>> in userspace and this is a public header.
> 
> Indeed, that I should have caught.
> 
>> I am not convinced about the usefulness of this check either. Drivers will
>> typically only support a subset of the available colorspaces, so they need
>> a switch to test for that.
> 
> Most MC drivers won't, as they don't care about colorspaces in most subdevs. 
> It's important for the colorspace to be propagated within subdevs, and 
> validated across the pipeline, but in most case, apart from the image source 
> subdev, other subdevs won't care. They should accept any valid colorspace 
> given to them and propagate it to their source pads unchanged (except of 
> course for subdevs that can change the colorspace, but that's the exception, 
> not the rule).

Right. So 'passthrough' subdevs should just copy this information from source
to sink, and only pure source or pure sink subdevs should validate these
fields. That makes sense.

> 
>> There is nothing wrong with userspace giving them an unknown colorspace:
>> either they will map anything they don't support to something that they DO
>> support, or they will return -EINVAL.
> 
> The former, not the latter. S_FMT should not return -EINVAL for unsupported 
> colorspace, the same way it doesn't return -EINVAL for unsupported pixel 
> formats.
> 
>> If memory serves the spec requires the first option, so anything unknown
>> will just be replaced.
>>
>> And anyway, this raises the question of why you do this for the colorspace
>> but not for all the other enums in the V4L2 API.
> 
> Because v4l2-compliance tries to set a colorspace > 0xff and expects that to 
> be replaced by a colorspace <= 0xff. That seems like a bogus check to me, 0xff 
> is as random as it can get.

v4l2-compliance fills all fields with 0xff, then it checks after calling the
ioctl if all fields have been set to valid values.

But in this case it should ignore the colorspace-related fields for passthrough
subdevs. The only passthrough devices that should set colorspace are colorspace
converter devices. I'm not sure if we can reliably detect that.

> 
>> It all seems rather pointless to me.
>>
>> I won't accept this unless I see it being used in a driver in a useful way.
>>
>> So for now:
>>
>> Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Can you then fix v4l2-compliance to stop testing colorspace against 0xff ?

For now I can simply relax this test for subdevs with sources and sinks.

Regards,

	Hans

> 
>>>> +
>>>
>>> Casting to u32 has the added benefit that the colorspace expression is
>>> evaluated once only, I like that.
>>>
>>> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>
>>>>  /*
>>>>   * Determine how COLORSPACE_DEFAULT should map to a proper colorspace.
>>>>   * This depends on whether this is a SDTV image (use SMPTE 170M), an
> 
