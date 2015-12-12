Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59115 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbbLQCUB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 21:20:01 -0500
Date: Sat, 12 Dec 2015 13:18:00 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, javier@osg.samsung.com
Subject: Re: [PATCH v2 07/22] media: Amend media graph walk API by init and
 cleanup functions
Message-ID: <20151212131800.78745c38@recife.lan>
In-Reply-To: <1448824823-10372-8-git-send-email-sakari.ailus@iki.fi>
References: <1448824823-10372-1-git-send-email-sakari.ailus@iki.fi>
	<1448824823-10372-8-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 29 Nov 2015 21:20:08 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Add media_entity_graph_walk_init() and media_entity_graph_walk_cleanup()
> functions in order to dynamically allocate memory for the graph. This is
> not done in media_entity_graph_walk_start() as there are situations where
> e.g. correct error handling, that itself may not fail, requires successful
> graph walk.

Looks ok to me.


> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/media-entity.c | 39 ++++++++++++++++++++++++++++++++++-----
>  include/media/media-entity.h |  5 ++++-
>  2 files changed, 38 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 667ab32..bf3c31f 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -353,14 +353,44 @@ static struct media_entity *stack_pop(struct media_entity_graph *graph)
>  #define stack_top(en)	((en)->stack[(en)->top].entity)
>  
>  /**
> + * media_entity_graph_walk_init - Allocate resources for graph walk
> + * @graph: Media graph structure that will be used to walk the graph
> + * @mdev: Media device
> + *
> + * Reserve resources for graph walk in media device's current
> + * state. The memory must be released using
> + * media_entity_graph_walk_free().
> + *
> + * Returns error on failure, zero on success.
> + */
> +__must_check int media_entity_graph_walk_init(
> +	struct media_entity_graph *graph, struct media_device *mdev)
> +{
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(media_entity_graph_walk_init);
> +
> +/**
> + * media_entity_graph_walk_cleanup - Release resources related to graph walking
> + * @graph: Media graph structure that was used to walk the graph
> + */
> +void media_entity_graph_walk_cleanup(struct media_entity_graph *graph)
> +{
> +}
> +EXPORT_SYMBOL_GPL(media_entity_graph_walk_cleanup);
> +
> +/**
>   * media_entity_graph_walk_start - Start walking the media graph at a given entity
>   * @graph: Media graph structure that will be used to walk the graph
>   * @entity: Starting entity
>   *
> - * This function initializes the graph traversal structure to walk the entities
> - * graph starting at the given entity. The traversal structure must not be
> - * modified by the caller during graph traversal. When done the structure can
> - * safely be freed.
> + * Before using this function, media_entity_graph_walk_init() must be
> + * used to allocate resources used for walking the graph. This
> + * function initializes the graph traversal structure to walk the
> + * entities graph starting at the given entity. The traversal
> + * structure must not be modified by the caller during graph
> + * traversal. After the graph walk, the resources must be released
> + * using media_entity_graph_walk_cleanup().
>   */
>  void media_entity_graph_walk_start(struct media_entity_graph *graph,
>  				   struct media_entity *entity)
> @@ -377,7 +407,6 @@ void media_entity_graph_walk_start(struct media_entity_graph *graph,
>  }
>  EXPORT_SYMBOL_GPL(media_entity_graph_walk_start);
>  
> -
>  /**
>   * media_entity_graph_walk_next - Get the next entity in the graph
>   * @graph: Media graph structure
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 4b5ca39..f0652e2 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -506,8 +506,11 @@ struct media_pad *media_entity_remote_pad(struct media_pad *pad);
>  struct media_entity *media_entity_get(struct media_entity *entity);
>  void media_entity_put(struct media_entity *entity);
>  
> +__must_check int media_entity_graph_walk_init(
> +	struct media_entity_graph *graph, struct media_device *mdev);
> +void media_entity_graph_walk_cleanup(struct media_entity_graph *graph);
>  void media_entity_graph_walk_start(struct media_entity_graph *graph,
> -		struct media_entity *entity);
> +				   struct media_entity *entity);
>  struct media_entity *
>  media_entity_graph_walk_next(struct media_entity_graph *graph);
>  __must_check int media_entity_pipeline_start(struct media_entity *entity,
