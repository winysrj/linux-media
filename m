Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:54077 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752739AbdCaJvH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 05:51:07 -0400
Subject: Re: [PATCH RFC 1/2] [media] v4l2: add V4L2_INPUT_TYPE_DEFAULT
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Helen Koike <helen.koike@collabora.com>
References: <1490889738-30009-1-git-send-email-helen.koike@collabora.com>
 <2926010.76lXoG2CJo@avalon>
 <34146d93-6651-69a2-0997-aa3ae91b4fd3@collabora.com>
 <1c25c87a-506a-d1b1-6d30-129128cd0205@collabora.com>
 <20170331064227.0ecc86e7@vento.lan>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media@vger.kernel.org, jgebben@codeaurora.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <76eff09e-a18d-ff80-9a20-01cfb389de50@xs4all.nl>
Date: Fri, 31 Mar 2017 11:51:03 +0200
MIME-Version: 1.0
In-Reply-To: <20170331064227.0ecc86e7@vento.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 31/03/17 11:42, Mauro Carvalho Chehab wrote:
> Em Fri, 31 Mar 2017 00:55:12 -0300
> Helen Koike <helen.koike@collabora.com> escreveu:
> 
>> On 2017-03-30 11:39 PM, Helen Koike wrote:
>>> Hi Laurent,
>>>
>>> Thanks for reviewing
>>>
>>> On 2017-03-30 04:56 PM, Laurent Pinchart wrote:  
>>>> Hi Helen,
>>>>
>>>> Thank you for the patch.
>>>>
>>>> On Thursday 30 Mar 2017 13:02:17 Helen Koike wrote:  
>>>>> Add V4L2_INPUT_TYPE_DEFAULT and helpers functions for input ioctls to be
>>>>> used when no inputs are available in the device
>>>>>
>>>>> Signed-off-by: Helen Koike <helen.koike@collabora.com>
>>>>> ---
>>>>>  drivers/media/v4l2-core/v4l2-ioctl.c | 27 +++++++++++++++++++++++++++
>>>>>  include/media/v4l2-ioctl.h           | 26 ++++++++++++++++++++++++++
>>>>>  include/uapi/linux/videodev2.h       |  1 +
>>>>>  3 files changed, 54 insertions(+)
>>>>>
>>>>> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
>>>>> b/drivers/media/v4l2-core/v4l2-ioctl.c index 0c3f238..ccaf04b 100644
>>>>> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
>>>>> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
>>>>> @@ -2573,6 +2573,33 @@ struct mutex *v4l2_ioctl_get_lock(struct
>>>>> video_device
>>>>> *vdev, unsigned cmd) return vdev->lock;
>>>>>  }
>>>>>
>>>>> +int v4l2_ioctl_enum_input_default(struct file *file, void *priv,
>>>>> +                  struct v4l2_input *i)
>>>>> +{
>>>>> +    if (i->index > 0)
>>>>> +        return -EINVAL;
>>>>> +
>>>>> +    memset(i, 0, sizeof(*i));
>>>>> +    i->type = V4L2_INPUT_TYPE_DEFAULT;
>>>>> +    strlcpy(i->name, "Default", sizeof(i->name));
>>>>> +
>>>>> +    return 0;
>>>>> +}
>>>>> +EXPORT_SYMBOL(v4l2_ioctl_enum_input_default);  
>>>>
>>>> V4L2 tends to use EXPORT_SYMBOL_GPL.  
>>>
>>> The whole v4l2-ioctl.c file is using EXPORT_SYMBOL instead of
>>> EXPORT_SYMBOL_GPL, should we change it all to EXPORT_SYMBOL_GPL then (in
>>> another patch) ?
>>>  
>>>>
>>>> What would you think about calling those default functions directly
>>>> from the
>>>> core when the input ioctl handlers are not set ? You wouldn't need to
>>>> modify
>>>> drivers.  
>>>
>>> Sure, I'll add them in ops inside __video_register_device when it
>>> validates the ioctls  
>>
>> I just realize I can not simply override struct v4l2_ioctl_ops as it is 
>> declared as a const inside strut video_device. I'll call those default 
>> functions only when the ioctls are handled to not modify vdev->ops.
> 
> You should not override it, anyway. What you should do, instead, is
> something like:
> 
> static int v4l_ginput(const struct v4l2_ioctl_ops *ops, ...)
> {
> 	if (ops->vidioc_ginput)
> 		return ops->vidioc_ginput(...);
> 
> 	/* default code */
> }
> 
> You should also make sure that the ioctls are alway valid, e. g. by
> calling SET_VALID_IOCTL()

Helen, FYI:

The input ioctls are compulsory for:

V4L2_CAP_VIDEO_CAPTURE
V4L2_CAP_VBI_CAPTURE
V4L2_CAP_VIDEO_CAPTURE_MPLANE
V4L2_CAP_SLICED_VBI_CAPTURE

The output ioctls are compulsory for:

V4L2_CAP_VIDEO_OUTPUT
V4L2_CAP_VBI_OUTPUT
V4L2_CAP_VIDEO_OUTPUT_MPLANE
V4L2_CAP_SLICED_VBI_OUTPUT

If none of these caps are set, then we shouldn't provide these stubs.

Regards,

	Hans

> 
> Thanks,
> Mauro
> 
