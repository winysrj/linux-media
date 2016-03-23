Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:56644 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975AbcCWQrs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2016 12:47:48 -0400
Date: Wed, 23 Mar 2016 13:47:42 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	<linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v5 1/2] media: Add obj_type field to struct media_entity
Message-ID: <20160323134742.5b9b6711@recife.lan>
In-Reply-To: <20160323161738.GJ11084@valkosipuli.retiisi.org.uk>
References: <1458722756-7269-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1458722756-7269-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<20160323073552.18db3b7e@recife.lan>
	<56F2A2B5.80206@xs4all.nl>
	<20160323120059.030a7b61@recife.lan>
	<20160323161738.GJ11084@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 23 Mar 2016 18:17:38 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Wed, Mar 23, 2016 at 12:00:59PM -0300, Mauro Carvalho Chehab wrote:
> > Em Wed, 23 Mar 2016 15:05:41 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >   
> > > On 03/23/2016 11:35 AM, Mauro Carvalho Chehab wrote:  
> > > > Em Wed, 23 Mar 2016 10:45:55 +0200
> > > > Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com> escreveu:
> > > >     
> > > >> Code that processes media entities can require knowledge of the
> > > >> structure type that embeds a particular media entity instance in order
> > > >> to cast the entity to the proper object type. This needs is shown by the
> > > >> presence of the is_media_entity_v4l2_io and is_media_entity_v4l2_subdev
> > > >> functions.
> > > >>
> > > >> The implementation of those two functions relies on the entity function
> > > >> field, which is both a wrong and an inefficient design, without even
> > > >> mentioning the maintenance issue involved in updating the functions
> > > >> every time a new entity function is added. Fix this by adding add an
> > > >> obj_type field to the media entity structure to carry the information.
> > > >>
> > > >> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> > > >> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > >> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > >> ---
> > > >>  drivers/media/media-device.c          |  2 +
> > > >>  drivers/media/v4l2-core/v4l2-dev.c    |  1 +
> > > >>  drivers/media/v4l2-core/v4l2-subdev.c |  1 +
> > > >>  include/media/media-entity.h          | 79 +++++++++++++++++++----------------
> > > >>  4 files changed, 46 insertions(+), 37 deletions(-)
> > > >>
> > > >> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > > >> index 4a97d92a7e7d..88d8de3b7a4f 100644
> > > >> --- a/drivers/media/media-device.c
> > > >> +++ b/drivers/media/media-device.c
> > > >> @@ -580,6 +580,8 @@ int __must_check media_device_register_entity(struct media_device *mdev,
> > > >>  			 "Entity type for entity %s was not initialized!\n",
> > > >>  			 entity->name);
> > > >>  
> > > >> +	WARN_ON(entity->obj_type == MEDIA_ENTITY_TYPE_INVALID);
> > > >> +    
> > > > 
> > > > This is not ok. There are valid cases where the entity is not embedded
> > > > on some other struct. That's the case of connectors/connections, for
> > > > example: a connector/connection entity doesn't need anything else but
> > > > struct media device.    
> > > 
> > > Once connectors are enabled, then we do need a MEDIA_ENTITY_TYPE_CONNECTOR or
> > > MEDIA_ENTITY_TYPE_STANDALONE or something along those lines.
> > >   
> > > > Also, this is V4L2 specific. Neither ALSA nor DVB need to use container_of().
> > > > Actually, this won't even work there, as the entity is stored as a pointer,
> > > > and not as an embedded data.    
> > > 
> > > Any other subsystem that *does* embed this can use obj_type. If it doesn't embed
> > > it in anything, then MEDIA_ENTITY_TYPE_STANDALONE should be used (or whatever
> > > name we give it). I agree that we need a type define for the case where it is
> > > not embedded.
> > >   
> > > > 
> > > > So, if we're willing to do this, then it should, instead, create
> > > > something like:
> > > > 
> > > > struct embedded_media_entity {
> > > > 	struct media_entity entity;
> > > > 	enum media_entity_type obj_type;
> > > > };    
> > > 
> > > It's not v4l2 specific. It is just that v4l2 is the only subsystem that requires
> > > this information at the moment. I see no reason at all to create such an ugly
> > > struct.  
> > 
> > At the minute we added a BUG_ON() there, it became mandatory that all
> > struct media_entity to be embedded. This is not always true, but
> > as the intention is to avoid the risk of embedding it without a type,
> > it makes sense to have the above struct. This way, the obj_type
> > usage will be enforced *only* in the places where it is needed.
> > 
> > We could, instead, remove BUG_ON() and make MEDIA_ENTITY_TYPE_STANDALONE
> > the default type, but that won't enforce its usage where it is needed.  
> 
> My understanding, based on the previous discussion, was that the
> media_entity would in practice be always embedded in another struct. If
> that's not the case, I think Hans proposed a few good options for type enums
> telling the media_entity is not embedded in another struct.
> 
> For what it's worth, my personal favourite is "NONE".

