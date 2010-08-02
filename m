Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:43194 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab0HBOFS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 10:05:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC/PATCH v3 03/10] media: Entities, pads and links
Date: Mon, 2 Aug 2010 16:05:14 +0200
Cc: linux-media@vger.kernel.org
References: <1280419616-7658-1-git-send-email-laurent.pinchart@ideasonboard.com> <1280419616-7658-4-git-send-email-laurent.pinchart@ideasonboard.com> <4C52DAFF.2060409@maxwell.research.nokia.com>
In-Reply-To: <4C52DAFF.2060409@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008021605.14675.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Friday 30 July 2010 16:00:31 Sakari Ailus wrote:
> Laurent Pinchart wrote:

[snip]

> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > new file mode 100644
> > index 0000000..37a25bf
> > --- /dev/null
> > +++ b/include/media/media-entity.h
> > @@ -0,0 +1,85 @@
> > +#ifndef _MEDIA_ENTITY_H
> > +#define _MEDIA_ENTITY_H
> > +
> > +#include <linux/list.h>
> > +
> > +#define MEDIA_ENTITY_TYPE_NODE			(1 << 16)
> 
> About that 16 there, could that be replaced by a #define instead? Like
> MEDIA_ENTITY_TYPE_SHIFT? (I don't think we'd need
> MEDIA_ENTITY_SUBTYPE_SHIFT.)

Agreed.

> > +#define MEDIA_ENTITY_TYPE_NODE_V4L		(MEDIA_ENTITY_TYPE_NODE + 1)
> > +#define MEDIA_ENTITY_TYPE_NODE_FB		(MEDIA_ENTITY_TYPE_NODE + 2)
> > +#define MEDIA_ENTITY_TYPE_NODE_ALSA		(MEDIA_ENTITY_TYPE_NODE + 3)
> > +#define MEDIA_ENTITY_TYPE_NODE_DVB		(MEDIA_ENTITY_TYPE_NODE + 4)
> > +
> > +#define MEDIA_ENTITY_TYPE_SUBDEV		(2 << 16)
> > +#define MEDIA_ENTITY_TYPE_SUBDEV_VID_DECODER	(MEDIA_ENTITY_TYPE_SUBDEV +
> > 1) +#define
> > MEDIA_ENTITY_TYPE_SUBDEV_VID_ENCODER	(MEDIA_ENTITY_TYPE_SUBDEV + 2)
> > +#define MEDIA_ENTITY_TYPE_SUBDEV_MISC		(MEDIA_ENTITY_TYPE_SUBDEV + 3) 
+
> > +#define MEDIA_LINK_FLAG_ACTIVE			(1 << 0)
> > +#define MEDIA_LINK_FLAG_IMMUTABLE		(1 << 1)
> > +
> > +#define MEDIA_PAD_FLAG_INPUT			(1 << 0)
> > +#define MEDIA_PAD_FLAG_OUTPUT			(1 << 1)
> > +
> > +struct media_link {
> > +	struct media_pad *source;	/* Source pad */
> > +	struct media_pad *sink;		/* Sink pad  */
> > +	struct media_link *other;	/* Link in the reverse direction */
> > +	unsigned long flags;		/* Link flags (MEDIA_LINK_FLAG_*) */
> > +};
> > +
> > +struct media_pad {
> > +	struct media_entity *entity;	/* Entity this pad belongs to */
> > +	u16 index;			/* Pad index in the entity pads array */
> > +	unsigned long flags;		/* Pad flags (MEDIA_PAD_FLAG_*) */
> > +};
> > +
> > +struct media_entity {
> > +	struct list_head list;
> > +	struct media_device *parent;	/* Media device this entity belongs to*/
> > +	u32 id;				/* Entity ID, unique in the parent media
> > +					 * device context */
> > +	const char *name;		/* Entity name */
> > +	u32 type;			/* Entity type (MEDIA_ENTITY_TYPE_*) */
> > +
> > +	u8 num_pads;			/* Number of input and output pads */
> 
> Hans suggested u16 for pads. This is a kernel structure but still it'd
> be good to keep them the same IMO, even if that u16 was there for the
> future.
> 
> u8 is used on some function arguments as well for these purposes.

Will fix.

> > +	u8 num_links;			/* Number of existing links, both active
> > +					 * and inactive */
> > +	u8 num_backlinks;		/* Number of backlinks */
> > +	u8 max_links;			/* Maximum number of links */
> 
> Same for these.

Agreed. The number of links is expected to be >= number of pads. I'll change 
num_links, num_backlinks and max_links to u16 as well.

> > +	struct media_pad *pads;		/* Pads array (num_pads elements) */
> > +	struct media_link *links;	/* Links array (max_links elements)*/
> > +
> > +	union {
> > +		/* Node specifications */
> > +		struct {
> > +			u32 major;
> > +			u32 minor;
> 
> How about dev_t here?

dev_t doesn't seem to be a public kernel type.

> > +		} v4l;
> > +		struct {
> > +			u32 major;
> > +			u32 minor;
> 
> And here.
> 
> > +		} fb;
> > +		int alsa;
> > +		int dvb;
> > +
> > +		/* Sub-device specifications */
> > +		/* Nothing needed yet */
> > +	};
> > +};

-- 
Regards,

Laurent Pinchart
