Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59010 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672AbbHUKT0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 06:19:26 -0400
Date: Fri, 21 Aug 2015 07:19:21 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v6 7/8] [media] media: add a debug message to warn about
 gobj creation/removal
Message-ID: <20150821071921.1f76b70d@recife.lan>
In-Reply-To: <1485912.HaZnsqcIqp@avalon>
References: <cover.1439981515.git.mchehab@osg.samsung.com>
	<7424c6b03ca0bcb8d5af55a6bda6f4c3414d3083.1439981515.git.mchehab@osg.samsung.com>
	<1485912.HaZnsqcIqp@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 21 Aug 2015 04:32:51 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Wednesday 19 August 2015 08:01:54 Mauro Carvalho Chehab wrote:
> > It helps to check if the media controller is doing the
> > right thing with the object creation and removal.
> > 
> > No extra code/data will be produced if DEBUG or
> > CONFIG_DYNAMIC_DEBUG is not enabled.
> 
> CONFIG_DYNAMIC_DEBUG is often enabled.

True, but once a driver/core is properly debugged, images without DEBUG
could be used in production, if the amount of memory constraints are
too tight.

> You're more or less adding function call tracing in this patch, isn't that 
> something that ftrace is supposed to do ?

Ftrace is a great infrastructure and helps a lot when we need to
identify bottlenecks and other performance related stuff, but it
doesn't replace debug functions.

There are some fundamental differences on what you could do with ftrace
and what you can't.

At least on this stage, what I need is something that will provide
output via serial console when the driver gets loaded, and that provides
a synchronous output with the other Kernel messages.

This is the only way to debug certain OOPSes that are happening during
the development of the patches.

This is something you cannot do with ftrace, but dynamic DEBUG works
like a charm.

> 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index 36d725ec5f3d..6d515e149d7f 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -27,6 +27,69 @@
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
> > +static inline const char *gobj_type(enum media_gobj_type type)
> > +{
> > +	switch (type) {
> > +	case MEDIA_GRAPH_ENTITY:
> > +		return "entity";
> > +	case MEDIA_GRAPH_PAD:
> > +		return "pad";
> > +	case MEDIA_GRAPH_LINK:
> > +		return "link";
> > +	default:
> > +		return "unknown";
> > +	}
> > +}
> > +
> > +static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
> > +{
> > +#if defined(DEBUG) || defined (CONFIG_DYNAMIC_DEBUG)
> > +	switch (media_type(gobj)) {
> > +	case MEDIA_GRAPH_ENTITY:
> > +		dev_dbg(gobj->mdev->dev,
> > +			"%s: id 0x%08x entity#%d: '%s'\n",
> > +			event_name, gobj->id, media_localid(gobj),
> > +			gobj_to_entity(gobj)->name);
> > +		break;
> > +	case MEDIA_GRAPH_LINK:
> > +	{
> > +		struct media_link *link = gobj_to_link(gobj);
> > +
> > +		dev_dbg(gobj->mdev->dev,
> > +			"%s: id 0x%08x link#%d: '%s' %s#%d ==> '%s' %s#%d\n",
> > +			event_name, gobj->id, media_localid(gobj),
> > +
> > +			link->source->entity->name,
> > +			gobj_type(media_type(&link->source->graph_obj)),
> > +			media_localid(&link->source->graph_obj),
> > +
> > +			link->sink->entity->name,
> > +			gobj_type(media_type(&link->sink->graph_obj)),
> > +			media_localid(&link->sink->graph_obj));
> > +		break;
> > +	}
> > +	case MEDIA_GRAPH_PAD:
> > +	{
> > +		struct media_pad *pad = gobj_to_pad(gobj);
> > +
> > +		dev_dbg(gobj->mdev->dev,
> > +			"%s: id 0x%08x pad#%d: '%s':%d\n",
> > +			event_name, gobj->id, media_localid(gobj),
> > +			pad->entity->name, pad->index);
> > +	}
> > +	}
> > +#endif
> > +}
> > +
> > +/**
> >   *  media_gobj_init - Initialize a graph object
> >   *
> >   * @mdev:	Pointer to the media_device that contains the object
> > @@ -43,6 +106,8 @@ void media_gobj_init(struct media_device *mdev,
> >  			   enum media_gobj_type type,
> >  			   struct media_gobj *gobj)
> >  {
> > +	gobj->mdev = mdev;
> > +
> >  	/* Create a per-type unique object ID */
> >  	switch (type) {
> >  	case MEDIA_GRAPH_ENTITY:
> > @@ -55,6 +120,7 @@ void media_gobj_init(struct media_device *mdev,
> >  		gobj->id = media_gobj_gen_id(type, ++mdev->link_id);
> >  		break;
> >  	}
> > +	dev_dbg_obj(__func__, gobj);
> >  }
> > 
> >  /**
> > @@ -66,7 +132,7 @@ void media_gobj_init(struct media_device *mdev,
> >   */
> >  void media_gobj_remove(struct media_gobj *gobj)
> >  {
> > -	/* For now, nothing to do */
> > +	dev_dbg_obj(__func__, gobj);
> >  }
> > 
> >  /**
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index 749b46c91217..bdd5e565ae76 100644
> > --- a/include/media/media-entity.h
> > +++ b/include/media/media-entity.h
> > @@ -61,6 +61,7 @@ enum media_gobj_type {
> >   * All elements on the media graph should have this struct embedded
> >   */
> >  struct media_gobj {
> > +	struct media_device	*mdev;
> 
> I'd move this to the patch that introduces media_gobj.
> 
> >  	u32			id;
> >  };
> > 
> > @@ -192,6 +193,12 @@ struct media_entity_graph {
> >  #define gobj_to_entity(gobj) \
> >  		container_of(gobj, struct media_entity, graph_obj)
> > 
> > +#define gobj_to_pad(gobj) \
> > +		container_of(gobj, struct media_pad, graph_obj)
> > +
> > +#define gobj_to_link(gobj) \
> > +		container_of(gobj, struct media_link, graph_obj)
> > +
> 
> And I'd call these media_gobj_* as commented on patch 2/8.
> 
> >  void media_gobj_init(struct media_device *mdev,
> >  		    enum media_gobj_type type,
> >  		    struct media_gobj *gobj);
> 