A "standalone" type would work. "none" doesn't seem a good name
though, but I don't intend to spend much time with naming issues.

> 
> >   
> > > I very strongly suspect that other subsystems will also embed this in their own
> > > internal structs.   
> > 
> > They will if they need.
> >   
> > > I actually wonder why it isn't embedded in struct dvb_device,
> > > but I have to admit that I didn't take a close look at that. The pads are embedded
> > > there, so it is somewhat odd that the entity isn't.  
> > 
> > The only advantage of embedding instead of using a pointer is that
> > it would allow to use container_of() to get the struct. On the
> > other hand, there's one drawback: both container and embedded
> > structs will be destroyed at the same time. This can be a problem
> > if the embedded object needs to live longer than the container.
> > 
> > Also, the usage of container_of() doesn't work fine if the
> > container have embedded two objects of the same type.
> > 
> > In the specific case of DVB, let's imagine we would use the above
> > solution and add a MEDIA_ENTITY_TYPE_DVB_DEVICE.
> > 
> > If you look into struct dvb_device, you'll see that there are
> > actually two media_entities on it:
> > 
> > struct dvb_device {
> > ...
> >         struct media_entity *entity, *tsout_entity;
> > ...
> > };
> > 
> > If we had embedded them, just knowing that the container is
> > struct dvb_device won't help, as the offsets for "entity"
> > and for "tsout_entity" to get its container would be different.
> > 
> > OK, we could have added two types there, but all of these
> > would be just adding uneeded complexity and wound't be error
> > prone. Also, there's no need to use container_of(), as a pointer
> > to the dvb_device struct is always there at the DVB code.  
> 
> If you wanted to obtain the dvb_device here, you'd instead add another
> struct that embeds the struct media_entity. This struct would contain a
> pointer to struct dvb_device. Simple and efficient.

Why would someone need that? There's no need to embedding it at 
the DVB core. Adding an extra struct just to make the media core
happy would just add extra complexity for no good reason.

> 
> > 
> > The same happens at ALSA code: so far, there's no need to go from a
> > media_entity to its container.
> > 
> > So, as I said before, the usage of container_of() and the need for an
> > object type is currently V4L2 specific, and it is due to the way
> > the v4l2 core and subdev framework was modeled. Don't expect or
> > force that all subsystems would do the same.  
> 
> What you do miss with using a pointer above is to find sub-system specific
> information related to the entity. It's a very common operation, if there is
> sub-system specific information related to an entity. I would say that if
> you don't, the driver creating the media device must be aware of a lot of
> the properties of the devices the media graph consists of, or use 
> alternative means to associate subsystem specific information to entities.
> Looping over a linked list, for instance, is bound to be less efficient.

The media device creation is handled by the core at the DVB side.
he knows already about any subsystem-specific data.

> I don't see anything V4L2 specific here as such, even though no other
> sub-system would (yet) need the feature.

Right now, this need happens in the case here the media entity is created
inside I2C devices, where the I2C driver doesn't know much about the
callers.

Such need is specific to a few subsystems: like v4l2 and hwmon.

Ok, other systems could need to do that in the future, but such
need assumes that the media_entities will be created by drivers
that are connected to the main driver via some bus, with is not
the generic case.

Regards,
Mauro
