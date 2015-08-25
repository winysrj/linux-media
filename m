Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:34677 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755517AbbHYJbP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 05:31:15 -0400
Message-ID: <55DC353D.8000807@xs4all.nl>
Date: Tue, 25 Aug 2015 11:28:29 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v7 41/44] [media] media: move mdev list init to gobj
References: <cover.1440359643.git.mchehab@osg.samsung.com> <bc5eb0364214343677965f660fda7337b97ec318.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <bc5eb0364214343677965f660fda7337b97ec318.1440359643.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/23/15 22:17, Mauro Carvalho Chehab wrote:
> Let's control the topology changes inside the graph_object.
> So, move the removal of interfaces/entitis from the mdev

s/entitis/entities/

> lists to media_gobj_init() and media_gobj_remove().
> 
> The main reason is that mdev should have lists for all
> object types, as the new MC api will require to store
> objects on separate places.

s/on/in/

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 659507bce63f..01cd014963d6 100644
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
> @@ -443,7 +443,6 @@ int __must_check media_device_register_entity(struct media_device *mdev,
>  	spin_lock(&mdev->lock);
>  	/* Initialize media_gobj embedded at the entity */
>  	media_gobj_init(mdev, MEDIA_GRAPH_ENTITY, &entity->graph_obj);
> -	list_add_tail(&entity->list, &mdev->entities);
>  
>  	/* Initialize objects at the pads */
>  	for (i = 0; i < entity->num_pads; i++)
> @@ -473,7 +472,7 @@ void media_device_unregister_entity(struct media_entity *entity)
>  		return;
>  
>  	spin_lock(&mdev->lock);
> -	list_for_each_entry_safe(link, tmp, &entity->links, list) {
> +	list_for_each_entry_safe(link, tmp, &entity->links, graph_obj.list) {
>  		media_gobj_remove(&link->graph_obj);
>  		list_del(&link->list);
>  		kfree(link);
> @@ -481,7 +480,6 @@ void media_device_unregister_entity(struct media_entity *entity)
>  	for (i = 0; i < entity->num_pads; i++)
>  		media_gobj_remove(&entity->pads[i].graph_obj);
>  	media_gobj_remove(&entity->graph_obj);
> -	list_del(&entity->list);
>  	spin_unlock(&mdev->lock);
>  	entity->graph_obj.mdev = NULL;
>  }
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index d30650e3562e..17f2f7555d42 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -168,6 +168,7 @@ void media_gobj_init(struct media_device *mdev,
>  	switch (type) {
>  	case MEDIA_GRAPH_ENTITY:
>  		gobj->id = media_gobj_gen_id(type, ++mdev->entity_id);
> +		list_add_tail(&gobj->list, &mdev->entities);
>  		break;
>  	case MEDIA_GRAPH_PAD:
>  		gobj->id = media_gobj_gen_id(type, ++mdev->pad_id);
> @@ -176,6 +177,7 @@ void media_gobj_init(struct media_device *mdev,
>  		gobj->id = media_gobj_gen_id(type, ++mdev->link_id);
>  		break;
>  	case MEDIA_GRAPH_INTF_DEVNODE:
> +		list_add_tail(&gobj->list, &mdev->interfaces);
>  		gobj->id = media_gobj_gen_id(type, ++mdev->intf_devnode_id);
>  		break;
>  	}
> @@ -191,6 +193,15 @@ void media_gobj_init(struct media_device *mdev,
>   */
>  void media_gobj_remove(struct media_gobj *gobj)
>  {
> +	/* Remove the object from mdev list */
> +	switch (media_type(gobj)) {
> +	case MEDIA_GRAPH_ENTITY:
> +	case MEDIA_GRAPH_INTF_DEVNODE:
> +		list_del(&gobj->list);

Missing break!

> +	default:
> +		break;
> +	}
> +
>  	dev_dbg_obj(__func__, gobj);
>  }
>  
> @@ -878,8 +889,6 @@ struct media_intf_devnode *media_devnode_create(struct media_device *mdev,
>  	media_gobj_init(mdev, MEDIA_GRAPH_INTF_DEVNODE,
>  		       &devnode->intf.graph_obj);
>  
> -	list_add_tail(&intf->list, &mdev->interfaces);
> -
>  	return devnode;
>  }
>  EXPORT_SYMBOL_GPL(media_devnode_create);
> @@ -887,7 +896,6 @@ EXPORT_SYMBOL_GPL(media_devnode_create);
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
> index 0111d9652b78..d89ceaf7bcc4 100644
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
>  	struct media_gobj graph_obj;	/* should be the first object */
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

Regards,

	Hans
