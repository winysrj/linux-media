Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:56674 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756317AbcCWR3q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2016 13:29:46 -0400
Date: Wed, 23 Mar 2016 14:29:35 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	<linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v5 1/2] media: Add obj_type field to struct media_entity
Message-ID: <20160323142935.68d417be@recife.lan>
In-Reply-To: <4580235.WOIJ26Ec16@avalon>
References: <1458722756-7269-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<56F2AEC6.4030209@xs4all.nl>
	<20160323121730.089fab87@recife.lan>
	<4580235.WOIJ26Ec16@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 23 Mar 2016 17:41:44 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> On Wednesday 23 Mar 2016 12:17:30 Mauro Carvalho Chehab wrote:
> > Em Wed, 23 Mar 2016 15:57:10 +0100 Hans Verkuil escreveu:  
> > > On 03/23/2016 03:45 PM, Laurent Pinchart wrote:  
> > >> On Wednesday 23 Mar 2016 15:05:41 Hans Verkuil wrote:  
> > >>> On 03/23/2016 11:35 AM, Mauro Carvalho Chehab wrote:  
> > >>>> Em Wed, 23 Mar 2016 10:45:55 +0200 Laurent Pinchart escreveu:  
> > >>>>> Code that processes media entities can require knowledge of the
> > >>>>> structure type that embeds a particular media entity instance in
> > >>>>> order
> > >>>>> to cast the entity to the proper object type. This needs is shown by
> > >>>>> the
> > >>>>> presence of the is_media_entity_v4l2_io and
> > >>>>> is_media_entity_v4l2_subdev
> > >>>>> functions.
> > >>>>> 
> > >>>>> The implementation of those two functions relies on the entity
> > >>>>> function
> > >>>>> field, which is both a wrong and an inefficient design, without even
> > >>>>> mentioning the maintenance issue involved in updating the functions
> > >>>>> every time a new entity function is added. Fix this by adding add an
> > >>>>> obj_type field to the media entity structure to carry the
> > >>>>> information.
> > >>>>> 
> > >>>>> Signed-off-by: Laurent Pinchart
> > >>>>> <laurent.pinchart+renesas@ideasonboard.com>
> > >>>>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > >>>>> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > >>>>> ---
> > >>>>> 
> > >>>>>  drivers/media/media-device.c          |  2 +
> > >>>>>  drivers/media/v4l2-core/v4l2-dev.c    |  1 +
> > >>>>>  drivers/media/v4l2-core/v4l2-subdev.c |  1 +
> > >>>>>  include/media/media-entity.h          | 79 ++++++++++++-------------
> > >>>>>  4 files changed, 46 insertions(+), 37 deletions(-)
> > >>>>> 
> > >>>>> diff --git a/drivers/media/media-device.c
> > >>>>> b/drivers/media/media-device.c
> > >>>>> index 4a97d92a7e7d..88d8de3b7a4f 100644
> > >>>>> --- a/drivers/media/media-device.c
> > >>>>> +++ b/drivers/media/media-device.c
> > >>>>> @@ -580,6 +580,8 @@ int __must_check
> > >>>>> media_device_register_entity(struct
> > >>>>> media_device *mdev,
> > >>>>> 
> > >>>>>  			 "Entity type for entity %s was not initialized!\n",
> > >>>>>  			 entity->name);
> > >>>>> 
> > >>>>> +	WARN_ON(entity->obj_type == MEDIA_ENTITY_TYPE_INVALID);
> > >>>>> +  
> > >>>> 
> > >>>> This is not ok. There are valid cases where the entity is not embedded
> > >>>> on some other struct. That's the case of connectors/connections, for
> > >>>> example: a connector/connection entity doesn't need anything else but
> > >>>> struct media device.  
> > >>> 
> > >>> Once connectors are enabled, then we do need a
> > >>> MEDIA_ENTITY_TYPE_CONNECTOR
> > >>> or MEDIA_ENTITY_TYPE_STANDALONE or something along those lines.  
> > >> 
> > >> MEDIA_ENTITY_TYPE_CONNECTOR would make sense, but only if we add a
> > >> struct media_connector. I believe that can be a good idea, at least to
> > >> simplify management of the entity and the connector pad(s).
> > >>   
> > >>>> Also, this is V4L2 specific. Neither ALSA nor DVB need to use
> > >>>> container_of(). Actually, this won't even work there, as the entity is
> > >>>> stored as a pointer, and not as an embedded data.  
> > >> 
> > >> That's sounds like a strange design decision at the very least. There
> > >> can be valid cases that require creation of bare entities, but I don't
> > >> think they should be that common.  
> > 
> > This is where we disagree.
> > 
> > Basically the problem we have is that we have something like:
> > 
> > struct container {
> > 	struct object obj;
> > };
> > 
> > or
> > 
> > struct container {
> > 	struct object *obj;
> > };
> > 
> > 
> > The normal usage is the way both DVB and ALSA currently does: they
> > always go from the container to the obj:
> > 
> > 	obj = container.obj;
> > or
> > 	obj = container->obj;
> > 
> > Anyway, either embeeding or usin a pointer, for such usage, there's no
> > need for an "obj_type".
> > 
> > At some V4L2 drivers, however, it is needed to do something like:
> > 
> > if (obj_type == MEDIA_TYPE_FOO)
> > 	container_foo = container_of(obj, struct container_foo, obj);
> > 
> > if (obj_type == MEDIA_TYPE_BAR)
> > 	container_bar = container_of(obj, struct container_bar, obj);
> > 
> > Ok, certainly there are cases where this could be unavoidable, but it is
> > *ugly*.
> > 
> > The way DVB uses it is a way cleaner, as never needs to use
> > container_of(), as the container struct is always known. Also, there's
> > no need to embed the struct.  
> 
> No, no, no and no. Looks like it's time for a bit of Object Oriented 
> Programming 101.

I know what you're doing. I had my usual workload of programs 
in c++ programming.

> Casting from a superclass (a.k.a. base class) type to a subclass type is a 
> basic programming concept found in most languages that deal with objects. It 
> allows creating collections of objects of different subclasses than all 
> inherit from the same base class, handle them with generic code and still 
> offer the ability for custom processing when needed.
> 
> C++ implements this concept with the dynamic_cast<> operator. As the kernel is 
> written in plain C we use container_of() instead for the same purpose, and 
> need explicit object types to perform RTTI.

I'm not arguing against the c++ theory, but, instead, about its
implementation.

On (almost?) all cases where we use container_of() in the Kernel, the
container type is already known. So, drivers just use container_of()
without any if/switch().

That's OK.

What's different in this usecase is that the driver that needs to
use container_of() doesn't know the type of the object that it
is needing to reference. So, it has things like[1]:

        while (pad) {
                if (!is_media_entity_v4l2_subdev(pad->entity))
                       	break;

		subdev = container_of(pad->entity, struct v4l2_subdev, entity)
                entity = container_of(subdev, struct vsp1_entity, subdev);
...
	}

[1] I changed the code snippet a little bit to show the container_of()
that would be otherwise hidden by a function call.

This is needed only because the loop doesn't know if the pad->entity
may not be contained inside struct v4l2_subdev.

While the above *works*, it is, IMHO, ugly, as, if the type is not
properly set, it will cause an horrible crash.

I bet you won't find too many places with similar tests at the Kernel.

On most places, what you'll find is just:

	function xxx(struct foo)
	{
		struct bar = container_of(obj, foo, obj);

without any ifs.

Yet, while I don't like the if's before container_of() and I would
avoid doing that on my own code, I see why you need it, and I'm ok
with that.

Thanks,
Mauro
