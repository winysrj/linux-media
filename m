Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4431 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932190Ab0GSNFd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 09:05:33 -0400
Message-ID: <148732859b96b07f91731de2c1739db5.squirrel@webmail.xs4all.nl>
In-Reply-To: <201007191413.01447.laurent.pinchart@ideasonboard.com>
References: <1279114219-27389-1-git-send-email-laurent.pinchart@ideasonboard.com>
    <1279114219-27389-4-git-send-email-laurent.pinchart@ideasonboard.com>
    <201007181353.51944.hverkuil@xs4all.nl>
    <201007191413.01447.laurent.pinchart@ideasonboard.com>
Date: Mon, 19 Jul 2010 15:05:28 +0200
Subject: Re: [RFC/PATCH 03/10] media: Entities, pads and links
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hi Hans,
>
> Thanks for the review.
>
> On Sunday 18 July 2010 13:53:51 Hans Verkuil wrote:
>> On Wednesday 14 July 2010 15:30:12 Laurent Pinchart wrote:
>
> [snip]
>
>> > +Links have flags that describe the link capabilities and state.
>> > +
>> > +	MEDIA_LINK_FLAG_ACTIVE indicates that the link is active and can be
>> > +	used to transfer media data. When two or more links target a sink
>> pad,
>> > +	only one of them can be active at a time.
>> > +	MEDIA_LINK_FLAG_IMMUTABLE indicates that the link active state can't
>> > +	be modified at runtime. An immutable link is always active.
>>
>> I would rephrase the last sentence to:
>>
>> If MEDIA_LINK_FLAG_IMMUTABLE is set, then MEDIA_LINK_FLAG_ACTIVE must
>> also
>> be set since an immutable link is always active.
>
> OK, I'll change that.
>
> [snip]
>
>> > diff --git a/include/media/media-entity.h
>> b/include/media/media-entity.h
>> > new file mode 100644
>> > index 0000000..0929a90
>> > --- /dev/null
>> > +++ b/include/media/media-entity.h
>> > @@ -0,0 +1,79 @@
>> > +#ifndef _MEDIA_ENTITY_H
>> > +#define _MEDIA_ENTITY_H
>> > +
>> > +#include <linux/list.h>
>> > +
>> > +#define MEDIA_ENTITY_TYPE_NODE		1
>> > +#define MEDIA_ENTITY_TYPE_SUBDEV	2
>> > +
>> > +#define MEDIA_NODE_TYPE_V4L		1
>> > +#define MEDIA_NODE_TYPE_FB		2
>> > +#define MEDIA_NODE_TYPE_ALSA		3
>> > +#define MEDIA_NODE_TYPE_DVB		4
>> > +
>> > +#define MEDIA_SUBDEV_TYPE_VID_DECODER	1
>> > +#define MEDIA_SUBDEV_TYPE_VID_ENCODER	2
>> > +#define MEDIA_SUBDEV_TYPE_MISC		3
>>
>> Are these the subtypes? If so, I would rename this to
>> MEDIA_ENTITY_SUBTYPE_VID_DECODER, etc.
>
> Those are subtypes relative to the node and subdev types. Their name
> should
> thus start with the type they refer to. What about
>
> MEDIA_ENTITY_SUBTYPE_NODE_V4L
> MEDIA_ENTITY_SUBTYPE_NODE_FB
> MEDIA_ENTITY_SUBTYPE_NODE_ALSA
> MEDIA_ENTITY_SUBTYPE_NODE_DVB
>
> MEDIA_ENTITY_SUBTYPE_SUBDEV_VID_DECODER
> MEDIA_ENTITY_SUBTYPE_SUBDEV_VID_ENCODER
> MEDIA_ENTITY_SUBTYPE_SUBDEV_MISC
>
> It might be a bit long though.

Perhaps, but now I understand it. I really didn't get the original names.

> The subdev subtypes need more attention. I don't think that video decoder,
> video encoder and misc are good enough. Maybe some kind of capabilities
> bitflag would be better.

I don't think so. The problem with bitflags is that you run out of them so
quickly. We definitely need more subtypes, though, but we can just add
them as needed.

>
>> > +#define MEDIA_LINK_FLAG_ACTIVE		(1 << 0)
>> > +#define MEDIA_LINK_FLAG_IMMUTABLE	(1 << 1)
>> > +
>> > +#define MEDIA_PAD_TYPE_INPUT		1
>> > +#define MEDIA_PAD_TYPE_OUTPUT		2
>> > +
>> > +struct media_entity_link {
>> > +	struct media_entity_pad *source;/* Source pad */
>> > +	struct media_entity_pad *sink;	/* Sink pad  */
>> > +	struct media_entity_link *other;/* Link in the reverse direction */
>> > +	u32 flags;			/* Link flags (MEDIA_LINK_FLAG_*) */
>> > +};
>> > +
>> > +struct media_entity_pad {
>> > +	struct media_entity *entity;	/* Entity this pad belongs to */
>> > +	u32 type;			/* Pad type (MEDIA_PAD_TYPE_*) */
>> > +	u32 index;			/* Pad index in the entity pads array */
>>
>> u32 seems unnecessarily wasteful. u8 should be sufficient.
>
> OK.
>
>> I don't really like the name 'type'. Why not 'dir' for direction?
>>
>> Another reason for not using the name 'type' for this is that I think we
>> need an actual 'type' field that describes the type of data being
>> streamed
>> to/from the pad. While for now we mainly have video pads, we may also
>> get
>> audio pads and perhaps vbi pads as well.
>
> Agreed. Do you think we should have a capabilities bitflag ? The direction
> could be encoded as 2 bits, one for input and one for output.

I don't really like that. It makes for awkward ANDs in the code whenever
you need to detect the direction.

If this is only used internally, then we might consider using a bitfield.
That would work as well.

Regards.

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

