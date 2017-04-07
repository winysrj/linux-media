Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:33350 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754294AbdDGJgj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Apr 2017 05:36:39 -0400
Subject: Re: [PATCH RFC 1/2] [media] v4l2: add V4L2_INPUT_TYPE_DEFAULT
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1490889738-30009-1-git-send-email-helen.koike@collabora.com>
 <edfc014d-3b5e-53f9-04f0-95ae4fd4017e@xs4all.nl>
 <20170331065714.228634d1@vento.lan>
Cc: Helen Koike <helen.koike@collabora.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media@vger.kernel.org, jgebben@codeaurora.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <57cfe4fe-94f6-6c0f-3a06-03569ace3739@xs4all.nl>
Date: Fri, 7 Apr 2017 11:36:33 +0200
MIME-Version: 1.0
In-Reply-To: <20170331065714.228634d1@vento.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/31/2017 11:57 AM, Mauro Carvalho Chehab wrote:
> Em Fri, 31 Mar 2017 10:29:04 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 30/03/17 18:02, Helen Koike wrote:
>>> Add V4L2_INPUT_TYPE_DEFAULT and helpers functions for input ioctls to be
>>> used when no inputs are available in the device
>>>
>>> Signed-off-by: Helen Koike <helen.koike@collabora.com>
>>> ---
>>>  drivers/media/v4l2-core/v4l2-ioctl.c | 27 +++++++++++++++++++++++++++
>>>  include/media/v4l2-ioctl.h           | 26 ++++++++++++++++++++++++++
>>>  include/uapi/linux/videodev2.h       |  1 +
>>>  3 files changed, 54 insertions(+)
>>>
>>> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
>>> index 0c3f238..ccaf04b 100644
>>> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
>>> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
>>> @@ -2573,6 +2573,33 @@ struct mutex *v4l2_ioctl_get_lock(struct video_device *vdev, unsigned cmd)
>>>  	return vdev->lock;
>>>  }
>>>  
>>> +int v4l2_ioctl_enum_input_default(struct file *file, void *priv,
>>> +				  struct v4l2_input *i)
>>> +{
>>> +	if (i->index > 0)
>>> +		return -EINVAL;
>>> +
>>> +	memset(i, 0, sizeof(*i));
>>> +	i->type = V4L2_INPUT_TYPE_DEFAULT;
>>> +	strlcpy(i->name, "Default", sizeof(i->name));
>>> +
>>> +	return 0;
>>> +}
>>> +EXPORT_SYMBOL(v4l2_ioctl_enum_input_default);
>>> +
>>> +int v4l2_ioctl_g_input_default(struct file *file, void *priv, unsigned int *i)
>>> +{
>>> +	*i = 0;
>>> +	return 0;
>>> +}
>>> +EXPORT_SYMBOL(v4l2_ioctl_g_input_default);
>>> +
>>> +int v4l2_ioctl_s_input_default(struct file *file, void *priv, unsigned int i)
>>> +{
>>> +	return i ? -EINVAL : 0;
>>> +}
>>> +EXPORT_SYMBOL(v4l2_ioctl_s_input_default);
>>> +
>>>  /* Common ioctl debug function. This function can be used by
>>>     external ioctl messages as well as internal V4L ioctl */
>>>  void v4l_printk_ioctl(const char *prefix, unsigned int cmd)
>>> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
>>> index 6cd94e5..accc470 100644
>>> --- a/include/media/v4l2-ioctl.h
>>> +++ b/include/media/v4l2-ioctl.h
>>> @@ -652,6 +652,32 @@ struct video_device;
>>>   */
>>>  struct mutex *v4l2_ioctl_get_lock(struct video_device *vdev, unsigned int cmd);
>>>  
>>> +
>>> +/**
>>> + * v4l2_ioctl_enum_input_default - v4l2 ioctl helper for VIDIOC_ENUM_INPUT ioctl
>>> + *
>>> + * Plug this function in vidioc_enum_input field of the struct v4l2_ioctl_ops to
>>> + * enumerate a single input as V4L2_INPUT_TYPE_DEFAULT
>>> + */
>>> +int v4l2_ioctl_enum_input_default(struct file *file, void *priv,
>>> +				  struct v4l2_input *i);
>>> +
>>> +/**
>>> + * v4l2_ioctl_g_input_default - v4l2 ioctl helper for VIDIOC_G_INPUT ioctl
>>> + *
>>> + * Plug this function in vidioc_g_input field of the struct v4l2_ioctl_ops
>>> + * when using v4l2_ioctl_enum_input_default
>>> + */
>>> +int v4l2_ioctl_g_input_default(struct file *file, void *priv, unsigned int *i);
>>> +
>>> +/**
>>> + * v4l2_ioctl_s_input_default - v4l2 ioctl helper for VIDIOC_S_INPUT ioctl
>>> + *
>>> + * Plug this function in vidioc_s_input field of the struct v4l2_ioctl_ops
>>> + * when using v4l2_ioctl_enum_input_default
>>> + */
>>> +int v4l2_ioctl_s_input_default(struct file *file, void *priv, unsigned int i);
>>> +
>>>  /* names for fancy debug output */
>>>  extern const char *v4l2_field_names[];
>>>  extern const char *v4l2_type_names[];
>>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>>> index 316be62..c10bbde 100644
>>> --- a/include/uapi/linux/videodev2.h
>>> +++ b/include/uapi/linux/videodev2.h
>>> @@ -1477,6 +1477,7 @@ struct v4l2_input {
>>>  };
>>>  
>>>  /*  Values for the 'type' field */
>>> +#define V4L2_INPUT_TYPE_DEFAULT		0  
>>
>> I don't think we should add a new type here.
> 
> I second that. Just replied the same thing on a comment from Sakari to
> patch 2/2.
> 
>> The whole point of this exercise is to
>> allow existing apps to work, and existing apps expect a TYPE_CAMERA.
>>
>> BTW, don't read to much in the term 'CAMERA': it's really a catch all for any video
>> stream, whether it is from a sensor, composite input, HDMI, etc.
>>
>> The description for V4L2_INPUT_TYPE_CAMERA in the spec is hopelessly out of date :-(
> 
> Yeah, we always used "CAMERA" to mean NOT_TUNER.
> 
>> Rather than creating a new type I would add a new V4L2_IN_CAP_MC capability that
>> indicates that this input is controlled via the media controller. That makes much
>> more sense and it wouldn't potentially break applications.
>>
>> Exactly the same can be done for outputs as well: add V4L2_OUT_CAP_MC and use
>> V4L2_OUTPUT_TYPE_ANALOG as the output type (again, a horrible outdated name and the
>> spec is again out of date).
> 
> I don't see any sense on distinguishing IN and OUT for MC. I mean: should
> we ever allow that any driver to have their inputs controlled via V4L2 API, 
> and their outputs controlled via MC (or vice-versa)? I don't think so.

It's historical: the V4L2_OUT_CAP_ defines are aliases of the V4L2_IN_CAP_ defines.

Regards,

	Hans

> 
> Either all device inputs/outputs are controlled via V4L2 or via MC. So,
> let's call it just V4L2_CAP_MC.
> 
>> Regarding the name: should we use the name stored in struct video_device instead?
>> That might be more descriptive.
> 
> Makes sense to me.
> 
>> Alternatively use something like "Media Controller Input".
> 
> Yeah, we could do that, if V4L2_CAP_MC. if not, we can use the name
> stored at video_device.
> 
>> More helpful (perhaps) than just "Default" or "Unknown".
>>
>> I'll make a patch to update the input/output type description in the spec.
> 
> Thanks!
> 
>>
>> Regards,
>>
>> 	Hans
>>
>>>  #define V4L2_INPUT_TYPE_TUNER		1
>>>  #define V4L2_INPUT_TYPE_CAMERA		2
>>>  #define V4L2_INPUT_TYPE_TOUCH		3
>>>   
>>
> 
> 
> 
> Thanks,
> Mauro
> 
