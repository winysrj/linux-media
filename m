Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:34761 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933852AbeFRKSs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 06:18:48 -0400
Subject: Re: [RFC 1/2] media: add helpers for memory-to-memory media
 controller
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel@collabora.com
References: <20180612104827.11565-1-ezequiel@collabora.com>
 <20180612104827.11565-2-ezequiel@collabora.com>
 <8f9244b1-b547-5e4c-cc89-793d8e9b427c@xs4all.nl>
 <7641c73146ce5d8db73912d7625c7830f9c08615.camel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <453cfc7a-47b4-10d2-3a98-9e92845073a9@xs4all.nl>
Date: Mon, 18 Jun 2018 12:18:43 +0200
MIME-Version: 1.0
In-Reply-To: <7641c73146ce5d8db73912d7625c7830f9c08615.camel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/15/2018 06:22 PM, Ezequiel Garcia wrote:
> Hi Hans,
> 
> Thanks for the review.
> 
> On Fri, 2018-06-15 at 11:24 +0200, Hans Verkuil wrote:
>> On 12/06/18 12:48, Ezequiel Garcia wrote:

<snip>

>>> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
>>> index 3aa3d58d1d58..ff6fbe8333e1 100644
>>> --- a/include/media/media-entity.h
>>> +++ b/include/media/media-entity.h
>>> @@ -206,6 +206,9 @@ struct media_entity_operations {
>>>   *	The entity is embedded in a struct video_device instance.
>>>   * @MEDIA_ENTITY_TYPE_V4L2_SUBDEV:
>>>   *	The entity is embedded in a struct v4l2_subdev instance.
>>> + * @MEDIA_ENTITY_TYPE_V4L2_MEM2MEM:
>>> + *	The entity is not embedded in any struct, but part of
>>> + *	a memory-to-memory topology.
>>
>> I see no need for this. An M2M device is of type VIDEO_DEVICE, no need to
>> change that.
>>
> 
> Well, the problem is that this type is used to cast the media_entity
> using container_of macro, by means of is_media_entity_v4l2_video_device
> and is_media_entity_v4l2_subdev.
> 
> So, by using one these types we'd be breaking that assumption. 

Good point. But in that case I would just use MEDIA_ENTITY_TYPE_V4L2_BASE.
That's fine here.

> 
>>>   *
>>>   * Media entity objects are often not instantiated directly, but the media
>>>   * entity structure is inherited by (through embedding) other subsystem-specific
>>> @@ -222,6 +225,7 @@ enum media_entity_type {
>>>  	MEDIA_ENTITY_TYPE_BASE,
>>>  	MEDIA_ENTITY_TYPE_VIDEO_DEVICE,
>>>  	MEDIA_ENTITY_TYPE_V4L2_SUBDEV,
>>> +	MEDIA_ENTITY_TYPE_MEM2MEM,
>>>  };
>>>  
>>>  /**
>>> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
>>> index 456ac13eca1d..a9df949bb9c3 100644
>>> --- a/include/media/v4l2-dev.h
>>> +++ b/include/media/v4l2-dev.h
>>> @@ -30,6 +30,7 @@
>>>   * @VFL_TYPE_SUBDEV:	for V4L2 subdevices
>>>   * @VFL_TYPE_SDR:	for Software Defined Radio tuners
>>>   * @VFL_TYPE_TOUCH:	for touch sensors
>>> + * @VFL_TYPE_MEM2MEM:	for mem2mem devices
>>>   * @VFL_TYPE_MAX:	number of VFL types, must always be last in the enum
>>>   */
>>>  enum vfl_devnode_type {
>>> @@ -39,6 +40,7 @@ enum vfl_devnode_type {
>>>  	VFL_TYPE_SUBDEV,
>>>  	VFL_TYPE_SDR,
>>>  	VFL_TYPE_TOUCH,
>>> +	VFL_TYPE_MEM2MEM,
>>>  	VFL_TYPE_MAX /* Shall be the last one */
>>>  };
>>>  
>>> diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
>>> index 3d07ba3a8262..9dfe9bd23f89 100644
>>> --- a/include/media/v4l2-mem2mem.h
>>> +++ b/include/media/v4l2-mem2mem.h
>>> @@ -53,6 +53,7 @@ struct v4l2_m2m_ops {
>>>  	void (*unlock)(void *priv);
>>>  };
>>>  
>>> +struct video_device;
>>>  struct v4l2_m2m_dev;
>>>  
>>>  /**
>>> @@ -328,6 +329,10 @@ int v4l2_m2m_mmap(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
>>>   */
>>>  struct v4l2_m2m_dev *v4l2_m2m_init(const struct v4l2_m2m_ops *m2m_ops);
>>>  
>>> +int v4l2_m2m_register_media_controller(struct v4l2_m2m_dev *m2m_dev, struct video_device *vdev);
>>> +
>>> +void v4l2_m2m_unregister_media_controller(struct v4l2_m2m_dev *m2m_dev);
>>> +
>>>  /**
>>>   * v4l2_m2m_release() - cleans up and frees a m2m_dev structure
>>>   *
>>> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
>>> index c7e9a5cba24e..becb7db77f6a 100644
>>> --- a/include/uapi/linux/media.h
>>> +++ b/include/uapi/linux/media.h
>>> @@ -81,6 +81,7 @@ struct media_device_info {
>>>  #define MEDIA_ENT_F_IO_DTV			(MEDIA_ENT_F_BASE + 0x01001)
>>>  #define MEDIA_ENT_F_IO_VBI			(MEDIA_ENT_F_BASE + 0x01002)
>>>  #define MEDIA_ENT_F_IO_SWRADIO			(MEDIA_ENT_F_BASE + 0x01003)
>>> +#define MEDIA_ENT_F_IO_DMAENGINE		(MEDIA_ENT_F_BASE + 0x01004)
>>
>> Drop this as well. Just stick to MEDIA_ENT_F_IO_V4L which is what we've decided to
>> call such entities (for better or worse).
>>
> 
> Will do.
> 
>>>  
>>>  /*
>>>   * Sensor functions
>>> @@ -132,6 +133,7 @@ struct media_device_info {
>>>  #define MEDIA_ENT_F_PROC_VIDEO_LUT		(MEDIA_ENT_F_BASE + 0x4004)
>>>  #define MEDIA_ENT_F_PROC_VIDEO_SCALER		(MEDIA_ENT_F_BASE + 0x4005)
>>>  #define MEDIA_ENT_F_PROC_VIDEO_STATISTICS	(MEDIA_ENT_F_BASE + 0x4006)
>>> +#define MEDIA_ENT_F_PROC_VIDEO_TRANSFORM	(MEDIA_ENT_F_BASE + 0x4007)
>>
>> I think we need to be a bit more specific here:
>>
>> #define MEDIA_ENT_F_PROC_VIDEO_DECODER
>> #define MEDIA_ENT_F_PROC_VIDEO_ENCODER
>> #define MEDIA_ENT_F_PROC_VIDEO_DEINTERLACER
>> // others?
>>
> 
> OK. And what about "composite" devices that can encode and perform
> other transforms, e.g. scale, rotation, etc. 

The intention is to eventually allow for more than one function to be specified
for an entity. That should be done through 'properties', but that still hasn't
been implemented. For now we use 'function' to specify the primary function of
the device.

Regards,

	Hans
