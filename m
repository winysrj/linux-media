Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:52497 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754683AbbHNPTB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2015 11:19:01 -0400
Message-ID: <55CE06C4.7080100@xs4all.nl>
Date: Fri, 14 Aug 2015 17:18:28 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 6/6] media: use media_graph_obj inside links
References: <cover.1439563682.git.mchehab@osg.samsung.com> <b7b0a4f38b7ae2bb3bd69aeaf3476250f489d50a.1439563682.git.mchehab@osg.samsung.com>
In-Reply-To: <b7b0a4f38b7ae2bb3bd69aeaf3476250f489d50a.1439563682.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/14/2015 04:56 PM, Mauro Carvalho Chehab wrote:
> Just like entities and pads, links also need to have unique
> Object IDs along a given media controller.
> 
> So, let's add a media_graph_obj inside it and initialize
> the object then a new link is created.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 3ac5803b327e..9f02939c2864 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -466,6 +466,8 @@ void media_device_unregister_entity(struct media_entity *entity)
>  	graph_obj_remove(&entity->graph_obj);
>  	for (i = 0; i < entity->num_pads; i++)
>  		graph_obj_remove(&entity->pads[i].graph_obj);
> +	for (i = 0; entity->num_links; i++)
> +		graph_obj_remove(&entity->links[i].graph_obj);
>  	list_del(&entity->list);
>  	spin_unlock(&mdev->lock);
>  	entity->parent = NULL;
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index d3dee6fc79d7..4f18bd10b162 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -50,6 +50,8 @@ void graph_obj_init(struct media_device *mdev,
>  		gobj->id |= ++mdev->entity_id;
>  	case MEDIA_GRAPH_PAD:
>  		gobj->id |= ++mdev->pad_id;
> +	case MEDIA_GRAPH_LINK:
> +		gobj->id |= ++mdev->pad_id;

Same issue with missing breaks. Also for links you want to use link_id, not
pad_id. Clearly a copy-and-paste mistake.

A bigger question is whether you actually need graph_obj for a link? Links are
*between* graph objects, but are they really graph objects in their own right?

Currently a link is identified by the source/sink objects and I think that is
all you need. I didn't realize that when reviewing the v3 patch series, but I'm
now wondering about it.

If you *don't* make links a graph_obj, will anything break or become difficult
to use? I don't think so, but let me know if I am overlooking something.

>  	}
>  }
>  
> @@ -469,6 +471,10 @@ static struct media_link *media_entity_add_link(struct media_entity *entity)
>  		entity->links = links;
>  	}
>  
> +	/* Initialize graph object embedded at the new link */
> +	graph_obj_init(entity->parent, MEDIA_GRAPH_LINK,
> +			&entity->links[entity->num_links].graph_obj);
> +
>  	return &entity->links[entity->num_links++];
>  }
>  
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index 2a9d9260cccc..2d9a050d46f7 100644
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
> @@ -72,6 +73,7 @@ struct media_device {
>  	/* Unique object ID counter */
>  	u32 entity_id;
>  	u32 pad_id;
> +	u32 link_id;
>  
>  	struct list_head entities;
>  
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 936f68f27bba..30eaae47d72e 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -35,10 +35,12 @@
>   *
>   * @MEDIA_GRAPH_ENTITY:		Identify a media entity
>   * @MEDIA_GRAPH_PAD:		Identify a media pad
> + * @MEDIA_GRAPH_LINK:		Identify a media link
>   */
>  enum media_graph_type {
>  	MEDIA_GRAPH_ENTITY,
>  	MEDIA_GRAPH_PAD,
> +	MEDIA_GRAPH_LINK,
>  };
>  
>  
> @@ -61,6 +63,7 @@ struct media_pipeline {
>  };
>  
>  struct media_link {
> +	struct media_graph_obj graph_obj;
>  	struct media_pad *source;	/* Source pad */
>  	struct media_pad *sink;		/* Sink pad  */
>  	struct media_link *reverse;	/* Link in the reverse direction */
> 

Regards,

	Hans
