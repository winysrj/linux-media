Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:23507 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab0GZQ5Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jul 2010 12:57:25 -0400
Message-ID: <4C4DBE64.4040107@maxwell.research.nokia.com>
Date: Mon, 26 Jul 2010 19:57:08 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [RFC/PATCH v2 03/10] media: Entities, pads and links
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com> <1279722935-28493-4-git-send-email-laurent.pinchart@ideasonboard.com> <201007241418.11463.hverkuil@xs4all.nl> <201007261838.29490.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201007261838.29490.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Hi Hans,

Hi,

> On Saturday 24 July 2010 14:18:11 Hans Verkuil wrote:
>> On Wednesday 21 July 2010 16:35:28 Laurent Pinchart wrote:
...
>>> +
>>> +#define MEDIA_LINK_FLAG_ACTIVE				(1 << 0)
>>> +#define MEDIA_LINK_FLAG_IMMUTABLE			(1 << 1)
>>> +
>>> +#define MEDIA_PAD_DIR_INPUT				1
>>> +#define MEDIA_PAD_DIR_OUTPUT				2
>>> +
>>> +struct media_entity_link {
>>> +	struct media_entity_pad *source;/* Source pad */
>>> +	struct media_entity_pad *sink;	/* Sink pad  */
>>> +	struct media_entity_link *other;/* Link in the reverse direction */
>>> +	u32 flags;			/* Link flags (MEDIA_LINK_FLAG_*) */
>>> +};
>>> +
>>> +struct media_entity_pad {
>>> +	struct media_entity *entity;	/* Entity this pad belongs to */
>>> +	u32 direction;			/* Pad direction (MEDIA_PAD_DIR_*) */
>>> +	u8 index;			/* Pad index in the entity pads array */
>>
>> We can use bitfields for direction and index. That way we can also easily
>> add other flags/attributes.
> 
> You proposed to merge the direction field into a new flags field, I suppose 
> that should be done here too for consistency. Having 16 flags might be a bit 
> low though, 32 would be better. If you want to keep 16 bits for now, maybe we 
> should have 2 reserved __u32 instead of one.

I think we could have some more reserved fields than just one or two.
Nothing can replace reserved fields when you do need them.

Think of supporting dynamic format changes across a streaming pipeline,
for example. That might not happen ever, but once the hardware support
is there it might be something to think about.

Haven't exactly heard of problems of having too many of the reserved
fields, too few, yes! :-)

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
