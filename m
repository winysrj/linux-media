Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47407 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751976AbbHNWM3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2015 18:12:29 -0400
Date: Sat, 15 Aug 2015 01:12:27 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 4/6] media: use media_graph_obj inside entities
Message-ID: <20150814221227.GC28370@valkosipuli.retiisi.org.uk>
References: <cover.1439563682.git.mchehab@osg.samsung.com>
 <c4f28657fcd882ce4eef2738a4319bb685f70915.1439563682.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4f28657fcd882ce4eef2738a4319bb685f70915.1439563682.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Fri, Aug 14, 2015 at 11:56:41AM -0300, Mauro Carvalho Chehab wrote:
> As entities are graph elements, let's embeed media_graph_obj
> on it. That ensures an unique ID for entities that can be
> global along the entire media controller.
> 
> For now, we'll keep the already existing entity ID. Such
> field need to be dropped on some point, but for now, let's
> not do this, to avoid needing to review all drivers and
> the userspace apps.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index b9382f06044a..f06b08392007 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -377,7 +377,6 @@ int __must_check __media_device_register(struct media_device *mdev,
>  	if (WARN_ON(mdev->dev == NULL || mdev->model[0] == 0))
>  		return -EINVAL;
>  
> -	mdev->entity_id = 1;
>  	INIT_LIST_HEAD(&mdev->entities);
>  	spin_lock_init(&mdev->lock);
>  	mutex_init(&mdev->graph_mutex);
> @@ -431,11 +430,9 @@ int __must_check media_device_register_entity(struct media_device *mdev,
>  	entity->parent = mdev;
>  
>  	spin_lock(&mdev->lock);
> -	if (entity->id == 0)
> -		entity->id = mdev->entity_id++;
> -	else
> -		mdev->entity_id = max(entity->id + 1, mdev->entity_id);
> -	list_add_tail(&entity->list, &mdev->entities);
> +	/* Initialize media_graph_obj embedded at the entity */
> +	graph_obj_init(mdev, MEDIA_GRAPH_ENTITY, &entity->graph_obj);
> +
>  	spin_unlock(&mdev->lock);
>  
>  	return 0;
> @@ -457,6 +454,7 @@ void media_device_unregister_entity(struct media_entity *entity)
>  		return;
>  
>  	spin_lock(&mdev->lock);
> +	graph_obj_remove(&entity->graph_obj);
>  	list_del(&entity->list);
>  	spin_unlock(&mdev->lock);
>  	entity->parent = NULL;
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 046f1fe40b50..c06546509a89 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -43,8 +43,12 @@ void graph_obj_init(struct media_device *mdev,
>  			   enum media_graph_type type,
>  			   struct media_graph_obj *gobj)
>  {
> -	/* An unique object ID will be provided on next patches */
> +	/* Create a per-type unique object ID */
>  	gobj->id = type << 24;
> +	switch (type) {
> +	case MEDIA_GRAPH_ENTITY:
> +		gobj->id |= ++mdev->entity_id;
> +	}
>  }
>  
>  /**
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index 6e6db78f1ee2..35634c0da362 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -41,7 +41,7 @@ struct device;
>   * @bus_info:	Unique and stable device location identifier
>   * @hw_revision: Hardware device revision
>   * @driver_version: Device driver version
> - * @entity_id:	ID of the next entity to be registered
> + * @entity_id:	Unique ID used on the last entity registered
>   * @entities:	List of registered entities
>   * @lock:	Entities list lock
>   * @graph_mutex: Entities graph operation lock
> @@ -68,7 +68,9 @@ struct media_device {
>  	u32 hw_revision;
>  	u32 driver_version;
>  
> +	/* Unique object ID counter */

I think the KernelDoc above should be enough.

>  	u32 entity_id;
> +
>  	struct list_head entities;
>  
>  	/* Protects the entities list */
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 58938bb980fe..2c775f3ef24f 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -33,10 +33,10 @@
>  /**
>   * enum media_graph_type - type of a graph element
>   *
> + * @MEDIA_GRAPH_ENTITY:		Identify a media entity
>   */
>  enum media_graph_type {
> -	 /* FIXME: add the types here, as we embeed media_graph_obj */
> -	MEDIA_GRAPH_NONE
> +	MEDIA_GRAPH_ENTITY,
>  };
>  
>  
> @@ -88,10 +88,9 @@ struct media_entity_operations {
>  };
>  
>  struct media_entity {
> +	struct media_graph_obj graph_obj;
>  	struct list_head list;
>  	struct media_device *parent;	/* Media device this entity belongs to*/
> -	u32 id;				/* Entity ID, unique in the parent media
> -					 * device context */
>  	const char *name;		/* Entity name */
>  	u32 type;			/* Entity type (MEDIA_ENT_T_*) */
>  	u32 revision;			/* Entity revision, driver specific */
> @@ -153,7 +152,7 @@ struct media_entity_graph {
>  	int top;
>  };
>  
> -#define entity_id(entity) ((entity)->id)
> +#define entity_id(entity) ((entity)->graph_obj.id)
>  
>  #define gobj_to_entity(gobj) \
>  		container_of(gobj, struct media_entity, graph_obj)

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
