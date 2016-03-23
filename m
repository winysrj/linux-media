Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:56659 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbcCWRG3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2016 13:06:29 -0400
Date: Wed, 23 Mar 2016 14:06:23 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	<linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v5 1/2] media: Add obj_type field to struct media_entity
Message-ID: <20160323140623.39939007@recife.lan>
In-Reply-To: <7243186.ETMcFxAVHJ@avalon>
References: <1458722756-7269-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1938529.9P9zNWsNbc@avalon>
	<20160323122438.101874ba@recife.lan>
	<7243186.ETMcFxAVHJ@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 23 Mar 2016 18:30:47 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> On Wednesday 23 Mar 2016 12:24:38 Mauro Carvalho Chehab wrote:
> > Em Wed, 23 Mar 2016 17:11:30 +0200 Laurent Pinchart escreveu:  
> > > On Wednesday 23 Mar 2016 12:00:59 Mauro Carvalho Chehab wrote:  
> > > > Em Wed, 23 Mar 2016 15:05:41 +0100 Hans Verkuil escreveu:  
> > > >> On 03/23/2016 11:35 AM, Mauro Carvalho Chehab wrote:  
> > > >>> Em Wed, 23 Mar 2016 10:45:55 +0200 Laurent Pinchart escreveu:  
> > > >>>> Code that processes media entities can require knowledge of the
> > > >>>> structure type that embeds a particular media entity instance in
> > > >>>> order to cast the entity to the proper object type. This needs is
> > > >>>> shown by the presence of the is_media_entity_v4l2_io and
> > > >>>> is_media_entity_v4l2_subdev functions.
> > > >>>> 
> > > >>>> The implementation of those two functions relies on the entity
> > > >>>> function field, which is both a wrong and an inefficient design,
> > > >>>> without even mentioning the maintenance issue involved in updating
> > > >>>> the functions every time a new entity function is added. Fix this by
> > > >>>> adding add an obj_type field to the media entity structure to carry
> > > >>>> the information.
> > > >>>> 
> > > >>>> Signed-off-by: Laurent Pinchart
> > > >>>> <laurent.pinchart+renesas@ideasonboard.com>
> > > >>>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > >>>> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > >>>> ---
> > > >>>> 
> > > >>>> drivers/media/media-device.c          |  2 +
> > > >>>> drivers/media/v4l2-core/v4l2-dev.c    |  1 +
> > > >>>> drivers/media/v4l2-core/v4l2-subdev.c |  1 +
> > > >>>> include/media/media-entity.h          | 79  ++++++++++++-----------
> > > >>>> 4 files changed, 46 insertions(+), 37 deletions(-)
> > > >>>> 
> > > >>>> diff --git a/drivers/media/media-device.c
> > > >>>> b/drivers/media/media-device.c
> > > >>>> index 4a97d92a7e7d..88d8de3b7a4f 100644
> > > >>>> --- a/drivers/media/media-device.c
> > > >>>> +++ b/drivers/media/media-device.c
> > > >>>> @@ -580,6 +580,8 @@ int __must_check
> > > >>>> media_device_register_entity(struct media_device *mdev,> >>
> > > >>>> 
> > > >>>>  			 "Entity type for entity %s was not initialized!\n",
> > > >>>>  			 entity->name);
> > > >>>> 
> > > >>>> +	WARN_ON(entity->obj_type == MEDIA_ENTITY_TYPE_INVALID);
> > > >>>> +  
> > > >>> 
> > > >>> This is not ok. There are valid cases where the entity is not
> > > >>> embedded on some other struct. That's the case of
> > > >>> connectors/connections, for example: a connector/connection entity
> > > >>> doesn't need anything else but struct media device.  
> > > >> 
> > > >> Once connectors are enabled, then we do need a
> > > >> MEDIA_ENTITY_TYPE_CONNECTOR or MEDIA_ENTITY_TYPE_STANDALONE or
> > > >> something along those lines.
> > > >>   
> > > >>> Also, this is V4L2 specific. Neither ALSA nor DVB need to use
> > > >>> container_of(). Actually, this won't even work there, as the entity
> > > >>> is stored as a pointer, and not as an embedded data.  
> > > >> 
> > > >> Any other subsystem that *does* embed this can use obj_type. If it
> > > >> doesn't embed it in anything, then MEDIA_ENTITY_TYPE_STANDALONE should
> > > >> be used (or whatever name we give it). I agree that we need a type
> > > >> define for the case where it is not embedded.
> > > >>   
> > > >>> So, if we're willing to do this, then it should, instead, create
> > > >>> something like:
> > > >>> 
> > > >>> struct embedded_media_entity {
> > > >>> 
> > > >>> 	struct media_entity entity;
> > > >>> 	enum media_entity_type obj_type;
> > > >>> 
> > > >>> };  
> > > >> 
> > > >> It's not v4l2 specific. It is just that v4l2 is the only subsystem
> > > >> that requires this information at the moment. I see no reason at all to
> > > >> create such an ugly struct.  
> > > > 
> > > > At the minute we added a BUG_ON() there,  
> > > 
> > > Note that it's a WARN_ON(), not a BUG_ON().  
> > 
> > WARN_ON() should warn about a trouble. This is not the case here.
> > It is only a problem for a few drivers that need to use container_of()
> > to get the container struct..  
> 
> No, the purpose of this WARN_ON() is to catch unitialized obj_type fields. The 
> field must be initialized, otherwise code dealing with entities will fail. 
> Now, if we consider that the MEDIA_ENTITY_TYPE_BASE (to use Hans' proposed 
> name) case is the most common case, and if we would like to avoid forcing all 
> drivers that create entities directly to initialize their type explicitly, we 
> could make that type be equal to 0. I would however prevent us from catching 
> missing initializations, but I could live with that.

