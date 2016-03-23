Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:40034 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751610AbcCWOFs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2016 10:05:48 -0400
Subject: Re: [PATCH v5 1/2] media: Add obj_type field to struct media_entity
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
References: <1458722756-7269-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1458722756-7269-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <20160323073552.18db3b7e@recife.lan>
Cc: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56F2A2B5.80206@xs4all.nl>
Date: Wed, 23 Mar 2016 15:05:41 +0100
MIME-Version: 1.0
In-Reply-To: <20160323073552.18db3b7e@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/23/2016 11:35 AM, Mauro Carvalho Chehab wrote:
> Em Wed, 23 Mar 2016 10:45:55 +0200
> Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com> escreveu:
> 
>> Code that processes media entities can require knowledge of the
>> structure type that embeds a particular media entity instance in order
>> to cast the entity to the proper object type. This needs is shown by the
>> presence of the is_media_entity_v4l2_io and is_media_entity_v4l2_subdev
>> functions.
>>
>> The implementation of those two functions relies on the entity function
>> field, which is both a wrong and an inefficient design, without even
>> mentioning the maintenance issue involved in updating the functions
>> every time a new entity function is added. Fix this by adding add an
>> obj_type field to the media entity structure to carry the information.
>>
>> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>>  drivers/media/media-device.c          |  2 +
>>  drivers/media/v4l2-core/v4l2-dev.c    |  1 +
>>  drivers/media/v4l2-core/v4l2-subdev.c |  1 +
>>  include/media/media-entity.h          | 79 +++++++++++++++++++----------------
>>  4 files changed, 46 insertions(+), 37 deletions(-)
>>
>> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
>> index 4a97d92a7e7d..88d8de3b7a4f 100644
>> --- a/drivers/media/media-device.c
>> +++ b/drivers/media/media-device.c
>> @@ -580,6 +580,8 @@ int __must_check media_device_register_entity(struct media_device *mdev,
>>  			 "Entity type for entity %s was not initialized!\n",
>>  			 entity->name);
>>  
>> +	WARN_ON(entity->obj_type == MEDIA_ENTITY_TYPE_INVALID);
>> +
> 
> This is not ok. There are valid cases where the entity is not embedded
> on some other struct. That's the case of connectors/connections, for
> example: a connector/connection entity doesn't need anything else but
> struct media device.

Once connectors are enabled, then we do need a MEDIA_ENTITY_TYPE_CONNECTOR or
MEDIA_ENTITY_TYPE_STANDALONE or something along those lines.

> Also, this is V4L2 specific. Neither ALSA nor DVB need to use container_of().
> Actually, this won't even work there, as the entity is stored as a pointer,
> and not as an embedded data.

Any other subsystem that *does* embed this can use obj_type. If it doesn't embed
it in anything, then MEDIA_ENTITY_TYPE_STANDALONE should be used (or whatever
name we give it). I agree that we need a type define for the case where it is
not embedded.

> 
> So, if we're willing to do this, then it should, instead, create
> something like:
> 
> struct embedded_media_entity {
> 	struct media_entity entity;
> 	enum media_entity_type obj_type;
> };

It's not v4l2 specific. It is just that v4l2 is the only subsystem that requires
this information at the moment. I see no reason at all to create such an ugly
struct.

I very strongly suspect that other subsystems will also embed this in their own
internal structs. I actually wonder why it isn't embedded in struct dvb_device,
but I have to admit that I didn't take a close look at that. The pads are embedded
there, so it is somewhat odd that the entity isn't.

Regards,

	Hans

