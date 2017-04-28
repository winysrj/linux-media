Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50304 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1033755AbdD1KoN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 06:44:13 -0400
Date: Fri, 28 Apr 2017 13:43:39 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 2/2] media: entity: Add media_entity_pad_from_dt_regs()
 function
Message-ID: <20170428104339.GH7456@valkosipuli.retiisi.org.uk>
References: <20170427223323.13861-1-niklas.soderlund+renesas@ragnatech.se>
 <20170427223323.13861-3-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170427223323.13861-3-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hejssan!!!

On Fri, Apr 28, 2017 at 12:33:23AM +0200, Niklas Söderlund wrote:
> This is a wrapper around the media entity pad_from_dt_regs operation.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/media-entity.c | 21 +++++++++++++++++++++
>  include/media/media-entity.h | 22 ++++++++++++++++++++++
>  2 files changed, 43 insertions(+)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 5640ca29da8c9bbc..6ef76186d552724e 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -386,6 +386,27 @@ struct media_entity *media_graph_walk_next(struct media_graph *graph)
>  }
>  EXPORT_SYMBOL_GPL(media_graph_walk_next);
>  
> +int media_entity_pad_from_dt_regs(struct media_entity *entity,
> +				  int port_reg, int reg, unsigned int *pad)
> +{
> +	int ret;
> +
> +	if (!entity->ops || !entity->ops->pad_from_dt_regs) {
> +		*pad = port_reg;

I don't think we should bind the port number in firmware to a pad in V4L2
sub-device interface.

How about looking for a source pad in the entity instead? That's what some
drivers do.

> +		return 0;
> +	}
> +
> +	ret = entity->ops->pad_from_dt_regs(port_reg, reg, pad);
> +	if (ret)
> +		return ret;
> +
> +	if (*pad >= entity->num_pads)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(media_entity_pad_from_dt_regs);
> +
>  /* -----------------------------------------------------------------------------
>   * Pipeline management
>   */
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 47efaf4d825e671b..c60a3713d0a21baf 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -820,6 +820,28 @@ struct media_pad *media_entity_remote_pad(struct media_pad *pad);
>  struct media_entity *media_entity_get(struct media_entity *entity);
>  
>  /**
> + * media_entity_pad_from_dt_regs - Get pad number from DT regs
> + *
> + * @entity: The entity
> + * @port_reg: DT port
> + * @reg: DT reg
> + * @pad: Pointer to pad which will be filled in
> + *
> + * This function can be used to resolve the media pad number from
> + * DT port and reg numbers. This is useful for devices which
> + * uses more complex mappings of media pads then that the
> + * DT port number is equivalent to the media pad number.
> + *
> + * If the entity do not implement the pad_from_dt_regs() operation
> + * this function assumes DT port is equivalent to media pad number
> + * and sets @pad to @port_reg.
> + *
> + * Return: 0 on success else -EINVAL.

-EINVAL suggests the user provided bad parameters, but this isn't the case
here. How about e.g. -ENXIO?

> + */
> +int media_entity_pad_from_dt_regs(struct media_entity *entity,
> +				  int port_reg, int reg, unsigned int *pad);
> +
> +/**
>   * media_graph_walk_init - Allocate resources used by graph walk.
>   *
>   * @graph: Media graph structure that will be used to walk the graph

-- 
Hälsningar,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