Works for me, but, as I said, if you want to enforce, the best is to create
a separate struct for the cases where the entity is embed on some other
object.

> Again, the purpose of the WARN_ON() isn't to enforce a programming model, but 
> to catch missing initialization of an important field.

If this is the case, I'm OK.

> > >> it became mandatory that all struct media_entity to be embedded.  
> > > 
> > > No, it becomes mandatory to initialize the field.  
> > 
> > The current patch makes it mandatory, causing lots of bogus WARN_ON().
> >   
> > >> This is not always true, but as the intention is to avoid the risk of
> > >> embedding it without a type, it makes sense to have the above struct.
> > >> This way, the obj_type usage will be enforced *only* in the places where
> > >> it is needed.
> > >> 
> > >> We could, instead, remove BUG_ON() and make MEDIA_ENTITY_TYPE_STANDALONE
> > >> the default type, but that won't enforce its usage where it is needed.
> > >>   
> > >>> I very strongly suspect that other subsystems will also embed this in
> > >>> their own internal structs.  
> > >> 
> > >> They will if they need.
> > >>   
> > >>> I actually wonder why it isn't embedded in struct dvb_device,
> > >>> but I have to admit that I didn't take a close look at that. The pads
> > >>> are embedded there, so it is somewhat odd that the entity isn't.  
> > >> 
> > >> The only advantage of embedding instead of using a pointer is that
> > >> it would allow to use container_of() to get the struct. On the
> > >> other hand, there's one drawback: both container and embedded
> > >> structs will be destroyed at the same time. This can be a problem
> > >> if the embedded object needs to live longer than the container.
> > >> 
> > >> Also, the usage of container_of() doesn't work fine if the
> > >> container have embedded two objects of the same type.
> > >> 
> > >> In the specific case of DVB, let's imagine we would use the above
> > >> solution and add a MEDIA_ENTITY_TYPE_DVB_DEVICE.
> > >> 
> > >> If you look into struct dvb_device, you'll see that there are
> > >> actually two media_entities on it:
> > >> 
> > >> struct dvb_device {
> > >> ...
> > >>         struct media_entity *entity, *tsout_entity;
> > >> ...
> > >> };
> > >> 
> > >> If we had embedded them, just knowing that the container is
> > >> struct dvb_device won't help, as the offsets for "entity"
> > >> and for "tsout_entity" to get its container would be different.  
> > > 
> > > That's not the issue. The two entities above do not represent the DVB
> > > device, struct dvb_device should certainly not inherit from media_entity.
> > > Those two entities should be embedded in the DVB structures that model
> > > the objects they represented.  
> > 
> > On what structs they should be embedded? There's no subdev concept
> > at the DVB subsystem, and it doesn't make any sense to add it just
> > to make you happy.  
> 
> I'm surprised that there's no DVB kernel objects that model what the entities 
> represent, but if that's indeed the case, there's no need to embed them in 
> anything. They certainly shouldn't be embedded in struct dvb_device, those two 
> entities do *not* represent the DVB decide.

Well, the DVB subsystem doesn't use the I2C bus approach (except for
the tuner, when it is shared with V4L2). It uses the low-level I2C API, 
with leads to a very different way for a DVB driver to work. Basically,
all DVB subdevs directly access the DVB structs, as those are passed
via the binding functions.

Also, some entities are really a piece of a hardware with no distinct
I2C address, or even implemented in software for really cheap devices
(like the DVB soft demux).

Also, in *all* cases, the core is called to create the model of
the objects, using their own standard structs. So, it was easier
to just let the core create the entities at the register functions.

> > >> OK, we could have added two types there, but all of these
> > >> would be just adding uneeded complexity and wound't be error
> > >> prone. Also, there's no need to use container_of(), as a pointer
> > >> to the dvb_device struct is always there at the DVB code.
> > >> 
> > >> The same happens at ALSA code: so far, there's no need to go from a
> > >> media_entity to its container.
> > >> 
> > >> So, as I said before, the usage of container_of() and the need for an
> > >> object type is currently V4L2 specific, and it is due to the way
> > >> the v4l2 core and subdev framework was modeled. Don't expect or
> > >> force that all subsystems would do the same.  
> > > 
> > > It's not a V4L2-specific concept, it's an OOP concept. The fact that the
> > > very few users of media entities outside of V4L2 don't currently embed
> > > struct media_entity doesn't change anything here.  
> > 
> > If there was a consensus at the Kernel that this is something that
> > should be used everywhere, it should have something at the core to
> > handle it.  
> 
> I don't think you can do that in the core in plain C, although it would be 
> useful.

I guess it is possible, but not easy. I remember that some of the early c++
"compilers" that would actually convert the C++ code into a pure C code,
and then compile it. The end result were not nice, IMHO, as cleaning
up memory were done via some sort of garbage collector.

> > Also, the kernel was not written in c++. OOP usage should not be
> > enforced everywhere. It should be used only when there are good
> > reasons for doing it.  
> 
> Those are two orthogonal issues. We're using OOP throughout the whole kernel 
> in C. It requires slightly more verbose coding, but hasn't been an issue so 
> far. OOP doesn't mean and isn't limited to C++.

We use some OOP concepts in the Kernel, where it is helpful.

What I'm against on this patch is that, the way it is, it is forcing
all places to have a struct to embeed media_entity, even where this is
not needed/wanted.

If you remove that WARN_ON() and initialize all media_entities
as _BASE objects, that would work for me.

It would also work if you create a separate struct to enforce that the
obj type will always be filled for the cases it gets embedded.

Regards,
Mauro