> 
> And then replace the occurrences of embedded media_entity by
> embedded_media_entity at the V4L2 subsystem only, in the places where
> the struct is embeded on another one.
> 
>>  	/* Warn if we apparently re-register an entity */
>>  	WARN_ON(entity->graph_obj.mdev != NULL);
>>  	entity->graph_obj.mdev = mdev;
>> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
>> index d8e5994cccf1..70b559d7ca80 100644
>> --- a/drivers/media/v4l2-core/v4l2-dev.c
>> +++ b/drivers/media/v4l2-core/v4l2-dev.c
>> @@ -735,6 +735,7 @@ static int video_register_media_controller(struct video_device *vdev, int type)
>>  	if (!vdev->v4l2_dev->mdev)
>>  		return 0;
>>  
>> +	vdev->entity.obj_type = MEDIA_ENTITY_TYPE_VIDEO_DEVICE;
>>  	vdev->entity.function = MEDIA_ENT_F_UNKNOWN;
>>  
>>  	switch (type) {
>> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
>> index d63083803144..0fa60801a428 100644
>> --- a/drivers/media/v4l2-core/v4l2-subdev.c
>> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
>> @@ -584,6 +584,7 @@ void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
>>  	sd->host_priv = NULL;
>>  #if defined(CONFIG_MEDIA_CONTROLLER)
>>  	sd->entity.name = sd->name;
>> +	sd->entity.obj_type = MEDIA_ENTITY_TYPE_V4L2_SUBDEV;
>>  	sd->entity.function = MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN;
>>  #endif
>>  }
>> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
>> index 6dc9e4e8cbd4..5cea57955a3a 100644
>> --- a/include/media/media-entity.h
>> +++ b/include/media/media-entity.h
>> @@ -188,10 +188,41 @@ struct media_entity_operations {
>>  };
>>  
>>  /**
>> + * enum media_entity_type - Media entity type
>> + *
>> + * @MEDIA_ENTITY_TYPE_INVALID:
>> + *	Invalid type, used to catch uninitialized fields.
>> + * @MEDIA_ENTITY_TYPE_VIDEO_DEVICE:
>> + *	The entity is embedded in a struct video_device instance.
>> + * @MEDIA_ENTITY_TYPE_V4L2_SUBDEV:
>> + *	The entity is embedded in a struct v4l2_subdev instance.
>> + *
>> + * Media entity objects are not instantiated directly, 
> 
> As I said before, this is not true (nor even at V4L2 subsystem, due to
> the connectors/connections).
> 
> As before, you should call this as:
> 	enum embedded_media_entity_type
> 
> And then change the test to:
> 
> 	"Media entity objects declared via struct embedded_media_device are not
> 	 instantiated directly,"
> 
> and fix the text below accordingly.
> 
>> but the media entity
>> + * structure is inherited by (through embedding) other subsystem-specific
>> + * structures. The media entity type identifies the type of the subclass
>> + * structure that implements a media entity instance.
>> + *
>> + * This allows runtime type identification of media entities and safe casting to
>> + * the correct object type. For instance, a media entity structure instance
>> + * embedded in a v4l2_subdev structure instance will have the type
>> + * MEDIA_ENTITY_TYPE_V4L2_SUBDEV and can safely be cast to a v4l2_subdev
>> + * structure using the container_of() macro.
>> + *
>> + * The MEDIA_ENTITY_TYPE_INVALID type should never be set as an entity type, it
>> + * only serves to catch uninitialized fields when registering entities.
>> + */
>> +enum media_entity_type {
>> +	MEDIA_ENTITY_TYPE_INVALID,
>> +	MEDIA_ENTITY_TYPE_VIDEO_DEVICE,
>> +	MEDIA_ENTITY_TYPE_V4L2_SUBDEV,
>> +};
>> +
>> +/**
>>   * struct media_entity - A media entity graph object.
>>   *
>>   * @graph_obj:	Embedded structure containing the media object common data.
>>   * @name:	Entity name.
>> + * @obj_type:	Type of the object that implements the media_entity.
>>   * @function:	Entity main function, as defined in uapi/media.h
>>   *		(MEDIA_ENT_F_*)
>>   * @flags:	Entity flags, as defined in uapi/media.h (MEDIA_ENT_FL_*)
>> @@ -220,6 +251,7 @@ struct media_entity_operations {
>>  struct media_entity {
>>  	struct media_gobj graph_obj;	/* must be first field in struct */
>>  	const char *name;
>> +	enum media_entity_type obj_type;
> 
> See above. This doesn't below to the generic media entity struct,
> but to an special type that is meant to be embedded on some places.
> 
>>  	u32 function;
>>  	unsigned long flags;
>>  
>> @@ -329,56 +361,29 @@ static inline u32 media_gobj_gen_id(enum media_gobj_type type, u64 local_id)
>>  }
>>  
>>  /**
>> - * is_media_entity_v4l2_io() - identify if the entity main function
>> - *			       is a V4L2 I/O
>> - *
>> + * is_media_entity_v4l2_io() - Check if the entity is a video_device
>>   * @entity:	pointer to entity
>>   *
>> - * Return: true if the entity main function is one of the V4L2 I/O types
>> - *	(video, VBI or SDR radio); false otherwise.
>> + * Return: true if the entity is an instance of a video_device object and can
>> + * safely be cast to a struct video_device using the container_of() macro, or
>> + * false otherwise.
>>   */
>>  static inline bool is_media_entity_v4l2_io(struct media_entity *entity)
>>  {
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
>> +	return entity && entity->obj_type == MEDIA_ENTITY_TYPE_VIDEO_DEVICE;
>>  }
>>  
>>  /**
>> - * is_media_entity_v4l2_subdev - return true if the entity main function is
>> - *				 associated with the V4L2 API subdev usage
>> - *
>> + * is_media_entity_v4l2_subdev() - Check if the entity is a v4l2_subdev
>>   * @entity:	pointer to entity
>>   *
>> - * This is an ancillary function used by subdev-based V4L2 drivers.
>> - * It checks if the entity function is one of functions used by a V4L2 subdev,
>> - * e. g. camera-relatef functions, analog TV decoder, TV tuner, V4L2 DSPs.
>> + * Return: true if the entity is an instance of a v4l2_subdev object and can
>> + * safely be cast to a struct v4l2_subdev using the container_of() macro, or
>> + * false otherwise.
>>   */
>>  static inline bool is_media_entity_v4l2_subdev(struct media_entity *entity)
>>  {
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
>> +	return entity && entity->obj_type == MEDIA_ENTITY_TYPE_V4L2_SUBDEV;
>>  }
>>  
>>  /**
> 
> 

