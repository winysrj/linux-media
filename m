Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0726FC43612
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 21:43:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6CBE20866
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 21:43:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="OhMtG5Cz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390634AbfAOVnU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 16:43:20 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:48554 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729432AbfAOVnU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 16:43:20 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5A609530;
        Tue, 15 Jan 2019 22:43:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547588596;
        bh=si1YooDQEIiSGiBnz1e5VhuJ5P1rVerOU8Q4kutUolc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OhMtG5Czw543SG8XRV1mzd05668QqqoiQQmm8S0U5VBjeSLSxFQWlL8Li5FrQz2C6
         Ie0jG1T2bqmYuL9Jgn3UZVOMcUp7nXgD4crUwHoOyLQQ6xUthx6CDh0AjsBToH03jJ
         PS1LHWk49af3jP8PLZigK7Ku6Ftla4amKKLbd4QI=
Date:   Tue, 15 Jan 2019 23:43:17 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 01/30] media: entity: Use pad as a starting point for
 graph walk
Message-ID: <20190115214317.GA28397@pendragon.ideasonboard.com>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-2-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181101233144.31507-2-niklas.soderlund+renesas@ragnatech.se>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello Niklas,

Thank you for the patch.

On Fri, Nov 02, 2018 at 12:31:15AM +0100, Niklas S�derlund wrote:
> From: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> With the upcoming use of the recently added has_route() media entity op, all
> the pads in an entity will no longer be considered interconnected. This has
> an effect where the media graph is traversed: the starting pad does make a
> difference.
> 
> Prepare for this change by using pad instead of the entity as an argument
> for the graph walk operations. The actual graph traversal algorithm change
> is in further patches.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Niklas S�derlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  Documentation/media/kapi/mc-core.rst            |  2 +-
>  drivers/media/media-entity.c                    | 17 ++++++++---------
>  drivers/media/platform/exynos4-is/media-dev.c   |  4 ++--
>  drivers/media/platform/omap3isp/ispvideo.c      |  2 +-
>  drivers/media/platform/vsp1/vsp1_video.c        |  2 +-
>  drivers/media/platform/xilinx/xilinx-dma.c      |  2 +-
>  drivers/media/v4l2-core/v4l2-mc.c               |  6 +++---
>  drivers/staging/media/davinci_vpfe/vpfe_video.c |  6 +++---
>  drivers/staging/media/omap4iss/iss_video.c      |  4 ++--
>  include/media/media-entity.h                    | 10 ++++------
>  10 files changed, 26 insertions(+), 29 deletions(-)
> 
> diff --git a/Documentation/media/kapi/mc-core.rst b/Documentation/media/kapi/mc-core.rst
> index 0c05503eaf1fa6c7..27aefb9a778b2ad6 100644
> --- a/Documentation/media/kapi/mc-core.rst
> +++ b/Documentation/media/kapi/mc-core.rst
> @@ -165,7 +165,7 @@ Drivers initiate a graph traversal by calling
>  :c:func:`media_graph_walk_start()`
>  
>  The graph structure, provided by the caller, is initialized to start graph
> -traversal at the given entity.
> +traversal at the given pad in an entity.
>  
>  Drivers can then retrieve the next entity by calling
>  :c:func:`media_graph_walk_next()`
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 0b1cb3559140a1fe..2bbc07de71aa5e6d 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -300,17 +300,16 @@ void media_graph_walk_cleanup(struct media_graph *graph)
>  }
>  EXPORT_SYMBOL_GPL(media_graph_walk_cleanup);
>  
> -void media_graph_walk_start(struct media_graph *graph,
> -			    struct media_entity *entity)
> +void media_graph_walk_start(struct media_graph *graph, struct media_pad *pad)
>  {
>  	media_entity_enum_zero(&graph->ent_enum);
> -	media_entity_enum_set(&graph->ent_enum, entity);
> +	media_entity_enum_set(&graph->ent_enum, pad->entity);
>  
>  	graph->top = 0;
>  	graph->stack[graph->top].entity = NULL;
> -	stack_push(graph, entity);
> -	dev_dbg(entity->graph_obj.mdev->dev,
> -		"begin graph walk at '%s'\n", entity->name);
> +	stack_push(graph, pad->entity);
> +	dev_dbg(pad->graph_obj.mdev->dev,
> +		"begin graph walk at '%s':%u\n", pad->entity->name, pad->index);
>  }
>  EXPORT_SYMBOL_GPL(media_graph_walk_start);
>  
> @@ -428,7 +427,7 @@ __must_check int __media_pipeline_start(struct media_entity *entity,
>  			goto error_graph_walk_start;
>  	}
>  
> -	media_graph_walk_start(&pipe->graph, entity);
> +	media_graph_walk_start(&pipe->graph, entity->pads);
>  
>  	while ((entity = media_graph_walk_next(graph))) {
>  		DECLARE_BITMAP(active, MEDIA_ENTITY_MAX_PADS);
> @@ -509,7 +508,7 @@ __must_check int __media_pipeline_start(struct media_entity *entity,
>  	 * Link validation on graph failed. We revert what we did and
>  	 * return the error.
>  	 */
> -	media_graph_walk_start(graph, entity_err);
> +	media_graph_walk_start(graph, entity_err->pads);
>  
>  	while ((entity_err = media_graph_walk_next(graph))) {
>  		/* Sanity check for negative stream_count */
> @@ -560,7 +559,7 @@ void __media_pipeline_stop(struct media_entity *entity)
>  	if (WARN_ON(!pipe))
>  		return;
>  
> -	media_graph_walk_start(graph, entity);
> +	media_graph_walk_start(graph, entity->pads);
>  
>  	while ((entity = media_graph_walk_next(graph))) {
>  		/* Sanity check for negative stream_count */
> diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
> index 870501b0f351addb..51d2a571c06db6a3 100644
> --- a/drivers/media/platform/exynos4-is/media-dev.c
> +++ b/drivers/media/platform/exynos4-is/media-dev.c
> @@ -1144,7 +1144,7 @@ static int __fimc_md_modify_pipelines(struct media_entity *entity, bool enable,
>  	 * through active links. This is needed as we cannot power on/off the
>  	 * subdevs in random order.
>  	 */
> -	media_graph_walk_start(graph, entity);
> +	media_graph_walk_start(graph, entity->pads);
>  
>  	while ((entity = media_graph_walk_next(graph))) {
>  		if (!is_media_entity_v4l2_video_device(entity))
> @@ -1159,7 +1159,7 @@ static int __fimc_md_modify_pipelines(struct media_entity *entity, bool enable,
>  	return 0;
>  
>  err:
> -	media_graph_walk_start(graph, entity_err);
> +	media_graph_walk_start(graph, entity_err->pads);
>  
>  	while ((entity_err = media_graph_walk_next(graph))) {
>  		if (!is_media_entity_v4l2_video_device(entity_err))
> diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
> index 5658f6a326f77f66..50ad35bc644eae29 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -238,7 +238,7 @@ static int isp_video_get_graph_data(struct isp_video *video,
>  		return ret;
>  	}
>  
> -	media_graph_walk_start(&graph, entity);
> +	media_graph_walk_start(&graph, entity->pads);
>  
>  	while ((entity = media_graph_walk_next(&graph))) {
>  		struct isp_video *__video;
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
> index 771dfe1f7c20e526..e35b2e2340b82f00 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -580,7 +580,7 @@ static int vsp1_video_pipeline_build(struct vsp1_pipeline *pipe,
>  	if (ret)
>  		return ret;
>  
> -	media_graph_walk_start(&graph, entity);
> +	media_graph_walk_start(&graph, entity->pads);
>  
>  	while ((entity = media_graph_walk_next(&graph))) {
>  		struct v4l2_subdev *subdev;
> diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
> index 4ae9d38c94332fa4..566c2d0fb97dc162 100644
> --- a/drivers/media/platform/xilinx/xilinx-dma.c
> +++ b/drivers/media/platform/xilinx/xilinx-dma.c
> @@ -193,7 +193,7 @@ static int xvip_pipeline_validate(struct xvip_pipeline *pipe,
>  		return ret;
>  	}
>  
> -	media_graph_walk_start(&graph, entity);
> +	media_graph_walk_start(&graph, entity->pads);
>  
>  	while ((entity = media_graph_walk_next(&graph))) {
>  		struct xvip_dma *dma;
> diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
> index 014a2a97cadd8706..9ed480fe5b6e4762 100644
> --- a/drivers/media/v4l2-core/v4l2-mc.c
> +++ b/drivers/media/v4l2-core/v4l2-mc.c
> @@ -341,7 +341,7 @@ static int pipeline_pm_use_count(struct media_entity *entity,
>  {
>  	int use = 0;
>  
> -	media_graph_walk_start(graph, entity);
> +	media_graph_walk_start(graph, entity->pads);
>  
>  	while ((entity = media_graph_walk_next(graph))) {
>  		if (is_media_entity_v4l2_video_device(entity))
> @@ -404,7 +404,7 @@ static int pipeline_pm_power(struct media_entity *entity, int change,
>  	if (!change)
>  		return 0;
>  
> -	media_graph_walk_start(graph, entity);
> +	media_graph_walk_start(graph, entity->pads);
>  
>  	while (!ret && (entity = media_graph_walk_next(graph)))
>  		if (is_media_entity_v4l2_subdev(entity))
> @@ -413,7 +413,7 @@ static int pipeline_pm_power(struct media_entity *entity, int change,
>  	if (!ret)
>  		return ret;
>  
> -	media_graph_walk_start(graph, first);
> +	media_graph_walk_start(graph, first->pads);
>  
>  	while ((first = media_graph_walk_next(graph))
>  	       && first != entity)
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> index 5e42490331b7620f..912d93fc7a483cd4 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> @@ -150,7 +150,7 @@ static int vpfe_prepare_pipeline(struct vpfe_video_device *video)
>  		mutex_unlock(&mdev->graph_mutex);
>  		return -ENOMEM;
>  	}
> -	media_graph_walk_start(&graph, entity);
> +	media_graph_walk_start(&graph, entity->pads);
>  	while ((entity = media_graph_walk_next(&graph))) {
>  		if (entity == &video->video_dev.entity)
>  			continue;
> @@ -303,7 +303,7 @@ static int vpfe_pipeline_enable(struct vpfe_pipeline *pipe)
>  	ret = media_graph_walk_init(&pipe->graph, mdev);
>  	if (ret)
>  		goto out;
> -	media_graph_walk_start(&pipe->graph, entity);
> +	media_graph_walk_start(&pipe->graph, entity->pads);
>  	while ((entity = media_graph_walk_next(&pipe->graph))) {
>  
>  		if (!is_media_entity_v4l2_subdev(entity))
> @@ -345,7 +345,7 @@ static int vpfe_pipeline_disable(struct vpfe_pipeline *pipe)
>  
>  	mdev = entity->graph_obj.mdev;
>  	mutex_lock(&mdev->graph_mutex);
> -	media_graph_walk_start(&pipe->graph, entity);
> +	media_graph_walk_start(&pipe->graph, entity->pads);
>  
>  	while ((entity = media_graph_walk_next(&pipe->graph))) {
>  
> diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
> index c1322aeaf01eb951..6f72c02c8054f496 100644
> --- a/drivers/staging/media/omap4iss/iss_video.c
> +++ b/drivers/staging/media/omap4iss/iss_video.c
> @@ -217,7 +217,7 @@ iss_video_far_end(struct iss_video *video)
>  		return NULL;
>  	}
>  
> -	media_graph_walk_start(&graph, entity);
> +	media_graph_walk_start(&graph, entity->pads);
>  
>  	while ((entity = media_graph_walk_next(&graph))) {
>  		if (entity == &video->video.entity)
> @@ -897,7 +897,7 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
>  	if (ret < 0)
>  		goto err_media_pipeline_start;
>  
> -	media_graph_walk_start(&graph, entity);
> +	media_graph_walk_start(&graph, entity->pads);
>  	while ((entity = media_graph_walk_next(&graph)))
>  		media_entity_enum_set(&pipe->ent_enum, entity);
>  
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index e5f6960d92f6cdd4..07ab141e739ef5ff 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -928,22 +928,20 @@ void media_graph_walk_cleanup(struct media_graph *graph);
>  void media_entity_put(struct media_entity *entity);
>  
>  /**
> - * media_graph_walk_start - Start walking the media graph at a
> - *	given entity
> + * media_graph_walk_start - Start walking the media graph at a given pad
>   *
>   * @graph: Media graph structure that will be used to walk the graph
> - * @entity: Starting entity
> + * @pad: Starting pad
>   *
>   * Before using this function, media_graph_walk_init() must be
>   * used to allocate resources used for walking the graph. This
>   * function initializes the graph traversal structure to walk the
> - * entities graph starting at the given entity. The traversal
> + * entities graph starting at the given pad. The traversal
>   * structure must not be modified by the caller during graph
>   * traversal. After the graph walk, the resources must be released
>   * using media_graph_walk_cleanup().
>   */
> -void media_graph_walk_start(struct media_graph *graph,
> -			    struct media_entity *entity);
> +void media_graph_walk_start(struct media_graph *graph, struct media_pad *pad);
>  
>  /**
>   * media_graph_walk_next - Get the next entity in the graph

-- 
Regards,

Laurent Pinchart
