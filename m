Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36874 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbcBVJqH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 04:46:07 -0500
Date: Mon, 22 Feb 2016 06:46:01 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] media: Add type field to struct media_entity
Message-ID: <20160222064601.6fc22c30@recife.lan>
In-Reply-To: <1456105996-20845-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1456105996-20845-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 22 Feb 2016 03:53:16 +0200
Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com> escreveu:

> Code that processes media entities can require knowledge of the
> structure type that embeds a particular media entity instance in order
> to use the API provided by that structure. This needs is shown by the
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
> ---
>  drivers/media/v4l2-core/v4l2-dev.c    |  1 +
>  drivers/media/v4l2-core/v4l2-subdev.c |  1 +
>  include/media/media-entity.h          | 65 +++++++++++++++--------------------
>  3 files changed, 30 insertions(+), 37 deletions(-)
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
> index fe485d367985..2be38483f3a4 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -187,10 +187,27 @@ struct media_entity_operations {
>  };
>  
>  /**
> + * enum MEDIA_ENTITY_TYPE_NONE - Media entity type
> + *

s/MEDIA_ENTITY_TYPE_NONE/media_entity_type/

(it seems you didn't test producing the docbook, otherwise you would
have seen this error - Please always generate the docbook when the
patch contains kernel-doc markups)

I don't like the idea of calling it as "type", as this is confusing,
specially since we used to call entity.type for what we now call function.

What we're actually wanting to represent is the Linux kABI group where
the entity belongs. So, maybe we could call it as
media_entity_kabi_type, instead.

> + * @MEDIA_ENTITY_TYPE_NONE:
> + *	The entity isn't embedded in a standard structure.

I also don't like having a NONE here. All objects belong to some
kABI type, but not all subsystems need to use this field
(so far, DVB doesn't need nor ALSA).

So, I would either call it as DEFAULT or UNDEFINED.

> + * @MEDIA_ENTITY_TYPE_VIDEO_DEVICE:
> + *	The media entity is embedded in a struct video_device.
> + * @MEDIA_ENTITY_TYPE_V4L2_SUBDEV:
> + *	The media entity is embedded in a struct v4l2_subdev.
> + */
> +enum media_entity_type {
> +	MEDIA_ENTITY_TYPE_NONE,
> +	MEDIA_ENTITY_TYPE_VIDEO_DEVICE,
> +	MEDIA_ENTITY_TYPE_V4L2_SUBDEV,
> +};

> +
> +/**
>   * struct media_entity - A media entity graph object.
>   *
>   * @graph_obj:	Embedded structure containing the media object common data.
>   * @name:	Entity name.
> + * @type:	Type of the object that embeds the media_entity instance.
>   * @function:	Entity main function, as defined in uapi/media.h
>   *		(MEDIA_ENT_F_*)
>   * @flags:	Entity flags, as defined in uapi/media.h (MEDIA_ENT_FL_*)
> @@ -219,6 +236,7 @@ struct media_entity_operations {
>  struct media_entity {
>  	struct media_gobj graph_obj;	/* must be first field in struct */
>  	const char *name;
> +	enum media_entity_type type;

Same as before: I would call it as kabi_type.

>  	u32 function;
>  	unsigned long flags;
>  
> @@ -328,56 +346,29 @@ static inline u32 media_gobj_gen_id(enum media_gobj_type type, u64 local_id)
>  }
>  
>  /**
> - * is_media_entity_v4l2_io() - identify if the entity main function
> - *			       is a V4L2 I/O
> - *
> + * is_media_entity_v4l2_io() - Check if the entity implements the video_device
> + *			       API
>   * @entity:	pointer to entity
>   *
> - * Return: true if the entity main function is one of the V4L2 I/O types
> - *	(video, VBI or SDR radio); false otherwise.
> + * Return: true if the entity implement the video_device API (is directly
> + * embedded in a struct video_device instance) or false otherwise.

s/implement/implements/

Yet, I don't think the above comment is ok. First of all, video_device is
a kABI. We're nowadays calling the kernel APIs as kABI, and the userspace
ones as uAPI.

Also, it doesn't make clear that it would be used also for radio, and 
it is repeating the same thing twice.

So, I would either keep the original comment or change it to:

"Return: true if the entity implements the video_device kABI for video,
 VBI or SDR radio (e. g. if the entity is embeddded at a struct
 video_device instance) or false otherwise."


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
> + * is_media_entity_v4l2_subdev() - Check if the entity implements the
> + *				   v4l2_subdev API
>   * @entity:	pointer to entity
>   *
> - * This is an ancillary function used by subdev-based V4L2 drivers.
> - * It checks if the entity function is one of functions used by a V4L2 subdev,
> - * e. g. camera-relatef functions, analog TV decoder, TV tuner, V4L2 DSPs.
> + * Return: true if the entity implement the v4l2_subdev API (is directly
> + * embedded in a struct v4l2_subdev instance) or false otherwise.
>   */

s/API/kABI/

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


-- 
Thanks,
Mauro
