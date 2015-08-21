Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59007 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbbHUKJs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 06:09:48 -0400
Date: Fri, 21 Aug 2015 07:09:44 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v6 3/8] [media] media: use media_gobj inside entities
Message-ID: <20150821070944.2eaca4ff@recife.lan>
In-Reply-To: <1659621.SfFOT8CCKq@avalon>
References: <cover.1439981515.git.mchehab@osg.samsung.com>
	<80431d3c9fc9088a316031de12c8c9e68fedd85b.1439981515.git.mchehab@osg.samsung.com>
	<1659621.SfFOT8CCKq@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 21 Aug 2015 04:10:03 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Wednesday 19 August 2015 08:01:50 Mauro Carvalho Chehab wrote:
> > As entities are graph elements, let's embed media_gobj
> > on it. That ensures an unique ID for entities that can be
> > global along the entire media controller.
> > 
> > For now, we'll keep the already existing entity ID. Such
> > field need to be dropped at some point, but for now, let's
> > not do this, to avoid needing to review all drivers and
> > the userspace apps.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index e429605ca2c3..81d6a130efef 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> > @@ -379,7 +379,6 @@ int __must_check __media_device_register(struct
> > media_device *mdev, if (WARN_ON(mdev->dev == NULL || mdev->model[0] == 0))
> >  		return -EINVAL;
> > 
> > -	mdev->entity_id = 1;
> >  	INIT_LIST_HEAD(&mdev->entities);
> >  	spin_lock_init(&mdev->lock);
> >  	mutex_init(&mdev->graph_mutex);
> > @@ -433,10 +432,8 @@ int __must_check media_device_register_entity(struct
> > media_device *mdev, entity->parent = mdev;
> > 
> >  	spin_lock(&mdev->lock);
> > -	if (entity->id == 0)
> > -		entity->id = mdev->entity_id++;
> > -	else
> > -		mdev->entity_id = max(entity->id + 1, mdev->entity_id);
> > +	/* Initialize media_gobj embedded at the entity */
> > +	media_gobj_init(mdev, MEDIA_GRAPH_ENTITY, &entity->graph_obj);
> 
> Graph object initialization should be moved to media_entity_init() to keep 
> initialization separate from registration.

Won't work. I tried. My first RFC patches were doing that.

The problem is that media_entity_init() is currently called too early
at the V4L2 drivers, before having mdev assigned.

Also, objects without PADs don't call media_entity_init(). At long
term, this function may even disappear, as it only exists today to
allocate arrays for pads/links. If we get rid of the pads array, it
will make no sense to keep it.

> >  	list_add_tail(&entity->list, &mdev->entities);
> >  	spin_unlock(&mdev->lock);
> > 
> > @@ -459,6 +456,7 @@ void media_device_unregister_entity(struct media_entity
> > *entity) return;
> > 
> >  	spin_lock(&mdev->lock);
> > +	media_gobj_remove(&entity->graph_obj);
> >  	list_del(&entity->list);
> >  	spin_unlock(&mdev->lock);
> >  	entity->parent = NULL;
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index 4834172bf6f8..888cb88e19bf 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -43,7 +43,12 @@ void media_gobj_init(struct media_device *mdev,
> >  			   enum media_gobj_type type,
> >  			   struct media_gobj *gobj)
> >  {
> > -	/* For now, nothing to do */
> > +	/* Create a per-type unique object ID */
> > +	switch (type) {
> > +	case MEDIA_GRAPH_ENTITY:
> > +		gobj->id = media_gobj_gen_id(type, ++mdev->entity_id);
> > +		break;
> > +	}
> >  }
> > 
> >  /**
> > diff --git a/include/media/media-device.h b/include/media/media-device.h
> > index a44f18fdf321..f6deef6e5820 100644
> > --- a/include/media/media-device.h
> > +++ b/include/media/media-device.h
> > @@ -41,7 +41,7 @@ struct device;
> >   * @bus_info:	Unique and stable device location identifier
> >   * @hw_revision: Hardware device revision
> >   * @driver_version: Device driver version
> > - * @entity_id:	ID of the next entity to be registered
> > + * @entity_id:	Unique ID used on the last entity registered
> >   * @entities:	List of registered entities
> >   * @lock:	Entities list lock
> >   * @graph_mutex: Entities graph operation lock
> > @@ -69,6 +69,7 @@ struct media_device {
> >  	u32 driver_version;
> > 
> >  	u32 entity_id;
> > +
> >  	struct list_head entities;
> > 
> >  	/* Protects the entities list */
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index c1cd4fba051d..9ca366334bcf 100644
> > --- a/include/media/media-entity.h
> > +++ b/include/media/media-entity.h
> > @@ -33,10 +33,10 @@
> >  /**
> >   * enum media_gobj_type - type of a graph element
> >   *
> > + * @MEDIA_GRAPH_ENTITY:		Identify a media entity
> 
> I think we should explicitly define here what an entity is.

I'm happy to add a new text here if you have a better idea.

Anyway, for now, I'm more concerned on getting things done than to spend
lots of time with the comments. As pointed on patch 1/8, while we're
changing a lot the code, those comments tend to become obsolete very
quick. The comments there is more like a boilerplate, as, once we finish
touching at the core,  it makes sense to review the comments at media *.h
files, converting all descriptions to kernel-doc-nano format (there are
several not using it) and review Documentation/media-framework.txt, adding
the missing parts.

> 
> >   */
> >  enum media_gobj_type {
> > -	 /* FIXME: add the types here, as we embed media_gobj */
> > -	MEDIA_GRAPH_NONE
> > +	MEDIA_GRAPH_ENTITY,
> >  };
> > 
> >  #define MEDIA_BITS_PER_TYPE		8
> > @@ -94,10 +94,9 @@ struct media_entity_operations {
> >  };
> > 
> >  struct media_entity {
> > +	struct media_gobj graph_obj;
> >  	struct list_head list;
> >  	struct media_device *parent;	/* Media device this entity belongs to*/
> > -	u32 id;				/* Entity ID, unique in the parent media
> > -					 * device context */
> >  	const char *name;		/* Entity name */
> >  	u32 type;			/* Entity type (MEDIA_ENT_T_*) */
> >  	u32 revision;			/* Entity revision, driver specific */
> > @@ -148,7 +147,7 @@ static inline u32 media_entity_subtype(struct
> > media_entity *entity)
> > 
> >  static inline u32 media_entity_id(struct media_entity *entity)
> >  {
> > -	return entity->id;
> > +	return entity->graph_obj.id;
> >  }
> > 
> >  static inline enum media_gobj_type media_type(struct media_gobj *gobj)
> 
