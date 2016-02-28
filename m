Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42659 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970AbcB1TJm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2016 14:09:42 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH] media: Add type field to struct media_entity
Date: Sun, 28 Feb 2016 21:09:49 +0200
Message-ID: <7962216.zi3BEj9HKN@avalon>
In-Reply-To: <56D05A66.2010207@xs4all.nl>
References: <1456105996-20845-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <20160226102141.01afcda6@recife.lan> <56D05A66.2010207@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 26 February 2016 15:00:06 Hans Verkuil wrote:
> On 02/26/2016 02:21 PM, Mauro Carvalho Chehab wrote:
> > Em Fri, 26 Feb 2016 13:18:30 +0200 Laurent Pinchart escreveu:
> >> On Monday 22 February 2016 23:20:58 Sakari Ailus wrote:
> >>> On Mon, Feb 22, 2016 at 06:46:01AM -0300, Mauro Carvalho Chehab wrote:
> >>>> Em Mon, 22 Feb 2016 03:53:16 +0200 Laurent Pinchart escreveu:
> >>>>> Code that processes media entities can require knowledge of the
> >>>>> structure type that embeds a particular media entity instance in order
> >>>>> to use the API provided by that structure. This needs is shown by the
> >>>>> presence of the is_media_entity_v4l2_io and
> >>>>> is_media_entity_v4l2_subdev
> >>>>> functions.
> >>>>> 
> >>>>> The implementation of those two functions relies on the entity
> >>>>> function field, which is both a wrong and an inefficient design,
> >>>>> without even
> >>> 
> >>> I wouldn't necessarily say "wrong", but it is risky. A device's function
> >>> not only defines the interface it offers but also which struct is
> >>> considered to contain the media entity. Having a wrong value in the
> >>> function field may thus lead memory corruption and / or system crash.
> >>> 
> >>>>> mentioning the maintenance issue involved in updating the functions
> >>>>> every time a new entity function is added. Fix this by adding add a
> >>>>> type field to the media entity structure to carry the information.
> >>>>> 
> >>>>> Signed-off-by: Laurent Pinchart
> >>>>> <laurent.pinchart+renesas@ideasonboard.com>
> >>>>> ---
> >>>>> 
> >>>>>  drivers/media/v4l2-core/v4l2-dev.c    |  1 +
> >>>>>  drivers/media/v4l2-core/v4l2-subdev.c |  1 +
> >>>>>  include/media/media-entity.h          | 65  +++++++++----------------
> >>>>>  3 files changed, 30 insertions(+), 37 deletions(-)
> >> 
> >> [snip]
> >> 
> >>>>> diff --git a/include/media/media-entity.h
> >>>>> b/include/media/media-entity.h
> >>>>> index fe485d367985..2be38483f3a4 100644
> >>>>> --- a/include/media/media-entity.h
> >>>>> +++ b/include/media/media-entity.h
> >>>>> @@ -187,10 +187,27 @@ struct media_entity_operations {
> >>>>>  };
> >>>>>  
> >>>>>  /**
> >>>>> + * enum MEDIA_ENTITY_TYPE_NONE - Media entity type
> >>>>> + *
> >>>> 
> >>>> s/MEDIA_ENTITY_TYPE_NONE/media_entity_type/
> >>>> 
> >>>> (it seems you didn't test producing the docbook, otherwise you would
> >>>> have seen this error - Please always generate the docbook when the
> >>>> patch contains kernel-doc markups)
> >> 
> >> Oops, sorry. I'll fix that.
> >> 
> >>>> I don't like the idea of calling it as "type", as this is confusing,
> >>>> specially since we used to call entity.type for what we now call
> >>>> function.
> >>> 
> >>> What that field essentially defines is which struct embeds the media
> >>> entity. (Well, there's some cleanups to be done there, as we have extra
> >>> entity for V4L2 subdevices, but that's another story.)
> >>> 
> >>> The old type field had that information, plus the "function" of the
> >>> entity.
> >>> 
> >>> I think "type" isn't a bad name for this field, as what we would really
> >>> need is inheritance. It refers to the object type. What would you think
> >>> of "class"?
> >> 
> >> I'd prefer type as class has other meanings in the kernel, but I can live
> >> with it. Mauro, I agree with Sakari here, what the field contains is
> >> really the object type in an object-oriented programming context.
> > 
> > Well, as we could have entities not embedded on some other object, this
> > is actually not an object type, even on OO programming. What we're
> > actually representing here is a graph object class.
> > 
> > The problem is that "type" is a very generic term, and, as we used it
> > before with some other meaning, so I prefer to call it as something else.
> > 
> > I'm ok with any other name, although I agree that Kernel uses "class" for
> > other things. Maybe gr_class or obj_class?
> 
> I had to think about this a bit, but IMHO it is an entity classification
> that a subsystem sets when creating the entity.
>
> So v4l2 has the classifications V4L2_SUBDEV and V4L2_IO. And while all
> entities of the V4L2_SUBDEV classification are indeed embedded in a struct
> v4l2_subdev, that is not true for V4L2_IO (radio interface entities are
> embedded in struct video_device, but are not of the V4L2_IO class).
> 
> Other subsystems may need other classifications.
> 
> So what about this:
> 
> enum media_entity_class {
> 	MEDIA_ENTITY_CLASS_UNDEFINED, // Actually, CLASS_NONE would work here too
> 	MEDIA_ENTITY_CLASS_V4L2_IO,
> 	MEDIA_ENTITY_CLASS_V4L2_SUBDEV,
> };

The purpose of the type is solely to identify the type of the media_entity 
instance to safely cast it to the proper object type (in an OOP sense). That's 
what I want the name of the field to describe. It's not about a 
classification, it's about object instance type identification.

>From that point of view, the V4L2_IO class/type is wrong. We want to tell that 
the entity instance is a video_device instance (and given that we use C, this 
OOP construct is implemented by embedding the struct media_entity in a struct 
video_device). We really want VIDEO_DEVICE here, there is no struct v4l2_io.

> and the field enum media_entity_class class; in struct media_entity with
> documentation:
> 
> @class:	Classification of the media_entity, subsystems can set this to
> quickly classify what sort of media_entity this is.

-- 
Regards,

Laurent Pinchart

