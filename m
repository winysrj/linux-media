Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54064 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbbHUBDC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2015 21:03:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v6 2/8] [media] media: add a common struct to be embed on media graph objects
Date: Fri, 21 Aug 2015 04:02:57 +0300
Message-ID: <1667127.681LBiMjnq@avalon>
In-Reply-To: <0622f35fe1287a61f7703ba3f99fd78e4f992806.1439981515.git.mchehab@osg.samsung.com>
References: <cover.1439981515.git.mchehab@osg.samsung.com> <0622f35fe1287a61f7703ba3f99fd78e4f992806.1439981515.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Wednesday 19 August 2015 08:01:49 Mauro Carvalho Chehab wrote:
> Due to the MC API proposed changes, we'll need to have an unique
> object ID for all graph objects, and have some shared fields
> that will be common on all media graph objects.
> 
> Right now, the only common object is the object ID, but other
> fields will be added later on.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index cb0ac4e0dfa5..4834172bf6f8 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -27,6 +27,38 @@
>  #include <media/media-device.h>
> 
>  /**
> + *  media_gobj_init - Initialize a graph object
> + *
> + * @mdev:	Pointer to the media_device that contains the object
> + * @type:	Type of the object
> + * @gobj:	Pointer to the object
> + *
> + * This routine initializes the embedded struct media_gobj inside a
> + * media graph object. It is called automatically if media_*_create()
> + * calls are used. However, if the object (entity, link, pad, interface)
> + * is embedded on some other object, this function should be called before
> + * registering the object at the media controller.

Allowing both dynamic allocation and embedding will create a more complex API 
with more opportunities for drivers to get it wrong. I'd like to try and 
standardize the expected behaviour.

> + */
> +void media_gobj_init(struct media_device *mdev,
> +			   enum media_gobj_type type,
> +			   struct media_gobj *gobj)
> +{
> +	/* For now, nothing to do */
> +}
> +
> +/**
> + *  media_gobj_remove - Stop using a graph object on a media device

Is this function supposed to be the counterpart of media_gobj_init ? If so it 
should be called media_gobj_cleanup instead.

> + *
> + * @graph_obj:	Pointer to the object

The parameter is called gobj. Could you compile the kerneldoc to ensure that 
such typos get caught ?

> + *
> + * This should be called at media_device_unregister_*() routines
> + */
> +void media_gobj_remove(struct media_gobj *gobj)
> +{
> +	/* For now, nothing to do */
> +}
> +
> +/**
>   * media_entity_init - Initialize a media entity
>   *
>   * @num_pads: Total number of sink and source pads.
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 0a66fc225559..c1cd4fba051d 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -28,6 +28,39 @@
>  #include <linux/list.h>
>  #include <linux/media.h>
> 
> +/* Enums used internally at the media controller to represent graphs */
> +
> +/**
> + * enum media_gobj_type - type of a graph element

Let's try to standardize the vocabulary, should it be called graph object or 
graph element ? In the first case let's document it as graph object. In the 
second case it would be more consistent to refer to it as enum 
media_gelem_type (and struct media_gelem below).

> + *
> + */
> +enum media_gobj_type {
> +	 /* FIXME: add the types here, as we embed media_gobj */
> +	MEDIA_GRAPH_NONE
> +};
> +
> +#define MEDIA_BITS_PER_TYPE		8
> +#define MEDIA_BITS_PER_LOCAL_ID		(32 - MEDIA_BITS_PER_TYPE)
> +#define MEDIA_LOCAL_ID_MASK		 GENMASK(MEDIA_BITS_PER_LOCAL_ID - 1, 0)
> +
> +/* Structs to represent the objects that belong to a media graph */
> +
> +/**
> + * struct media_gobj - Define a graph object.
> + *
> + * @id:		Non-zero object ID identifier. The ID should be unique
> + *		inside a media_device, as it is composed by
> + *		MEDIA_BITS_PER_TYPE to store the type plus
> + *		MEDIA_BITS_PER_LOCAL_ID	to store a per-type ID
> + *		(called as "local ID").

I'd very much prefer using a single ID range and adding a type field. Abusing 
bits of the ID field to store the type will just makes IDs impractical to use. 
Let's do it properly.

> + * All elements on the media graph should have this struct embedded

All elements (objects) or only the ones that need an ID ? Or maybe we'll 
define graph element (object) as an element (object) that has an ID, making 
some "elements" not elements.

> + */
> +struct media_gobj {
> +	u32			id;
> +};
> +
> +
>  struct media_pipeline {
>  };
> 
> @@ -118,6 +151,26 @@ static inline u32 media_entity_id(struct media_entity
> *entity) return entity->id;
>  }
> 
> +static inline enum media_gobj_type media_type(struct media_gobj *gobj)
> +{
> +	return gobj->id >> MEDIA_BITS_PER_LOCAL_ID;
> +}
> +
> +static inline u32 media_localid(struct media_gobj *gobj)
> +{
> +	return gobj->id & MEDIA_LOCAL_ID_MASK;
> +}
> +
> +static inline u32 media_gobj_gen_id(enum media_gobj_type type, u32
> local_id)
> +{
> +	u32 id;
> +
> +	id = type << MEDIA_BITS_PER_LOCAL_ID;
> +	id |= local_id & MEDIA_LOCAL_ID_MASK;
> +
> +	return id;
> +}
> +
>  #define MEDIA_ENTITY_ENUM_MAX_DEPTH	16
>  #define MEDIA_ENTITY_ENUM_MAX_ID	64
> 
> @@ -131,6 +184,14 @@ struct media_entity_graph {
>  	int top;
>  };
> 
> +#define gobj_to_entity(gobj) \
> +		container_of(gobj, struct media_entity, graph_obj)

For consistency reason would this be called media_gobj_to_entity ? I would 
also turn it into an inline function to ensure type checking.

> +
> +void media_gobj_init(struct media_device *mdev,
> +		    enum media_gobj_type type,
> +		    struct media_gobj *gobj);
> +void media_gobj_remove(struct media_gobj *gobj);
> +
>  int media_entity_init(struct media_entity *entity, u16 num_pads,
>  		struct media_pad *pads);
>  void media_entity_cleanup(struct media_entity *entity);

-- 
Regards,

Laurent Pinchart

