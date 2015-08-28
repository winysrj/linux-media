Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60795 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378AbbH1NBK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2015 09:01:10 -0400
Date: Fri, 28 Aug 2015 10:01:05 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	shuahkh@osg.samsung.com
Subject: Re: [PATCH v7 04/44] [media] media: add a common struct to be embed
 on media graph objects
Message-ID: <20150828100105.2c281bad@recife.lan>
In-Reply-To: <CAKocOOPNoMRWyx1KbDO-vh2Wh7fGtPBSN8uYw+34qzpCTaAHLw@mail.gmail.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
	<7ec9c268c9a0faa0f79cc3ce2c2fb04be05d3c0f.1440359643.git.mchehab@osg.samsung.com>
	<CAKocOOPNoMRWyx1KbDO-vh2Wh7fGtPBSN8uYw+34qzpCTaAHLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 24 Aug 2015 14:07:07 -0600
Shuah Khan <shuahkhan@gmail.com> escreveu:

> On Sun, Aug 23, 2015 at 2:17 PM, Mauro Carvalho Chehab
> <mchehab@osg.samsung.com> wrote:
> > Due to the MC API proposed changes, we'll need to have an unique
> > object ID for all graph objects, and have some shared fields
> > that will be common on all media graph objects.
> >
> > Right now, the only common object is the object ID, but other
> > fields will be added later on.
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
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
> > + * @mdev:      Pointer to the media_device that contains the object
> > + * @type:      Type of the object
> > + * @gobj:      Pointer to the object
> > + *
> > + * This routine initializes the embedded struct media_gobj inside a
> > + * media graph object. It is called automatically if media_*_create()
> > + * calls are used. However, if the object (entity, link, pad, interface)
> > + * is embedded on some other object, this function should be called before
> > + * registering the object at the media controller.
> > + */
> > +void media_gobj_init(struct media_device *mdev,
> > +                          enum media_gobj_type type,
> > +                          struct media_gobj *gobj)
> > +{
> > +       /* For now, nothing to do */
> > +}
> > +
> 
> This patch is mainly adding skeleton framework. Does this patch series
> implement the media_gobj_init() and media_gobj_remove()?

Yes, on next patches as the usage is needed. One logical change per patch.
> 
> If so, would it make sense to combine the implementation and the stubs?

Keeping separate makes easier to review for most people, as it is easier
to check that this patch won't cause regressions, as it only adds
stub functions.
> 
> thanks,
> -- Shuah
> 
> > +/**
> > + *  media_gobj_remove - Stop using a graph object on a media device
> > + *
> > + * @graph_obj: Pointer to the object
> > + *
> > + * This should be called at media_device_unregister_*() routines
> > + */
> > +void media_gobj_remove(struct media_gobj *gobj)
> > +{
> > +       /* For now, nothing to do */
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
> > +        /* FIXME: add the types here, as we embed media_gobj */
> > +       MEDIA_GRAPH_NONE
> > +};
> > +
> > +#define MEDIA_BITS_PER_TYPE            8
> > +#define MEDIA_BITS_PER_LOCAL_ID                (32 - MEDIA_BITS_PER_TYPE)
> > +#define MEDIA_LOCAL_ID_MASK             GENMASK(MEDIA_BITS_PER_LOCAL_ID - 1, 0)
> > +
> > +/* Structs to represent the objects that belong to a media graph */
> > +
> > +/**
> > + * struct media_gobj - Define a graph object.
> > + *
> > + * @id:                Non-zero object ID identifier. The ID should be unique
> > + *             inside a media_device, as it is composed by
> > + *             MEDIA_BITS_PER_TYPE to store the type plus
> > + *             MEDIA_BITS_PER_LOCAL_ID to store a per-type ID
> > + *             (called as "local ID").
> > + *
> > + * All objects on the media graph should have this struct embedded
> > + */
> > +struct media_gobj {
> > +       u32                     id;
> > +};
> > +
> > +
> >  struct media_pipeline {
> >  };
> >
> > @@ -118,6 +151,26 @@ static inline u32 media_entity_id(struct media_entity *entity)
> >         return entity->id;
> >  }
> >
> > +static inline enum media_gobj_type media_type(struct media_gobj *gobj)
> > +{
> > +       return gobj->id >> MEDIA_BITS_PER_LOCAL_ID;
> > +}
> > +
> > +static inline u32 media_localid(struct media_gobj *gobj)
> > +{
> > +       return gobj->id & MEDIA_LOCAL_ID_MASK;
> > +}
> > +
> > +static inline u32 media_gobj_gen_id(enum media_gobj_type type, u32 local_id)
> > +{
> > +       u32 id;
> > +
> > +       id = type << MEDIA_BITS_PER_LOCAL_ID;
> > +       id |= local_id & MEDIA_LOCAL_ID_MASK;
> > +
> > +       return id;
> > +}
> > +
> >  #define MEDIA_ENTITY_ENUM_MAX_DEPTH    16
> >  #define MEDIA_ENTITY_ENUM_MAX_ID       64
> >
> > @@ -131,6 +184,14 @@ struct media_entity_graph {
> >         int top;
> >  };
> >
> > +#define gobj_to_entity(gobj) \
> > +               container_of(gobj, struct media_entity, graph_obj)
> > +
> > +void media_gobj_init(struct media_device *mdev,
> > +                   enum media_gobj_type type,
> > +                   struct media_gobj *gobj);
> > +void media_gobj_remove(struct media_gobj *gobj);
> > +
> >  int media_entity_init(struct media_entity *entity, u16 num_pads,
> >                 struct media_pad *pads);
> >  void media_entity_cleanup(struct media_entity *entity);
> > --
> > 2.4.3
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
