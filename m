Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39539 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbcCXIPZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 04:15:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v5 1/2] media: Add obj_type field to struct media_entity
Date: Thu, 24 Mar 2016 10:15:24 +0200
Message-ID: <1531138.5SJC8n9jCF@avalon>
In-Reply-To: <20160323142935.68d417be@recife.lan>
References: <1458722756-7269-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <4580235.WOIJ26Ec16@avalon> <20160323142935.68d417be@recife.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 23 Mar 2016 14:29:35 Mauro Carvalho Chehab wrote:
> Em Wed, 23 Mar 2016 17:41:44 +0200 Laurent Pinchart escreveu:
> > On Wednesday 23 Mar 2016 12:17:30 Mauro Carvalho Chehab wrote:
> >> Em Wed, 23 Mar 2016 15:57:10 +0100 Hans Verkuil escreveu:
> >>> On 03/23/2016 03:45 PM, Laurent Pinchart wrote:
> >>>> On Wednesday 23 Mar 2016 15:05:41 Hans Verkuil wrote:
> >>>>> On 03/23/2016 11:35 AM, Mauro Carvalho Chehab wrote:

[snip]

> >>>>>> Also, this is V4L2 specific. Neither ALSA nor DVB need to use
> >>>>>> container_of(). Actually, this won't even work there, as the entity
> >>>>>> is stored as a pointer, and not as an embedded data.
> >>>> 
> >>>> That's sounds like a strange design decision at the very least. There
> >>>> can be valid cases that require creation of bare entities, but I
> >>>> don't think they should be that common.
> >> 
> >> This is where we disagree.
> >> 
> >> Basically the problem we have is that we have something like:
> >> 
> >> struct container {
> >> 	struct object obj;
> >> };
> >> 
> >> or
> >> 
> >> struct container {
> >> 	struct object *obj;
> >> };
> >> 
> >> 
> >> The normal usage is the way both DVB and ALSA currently does: they
> >> 
> >> always go from the container to the obj:
> >> 	obj = container.obj;
> >> 
> >> or
> >> 
> >> 	obj = container->obj;
> >> 
> >> Anyway, either embeeding or usin a pointer, for such usage, there's no
> >> need for an "obj_type".
> >> 
> >> At some V4L2 drivers, however, it is needed to do something like:
> >> 
> >> if (obj_type == MEDIA_TYPE_FOO)
> >> 	container_foo = container_of(obj, struct container_foo, obj);
> >> 
> >> if (obj_type == MEDIA_TYPE_BAR)
> >> 	container_bar = container_of(obj, struct container_bar, obj);
> >> 
> >> Ok, certainly there are cases where this could be unavoidable, but it is
> >> *ugly*.
> >> 
> >> The way DVB uses it is a way cleaner, as never needs to use
> >> container_of(), as the container struct is always known. Also, there's
> >> no need to embed the struct.
> > 
> > No, no, no and no. Looks like it's time for a bit of Object Oriented
> > Programming 101.
> 
> I know what you're doing. I had my usual workload of programs
> in c++ programming.
> 
> > Casting from a superclass (a.k.a. base class) type to a subclass type is a
> > basic programming concept found in most languages that deal with objects.
> > It allows creating collections of objects of different subclasses than
> > all inherit from the same base class, handle them with generic code and
> > still offer the ability for custom processing when needed.
> > 
> > C++ implements this concept with the dynamic_cast<> operator. As the
> > kernel is written in plain C we use container_of() instead for the same
> > purpose, and need explicit object types to perform RTTI.
> 
> I'm not arguing against the c++ theory, but, instead, about its
> implementation.
> 
> On (almost?) all cases where we use container_of() in the Kernel, the
> container type is already known. So, drivers just use container_of()
> without any if/switch().
> 
> That's OK.
> 
> What's different in this usecase is that the driver that needs to
> use container_of() doesn't know the type of the object that it
> is needing to reference. So, it has things like[1]:
> 
> 	while (pad) {
> 		if (!is_media_entity_v4l2_subdev(pad->entity))
> 			break;
> 
> 		subdev = container_of(pad->entity, struct v4l2_subdev, entity)
> 		entity = container_of(subdev, struct vsp1_entity, subdev);
> ...
> 	}
> 
> [1] I changed the code snippet a little bit to show the container_of()
> that would be otherwise hidden by a function call.
> 
> This is needed only because the loop doesn't know if the pad->entity
> may not be contained inside struct v4l2_subdev.
> 
> While the above *works*, it is, IMHO, ugly, as, if the type is not
> properly set, it will cause an horrible crash.
> 
> I bet you won't find too many places with similar tests at the Kernel.

I believe that the construct will be quite common at least in embedded device 
drivers, and more generically in drivers that use the subdev userspace API, as 
they have a need to go through a pipeline (and thus iterating over 
media_entity instances) and process the entities depending on their type. One 
particular example is pipeline validation code where formats on connected pads 
must be matched, and how to retrieve that format differs between subdevs and 
video nodes.

> On most places, what you'll find is just:
> 
> 	function xxx(struct foo)
> 	{
> 		struct bar = container_of(obj, foo, obj);
> 
> without any ifs.
> 
> Yet, while I don't like the if's before container_of() and I would
> avoid doing that on my own code, I see why you need it, and I'm ok
> with that.

-- 
Regards,

Laurent Pinchart

