Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:30083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab0IIAqo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Sep 2010 20:46:44 -0400
Message-ID: <4C882E75.8060906@redhat.com>
Date: Wed, 08 Sep 2010 21:46:45 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: Re: [RFC/PATCH v4 04/11] media: Entity graph traversal
References: <1282318153-18885-1-git-send-email-laurent.pinchart@ideasonboard.com> <1282318153-18885-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1282318153-18885-5-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Em 20-08-2010 12:29, Laurent Pinchart escreveu:
> From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> 
> Add media entity graph traversal. The traversal follows active links by
> depth first. Traversing graph backwards is prevented by comparing the next
> possible entity in the graph with the previous one. Multiply connected
> graphs are thus not supported.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Vimarsh Zutshi <vimarsh.zutshi@nokia.com>
> ---
>  Documentation/media-framework.txt |   40 +++++++++++++
>  drivers/media/media-entity.c      |  115 +++++++++++++++++++++++++++++++++++++
>  include/media/media-entity.h      |   15 +++++
>  3 files changed, 170 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/media-framework.txt b/Documentation/media-framework.txt
> index 35d74e4..a599824 100644
> --- a/Documentation/media-framework.txt
> +++ b/Documentation/media-framework.txt
> @@ -238,3 +238,43 @@ Links have flags that describe the link capabilities and state.
>  	MEDIA_LINK_FLAG_ACTIVE must also be set since an immutable link is
>  	always active.
>  
> +
> +Graph traversal
> +---------------
> +
> +The media framework provides APIs to iterate over entities in a graph.
> +
> +To iterate over all entities belonging to a media device, drivers can use the
> +media_device_for_each_entity macro, defined in include/media/media-device.h.
> +
> +	struct media_entity *entity;
> +
> +	media_device_for_each_entity(entity, mdev) {
> +		/* entity will point to each entity in turn */
> +		...
> +	}
> +
> +Drivers might also need to iterate over all entities in a graph that can be
> +reached only through active links starting at a given entity. The media
> +framework provides a depth-first graph traversal API for that purpose.
> +
> +Note that graphs with cycles (whether directed or undirected) are *NOT*
> +supported by the graph traversal API.

Please document that a maximum depth exists to prevent loops, currently
defined as 16 (MEDIA_ENTITY_ENUM_MAX_DEPTH).

