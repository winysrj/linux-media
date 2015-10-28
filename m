Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53453 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755029AbbJ1CJf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2015 22:09:35 -0400
Date: Wed, 28 Oct 2015 11:09:31 +0900
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	javier@osg.samsung.com, hverkuil@xs4all.nl,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH 03/19] media: Add an API to manage entity enumerations
Message-ID: <20151028110931.2e7e8a89@concha.lan>
In-Reply-To: <1445900510-1398-4-git-send-email-sakari.ailus@iki.fi>
References: <1445900510-1398-1-git-send-email-sakari.ailus@iki.fi>
	<1445900510-1398-4-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 27 Oct 2015 01:01:34 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> From: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> This is useful in e.g. knowing whether certain operations have already
> been performed for an entity. The users include the framework itself (for
> graph walking) and a number of drivers.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/media-entity.c |  39 +++++++++++++
>  include/media/media-device.h |  14 +++++
>  include/media/media-entity.h | 128 ++++++++++++++++++++++++++++++++++++++++---
>  3 files changed, 173 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index d11f440..fceaf44 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -213,6 +213,45 @@ void media_gobj_remove(struct media_gobj *gobj)
>  }
>  
>  /**
> + * __media_entity_enum_init - Initialise an entity enumeration
> + *
> + * @e: Entity enumeration to be initialised
> + * @idx_max: Maximum number of entities in the enumeration
> + *
> + * Returns zero on success or a negative error code.
> + */
> +int __media_entity_enum_init(struct media_entity_enum *e, int idx_max)
> +{
> +	if (idx_max > MEDIA_ENTITY_ENUM_MAX_ID) {
> +		e->e = kcalloc(DIV_ROUND_UP(idx_max, BITS_PER_LONG),
> +			       sizeof(long), GFP_KERNEL);

That looks wrong to me when the graph size increases. 

If e->e is not null, you need first to free the previously allocated
map before allocing a new one.

> +		if (!e->e)
> +			return -ENOMEM;
> +	} else {
> +		e->e = e->__e;
> +	}
> +
> +	bitmap_zero(e->e, idx_max);
> +	e->idx_max = idx_max;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(__media_entity_enum_init);
> +
> +/**
> + * media_entity_enum_cleanup - Release resources of an entity enumeration
> + *
> + * @e: Entity enumeration to be released
> + */
> +void media_entity_enum_cleanup(struct media_entity_enum *e)
> +{
> +	if (e->e != e->__e)
> +		kfree(e->e);
> +	e->e = NULL;
> +}
> +EXPORT_SYMBOL_GPL(media_entity_enum_cleanup);
> +
> +/**
>   * media_entity_init - Initialize a media entity
>   *
>   * @num_pads: Total number of sink and source pads.
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index c0e1764..2d46c66 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -110,6 +110,20 @@ struct media_device {
>  /* media_devnode to media_device */
>  #define to_media_device(node) container_of(node, struct media_device, devnode)
>  
> +/**
> + * media_entity_enum_init - Initialise an entity enumeration
> + *
> + * @e: Entity enumeration to be initialised
> + * @mdev: The related media device
> + *
> + * Returns zero on success or a negative error code.
> + */
> +static inline __must_check int media_entity_enum_init(
> +	struct media_entity_enum *e, struct media_device *mdev)
> +{
> +	return __media_entity_enum_init(e, mdev->entity_internal_idx_max + 1);
> +}
> +
>  void media_device_init(struct media_device *mdev);
>  void media_device_cleanup(struct media_device *mdev);
>  int __must_check __media_device_register(struct media_device *mdev,
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index d3d3a39..fc54192 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -23,7 +23,7 @@
>  #ifndef _MEDIA_ENTITY_H
>  #define _MEDIA_ENTITY_H
>  
> -#include <linux/bitops.h>
> +#include <linux/bitmap.h>
>  #include <linux/kernel.h>
>  #include <linux/list.h>
>  #include <linux/media.h>
> @@ -71,6 +71,22 @@ struct media_gobj {
>  	struct list_head	list;
>  };
>  
> +#define MEDIA_ENTITY_ENUM_MAX_DEPTH	16
> +#define MEDIA_ENTITY_ENUM_MAX_ID	64
> +
> +/*
> + * The number of pads can't be bigger than the number of entities,
> + * as the worse-case scenario is to have one entity linked up to
> + * MEDIA_ENTITY_ENUM_MAX_ID - 1 entities.
> + */
> +#define MEDIA_ENTITY_MAX_PADS		(MEDIA_ENTITY_ENUM_MAX_ID - 1)
> +
> +struct media_entity_enum {
> +	DECLARE_BITMAP(__e, MEDIA_ENTITY_ENUM_MAX_ID);

I don't think it makes sense to keep MEDIA_ENTITY_ENUM_MAX_ID. 
Instead, let's just dynamically allocate the bitmap.

> +	unsigned long *e;

Btw, "__e" and "e" are very bad names. Please use a better name
here.

> +	int idx_max;
> +};
> +
>  struct media_pipeline {
>  };
>  
> @@ -307,15 +323,111 @@ static inline bool is_media_entity_v4l2_subdev(struct media_entity *entity)
>  	}
>  }
>  
> -#define MEDIA_ENTITY_ENUM_MAX_DEPTH	16
> -#define MEDIA_ENTITY_ENUM_MAX_ID	64
> +int __media_entity_enum_init(struct media_entity_enum *e, int idx_max);
> +void media_entity_enum_cleanup(struct media_entity_enum *e);
>  
> -/*
> - * The number of pads can't be bigger than the number of entities,
> - * as the worse-case scenario is to have one entity linked up to
> - * MEDIA_ENTITY_ENUM_MAX_ID - 1 entities.
> +/**
> + * media_entity_enum_zero - Clear the entire enum
> + *
> + * @e: Entity enumeration to be cleared
>   */
> -#define MEDIA_ENTITY_MAX_PADS		(MEDIA_ENTITY_ENUM_MAX_ID - 1)
> +static inline void media_entity_enum_zero(struct media_entity_enum *e)
> +{
> +	bitmap_zero(e->e, e->idx_max);
> +}
> +
> +/**
> + * media_entity_enum_set - Mark a single entity in the enum
> + *
> + * @e: Entity enumeration
> + * @entity: Entity to be marked
> + */
> +static inline void media_entity_enum_set(struct media_entity_enum *e,
> +					 struct media_entity *entity)
> +{
> +	if (WARN_ON(entity->internal_idx >= e->idx_max))
> +		return;
> +
> +	__set_bit(entity->internal_idx, e->e);
> +}
> +
> +/**
> + * media_entity_enum_clear - Unmark a single entity in the enum
> + *
> + * @e: Entity enumeration
> + * @entity: Entity to be unmarked
> + */
> +static inline void media_entity_enum_clear(struct media_entity_enum *e,
> +					   struct media_entity *entity)
> +{
> +	if (WARN_ON(entity->internal_idx >= e->idx_max))
> +		return;
> +
> +	__clear_bit(entity->internal_idx, e->e);
> +}
> +
> +/**
> + * media_entity_enum_test - Test whether the entity is marked
> + *
> + * @e: Entity enumeration
> + * @entity: Entity to be tested
> + *
> + * Returns true if the entity was marked.
> + */
> +static inline bool media_entity_enum_test(struct media_entity_enum *e,
> +					  struct media_entity *entity)
> +{
> +	if (WARN_ON(entity->internal_idx >= e->idx_max))
> +		return true;
> +
> +	return test_bit(entity->internal_idx, e->e);
> +}
> +
> +/**
> + * media_entity_enum_test - Test whether the entity is marked, and mark it
> + *
> + * @e: Entity enumeration
> + * @entity: Entity to be tested
> + *
> + * Returns true if the entity was marked, and mark it before doing so.
> + */
> +static inline bool media_entity_enum_test_and_set(struct media_entity_enum *e,
> +						  struct media_entity *entity)
> +{
> +	if (WARN_ON(entity->internal_idx >= e->idx_max))
> +		return true;
> +
> +	return __test_and_set_bit(entity->internal_idx, e->e);
> +}
> +
> +/**
> + * media_entity_enum_test - Test whether the entire enum is empty
> + *
> + * @e: Entity enumeration
> + * @entity: Entity to be tested
> + *
> + * Returns true if the entity was marked.
> + */
> +static inline bool media_entity_enum_empty(struct media_entity_enum *e)
> +{
> +	return bitmap_empty(e->e, e->idx_max);
> +}
> +
> +/**
> + * media_entity_enum_intersects - Test whether two enums intersect
> + *
> + * @e: First entity enumeration
> + * @f: Second entity enumeration
> + *
> + * Returns true if entity enumerations e and f intersect, otherwise false.
> + */
> +static inline bool media_entity_enum_intersects(struct media_entity_enum *e,
> +						struct media_entity_enum *f)
> +{
> +	WARN_ON(e->idx_max != f->idx_max);

I'm not sure about a WARN_ON() here. The routine will do the right thing,
due to the min() function below:

> +
> +	return bitmap_intersects(e->e, f->e, min(e->idx_max, f->idx_max));

So, the routine will be doing its job.

If having a different size is a problem for some driver/usecase, the
WARN_ON() should be there, not at the core.

> +}
>  
>  struct media_entity_graph {
>  	struct {


-- 

Cheers,
Mauro
