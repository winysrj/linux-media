Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:48934 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933407Ab0GOOfZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jul 2010 10:35:25 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
Date: Thu, 15 Jul 2010 09:35:20 -0500
Subject: RE: [RFC/PATCH 03/10] media: Entities, pads and links
Message-ID: <A24693684029E5489D1D202277BE894456775DDC@dlee02.ent.ti.com>
References: <1279114219-27389-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1279114219-27389-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1279114219-27389-4-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> Sent: Wednesday, July 14, 2010 8:30 AM
> To: linux-media@vger.kernel.org
> Cc: sakari.ailus@maxwell.research.nokia.com
> Subject: [RFC/PATCH 03/10] media: Entities, pads and links
>
> As video hardware pipelines become increasingly complex and
> configurable, the current hardware description through v4l2 subdevices
> reaches its limits. In addition to enumerating and configuring
> subdevices, video camera drivers need a way to discover and modify at
> runtime how those subdevices are connected. This is done through new
> elements called entities, pads and links.
>
> An entity is a basic media hardware building block. It can correspond to
> a large variety of logical blocks such as physical hardware devices
> (CMOS sensor for instance), logical hardware devices (a building block
> in a System-on-Chip image processing pipeline), DMA channels or physical
> connectors.
>
> A pad is a connection endpoint through which an entity can interact with
> other entities. Data (not restricted to video) produced by an entity
> flows from the entity's output to one or more entity inputs. Pads should
> not be confused with physical pins at chip boundaries.
>
> A link is a point-to-point oriented connection between two pads, either
> on the same entity or on different entities. Data flows from a source
> pad to a sink pad.
>
> Links are stored in the source entity. To make backwards graph walk
> faster, a copy of all links is also stored in the sink entity. The copy
> is known as a backlink and is only used to help graph traversal.
>
> The entity API is made of three functions:
>
> - media_entity_init() initializes an entity. The caller must provide an
> array of pads as well as an estimated number of links. The links array
> is allocated dynamically and will be reallocated if it grows beyond the
> initial estimate.
>
> - media_entity_cleanup() frees resources allocated for an entity. It
> must be called during the cleanup phase after unregistering the entity
> and before freeing it.
>
> - media_entity_create_link() creates a link between two entities. An
> entry in the link array of each entity is allocated and stores pointers
> to source and sink pads.
>
> When a media device is unregistered, all its entities are unregistered
> automatically.
>
> The code is based on Hans Verkuil <hverkuil@xs4all.nl> initial work.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> ---
>  Documentation/media-framework.txt |  125 ++++++++++++++++++++++++++++++++
>  drivers/media/Makefile            |    2 +-
>  drivers/media/media-device.c      |   53 ++++++++++++++
>  drivers/media/media-entity.c      |  145
> +++++++++++++++++++++++++++++++++++++
>  include/media/media-device.h      |   16 ++++
>  include/media/media-entity.h      |   79 ++++++++++++++++++++
>  6 files changed, 419 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/media/media-entity.c
>  create mode 100644 include/media/media-entity.h
>
> diff --git a/Documentation/media-framework.txt b/Documentation/media-
> framework.txt
> index b942c8f..4a8f379 100644
> --- a/Documentation/media-framework.txt
> +++ b/Documentation/media-framework.txt
> @@ -35,6 +35,30 @@ belong to userspace.
>  The media kernel API aims at solving those problems.
>
>
> +Abstract media device model
> +---------------------------
> +
> +Discovering a device internal topology, and configuring it at runtime, is
> one
> +of the goals of the media framework. To achieve this, hardware devices
> are
> +modeled as an oriented graph of building blocks called entities connected
> +through pads.
> +
> +An entity is a basic media hardware building block. It can correspond to
> +a large variety of logical blocks such as physical hardware devices
> +(CMOS sensor for instance), logical hardware devices (a building block
> +in a System-on-Chip image processing pipeline), DMA channels or physical
> +connectors.
> +
> +A pad is a connection endpoint through which an entity can interact with
> +other entities. Data (not restricted to video) produced by an entity
> +flows from the entity's output to one or more entity inputs. Pads should
> +not be confused with physical pins at chip boundaries.
> +
> +A link is a point-to-point oriented connection between two pads, either
> +on the same entity or on different entities. Data flows from a source
> +pad to a sink pad.
> +
> +
>  Media device
>  ------------
>
> @@ -66,3 +90,104 @@ Drivers unregister media device instances by calling
>
>  Unregistering a media device that hasn't been registered is *NOT* safe.
>
> +
> +Entities, pads and links
> +------------------------
> +
> +- Entities
> +
> +Entities are represented by a struct media_entity instance, defined in
> +include/media/media-entity.h. The structure is usually embedded into a
> +higher-level structure, such as a v4l2_subdev or video_device instance,
> +although drivers can allocate entities directly.
> +
> +Drivers initialize entities by calling
> +
> +     media_entity_init(struct media_entity *entity, u8 num_pads,
> +                       struct media_entity_pad *pads, u8 extra_links);
> +
> +The media_entity name, type and subtype fields can be initialized before
> or
> +after calling media_entity_init. Entities embedded in higher-level
> standard
> +structures have those fields set by the higher-level framework.
> +
> +As the number of pads is known in advance, the pads array is not
> allocated
> +dynamically but is managed by the entity driver. Most drivers will embed
> the
> +pads array in a driver-specific structure, avoiding dynamic allocation.
> +
> +Drivers must set the type of every pad in the pads array before calling
> +media_entity_init. The function will initialize the other pads fields.
> +
> +Unlike the number of pads, the total number of links isn't always known
> in
> +advance by the entity driver. As an initial estimate, media_entity_init
> +pre-allocates a number of links equal to the number of pads plus an
> optional
> +number of extra links. The links array will be reallocated if it grows
> beyond
> +the initial estimate.
> +
> +Drivers register entities with a media device by calling
> +
> +     media_device_register_entity(struct media_device *mdev,
> +                                  struct media_entity *entity);
> +
> +When registered the entity is assigned an ID. Entity IDs are positive
> integers
> +and are guaranteed to be unique in the context of the media device. The
> +framework doesn't guarantees that IDs will always be continuous.
> +
> +Drivers unregister entities by calling
> +
> +     media_device_unregister_entity(struct media_entity *entity);
> +
> +Unregistering an entity will not change the IDs of the other entities,
> and the
> +ID will never be reused for a newly registered entity.
> +
> +When a media device is unregistered, all its entities are unregistered
> +automatically. No manual entities unregistration is then required.
> +
> +Drivers free resources associated with an entity by calling
> +
> +     media_entity_cleanup(struct media_entity *entity);
> +
> +This function must be called during the cleanup phase after unregistering
> the
> +entity. Note that the media_entity instance itself must be freed
> explicitly by
> +the driver if required.
> +
> +- Pads
> +
> +Pads are represented by a struct media_entity_pad instance, defined in
> +include/media/media-entity.h. Each entity stores its pads in a pads array
> +managed by the entity driver. Drivers usually embed the array in a
> +driver-specific structure.
> +
> +Pads are identified by their entity and their 0-based index in the pads
> array.
> +Both information are stored in the media_entity_pad structure, making the
> +media_entity_pad pointer the canonical way to store and pass link
> references.
> +
> +Pads have a type, relative to the entity they belong to:
> +
> +     pads of type MEDIA_PAD_TYPE_INPUT sink data, while
> +     pads of type MEDIA_PAD_TYPE_OUTPUT source data.
> +
> +- Links
> +
> +Links are represented by a struct media_entity_link instance, defined in
> +include/media/media-entity.h. Each entity stores all links originating at
> or
> +targetting any of its pads in a links array. A given link is thus stored
> +twice, once in the source entity and once in the target entity. The array
> is
> +pre-allocated and grows dynamically as needed.
> +
> +Drivers create links by calling
> +
> +     media_entity_create_link(struct media_entity *source, u8 source_pad,
> +                              struct media_entity *sink,   u8 sink_pad,
> +                              u32 flags);
> +
> +An entry in the link array of each entity is allocated and stores
> pointers
> +to source and sink pads.
> +
> +Links have flags that describe the link capabilities and state.
> +
> +     MEDIA_LINK_FLAG_ACTIVE indicates that the link is active and can be
> +     used to transfer media data. When two or more links target a sink
> pad,
> +     only one of them can be active at a time.
> +     MEDIA_LINK_FLAG_IMMUTABLE indicates that the link active state can't
> +     be modified at runtime. An immutable link is always active.
> +
> diff --git a/drivers/media/Makefile b/drivers/media/Makefile
> index f8d8dcb..a425581 100644
> --- a/drivers/media/Makefile
> +++ b/drivers/media/Makefile
> @@ -2,7 +2,7 @@
>  # Makefile for the kernel multimedia device drivers.
>  #
>
> -media-objs   := media-device.o media-devnode.o
> +media-objs   := media-device.o media-devnode.o media-entity.o
>
>  obj-$(CONFIG_MEDIA_SUPPORT)  += media.o
>
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index a4d3db5..6361367 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -23,6 +23,7 @@
>
>  #include <media/media-device.h>
>  #include <media/media-devnode.h>
> +#include <media/media-entity.h>
>
>  static const struct media_file_operations media_device_fops = {
>       .owner = THIS_MODULE,
> @@ -47,6 +48,10 @@ static void media_device_release(struct media_devnode
> *mdev)
>   */
>  int __must_check media_device_register(struct media_device *mdev)
>  {
> +     mdev->entity_id = 1;
> +     INIT_LIST_HEAD(&mdev->entities);
> +     spin_lock_init(&mdev->lock);
> +
>       /* If dev == NULL, then name must be filled in by the caller */
>       if (mdev->dev == NULL && WARN_ON(!mdev->name[0]))
>               return 0;
> @@ -72,6 +77,54 @@ EXPORT_SYMBOL_GPL(media_device_register);
>   */
>  void media_device_unregister(struct media_device *mdev)
>  {
> +     struct media_entity *entity;
> +     struct media_entity *next;
> +
> +     list_for_each_entry_safe(entity, next, &mdev->entities, list)
> +             media_device_unregister_entity(entity);
> +
>       media_devnode_unregister(&mdev->devnode);
>  }
>  EXPORT_SYMBOL_GPL(media_device_unregister);
> +
> +/**
> + * media_device_register_entity - Register an entity with a media device
> + * @mdev:    The media device
> + * @entity:  The entity
> + */
> +int __must_check media_device_register_entity(struct media_device *mdev,
> +                                           struct media_entity *entity)
> +{

What if mdev == NULL OR entity == NULL?

> +     /* Warn if we apparently re-register an entity */
> +     WARN_ON(entity->parent != NULL);

Shouldn't we exit with -EBUSY here instead? Or is there a usecase
In which this is a valid scenario?

> +     entity->parent = mdev;
> +
> +     spin_lock(&mdev->lock);
> +     entity->id = mdev->entity_id++;
> +     list_add_tail(&entity->list, &mdev->entities);
> +     spin_unlock(&mdev->lock);
> +
> +     return 0;
> +}
> +EXPORT_SYMBOL_GPL(media_device_register_entity);
> +
> +/**
> + * media_device_unregister_entity - Unregister an entity
> + * @entity:  The entity
> + *
> + * If the entity has never been registered this function will return
> + * immediately.
> + */
> +void media_device_unregister_entity(struct media_entity *entity)
> +{
> +     struct media_device *mdev = entity->parent;

What if entity == NULL?

> +
> +     if (mdev == NULL)
> +             return;
> +
> +     spin_lock(&mdev->lock);
> +     list_del(&entity->list);
> +     spin_unlock(&mdev->lock);
> +     entity->parent = NULL;
> +}
> +EXPORT_SYMBOL_GPL(media_device_unregister_entity);
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> new file mode 100644
> index 0000000..d5a4b4c
> --- /dev/null
> +++ b/drivers/media/media-entity.c
> @@ -0,0 +1,145 @@
> +/*
> + *  Media Entity support
> + *
> + *  Copyright (C) 2009 Laurent Pinchart
> <laurent.pinchart@ideasonboard.com>

2010?

> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
> USA
> + */
> +
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <media/media-entity.h>
> +
> +/**
> + * media_entity_init - Initialize a media entity
> + *
> + * @num_pads: Total number of input and output pads.
> + * @extra_links: Initial estimate of the number of extra links.
> + * @pads: Array of 'num_pads' pads.
> + *
> + * The total number of pads is an intrinsic property of entities known by
> the
> + * entity driver, while the total number of links depends on hardware
> design
> + * and is an extrinsic property unknown to the entity driver. However, in
> most
> + * use cases the entity driver can guess the number of links which can
> safely
> + * be assumed to be equal to or larger than the number of pads.
> + *
> + * For those reasons the links array can be preallocated based on the
> entity
> + * driver guess and will be reallocated later if extra links need to be
> + * created.
> + *
> + * This function allocates a links array with enough space to hold at
> least
> + * 'num_pads' + 'extra_links' elements. The media_entity::max_links field
> will
> + * be set to the number of allocated elements.
> + *
> + * The pads array is managed by the entity driver and passed to
> + * media_entity_init() where its pointer will be stored in the entity
> structure.
> + */
> +int
> +media_entity_init(struct media_entity *entity, u8 num_pads,
> +               struct media_entity_pad *pads, u8 extra_links)
> +{
> +     struct media_entity_link *links;
> +     unsigned int max_links = num_pads + extra_links;
> +     unsigned int i;
> +
> +     links = kzalloc(max_links * sizeof(links[0]), GFP_KERNEL);
> +     if (links == NULL)
> +             return -ENOMEM;
> +
> +     entity->max_links = max_links;
> +     entity->num_links = 0;
> +     entity->num_backlinks = 0;
> +     entity->num_pads = num_pads;
> +     entity->pads = pads;
> +     entity->links = links;
> +
> +     for (i = 0; i < num_pads; i++) {
> +             pads[i].entity = entity;
> +             pads[i].index = i;
> +     }
> +
> +     return 0;
> +}
> +EXPORT_SYMBOL(media_entity_init);
> +
> +void
> +media_entity_cleanup(struct media_entity *entity)
> +{
> +     kfree(entity->links);
> +}
> +EXPORT_SYMBOL(media_entity_cleanup);
> +
> +static struct
> +media_entity_link *media_entity_add_link(struct media_entity *entity)
> +{
> +     if (entity->num_links >= entity->max_links) {
> +             struct media_entity_link *links = entity->links;
> +             unsigned int max_links = entity->max_links + 2;
> +             unsigned int i;
> +
> +             links = krealloc(links, max_links * sizeof(*links),
> GFP_KERNEL);
> +             if (links == NULL)
> +                     return NULL;
> +
> +             for (i = 0; i < entity->num_links; i++)
> +                     links[i].other->other = &links[i];
> +
> +             entity->max_links = max_links;
> +             entity->links = links;
> +     }
> +
> +     return &entity->links[entity->num_links++];
> +}
> +
> +int
> +media_entity_create_link(struct media_entity *source, u8 source_pad,
> +                      struct media_entity *sink, u8 sink_pad, u32 flags)
> +{
> +     struct media_entity_link *link;
> +     struct media_entity_link *backlink;
> +
> +     BUG_ON(source == NULL || sink == NULL);
> +     BUG_ON(source_pad >= source->num_pads);
> +     BUG_ON(sink_pad >= sink->num_pads);

Isn't this too dramatic? :)

I mean, does the entire system needs to be halted because you won't be
able to link your video subdevices?

> +
> +     link = media_entity_add_link(source);
> +     if (link == NULL)
> +             return -ENOMEM;
> +
> +     link->source = &source->pads[source_pad];
> +     link->sink = &sink->pads[sink_pad];
> +     link->flags = flags;
> +
> +     /* Create the backlink. Backlinks are used to help graph traversal
> and
> +      * are not reported to userspace.
> +      */
> +     backlink = media_entity_add_link(sink);
> +     if (backlink == NULL) {
> +             source->num_links--;
> +             return -ENOMEM;
> +     }
> +
> +     backlink->source = &source->pads[source_pad];
> +     backlink->sink = &sink->pads[sink_pad];
> +     backlink->flags = flags;
> +
> +     link->other = backlink;
> +     backlink->other = link;
> +
> +     sink->num_backlinks++;
> +
> +     return 0;
> +}
> +EXPORT_SYMBOL(media_entity_create_link);
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index 6c1fc4a..9105dc3 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -23,8 +23,10 @@
>
>  #include <linux/device.h>
>  #include <linux/list.h>
> +#include <linux/spinlock.h>
>
>  #include <media/media-devnode.h>
> +#include <media/media-entity.h>
>
>  /* Each instance of a media device should create the media_device struct,
>   * either stand-alone or embedded in a larger struct.
> @@ -43,6 +45,12 @@ struct media_device {
>       struct device *dev;
>       struct media_devnode devnode;
>
> +     u32 entity_id;
> +     struct list_head entities;
> +
> +     /* Protects the entities list */
> +     spinlock_t lock;
> +
>       /* unique device name, by default the driver name + bus ID */
>       char name[MEDIA_DEVICE_NAME_SIZE];
>  };
> @@ -50,4 +58,12 @@ struct media_device {
>  int __must_check media_device_register(struct media_device *mdev);
>  void media_device_unregister(struct media_device *mdev);
>
> +int __must_check media_device_register_entity(struct media_device *mdev,
> +                                           struct media_entity *entity);
> +void media_device_unregister_entity(struct media_entity *entity);
> +
> +/* Iterate over all entities. */
> +#define media_device_for_each_entity(entity, mdev)                   \
> +     list_for_each_entry(entity, &(mdev)->entities, list)
> +
>  #endif
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> new file mode 100644
> index 0000000..0929a90
> --- /dev/null
> +++ b/include/media/media-entity.h
> @@ -0,0 +1,79 @@
> +#ifndef _MEDIA_ENTITY_H
> +#define _MEDIA_ENTITY_H
> +
> +#include <linux/list.h>
> +
> +#define MEDIA_ENTITY_TYPE_NODE               1
> +#define MEDIA_ENTITY_TYPE_SUBDEV     2
> +
> +#define MEDIA_NODE_TYPE_V4L          1
> +#define MEDIA_NODE_TYPE_FB           2
> +#define MEDIA_NODE_TYPE_ALSA         3
> +#define MEDIA_NODE_TYPE_DVB          4
> +
> +#define MEDIA_SUBDEV_TYPE_VID_DECODER        1
> +#define MEDIA_SUBDEV_TYPE_VID_ENCODER        2
> +#define MEDIA_SUBDEV_TYPE_MISC               3
> +
> +#define MEDIA_LINK_FLAG_ACTIVE               (1 << 0)
> +#define MEDIA_LINK_FLAG_IMMUTABLE    (1 << 1)
> +
> +#define MEDIA_PAD_TYPE_INPUT         1
> +#define MEDIA_PAD_TYPE_OUTPUT                2

Shouldn't all the above be enums? (except of course the
MEDIA_LINK_FLAG_* defines)

Regards,
Sergio

> +
> +struct media_entity_link {
> +     struct media_entity_pad *source;/* Source pad */
> +     struct media_entity_pad *sink;  /* Sink pad  */
> +     struct media_entity_link *other;/* Link in the reverse direction */
> +     u32 flags;                      /* Link flags (MEDIA_LINK_FLAG_*) */
> +};
> +
> +struct media_entity_pad {
> +     struct media_entity *entity;    /* Entity this pad belongs to */
> +     u32 type;                       /* Pad type (MEDIA_PAD_TYPE_*) */
> +     u32 index;                      /* Pad index in the entity pads array */
> +};
> +
> +struct media_entity {
> +     struct list_head list;
> +     struct media_device *parent;    /* Media device this entity belongs
> to*/
> +     u32 id;                         /* Entity ID, unique in the parent
> media
> +                                      * device context */
> +     const char *name;               /* Entity name */
> +     u32 type;                       /* Entity type (MEDIA_ENTITY_TYPE_*) */
> +     u32 subtype;                    /* Entity subtype (type-specific) */
> +
> +     u8 num_pads;                    /* Number of input and output pads */
> +     u8 num_links;                   /* Number of existing links, both
> active
> +                                      * and inactive */
> +     u8 num_backlinks;               /* Number of backlinks */
> +     u8 max_links;                   /* Maximum number of links */
> +
> +     struct media_entity_pad *pads;  /* Array of pads (num_pads
> elements) */
> +     struct media_entity_link *links;/* Array of links (max_links
> elements)*/
> +
> +     union {
> +             /* Node specifications */
> +             struct {
> +                     u32 major;
> +                     u32 minor;
> +             } v4l;
> +             struct {
> +                     u32 major;
> +                     u32 minor;
> +             } fb;
> +             int alsa;
> +             int dvb;
> +
> +             /* Sub-device specifications */
> +             /* Nothing needed yet */
> +     };
> +};
> +
> +int media_entity_init(struct media_entity *entity, u8 num_pads,
> +             struct media_entity_pad *pads, u8 extra_links);
> +void media_entity_cleanup(struct media_entity *entity);
> +int media_entity_create_link(struct media_entity *source, u8 source_pad,
> +             struct media_entity *sink, u8 sink_pad, u32 flags);
> +
> +#endif
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
