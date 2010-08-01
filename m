Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1811 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab0HALdB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Aug 2010 07:33:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC/PATCH v3 03/10] media: Entities, pads and links
Date: Sun, 1 Aug 2010 13:32:50 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1280419616-7658-1-git-send-email-laurent.pinchart@ideasonboard.com> <1280419616-7658-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1280419616-7658-4-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201008011332.50872.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 29 July 2010 18:06:36 Laurent Pinchart wrote:

<snip>

> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index bd559b0..ac96847 100644
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
> @@ -40,9 +42,23 @@ struct media_device {
>  	 */
>  	struct device *dev;
>  	struct media_devnode devnode;
> +
> +	u32 entity_id;
> +	struct list_head entities;
> +
> +	/* Protects the entities list */
> +	spinlock_t lock;
>  };
>  
>  int __must_check media_device_register(struct media_device *mdev);
>  void media_device_unregister(struct media_device *mdev);
>  
> +int __must_check media_device_register_entity(struct media_device *mdev,
> +					      struct media_entity *entity);
> +void media_device_unregister_entity(struct media_entity *entity);
> +
> +/* Iterate over all entities. */
> +#define media_device_for_each_entity(entity, mdev)			\
> +	list_for_each_entry(entity, &(mdev)->entities, list)
> +
>  #endif
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> new file mode 100644
> index 0000000..37a25bf
> --- /dev/null
> +++ b/include/media/media-entity.h
> @@ -0,0 +1,85 @@
> +#ifndef _MEDIA_ENTITY_H
> +#define _MEDIA_ENTITY_H
> +
> +#include <linux/list.h>
> +
> +#define MEDIA_ENTITY_TYPE_NODE			(1 << 16)

I agree with Sakari that '16' should be a define.

> +#define MEDIA_ENTITY_TYPE_NODE_V4L		(MEDIA_ENTITY_TYPE_NODE + 1)
> +#define MEDIA_ENTITY_TYPE_NODE_FB		(MEDIA_ENTITY_TYPE_NODE + 2)
> +#define MEDIA_ENTITY_TYPE_NODE_ALSA		(MEDIA_ENTITY_TYPE_NODE + 3)
> +#define MEDIA_ENTITY_TYPE_NODE_DVB		(MEDIA_ENTITY_TYPE_NODE + 4)
> +
> +#define MEDIA_ENTITY_TYPE_SUBDEV		(2 << 16)
> +#define MEDIA_ENTITY_TYPE_SUBDEV_VID_DECODER	(MEDIA_ENTITY_TYPE_SUBDEV + 1)
> +#define MEDIA_ENTITY_TYPE_SUBDEV_VID_ENCODER	(MEDIA_ENTITY_TYPE_SUBDEV + 2)
> +#define MEDIA_ENTITY_TYPE_SUBDEV_MISC		(MEDIA_ENTITY_TYPE_SUBDEV + 3)
> +
> +#define MEDIA_LINK_FLAG_ACTIVE			(1 << 0)
> +#define MEDIA_LINK_FLAG_IMMUTABLE		(1 << 1)
> +
> +#define MEDIA_PAD_FLAG_INPUT			(1 << 0)
> +#define MEDIA_PAD_FLAG_OUTPUT			(1 << 1)
> +
> +struct media_link {
> +	struct media_pad *source;	/* Source pad */
> +	struct media_pad *sink;		/* Sink pad  */
> +	struct media_link *other;	/* Link in the reverse direction */

Why not rename 'other' to 'back' or 'backlink'? 'other' is not a good name IMHO.

> +	unsigned long flags;		/* Link flags (MEDIA_LINK_FLAG_*) */
> +};
> +
> +struct media_pad {
> +	struct media_entity *entity;	/* Entity this pad belongs to */
> +	u16 index;			/* Pad index in the entity pads array */
> +	unsigned long flags;		/* Pad flags (MEDIA_PAD_FLAG_*) */
> +};
> +
> +struct media_entity {
> +	struct list_head list;
> +	struct media_device *parent;	/* Media device this entity belongs to*/
> +	u32 id;				/* Entity ID, unique in the parent media
> +					 * device context */
> +	const char *name;		/* Entity name */
> +	u32 type;			/* Entity type (MEDIA_ENTITY_TYPE_*) */
> +
> +	u8 num_pads;			/* Number of input and output pads */
> +	u8 num_links;			/* Number of existing links, both active
> +					 * and inactive */
> +	u8 num_backlinks;		/* Number of backlinks */
> +	u8 max_links;			/* Maximum number of links */
> +
> +	struct media_pad *pads;		/* Pads array (num_pads elements) */
> +	struct media_link *links;	/* Links array (max_links elements)*/
> +
> +	union {
> +		/* Node specifications */
> +		struct {
> +			u32 major;
> +			u32 minor;
> +		} v4l;
> +		struct {
> +			u32 major;
> +			u32 minor;
> +		} fb;
> +		int alsa;
> +		int dvb;
> +
> +		/* Sub-device specifications */
> +		/* Nothing needed yet */
> +	};
> +};
> +
> +#define MEDIA_ENTITY_TYPE_MASK		0xffff0000
> +#define MEDIA_ENTITY_SUBTYPE_MASK	0x0000ffff
> +
> +#define media_entity_type(entity) \
> +	((entity)->type & MEDIA_ENTITY_TYPE_MASK)
> +#define media_entity_subtype(entity) \
> +	((entity)->type & MEDIA_ENTITY_SUBTYPE_MASK)

Make these inline functions to ensure correct typechecking.
Since bit 31 of the entity ID is reserved for MEDIA_ENTITY_ID_FLAG_NEXT you
probably should change the TYPE_MASK to 0x7fff0000. Actually, I would
change the type mask to 0x00ff0000, that way all top 8 bits are available
for the future.

> +
> +int media_entity_init(struct media_entity *entity, u8 num_pads,
> +		struct media_pad *pads, u8 extra_links);
> +void media_entity_cleanup(struct media_entity *entity);
> +int media_entity_create_link(struct media_entity *source, u8 source_pad,
> +		struct media_entity *sink, u8 sink_pad, u32 flags);
> +
> +#endif
> 

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
