Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:39215 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936136Ab0GPJKH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jul 2010 05:10:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Subject: Re: [RFC/PATCH 03/10] media: Entities, pads and links
Date: Fri, 16 Jul 2010 11:10:07 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
References: <1279114219-27389-1-git-send-email-laurent.pinchart@ideasonboard.com> <1279114219-27389-4-git-send-email-laurent.pinchart@ideasonboard.com> <A24693684029E5489D1D202277BE894456775DDC@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894456775DDC@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007161110.08165.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio,

Thanks for the review.

On Thursday 15 July 2010 16:35:20 Aguirre, Sergio wrote:
> On Wednesday 14 July 2010 08:30:00 Laurent Pinchart wrote:

[snip]

> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index a4d3db5..6361367 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c

[snip]

> > @@ -72,6 +77,54 @@ EXPORT_SYMBOL_GPL(media_device_register);

[snip]

> > +
> > +/**
> > + * media_device_register_entity - Register an entity with a media device
> > + * @mdev:    The media device
> > + * @entity:  The entity
> > + */
> > +int __must_check media_device_register_entity(struct media_device *mdev,
> > +                                           struct media_entity *entity)
> > +{
> 
> What if mdev == NULL OR entity == NULL?

It's not a valid use case. Drivers must not try to register a NULL entity, or 
an entity to a NULL media device.

> > +     /* Warn if we apparently re-register an entity */
> > +     WARN_ON(entity->parent != NULL);
> 
> Shouldn't we exit with -EBUSY here instead? Or is there a usecase
> In which this is a valid scenario?

entity->parent != NULL isn't a valid scenario. It's a driver bug, and WARN_ON 
will result in a backtrace being printed, notifying the driver developer that 
something is seriously wrong.

> > +     entity->parent = mdev;
> > +
> > +     spin_lock(&mdev->lock);
> > +     entity->id = mdev->entity_id++;
> > +     list_add_tail(&entity->list, &mdev->entities);
> > +     spin_unlock(&mdev->lock);
> > +
> > +     return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(media_device_register_entity);
> > +
> > +/**
> > + * media_device_unregister_entity - Unregister an entity
> > + * @entity:  The entity
> > + *
> > + * If the entity has never been registered this function will return
> > + * immediately.
> > + */
> > +void media_device_unregister_entity(struct media_entity *entity)
> > +{
> > +     struct media_device *mdev = entity->parent;
> 
> What if entity == NULL?

Still not a valid use case, don't unregister NULL.

> > +
> > +     if (mdev == NULL)
> > +             return;
> > +
> > +     spin_lock(&mdev->lock);
> > +     list_del(&entity->list);
> > +     spin_unlock(&mdev->lock);
> > +     entity->parent = NULL;
> > +}
> > +EXPORT_SYMBOL_GPL(media_device_unregister_entity);
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > new file mode 100644
> > index 0000000..d5a4b4c
> > --- /dev/null
> > +++ b/drivers/media/media-entity.c
> > @@ -0,0 +1,145 @@
> > +/*
> > + *  Media Entity support
> > + *
> > + *  Copyright (C) 2009 Laurent Pinchart
> > <laurent.pinchart@ideasonboard.com>
> 
> 2010?

Oops, yes, will fix.

[snip]

> > +int
> > +media_entity_create_link(struct media_entity *source, u8 source_pad,
> > +                      struct media_entity *sink, u8 sink_pad, u32 flags)
> > +{
> > +     struct media_entity_link *link;
> > +     struct media_entity_link *backlink;
> > +
> > +     BUG_ON(source == NULL || sink == NULL);
> > +     BUG_ON(source_pad >= source->num_pads);
> > +     BUG_ON(sink_pad >= sink->num_pads);
> 
> Isn't this too dramatic? :)
> 
> I mean, does the entire system needs to be halted because you won't be
> able to link your video subdevices?

If source or sink is NULL, the second or third BUG_ON will result in a crash. 
If the source or sink pad numbers are out of bounds, undefined memory will be 
dereferenced later. Both conditions will likely result in a crash, so it's 
better to have a predictable, easy to understand crash.

Once again this should never happen. It's a driver bug if it does, and should 
not happen randomly at runtime.

[snip]

> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > new file mode 100644
> > index 0000000..0929a90
> > --- /dev/null
> > +++ b/include/media/media-entity.h
> > @@ -0,0 +1,79 @@
> > +#ifndef _MEDIA_ENTITY_H
> > +#define _MEDIA_ENTITY_H
> > +
> > +#include <linux/list.h>
> > +
> > +#define MEDIA_ENTITY_TYPE_NODE               1
> > +#define MEDIA_ENTITY_TYPE_SUBDEV     2
> > +
> > +#define MEDIA_NODE_TYPE_V4L          1
> > +#define MEDIA_NODE_TYPE_FB           2
> > +#define MEDIA_NODE_TYPE_ALSA         3
> > +#define MEDIA_NODE_TYPE_DVB          4
> > +
> > +#define MEDIA_SUBDEV_TYPE_VID_DECODER        1
> > +#define MEDIA_SUBDEV_TYPE_VID_ENCODER        2
> > +#define MEDIA_SUBDEV_TYPE_MISC               3
> > +
> > +#define MEDIA_LINK_FLAG_ACTIVE               (1 << 0)
> > +#define MEDIA_LINK_FLAG_IMMUTABLE    (1 << 1)
> > +
> > +#define MEDIA_PAD_TYPE_INPUT         1
> > +#define MEDIA_PAD_TYPE_OUTPUT                2
> 
> Shouldn't all the above be enums? (except of course the
> MEDIA_LINK_FLAG_* defines)

They can be enums, but the structures used in ioctls must use integer types as 
enum sizes vary depending on the ABI on some platforms (most notably ARM). I 
have no strong opinion for or against enums for the definitions of the values.

-- 
Regards,

Laurent Pinchart
