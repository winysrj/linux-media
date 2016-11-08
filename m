Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33434 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933181AbcKHMnW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Nov 2016 07:43:22 -0500
Date: Tue, 8 Nov 2016 14:42:38 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH 02/32] media: entity: Add media_entity_has_route()
 function
Message-ID: <20161108124238.GM3217@valkosipuli.retiisi.org.uk>
References: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se>
 <20161102132329.436-3-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20161102132329.436-3-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Wed, Nov 02, 2016 at 02:22:59PM +0100, Niklas Söderlund wrote:
> From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> This is a wrapper around the media entity has_route operation.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/media-entity.c | 29 +++++++++++++++++++++++++++++
>  include/media/media-entity.h |  3 +++
>  2 files changed, 32 insertions(+)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index c68239e..4d03ea7 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -242,6 +242,35 @@ EXPORT_SYMBOL_GPL(media_entity_pads_init);
>   * Graph traversal
>   */
>  
> +/**
> + * media_entity_has_route - Check if two entity pads are connected internally
> + * @entity: The entity
> + * @pad0: The first pad index
> + * @pad1: The second pad index
> + *
> + * This function can be used to check whether two pads of an entity are
> + * connected internally in the entity.
> + *
> + * The caller must hold entity->source->parent->mutex.
> + *
> + * Return: true if the pads are connected internally and false otherwise.
> + */
> +bool media_entity_has_route(struct media_entity *entity, unsigned int pad0,
> +			    unsigned int pad1)
> +{
> +	if (pad0 >= entity->num_pads || pad1 >= entity->num_pads)
> +		return false;
> +
> +	if (pad0 == pad1)
> +		return true;
> +
> +	if (!entity->ops || !entity->ops->has_route)
> +		return true;
> +
> +	return entity->ops->has_route(entity, pad0, pad1);
> +}
> +EXPORT_SYMBOL_GPL(media_entity_has_route);
> +
>  static struct media_entity *
>  media_entity_other(struct media_entity *entity, struct media_link *link)
>  {
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 8f9fc85..5fb3f06 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -851,6 +851,9 @@ void media_entity_graph_walk_cleanup(struct media_entity_graph *graph);
>   */
>  void media_entity_put(struct media_entity *entity);
>  
> +bool media_entity_has_route(struct media_entity *entity, unsigned int sink,
> +			    unsigned int source);

The Kerneldoc documentation should be found here, not in the .c file.

Also the arguments are different from the actual implementation.

That's the diff to what I happen to have here, feel free to use instead:

<URL:http://git.retiisi.org.uk/?p=~sailus/linux.git;a=commitdiff;h=7c3bdf5bde5ac8627c94841bef6c6db34d8d2b2a>

> +
>  /**
>   * media_entity_graph_walk_start - Start walking the media graph at a
>   *	given entity

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
