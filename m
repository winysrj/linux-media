Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:46536 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075AbbLHPlQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2015 10:41:16 -0500
Date: Tue, 8 Dec 2015 13:41:00 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v8 31/55] [media] media: add macros to check if subdev
 or V4L2 DMA
Message-ID: <20151208134100.11e9def3@recife.lan>
In-Reply-To: <24575825.N6z5OZzxrl@avalon>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
	<a811ed07aab2bf1410ffe4c438fcbd4149581290.1441540862.git.mchehab@osg.samsung.com>
	<24575825.N6z5OZzxrl@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 06 Dec 2015 04:20:38 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Sunday 06 September 2015 09:02:57 Mauro Carvalho Chehab wrote:
> > As we'll be removing entity subtypes from the Kernel, we need
> > to provide a way for drivers and core to check if a given
> > entity is represented by a V4L2 subdev or if it is an V4L2
> > I/O entity (typically with DMA).
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index 4e36b1f2b2d7..220864319d21 100644
> > --- a/include/media/media-entity.h
> > +++ b/include/media/media-entity.h
> > @@ -220,6 +220,39 @@ static inline u32 media_gobj_gen_id(enum
> > media_gobj_type type, u32 local_id) return id;
> >  }
> > 
> > +static inline bool is_media_entity_v4l2_io(struct media_entity *entity)
> > +{
> > +	if (!entity)
> > +		return false;
> > +
> > +	switch (entity->type) {
> > +	case MEDIA_ENT_T_V4L2_VIDEO:
> > +	case MEDIA_ENT_T_V4L2_VBI:
> > +	case MEDIA_ENT_T_V4L2_SWRADIO:
> > +		return true;
> > +	default:
> > +		return false;
> > +	}
> > +}
> > +
> > +static inline bool is_media_entity_v4l2_subdev(struct media_entity *entity)
> > +{
> > +	if (!entity)
> > +		return false;
> > +
> > +	switch (entity->type) {
> > +	case MEDIA_ENT_T_V4L2_SUBDEV_SENSOR:
> > +	case MEDIA_ENT_T_V4L2_SUBDEV_FLASH:
> > +	case MEDIA_ENT_T_V4L2_SUBDEV_LENS:
> > +	case MEDIA_ENT_T_V4L2_SUBDEV_DECODER:
> > +	case MEDIA_ENT_T_V4L2_SUBDEV_TUNER:
> 
> I'm sorry but this simply won't scale. We need a better way to determine the 
> entity type, and this could be a valid use case to actually retain an entity 
> type field separate from the function, at least inside the kernel.

As we're getting rid of a separate range for V4L2 subdevs, several drivers
need some logic to identify if an entity is a subdev or not. So, no matter
how we implement it, we need a is_media_entity_v4l2_subdev() function.

So, I guess you're discussing the actual implementation, not the need of
such function.

With that regards, I'm not sure if this won't scale. The gcc compiler 
optimizer usually uses binary search on switches. So, O(log(n)). 
Even if we had 256 subdev types, that would mean 8 ifs. Doesn't seem
too bad, specially since we have right now only 5 subdev types.

Ok, there's one thing bad on this: we need to update this function every
time a new V4L2 subdev is added. So, it may be a maintainance nightmare,
but I don't see any way to avoid the need of adding the subdevs at both
UAPI and kernelspace.

I'm not opposed to change this to some other method that we would find.
In any case, this is inside an inlined function. So, it is easy to
replace the implementation to any other logic we find better. So,
if you have a better idea, feel free to submit a followup patch
optimizing it.

Regards,
Mauro
