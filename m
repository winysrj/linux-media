Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A661EC43612
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 22:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CBC5214DA
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 22:48:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387736AbfAOWs6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 17:48:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:39587 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387714AbfAOWs6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 17:48:58 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jan 2019 14:48:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,483,1539673200"; 
   d="scan'208";a="117023882"
Received: from markusac-mobl.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.252.58.202])
  by fmsmga008.fm.intel.com with ESMTP; 15 Jan 2019 14:48:55 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id C67F021E54; Wed, 16 Jan 2019 00:48:52 +0200 (EET)
Date:   Wed, 16 Jan 2019 00:48:52 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 05/30] media: entity: Move the pipeline from entity to
 pads
Message-ID: <20190115224851.6jqyxszr6xg3w6p5@kekkonen.localdomain>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-6-niklas.soderlund+renesas@ragnatech.se>
 <20190115223842.GF28397@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190115223842.GF28397@pendragon.ideasonboard.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Jan 16, 2019 at 12:38:42AM +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thanks you for the patch.
> 
> On Fri, Nov 02, 2018 at 12:31:19AM +0100, Niklas S�derlund wrote:
> > From: Sakari Ailus <sakari.ailus@linux.intel.com>
> > 
> > This moves the pipe and stream_count fields from struct media_entity to
> > struct media_pad. Effectively streams become pad-specific rather than
> > being stream specific, allowing several independent streams to traverse a
> 
> Should this be "entity-specific" instead of "stream specific" ?

Yes.

> 
> > single entity.
> 
> "and the entity to be part of multiple pipelines" ?

Sounds good.

