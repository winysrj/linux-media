Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:54435 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752276AbbHaM0L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 08:26:11 -0400
Message-ID: <55E447AB.3070202@xs4all.nl>
Date: Mon, 31 Aug 2015 14:25:15 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v8 47/55] [media] media-device: add pads and links to
 media_device
References: <cover.1440902901.git.mchehab@osg.samsung.com> <4579c96afc1354e38e042de43ac976282638fb2f.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <4579c96afc1354e38e042de43ac976282638fb2f.1440902901.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/30/2015 05:06 AM, Mauro Carvalho Chehab wrote:
> The MC next gen API sends objects to userspace grouped by
> their types.
> 
> In the case of pads and links, in order to improve performance
> and have a simpler code, the best is to store them also on
> separate linked lists at MC.
> 
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
> loops for links. By using  separate linked lists for them,
> just one loop would be enough.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index ec98595b8a7a..5b2c9f7fcd45 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -382,6 +382,8 @@ int __must_check __media_device_register(struct media_device *mdev,
>  
>  	INIT_LIST_HEAD(&mdev->entities);
>  	INIT_LIST_HEAD(&mdev->interfaces);
> +	INIT_LIST_HEAD(&mdev->pads);
> +	INIT_LIST_HEAD(&mdev->links);
>  	spin_lock_init(&mdev->lock);
>  	mutex_init(&mdev->graph_mutex);
>  
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 192af193a394..c89f51bc688d 100644
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
> @@ -195,16 +197,10 @@ void media_gobj_init(struct media_device *mdev,
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
>   * @intf_devnode_id: Unique ID used on the last interface devnode registered
>   * @entities:	List of registered entities
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
> @@ -117,6 +121,14 @@ struct media_device *media_device_find_devres(struct device *dev);
>  #define media_device_for_each_intf(intf, mdev)			\
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
> 

