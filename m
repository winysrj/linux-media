Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59002 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbbHUJ50 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 05:57:26 -0400
Date: Fri, 21 Aug 2015 06:57:20 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v6 2/8] [media] media: add a common struct to be embed
 on media graph objects
Message-ID: <20150821065720.69a03943@recife.lan>
In-Reply-To: <1667127.681LBiMjnq@avalon>
References: <cover.1439981515.git.mchehab@osg.samsung.com>
	<0622f35fe1287a61f7703ba3f99fd78e4f992806.1439981515.git.mchehab@osg.samsung.com>
	<1667127.681LBiMjnq@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 21 Aug 2015 04:02:57 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Wednesday 19 August 2015 08:01:49 Mauro Carvalho Chehab wrote:
> > Due to the MC API proposed changes, we'll need to have an unique
> > object ID for all graph objects, and have some shared fields
> > that will be common on all media graph objects.
> > 
> > Right now, the only common object is the object ID, but other
> > fields will be added later on.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index cb0ac4e0dfa5..4834172bf6f8 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -27,6 +27,38 @@
> >  #include <media/media-device.h>
> > 
> >  /**
> > + *  media_gobj_init - Initialize a graph object
> > + *
> > + * @mdev:	Pointer to the media_device that contains the object
> > + * @type:	Type of the object
> > + * @gobj:	Pointer to the object
> > + *
> > + * This routine initializes the embedded struct media_gobj inside a
> > + * media graph object. It is called automatically if media_*_create()
> > + * calls are used. However, if the object (entity, link, pad, interface)
> > + * is embedded on some other object, this function should be called before
> > + * registering the object at the media controller.

Actually, the comment here is a little bit outdated, from the time I was
adding a kref inside the graph_obj. That's by the way one of the problems
with patches that suffer lots of transforms: comments may need to be
adjusted to reflect what changed, but tracking such changes is harder.

The comment above should be, instead:

 * This routine initializes the embedded struct media_gobj inside a
 * media graph object. It is called automatically at media_*_create()
 * and at media_entity_register().

> Allowing both dynamic allocation and embedding will create a more complex API 
> with more opportunities for drivers to get it wrong. I'd like to try and 
> standardize the expected behaviour.

Let's discuss dynamic allocation when we come with the patches. For
now, if media_obj_init is not called, objects won't have an unique
ID and will cause an OOPS if debug is enabled, with is easily tracked.

> 
> > + */
> > +void media_gobj_init(struct media_device *mdev,
> > +			   enum media_gobj_type type,
> > +			   struct media_gobj *gobj)
> > +{
> > +	/* For now, nothing to do */
> > +}
> > +
> > +/**
> > + *  media_gobj_remove - Stop using a graph object on a media device
> 
> Is this function supposed to be the counterpart of media_gobj_init ? If so it 
> should be called media_gobj_cleanup instead.

*_cleanup doesn't mean anything for me. The usual Kernel way is to use either
*_init and *_remove or *_register/*_remove for a kernel "object"
creation/removal.

If you prefer, I could rename the first function to media_gobj_register.

> 
> > + *
> > + * @graph_obj:	Pointer to the object
> 
> The parameter is called gobj. Could you compile the kerneldoc to ensure that 
> such typos get caught ?

I will fix at a next version and compile kerneldoc.

> 
> > + *
> > + * This should be called at media_device_unregister_*() routines
> > + */
> > +void media_gobj_remove(struct media_gobj *gobj)
> > +{
> > +	/* For now, nothing to do */
> > +}
> > +
> > +/**
> >   * media_entity_init - Initialize a media entity
> >   *
> >   * @num_pads: Total number of sink and source pads.
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index 0a66fc225559..c1cd4fba051d 100644
> > --- a/include/media/media-entity.h
> > +++ b/include/media/media-entity.h
> > @@ -28,6 +28,39 @@
> >  #include <linux/list.h>
> >  #include <linux/media.h>
> > 
> > +/* Enums used internally at the media controller to represent graphs */
> > +
> > +/**
> > + * enum media_gobj_type - type of a graph element
> 
> Let's try to standardize the vocabulary, should it be called graph object or 
> graph element ? In the first case let's document it as graph object. In the 
> second case it would be more consistent to refer to it as enum 
> media_gelem_type (and struct media_gelem below).

graph object. Thanks for noticing it. I'll fix.

> 
> > + *
> > + */
> > +enum media_gobj_type {
> > +	 /* FIXME: add the types here, as we embed media_gobj */
> > +	MEDIA_GRAPH_NONE
> > +};
> > +
> > +#define MEDIA_BITS_PER_TYPE		8
> > +#define MEDIA_BITS_PER_LOCAL_ID		(32 - MEDIA_BITS_PER_TYPE)
> > +#define MEDIA_LOCAL_ID_MASK		 GENMASK(MEDIA_BITS_PER_LOCAL_ID - 1, 0)
> > +
> > +/* Structs to represent the objects that belong to a media graph */
> > +
> > +/**
> > + * struct media_gobj - Define a graph object.
> > + *
> > + * @id:		Non-zero object ID identifier. The ID should be unique
> > + *		inside a media_device, as it is composed by
> > + *		MEDIA_BITS_PER_TYPE to store the type plus
> > + *		MEDIA_BITS_PER_LOCAL_ID	to store a per-type ID
> > + *		(called as "local ID").
> 
> I'd very much prefer using a single ID range and adding a type field. Abusing 
> bits of the ID field to store the type will just makes IDs impractical to use. 
> Let's do it properly.

This came actually from the feedback I got on the first RFC, but
it is not possible to use a singe ID range. We can, of course
have a separate type, but we need at least two ID ranges.

Otherwise, both Kernelspace and userspace will break.

At least on my tests, the media-ctl implementation is very sensitive to
the way the things are currently implemented on Kernel, and even small
changes like reporting a backlink or changing the initial object ID to
0 causes it to crash or fail. I suspect that other userspace apps
could be even worse.

Also, as I pointed before, the graph traversal algorithm wants that
the entity number to be below 64 (MEDIA_ENTITY_ENUM_MAX_ID) and 
similar mechanisms inside drivers at have even lower constraints for
the entity range: no entity can have an ID bigger than 32.

While removing such restrictions at Kernespace is doable, this is out
of the scope of this work, and would require changes/testing on
hardware that could otherwise work forever keeping the entity range
below 32.

That means, in practice, that the first driver that will use dynamic
entity addition and removal and need to call the graph_traversal routines
at the MC core will have to come up with a different graph traversal
algorithm.

So, the question is either if we'll have 2 ranges (one for entities and
another one for the other types) or one range per type.

On the first case, we'll be using something like:
	ID range from 0x000000000000 to 0x7fffffffffff - entities
	ID range from 0x800000000000 to 0xffffffffffff - other elements

And split that "global_id" field into two separate fields, as I
proposed on my initial patch series:
	struct media_gobj {
		u32 id;
		enum media_gobj_type type;
	}


While I'm ok with that, it has some drawbacks:

1) if we remove the concept of type+id together, the IDs on userspace
will not be "human-friendly", as Sakari requested on his feedback (or it
would require some messy hacks). 
With the current proposal, if one would like to change something at a pad,
instead of using an object ID like: 
	0x010000000004
It could, instead, use:
	pad#4

2) What would be the name of the var that would carry on the non-entities
ID? I guess the internal API namespace will be a little messier. Should
we call it:
	mdev.entity_id
	mdev.non_entity_id
Or do you have another suggestion for the namespace thing?

3) At debug/tracing logs, it is easier for humans to identify something
called "pad#4" than 0x010000000004.

So, at least while we're debugging the patches, I'll keep the ranges 
separate.

If we decide to do it otherwise, I'll add a patch near the end of the MC
next generation patches to change the range ID to whatever gets decided.

> 
> > + * All elements on the media graph should have this struct embedded
> 
> All elements (objects) or only the ones that need an ID ? Or maybe we'll 
> define graph element (object) as an element (object) that has an ID, making 
> some "elements" not elements.

The idea is to have the common struct embedded on all objects, containing
the object type, and other common data.

A common struct is very useful for debugging purposes, for notification
purposes, etc, as from the object struct is possible to go to the main
object. It will also be important when we'll need dynamic support.

All objects need a type. If we split the ID, we might move the
ID out of the struct if we ever need an ID-less object, but, I think that
an ID-less object is a terrible idea, as it makes a way harder to track
the object lifecycle when debugging the code, and objects will then
be only referenced internally via pointers.

See, with an object ID for the links, any debug messages can contain the ID,
like:
	media_gobj_init: id 0x02000002 link#2: 'Xceive XC5000' pad#4 ==> 'Auvitek AU8522 QAM/8VSB Frontend' pad#7

If I need, for example, to check if the ioctl's are properly reporting
such link to userspace, all I would need to do is to print the
link "name":
		link#2

as this is a good enough reference for the object (and yes, I had do do
something exactly like that yesterday).

With a combined id+type, there's no penalty of having an ID for all
objects. If we split into id + type, we'll "waste" just 4 bytes, with
seems a low price to pay to avoid the waste of time when debugging the
object lifecycle.

> 
> > + */
> > +struct media_gobj {
> > +	u32			id;
> > +};
> > +
> > +
> >  struct media_pipeline {
> >  };
> > 
> > @@ -118,6 +151,26 @@ static inline u32 media_entity_id(struct media_entity
> > *entity) return entity->id;
> >  }
> > 
> > +static inline enum media_gobj_type media_type(struct media_gobj *gobj)
> > +{
> > +	return gobj->id >> MEDIA_BITS_PER_LOCAL_ID;
> > +}
> > +
> > +static inline u32 media_localid(struct media_gobj *gobj)
> > +{
> > +	return gobj->id & MEDIA_LOCAL_ID_MASK;
> > +}
> > +
> > +static inline u32 media_gobj_gen_id(enum media_gobj_type type, u32
> > local_id)
> > +{
> > +	u32 id;
> > +
> > +	id = type << MEDIA_BITS_PER_LOCAL_ID;
> > +	id |= local_id & MEDIA_LOCAL_ID_MASK;
> > +
> > +	return id;
> > +}
> > +
> >  #define MEDIA_ENTITY_ENUM_MAX_DEPTH	16
> >  #define MEDIA_ENTITY_ENUM_MAX_ID	64
> > 
> > @@ -131,6 +184,14 @@ struct media_entity_graph {
> >  	int top;
> >  };
> > 
> > +#define gobj_to_entity(gobj) \
> > +		container_of(gobj, struct media_entity, graph_obj)
> 
> For consistency reason would this be called media_gobj_to_entity ? 

I would avoid having a big name for those containers macros.

Also, the usual Kernel practice is to use exactly the same type of
declaration like above:

#define <object>_to_<object>(foo) \
		container_of(foo, ...)

> I would 
> also turn it into an inline function to ensure type checking.

container_of() already provides type checking. So, I don't see any
gain of inlining it.

> 
> > +
> > +void media_gobj_init(struct media_device *mdev,
> > +		    enum media_gobj_type type,
> > +		    struct media_gobj *gobj);
> > +void media_gobj_remove(struct media_gobj *gobj);
> > +
> >  int media_entity_init(struct media_entity *entity, u16 num_pads,
> >  		struct media_pad *pads);
> >  void media_entity_cleanup(struct media_entity *entity);
> 
