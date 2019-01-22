Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B5D8C41518
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 15:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44DC3217F4
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 15:37:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="R2kGb6Q/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbfAVPhT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:37:19 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:49486 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728699AbfAVPhT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 10:37:19 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 4AC6D53E;
        Tue, 22 Jan 2019 16:37:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1548171436;
        bh=YH5DkU8XVa0w5f+ZjtVahXbFNIIbWrmR2pIT85H7e28=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R2kGb6Q/wwqTbtwhpeWTrPPkvy27EuFvoj2T6gnwQtX6+PecTSW+0Y7N/xNc4wUT1
         sNR3jhKcuUTA6AxzNXXlnwo18LARCiQTw29S+0MbGCWxnOEGYM8VvryPzQfBwOSagV
         kfwee0DFbZbyJo6lKeaaRi4GyY0xZ5LSgMLWMu8M=
Date:   Tue, 22 Jan 2019 17:37:15 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Niklas =?utf-8?Q?S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 06/30] media: entity: Use pad as the starting point
 for a pipeline
Message-ID: <20190122153715.GC11461@pendragon.ideasonboard.com>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-7-niklas.soderlund+renesas@ragnatech.se>
 <20190115225420.GG28397@pendragon.ideasonboard.com>
 <20190122153134.qmjqxgrptuvmhhhz@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190122153134.qmjqxgrptuvmhhhz@paasikivi.fi.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

On Tue, Jan 22, 2019 at 05:31:34PM +0200, Sakari Ailus wrote:
> On Wed, Jan 16, 2019 at 12:54:20AM +0200, Laurent Pinchart wrote:
> > On Fri, Nov 02, 2018 at 12:31:20AM +0100, Niklas Söderlund wrote:
> >> From: Sakari Ailus <sakari.ailus@linux.intel.com>
> >> 
> >> The pipeline will be moved from the entity to the pads; reflect this in
> >> the media pipeline function API.
> > 
> > Will be moved, or has been moved ?
> 
> Will be, as it's not yet in this patch.

[PATCH v2 05/30] media: entity: Move the pipeline from entity to pads

> >> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> >> ---
> >>  Documentation/media/kapi/mc-core.rst          |  6 ++--
> >>  drivers/media/media-entity.c                  | 25 +++++++-------
> >>  drivers/media/pci/intel/ipu3/ipu3-cio2.c      |  6 ++--
> >>  .../media/platform/exynos4-is/fimc-capture.c  |  8 ++---
> >>  .../platform/exynos4-is/fimc-isp-video.c      |  8 ++---
> >>  drivers/media/platform/exynos4-is/fimc-lite.c |  8 ++---
> >>  drivers/media/platform/omap3isp/ispvideo.c    |  6 ++--
> >>  .../media/platform/qcom/camss/camss-video.c   |  6 ++--
> >>  drivers/media/platform/rcar-vin/rcar-dma.c    |  6 ++--
> >>  .../media/platform/s3c-camif/camif-capture.c  |  6 ++--
> >>  drivers/media/platform/vimc/vimc-capture.c    |  6 ++--
> >>  drivers/media/platform/vsp1/vsp1_video.c      |  6 ++--
> >>  drivers/media/platform/xilinx/xilinx-dma.c    |  6 ++--
> >>  drivers/media/usb/au0828/au0828-core.c        |  4 +--
> >>  drivers/staging/media/imx/imx-media-utils.c   |  6 ++--
> >>  drivers/staging/media/omap4iss/iss_video.c    |  6 ++--
> >>  include/media/media-entity.h                  | 33 ++++++++++---------
> >>  17 files changed, 76 insertions(+), 76 deletions(-)
> >> 
> >> diff --git a/Documentation/media/kapi/mc-core.rst b/Documentation/media/kapi/mc-core.rst
> >> index 849b87439b7a9772..ede7e946f6a82ac0 100644
> >> --- a/Documentation/media/kapi/mc-core.rst
> >> +++ b/Documentation/media/kapi/mc-core.rst
> >> @@ -211,11 +211,11 @@ When starting streaming, drivers must notify all entities in the pipeline to
> >>  prevent link states from being modified during streaming by calling
> >>  :c:func:`media_pipeline_start()`.
> >>  
> >> -The function will mark all entities connected to the given entity through
> >> -enabled links, either directly or indirectly, as streaming.
> >> +The function will mark all entities connected to the given pad through
> >> +enabled routes and links, either directly or indirectly, as streaming.
> > 
> > That's not really correct, it doesn't mark entities, but pads. I think
> > this section of the documentation needs to be rewritten based on the new
> > model of an entity being part of multiple pipelines. s/entity/pad/ isn't
> > enough, there's a whole new semantics.
> 
> I'd say it's correct. Note that this function just beings the walk from a
> given pad, it doesn't make other changes --- there are further patches
> thought that do.

