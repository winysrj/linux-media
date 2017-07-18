Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57871 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751462AbdGROig (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 10:38:36 -0400
Subject: Re: [PATCH v4 2/2] media: entity: Add media_entity_get_fwnode_pad()
 function
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20170615091726.22370-1-niklas.soderlund+renesas@ragnatech.se>
 <20170615091726.22370-3-niklas.soderlund+renesas@ragnatech.se>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <ae0bebb9-63f2-8ed8-88b0-a23fe42a1b72@ideasonboard.com>
Date: Tue, 18 Jul 2017 15:38:31 +0100
MIME-Version: 1.0
In-Reply-To: <20170615091726.22370-3-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Small spelling error discovered in here:

On 15/06/17 10:17, Niklas Söderlund wrote:
> This is a wrapper around the media entity get_fwnode_pad operation.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/media-entity.c | 36 ++++++++++++++++++++++++++++++++++++
>  include/media/media-entity.h | 23 +++++++++++++++++++++++
>  2 files changed, 59 insertions(+)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index bc44193efa4798b4..82d6755bd5d0d5f0 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -18,6 +18,7 @@
>  
>  #include <linux/bitmap.h>
>  #include <linux/module.h>
> +#include <linux/property.h>
>  #include <linux/slab.h>
>  #include <media/media-entity.h>
>  #include <media/media-device.h>
> @@ -386,6 +387,41 @@ struct media_entity *media_graph_walk_next(struct media_graph *graph)
>  }
>  EXPORT_SYMBOL_GPL(media_graph_walk_next);
>  
> +int media_entity_get_fwnode_pad(struct media_entity *entity,
> +				struct fwnode_handle *fwnode,

Could fwnode be 'ep' or such to show that we want the pad of the remote endpoint?

fwnode is confusing ...

> +				unsigned long direction_flags)
> +{
> +	struct fwnode_endpoint endpoint;
> +	unsigned int i;
> +	int ret;
> +
> +	if (!entity->ops || !entity->ops->get_fwnode_pad) {
> +		for (i = 0; i < entity->num_pads; i++) {
> +			if (entity->pads[i].flags & direction_flags)
> +				return i;
> +		}
> +
> +		return -ENXIO;
> +	}
> +
> +	ret = fwnode_graph_parse_endpoint(fwnode, &endpoint);
> +	if (ret)
> +		return ret;
> +
> +	ret = entity->ops->get_fwnode_pad(&endpoint);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ret >= entity->num_pads)
> +		return -ENXIO;
> +
> +	if (!(entity->pads[ret].flags & direction_flags))
> +		return -ENXIO;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(media_entity_get_fwnode_pad);
> +
>  /* -----------------------------------------------------------------------------
>   * Pipeline management
>   */
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 46eeb036aa330534..754182d296689675 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -821,6 +821,29 @@ struct media_pad *media_entity_remote_pad(struct media_pad *pad);
>  struct media_entity *media_entity_get(struct media_entity *entity);
>  
>  /**
> + * media_entity_get_fwnode_pad - Get pad number from fwnode
> + *
> + * @entity: The entity
> + * @fwnode: Pointer to the fwnode_handle which should be used to find the pad
> + * @direction_flags: Expected direction of the pad, as defined in
> + *		     :ref:`include/uapi/linux/media.h <media_header>`
> + *		     (seek for ``MEDIA_PAD_FL_*``)
> + *
> + * This function can be used to resolve the media pad number from
> + * a fwnode. This is useful for devices which use more complex
> + * mappings of media pads.
> + *
> + * If the entity dose not implement the get_fwnode_pad() operation

s/dose/does/

> + * then this function searches the entity for the first pad that
> + * matches the @direction_flags.
> + *
> + * Return: returns the pad number on success or a negative error code.
> + */
> +int media_entity_get_fwnode_pad(struct media_entity *entity,
> +				struct fwnode_handle *fwnode,
> +				unsigned long direction_flags);
> +
> +/**
>   * media_graph_walk_init - Allocate resources used by graph walk.
>   *
>   * @graph: Media graph structure that will be used to walk the graph
> 
