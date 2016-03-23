Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:49980 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755427AbcCWO5S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2016 10:57:18 -0400
Subject: Re: [PATCH v5 1/2] media: Add obj_type field to struct media_entity
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1458722756-7269-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <20160323073552.18db3b7e@recife.lan> <56F2A2B5.80206@xs4all.nl>
 <3511467.97gkNM9KCE@avalon>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56F2AEC6.4030209@xs4all.nl>
Date: Wed, 23 Mar 2016 15:57:10 +0100
MIME-Version: 1.0
In-Reply-To: <3511467.97gkNM9KCE@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/23/2016 03:45 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Wednesday 23 Mar 2016 15:05:41 Hans Verkuil wrote:
>> On 03/23/2016 11:35 AM, Mauro Carvalho Chehab wrote:
>>> Em Wed, 23 Mar 2016 10:45:55 +0200 Laurent Pinchart escreveu:
>>>> Code that processes media entities can require knowledge of the
>>>> structure type that embeds a particular media entity instance in order
>>>> to cast the entity to the proper object type. This needs is shown by the
>>>> presence of the is_media_entity_v4l2_io and is_media_entity_v4l2_subdev
>>>> functions.
>>>>
>>>> The implementation of those two functions relies on the entity function
>>>> field, which is both a wrong and an inefficient design, without even
>>>> mentioning the maintenance issue involved in updating the functions
>>>> every time a new entity function is added. Fix this by adding add an
>>>> obj_type field to the media entity structure to carry the information.
>>>>
>>>> Signed-off-by: Laurent Pinchart
>>>> <laurent.pinchart+renesas@ideasonboard.com>
>>>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>>> ---
>>>>
>>>>  drivers/media/media-device.c          |  2 +
>>>>  drivers/media/v4l2-core/v4l2-dev.c    |  1 +
>>>>  drivers/media/v4l2-core/v4l2-subdev.c |  1 +
>>>>  include/media/media-entity.h          | 79 ++++++++++++++++-------------
>>>>  4 files changed, 46 insertions(+), 37 deletions(-)
>>>>
>>>> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
>>>> index 4a97d92a7e7d..88d8de3b7a4f 100644
>>>> --- a/drivers/media/media-device.c
>>>> +++ b/drivers/media/media-device.c
>>>> @@ -580,6 +580,8 @@ int __must_check media_device_register_entity(struct
>>>> media_device *mdev,
>>>>  			 "Entity type for entity %s was not initialized!\n",
>>>>  			 entity->name);
>>>>
>>>> +	WARN_ON(entity->obj_type == MEDIA_ENTITY_TYPE_INVALID);
>>>> +
>>>
>>> This is not ok. There are valid cases where the entity is not embedded
>>> on some other struct. That's the case of connectors/connections, for
>>> example: a connector/connection entity doesn't need anything else but
>>> struct media device.
>>
>> Once connectors are enabled, then we do need a MEDIA_ENTITY_TYPE_CONNECTOR
>> or MEDIA_ENTITY_TYPE_STANDALONE or something along those lines.
> 
> MEDIA_ENTITY_TYPE_CONNECTOR would make sense, but only if we add a struct 
> media_connector. I believe that can be a good idea, at least to simplify 
> management of the entity and the connector pad(s).
> 
>>> Also, this is V4L2 specific. Neither ALSA nor DVB need to use
>>> container_of(). Actually, this won't even work there, as the entity is
>>> stored as a pointer, and not as an embedded data.
> 
> That's sounds like a strange design decision at the very least. There can be 
> valid cases that require creation of bare entities, but I don't think they 
> should be that common.
> 
>> Any other subsystem that *does* embed this can use obj_type. If it doesn't
>> embed it in anything, then MEDIA_ENTITY_TYPE_STANDALONE should be used (or
>> whatever name we give it). I agree that we need a type define for the case
>> where it is not embedded.
> 
> I'd like to point out that I had defined MEDIA_ENTITY_TYPE_MEDIA_ENTITY for 
> that purpose in v4, and was requested to drop it.

I think MEDIA_ENTITY_TYPE_MEDIA_ENTITY is very ugly. Hm, some alternatives:

MEDIA_ENTITY_TYPE_NONE
MEDIA_ENTITY_TYPE_ME
MEDIA_ENTITY_TYPE_SINGLETON
MEDIA_ENTITY_TYPE_BASE

I personally prefer the last since it is just the media_entity base class by
itself.

Regards,

	Hans

