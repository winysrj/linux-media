Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39397 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbbKWW2Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2015 17:28:16 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v8 47/55] [media] media-device: add pads and links to media_device
Date: Tue, 24 Nov 2015 00:28:24 +0200
Message-ID: <1719719.uHu2Ij6nVQ@avalon>
In-Reply-To: <ab2ed3a063cca99241aee1b488245b7ddeac7185.1441540862.git.mchehab@osg.samsung.com>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com> <ab2ed3a063cca99241aee1b488245b7ddeac7185.1441540862.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Sunday 06 September 2015 09:03:07 Mauro Carvalho Chehab wrote:
> The MC next gen API sends objects to userspace grouped by
> their types.
> 
> In the case of pads and links, in order to improve performance

Are we sure it really improves performances ?

> and have a simpler code, the best is to store them also on
> separate linked lists at MC.

Have you considered the approach of storing them in a single list of objects 
instead of per-type lists ? I wonder if it could be helpful. What bothers me 
here is that we violate layers by using the list field in the graph object 
structure to store it in lists specific to the individual graph object types. 
Such violations have proved to be bad ideas in most cases, even if I can't 
pinpoint why right now. It could of course also be an exception.

> If we don't do that, we would need this kind of interaction
> to send data to userspace (code is in structured english):
> 
> 	for each entity:
> 		for each pad:
> 			store pads
> 
> 	for each entity:
> 		for each link:
> 			store link
> 
> 	for each interface:
> 		for each link:
> 			store link
> 
> With would require one nexted loop for pads and two nested

s/nexted loop/nested loop/

> loops for links. By using  separate linked lists for them,
> just one loop would be enough.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index ec98595b8a7a..5b2c9f7fcd45 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -382,6 +382,8 @@ int __must_check __media_device_register(struct
> media_device *mdev,
> 
>  	INIT_LIST_HEAD(&mdev->entities);
>  	INIT_LIST_HEAD(&mdev->interfaces);
> +	INIT_LIST_HEAD(&mdev->pads);
> +	INIT_LIST_HEAD(&mdev->links);
>  	spin_lock_init(&mdev->lock);
>  	mutex_init(&mdev->graph_mutex);
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index cbb0604e81c1..568553d41f5d 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -174,13 +174,15 @@ void media_gobj_init(struct media_device *mdev,
>  		break;
>  	case MEDIA_GRAPH_PAD:
>  		gobj->id = media_gobj_gen_id(type, ++mdev->pad_id);
> +		list_add_tail(&gobj->list, &mdev->pads);
>  		break;
>  	case MEDIA_GRAPH_LINK:
>  		gobj->id = media_gobj_gen_id(type, ++mdev->link_id);
> +		list_add_tail(&gobj->list, &mdev->links);
>  		break;
>  	case MEDIA_GRAPH_INTF_DEVNODE:
> -		list_add_tail(&gobj->list, &mdev->interfaces);
>  		gobj->id = media_gobj_gen_id(type, ++mdev->intf_devnode_id);
> +		list_add_tail(&gobj->list, &mdev->interfaces);
>  		break;
>  	}
>  	dev_dbg_obj(__func__, gobj);
> @@ -195,17 +197,10 @@ void media_gobj_init(struct media_device *mdev,
>   */
>  void media_gobj_remove(struct media_gobj *gobj)
>  {
> +	dev_dbg_obj(__func__, gobj);
> +
>  	/* Remove the object from mdev list */
> -	switch (media_type(gobj)) {
> -	case MEDIA_GRAPH_ENTITY:
> -	case MEDIA_GRAPH_INTF_DEVNODE:
> -		list_del(&gobj->list);
> -		break;
> -	default:
> -		break;
> -	}
> -
> -	dev_dbg_obj(__func__, gobj);
> +	list_del(&gobj->list);
>  }
> 
>  /**
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index 85fa302047bd..0d1b9c687454 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -47,6 +47,8 @@ struct device;
>   * @intf_devnode_id: Unique ID used on the last interface devnode
> registered * @entities:	List of registered entities
>   * @interfaces:	List of registered interfaces
> + * @pads:	List of registered pads
> + * @links:	List of registered links
>   * @lock:	Entities list lock
>   * @graph_mutex: Entities graph operation lock
>   * @link_notify: Link state change notification callback
> @@ -79,6 +81,8 @@ struct media_device {
> 
>  	struct list_head entities;
>  	struct list_head interfaces;
> +	struct list_head pads;
> +	struct list_head links;
> 
>  	/* Protects the entities list */
>  	spinlock_t lock;
> @@ -117,6 +121,14 @@ struct media_device *media_device_find_devres(struct
> device *dev); #define media_device_for_each_intf(intf, mdev)			\
>  	list_for_each_entry(intf, &(mdev)->interfaces, graph_obj.list)
> 
> +/* Iterate over all pads. */
> +#define media_device_for_each_pad(pad, mdev)			\
> +	list_for_each_entry(pad, &(mdev)->pads, graph_obj.list)
> +
> +/* Iterate over all links. */
> +#define media_device_for_each_link(link, mdev)			\
> +	list_for_each_entry(link, &(mdev)->links, graph_obj.list)
> +
> 
>  #else
>  static inline int media_device_register(struct media_device *mdev)

-- 
Regards,

Laurent Pinchart

