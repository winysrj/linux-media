Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58394 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbbHSJut (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2015 05:50:49 -0400
Date: Wed, 19 Aug 2015 06:50:44 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH RFC v5 7/8] [media] media: add a debug message to warn
 about gobj creation/removal
Message-ID: <20150819065044.5bfdf3ac@recife.lan>
In-Reply-To: <55D44023.6040703@xs4all.nl>
References: <cover.1439927113.git.mchehab@osg.samsung.com>
	<b45fb12d0c6c2d45a55522ab7cbcdcd746155528.1439927113.git.mchehab@osg.samsung.com>
	<55D44023.6040703@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 19 Aug 2015 10:36:51 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 08/18/2015 10:04 PM, Mauro Carvalho Chehab wrote:
> > It helps to check if the media controller is doing the
> > right thing with the object creation and removal.
> > 
> > No extra code/data will be produced if DEBUG or
> > CONFIG_DYNAMIC_DEBUG is not enabled.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index a6be50e04736..9e5ebc83ff76 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -27,6 +27,67 @@
> >  #include <media/media-device.h>
> >  
> >  /**
> > + *  dev_dbg_obj - Prints in debug mode a change on some object
> > + *
> > + * @event_name:	Name of the event to report. Could be __func__
> > + * @gobj:	Pointer to the object
> > + *
> > + * Enabled only if DEBUG or CONFIG_DYNAMIC_DEBUG. Otherwise, it
> > + * won't produce any code.
> > + */
> > +static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
> > +{
> > +#if defined(DEBUG) || defined (CONFIG_DYNAMIC_DEBUG)
> > +	static const char *gobj_type[] = {
> > +		[MEDIA_GRAPH_ENTITY] = "entity",
> > +		[MEDIA_GRAPH_PAD] = "pad",
> > +		[MEDIA_GRAPH_LINK] = "link",
> > +	};
> > +
> > +	switch (media_type(gobj)) {
> > +	case MEDIA_GRAPH_ENTITY:
> > +		dev_dbg(gobj->mdev->dev,
> > +			"%s: id 0x%08x %s#%d '%s'\n",
> > +			event_name, gobj->id,
> > +			gobj_type[media_type(gobj)],
> 
> You can just fill in "entity" in the string since this is always an entity in
> this case.

Yes, I know that we actually don't need to use gobj_type[] on the
macros anymore. On my first version, there was no switch(), and just
a generic function. I would prefer this way, though. We'll end by
using the arrays for the links.

So, I'll do such cleanup when adding interfaces and interface links.

> 
> > +			media_localid(gobj),
> > +			gobj_to_entity(gobj)->name);
> > +		break;
> > +	case MEDIA_GRAPH_LINK:
> > +	{
> > +		struct media_link *link = gobj_to_link(gobj);
> > +
> > +		dev_dbg(gobj->mdev->dev,
> > +			"%s: id 0x%08x %s#%d: '%s' %s#%d ==> '%s' %s#%d\n",
> > +			event_name, gobj->id,
> > +			gobj_type[media_type(gobj)],
> 
> Ditto.
> 
> > +			media_localid(gobj),
> > +
> > +			link->source->entity->name,
> > +			gobj_type[media_type(&link->source->graph_obj)],
> > +			media_localid(&link->source->graph_obj),
> > +
> > +			link->sink->entity->name,
> > +			gobj_type[media_type(&link->sink->graph_obj)],
> > +			media_localid(&link->sink->graph_obj));
> > +		break;
> > +	}
> > +	case MEDIA_GRAPH_PAD:
> > +	{
> > +		struct media_pad *pad = gobj_to_pad(gobj);
> > +
> > +		dev_dbg(gobj->mdev->dev,
> > +			"%s: id 0x%08x %s %s#%d\n",
> > +			event_name, gobj->id,
> > +			pad->entity->name,
> > +			gobj_type[media_type(gobj)],
> 
> Ditto.
> 
> > +			media_localid(gobj));
> > +	}
> 
> I would add a default case here with a WARN(1) or something like that to make
> it very clear that someone forgot to extend this switch after adding a new
> object type.

Well, newer gcc versions will print a warning if we add a new type at
the enum and we forget to add here. So, I guess a default case is an
overkill, and will just add extra code that will never be used.

> In the LINK case there is no check for unknown object types in the gobj_type[]
> lookups. I think it is overkill to add a check for that since the objects that
> are linked are going to be created first, so they would trigger the WARN(1) in
> the default case first if they are using unhandled types. That should give
> enough information for the developer.

Well, I can convert gobj_type into a function and add a default case
there, as going past the array is something that makes sense to avoid.

I'll do such change when writing the support for interface links.

> 
> > +	}
> > +#endif
> > +}
> > +
> > +/**
> >   *  media_gobj_init - Initialize a graph object
> >   *
> >   * @mdev:	Pointer to the media_device that contains the object
> > @@ -43,6 +104,8 @@ void media_gobj_init(struct media_device *mdev,
> >  			   enum media_gobj_type type,
> >  			   struct media_gobj *gobj)
> >  {
> > +	gobj->mdev = mdev;
> > +
> >  	/* Create a per-type unique object ID */
> >  	switch (type) {
> >  	case MEDIA_GRAPH_ENTITY:
> > @@ -55,6 +118,7 @@ void media_gobj_init(struct media_device *mdev,
> >  		gobj->id = media_gobj_gen_id(type, ++mdev->link_id);
> >  		break;
> >  	}
> > +	dev_dbg_obj(__func__, gobj);
> >  }
> >  
> >  /**
> > @@ -66,7 +130,7 @@ void media_gobj_init(struct media_device *mdev,
> >   */
> >  void media_gobj_remove(struct media_gobj *gobj)
> >  {
> > -	/* For now, nothing to do */
> > +	dev_dbg_obj(__func__, gobj);
> >  }
> >  
> >  /**
> > @@ -472,13 +536,6 @@ static struct media_link *media_entity_add_link(struct media_entity *entity)
> >  		entity->links = links;
> >  	}
> >  
> > -	/* Initialize graph object embedded at the new link */
> > -	if (entity->parent)
> > -		media_gobj_init(entity->parent, MEDIA_GRAPH_LINK,
> > -				&entity->links[entity->num_links].graph_obj);
> > -	else
> > -		pr_warn("Link created before entity register!\n");
> > -
> 
> This is confusing: this was added in patch 5 and now it is removed again. This doesn't
> seem to have anything to do with adding this debugging facility.

