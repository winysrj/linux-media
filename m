Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37024 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755237Ab3GQTrj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 15:47:39 -0400
Date: Wed, 17 Jul 2013 22:47:03 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2 1/5] media: Fix circular graph traversal
Message-ID: <20130717194703.GB11369@valkosipuli.retiisi.org.uk>
References: <1374072882-14598-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1374072882-14598-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374072882-14598-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, Jul 17, 2013 at 04:54:38PM +0200, Laurent Pinchart wrote:
> The graph traversal API (media_entity_graph_walk_*) will fail to
> correctly walk the graph when circular links exist. Fix it by checking
> whether an entity is already present in the stack before pushing it.

We never had any multiply connected graphs (ignoring direction, nor
supported them) before. So this is rather a patch that adds support for
those instead of fixing it. :-)

> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/media/media-entity.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index cb30ffb..c8aba5e 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -121,9 +121,9 @@ static struct media_entity *stack_pop(struct media_entity_graph *graph)
>  	return entity;
>  }
>  
> -#define stack_peek(en)	((en)->stack[(en)->top - 1].entity)
> -#define link_top(en)	((en)->stack[(en)->top].link)
> -#define stack_top(en)	((en)->stack[(en)->top].entity)
> +#define stack_peek(en, i)	((en)->stack[i].entity)
> +#define link_top(en)		((en)->stack[(en)->top].link)
> +#define stack_top(en)		((en)->stack[(en)->top].entity)
>  
>  /**
>   * media_entity_graph_walk_start - Start walking the media graph at a given entity
> @@ -159,6 +159,8 @@ EXPORT_SYMBOL_GPL(media_entity_graph_walk_start);
>  struct media_entity *
>  media_entity_graph_walk_next(struct media_entity_graph *graph)
>  {
> +	unsigned int i;
> +
>  	if (stack_top(graph) == NULL)
>  		return NULL;
>  
> @@ -181,8 +183,13 @@ media_entity_graph_walk_next(struct media_entity_graph *graph)
>  		/* Get the entity in the other end of the link . */
>  		next = media_entity_other(entity, link);
>  
> -		/* Was it the entity we came here from? */
> -		if (next == stack_peek(graph)) {
> +		/* Is the entity already in the path? */
> +		for (i = 1; i < graph->top; ++i) {
> +			if (next == stack_peek(graph, i))
> +				break;
> +		}
> +
> +		if (i < graph->top) {
>  			link_top(graph)++;
>  			continue;
>  		}

I think you should also ensure a node in the graph hasn't been enumerated in
the past; otherwise it's possible to do that multiple times in a multiply
connected graph.

How about using a bit field that contained as many bits as there were
entities? It's also faster to check for a single bit than loop over the
whole path for each entity, which certainly will start showing in execution
time with these link numbres.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
