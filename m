Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:35096 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbbIILKg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Sep 2015 07:10:36 -0400
Date: Wed, 9 Sep 2015 08:10:31 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v8 04/55] [media] media: add a common struct to be embed
 on media graph objects
Message-ID: <20150909081031.58b4a5e1@recife.lan>
In-Reply-To: <20150909070149.GI3175@valkosipuli.retiisi.org.uk>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
	<8127dc64593c95072f3b5eaa820f738dc1af1920.1440902901.git.mchehab@osg.samsung.com>
	<20150909070149.GI3175@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Em Wed, 09 Sep 2015 10:01:49 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Sun, Aug 30, 2015 at 12:06:15AM -0300, Mauro Carvalho Chehab wrote:
> > Due to the MC API proposed changes, we'll need to have an unique
> > object ID for all graph objects, and have some shared fields
> > that will be common on all media graph objects.
> > 
> > Right now, the only common object is the object ID, but other
> > fields will be added later on.

Thanks for the review!

There are already too much patches on the top of this one. So, I'll
be addressing anything we've agreed on at a separate patch series.

I guess this makes easier for reviewers, and avoid spending hours with rebases
and re-tests. On my experience, rebasing a long series like this is not
a good idea, as errors can be introduced on every rebase. So, doing a 
separate patch is usually better.

> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
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
> > + *
> > + * @graph_obj:	Pointer to the object
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
> > index 0a66fc225559..b1854239a476 100644
> > --- a/include/media/media-entity.h
> > +++ b/include/media/media-entity.h
> > @@ -28,6 +28,39 @@
> >  #include <linux/list.h>
> >  #include <linux/media.h>
> >  
> > +/* Enums used internally at the media controller to represent graphs */
> > +
> > +/**
> > + * enum media_gobj_type - type of a graph object
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
> > + *
> > + * All objects on the media graph should have this struct embedded
> > + */
> > +struct media_gobj {
> > +	u32			id;
> > +};
> > +
> > +
> 
> Two newlines. Looks like one would be enough. A minor matter though.

Ok, I'll be dropping the extra line.

> >  struct media_pipeline {
> >  };
> >  
> > @@ -118,6 +151,26 @@ static inline u32 media_entity_id(struct media_entity *entity)
> >  	return entity->id;
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
> > +static inline u32 media_gobj_gen_id(enum media_gobj_type type, u32 local_id)
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
> Just on naming: I'd call this media_gobj_to_entity, as the type is called
> media_gobj and secondly the common media prefix is used throughout the MC
> API.
> 
> Same for the rest of similar macros in further patches.

As commented on my answer to your review on patch 14/55, the above is
the right namespace for this kind of macro. Nobody uses big names for
those container_of macros, as the hole idea is to have a short name
at the form of:
	"to_bar"
or
	"foo_to_bar"

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