OK, it might be a change in progress, but the documentation still has to
be rewritten to explain the new model. We need at least one or two new
paragraphs in addition to the s/entity/pad/.

> >>  The struct :c:type:`media_pipeline` instance pointed to by
> >> -the pipe argument will be stored in every entity in the pipeline.
> >> +the pipe argument will be stored in every pad in the pipeline.
> >>  Drivers should embed the struct :c:type:`media_pipeline`
> >>  in higher-level pipeline structures and can then access the
> >>  pipeline through the struct :c:type:`media_entity`
> >> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> >> index 13260149c4dfc90c..f2fa0b7826dbc2f3 100644
> >> --- a/drivers/media/media-entity.c
> >> +++ b/drivers/media/media-entity.c
> >> @@ -411,12 +411,11 @@ EXPORT_SYMBOL_GPL(media_entity_get_fwnode_pad);
> >>   * Pipeline management
> >>   */
> >>  
> >> -__must_check int __media_pipeline_start(struct media_entity *entity,
> >> +__must_check int __media_pipeline_start(struct media_pad *pad,
> >>  					struct media_pipeline *pipe)
> >>  {
> >> -	struct media_device *mdev = entity->graph_obj.mdev;
> >> +	struct media_device *mdev = pad->graph_obj.mdev;
> >>  	struct media_graph *graph = &pipe->graph;
> >> -	struct media_pad *pad = entity->pads;
> >>  	struct media_pad *pad_err = pad;
> >>  	struct media_link *link;
> >>  	int ret = 0;
> >> @@ -549,24 +548,23 @@ __must_check int __media_pipeline_start(struct media_entity *entity,
> >>  }
> >>  EXPORT_SYMBOL_GPL(__media_pipeline_start);
> >>  
> >> -__must_check int media_pipeline_start(struct media_entity *entity,
> >> +__must_check int media_pipeline_start(struct media_pad *pad,
> >>  				      struct media_pipeline *pipe)
> >>  {
> >> -	struct media_device *mdev = entity->graph_obj.mdev;
> >> +	struct media_device *mdev = pad->graph_obj.mdev;
> >>  	int ret;
> >>  
> >>  	mutex_lock(&mdev->graph_mutex);
> >> -	ret = __media_pipeline_start(entity, pipe);
> >> +	ret = __media_pipeline_start(pad, pipe);
> >>  	mutex_unlock(&mdev->graph_mutex);
> >>  	return ret;
> >>  }
> >>  EXPORT_SYMBOL_GPL(media_pipeline_start);
> >>  
> >> -void __media_pipeline_stop(struct media_entity *entity)
> >> +void __media_pipeline_stop(struct media_pad *pad)
> >>  {
> >> -	struct media_pipeline *pipe = entity->pads->pipe;
> >> +	struct media_pipeline *pipe = pad->pipe;
> >>  	struct media_graph *graph = &pipe->graph;
> >> -	struct media_pad *pad;
> >>  
> >>  	/*
> >>  	 * If the following check fails, the driver has performed an
> >> @@ -575,9 +573,10 @@ void __media_pipeline_stop(struct media_entity *entity)
> >>  	if (WARN_ON(!pipe))
> >>  		return;
> >>  
> >> -	media_graph_walk_start(graph, entity->pads);
> >> +	media_graph_walk_start(graph, pad);
> >>  
> >>  	while ((pad = media_graph_walk_next(graph))) {
> >> +		struct media_entity *entity = pad->entity;
> > 
> > It looks like this line is a bug fix for a previous patch in the series.
> 
> Yes, so it seems to be. The previous patch appears to remove it.
> 
> >>  		unsigned int i;
> >>  
> >>  		for (i = 0; i < entity->num_pads; i++) {
> >> @@ -598,12 +597,12 @@ void __media_pipeline_stop(struct media_entity *entity)
> >>  }
> >>  EXPORT_SYMBOL_GPL(__media_pipeline_stop);
> >>  
> >> -void media_pipeline_stop(struct media_entity *entity)
> >> +void media_pipeline_stop(struct media_pad *pad)
> >>  {
> >> -	struct media_device *mdev = entity->graph_obj.mdev;
> >> +	struct media_device *mdev = pad->graph_obj.mdev;
> >>  
> >>  	mutex_lock(&mdev->graph_mutex);
> >> -	__media_pipeline_stop(entity);
> >> +	__media_pipeline_stop(pad);
> >>  	mutex_unlock(&mdev->graph_mutex);
> >>  }
> >>  EXPORT_SYMBOL_GPL(media_pipeline_stop);
> > 
> > [snip]
> > 
> >> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> >> index ca0b79288ea7fd11..8378f700389635ea 100644
> >> --- a/include/media/media-entity.h
> >> +++ b/include/media/media-entity.h
> >> @@ -965,53 +965,54 @@ struct media_pad *media_graph_walk_next(struct media_graph *graph);
> >>  
> >>  /**
> >>   * media_pipeline_start - Mark a pipeline as streaming
> >> - * @entity: Starting entity
> >> - * @pipe: Media pipeline to be assigned to all entities in the pipeline.
> >> + * @pad: Starting pad
> >> + * @pipe: Media pipeline to be assigned to all pads in the pipeline.
> >>   *
> >> - * Mark all entities connected to a given entity through enabled links, either
> >> - * directly or indirectly, as streaming. The given pipeline object is assigned
> >> - * to every entity in the pipeline and stored in the media_entity pipe field.
> >> + * Mark all pads connected to a given pad through enabled
> >> + * routes or links, either directly or indirectly, as streaming. The
> >> + * given pipeline object is assigned to every pad in the pipeline
> >> + * and stored in the media_pad pipe field.
> > 
> > Reflowing text to the 80 columns limit ?
> 
> Agreed.
> 
> >>   *
> >>   * Calls to this function can be nested, in which case the same number of
> >>   * media_pipeline_stop() calls will be required to stop streaming. The
> >>   * pipeline pointer must be identical for all nested calls to
> >>   * media_pipeline_start().
> >>   */
> >> -__must_check int media_pipeline_start(struct media_entity *entity,
> >> +__must_check int media_pipeline_start(struct media_pad *pad,
> >>  				      struct media_pipeline *pipe);
> >>  /**
> >>   * __media_pipeline_start - Mark a pipeline as streaming
> >>   *
> >> - * @entity: Starting entity
> >> - * @pipe: Media pipeline to be assigned to all entities in the pipeline.
> >> + * @pad: Starting pad
> >> + * @pipe: Media pipeline to be assigned to all pads in the pipeline.
> >>   *
> >>   * ..note:: This is the non-locking version of media_pipeline_start()
> >>   */
> >> -__must_check int __media_pipeline_start(struct media_entity *entity,
> >> +__must_check int __media_pipeline_start(struct media_pad *pad,
> >>  					struct media_pipeline *pipe);
> >>  
> >>  /**
> >>   * media_pipeline_stop - Mark a pipeline as not streaming
> >> - * @entity: Starting entity
> >> + * @pad: Starting pad
> >>   *
> >> - * Mark all entities connected to a given entity through enabled links, either
> >> - * directly or indirectly, as not streaming. The media_entity pipe field is
> >> - * reset to %NULL.
> >> + * Mark all pads connected to a given pad through enabled routes or
> >> + * links, either directly or indirectly, as not streaming. The
> >> + * media_pad pipe field is reset to %NULL.
> > 
> > Ditto.
> > 
> > With the above fixed,
> > 
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> >>   *
> >>   * If multiple calls to media_pipeline_start() have been made, the same
> >>   * number of calls to this function are required to mark the pipeline as not
> >>   * streaming.
> >>   */
> >> -void media_pipeline_stop(struct media_entity *entity);
> >> +void media_pipeline_stop(struct media_pad *pad);
> >>  
> >>  /**
> >>   * __media_pipeline_stop - Mark a pipeline as not streaming
> >>   *
> >> - * @entity: Starting entity
> >> + * @pad: Starting pad
> >>   *
> >>   * .. note:: This is the non-locking version of media_pipeline_stop()
> >>   */
> >> -void __media_pipeline_stop(struct media_entity *entity);
> >> +void __media_pipeline_stop(struct media_pad *pad);
> >>  
> >>  /**
> >>   * media_devnode_create() - creates and initializes a device node interface

-- 
Regards,

Laurent Pinchart
