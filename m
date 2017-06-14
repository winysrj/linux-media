Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35230 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751727AbdFNKB5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 06:01:57 -0400
Date: Wed, 14 Jun 2017 13:01:50 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v3 2/2] media: entity: Add media_entity_get_fwnode_pad()
 function
Message-ID: <20170614100149.GI12407@valkosipuli.retiisi.org.uk>
References: <20170613143126.755-1-niklas.soderlund+renesas@ragnatech.se>
 <20170613143126.755-3-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170613143126.755-3-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thanks for the update!

On Tue, Jun 13, 2017 at 04:31:26PM +0200, Niklas Söderlund wrote:
> This is a wrapper around the media entity get_fwnode_pad operation.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/media-entity.c | 35 +++++++++++++++++++++++++++++++++++
>  include/media/media-entity.h | 23 +++++++++++++++++++++++
>  2 files changed, 58 insertions(+)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index bc44193efa4798b4..35a15263793f71e1 100644
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
> @@ -386,6 +387,40 @@ struct media_entity *media_graph_walk_next(struct media_graph *graph)
>  }
>  EXPORT_SYMBOL_GPL(media_graph_walk_next);
>  
> +int media_entity_get_fwnode_pad(struct media_entity *entity,
> +				struct fwnode_handle *fwnode,
> +				unsigned int direction)

media entity pad flags has unsigned long type. I think you should call this
e.g. direction_flags or pad_direction_flags. It'd be clear that it's about
pad flags and only the direction matters.

> +{
> +	struct fwnode_endpoint endpoint;
> +	int i, ret;

media entity num_pads field is u16. I guess unsigned int is fine, but it
should be unsigned at least.

With these,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> +
> +	if (!entity->ops || !entity->ops->get_fwnode_pad) {
> +		for (i = 0; i < entity->num_pads; i++) {
> +			if (entity->pads[i].flags & direction)
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
> +	if (!(entity->pads[ret].flags & direction))
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
> index 46eeb036aa330534..4114e06964824ec9 100644
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
> + * @direction: Expected direction of the pad, as defined in
> + *	       :ref:`include/uapi/linux/media.h <media_header>`
> + *	       (seek for ``MEDIA_PAD_FL_*``)
> + *
> + * This function can be used to resolve the media pad number from
> + * a fwnode. This is useful for devices which use more complex
> + * mappings of media pads.
> + *
> + * If the entity dose not implement the get_fwnode_pad() operation
> + * then this function searches the entity for the first pad that
> + * matches the @direction.
> + *
> + * Return: returns the pad number on success or a negative error code.
> + */
> +int media_entity_get_fwnode_pad(struct media_entity *entity,
> +				struct fwnode_handle *fwnode,
> +				unsigned int direction);
> +
> +/**
>   * media_graph_walk_init - Allocate resources used by graph walk.
>   *
>   * @graph: Media graph structure that will be used to walk the graph

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
