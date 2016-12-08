Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45453 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751064AbcLHOT0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2016 09:19:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se
Subject: Re: [PATCH 4/5] media: entity: Split graph walk iteration into two functions
Date: Thu, 08 Dec 2016 16:02:05 +0200
Message-ID: <3239339.ITEAqaAlQp@avalon>
In-Reply-To: <1480082146-25991-5-git-send-email-sakari.ailus@linux.intel.com>
References: <1480082146-25991-1-git-send-email-sakari.ailus@linux.intel.com> <1480082146-25991-5-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Friday 25 Nov 2016 15:55:45 Sakari Ailus wrote:
> With media_entity_graph_walk_next() getting more and more complicated (and
> especially so with has_routing() support added), split the function into
> two.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/media-entity.c | 56 +++++++++++++++++++++--------------------
>  1 file changed, 30 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 2bddebb..e242ead 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -338,6 +338,34 @@ void media_graph_walk_start(struct media_graph *graph,
>  }
>  EXPORT_SYMBOL_GPL(media_graph_walk_start);
> 
> +static void graph_walk_iter(struct media_graph *graph)

I'd name the function media_graph_walk_iter(). With that changed,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> +{
> +	struct media_entity *entity = stack_top(graph);
> +	struct media_link *link;
> +	struct media_entity *next;
> +
> +	link = list_entry(link_top(graph), typeof(*link), list);
> +
> +	/* The link is not enabled so we do not follow. */
> +	if (!(link->flags & MEDIA_LNK_FL_ENABLED)) {
> +		link_top(graph) = link_top(graph)->next;
> +		return;
> +	}
> +
> +	/* Get the entity in the other end of the link . */
> +	next = media_entity_other(entity, link);
> +
> +	/* Has the entity already been visited? */
> +	if (media_entity_enum_test_and_set(&graph->ent_enum, next)) {
> +		link_top(graph) = link_top(graph)->next;
> +		return;
> +	}
> +
> +	/* Push the new entity to stack and start over. */
> +	link_top(graph) = link_top(graph)->next;
> +	stack_push(graph, next);
> +}
> +
>  struct media_entity *media_graph_walk_next(struct media_graph *graph)
>  {
>  	if (stack_top(graph) == NULL)
> @@ -348,32 +376,8 @@ struct media_entity *media_graph_walk_next(struct
> media_graph *graph) * top of the stack until no more entities on the level
> can be
>  	 * found.
>  	 */
> -	while (link_top(graph) != &stack_top(graph)->links) {
> -		struct media_entity *entity = stack_top(graph);
> -		struct media_link *link;
> -		struct media_entity *next;
> -
> -		link = list_entry(link_top(graph), typeof(*link), list);
> -
> -		/* The link is not enabled so we do not follow. */
> -		if (!(link->flags & MEDIA_LNK_FL_ENABLED)) {
> -			link_top(graph) = link_top(graph)->next;
> -			continue;
> -		}
> -
> -		/* Get the entity in the other end of the link . */
> -		next = media_entity_other(entity, link);
> -
> -		/* Has the entity already been visited? */
> -		if (media_entity_enum_test_and_set(&graph->ent_enum, next)) {
> -			link_top(graph) = link_top(graph)->next;
> -			continue;
> -		}
> -
> -		/* Push the new entity to stack and start over. */
> -		link_top(graph) = link_top(graph)->next;
> -		stack_push(graph, next);
> -	}
> +	while (link_top(graph) != &stack_top(graph)->links)
> +		graph_walk_iter(graph);
> 
>  	return stack_pop(graph);
>  }

-- 
Regards,

Laurent Pinchart