> +
> +Drivers initiate a graph traversal by calling
> +
> +	media_entity_graph_walk_start(struct media_entity_graph *graph,
> +				      struct media_entity *entity);
> +
> +The graph structure, provided by the caller, is initialized to start graph
> +traversal at the given entity.
> +
> +Drivers can then retrieve the next entity by calling
> +
> +	media_entity_graph_walk_next(struct media_entity_graph *graph);
> +
> +When the graph traversal is complete the function will return NULL.
> +
> +Graph traversal can be interrupted at any moment. No cleanup function call is
> +required and the graph structure can be freed normally.
> +
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 541063b..c277c18 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -82,6 +82,121 @@ media_entity_cleanup(struct media_entity *entity)
>  }
>  EXPORT_SYMBOL(media_entity_cleanup);
>  
> +/* -----------------------------------------------------------------------------
> + * Graph traversal
> + */
> +
> +static struct media_entity *
> +media_entity_other(struct media_entity *entity, struct media_link *link)
> +{
> +	if (link->source->entity == entity)
> +		return link->sink->entity;
> +	else
> +		return link->source->entity;
> +}
> +
> +/* push an entity to traversal stack */
> +static void stack_push(struct media_entity_graph *graph,
> +		       struct media_entity *entity)
> +{
> +	if (graph->top == MEDIA_ENTITY_ENUM_MAX_DEPTH - 1) {
> +		WARN_ON(1);
> +		return;
> +	}
> +	graph->top++;
> +	graph->stack[graph->top].link = 0;
> +	graph->stack[graph->top].entity = entity;
> +}
> +
> +static struct media_entity *stack_pop(struct media_entity_graph *graph)
> +{
> +	struct media_entity *entity;
> +
> +	entity = graph->stack[graph->top].entity;
> +	graph->top--;
> +
> +	return entity;
> +}
> +
> +#define stack_peek(en)	((en)->stack[(en)->top - 1].entity)
> +#define link_top(en)	((en)->stack[(en)->top].link)
> +#define stack_top(en)	((en)->stack[(en)->top].entity)
> +
> +/**
> + * media_entity_graph_walk_start - Start walking the media graph at a given entity
> + * @graph: Media graph structure that will be used to walk the graph
> + * @entity: Starting entity
> + *
> + * This function initializes the graph traversal structure to walk the entities
> + * graph starting at the given entity. The traversal structure must not be
> + * modified by the caller during graph traversal. When done the structure can
> + * safely be freed.
> + */
> +void media_entity_graph_walk_start(struct media_entity_graph *graph,
> +				   struct media_entity *entity)
> +{
> +	graph->top = 0;
> +	graph->stack[graph->top].entity = NULL;
> +	stack_push(graph, entity);
> +}
> +EXPORT_SYMBOL_GPL(media_entity_graph_walk_start);
> +
> +/**
> + * media_entity_graph_walk_next - Get the next entity in the graph
> + * @graph: Media graph structure
> + *
> + * Perform a depth-first traversal of the given media entities graph.
> + *
> + * The graph structure must have been previously initialized with a call to
> + * media_entity_graph_walk_start().
> + *
> + * Return the next entity in the graph or NULL if the whole graph have been
> + * traversed.
> + */
> +struct media_entity *
> +media_entity_graph_walk_next(struct media_entity_graph *graph)
> +{
> +	if (stack_top(graph) == NULL)
> +		return NULL;
> +
> +	/*
> +	 * Depth first search. Push entity to stack and continue from
> +	 * top of the stack until no more entities on the level can be
> +	 * found.
> +	 */
> +	while (link_top(graph) < stack_top(graph)->num_links) {
> +		struct media_entity *entity = stack_top(graph);
> +		struct media_link *link = &entity->links[link_top(graph)];
> +		struct media_entity *next;
> +
> +		/* The link is not active so we do not follow. */
> +		if (!(link->flags & MEDIA_LINK_FLAG_ACTIVE)) {
> +			link_top(graph)++;
> +			continue;
> +		}
> +
> +		/* Get the entity in the other end of the link . */
> +		next = media_entity_other(entity, link);
> +
> +		/* Was it the entity we came here from? */
> +		if (next == stack_peek(graph)) {
> +			link_top(graph)++;
> +			continue;
> +		}
> +
> +		/* Push the new entity to stack and start over. */
> +		link_top(graph)++;
> +		stack_push(graph, next);
> +	}
> +
> +	return stack_pop(graph);
> +}
> +EXPORT_SYMBOL_GPL(media_entity_graph_walk_next);
> +
> +/* -----------------------------------------------------------------------------
> + * Links management
> + */
> +
>  static struct media_link *media_entity_add_link(struct media_entity *entity)
>  {
>  	if (entity->num_links >= entity->max_links) {
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 32bb20a..3a7c74d 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -87,10 +87,25 @@ static inline u32 media_entity_subtype(struct media_entity *entity)
>  	return entity->type & MEDIA_ENTITY_SUBTYPE_MASK;
>  }
>  
> +#define MEDIA_ENTITY_ENUM_MAX_DEPTH	16
> +
> +struct media_entity_graph {
> +	struct {
> +		struct media_entity *entity;
> +		int link;
> +	} stack[MEDIA_ENTITY_ENUM_MAX_DEPTH];
> +	int top;
> +};
> +
>  int media_entity_init(struct media_entity *entity, u16 num_pads,
>  		struct media_pad *pads, u16 extra_links);
>  void media_entity_cleanup(struct media_entity *entity);
>  int media_entity_create_link(struct media_entity *source, u16 source_pad,
>  		struct media_entity *sink, u16 sink_pad, u32 flags);
>  
> +void media_entity_graph_walk_start(struct media_entity_graph *graph,
> +		struct media_entity *entity);
> +struct media_entity *
> +media_entity_graph_walk_next(struct media_entity_graph *graph);
> +
>  #endif

