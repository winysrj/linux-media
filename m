Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:54038 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755559AbcCWPUQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2016 11:20:16 -0400
Subject: Re: [PATCH v5 1/2] media: Add obj_type field to struct media_entity
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1458722756-7269-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <56F2A2B5.80206@xs4all.nl> <20160323120059.030a7b61@recife.lan>
 <1938529.9P9zNWsNbc@avalon>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56F2B428.3070105@xs4all.nl>
Date: Wed, 23 Mar 2016 16:20:08 +0100
MIME-Version: 1.0
In-Reply-To: <1938529.9P9zNWsNbc@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/23/2016 04:11 PM, Laurent Pinchart wrote:
> Hi Mauro,
> 
> On Wednesday 23 Mar 2016 12:00:59 Mauro Carvalho Chehab wrote:
>> Em Wed, 23 Mar 2016 15:05:41 +0100 Hans Verkuil escreveu:
>>> On 03/23/2016 11:35 AM, Mauro Carvalho Chehab wrote:
>>>> Em Wed, 23 Mar 2016 10:45:55 +0200 Laurent Pinchart escreveu:
>>>>> Code that processes media entities can require knowledge of the
>>>>> structure type that embeds a particular media entity instance in order
>>>>> to cast the entity to the proper object type. This needs is shown by
>>>>> the presence of the is_media_entity_v4l2_io and
>>>>> is_media_entity_v4l2_subdev functions.
>>>>>
>>>>> The implementation of those two functions relies on the entity function
>>>>> field, which is both a wrong and an inefficient design, without even
>>>>> mentioning the maintenance issue involved in updating the functions
>>>>> every time a new entity function is added. Fix this by adding add an
>>>>> obj_type field to the media entity structure to carry the information.
>>>>>
>>>>> Signed-off-by: Laurent Pinchart
>>>>> <laurent.pinchart+renesas@ideasonboard.com>
>>>>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>>> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>>>> ---
>>>>>
>>>>>  drivers/media/media-device.c          |  2 +
>>>>>  drivers/media/v4l2-core/v4l2-dev.c    |  1 +
>>>>>  drivers/media/v4l2-core/v4l2-subdev.c |  1 +
>>>>>  include/media/media-entity.h          | 79 ++++++++++++++-------------
>>>>>  4 files changed, 46 insertions(+), 37 deletions(-)
>>>>>
>>>>> diff --git a/drivers/media/media-device.c
>>>>> b/drivers/media/media-device.c
>>>>> index 4a97d92a7e7d..88d8de3b7a4f 100644
>>>>> --- a/drivers/media/media-device.c
>>>>> +++ b/drivers/media/media-device.c
>>>>> @@ -580,6 +580,8 @@ int __must_check
>>>>> media_device_register_entity(struct media_device *mdev,> >> 
>>>>>  			 "Entity type for entity %s was not initialized!\n",
>>>>>  			 entity->name);
>>>>>
>>>>> +	WARN_ON(entity->obj_type == MEDIA_ENTITY_TYPE_INVALID);
>>>>> +
>>>>
>>>> This is not ok. There are valid cases where the entity is not embedded
>>>> on some other struct. That's the case of connectors/connections, for
>>>> example: a connector/connection entity doesn't need anything else but
>>>> struct media device.
>>>
>>> Once connectors are enabled, then we do need a MEDIA_ENTITY_TYPE_CONNECTOR
>>> or MEDIA_ENTITY_TYPE_STANDALONE or something along those lines.
>>>
>>>> Also, this is V4L2 specific. Neither ALSA nor DVB need to use
>>>> container_of(). Actually, this won't even work there, as the entity is
>>>> stored as a pointer, and not as an embedded data.
>>>
>>> Any other subsystem that *does* embed this can use obj_type. If it doesn't
>>> embed it in anything, then MEDIA_ENTITY_TYPE_STANDALONE should be used
>>> (or whatever name we give it). I agree that we need a type define for the
>>> case where it is not embedded.
>>>
>>>> So, if we're willing to do this, then it should, instead, create
>>>> something like:
>>>>
>>>> struct embedded_media_entity {
>>>>
>>>> 	struct media_entity entity;
>>>> 	enum media_entity_type obj_type;
>>>>
>>>> };
>>>
>>> It's not v4l2 specific. It is just that v4l2 is the only subsystem that
>>> requires this information at the moment. I see no reason at all to create
>>> such an ugly struct.
>>
>> At the minute we added a BUG_ON() there,
> 
> Note that it's a WARN_ON(), not a BUG_ON().
> 
>> it became mandatory that all struct media_entity to be embedded.
> 
> No, it becomes mandatory to initialize the field.

I think the _INVALID type should just be dropped. _BASE would be the default.

If the entity is embedded in a larger struct, then whoever creates that struct
will set the type correctly. That's not done in drivers anyway but in subsystem
core code, so I don't think you need an _INVALID type at all.

Regards,

	Hans
