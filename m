Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:56130 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752046AbcCCNcO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 08:32:14 -0500
Subject: Re: [PATCH 3/8] media: Add type field to struct media_entity
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org
References: <1456844246-18778-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1456844246-18778-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56D83CE0.70407@xs4all.nl>
Date: Thu, 3 Mar 2016 14:32:16 +0100
MIME-Version: 1.0
In-Reply-To: <1456844246-18778-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/01/16 15:57, Laurent Pinchart wrote:
> Code that processes media entities can require knowledge of the
> structure type that embeds a particular media entity instance in order
> to cast the entity to the proper object type. This needs is shown by the
> presence of the is_media_entity_v4l2_io and is_media_entity_v4l2_subdev
> functions.
> 
> The implementation of those two functions relies on the entity function
> field, which is both a wrong and an inefficient design, without even
> mentioning the maintenance issue involved in updating the functions
> every time a new entity function is added. Fix this by adding add a type
> field to the media entity structure to carry the information.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  drivers/media/v4l2-core/v4l2-dev.c    |  1 +
>  drivers/media/v4l2-core/v4l2-subdev.c |  1 +
>  include/media/media-entity.h          | 75 ++++++++++++++++++-----------------
>  3 files changed, 40 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index d8e5994cccf1..7e766a92e3d9 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -735,6 +735,7 @@ static int video_register_media_controller(struct video_device *vdev, int type)
>  	if (!vdev->v4l2_dev->mdev)
>  		return 0;
>  
> +	vdev->entity.type = MEDIA_ENTITY_TYPE_VIDEO_DEVICE;
>  	vdev->entity.function = MEDIA_ENT_F_UNKNOWN;
>  
>  	switch (type) {
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index d63083803144..bb6e79f14bb8 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -584,6 +584,7 @@ void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
>  	sd->host_priv = NULL;
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  	sd->entity.name = sd->name;
> +	sd->entity.type = MEDIA_ENTITY_TYPE_V4L2_SUBDEV;
>  	sd->entity.function = MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN;
>  #endif
>  }
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index d58e29d3f239..cbd37530f6b8 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -187,10 +187,37 @@ struct media_entity_operations {
>  };
>  
>  /**
> + * enum media_entity_type - Media entity type
> + *
> + * @MEDIA_ENTITY_TYPE_MEDIA_ENTITY:
> + *	The entity is a struct media_entity instance.
> + * @MEDIA_ENTITY_TYPE_VIDEO_DEVICE:
> + *	The entity is a struct video_device instance.
> + * @MEDIA_ENTITY_TYPE_V4L2_SUBDEV:
> + *	The entity is a struct v4l2_subdev instance.
> + *
> + * The entity type identifies the type of the object instance that implements
> + * the struct media_entity instance. This allows runtime type identification of
> + * media entities and safe casting to the project object type. For instance, a
> + * media entity structure instance embedded in a v4l2_subdev structure instance
> + * will have the type MEDIA_ENTITY_TYPE_V4L2_SUBDEV and can safely be cast to a
> + * v4l2_subdev structure using the container_of() macro.
> + *
> + * Media entities can be instantiated without creating any derived object type,
> + * in which case their type will be MEDIA_ENTITY_TYPE_MEDIA_ENTITY.
> + */
> +enum media_entity_type {
> +	MEDIA_ENTITY_TYPE_MEDIA_ENTITY,
> +	MEDIA_ENTITY_TYPE_VIDEO_DEVICE,
> +	MEDIA_ENTITY_TYPE_V4L2_SUBDEV,
> +};
> +
> +/**
>   * struct media_entity - A media entity graph object.
>   *
>   * @graph_obj:	Embedded structure containing the media object common data.
>   * @name:	Entity name.
> + * @type:	Type of the object that implements the media_entity.
>   * @function:	Entity main function, as defined in uapi/media.h
>   *		(MEDIA_ENT_F_*)
>   * @flags:	Entity flags, as defined in uapi/media.h (MEDIA_ENT_FL_*)
> @@ -219,6 +246,7 @@ struct media_entity_operations {
>  struct media_entity {
>  	struct media_gobj graph_obj;	/* must be first field in struct */
>  	const char *name;
> +	enum media_entity_type type;
>  	u32 function;
>  	unsigned long flags;
>  
> @@ -328,56 +356,29 @@ static inline u32 media_gobj_gen_id(enum media_gobj_type type, u64 local_id)
>  }
>  
>  /**
> - * is_media_entity_v4l2_io() - identify if the entity main function
> - *			       is a V4L2 I/O
> - *
> + * is_media_entity_v4l2_io() - Check if the entity is a video_device
>   * @entity:	pointer to entity
>   *
> - * Return: true if the entity main function is one of the V4L2 I/O types
> - *	(video, VBI or SDR radio); false otherwise.
> + * Return: true if the entity is an instance of a video_device object and can
> + * safely be cast to a struct video_device using the container_of() macro, or
> + * false otherwise.
>   */
>  static inline bool is_media_entity_v4l2_io(struct media_entity *entity)
>  {
> -	if (!entity)
> -		return false;
> -
> -	switch (entity->function) {
> -	case MEDIA_ENT_F_IO_V4L:
> -	case MEDIA_ENT_F_IO_VBI:
> -	case MEDIA_ENT_F_IO_SWRADIO:
> -		return true;
> -	default:
> -		return false;
> -	}
> +	return entity && entity->type == MEDIA_ENTITY_TYPE_VIDEO_DEVICE;
>  }
>  
>  /**
> - * is_media_entity_v4l2_subdev - return true if the entity main function is
> - *				 associated with the V4L2 API subdev usage
> - *
> + * is_media_entity_v4l2_subdev() - Check if the entity is a v4l2_subdev
>   * @entity:	pointer to entity
>   *
> - * This is an ancillary function used by subdev-based V4L2 drivers.
> - * It checks if the entity function is one of functions used by a V4L2 subdev,
> - * e. g. camera-relatef functions, analog TV decoder, TV tuner, V4L2 DSPs.
> + * Return: true if the entity is an instance of a v4l2_subdev object and can
> + * safely be cast to a struct v4l2_subdev using the container_of() macro, or
> + * false otherwise.
>   */
>  static inline bool is_media_entity_v4l2_subdev(struct media_entity *entity)
>  {
> -	if (!entity)
> -		return false;
> -
> -	switch (entity->function) {
> -	case MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN:
> -	case MEDIA_ENT_F_CAM_SENSOR:
> -	case MEDIA_ENT_F_FLASH:
> -	case MEDIA_ENT_F_LENS:
> -	case MEDIA_ENT_F_ATV_DECODER:
> -	case MEDIA_ENT_F_TUNER:
> -		return true;
> -
> -	default:
> -		return false;
> -	}
> +	return entity && entity->type == MEDIA_ENTITY_TYPE_V4L2_SUBDEV;
>  }
>  
>  /**
> 
