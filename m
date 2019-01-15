Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FCF5C43612
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 22:24:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 504802086D
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 22:24:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="XBErkM1h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387886AbfAOWYd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 17:24:33 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:48852 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733238AbfAOWYd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 17:24:33 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 20419530;
        Tue, 15 Jan 2019 23:24:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547591071;
        bh=k3ScVRD609Wuq1gMQvFIawQkAeg/+Shz5VzQDKh7Cng=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XBErkM1h7KxUAhxWKNIO5/PpSwkyMGnfM7IvFa772Ojr6FXu+zVD+IRxHZ9e71hHD
         3TM4Mk6sdLGbTVUiL7pn5IOjK5zZA3Bvyvh+JlQddvSpfVnLz8k8ne26a6aGlZYtll
         XLO2tK3phqAtAHQs9FvHIfpzob5Usr6RdO1hJ9xA=
Date:   Wed, 16 Jan 2019 00:24:32 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 04/30] v4l: mc: Start walk from a specific pad in use
 count calculation
Message-ID: <20190115222432.GE28397@pendragon.ideasonboard.com>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-5-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181101233144.31507-5-niklas.soderlund+renesas@ragnatech.se>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

Thank you for the patch.

On Fri, Nov 02, 2018 at 12:31:18AM +0100, Niklas Söderlund wrote:
> From: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> With the addition of the recent has_route() media entity op, the pads of a
> media entity are no longer all interconnected. This has to be taken into
> account in power management.
> 
> Prepare for the addition of a helper function supporting S_ROUTING.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/v4l2-core/v4l2-mc.c | 25 ++++++++++++-------------
>  1 file changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
> index 98edd47b2f0ae747..208cd91ce57ff211 100644
> --- a/drivers/media/v4l2-core/v4l2-mc.c
> +++ b/drivers/media/v4l2-core/v4l2-mc.c
> @@ -332,17 +332,16 @@ EXPORT_SYMBOL_GPL(v4l_vb2q_enable_media_source);
>  
>  /*
>   * pipeline_pm_use_count - Count the number of users of a pipeline
> - * @entity: The entity
> + * @pad: The pad

That's not very descriptive (I know it wasn't to start with either). How
about "Any pad part of the pipeline" ?

>   *
>   * Return the total number of users of all video device nodes in the pipeline.
>   */
> -static int pipeline_pm_use_count(struct media_entity *entity,
> -	struct media_graph *graph)
> +static int pipeline_pm_use_count(struct media_pad *pad,
> +				 struct media_graph *graph)
>  {
> -	struct media_pad *pad;
>  	int use = 0;
>  
> -	media_graph_walk_start(graph, entity->pads);
> +	media_graph_walk_start(graph, pad);
>  
>  	while ((pad = media_graph_walk_next(graph))) {
>  		if (is_media_entity_v4l2_video_device(pad->entity))
> @@ -388,7 +387,7 @@ static int pipeline_pm_power_one(struct media_entity *entity, int change)
>  
>  /*
>   * pipeline_pm_power - Apply power change to all entities in a pipeline
> - * @entity: The entity
> + * @pad: The pad

Same here.

With this fixed,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>   * @change: Use count change
>   *
>   * Walk the pipeline to update the use count and the power state of all non-node
> @@ -396,16 +395,16 @@ static int pipeline_pm_power_one(struct media_entity *entity, int change)
>   *
>   * Return 0 on success or a negative error code on failure.
>   */
> -static int pipeline_pm_power(struct media_entity *entity, int change,
> +static int pipeline_pm_power(struct media_pad *pad, int change,
>  	struct media_graph *graph)
>  {
> -	struct media_pad *tmp_pad, *pad;
> +	struct media_pad *tmp_pad, *first = pad;
>  	int ret = 0;
>  
>  	if (!change)
>  		return 0;
>  
> -	media_graph_walk_start(graph, entity->pads);
> +	media_graph_walk_start(graph, pad);
>  
>  	while (!ret && (pad = media_graph_walk_next(graph)))
>  		if (is_media_entity_v4l2_subdev(pad->entity))
> @@ -414,7 +413,7 @@ static int pipeline_pm_power(struct media_entity *entity, int change,
>  	if (!ret)
>  		return ret;
>  
> -	media_graph_walk_start(graph, entity->pads);
> +	media_graph_walk_start(graph, first);
>  
>  	while ((tmp_pad = media_graph_walk_next(graph))
>  	       && tmp_pad != pad)
> @@ -437,7 +436,7 @@ int v4l2_pipeline_pm_use(struct media_entity *entity, int use)
>  	WARN_ON(entity->use_count < 0);
>  
>  	/* Apply power change to connected non-nodes. */
> -	ret = pipeline_pm_power(entity, change, &mdev->pm_count_walk);
> +	ret = pipeline_pm_power(entity->pads, change, &mdev->pm_count_walk);
>  	if (ret < 0)
>  		entity->use_count -= change;
>  
> @@ -451,8 +450,8 @@ int v4l2_pipeline_link_notify(struct media_link *link, u32 flags,
>  			      unsigned int notification)
>  {
>  	struct media_graph *graph = &link->graph_obj.mdev->pm_count_walk;
> -	struct media_entity *source = link->source->entity;
> -	struct media_entity *sink = link->sink->entity;
> +	struct media_pad *source = link->source;
> +	struct media_pad *sink = link->sink;
>  	int source_use;
>  	int sink_use;
>  	int ret = 0;

-- 
Regards,

Laurent Pinchart
