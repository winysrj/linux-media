Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3163 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab0GXMSQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Jul 2010 08:18:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC/PATCH v2 03/10] media: Entities, pads and links
Date: Sat, 24 Jul 2010 14:18:11 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com> <1279722935-28493-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1279722935-28493-4-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201007241418.11463.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 21 July 2010 16:35:28 Laurent Pinchart wrote:

<snip>

> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> new file mode 100644
> index 0000000..fd44647
> --- /dev/null
> +++ b/include/media/media-entity.h
> @@ -0,0 +1,79 @@
> +#ifndef _MEDIA_ENTITY_H
> +#define _MEDIA_ENTITY_H
> +
> +#include <linux/list.h>
> +
> +#define MEDIA_ENTITY_TYPE_NODE				1
> +#define MEDIA_ENTITY_TYPE_SUBDEV			2
> +
> +#define MEDIA_ENTITY_SUBTYPE_NODE_V4L			1
> +#define MEDIA_ENTITY_SUBTYPE_NODE_FB			2
> +#define MEDIA_ENTITY_SUBTYPE_NODE_ALSA			3
> +#define MEDIA_ENTITY_SUBTYPE_NODE_DVB			4
> +
> +#define MEDIA_ENTITY_SUBTYPE_SUBDEV_VID_DECODER		1
> +#define MEDIA_ENTITY_SUBTYPE_SUBDEV_VID_ENCODER		2
> +#define MEDIA_ENTITY_SUBTYPE_SUBDEV_MISC		3

These names are too awkward.

I see two options:

1) Rename the type field to 'entity' and the macros to MEDIA_ENTITY_NODE/SUBDEV.
   Also rename subtype to type and the macros to MEDIA_ENTITY_TYPE_NODE_V4L
   and MEDIA_ENTITY_TYPE_SUBDEV_VID_DECODER. We might even get away with dropping
   _TYPE from the macro name.

2) Merge type and subtype to a single entity field. The top 16 bits are the entity
   type, the bottom 16 bits are the subtype. That way you end up with:

#define MEDIA_ENTITY_NODE			(1 << 16)
#define MEDIA_ENTITY_SUBDEV			(2 << 16)

#define MEDIA_ENTITY_NODE_V4L			(MEDIA_ENTITY_NODE + 1)

#define MEDIA_ENTITY_SUBDEV_VID_DECODER		(MEDIA_ENTITY_SUBDEV + 1)

I rather like this option myself.

> +
> +#define MEDIA_LINK_FLAG_ACTIVE				(1 << 0)
> +#define MEDIA_LINK_FLAG_IMMUTABLE			(1 << 1)
> +
> +#define MEDIA_PAD_DIR_INPUT				1
> +#define MEDIA_PAD_DIR_OUTPUT				2
> +
> +struct media_entity_link {
> +	struct media_entity_pad *source;/* Source pad */
> +	struct media_entity_pad *sink;	/* Sink pad  */
> +	struct media_entity_link *other;/* Link in the reverse direction */
> +	u32 flags;			/* Link flags (MEDIA_LINK_FLAG_*) */
> +};
> +
> +struct media_entity_pad {
> +	struct media_entity *entity;	/* Entity this pad belongs to */
> +	u32 direction;			/* Pad direction (MEDIA_PAD_DIR_*) */
> +	u8 index;			/* Pad index in the entity pads array */

We can use bitfields for direction and index. That way we can also easily add
other flags/attributes.

> +};
> +
> +struct media_entity {
> +	struct list_head list;
> +	struct media_device *parent;	/* Media device this entity belongs to*/
> +	u32 id;				/* Entity ID, unique in the parent media
> +					 * device context */
> +	const char *name;		/* Entity name */
> +	u32 type;			/* Entity type (MEDIA_ENTITY_TYPE_*) */
> +	u32 subtype;			/* Entity subtype (type-specific) */
> +
> +	u8 num_pads;			/* Number of input and output pads */
> +	u8 num_links;			/* Number of existing links, both active
> +					 * and inactive */
> +	u8 num_backlinks;		/* Number of backlinks */
> +	u8 max_links;			/* Maximum number of links */
> +
> +	struct media_entity_pad *pads;	/* Array of pads (num_pads elements) */
> +	struct media_entity_link *links;/* Array of links (max_links elements)*/
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
> +int media_entity_init(struct media_entity *entity, u8 num_pads,
> +		struct media_entity_pad *pads, u8 extra_links);
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
