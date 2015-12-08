Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:47665 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbbLHTbt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2015 14:31:49 -0500
Date: Tue, 8 Dec 2015 17:31:45 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v8 46/55] [media] media: move mdev list init to gobj
Message-ID: <20151208173145.01ea3cf6@recife.lan>
In-Reply-To: <3064066.jNbDTAyJ1A@avalon>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
	<7b800aebe4c9f6549942fd95b40d4263dcffe3bc.1441540862.git.mchehab@osg.samsung.com>
	<3064066.jNbDTAyJ1A@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 24 Nov 2015 00:32:49 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Sunday 06 September 2015 09:03:06 Mauro Carvalho Chehab wrote:
> > Let's control the topology changes inside the graph_object. So, move the
> > addition and removal of interfaces/entities from the mdev lists to
> > media_gobj_init() and media_gobj_remove().
> > 
> > The main reason is that mdev should have lists for all object types, as
> > the new MC api will require to store objects in separate places.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index 134fe7510195..ec98595b8a7a 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> > @@ -415,7 +415,7 @@ void media_device_unregister(struct media_device *mdev)
> >  	struct media_entity *entity;
> >  	struct media_entity *next;
> > 
> > -	list_for_each_entry_safe(entity, next, &mdev->entities, list)
> > +	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
> >  		media_device_unregister_entity(entity);
> > 
> >  	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
> > @@ -449,7 +449,6 @@ int __must_check media_device_register_entity(struct
> > media_device *mdev, spin_lock(&mdev->lock);
> >  	/* Initialize media_gobj embedded at the entity */
> >  	media_gobj_init(mdev, MEDIA_GRAPH_ENTITY, &entity->graph_obj);
> > -	list_add_tail(&entity->list, &mdev->entities);
> > 
> >  	/* Initialize objects at the pads */
> >  	for (i = 0; i < entity->num_pads; i++)
> > @@ -487,7 +486,6 @@ void media_device_unregister_entity(struct media_entity
> > *entity) for (i = 0; i < entity->num_pads; i++)
> >  		media_gobj_remove(&entity->pads[i].graph_obj);
> >  	media_gobj_remove(&entity->graph_obj);
> > -	list_del(&entity->list);
> >  	spin_unlock(&mdev->lock);
> >  	entity->graph_obj.mdev = NULL;
> >  }
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index 6ed5eef88593..cbb0604e81c1 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -170,6 +170,7 @@ void media_gobj_init(struct media_device *mdev,
> >  	switch (type) {
> >  	case MEDIA_GRAPH_ENTITY:
> >  		gobj->id = media_gobj_gen_id(type, ++mdev->entity_id);
> > +		list_add_tail(&gobj->list, &mdev->entities);
> >  		break;
> >  	case MEDIA_GRAPH_PAD:
> >  		gobj->id = media_gobj_gen_id(type, ++mdev->pad_id);
> > @@ -178,6 +179,7 @@ void media_gobj_init(struct media_device *mdev,
> >  		gobj->id = media_gobj_gen_id(type, ++mdev->link_id);
> >  		break;
> >  	case MEDIA_GRAPH_INTF_DEVNODE:
> > +		list_add_tail(&gobj->list, &mdev->interfaces);
> >  		gobj->id = media_gobj_gen_id(type, ++mdev->intf_devnode_id);
> >  		break;
> >  	}
> > @@ -193,6 +195,16 @@ void media_gobj_init(struct media_device *mdev,
> >   */
> >  void media_gobj_remove(struct media_gobj *gobj)
> >  {
> > +	/* Remove the object from mdev list */
> > +	switch (media_type(gobj)) {
> > +	case MEDIA_GRAPH_ENTITY:
> > +	case MEDIA_GRAPH_INTF_DEVNODE:
> > +		list_del(&gobj->list);
> > +		break;
> 
> Type-specific handling in the graph object code doesn't seem right. I'd keep 
> the list_del calls in the type-specific remove functions. Same for the 
> list_add_tail calls above, unless we switch from per-type lists to a single 
> graph objects list as I mentioned in a reply to another patch (and the more I 
> think about it the more tempting it gets).

I commented about that already. IMHO, keeping everything needed to
unregister a graph object is the way to go, as it saves troubles of
having type-specific unregister functions for everything, and the
state of the object removal will be sane after the end of calling
this function.

Using a single graph object list decreases the performance, as
already explained.

Regards,
Mauro
