Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:50162 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965448AbcCJHBy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2016 02:01:54 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v4 3/4] media: Add type field to struct media_entity
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
References: <1457122731-22558-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1457122731-22558-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <20160305095525.4983526f@recife.lan>
Message-ID: <56E11BDE.8020905@linux.intel.com>
Date: Thu, 10 Mar 2016 09:01:50 +0200
MIME-Version: 1.0
In-Reply-To: <20160305095525.4983526f@recife.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro and Laurent,

Mauro Carvalho Chehab wrote:
> Em Fri,  4 Mar 2016 22:18:50 +0200
> Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com> escreveu:
>
>> Code that processes media entities can require knowledge of the
>> structure type that embeds a particular media entity instance in order
>> to cast the entity to the proper object type. This needs is shown by the
>> presence of the is_media_entity_v4l2_io and is_media_entity_v4l2_subdev
>> functions.
>>
>> The implementation of those two functions relies on the entity function
>> field, which is both a wrong and an inefficient design,
>
> I agree with Sakari here: it is not wrong, just risky when new types
> are added.
>
> Btw, I still don't like using "type" here. People that didn't read
> all those boring MC discussions will be confused, as we're removing
> "type" in one version, and re-introducing it again with a very
> different meaning.
>
> What we're really doing here is to "flag" when the entity is a subdev
> or when the entity is a V4L I/O entity. Also, one thing that bothers me
> is that this is very subsystem-specific. See more below.

What the field is really telling is what kind of object embeds the
media_entity struct. How about using another name for the field, to
distinguish it from the previous type field? object_type, for instance.

