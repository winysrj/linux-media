Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33469 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750925AbbLMWON (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Dec 2015 17:14:13 -0500
Subject: Re: [PATCH v2 03/22] media: Add an API to manage entity enumerations
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, javier@osg.samsung.com,
	Sakari Ailus <sakari.ailus@linux.intel.com>
References: <1448824823-10372-1-git-send-email-sakari.ailus@iki.fi>
 <1448824823-10372-4-git-send-email-sakari.ailus@iki.fi>
 <20151212130936.6cf7cdee@recife.lan>
From: Sakari Ailus <sakari.ailus@iki.fi>
Message-ID: <566DED38.1040802@iki.fi>
Date: Mon, 14 Dec 2015 00:12:08 +0200
MIME-Version: 1.0
In-Reply-To: <20151212130936.6cf7cdee@recife.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks for the comments!

Mauro Carvalho Chehab wrote:
> Hi Sakari,
> 
> Em Sun, 29 Nov 2015 21:20:04 +0200
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
>> From: Sakari Ailus <sakari.ailus@linux.intel.com>
>>
>> This is useful in e.g. knowing whether certain operations have already
>> been performed for an entity. The users include the framework itself (for
>> graph walking) and a number of drivers.
> 
> Please use better names on the vars. See below for details.
> 
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>>  drivers/media/media-entity.c |  39 +++++++++++++
>>  include/media/media-device.h |  14 +++++
>>  include/media/media-entity.h | 136 ++++++++++++++++++++++++++++++++++++++++---
>>  3 files changed, 181 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
>> index d11f440..fceaf44 100644
>> --- a/drivers/media/media-entity.c
>> +++ b/drivers/media/media-entity.c
>> @@ -213,6 +213,45 @@ void media_gobj_remove(struct media_gobj *gobj)
>>  }
>>  
>>  /**
>> + * __media_entity_enum_init - Initialise an entity enumeration
>> + *
>> + * @e: Entity enumeration to be initialised
>> + * @idx_max: Maximum number of entities in the enumeration
>> + *
>> + * Returns zero on success or a negative error code.
>> + */
> 
> We're using kernel-doc macros only at the header files. Please
> move those macros to there.

Oops. Will fix.

> 
>> +int __media_entity_enum_init(struct media_entity_enum *e, int idx_max)
> 
> using "e" as a var is not nice, specially on a public header.
> 
> I would use "ent_enum" instead for media_entity_enum pointers. This
> applies everywhere on this patch series.

