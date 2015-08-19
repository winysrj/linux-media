Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:46151 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753093AbbHSLNk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2015 07:13:40 -0400
Message-ID: <55D46449.8020307@xs4all.nl>
Date: Wed, 19 Aug 2015 13:11:05 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v6 5/8] [media] media: use media_gobj inside links
References: <cover.1439981515.git.mchehab@osg.samsung.com> <c023b34a71fb87d11ca5d87c4c6883fd06224693.1439981515.git.mchehab@osg.samsung.com>
In-Reply-To: <c023b34a71fb87d11ca5d87c4c6883fd06224693.1439981515.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/19/15 13:01, Mauro Carvalho Chehab wrote:
> Just like entities and pads, links also need to have unique
> Object IDs along a given media controller.
> 
> So, let's add a media_gobj inside it and initialize
> the object then a new link is created.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Hmm, my earlier Ack was lost. Here it is again:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 3bdda16584fe..065f6f08da37 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -438,6 +438,13 @@ int __must_check media_device_register_entity(struct media_device *mdev,
>  	media_gobj_init(mdev, MEDIA_GRAPH_ENTITY, &entity->graph_obj);
>  	list_add_tail(&entity->list, &mdev->entities);
>  
> +	/*
> +	 * Initialize objects at the links
> +	 * in the case where links got created before entity register
> +	 */
> +	for (i = 0; i < entity->num_links; i++)
> +		media_gobj_init(mdev, MEDIA_GRAPH_LINK,
> +				&entity->links[i].graph_obj);
>  	/* Initialize objects at the pads */
>  	for (i = 0; i < entity->num_pads; i++)
>  		media_gobj_init(mdev, MEDIA_GRAPH_PAD,
> @@ -465,6 +472,8 @@ void media_device_unregister_entity(struct media_entity *entity)
>  		return;
>  
>  	spin_lock(&mdev->lock);
> +	for (i = 0; i < entity->num_links; i++)
> +		media_gobj_remove(&entity->links[i].graph_obj);
>  	for (i = 0; i < entity->num_pads; i++)
>  		media_gobj_remove(&entity->pads[i].graph_obj);
>  	media_gobj_remove(&entity->graph_obj);
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 377c6655c5d0..36d725ec5f3d 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -51,6 +51,9 @@ void media_gobj_init(struct media_device *mdev,
>  	case MEDIA_GRAPH_PAD:
>  		gobj->id = media_gobj_gen_id(type, ++mdev->pad_id);
>  		break;
> +	case MEDIA_GRAPH_LINK:
> +		gobj->id = media_gobj_gen_id(type, ++mdev->link_id);
> +		break;
>  	}
>  }
>  
> @@ -491,6 +494,9 @@ media_entity_create_link(struct media_entity *source, u16 source_pad,
>  	link->sink = &sink->pads[sink_pad];
>  	link->flags = flags;
>  
> +	/* Initialize graph object embedded at the new link */
> +	media_gobj_init(source->parent, MEDIA_GRAPH_LINK, &link->graph_obj);
> +
>  	/* Create the backlink. Backlinks are used to help graph traversal and
>  	 * are not reported to userspace.
>  	 */
> @@ -504,6 +510,9 @@ media_entity_create_link(struct media_entity *source, u16 source_pad,
>  	backlink->sink = &sink->pads[sink_pad];
>  	backlink->flags = flags;
>  
> +	/* Initialize graph object embedded at the new link */
> +	media_gobj_init(sink->parent, MEDIA_GRAPH_LINK, &backlink->graph_obj);
> +
>  	link->reverse = backlink;
>  	backlink->reverse = link;
>  
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index 9493721f630e..05414e351f8e 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -43,6 +43,7 @@ struct device;
>   * @driver_version: Device driver version
>   * @entity_id:	Unique ID used on the last entity registered
>   * @pad_id:	Unique ID used on the last pad registered
> + * @link_id:	Unique ID used on the last link registered
>   * @entities:	List of registered entities
>   * @lock:	Entities list lock
>   * @graph_mutex: Entities graph operation lock
> @@ -71,6 +72,7 @@ struct media_device {
>  
>  	u32 entity_id;
>  	u32 pad_id;
> +	u32 link_id;
>  
>  	struct list_head entities;
>  
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 39c9ca8f2e7a..749b46c91217 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -35,10 +35,12 @@
>   *
>   * @MEDIA_GRAPH_ENTITY:		Identify a media entity
>   * @MEDIA_GRAPH_PAD:		Identify a media pad
> + * @MEDIA_GRAPH_LINK:		Identify a media link
>   */
>  enum media_gobj_type {
>  	MEDIA_GRAPH_ENTITY,
>  	MEDIA_GRAPH_PAD,
> +	MEDIA_GRAPH_LINK,
>  };
>  
>  #define MEDIA_BITS_PER_TYPE		8
> @@ -67,6 +69,7 @@ struct media_pipeline {
>  };
>  
>  struct media_link {
> +	struct media_gobj graph_obj;
>  	struct media_pad *source;	/* Source pad */
>  	struct media_pad *sink;		/* Sink pad  */
>  	struct media_link *reverse;	/* Link in the reverse direction */
> 
