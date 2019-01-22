Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E5FC282C5
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 14:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C61B221721
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 14:50:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728863AbfAVOue (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 09:50:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:35340 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728353AbfAVOue (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 09:50:34 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Jan 2019 06:50:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,506,1539673200"; 
   d="scan'208";a="136728828"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga002.fm.intel.com with ESMTP; 22 Jan 2019 06:50:31 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id A4025205C8; Tue, 22 Jan 2019 16:50:30 +0200 (EET)
Date:   Tue, 22 Jan 2019 16:50:30 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 03/30] media: entity: Walk the graph based on pads
Message-ID: <20190122145030.m2vows5yxldlphrr@paasikivi.fi.intel.com>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-4-niklas.soderlund+renesas@ragnatech.se>
 <20190115222136.GD28397@pendragon.ideasonboard.com>
 <20190115223406.mxgzl36cp54gb7nv@kekkonen.localdomain>
 <20190115232822.GB31088@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190115232822.GB31088@pendragon.ideasonboard.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

On Wed, Jan 16, 2019 at 01:28:22AM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Wed, Jan 16, 2019 at 12:34:07AM +0200, Sakari Ailus wrote:
> > On Wed, Jan 16, 2019 at 12:21:36AM +0200, Laurent Pinchart wrote:
> > > On Fri, Nov 02, 2018 at 12:31:17AM +0100, Niklas Söderlund wrote:
> > >> From: Sakari Ailus <sakari.ailus@linux.intel.com>
> > >> 
> > >> Instead of iterating over graph entities during the walk, iterate the pads
> > >> through which the entity was first reached. This is required in order to
> > >> make the entity pipeline pad-based rather than entity based.
> > >> 
> > >> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > >> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > >> ---
> > >>  Documentation/media/kapi/mc-core.rst          |  7 ++-
> > >>  drivers/media/media-entity.c                  | 46 ++++++++++--------
> > >>  drivers/media/platform/exynos4-is/media-dev.c | 20 ++++----
> > >>  drivers/media/platform/omap3isp/ispvideo.c    | 17 +++----
> > >>  drivers/media/platform/vsp1/vsp1_video.c      | 12 ++---
> > >>  drivers/media/platform/xilinx/xilinx-dma.c    | 12 ++---
> > >>  drivers/media/v4l2-core/v4l2-mc.c             | 25 +++++-----
> > >>  .../staging/media/davinci_vpfe/vpfe_video.c   | 47 ++++++++++---------
> > >>  drivers/staging/media/omap4iss/iss_video.c    | 34 +++++++-------
> > >>  include/media/media-entity.h                  |  7 +--
> > >>  10 files changed, 122 insertions(+), 105 deletions(-)
> > > 
> > > [snip]
> > > 
> > >> diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
> > >> index 51d2a571c06db6a3..5813639c63b56a2c 100644
> > >> --- a/drivers/media/platform/exynos4-is/media-dev.c
> > >> +++ b/drivers/media/platform/exynos4-is/media-dev.c
> > >> @@ -1135,7 +1135,7 @@ static int __fimc_md_modify_pipeline(struct media_entity *entity, bool enable)
> > >>  static int __fimc_md_modify_pipelines(struct media_entity *entity, bool enable,
> > >>  				      struct media_graph *graph)
> > >>  {
> > >> -	struct media_entity *entity_err = entity;
> > >> +	struct media_pad *pad, *pad_err = entity->pads;
> > >>  	int ret;
> > >>  
> > >>  	/*
> > >> @@ -1144,13 +1144,13 @@ static int __fimc_md_modify_pipelines(struct media_entity *entity, bool enable,
> > >>  	 * through active links. This is needed as we cannot power on/off the
> > >>  	 * subdevs in random order.
> > >>  	 */
> > >> -	media_graph_walk_start(graph, entity->pads);
> > >> +	media_graph_walk_start(graph, pad_err);
> > > 
> > > I would keep entity->pads here as we're not dealing with an error path.
> > > 
> > >>  
> > >> -	while ((entity = media_graph_walk_next(graph))) {
> > >> -		if (!is_media_entity_v4l2_video_device(entity))
> > >> +	while ((pad = media_graph_walk_next(graph))) {
> > >> +		if (!is_media_entity_v4l2_video_device(pad->entity))
> > >>  			continue;
> > >>  
> > >> -		ret  = __fimc_md_modify_pipeline(entity, enable);
> > >> +		ret  = __fimc_md_modify_pipeline(pad->entity, enable);
> > >>  
> > >>  		if (ret < 0)
> > >>  			goto err;
> > >> @@ -1159,15 +1159,15 @@ static int __fimc_md_modify_pipelines(struct media_entity *entity, bool enable,
> > >>  	return 0;
> > >>  
> > >>  err:
> > >> -	media_graph_walk_start(graph, entity_err->pads);
> > >> +	media_graph_walk_start(graph, pad_err);
> > >>  
> > >> -	while ((entity_err = media_graph_walk_next(graph))) {
> > >> -		if (!is_media_entity_v4l2_video_device(entity_err))
> > >> +	while ((pad_err = media_graph_walk_next(graph))) {
> > >> +		if (!is_media_entity_v4l2_video_device(pad_err->entity))
> > >>  			continue;
> > >>  
> > >> -		__fimc_md_modify_pipeline(entity_err, !enable);
> > >> +		__fimc_md_modify_pipeline(pad_err->entity, !enable);
> > >>  
> > >> -		if (entity_err == entity)
> > >> +		if (pad_err == pad)
> > >>  			break;
> > >>  	}
> > >>  
> > > 
> > > [snip]
> > > 
> > >> diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
> > >> index 9ed480fe5b6e4762..98edd47b2f0ae747 100644
> > >> --- a/drivers/media/v4l2-core/v4l2-mc.c
> > >> +++ b/drivers/media/v4l2-core/v4l2-mc.c
> > >> @@ -339,13 +339,14 @@ EXPORT_SYMBOL_GPL(v4l_vb2q_enable_media_source);
> > >>  static int pipeline_pm_use_count(struct media_entity *entity,
> > >>  	struct media_graph *graph)
> > >>  {
> > >> +	struct media_pad *pad;
> > >>  	int use = 0;
> > >>  
> > >>  	media_graph_walk_start(graph, entity->pads);
> > >>  
> > >> -	while ((entity = media_graph_walk_next(graph))) {
> > >> -		if (is_media_entity_v4l2_video_device(entity))
> > >> -			use += entity->use_count;
> > >> +	while ((pad = media_graph_walk_next(graph))) {
> > >> +		if (is_media_entity_v4l2_video_device(pad->entity))
> > >> +			use += pad->entity->use_count;
> > >>  	}
> > >>  
> > >>  	return use;
> > >> @@ -398,7 +399,7 @@ static int pipeline_pm_power_one(struct media_entity *entity, int change)
> > >>  static int pipeline_pm_power(struct media_entity *entity, int change,
> > >>  	struct media_graph *graph)
> > >>  {
> > >> -	struct media_entity *first = entity;
> > >> +	struct media_pad *tmp_pad, *pad;
> > > 
> > > How about pad_err instead of tmp_pad, like in the exynos driver ? Or
> > > possible first_pad to retain the "first" name ?
> > 
> > Why? This is just a pad. It's an iterator. first_pad or pad_err are
> > misleading as such. If you don't like tmp_pad, how about "pad2"? The "pad"
> > variable is still used for a similar purpose.
> 
> The variable is a pad iterator used in the error path, which can't use
> the pad pointer as we need to stop iterating when we reach it. first_pad
> is a bad idea, but pad_err would convey the meaning.

I'm sure it'd convey a meaning but it's not the right meaning: this is an
iterator, not where the error happened. It'd require a code change as well
to change the meaning.

I'm not opposed to that necessarily, but I think it's more simple to grasp
as-is (with rename to e.g. pad2).

> 
> > > 
> > >>  	int ret = 0;
> > >>  
> > >>  	if (!change)
> > >> @@ -406,19 +407,19 @@ static int pipeline_pm_power(struct media_entity *entity, int change,
> > >>  
> > >>  	media_graph_walk_start(graph, entity->pads);
> > >>  
> > >> -	while (!ret && (entity = media_graph_walk_next(graph)))
> > >> -		if (is_media_entity_v4l2_subdev(entity))
> > >> -			ret = pipeline_pm_power_one(entity, change);
> > >> +	while (!ret && (pad = media_graph_walk_next(graph)))
> > >> +		if (is_media_entity_v4l2_subdev(pad->entity))
> > >> +			ret = pipeline_pm_power_one(pad->entity, change);
> > >>  
> > >>  	if (!ret)
> > >>  		return ret;
> > >>  
> > >> -	media_graph_walk_start(graph, first->pads);
> > >> +	media_graph_walk_start(graph, entity->pads);
> > >>  
> > >> -	while ((first = media_graph_walk_next(graph))
> > >> -	       && first != entity)
> > >> -		if (is_media_entity_v4l2_subdev(first))
> > >> -			pipeline_pm_power_one(first, -change);
> > >> +	while ((tmp_pad = media_graph_walk_next(graph))
> > >> +	       && tmp_pad != pad)
> > >> +		if (is_media_entity_v4l2_subdev(tmp_pad->entity))
> > >> +			pipeline_pm_power_one(tmp_pad->entity, -change);
> > >>  
> > >>  	return ret;
> > >>  }
> > > 
> > > [snip]
> > > 
> > >> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > >> index 99c7606f01317741..cde6350d752bb0ae 100644
> > >> --- a/include/media/media-entity.h
> > >> +++ b/include/media/media-entity.h
> > >> @@ -952,10 +952,11 @@ void media_graph_walk_start(struct media_graph *graph, struct media_pad *pad);
> > >>   * The graph structure must have been previously initialized with a call to
> > >>   * media_graph_walk_start().
> > >>   *
> > >> - * Return: returns the next entity in the graph or %NULL if the whole graph
> > >> - * have been traversed.
> > >> + * Return: returns the next pad in the graph or %NULL if the whole
> > >> + * graph have been traversed. The pad which is returned is the pad
> > > 
> > > s/have been/has/been/
> > > s/The pad which is returned/The returned pad/
> > > 
> > >> + * through which a new entity is reached when parsing the graph.
> > > 
> > > through which the entity was reached when walking the graph.
> > 
> > I'd keep "new", as the intent is to underline that it's a new entity not
> > yet reached while walking the graph.
> 
> "through which the new entity was reached when walking the graph" then ?

Yes, please!

> 
> > > 
> > > With these addressed,
> > > 
> > > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > 
> > >>   */
> > >> -struct media_entity *media_graph_walk_next(struct media_graph *graph);
> > >> +struct media_pad *media_graph_walk_next(struct media_graph *graph);
> > >>  
> > >>  /**
> > >>   * media_pipeline_start - Mark a pipeline as streaming
> 
> -- 
> Regards,
> 
> Laurent Pinchart

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
