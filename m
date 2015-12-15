Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55734 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932428AbbLOXRE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2015 18:17:04 -0500
Date: Wed, 16 Dec 2015 01:16:30 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, javier@osg.samsung.com,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v2 03/22] media: Add an API to manage entity enumerations
Message-ID: <20151215231629.GM17128@valkosipuli.retiisi.org.uk>
References: <1448824823-10372-1-git-send-email-sakari.ailus@iki.fi>
 <1448824823-10372-4-git-send-email-sakari.ailus@iki.fi>
 <20151212130936.6cf7cdee@recife.lan>
 <566DED38.1040802@iki.fi>
 <20151213225457.46ba2f6c@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151213225457.46ba2f6c@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Sun, Dec 13, 2015 at 10:54:57PM -0200, Mauro Carvalho Chehab wrote:
> > >> +	e->idx_max = idx_max;
> > >> +
> > >> +	return 0;
> > >> +}
> > >> +EXPORT_SYMBOL_GPL(__media_entity_enum_init);
> > >> +
> > >> +/**
> > >> + * media_entity_enum_cleanup - Release resources of an entity enumeration
> > >> + *
> > >> + * @e: Entity enumeration to be released
> > >> + */
> > >> +void media_entity_enum_cleanup(struct media_entity_enum *e)
> > >> +{
> > >> +	if (e->e != e->__e)
> > >> +		kfree(e->e);
> > >> +	e->e = NULL;
> > >> +}
> > >> +EXPORT_SYMBOL_GPL(media_entity_enum_cleanup);
> > >> +
> > >> +/**
> > >>   * media_entity_init - Initialize a media entity
> > >>   *
> > >>   * @num_pads: Total number of sink and source pads.
> > >> diff --git a/include/media/media-device.h b/include/media/media-device.h
> > >> index c0e1764..2d46c66 100644
> > >> --- a/include/media/media-device.h
> > >> +++ b/include/media/media-device.h
> > >> @@ -110,6 +110,20 @@ struct media_device {
> > >>  /* media_devnode to media_device */
> > >>  #define to_media_device(node) container_of(node, struct media_device, devnode)
> > >>  
> > >> +/**
> > >> + * media_entity_enum_init - Initialise an entity enumeration
> > >> + *
> > >> + * @e: Entity enumeration to be initialised
> > >> + * @mdev: The related media device
> > >> + *
> > >> + * Returns zero on success or a negative error code.
> > >> + */
> > >> +static inline __must_check int media_entity_enum_init(
> > >> +	struct media_entity_enum *e, struct media_device *mdev)
> > >> +{
> > >> +	return __media_entity_enum_init(e, mdev->entity_internal_idx_max + 1);
> > >> +}
> > >> +
> > >>  void media_device_init(struct media_device *mdev);
> > >>  void media_device_cleanup(struct media_device *mdev);
> > >>  int __must_check __media_device_register(struct media_device *mdev,
> > >> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > >> index d3d3a39..5a0339a 100644
> > >> --- a/include/media/media-entity.h
> > >> +++ b/include/media/media-entity.h
> > >> @@ -23,7 +23,7 @@
> > >>  #ifndef _MEDIA_ENTITY_H
> > >>  #define _MEDIA_ENTITY_H
> > >>  
> > >> -#include <linux/bitops.h>
> > >> +#include <linux/bitmap.h>
> > >>  #include <linux/kernel.h>
> > >>  #include <linux/list.h>
> > >>  #include <linux/media.h>
> > >> @@ -71,6 +71,30 @@ struct media_gobj {
> > >>  	struct list_head	list;
> > >>  };
> > >>  
> > >> +#define MEDIA_ENTITY_ENUM_MAX_DEPTH	16
> > >> +#define MEDIA_ENTITY_ENUM_MAX_ID	64
> > >> +
> > >> +/*
> > >> + * The number of pads can't be bigger than the number of entities,
> > >> + * as the worse-case scenario is to have one entity linked up to
> > >> + * MEDIA_ENTITY_ENUM_MAX_ID - 1 entities.
> > >> + */
> > >> +#define MEDIA_ENTITY_MAX_PADS		(MEDIA_ENTITY_ENUM_MAX_ID - 1)
> > >> +
> > >> +/* struct media_entity_enum - An enumeration of media entities.
> > >> + *
> > >> + * @__e:	Pre-allocated space reserved for media entities if the total
> > >> + *		number of entities  does not exceed MEDIA_ENTITY_ENUM_MAX_ID.
> > >> + * @e:		Bit mask in which each bit represents one entity at struct
> > >> + *		media_entity->internal_idx.
> > >> + * @idx_max:	Number of bits in the enum.
> > >> + */
> > >> +struct media_entity_enum {
> > >> +	DECLARE_BITMAP(__e, MEDIA_ENTITY_ENUM_MAX_ID);
> > >> +	unsigned long *e;
> > > 
> > > As mentioned before, don't use single letter names, specially inside
> > > publicly used structures. There's no good reason for that, and the
> > > code become really obscure.
> > > 
> > > Also, just declare one bitmap. having a "pre-allocated" hardcoded
> > > one here is very confusing.
> > 
> > I prefer to keep it as allocating a few bytes of memory is silly. In the
> > vast majority of the cases the pre-allocated array will be sufficient.
> 
> "vast majority" actually depends on the driver/subsystem. The fact that
> right now most drivers work fine with < 64 entities may not be
> true in the future.

One reason the pre-allocated bitmap shouldn't be removed yet is that by
doing that, i.e. allocating memory in media_entity_enum_init(), the user
must check the return code. The further patches in the set make drivers do
that add __must_check modifier to the prototype.

I will thus add another patch near the top to remove the pre-allocated
bitmap.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
