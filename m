Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:34672 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752168AbbIKOAd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 10:00:33 -0400
Message-ID: <55F2DE39.90307@xs4all.nl>
Date: Fri, 11 Sep 2015 15:59:21 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v8 46/55] [media] media: move mdev list init to gobj
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com> <7b800aebe4c9f6549942fd95b40d4263dcffe3bc.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <7b800aebe4c9f6549942fd95b40d4263dcffe3bc.1441540862.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/2015 02:03 PM, Mauro Carvalho Chehab wrote:
> Let's control the topology changes inside the graph_object. So, move the
> addition and removal of interfaces/entities from the mdev lists to
> media_gobj_init() and media_gobj_remove().
> 
> The main reason is that mdev should have lists for all object types, as
> the new MC api will require to store objects in separate places.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 134fe7510195..ec98595b8a7a 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -415,7 +415,7 @@ void media_device_unregister(struct media_device *mdev)
>  	struct media_entity *entity;
>  	struct media_entity *next;
>  
> -	list_for_each_entry_safe(entity, next, &mdev->entities, list)
> +	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
>  		media_device_unregister_entity(entity);
>  
>  	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
> @@ -449,7 +449,6 @@ int __must_check media_device_register_entity(struct media_device *mdev,
>  	spin_lock(&mdev->lock);
>  	/* Initialize media_gobj embedded at the entity */
>  	media_gobj_init(mdev, MEDIA_GRAPH_ENTITY, &entity->graph_obj);
> -	list_add_tail(&entity->list, &mdev->entities);
>  
>  	/* Initialize objects at the pads */
>  	for (i = 0; i < entity->num_pads; i++)
> @@ -487,7 +486,6 @@ void media_device_unregister_entity(struct media_entity *entity)
>  	for (i = 0; i < entity->num_pads; i++)
>  		media_gobj_remove(&entity->pads[i].graph_obj);
>  	media_gobj_remove(&entity->graph_obj);
> -	list_del(&entity->list);
>  	spin_unlock(&mdev->lock);
>  	entity->graph_obj.mdev = NULL;
>  }
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 6ed5eef88593..cbb0604e81c1 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -170,6 +170,7 @@ void media_gobj_init(struct media_device *mdev,
>  	switch (type) {
>  	case MEDIA_GRAPH_ENTITY:
>  		gobj->id = media_gobj_gen_id(type, ++mdev->entity_id);
> +		list_add_tail(&gobj->list, &mdev->entities);
>  		break;
>  	case MEDIA_GRAPH_PAD:
>  		gobj->id = media_gobj_gen_id(type, ++mdev->pad_id);
> @@ -178,6 +179,7 @@ void media_gobj_init(struct media_device *mdev,
>  		gobj->id = media_gobj_gen_id(type, ++mdev->link_id);
>  		break;
>  	case MEDIA_GRAPH_INTF_DEVNODE:
> +		list_add_tail(&gobj->list, &mdev->interfaces);
>  		gobj->id = media_gobj_gen_id(type, ++mdev->intf_devnode_id);
>  		break;
>  	}
> @@ -193,6 +195,16 @@ void media_gobj_init(struct media_device *mdev,
>   */
>  void media_gobj_remove(struct media_gobj *gobj)
>  {
> +	/* Remove the object from mdev list */
> +	switch (media_type(gobj)) {
> +	case MEDIA_GRAPH_ENTITY:
> +	case MEDIA_GRAPH_INTF_DEVNODE:
> +		list_del(&gobj->list);
> +		break;
> +	default:
> +		break;
> +	}
> +
>  	dev_dbg_obj(__func__, gobj);
>  }
>  
> @@ -864,8 +876,6 @@ static void media_interface_init(struct media_device *mdev,
>  	INIT_LIST_HEAD(&intf->links);
>  
>  	media_gobj_init(mdev, gobj_type, &intf->graph_obj);
> -
> -	list_add_tail(&intf->list, &mdev->interfaces);
>  }
>  
>  /* Functions related to the media interface via device nodes */
> @@ -894,7 +904,6 @@ EXPORT_SYMBOL_GPL(media_devnode_create);
>  void media_devnode_remove(struct media_intf_devnode *devnode)
>  {
>  	media_gobj_remove(&devnode->intf.graph_obj);
> -	list_del(&devnode->intf.list);
>  	kfree(devnode);
>  }
>  EXPORT_SYMBOL_GPL(media_devnode_remove);
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index f23d686aaac6..85fa302047bd 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -111,11 +111,11 @@ struct media_device *media_device_find_devres(struct device *dev);
>  
>  /* Iterate over all entities. */
>  #define media_device_for_each_entity(entity, mdev)			\
> -	list_for_each_entry(entity, &(mdev)->entities, list)
> +	list_for_each_entry(entity, &(mdev)->entities, graph_obj.list)
>  
>  /* Iterate over all interfaces. */
>  #define media_device_for_each_intf(intf, mdev)			\
> -	list_for_each_entry(intf, &(mdev)->interfaces, list)
> +	list_for_each_entry(intf, &(mdev)->interfaces, graph_obj.list)
>  
>  
>  #else
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 2d5ad40254b7..bc7eb6240795 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -66,6 +66,7 @@ enum media_gobj_type {
>  struct media_gobj {
>  	struct media_device	*mdev;
>  	u32			id;
> +	struct list_head	list;
>  };
>  
>  
> @@ -114,7 +115,6 @@ struct media_entity_operations {
>  
>  struct media_entity {
>  	struct media_gobj graph_obj;	/* must be first field in struct */
> -	struct list_head list;
>  	const char *name;		/* Entity name */
>  	u32 type;			/* Entity type (MEDIA_ENT_T_*) */
>  	u32 revision;			/* Entity revision, driver specific */
> @@ -166,7 +166,6 @@ struct media_entity {
>   */
>  struct media_interface {
>  	struct media_gobj		graph_obj;
> -	struct list_head		list;
>  	struct list_head		links;
>  	u32				type;
>  	u32				flags;
> 