> 
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Reviewed-by: Niklas S�derlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/media-entity.c                  | 61 ++++++++++++-------
> >  drivers/media/platform/exynos4-is/fimc-isp.c  |  2 +-
> >  drivers/media/platform/exynos4-is/fimc-lite.c |  2 +-
> >  drivers/media/platform/omap3isp/isp.c         |  2 +-
> >  drivers/media/platform/omap3isp/ispvideo.c    |  2 +-
> >  drivers/media/platform/omap3isp/ispvideo.h    |  2 +-
> >  drivers/media/platform/rcar-vin/rcar-dma.c    |  2 +-
> >  drivers/media/platform/xilinx/xilinx-dma.c    |  2 +-
> >  drivers/media/platform/xilinx/xilinx-dma.h    |  2 +-
> >  drivers/staging/media/imx/imx-media-utils.c   |  2 +-
> >  drivers/staging/media/omap4iss/iss.c          |  2 +-
> >  drivers/staging/media/omap4iss/iss_video.c    |  2 +-
> >  drivers/staging/media/omap4iss/iss_video.h    |  2 +-
> >  include/media/media-entity.h                  | 17 ++++--
> >  14 files changed, 61 insertions(+), 41 deletions(-)
> > 
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index 70db03fa33a21db1..13260149c4dfc90c 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -419,7 +419,7 @@ __must_check int __media_pipeline_start(struct media_entity *entity,
> >  	struct media_pad *pad = entity->pads;
> >  	struct media_pad *pad_err = pad;
> >  	struct media_link *link;
> > -	int ret;
> > +	int ret = 0;
> 
> Is this needed ?
> 
> >  
> >  	if (!pipe->streaming_count++) {
> >  		ret = media_graph_walk_init(&pipe->graph, mdev);
> > @@ -431,21 +431,27 @@ __must_check int __media_pipeline_start(struct media_entity *entity,
> >  
> >  	while ((pad = media_graph_walk_next(graph))) {
> >  		struct media_entity *entity = pad->entity;
> > +		unsigned int i;
> > +		bool skip_validation = pad->pipe;
> >  
> >  		DECLARE_BITMAP(active, MEDIA_ENTITY_MAX_PADS);
> >  		DECLARE_BITMAP(has_no_links, MEDIA_ENTITY_MAX_PADS);
> >  
> > -		entity->stream_count++;
> > +		for (i = 0; i < entity->num_pads; i++) {
> > +			struct media_pad *iter = &entity->pads[i];
> 
> Unrelated to this patch, a for_each_pad() would be nice.
> 
> >  
> > -		if (WARN_ON(entity->pipe && entity->pipe != pipe)) {
> > -			ret = -EBUSY;
> > -			goto error;
> > +			if (iter->pipe && WARN_ON(iter->pipe != pipe))
> > +				ret = -EBUSY;
> > +			else
> > +				iter->pipe = pipe;
> > +			iter->stream_count++;
> 
> How about keeping a similar construct as currently exists ?

That would complicate the error handling there. Now it's enough to figure
out on which entity the failure happened, not the pad.

> 
> 		iter->stream_count++;
> 		if (WARN_ON(iter->pipe && iter->pipe != pipe) {
> 			ret = -EBUSY;
> 			goto error;
> 		}
> 
> 		iter->pipe = pipe;
> 
> >  		}
> >  
> > -		entity->pipe = pipe;
> > +		if (ret)
> > +			goto error;
> >  
> >  		/* Already streaming --- no need to check. */
> 
> Maybe "Already part of the pipeline" to match the condition ?

Fine with me.

> 
> > -		if (entity->stream_count > 1)
> > +		if (skip_validation)
> >  			continue;
> >  
> >  		if (!entity->ops || !entity->ops->link_validate)
> > @@ -514,19 +520,24 @@ __must_check int __media_pipeline_start(struct media_entity *entity,
> >  
> >  	while ((pad_err = media_graph_walk_next(graph))) {
> >  		struct media_entity *entity_err = pad_err->entity;
> > +		unsigned int i;
> > +
> > +		for (i = 0; i < entity_err->num_pads; i++) {
> > +			struct media_pad *iter = &entity_err->pads[i];
> >  
> > -		/* Sanity check for negative stream_count */
> > -		if (!WARN_ON_ONCE(entity_err->stream_count <= 0)) {
> > -			entity_err->stream_count--;
> > -			if (entity_err->stream_count == 0)
> > -				entity_err->pipe = NULL;
> > +			/* Sanity check for negative stream_count */
> > +			if (!WARN_ON_ONCE(iter->stream_count <= 0)) {
> > +				--iter->stream_count;
> > +				if (iter->stream_count == 0)
> > +					iter->pipe = NULL;
> > +			}
> >  		}
> >  
> >  		/*
> >  		 * We haven't increased stream_count further than this
> >  		 * so we quit here.
> >  		 */
> > -		if (pad_err == pad)
> > +		if (pad_err->entity == pad->entity)
> 
> Is this needed ?

See above�.

> 
> >  			break;
> >  	}
> >  
> > @@ -553,7 +564,7 @@ EXPORT_SYMBOL_GPL(media_pipeline_start);
> >  
> >  void __media_pipeline_stop(struct media_entity *entity)
> >  {
> > -	struct media_pipeline *pipe = entity->pipe;
> > +	struct media_pipeline *pipe = entity->pads->pipe;
> >  	struct media_graph *graph = &pipe->graph;
> >  	struct media_pad *pad;
> >  
> > @@ -567,13 +578,17 @@ void __media_pipeline_stop(struct media_entity *entity)
> >  	media_graph_walk_start(graph, entity->pads);
> >  
> >  	while ((pad = media_graph_walk_next(graph))) {
> > -		struct media_entity *entity = pad->entity;
> > +		unsigned int i;
> >  
> > -		/* Sanity check for negative stream_count */
> > -		if (!WARN_ON_ONCE(entity->stream_count <= 0)) {
> > -			entity->stream_count--;
> > -			if (entity->stream_count == 0)
> > -				entity->pipe = NULL;
> > +		for (i = 0; i < entity->num_pads; i++) {
> > +			struct media_pad *iter = &entity->pads[i];
> > +
> > +			/* Sanity check for negative stream_count */
> > +			if (!WARN_ON_ONCE(iter->stream_count <= 0)) {
> > +				iter->stream_count--;
> > +				if (iter->stream_count == 0)
> > +					iter->pipe = NULL;
> > +			}
> >  		}
> >  	}
> >  
> > @@ -865,7 +880,7 @@ int __media_entity_setup_link(struct media_link *link, u32 flags)
> >  {
> >  	const u32 mask = MEDIA_LNK_FL_ENABLED;
> >  	struct media_device *mdev;
> > -	struct media_entity *source, *sink;
> > +	struct media_pad *source, *sink;
> >  	int ret = -EBUSY;
> >  
> >  	if (link == NULL)
> > @@ -881,8 +896,8 @@ int __media_entity_setup_link(struct media_link *link, u32 flags)
> >  	if (link->flags == flags)
> >  		return 0;
> >  
> > -	source = link->source->entity;
> > -	sink = link->sink->entity;
> > +	source = link->source;
> > +	sink = link->sink;
> >  
> >  	if (!(link->flags & MEDIA_LNK_FL_DYNAMIC) &&
> >  	    (source->stream_count || sink->stream_count))
> > diff --git a/drivers/media/platform/exynos4-is/fimc-isp.c b/drivers/media/platform/exynos4-is/fimc-isp.c
> > index 9a48c0f69320ba35..79d128a57e87fd58 100644
> > --- a/drivers/media/platform/exynos4-is/fimc-isp.c
> > +++ b/drivers/media/platform/exynos4-is/fimc-isp.c
> > @@ -229,7 +229,7 @@ static int fimc_isp_subdev_set_fmt(struct v4l2_subdev *sd,
> >  			}
> >  		}
> >  	} else {
> > -		if (sd->entity.stream_count == 0) {
> > +		if (sd->entity.pads->stream_count == 0) {
> >  			if (fmt->pad == FIMC_ISP_SD_PAD_SINK) {
> >  				struct v4l2_subdev_format format = *fmt;
> >  
> > diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
> > index 96f0a8a0dcae591f..dbadcba6739a286b 100644
> > --- a/drivers/media/platform/exynos4-is/fimc-lite.c
> > +++ b/drivers/media/platform/exynos4-is/fimc-lite.c
> > @@ -1096,7 +1096,7 @@ static int fimc_lite_subdev_set_fmt(struct v4l2_subdev *sd,
> >  	mutex_lock(&fimc->lock);
> >  
> >  	if ((atomic_read(&fimc->out_path) == FIMC_IO_ISP &&
> > -	    sd->entity.stream_count > 0) ||
> > +	    sd->entity.pads->stream_count > 0) ||
> >  	    (atomic_read(&fimc->out_path) == FIMC_IO_DMA &&
> >  	    vb2_is_busy(&fimc->vb_queue))) {
> >  		mutex_unlock(&fimc->lock);
> > diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> > index 77fb7987b42f33cd..3663dfd00cadc2f0 100644
> > --- a/drivers/media/platform/omap3isp/isp.c
> > +++ b/drivers/media/platform/omap3isp/isp.c
> > @@ -927,7 +927,7 @@ static int isp_pipeline_is_last(struct media_entity *me)
> >  	struct isp_pipeline *pipe;
> >  	struct media_pad *pad;
> >  
> > -	if (!me->pipe)
> > +	if (!me->pads->pipe)
> >  		return 0;
> >  	pipe = to_isp_pipeline(me);
> >  	if (pipe->stream_state == ISP_PIPELINE_STREAM_STOPPED)
> > diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
> > index dc11b732dc05b00b..f354cd7ceb8ffce5 100644
> > --- a/drivers/media/platform/omap3isp/ispvideo.c
> > +++ b/drivers/media/platform/omap3isp/ispvideo.c
> > @@ -1102,7 +1102,7 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
> >  	/* Start streaming on the pipeline. No link touching an entity in the
> >  	 * pipeline can be activated or deactivated once streaming is started.
> >  	 */
> > -	pipe = video->video.entity.pipe
> > +	pipe = video->video.entity.pads->pipe
> >  	     ? to_isp_pipeline(&video->video.entity) : &video->pipe;
> >  
> >  	ret = media_entity_enum_init(&pipe->ent_enum, &video->isp->media_dev);
> > diff --git a/drivers/media/platform/omap3isp/ispvideo.h b/drivers/media/platform/omap3isp/ispvideo.h
> > index f6a2082b4a0a7708..8f4146c25a1b1293 100644
> > --- a/drivers/media/platform/omap3isp/ispvideo.h
> > +++ b/drivers/media/platform/omap3isp/ispvideo.h
> > @@ -103,7 +103,7 @@ struct isp_pipeline {
> >  };
> >  
> >  #define to_isp_pipeline(__e) \
> > -	container_of((__e)->pipe, struct isp_pipeline, pipe)
> > +	container_of((__e)->pads->pipe, struct isp_pipeline, pipe)
> >  
> >  static inline int isp_pipeline_ready(struct isp_pipeline *pipe)
> >  {
> > diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> > index 92323310f7352147..e749096926f34d4a 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> > @@ -1128,7 +1128,7 @@ static int rvin_set_stream(struct rvin_dev *vin, int on)
> >  	 */
> >  	mdev = vin->vdev.entity.graph_obj.mdev;
> >  	mutex_lock(&mdev->graph_mutex);
> > -	pipe = sd->entity.pipe ? sd->entity.pipe : &vin->vdev.pipe;
> > +	pipe = sd->entity.pads->pipe ? sd->entity.pads->pipe : &vin->vdev.pipe;
> >  	ret = __media_pipeline_start(&vin->vdev.entity, pipe);
> >  	mutex_unlock(&mdev->graph_mutex);
> >  	if (ret)
> > diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
> > index a2a329336243bdc7..f27a7be5f5d0f0b5 100644
> > --- a/drivers/media/platform/xilinx/xilinx-dma.c
> > +++ b/drivers/media/platform/xilinx/xilinx-dma.c
> > @@ -406,7 +406,7 @@ static int xvip_dma_start_streaming(struct vb2_queue *vq, unsigned int count)
> >  	 * Use the pipeline object embedded in the first DMA object that starts
> >  	 * streaming.
> >  	 */
> > -	pipe = dma->video.entity.pipe
> > +	pipe = dma->video.entity.pads->pipe
> >  	     ? to_xvip_pipeline(&dma->video.entity) : &dma->pipe;
> >  
> >  	ret = media_pipeline_start(&dma->video.entity, &pipe->pipe);
> > diff --git a/drivers/media/platform/xilinx/xilinx-dma.h b/drivers/media/platform/xilinx/xilinx-dma.h
> > index e95d136c153a8f5f..c12e053ff41eed1c 100644
> > --- a/drivers/media/platform/xilinx/xilinx-dma.h
> > +++ b/drivers/media/platform/xilinx/xilinx-dma.h
> > @@ -50,7 +50,7 @@ struct xvip_pipeline {
> >  
> >  static inline struct xvip_pipeline *to_xvip_pipeline(struct media_entity *e)
> >  {
> > -	return container_of(e->pipe, struct xvip_pipeline, pipe);
> > +	return container_of(e->pads->pipe, struct xvip_pipeline, pipe);
> >  }
> >  
> >  /**
> > diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
> > index 0eaa353d5cb39768..ba9d9a8337cb159e 100644
> > --- a/drivers/staging/media/imx/imx-media-utils.c
> > +++ b/drivers/staging/media/imx/imx-media-utils.c
> > @@ -917,7 +917,7 @@ int imx_media_pipeline_set_stream(struct imx_media_dev *imxmd,
> >  			__media_pipeline_stop(entity);
> >  	} else {
> >  		v4l2_subdev_call(sd, video, s_stream, 0);
> > -		if (entity->pipe)
> > +		if (entity->pads->pipe)
> >  			__media_pipeline_stop(entity);
> >  	}
> >  
> > diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
> > index c8be1db532ab2555..030808b222cf3ae5 100644
> > --- a/drivers/staging/media/omap4iss/iss.c
> > +++ b/drivers/staging/media/omap4iss/iss.c
> > @@ -543,7 +543,7 @@ static int iss_pipeline_is_last(struct media_entity *me)
> >  	struct iss_pipeline *pipe;
> >  	struct media_pad *pad;
> >  
> > -	if (!me->pipe)
> > +	if (!me->pads->pipe)
> >  		return 0;
> >  	pipe = to_iss_pipeline(me);
> >  	if (pipe->stream_state == ISS_PIPELINE_STREAM_STOPPED)
> > diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
> > index 1271bbacf9e7bdeb..65f1e358271b3743 100644
> > --- a/drivers/staging/media/omap4iss/iss_video.c
> > +++ b/drivers/staging/media/omap4iss/iss_video.c
> > @@ -877,7 +877,7 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
> >  	 * Start streaming on the pipeline. No link touching an entity in the
> >  	 * pipeline can be activated or deactivated once streaming is started.
> >  	 */
> > -	pipe = pad->entity->pipe
> > +	pipe = pad->pipe
> >  	     ? to_iss_pipeline(pad->entity) : &video->pipe;
> >  	pipe->external = NULL;
> >  	pipe->external_rate = 0;
> > diff --git a/drivers/staging/media/omap4iss/iss_video.h b/drivers/staging/media/omap4iss/iss_video.h
> > index f22489edb5624af2..cdea8543b3f93ecf 100644
> > --- a/drivers/staging/media/omap4iss/iss_video.h
> > +++ b/drivers/staging/media/omap4iss/iss_video.h
> > @@ -94,7 +94,7 @@ struct iss_pipeline {
> >  };
> >  
> >  #define to_iss_pipeline(__e) \
> > -	container_of((__e)->pipe, struct iss_pipeline, pipe)
> > +	container_of((__e)->pads->pipe, struct iss_pipeline, pipe)
> >  
> >  static inline int iss_pipeline_ready(struct iss_pipeline *pipe)
> >  {
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index cde6350d752bb0ae..ca0b79288ea7fd11 100644
> > --- a/include/media/media-entity.h
> > +++ b/include/media/media-entity.h
> > @@ -188,15 +188,25 @@ enum media_pad_signal_type {
> >   *
> >   * @graph_obj:	Embedded structure containing the media object common data
> >   * @entity:	Entity this pad belongs to
> > + * @pipe:	Pipeline this entity belongs to.
> 
> s/entity/pad/
> 
> > + * @stream_count: Stream count for the entity.
> 
> Ditto.

Agreed.

> 
> >   * @index:	Pad index in the entity pads array, numbered from 0 to n
> >   * @sig_type:	Type of the signal inside a media pad
> >   * @flags:	Pad flags, as defined in
> >   *		:ref:`include/uapi/linux/media.h <media_header>`
> >   *		(seek for ``MEDIA_PAD_FL_*``)
> > + * .. note::
> > + *
> > + *    @stream_count reference counts must never be negative, but are
> > + *    signed integers on purpose: a simple ``WARN_ON(<0)`` check can
> > + *    be used to detect reference count bugs that would make them
> > + *    negative.
> >   */
> >  struct media_pad {
> >  	struct media_gobj graph_obj;	/* must be first field in struct */
> >  	struct media_entity *entity;
> > +	struct media_pipeline *pipe;
> > +	int stream_count;
> >  	u16 index;
> >  	enum media_pad_signal_type sig_type;
> >  	unsigned long flags;
> > @@ -274,9 +284,7 @@ enum media_entity_type {
> >   * @pads:	Pads array with the size defined by @num_pads.
> >   * @links:	List of data links.
> >   * @ops:	Entity operations.
> > - * @stream_count: Stream count for the entity.
> >   * @use_count:	Use count for the entity.
> > - * @pipe:	Pipeline this entity belongs to.
> >   * @info:	Union with devnode information.  Kept just for backward
> >   *		compatibility.
> >   * @info.dev:	Contains device major and minor info.
> > @@ -289,7 +297,7 @@ enum media_entity_type {
> >   *
> >   * .. note::
> >   *
> > - *    @stream_count and @use_count reference counts must never be
> > + *    @use_count reference counts must never be
> >   *    negative, but are signed integers on purpose: a simple ``WARN_ON(<0)``
> >   *    check can be used to detect reference count bugs that would make them
> 
> I would rewrap the text.
> 
> With the above comments addressed,
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> >   *    negative.
> > @@ -311,11 +319,8 @@ struct media_entity {
> >  
> >  	const struct media_entity_operations *ops;
> >  
> > -	int stream_count;
> >  	int use_count;
> >  
> > -	struct media_pipeline *pipe;
> > -
> >  	union {
> >  		struct {
> >  			u32 major;
> 
> -- 
> Regards,
> 
> Laurent Pinchart

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
