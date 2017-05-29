Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:37543 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750837AbdE2Kc1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 May 2017 06:32:27 -0400
Subject: Re: [PATCH v2 2/2] media: entity: Add media_entity_pad_from_fwnode()
 function
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
References: <20170524000907.13061-1-niklas.soderlund@ragnatech.se>
 <20170524000907.13061-3-niklas.soderlund@ragnatech.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ef50bac1-ba66-ab7c-e30d-1f49ec36fee0@xs4all.nl>
Date: Mon, 29 May 2017 12:32:20 +0200
MIME-Version: 1.0
In-Reply-To: <20170524000907.13061-3-niklas.soderlund@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/24/2017 02:09 AM, Niklas Söderlund wrote:
> From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
> This is a wrapper around the media entity pad_from_fwnode operation.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>   drivers/media/media-entity.c | 39 +++++++++++++++++++++++++++++++++++++++
>   include/media/media-entity.h | 22 ++++++++++++++++++++++
>   2 files changed, 61 insertions(+)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index bc44193efa4798b4..c124754f739a8b94 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -18,6 +18,7 @@
>   
>   #include <linux/bitmap.h>
>   #include <linux/module.h>
> +#include <linux/property.h>
>   #include <linux/slab.h>
>   #include <media/media-entity.h>
>   #include <media/media-device.h>
> @@ -386,6 +387,44 @@ struct media_entity *media_graph_walk_next(struct media_graph *graph)
>   }
>   EXPORT_SYMBOL_GPL(media_graph_walk_next);
>   
> +int media_entity_pad_from_fwnode(struct media_entity *entity,
> +				 struct fwnode_handle *fwnode,
> +				 int direction, unsigned int *pad)

I'd use unsigned int or u32 for the direction: it's a bitmask so 'int'
is not really appropriate.

> +{
> +	struct fwnode_endpoint endpoint;
> +	int i, tmp, ret;
> +
> +	if (!entity->ops || !entity->ops->pad_from_fwnode) {
> +		for (i = 0; i < entity->num_pads; i++) {
> +			if (entity->pads[i].flags & direction) {
> +				*pad = i;
> +				return 0;
> +			}
> +		}
> +
> +		return -ENXIO;
> +	}
> +
> +	ret = fwnode_graph_parse_endpoint(fwnode, &endpoint);
> +	if (ret)
> +		return ret;
> +
> +	ret = entity->ops->pad_from_fwnode(&endpoint, &tmp);
> +	if (ret)
> +		return ret;
> +
> +	if (tmp >= entity->num_pads)
> +		return -ENXIO;
> +
> +	if (!(entity->pads[tmp].flags & direction))
> +		return -ENXIO;
> +
> +	*pad = tmp;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(media_entity_pad_from_fwnode);
> +
>   /* -----------------------------------------------------------------------------
>    * Pipeline management
>    */
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 2aea22b0409d1070..7507181609bec43c 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -822,6 +822,28 @@ struct media_pad *media_entity_remote_pad(struct media_pad *pad);
>   struct media_entity *media_entity_get(struct media_entity *entity);
>   
>   /**
> + * media_entity_pad_from_fwnode - Get pad number from fwnode
> + *
> + * @entity: The entity
> + * @fwnode: Pointer to fwnode_handle which should be used to find pad

* @fwnode: Pointer to the fwnode_handle which should be used to find the pad

> + * @direction: Expected direction of the pad
> + * @pad: Pointer to pad which will should be filled in

* @pad: Pointer to the pad which will be filled in

> + *
> + * This function can be used to resolve the media pad number from
> + * a fwnode. This is useful for devices which uses more complex

uses -> use

> + * mappings of media pads.
> + *
> + * If the entity do not implement the pad_from_fwnode() operation

do -> does

> + * this function searches the entity for the first pad that matches

this -> then this

> + * the @direction.
> + *
> + * Return: return 0 on success.
> + */
> +int media_entity_pad_from_fwnode(struct media_entity *entity,
> +				 struct fwnode_handle *fwnode,
> +				 int direction, unsigned int *pad);
> +
> +/**
>    * media_graph_walk_init - Allocate resources used by graph walk.
>    *
>    * @graph: Media graph structure that will be used to walk the graph
> 

Regards,

	Hans