I'm fine with that suggestion, I'll change to use ent_enum instead
(where there's no more specific purpose for the variable / field).

> 
>> +{
>> +	if (idx_max > MEDIA_ENTITY_ENUM_MAX_ID) {
>> +		e->e = kcalloc(DIV_ROUND_UP(idx_max, BITS_PER_LONG),
>> +			       sizeof(long), GFP_KERNEL);
>> +		if (!e->e)
>> +			return -ENOMEM;
>> +	} else {
>> +		e->e = e->__e;
> 
> This is crap! I can't tell what the above code is doing,
> as the var names don't give any clue!

In retrospect, the names could perhaps have been more descriptive.
There's no need to be angry at the letter "e" however, it's just doing
its job...

> 
>> +	}
>> +
>> +	bitmap_zero(e->e, idx_max);
> 
> Ok, here, there's a hint that one of the "e" is a bitmap, while
> the other is a struct... Weird, and very easy to do wrong things!
> 
> Please name the bitmap as "ent_enum_bmap" or something like that.

Fine with that.

> 
>> +	e->idx_max = idx_max;
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(__media_entity_enum_init);
>> +
>> +/**
>> + * media_entity_enum_cleanup - Release resources of an entity enumeration
>> + *
>> + * @e: Entity enumeration to be released
>> + */
>> +void media_entity_enum_cleanup(struct media_entity_enum *e)
>> +{
>> +	if (e->e != e->__e)
>> +		kfree(e->e);
>> +	e->e = NULL;
>> +}
>> +EXPORT_SYMBOL_GPL(media_entity_enum_cleanup);
>> +
>> +/**
>>   * media_entity_init - Initialize a media entity
>>   *
>>   * @num_pads: Total number of sink and source pads.
>> diff --git a/include/media/media-device.h b/include/media/media-device.h
>> index c0e1764..2d46c66 100644
>> --- a/include/media/media-device.h
>> +++ b/include/media/media-device.h
>> @@ -110,6 +110,20 @@ struct media_device {
>>  /* media_devnode to media_device */
>>  #define to_media_device(node) container_of(node, struct media_device, devnode)
>>  
>> +/**
>> + * media_entity_enum_init - Initialise an entity enumeration
>> + *
>> + * @e: Entity enumeration to be initialised
>> + * @mdev: The related media device
>> + *
>> + * Returns zero on success or a negative error code.
>> + */
>> +static inline __must_check int media_entity_enum_init(
>> +	struct media_entity_enum *e, struct media_device *mdev)
>> +{
>> +	return __media_entity_enum_init(e, mdev->entity_internal_idx_max + 1);
>> +}
>> +
>>  void media_device_init(struct media_device *mdev);
>>  void media_device_cleanup(struct media_device *mdev);
>>  int __must_check __media_device_register(struct media_device *mdev,
>> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
>> index d3d3a39..5a0339a 100644
>> --- a/include/media/media-entity.h
>> +++ b/include/media/media-entity.h
>> @@ -23,7 +23,7 @@
>>  #ifndef _MEDIA_ENTITY_H
>>  #define _MEDIA_ENTITY_H
>>  
>> -#include <linux/bitops.h>
>> +#include <linux/bitmap.h>
>>  #include <linux/kernel.h>
>>  #include <linux/list.h>
>>  #include <linux/media.h>
>> @@ -71,6 +71,30 @@ struct media_gobj {
>>  	struct list_head	list;
>>  };
>>  
>> +#define MEDIA_ENTITY_ENUM_MAX_DEPTH	16
>> +#define MEDIA_ENTITY_ENUM_MAX_ID	64
>> +
>> +/*
>> + * The number of pads can't be bigger than the number of entities,
>> + * as the worse-case scenario is to have one entity linked up to
>> + * MEDIA_ENTITY_ENUM_MAX_ID - 1 entities.
>> + */
>> +#define MEDIA_ENTITY_MAX_PADS		(MEDIA_ENTITY_ENUM_MAX_ID - 1)
>> +
>> +/* struct media_entity_enum - An enumeration of media entities.
>> + *
>> + * @__e:	Pre-allocated space reserved for media entities if the total
>> + *		number of entities  does not exceed MEDIA_ENTITY_ENUM_MAX_ID.
>> + * @e:		Bit mask in which each bit represents one entity at struct
>> + *		media_entity->internal_idx.
>> + * @idx_max:	Number of bits in the enum.
>> + */
>> +struct media_entity_enum {
>> +	DECLARE_BITMAP(__e, MEDIA_ENTITY_ENUM_MAX_ID);
>> +	unsigned long *e;
> 
> As mentioned before, don't use single letter names, specially inside
> publicly used structures. There's no good reason for that, and the
> code become really obscure.
> 
> Also, just declare one bitmap. having a "pre-allocated" hardcoded
> one here is very confusing.

I prefer to keep it as allocating a few bytes of memory is silly. In the
vast majority of the cases the pre-allocated array will be sufficient.

I have no strong opinion about this though. I agree it'd simplify the
code to remove it.

> 
>> +	int idx_max;
>> +};
>> +
>>  struct media_pipeline {
>>  };
>>  
>> @@ -307,15 +331,111 @@ static inline bool is_media_entity_v4l2_subdev(struct media_entity *entity)
>>  	}
>>  }
>>  
>> -#define MEDIA_ENTITY_ENUM_MAX_DEPTH	16
>> -#define MEDIA_ENTITY_ENUM_MAX_ID	64
>> +int __media_entity_enum_init(struct media_entity_enum *e, int idx_max);
>> +void media_entity_enum_cleanup(struct media_entity_enum *e);
>>  
>> -/*
>> - * The number of pads can't be bigger than the number of entities,
>> - * as the worse-case scenario is to have one entity linked up to
>> - * MEDIA_ENTITY_ENUM_MAX_ID - 1 entities.
>> +/**
>> + * media_entity_enum_zero - Clear the entire enum
>> + *
>> + * @e: Entity enumeration to be cleared
>>   */
>> -#define MEDIA_ENTITY_MAX_PADS		(MEDIA_ENTITY_ENUM_MAX_ID - 1)
>> +static inline void media_entity_enum_zero(struct media_entity_enum *e)
>> +{
>> +	bitmap_zero(e->e, e->idx_max);
>> +}
>> +
>> +/**
>> + * media_entity_enum_set - Mark a single entity in the enum
>> + *
>> + * @e: Entity enumeration
>> + * @entity: Entity to be marked
>> + */
>> +static inline void media_entity_enum_set(struct media_entity_enum *e,
>> +					 struct media_entity *entity)
>> +{
>> +	if (WARN_ON(entity->internal_idx >= e->idx_max))
>> +		return;
>> +
>> +	__set_bit(entity->internal_idx, e->e);
>> +}
>> +
>> +/**
>> + * media_entity_enum_clear - Unmark a single entity in the enum
>> + *
>> + * @e: Entity enumeration
>> + * @entity: Entity to be unmarked
>> + */
>> +static inline void media_entity_enum_clear(struct media_entity_enum *e,
>> +					   struct media_entity *entity)
>> +{
>> +	if (WARN_ON(entity->internal_idx >= e->idx_max))
>> +		return;
>> +
>> +	__clear_bit(entity->internal_idx, e->e);
>> +}
>> +
>> +/**
>> + * media_entity_enum_test - Test whether the entity is marked
>> + *
>> + * @e: Entity enumeration
>> + * @entity: Entity to be tested
>> + *
>> + * Returns true if the entity was marked.
>> + */
>> +static inline bool media_entity_enum_test(struct media_entity_enum *e,
>> +					  struct media_entity *entity)
>> +{
>> +	if (WARN_ON(entity->internal_idx >= e->idx_max))
>> +		return true;
>> +
>> +	return test_bit(entity->internal_idx, e->e);
>> +}
>> +
>> +/**
>> + * media_entity_enum_test - Test whether the entity is marked, and mark it
>> + *
>> + * @e: Entity enumeration
>> + * @entity: Entity to be tested
>> + *
>> + * Returns true if the entity was marked, and mark it before doing so.
>> + */
>> +static inline bool media_entity_enum_test_and_set(struct media_entity_enum *e,
>> +						  struct media_entity *entity)
>> +{
>> +	if (WARN_ON(entity->internal_idx >= e->idx_max))
>> +		return true;
>> +
>> +	return __test_and_set_bit(entity->internal_idx, e->e);
>> +}
>> +
>> +/**
>> + * media_entity_enum_test - Test whether the entire enum is empty
>> + *
>> + * @e: Entity enumeration
>> + * @entity: Entity to be tested
>> + *
>> + * Returns true if the entity was marked.
>> + */
>> +static inline bool media_entity_enum_empty(struct media_entity_enum *e)
>> +{
>> +	return bitmap_empty(e->e, e->idx_max);
>> +}
>> +
>> +/**
>> + * media_entity_enum_intersects - Test whether two enums intersect
>> + *
>> + * @e: First entity enumeration
>> + * @f: Second entity enumeration
>> + *
>> + * Returns true if entity enumerations e and f intersect, otherwise false.
>> + */
>> +static inline bool media_entity_enum_intersects(struct media_entity_enum *e,
>> +						struct media_entity_enum *f)
> 
> Huh, this is even uglier! The first media_entity_enum "e", and the
> second "f"...
> 
> For me, "f" is reserved for a "float" type ;) Seriously, the conventional
> usage for single-letter vars is to use them only for vars that don't
> deserve a name, like temporary integer vars and loop indexes (i, j, k),
> temporary pointers (p), temporary float values (f), etc.
> 
> All the rest should have more than one letter. Failing to do that makes
> the code very hard to be read by other people.

Frankly, if the function is to find an intersection between two sets,
why would someone really care what those sets would be called? This is a
tiny function.

If you however really disdain the letter "f" as well, I can opt for
using ent_enum[12] instead. :-)

> 
>> +{
>> +	WARN_ON(e->idx_max != f->idx_max);
>> +
>> +	return bitmap_intersects(e->e, f->e, min(e->idx_max, f->idx_max));
>> +}
>>  
>>  struct media_entity_graph {
>>  	struct {

-- 
Regards,

Sakari Ailus
sakari.ailus@iki.fi

