Return-path: <mchehab@gaivota>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:2184 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab0IFQwN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Sep 2010 12:52:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC/PATCH v4 07/11] media: Entities, pads and links enumeration
Date: Mon, 6 Sep 2010 18:51:59 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1282318153-18885-1-git-send-email-laurent.pinchart@ideasonboard.com> <201008281302.22703.hverkuil@xs4all.nl> <201009011605.12172.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201009011605.12172.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009061851.59844.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Wednesday, September 01, 2010 16:05:10 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Saturday 28 August 2010 13:02:22 Hans Verkuil wrote:
> > On Friday, August 20, 2010 17:29:09 Laurent Pinchart wrote:
> 
> [snip]
> 
> > > diff --git a/Documentation/media-framework.txt
> > > b/Documentation/media-framework.txt index 66f7f6c..74a137d 100644
> > > --- a/Documentation/media-framework.txt
> > > +++ b/Documentation/media-framework.txt
> 
> [snip]
> 
> > > +The media_entity_desc structure is defined as
> > > +
> > > +- struct media_entity_desc
> > > +
> > > +__u32	id		Entity id, set by the application. When the id is
> > > +			or'ed with MEDIA_ENTITY_ID_FLAG_NEXT, the driver
> > > +			clears the flag and returns the first entity with a
> > > +			larger id.
> > > +char	name[32]	Entity name. UTF-8 NULL-terminated string.
> > 
> > Why UTF-8 instead of ASCII?
> 
> Because vendor-specific names could include non-ASCII characters (same reason 
> for the model name in the media_device structure, if we decice to make the 
> model name ASCII I'll make the entity name ASCII as well).
> 
> [snip]
> 
> > > +struct media_entity_desc {
> > > +	__u32 id;
> > > +	char name[32];
> > > +	__u32 type;
> > > +	__u32 revision;
> > > +	__u32 flags;
> > > +	__u32 group_id;
> > > +	__u16 pads;
> > > +	__u16 links;
> > > +
> > > +	__u32 reserved[4];
> > > +
> > > +	union {
> > > +		/* Node specifications */
> > > +		struct {
> > > +			__u32 major;
> > > +			__u32 minor;
> > > +		} v4l;
> > > +		struct {
> > > +			__u32 major;
> > > +			__u32 minor;
> > > +		} fb;
> > > +		int alsa;
> > > +		int dvb;
> > > +
> > > +		/* Sub-device specifications */
> > > +		/* Nothing needed yet */
> > > +		__u8 raw[64];
> > > +	};
> > > +};
> > 
> > Should this be a packed struct?
> 
> Why ? :-) Packed struct are most useful when they need to match hardware 
> structures or network protocols. Packing a structure can generate unaligned 
> fields, which are bad performance-wise.

I'm thinking about preventing a compat32 mess as we have for v4l.

It is my understanding that the only way to prevent different struct sizes
between 32 and 64 bit is to use packed.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
