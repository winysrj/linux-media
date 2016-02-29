Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:55075 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754014AbcB2M1B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 07:27:01 -0500
Subject: Re: [PATCH 5/5] media-entity.h: rename _io to _video_device and add
 real _io
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1456746345-1431-1-git-send-email-hverkuil@xs4all.nl>
 <1456746345-1431-6-git-send-email-hverkuil@xs4all.nl>
 <1896521.YBlpbiMzc0@avalon>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56D43910.8080107@xs4all.nl>
Date: Mon, 29 Feb 2016 13:26:56 +0100
MIME-Version: 1.0
In-Reply-To: <1896521.YBlpbiMzc0@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/29/2016 01:23 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Monday 29 February 2016 12:45:45 Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> The is_media_entity_v4l2_io() function should be renamed to
>> is_media_entity_v4l2_video_device.
>>
>> Add a is_media_entity_v4l2_io to v4l2-common.h (since this is V4L2 specific)
>> that checks if the entity is a video_device AND if it does I/O.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  include/media/media-entity.h |  4 ++--
>>  include/media/v4l2-common.h  | 28 ++++++++++++++++++++++++++++
>>  2 files changed, 30 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
>> index cbd3753..e5108f0 100644
>> --- a/include/media/media-entity.h
>> +++ b/include/media/media-entity.h
>> @@ -356,14 +356,14 @@ static inline u32 media_gobj_gen_id(enum
>> media_gobj_type type, u64 local_id) }
>>
>>  /**
>> - * is_media_entity_v4l2_io() - Check if the entity is a video_device
>> + * is_media_entity_v4l2_video_device() - Check if the entity is a
>> video_device * @entity:	pointer to entity
>>   *
>>   * Return: true if the entity is an instance of a video_device object and
>> can * safely be cast to a struct video_device using the container_of()
>> macro, or * false otherwise.
>>   */
>> -static inline bool is_media_entity_v4l2_io(struct media_entity *entity)
>> +static inline bool is_media_entity_v4l2_video_device(struct media_entity
>> *entity) {
> 
> While at it, do you think this function should be moved to include/media/v4l2-
> common.h ?

I don't think so. It might be useful for other subsystems to ignore v4l2
entities, and they can use this function for that.

> 
>>  	return entity && entity->type == MEDIA_ENTITY_TYPE_VIDEO_DEVICE;
>>  }
>> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
>> index 1cc0c5b..858b165 100644
>> --- a/include/media/v4l2-common.h
>> +++ b/include/media/v4l2-common.h
>> @@ -189,4 +189,32 @@ const struct v4l2_frmsize_discrete
>> *v4l2_find_nearest_format(
>>
>>  void v4l2_get_timestamp(struct timeval *tv);
>>
>> +#ifdef CONFIG_MEDIA_CONTROLLER
>> +/**
>> + * is_media_entity_v4l2_io() - Check if the entity is a video_device and
>> can do I/O
>> + * @entity:	pointer to entity
>> + *
>> + * Return: true if the entity is an instance of a video_device object and
>> can
>> + * safely be cast to a struct video_device using the container_of() macro
>> and
>> + * can do I/O, or false otherwise.
>> + */
>> +static inline bool is_media_entity_v4l2_io(struct media_entity *entity)
> 
> Does this really qualify for an inline function ?

No, I was too lazy to move it to v4l2-common.c :-)

Regards,

	Hans

> 
>> +{
>> +	struct video_device *vdev;
>> +
>> +	if (!is_media_entity_v4l2_video_device(entity))
>> +		return false;
>> +	vdev = container_of(entity, struct video_device, entity);
>> +	/*
>> +	 * For now assume that is device_caps == 0, then I/O is available
>> +	 * unless it is a radio device.
>> +	 * Eventually all drivers should set vdev->device_caps and then
>> +	 * this assumption should be removed.
>> +	 */
>> +	if (vdev->device_caps == 0)
>> +		return vdev->vfl_type != VFL_TYPE_RADIO;
>> +	return vdev->device_caps & (V4L2_CAP_READWRITE | V4L2_CAP_STREAMING);
>> +}
>> +#endif
>> +
>>  #endif /* V4L2_COMMON_H_ */
> 

