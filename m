Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D25CEC43612
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 23:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A32F020883
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 23:33:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="qKabA6UU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391447AbfAOXd6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 18:33:58 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:49292 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728841AbfAOXd6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 18:33:58 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id D5B2D530;
        Wed, 16 Jan 2019 00:33:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547595236;
        bh=dyD+/aA6zqbY7NhAiVCXU75t/pu0baVHXrNtwHmu1eI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qKabA6UU6g7mGOA7fC28RqkNGKD8Mh9qulklpomPiNw9bU3nbt/ivKgIwp4r4fJum
         +QECutYy1tCCzmDolPPRvmdDd9WjnAALo2TgMvHaQ9P270u6AJfksDUuOQl8R3/1r3
         GrH6Ki/zO1NwvD0lRQ+3GKapa2dvFaurFpe4+wYc=
Date:   Wed, 16 Jan 2019 01:33:56 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 13/30] media: entity: Add only connected pads to the
 pipeline
Message-ID: <20190115233356.GC31088@pendragon.ideasonboard.com>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-14-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181101233144.31507-14-niklas.soderlund+renesas@ragnatech.se>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

Thank you for the patch.

On Fri, Nov 02, 2018 at 12:31:27AM +0100, Niklas Söderlund wrote:
> From: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> A single entity may contain multiple pipelines. Only add pads that were
> connected to the pad through which the entity was reached to the pipeline.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/media-entity.c | 20 ++++++--------------
>  1 file changed, 6 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index cdf3805dec755ec5..a5bb257d5a68f755 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -460,15 +460,13 @@ __must_check int __media_pipeline_start(struct media_pad *pad,
>  
>  	while ((pad = media_graph_walk_next(graph))) {
>  		struct media_entity *entity = pad->entity;
> -		unsigned int i;
> +		struct media_pad *iter;
>  		bool skip_validation = pad->pipe;
>  
>  		DECLARE_BITMAP(active, MEDIA_ENTITY_MAX_PADS);
>  		DECLARE_BITMAP(has_no_links, MEDIA_ENTITY_MAX_PADS);
>  
> -		for (i = 0; i < entity->num_pads; i++) {
> -			struct media_pad *iter = &entity->pads[i];
> -
> +		media_entity_for_routed_pads(pad, iter) {
>  			if (iter->pipe && WARN_ON(iter->pipe != pipe))
>  				ret = -EBUSY;
>  			else
> @@ -553,12 +551,9 @@ __must_check int __media_pipeline_start(struct media_pad *pad,
>  	media_graph_walk_start(graph, pad_err);
>  
>  	while ((pad_err = media_graph_walk_next(graph))) {
> -		struct media_entity *entity_err = pad_err->entity;
> -		unsigned int i;
> -
> -		for (i = 0; i < entity_err->num_pads; i++) {
> -			struct media_pad *iter = &entity_err->pads[i];
> +		struct media_pad *iter;
>  
> +		media_entity_for_routed_pads(pad_err, iter) {
>  			/* Sanity check for negative stream_count */
>  			if (!WARN_ON_ONCE(iter->stream_count <= 0)) {
>  				--iter->stream_count;
> @@ -611,12 +606,9 @@ void __media_pipeline_stop(struct media_pad *pad)
>  	media_graph_walk_start(graph, pad);
>  
>  	while ((pad = media_graph_walk_next(graph))) {
> -		struct media_entity *entity = pad->entity;
> -		unsigned int i;
> -
> -		for (i = 0; i < entity->num_pads; i++) {
> -			struct media_pad *iter = &entity->pads[i];
> +		struct media_pad *iter;
>  
> +		media_entity_for_routed_pads(pad, iter) {
>  			/* Sanity check for negative stream_count */
>  			if (!WARN_ON_ONCE(iter->stream_count <= 0)) {
>  				iter->stream_count--;

-- 
Regards,

Laurent Pinchart