>
>> without even
>> mentioning the maintenance issue involved in updating the functions
>> every time a new entity function is added. Fix this by adding add a type
>> field to the media entity structure to carry the information.
>>
>> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>   drivers/media/v4l2-core/v4l2-dev.c    |  1 +
>>   drivers/media/v4l2-core/v4l2-subdev.c |  1 +
>>   include/media/media-entity.h          | 75 ++++++++++++++++++-----------------
>>   3 files changed, 40 insertions(+), 37 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
>> index d8e5994cccf1..7e766a92e3d9 100644
>> --- a/drivers/media/v4l2-core/v4l2-dev.c
>> +++ b/drivers/media/v4l2-core/v4l2-dev.c
>> @@ -735,6 +735,7 @@ static int video_register_media_controller(struct video_device *vdev, int type)
>>   	if (!vdev->v4l2_dev->mdev)
>>   		return 0;
>>
>> +	vdev->entity.type = MEDIA_ENTITY_TYPE_VIDEO_DEVICE;
>>   	vdev->entity.function = MEDIA_ENT_F_UNKNOWN;
>>
>>   	switch (type) {
>> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
>> index d63083803144..bb6e79f14bb8 100644
>> --- a/drivers/media/v4l2-core/v4l2-subdev.c
>> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
>> @@ -584,6 +584,7 @@ void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
>>   	sd->host_priv = NULL;
>>   #if defined(CONFIG_MEDIA_CONTROLLER)
>>   	sd->entity.name = sd->name;
>> +	sd->entity.type = MEDIA_ENTITY_TYPE_V4L2_SUBDEV;
>>   	sd->entity.function = MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN;
>>   #endif
>>   }
>> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
>> index 6dc9e4e8cbd4..d148fc49c3be 100644
>> --- a/include/media/media-entity.h
>> +++ b/include/media/media-entity.h
>> @@ -188,10 +188,37 @@ struct media_entity_operations {
>>   };
>>
>>   /**
>> + * enum media_entity_type - Media entity type
>> + *
>> + * @MEDIA_ENTITY_TYPE_MEDIA_ENTITY:
>> + *	The entity is a struct media_entity instance.
>
> All entities are a media_entity instance. This doesn't make sense!

Can a media_entity exist without being something else as well? Would
that even make sense?

Should this be either invalid, or the documentation to be changed that
the media_entity is not embedded in any other object?
media_device_register_entity() should check the value.

>
>> + * @MEDIA_ENTITY_TYPE_VIDEO_DEVICE:
>> + *	The entity is a struct video_device instance.
>> + * @MEDIA_ENTITY_TYPE_V4L2_SUBDEV:
>> + *	The entity is a struct v4l2_subdev instance.
>> + *
>> + * The entity type identifies the type of the object instance that implements
>> + * the struct media_entity instance. This allows runtime type identification of
>> + * media entities and safe casting to the project object type. For instance, a
>> + * media entity structure instance embedded in a v4l2_subdev structure instance
>> + * will have the type MEDIA_ENTITY_TYPE_V4L2_SUBDEV and can safely be cast to a
>> + * v4l2_subdev structure using the container_of() macro.
>> + *
>> + * Media entities can be instantiated without creating any derived object type,
>> + * in which case their type will be MEDIA_ENTITY_TYPE_MEDIA_ENTITY.
>> + */
>> +enum media_entity_type {
>> +	MEDIA_ENTITY_TYPE_MEDIA_ENTITY,
>> +	MEDIA_ENTITY_TYPE_VIDEO_DEVICE,
>> +	MEDIA_ENTITY_TYPE_V4L2_SUBDEV,
>> +};
>> +
>> +/**
>>    * struct media_entity - A media entity graph object.
>>    *
>>    * @graph_obj:	Embedded structure containing the media object common data.
>>    * @name:	Entity name.
>> + * @type:	Type of the object that implements the media_entity.
>>    * @function:	Entity main function, as defined in uapi/media.h
>>    *		(MEDIA_ENT_F_*)
>>    * @flags:	Entity flags, as defined in uapi/media.h (MEDIA_ENT_FL_*)
>> @@ -220,6 +247,7 @@ struct media_entity_operations {
>>   struct media_entity {
>>   	struct media_gobj graph_obj;	/* must be first field in struct */
>>   	const char *name;
>> +	enum media_entity_type type;
>>   	u32 function;
>>   	unsigned long flags;
>>
>> @@ -329,56 +357,29 @@ static inline u32 media_gobj_gen_id(enum media_gobj_type type, u64 local_id)
>>   }
>>
>>   /**
>> - * is_media_entity_v4l2_io() - identify if the entity main function
>> - *			       is a V4L2 I/O
>> - *
>> + * is_media_entity_v4l2_io() - Check if the entity is a video_device
>>    * @entity:	pointer to entity
>>    *
>> - * Return: true if the entity main function is one of the V4L2 I/O types
>> - *	(video, VBI or SDR radio); false otherwise.
>> + * Return: true if the entity is an instance of a video_device object and can
>> + * safely be cast to a struct video_device using the container_of() macro, or
>> + * false otherwise.
>>    */
>>   static inline bool is_media_entity_v4l2_io(struct media_entity *entity)
>>   {
>> -	if (!entity)
>> -		return false;
>> -
>> -	switch (entity->function) {
>> -	case MEDIA_ENT_F_IO_V4L:
>> -	case MEDIA_ENT_F_IO_VBI:
>> -	case MEDIA_ENT_F_IO_SWRADIO:
>> -		return true;
>> -	default:
>> -		return false;
>> -	}
>> +	return entity && entity->type == MEDIA_ENTITY_TYPE_VIDEO_DEVICE;
>>   }
>>
>>   /**
>> - * is_media_entity_v4l2_subdev - return true if the entity main function is
>> - *				 associated with the V4L2 API subdev usage
>> - *
>> + * is_media_entity_v4l2_subdev() - Check if the entity is a v4l2_subdev
>>    * @entity:	pointer to entity
>>    *
>> - * This is an ancillary function used by subdev-based V4L2 drivers.
>> - * It checks if the entity function is one of functions used by a V4L2 subdev,
>> - * e. g. camera-relatef functions, analog TV decoder, TV tuner, V4L2 DSPs.
>> + * Return: true if the entity is an instance of a v4l2_subdev object and can
>> + * safely be cast to a struct v4l2_subdev using the container_of() macro, or
>> + * false otherwise.
>>    */
>>   static inline bool is_media_entity_v4l2_subdev(struct media_entity *entity)
>>   {
>> -	if (!entity)
>> -		return false;
>> -
>> -	switch (entity->function) {
>> -	case MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN:
>> -	case MEDIA_ENT_F_CAM_SENSOR:
>> -	case MEDIA_ENT_F_FLASH:
>> -	case MEDIA_ENT_F_LENS:
>> -	case MEDIA_ENT_F_ATV_DECODER:
>> -	case MEDIA_ENT_F_TUNER:
>> -		return true;
>> -
>> -	default:
>> -		return false;
>> -	}
>> +	return entity && entity->type == MEDIA_ENTITY_TYPE_V4L2_SUBDEV;
>>   }
>>
>>   /**
>
> When I wrote the ENUM_ENTITIES compat code and deciding what would
> be the best approach, it occurred to me that, for us to be able to
> remove major,minor from entity, the best way would be to "taint"
> the entities that have a 1:1 map with an interface, like:

I think this is a separate problem. It should be solved as well, but not
necessarily in this patchset and certainly not in this patch. The
purpose of this patch, as far as I understand, is to ensure correct use
of container_of() macro in order to obtain the object where the media
entity is embedded in. A lot of drivers (and the V4L2 sub-device
framework) depend on that currently.

>
> 	- I/O nodes;
> 	- subdevs (when CONFIG_VIDEO_V4L2_SUBDEV_API=y);
> 	- ALSA mixer.
>
> So, I was actually thinking that, instead of entity-type, we should
> an internal flag to mark those internal "caps" attributes.
>
> So, I guess we should really call this as entity->taint, entity->quirk
> or entity->internal_flag or entity->caps instead. For now, I'll call
> it "caps".
>
> by adding "caps", this field can be a way more flexible, and may
> be used for the needs on other subsystems too.
>
> By implementing it as a "caps" flag, the part of the code at
> media_device_enum_entities() on a patch dropping major and
> minor from struct media_entity would be like:
>
> 	if (ent->caps & ENTITY_HAS_DEVNODE) {
> 		media_device_for_each_link(link, mdev) {
> 			if (link->sink == ent) {
> 				struct media_intf_devnode *devnode;
>
> 	                        devnode = intf_to_devnode(intf);
>
> 				u_ent.dev.major = devnode->major;
> 				u_ent.dev.minor = devnode->minor;
> 			}
> 		}
> 	}
>
>
> This will also remove the need of touching at
> video_register_media_controller(), with seems pretty much useless
> so far. Just v4l2_subdev_init() will set "caps" to:
> 	ENTITY_IS_V4L2_SUBDEV
>
> Regards,
> Mauro
>
> PS.: patches 1 and 2 of this series are OK. I applied them
> already.
>


-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