The warning is a left over from the test phase. I was afraid that such
condition might be happening. 

With regards to media_gobj_init(), we can't call it here anymore, as
it is too early to call dev_dbg_obj(), as the link data is not filled.
So, this got moved to media_entity_create_link(), to happen after
filling link->source and link->sink.

> 
> >  	return &entity->links[entity->num_links++];
> >  }
> >  
> > @@ -501,6 +558,8 @@ )struct media_entity *source, u16 source_pad,
> >  	link->sink = &sink->pads[sink_pad];
> >  	link->flags = flags;
> >  
> > +	media_gobj_init(source->parent, MEDIA_GRAPH_LINK, &link->graph_obj);
> > +
> 
> Same for this,
> 
> >  	/* Create the backlink. Backlinks are used to help graph traversal and
> >  	 * are not reported to userspace.
> >  	 */
> > @@ -514,6 +573,8 @@ media_entity_create_link(struct media_entity *source, u16 source_pad,
> >  	backlink->sink = &sink->pads[sink_pad];
> >  	backlink->flags = flags;
> >  
> > +	media_gobj_init(sink->parent, MEDIA_GRAPH_LINK, &backlink->graph_obj);
> > +
> 
> and this.
> 
> Shouldn't these three changes be moved to patch 5?

Well, I can move this hunk to patch 5, but that will just be hiding 
the reason why they should be here in the first place: due to the new
debug function.

> 
> >  	link->reverse = backlink;
> >  	backlink->reverse = link;
> >  
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index 2ffe015629fa..db1f54f09723 100644
> > --- a/include/media/media-entity.h
> > +++ b/include/media/media-entity.h
> > @@ -59,6 +59,7 @@ enum media_gobj_type {
> >   * All elements on the media graph should have this struct embedded
> >   */
> >  struct media_gobj {
> > +	struct media_device	*mdev;
> 
> If you add this here, then the parent pointer in struct media_entity should be
> removed to avoid having duplicate fields.

Yes, I know, but I don't want to do it on just one patch. I'm trying to
do the minimal amount of changes to introduce interface and interface
links. My plan is to actually remove entity->parent latter, as such change
will touch inside the drivers. It could be a big patch that won't cause
any real gain, except for 4 bytes saved. So, I really prefer to postpone
this to a cleanup series. I'm also hoping to merge vimc driver before that,
as this would mean one less thing to be rebased on it ;)

> 
> I understand why you add this and I don't object, but I would split this change
> off into a separate patch that also includes removing the media_entity parent
> field.

Well, you didn't complain about that on the previous versions (and mdev
were on all other patches) :-) 

I actually think that this way is easier to review, as one of the usages
of mdev is explicit on this patch, and, as I said, the removal of the
entity->parent is just a cleanup that can be done latter.

Let's focus on adding the new functionality first.

> 
> Regards,
> 
> 	Hans
> 
> >  	u32			id;
> >  };
> >  
> > @@ -190,6 +191,12 @@ struct media_entity_graph {
> >  #define gobj_to_entity(gobj) \
> >  		container_of(gobj, struct media_entity, graph_obj)
> >  
> > +#define gobj_to_pad(gobj) \
> > +		container_of(gobj, struct media_pad, graph_obj)
> > +
> > +#define gobj_to_link(gobj) \
> > +		container_of(gobj, struct media_link, graph_obj)
> > +
> >  void media_gobj_init(struct media_device *mdev,
> >  		    enum media_gobj_type type,
> >  		    struct media_gobj *gobj);
> > 
> 
