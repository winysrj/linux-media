Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB53C43444
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 22:36:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CB722086D
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 22:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391047AbfAOWgb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 17:36:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:38618 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732029AbfAOWgb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 17:36:31 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jan 2019 14:36:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,483,1539673200"; 
   d="scan'208";a="118783425"
Received: from markusac-mobl.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.252.58.202])
  by orsmga003.jf.intel.com with ESMTP; 15 Jan 2019 14:36:28 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id 8F48521E54; Wed, 16 Jan 2019 00:36:25 +0200 (EET)
Date:   Wed, 16 Jan 2019 00:36:25 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 04/30] v4l: mc: Start walk from a specific pad in use
 count calculation
Message-ID: <20190115223624.43pxccov2eydfddc@kekkonen.localdomain>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-5-niklas.soderlund+renesas@ragnatech.se>
 <20190115222432.GE28397@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190115222432.GE28397@pendragon.ideasonboard.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Jan 16, 2019 at 12:24:32AM +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Fri, Nov 02, 2018 at 12:31:18AM +0100, Niklas Söderlund wrote:
> > From: Sakari Ailus <sakari.ailus@linux.intel.com>
> > 
> > With the addition of the recent has_route() media entity op, the pads of a
> > media entity are no longer all interconnected. This has to be taken into
> > account in power management.
> > 
> > Prepare for the addition of a helper function supporting S_ROUTING.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/v4l2-core/v4l2-mc.c | 25 ++++++++++++-------------
> >  1 file changed, 12 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
> > index 98edd47b2f0ae747..208cd91ce57ff211 100644
> > --- a/drivers/media/v4l2-core/v4l2-mc.c
> > +++ b/drivers/media/v4l2-core/v4l2-mc.c
> > @@ -332,17 +332,16 @@ EXPORT_SYMBOL_GPL(v4l_vb2q_enable_media_source);
> >  
> >  /*
> >   * pipeline_pm_use_count - Count the number of users of a pipeline
> > - * @entity: The entity
> > + * @pad: The pad
> 
> That's not very descriptive (I know it wasn't to start with either). How
> about "Any pad part of the pipeline" ?

How about: "Any pad along the pipeline"?

> 
> >   *
> >   * Return the total number of users of all video device nodes in the pipeline.
> >   */
> > -static int pipeline_pm_use_count(struct media_entity *entity,
> > -	struct media_graph *graph)
> > +static int pipeline_pm_use_count(struct media_pad *pad,
> > +				 struct media_graph *graph)
> >  {
> > -	struct media_pad *pad;
> >  	int use = 0;
> >  
> > -	media_graph_walk_start(graph, entity->pads);
> > +	media_graph_walk_start(graph, pad);
> >  
> >  	while ((pad = media_graph_walk_next(graph))) {
> >  		if (is_media_entity_v4l2_video_device(pad->entity))
> > @@ -388,7 +387,7 @@ static int pipeline_pm_power_one(struct media_entity *entity, int change)
> >  
> >  /*
> >   * pipeline_pm_power - Apply power change to all entities in a pipeline
> > - * @entity: The entity
> > + * @pad: The pad
> 
> Same here.
> 
> With this fixed,
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> >   * @change: Use count change
> >   *
> >   * Walk the pipeline to update the use count and the power state of all non-node
> > @@ -396,16 +395,16 @@ static int pipeline_pm_power_one(struct media_entity *entity, int change)
> >   *
> >   * Return 0 on success or a negative error code on failure.
> >   */
> > -static int pipeline_pm_power(struct media_entity *entity, int change,
> > +static int pipeline_pm_power(struct media_pad *pad, int change,
> >  	struct media_graph *graph)
> >  {
> > -	struct media_pad *tmp_pad, *pad;
> > +	struct media_pad *tmp_pad, *first = pad;
> >  	int ret = 0;
> >  
> >  	if (!change)
> >  		return 0;
> >  
> > -	media_graph_walk_start(graph, entity->pads);
> > +	media_graph_walk_start(graph, pad);
> >  
> >  	while (!ret && (pad = media_graph_walk_next(graph)))
> >  		if (is_media_entity_v4l2_subdev(pad->entity))
> > @@ -414,7 +413,7 @@ static int pipeline_pm_power(struct media_entity *entity, int change,
> >  	if (!ret)
> >  		return ret;
> >  
> > -	media_graph_walk_start(graph, entity->pads);
> > +	media_graph_walk_start(graph, first);
> >  
> >  	while ((tmp_pad = media_graph_walk_next(graph))
> >  	       && tmp_pad != pad)
> > @@ -437,7 +436,7 @@ int v4l2_pipeline_pm_use(struct media_entity *entity, int use)
> >  	WARN_ON(entity->use_count < 0);
> >  
> >  	/* Apply power change to connected non-nodes. */
> > -	ret = pipeline_pm_power(entity, change, &mdev->pm_count_walk);
> > +	ret = pipeline_pm_power(entity->pads, change, &mdev->pm_count_walk);
> >  	if (ret < 0)
> >  		entity->use_count -= change;
> >  
> > @@ -451,8 +450,8 @@ int v4l2_pipeline_link_notify(struct media_link *link, u32 flags,
> >  			      unsigned int notification)
> >  {
> >  	struct media_graph *graph = &link->graph_obj.mdev->pm_count_walk;
> > -	struct media_entity *source = link->source->entity;
> > -	struct media_entity *sink = link->sink->entity;
> > +	struct media_pad *source = link->source;
> > +	struct media_pad *sink = link->sink;
> >  	int source_use;
> >  	int sink_use;
> >  	int ret = 0;
> 
> -- 
> Regards,
> 
> Laurent Pinchart

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
