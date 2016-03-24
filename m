Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40236 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbcCXWLV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 18:11:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 1/5] [media] media-device: get rid of the spinlock
Date: Fri, 25 Mar 2016 00:11:21 +0200
Message-ID: <1707571.F8b41vb3Xc@avalon>
In-Reply-To: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
References: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 16 Mar 2016 09:04:02 Mauro Carvalho Chehab wrote:
> Right now, the lock schema for media_device struct is messy,
> since sometimes, it is protected via a spin lock, while, for
> media graph traversal, it is protected by a mutex.
> 
> Solve this conflict by always using a mutex.
> 
> As a side effect, this prevents a bug where the media notifiers
> were called at atomic context.

And as a side effect the kernel now deadlocks in MEDIA_IOC_ENUM_LINKS. I'm all 
for fixing messy the lock schema, but maybe you should test patches before 
merging them ?

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>  drivers/media/media-device.c | 32 ++++++++++++++------------------
>  drivers/media/media-entity.c | 16 ++++++++--------
>  include/media/media-device.h |  6 +-----
>  3 files changed, 23 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 6e43c95629ea..c32fa15cc76e 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -90,17 +90,17 @@ static struct media_entity *find_entity(struct
> media_device *mdev, u32 id)
> 
>  	id &= ~MEDIA_ENT_ID_FLAG_NEXT;
> 
> -	spin_lock(&mdev->lock);
> +	mutex_lock(&mdev->graph_mutex);
> 
>  	media_device_for_each_entity(entity, mdev) {
>  		if (((media_entity_id(entity) == id) && !next) ||
>  		    ((media_entity_id(entity) > id) && next)) {
> -			spin_unlock(&mdev->lock);
> +			mutex_unlock(&mdev->graph_mutex);
>  			return entity;
>  		}
>  	}
> 
> -	spin_unlock(&mdev->lock);
> +	mutex_unlock(&mdev->graph_mutex);
> 
>  	return NULL;
>  }
> @@ -590,12 +590,12 @@ int __must_check media_device_register_entity(struct
> media_device *mdev, if (!ida_pre_get(&mdev->entity_internal_idx,
> GFP_KERNEL))
>  		return -ENOMEM;
> 
> -	spin_lock(&mdev->lock);
> +	mutex_lock(&mdev->graph_mutex);
> 
>  	ret = ida_get_new_above(&mdev->entity_internal_idx, 1,
>  				&entity->internal_idx);
>  	if (ret < 0) {
> -		spin_unlock(&mdev->lock);
> +		mutex_unlock(&mdev->graph_mutex);
>  		return ret;
>  	}
> 
> @@ -615,9 +615,6 @@ int __must_check media_device_register_entity(struct
> media_device *mdev, (notify)->notify(entity, notify->notify_data);
>  	}
> 
> -	spin_unlock(&mdev->lock);
> -
> -	mutex_lock(&mdev->graph_mutex);
>  	if (mdev->entity_internal_idx_max
> 
>  	    >= mdev->pm_count_walk.ent_enum.idx_max) {
> 
>  		struct media_entity_graph new = { .top = 0 };
> @@ -680,9 +677,9 @@ void media_device_unregister_entity(struct media_entity
> *entity) if (mdev == NULL)
>  		return;
> 
> -	spin_lock(&mdev->lock);
> +	mutex_lock(&mdev->graph_mutex);
>  	__media_device_unregister_entity(entity);
> -	spin_unlock(&mdev->lock);
> +	mutex_unlock(&mdev->graph_mutex);
>  }
>  EXPORT_SYMBOL_GPL(media_device_unregister_entity);
> 
> @@ -703,7 +700,6 @@ void media_device_init(struct media_device *mdev)
>  	INIT_LIST_HEAD(&mdev->pads);
>  	INIT_LIST_HEAD(&mdev->links);
>  	INIT_LIST_HEAD(&mdev->entity_notify);
> -	spin_lock_init(&mdev->lock);
>  	mutex_init(&mdev->graph_mutex);
>  	ida_init(&mdev->entity_internal_idx);
> 
> @@ -752,9 +748,9 @@ EXPORT_SYMBOL_GPL(__media_device_register);
>  int __must_check media_device_register_entity_notify(struct media_device
> *mdev, struct media_entity_notify *nptr)
>  {
> -	spin_lock(&mdev->lock);
> +	mutex_lock(&mdev->graph_mutex);
>  	list_add_tail(&nptr->list, &mdev->entity_notify);
> -	spin_unlock(&mdev->lock);
> +	mutex_unlock(&mdev->graph_mutex);
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(media_device_register_entity_notify);
> @@ -771,9 +767,9 @@ static void
> __media_device_unregister_entity_notify(struct media_device *mdev, void
> media_device_unregister_entity_notify(struct media_device *mdev, struct
> media_entity_notify *nptr)
>  {
> -	spin_lock(&mdev->lock);
> +	mutex_lock(&mdev->graph_mutex);
>  	__media_device_unregister_entity_notify(mdev, nptr);
> -	spin_unlock(&mdev->lock);
> +	mutex_unlock(&mdev->graph_mutex);
>  }
>  EXPORT_SYMBOL_GPL(media_device_unregister_entity_notify);
> 
> @@ -787,11 +783,11 @@ void media_device_unregister(struct media_device
> *mdev) if (mdev == NULL)
>  		return;
> 
> -	spin_lock(&mdev->lock);
> +	mutex_lock(&mdev->graph_mutex);
> 
>  	/* Check if mdev was ever registered at all */
>  	if (!media_devnode_is_registered(&mdev->devnode)) {
> -		spin_unlock(&mdev->lock);
> +		mutex_unlock(&mdev->graph_mutex);
>  		return;
>  	}
> 
> @@ -811,7 +807,7 @@ void media_device_unregister(struct media_device *mdev)
>  		kfree(intf);
>  	}
> 
> -	spin_unlock(&mdev->lock);
> +	mutex_unlock(&mdev->graph_mutex);
> 
>  	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
>  	media_devnode_unregister(&mdev->devnode);
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index e95070b3a3d4..c53c1d5589a0 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -219,7 +219,7 @@ int media_entity_pads_init(struct media_entity *entity,
> u16 num_pads, entity->pads = pads;
> 
>  	if (mdev)
> -		spin_lock(&mdev->lock);
> +		mutex_lock(&mdev->graph_mutex);
> 
>  	for (i = 0; i < num_pads; i++) {
>  		pads[i].entity = entity;
> @@ -230,7 +230,7 @@ int media_entity_pads_init(struct media_entity *entity,
> u16 num_pads, }
> 
>  	if (mdev)
> -		spin_unlock(&mdev->lock);
> +		mutex_unlock(&mdev->graph_mutex);
> 
>  	return 0;
>  }
> @@ -747,9 +747,9 @@ void media_entity_remove_links(struct media_entity
> *entity) if (mdev == NULL)
>  		return;
> 
> -	spin_lock(&mdev->lock);
> +	mutex_lock(&mdev->graph_mutex);
>  	__media_entity_remove_links(entity);
> -	spin_unlock(&mdev->lock);
> +	mutex_unlock(&mdev->graph_mutex);
>  }
>  EXPORT_SYMBOL_GPL(media_entity_remove_links);
> 
> @@ -951,9 +951,9 @@ void media_remove_intf_link(struct media_link *link)
>  	if (mdev == NULL)
>  		return;
> 
> -	spin_lock(&mdev->lock);
> +	mutex_lock(&mdev->graph_mutex);
>  	__media_remove_intf_link(link);
> -	spin_unlock(&mdev->lock);
> +	mutex_unlock(&mdev->graph_mutex);
>  }
>  EXPORT_SYMBOL_GPL(media_remove_intf_link);
> 
> @@ -975,8 +975,8 @@ void media_remove_intf_links(struct media_interface
> *intf) if (mdev == NULL)
>  		return;
> 
> -	spin_lock(&mdev->lock);
> +	mutex_lock(&mdev->graph_mutex);
>  	__media_remove_intf_links(intf);
> -	spin_unlock(&mdev->lock);
> +	mutex_unlock(&mdev->graph_mutex);
>  }
>  EXPORT_SYMBOL_GPL(media_remove_intf_links);
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index df74cfa7da4a..0c2de97181f3 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -25,7 +25,6 @@
> 
>  #include <linux/list.h>
>  #include <linux/mutex.h>
> -#include <linux/spinlock.h>
> 
>  #include <media/media-devnode.h>
>  #include <media/media-entity.h>
> @@ -304,8 +303,7 @@ struct media_entity_notify {
>   * @pads:	List of registered pads
>   * @links:	List of registered links
>   * @entity_notify: List of registered entity_notify callbacks
> - * @lock:	Entities list lock
> - * @graph_mutex: Entities graph operation lock
> + * @graph_mutex: Protects access to struct media_device data
>   * @pm_count_walk: Graph walk for power state walk. Access serialised using
> *		   graph_mutex.
>   *
> @@ -371,8 +369,6 @@ struct media_device {
>  	/* notify callback list invoked when a new entity is registered */
>  	struct list_head entity_notify;
> 
> -	/* Protects the graph objects creation/removal */
> -	spinlock_t lock;
>  	/* Serializes graph operations. */
>  	struct mutex graph_mutex;
>  	struct media_entity_graph pm_count_walk;

-- 
Regards,

Laurent Pinchart

