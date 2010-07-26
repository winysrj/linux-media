Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:44283 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab0GZQh4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jul 2010 12:37:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH v2 03/10] media: Entities, pads and links
Date: Mon, 26 Jul 2010 18:38:28 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com> <1279722935-28493-4-git-send-email-laurent.pinchart@ideasonboard.com> <201007241418.11463.hverkuil@xs4all.nl>
In-Reply-To: <201007241418.11463.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201007261838.29490.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Saturday 24 July 2010 14:18:11 Hans Verkuil wrote:
> On Wednesday 21 July 2010 16:35:28 Laurent Pinchart wrote:
> 
> <snip>
> 
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > new file mode 100644
> > index 0000000..fd44647
> > --- /dev/null
> > +++ b/include/media/media-entity.h
> > @@ -0,0 +1,79 @@
> > +#ifndef _MEDIA_ENTITY_H
> > +#define _MEDIA_ENTITY_H
> > +
> > +#include <linux/list.h>
> > +
> > +#define MEDIA_ENTITY_TYPE_NODE				1
> > +#define MEDIA_ENTITY_TYPE_SUBDEV			2
> > +
> > +#define MEDIA_ENTITY_SUBTYPE_NODE_V4L			1
> > +#define MEDIA_ENTITY_SUBTYPE_NODE_FB			2
> > +#define MEDIA_ENTITY_SUBTYPE_NODE_ALSA			3
> > +#define MEDIA_ENTITY_SUBTYPE_NODE_DVB			4
> > +
> > +#define MEDIA_ENTITY_SUBTYPE_SUBDEV_VID_DECODER		1
> > +#define MEDIA_ENTITY_SUBTYPE_SUBDEV_VID_ENCODER		2
> > +#define MEDIA_ENTITY_SUBTYPE_SUBDEV_MISC		3
> 
> These names are too awkward.
> 
> I see two options:
> 
> 1) Rename the type field to 'entity' and the macros to
> MEDIA_ENTITY_NODE/SUBDEV. Also rename subtype to type and the macros to
> MEDIA_ENTITY_TYPE_NODE_V4L and MEDIA_ENTITY_TYPE_SUBDEV_VID_DECODER. We
> might even get away with dropping _TYPE from the macro name.
> 
> 2) Merge type and subtype to a single entity field. The top 16 bits are the
> entity type, the bottom 16 bits are the subtype. That way you end up with:
> 
> #define MEDIA_ENTITY_NODE			(1 << 16)
> #define MEDIA_ENTITY_SUBDEV			(2 << 16)
> 
> #define MEDIA_ENTITY_NODE_V4L			(MEDIA_ENTITY_NODE + 1)
> 
> #define MEDIA_ENTITY_SUBDEV_VID_DECODER		(MEDIA_ENTITY_SUBDEV + 1)
> 
> I rather like this option myself.

I like option 2 better, but I would keep the field name "type" instead of 
"entity". Constants could start with MEDIA_ENTITY_TYPE_, or just MEDIA_ENTITY_ 
(I think I would prefer MEDIA_ENTITY_TYPE_).

> > +
> > +#define MEDIA_LINK_FLAG_ACTIVE				(1 << 0)
> > +#define MEDIA_LINK_FLAG_IMMUTABLE			(1 << 1)
> > +
> > +#define MEDIA_PAD_DIR_INPUT				1
> > +#define MEDIA_PAD_DIR_OUTPUT				2
> > +
> > +struct media_entity_link {
> > +	struct media_entity_pad *source;/* Source pad */
> > +	struct media_entity_pad *sink;	/* Sink pad  */
> > +	struct media_entity_link *other;/* Link in the reverse direction */
> > +	u32 flags;			/* Link flags (MEDIA_LINK_FLAG_*) */
> > +};
> > +
> > +struct media_entity_pad {
> > +	struct media_entity *entity;	/* Entity this pad belongs to */
> > +	u32 direction;			/* Pad direction (MEDIA_PAD_DIR_*) */
> > +	u8 index;			/* Pad index in the entity pads array */
> 
> We can use bitfields for direction and index. That way we can also easily
> add other flags/attributes.

You proposed to merge the direction field into a new flags field, I suppose 
that should be done here too for consistency. Having 16 flags might be a bit 
low though, 32 would be better. If you want to keep 16 bits for now, maybe we 
should have 2 reserved __u32 instead of one.

> > +};
> > +

-- 
Regards,

Laurent Pinchart
