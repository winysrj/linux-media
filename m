Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39253 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbbLLPVd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Dec 2015 10:21:33 -0500
Date: Sat, 12 Dec 2015 13:21:27 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, javier@osg.samsung.com,
	Kamil Debski <k.debski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v2 10/22] v4l: exynos4-is: Use the new
 media_entity_graph_walk_start() interface
Message-ID: <20151212132127.27c1bfb6@recife.lan>
In-Reply-To: <1448824823-10372-11-git-send-email-sakari.ailus@iki.fi>
References: <1448824823-10372-1-git-send-email-sakari.ailus@iki.fi>
	<1448824823-10372-11-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 29 Nov 2015 21:20:11 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

description missing. Otherwise looks ok.

> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Javier Martinez Canillas <javier@osg.samsung.com>
> Cc: Kamil Debski <k.debski@samsung.com>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> ---
>  drivers/media/platform/exynos4-is/media-dev.c | 31 +++++++++++++++++----------
>  drivers/media/platform/exynos4-is/media-dev.h |  1 +
>  2 files changed, 21 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
> index d55b4f3..704040c 100644
> --- a/drivers/media/platform/exynos4-is/media-dev.c
> +++ b/drivers/media/platform/exynos4-is/media-dev.c
> @@ -1046,10 +1046,10 @@ static int __fimc_md_modify_pipeline(struct media_entity *entity, bool enable)
>  }
>  
>  /* Locking: called with entity->graph_obj.mdev->graph_mutex mutex held. */
> -static int __fimc_md_modify_pipelines(struct media_entity *entity, bool enable)
> +static int __fimc_md_modify_pipelines(struct media_entity *entity, bool enable,
> +				      struct media_entity_graph *graph)
>  {
>  	struct media_entity *entity_err = entity;
> -	struct media_entity_graph graph;
>  	int ret;
>  
>  	/*
> @@ -1058,9 +1058,9 @@ static int __fimc_md_modify_pipelines(struct media_entity *entity, bool enable)
>  	 * through active links. This is needed as we cannot power on/off the
>  	 * subdevs in random order.
>  	 */
> -	media_entity_graph_walk_start(&graph, entity);
> +	media_entity_graph_walk_start(graph, entity);
>  
> -	while ((entity = media_entity_graph_walk_next(&graph))) {
> +	while ((entity = media_entity_graph_walk_next(graph))) {
>  		if (!is_media_entity_v4l2_io(entity))
>  			continue;
>  
> @@ -1071,10 +1071,11 @@ static int __fimc_md_modify_pipelines(struct media_entity *entity, bool enable)
>  	}
>  
>  	return 0;
> - err:
> -	media_entity_graph_walk_start(&graph, entity_err);
>  
> -	while ((entity_err = media_entity_graph_walk_next(&graph))) {
> +err:
> +	media_entity_graph_walk_start(graph, entity_err);
> +
> +	while ((entity_err = media_entity_graph_walk_next(graph))) {
>  		if (!is_media_entity_v4l2_io(entity_err))
>  			continue;
>  
> @@ -1090,21 +1091,29 @@ static int __fimc_md_modify_pipelines(struct media_entity *entity, bool enable)
>  static int fimc_md_link_notify(struct media_link *link, unsigned int flags,
>  				unsigned int notification)
>  {
> +	struct media_entity_graph *graph =
> +		&container_of(link->graph_obj.mdev, struct fimc_md,
> +			      media_dev)->link_setup_graph;
>  	struct media_entity *sink = link->sink->entity;
>  	int ret = 0;
>  
>  	/* Before link disconnection */
>  	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH) {
> +		ret = media_entity_graph_walk_init(graph,
> +						   link->graph_obj.mdev);
> +		if (ret)
> +			return ret;
>  		if (!(flags & MEDIA_LNK_FL_ENABLED))
> -			ret = __fimc_md_modify_pipelines(sink, false);
> +			ret = __fimc_md_modify_pipelines(sink, false, graph);
>  #if 0
>  		else
>  			/* TODO: Link state change validation */
>  #endif
>  	/* After link activation */
> -	} else if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
> -		   (link->flags & MEDIA_LNK_FL_ENABLED)) {
> -		ret = __fimc_md_modify_pipelines(sink, true);
> +	} else if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH) {
> +		if (link->flags & MEDIA_LNK_FL_ENABLED)
> +			ret = __fimc_md_modify_pipelines(sink, true, graph);
> +		media_entity_graph_walk_cleanup(graph);
>  	}
>  
>  	return ret ? -EPIPE : 0;
> diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
> index 9a69913..e80c55d 100644
> --- a/drivers/media/platform/exynos4-is/media-dev.h
> +++ b/drivers/media/platform/exynos4-is/media-dev.h
> @@ -154,6 +154,7 @@ struct fimc_md {
>  	bool user_subdev_api;
>  	spinlock_t slock;
>  	struct list_head pipelines;
> +	struct media_entity_graph link_setup_graph;
>  };
>  
>  static inline
