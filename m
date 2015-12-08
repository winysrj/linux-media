Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:46598 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965154AbbLHQEA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2015 11:04:00 -0500
Date: Tue, 8 Dec 2015 14:03:45 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Michal Simek <michal.simek@xilinx.com>,
	=?UTF-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-sh@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH v8 32/55] [media] media: use macros to check for V4L2
 subdev entities
Message-ID: <20151208140345.7d48c120@recife.lan>
In-Reply-To: <3216825.M3fFyKeUjZ@avalon>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
	<b94146f3b95e9adb08b11fffc896a9e747b2fa9c.1440902901.git.mchehab@osg.samsung.com>
	<3216825.M3fFyKeUjZ@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 06 Dec 2015 04:16:15 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Sunday 30 August 2015 00:06:43 Mauro Carvalho Chehab wrote:
> > Instead of relying on media subtype, use the new macros to detect
> > if an entity is a subdev or an A/V DMA entity.
> > 
> > Please note that most drivers assume that there's just AV_DMA or
> > V4L2 subdevs. This is not true anymore, as we've added MC support
> > for DVB, and there are plans to add support for ALSA and FB/DRM
> > too.
> > 
> > Ok, on the current pipelines supported by those drivers, just V4L
> > stuff are there, but, assuming that some day a pipeline that also
> > works with other subsystems will ever added, it is better to add
> > explicit checks for the AV_DMA stuff.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/platform/exynos4-is/common.c
> > b/drivers/media/platform/exynos4-is/common.c index
> > 0eb34ecb8ee4..8c9a29e0e294 100644
> > --- a/drivers/media/platform/exynos4-is/common.c
> > +++ b/drivers/media/platform/exynos4-is/common.c
> > @@ -22,8 +22,7 @@ struct v4l2_subdev *fimc_find_remote_sensor(struct
> > media_entity *entity) while (pad->flags & MEDIA_PAD_FL_SINK) {
> >  		/* source pad */
> >  		pad = media_entity_remote_pad(pad);
> > -		if (pad == NULL ||
> > -		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> > +		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
> >  			break;
> > 
> >  		sd = media_entity_to_v4l2_subdev(pad->entity);
> > diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c
> > b/drivers/media/platform/exynos4-is/fimc-capture.c index
> > 0627a93b2f3b..e9810fee4c30 100644
> > --- a/drivers/media/platform/exynos4-is/fimc-capture.c
> > +++ b/drivers/media/platform/exynos4-is/fimc-capture.c
> > @@ -1141,8 +1141,7 @@ static int fimc_pipeline_validate(struct fimc_dev
> > *fimc) }
> >  		}
> > 
> > -		if (src_pad == NULL ||
> > -		    media_entity_type(src_pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> > +		if (!src_pad || !is_media_entity_v4l2_subdev(src_pad->entity))
> >  			break;
> > 
> >  		/* Don't call FIMC subdev operation to avoid nested locking */
> > @@ -1397,7 +1396,7 @@ static int fimc_link_setup(struct media_entity
> > *entity, struct fimc_vid_cap *vc = &fimc->vid_cap;
> >  	struct v4l2_subdev *sensor;
> > 
> > -	if (media_entity_type(remote->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> > +	if (!is_media_entity_v4l2_subdev(remote->entity))
> >  		return -EINVAL;
> > 
> >  	if (WARN_ON(fimc == NULL))
> > diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c
> > b/drivers/media/platform/exynos4-is/fimc-isp-video.c index
> > 3d9ccbf5f10f..5fbaf5e39903 100644
> > --- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
> > +++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
> > @@ -467,8 +467,7 @@ static int isp_video_pipeline_validate(struct fimc_isp
> > *isp)
> > 
> >  		/* Retrieve format at the source pad */
> >  		pad = media_entity_remote_pad(pad);
> > -		if (pad == NULL ||
> > -		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> > +		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
> >  			break;
> > 
> >  		sd = media_entity_to_v4l2_subdev(pad->entity);
> > diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c
> > b/drivers/media/platform/exynos4-is/fimc-lite.c index
> > b2607da4ad14..c2327147b360 100644
> > --- a/drivers/media/platform/exynos4-is/fimc-lite.c
> > +++ b/drivers/media/platform/exynos4-is/fimc-lite.c
> > @@ -814,8 +814,7 @@ static int fimc_pipeline_validate(struct fimc_lite
> > *fimc) }
> >  		/* Retrieve format at the source pad */
> >  		pad = media_entity_remote_pad(pad);
> > -		if (pad == NULL ||
> > -		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> > +		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
> >  			break;
> > 
> >  		sd = media_entity_to_v4l2_subdev(pad->entity);
> > @@ -988,7 +987,6 @@ static int fimc_lite_link_setup(struct media_entity
> > *entity, {
> >  	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
> >  	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
> > -	unsigned int remote_ent_type = media_entity_type(remote->entity);
> >  	int ret = 0;
> > 
> >  	if (WARN_ON(fimc == NULL))
> > @@ -1000,7 +998,7 @@ static int fimc_lite_link_setup(struct media_entity
> > *entity,
> > 
> >  	switch (local->index) {
> >  	case FLITE_SD_PAD_SINK:
> > -		if (remote_ent_type != MEDIA_ENT_T_V4L2_SUBDEV) {
> > +		if (!is_media_entity_v4l2_subdev(remote->entity)) {
> >  			ret = -EINVAL;
> >  			break;
> >  		}
> > @@ -1018,7 +1016,7 @@ static int fimc_lite_link_setup(struct media_entity
> > *entity, case FLITE_SD_PAD_SOURCE_DMA:
> >  		if (!(flags & MEDIA_LNK_FL_ENABLED))
> >  			atomic_set(&fimc->out_path, FIMC_IO_NONE);
> > -		else if (remote_ent_type == MEDIA_ENT_T_DEVNODE)
> > +		else if (is_media_entity_v4l2_io(remote->entity))
> >  			atomic_set(&fimc->out_path, FIMC_IO_DMA);
> >  		else
> >  			ret = -EINVAL;
> > @@ -1027,7 +1025,7 @@ static int fimc_lite_link_setup(struct media_entity
> > *entity, case FLITE_SD_PAD_SOURCE_ISP:
> >  		if (!(flags & MEDIA_LNK_FL_ENABLED))
> >  			atomic_set(&fimc->out_path, FIMC_IO_NONE);
> > -		else if (remote_ent_type == MEDIA_ENT_T_V4L2_SUBDEV)
> > +		else if (is_media_entity_v4l2_subdev(remote->entity))
> >  			atomic_set(&fimc->out_path, FIMC_IO_ISP);
> >  		else
> >  			ret = -EINVAL;
> > diff --git a/drivers/media/platform/exynos4-is/media-dev.c
> > b/drivers/media/platform/exynos4-is/media-dev.c index
> > 92dbade2fffc..4a25df9dd869 100644
> > --- a/drivers/media/platform/exynos4-is/media-dev.c
> > +++ b/drivers/media/platform/exynos4-is/media-dev.c
> > @@ -88,8 +88,7 @@ static void fimc_pipeline_prepare(struct fimc_pipeline *p,
> > break;
> >  		}
> > 
> > -		if (pad == NULL ||
> > -		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> > +		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
> >  			break;
> >  		sd = media_entity_to_v4l2_subdev(pad->entity);
> > 
> > @@ -1062,7 +1061,7 @@ static int __fimc_md_modify_pipelines(struct
> > media_entity *entity, bool enable) media_entity_graph_walk_start(&graph,
> > entity);
> > 
> >  	while ((entity = media_entity_graph_walk_next(&graph))) {
> > -		if (media_entity_type(entity) != MEDIA_ENT_T_DEVNODE)
> > +		if (!is_media_entity_v4l2_io(entity))
> >  			continue;
> > 
> >  		ret  = __fimc_md_modify_pipeline(entity, enable);
> > @@ -1076,7 +1075,7 @@ static int __fimc_md_modify_pipelines(struct
> > media_entity *entity, bool enable) media_entity_graph_walk_start(&graph,
> > entity_err);
> > 
> >  	while ((entity_err = media_entity_graph_walk_next(&graph))) {
> > -		if (media_entity_type(entity_err) != MEDIA_ENT_T_DEVNODE)
> > +		if (!is_media_entity_v4l2_io(entity_err))
> >  			continue;
> > 
> >  		__fimc_md_modify_pipeline(entity_err, !enable);
> > diff --git a/drivers/media/platform/omap3isp/isp.c
> > b/drivers/media/platform/omap3isp/isp.c index 69e7733d36cd..cb8ac90086c1
> > 100644
> > --- a/drivers/media/platform/omap3isp/isp.c
> > +++ b/drivers/media/platform/omap3isp/isp.c
> > @@ -691,7 +691,7 @@ static int isp_pipeline_pm_use_count(struct media_entity
> > *entity) media_entity_graph_walk_start(&graph, entity);
> > 
> >  	while ((entity = media_entity_graph_walk_next(&graph))) {
> > -		if (media_entity_type(entity) == MEDIA_ENT_T_DEVNODE)
> > +		if (is_media_entity_v4l2_io(entity))
> >  			use += entity->use_count;
> >  	}
> > 
> > @@ -714,7 +714,7 @@ static int isp_pipeline_pm_power_one(struct media_entity
> > *entity, int change) struct v4l2_subdev *subdev;
> >  	int ret;
> > 
> > -	subdev = media_entity_type(entity) == MEDIA_ENT_T_V4L2_SUBDEV
> > +	subdev = is_media_entity_v4l2_subdev(entity)
> >  	       ? media_entity_to_v4l2_subdev(entity) : NULL;
> > 
> >  	if (entity->use_count == 0 && change > 0 && subdev != NULL) {
> > @@ -754,7 +754,7 @@ static int isp_pipeline_pm_power(struct media_entity
> > *entity, int change) media_entity_graph_walk_start(&graph, entity);
> > 
> >  	while (!ret && (entity = media_entity_graph_walk_next(&graph)))
> > -		if (media_entity_type(entity) != MEDIA_ENT_T_DEVNODE)
> > +		if (is_media_entity_v4l2_subdev(entity))
> >  			ret = isp_pipeline_pm_power_one(entity, change);
> > 
> >  	if (!ret)
> > @@ -764,7 +764,7 @@ static int isp_pipeline_pm_power(struct media_entity
> > *entity, int change)
> > 
> >  	while ((first = media_entity_graph_walk_next(&graph))
> >  	       && first != entity)
> > -		if (media_entity_type(first) != MEDIA_ENT_T_DEVNODE)
> > +		if (is_media_entity_v4l2_subdev(first))
> >  			isp_pipeline_pm_power_one(first, -change);
> > 
> >  	return ret;
> > @@ -897,8 +897,7 @@ static int isp_pipeline_enable(struct isp_pipeline
> > *pipe, break;
> > 
> >  		pad = media_entity_remote_pad(pad);
> > -		if (pad == NULL ||
> > -		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> > +		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
> >  			break;
> > 
> >  		entity = pad->entity;
> > @@ -988,8 +987,7 @@ static int isp_pipeline_disable(struct isp_pipeline
> > *pipe) break;
> > 
> >  		pad = media_entity_remote_pad(pad);
> > -		if (pad == NULL ||
> > -		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> > +		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
> >  			break;
> > 
> >  		entity = pad->entity;
> > diff --git a/drivers/media/platform/omap3isp/ispvideo.c
> > b/drivers/media/platform/omap3isp/ispvideo.c index
> > 4c367352b1f7..52843ac2a9ca 100644
> > --- a/drivers/media/platform/omap3isp/ispvideo.c
> > +++ b/drivers/media/platform/omap3isp/ispvideo.c
> > @@ -210,8 +210,7 @@ isp_video_remote_subdev(struct isp_video *video, u32
> > *pad)
> > 
> >  	remote = media_entity_remote_pad(&video->pad);
> > 
> > -	if (remote == NULL ||
> > -	    media_entity_type(remote->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> > +	if (!remote || !is_media_entity_v4l2_subdev(remote->entity))
> >  		return NULL;
> > 
> >  	if (pad)
> > @@ -243,7 +242,7 @@ static int isp_video_get_graph_data(struct isp_video
> > *video, if (entity == &video->video.entity)
> >  			continue;
> > 
> > -		if (media_entity_type(entity) != MEDIA_ENT_T_DEVNODE)
> > +		if (!is_media_entity_v4l2_io(entity))
> >  			continue;
> > 
> >  		__video = to_isp_video(media_entity_to_video_device(entity));
> > @@ -917,7 +916,7 @@ static int isp_video_check_external_subdevs(struct
> > isp_video *video, return -EINVAL;
> >  	}
> > 
> > -	if (media_entity_type(source) != MEDIA_ENT_T_V4L2_SUBDEV)
> > +	if (!is_media_entity_v4l2_subdev(source))
> >  		return 0;
> > 
> >  	pipe->external = media_entity_to_v4l2_subdev(source);
> > diff --git a/drivers/media/platform/s3c-camif/camif-capture.c
> > b/drivers/media/platform/s3c-camif/camif-capture.c index
> > eae667eab1b9..fb5b016cc0a1 100644
> > --- a/drivers/media/platform/s3c-camif/camif-capture.c
> > +++ b/drivers/media/platform/s3c-camif/camif-capture.c
> > @@ -837,7 +837,7 @@ static int camif_pipeline_validate(struct camif_dev
> > *camif)
> > 
> >  	/* Retrieve format at the sensor subdev source pad */
> >  	pad = media_entity_remote_pad(&camif->pads[0]);
> > -	if (!pad || media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> > +	if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
> >  		return -EPIPE;
> > 
> >  	src_fmt.pad = pad->index;
> > diff --git a/drivers/media/platform/vsp1/vsp1_video.c
> > b/drivers/media/platform/vsp1/vsp1_video.c index 1f94c1a54e00..f74158224b93
> > 100644
> > --- a/drivers/media/platform/vsp1/vsp1_video.c
> > +++ b/drivers/media/platform/vsp1/vsp1_video.c
> > @@ -160,8 +160,7 @@ vsp1_video_remote_subdev(struct media_pad *local, u32
> > *pad) struct media_pad *remote;
> > 
> >  	remote = media_entity_remote_pad(local);
> > -	if (remote == NULL ||
> > -	    media_entity_type(remote->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> > +	if (!remote || !is_media_entity_v4l2_subdev(remote->entity))
> >  		return NULL;
> > 
> >  	if (pad)
> > @@ -326,7 +325,7 @@ static int vsp1_pipeline_validate_branch(struct
> > vsp1_pipeline *pipe, return -EPIPE;
> > 
> >  		/* We've reached a video node, that shouldn't have happened. */
> > -		if (media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> > +		if (!is_media_entity_v4l2_subdev(pad->entity))
> >  			return -EPIPE;
> > 
> >  		entity = to_vsp1_entity(media_entity_to_v4l2_subdev(pad->entity));
> > @@ -423,7 +422,7 @@ static int vsp1_pipeline_validate(struct vsp1_pipeline
> > *pipe, struct vsp1_rwpf *rwpf;
> >  		struct vsp1_entity *e;
> > 
> > -		if (media_entity_type(entity) != MEDIA_ENT_T_V4L2_SUBDEV) {
> > +		if (is_media_entity_v4l2_io(entity)) {
> >  			pipe->num_video++;
> >  			continue;
> >  		}
> > @@ -692,7 +691,7 @@ void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline
> > *pipe, pad = media_entity_remote_pad(&input->pads[RWPF_PAD_SOURCE]);
> > 
> >  	while (pad) {
> > -		if (media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> > +		if (!is_media_entity_v4l2_subdev(pad->entity))
> >  			break;
> > 
> >  		entity = to_vsp1_entity(media_entity_to_v4l2_subdev(pad->entity));
> > diff --git a/drivers/media/platform/xilinx/xilinx-dma.c
> > b/drivers/media/platform/xilinx/xilinx-dma.c index
> > 88cd789cdaf7..8e14841bf445 100644
> > --- a/drivers/media/platform/xilinx/xilinx-dma.c
> > +++ b/drivers/media/platform/xilinx/xilinx-dma.c
> > @@ -49,8 +49,7 @@ xvip_dma_remote_subdev(struct media_pad *local, u32 *pad)
> >  	struct media_pad *remote;
> > 
> >  	remote = media_entity_remote_pad(local);
> > -	if (remote == NULL ||
> > -	    media_entity_type(remote->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> > +	if (!remote || !is_media_entity_v4l2_subdev(remote->entity))
> >  		return NULL;
> > 
> >  	if (pad)
> > @@ -113,8 +112,7 @@ static int xvip_pipeline_start_stop(struct xvip_pipeline
> > *pipe, bool start) break;
> > 
> >  		pad = media_entity_remote_pad(pad);
> > -		if (pad == NULL ||
> > -		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> > +		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
> >  			break;
> > 
> >  		entity = pad->entity;
> > diff --git a/drivers/media/v4l2-core/v4l2-subdev.c
> > b/drivers/media/v4l2-core/v4l2-subdev.c index e6e1115d8215..60da43772de9
> > 100644
> > --- a/drivers/media/v4l2-core/v4l2-subdev.c
> > +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> > @@ -526,7 +526,7 @@ static int
> >  v4l2_subdev_link_validate_get_format(struct media_pad *pad,
> >  				     struct v4l2_subdev_format *fmt)
> >  {
> > -	if (media_entity_type(pad->entity) == MEDIA_ENT_T_V4L2_SUBDEV) {
> > +	if (is_media_entity_v4l2_subdev(pad->entity)) {
> >  		struct v4l2_subdev *sd =
> >  			media_entity_to_v4l2_subdev(pad->entity);
> > 
> > diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> > b/drivers/staging/media/davinci_vpfe/vpfe_video.c index
> > 92573fa852a9..16763e0831f2 100644
> > --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> > +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> > @@ -148,7 +148,7 @@ static void vpfe_prepare_pipeline(struct
> > vpfe_video_device *video) while ((entity =
> > media_entity_graph_walk_next(&graph))) {
> >  		if (entity == &video->video_dev.entity)
> >  			continue;
> > -		if (media_entity_type(entity) != MEDIA_ENT_T_DEVNODE)
> > +		if ((!is_media_entity_v4l2_io(remote->entity))
> >  			continue;
> >  		far_end = to_vpfe_video(media_entity_to_video_device(entity));
> >  		if (far_end->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> > @@ -293,7 +293,7 @@ static int vpfe_pipeline_enable(struct vpfe_pipeline
> > *pipe) media_entity_graph_walk_start(&graph, entity);
> >  	while ((entity = media_entity_graph_walk_next(&graph))) {
> > 
> > -		if (media_entity_type(entity) == MEDIA_ENT_T_DEVNODE)
> > +		if !is_media_entity_v4l2_subdev(entity))
> 
> With these two chunks fixed,
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> I'm wondering, however, why you replace some occurrences of == 
> MEDIA_ENT_T_DEVNODE with !is_media_entity_v4l2_subdev and some other with 
> is_media_entity_v4l2_io.

For devices that don't have non-V4L2 media controller nodes, this would
work, but if we ever add ALSA, DVB, IIO, etc to the media controller,
then we may have troubles.

That's why I opted to add a macro for checking for the V4L2 subdev.
This is more future-proof, as other patches may be adding other
non-V4L2 types of MC entities have the potential of breaking codes like
the above.

> 
> >  			continue;
> >  		subdev = media_entity_to_v4l2_subdev(entity);
> >  		ret = v4l2_subdev_call(subdev, video, s_stream, 1);
> > @@ -334,7 +334,7 @@ static int vpfe_pipeline_disable(struct vpfe_pipeline
> > *pipe)
> > 
> >  	while ((entity = media_entity_graph_walk_next(&graph))) {
> > 
> > -		if (media_entity_type(entity) == MEDIA_ENT_T_DEVNODE)
> > +		if (!is_media_entity_v4l2_subdev(entity))
> >  			continue;
> >  		subdev = media_entity_to_v4l2_subdev(entity);
> >  		ret = v4l2_subdev_call(subdev, video, s_stream, 0);
> > diff --git a/drivers/staging/media/omap4iss/iss.c
> > b/drivers/staging/media/omap4iss/iss.c index 40591963b42b..44b88ff3ba83
> > 100644
> > --- a/drivers/staging/media/omap4iss/iss.c
> > +++ b/drivers/staging/media/omap4iss/iss.c
> > @@ -397,7 +397,7 @@ static int iss_pipeline_pm_use_count(struct media_entity
> > *entity) media_entity_graph_walk_start(&graph, entity);
> > 
> >  	while ((entity = media_entity_graph_walk_next(&graph))) {
> > -		if (media_entity_type(entity) == MEDIA_ENT_T_DEVNODE)
> > +		if (is_media_entity_v4l2_io(entity))
> >  			use += entity->use_count;
> >  	}
> > 
> > @@ -419,7 +419,7 @@ static int iss_pipeline_pm_power_one(struct media_entity
> > *entity, int change) {
> >  	struct v4l2_subdev *subdev;
> > 
> > -	subdev = media_entity_type(entity) == MEDIA_ENT_T_V4L2_SUBDEV
> > +	subdev = is_media_entity_v4l2_subdev(entity)
> >  	       ? media_entity_to_v4l2_subdev(entity) : NULL;
> > 
> >  	if (entity->use_count == 0 && change > 0 && subdev != NULL) {
> > @@ -461,7 +461,7 @@ static int iss_pipeline_pm_power(struct media_entity
> > *entity, int change) media_entity_graph_walk_start(&graph, entity);
> > 
> >  	while (!ret && (entity = media_entity_graph_walk_next(&graph)))
> > -		if (media_entity_type(entity) != MEDIA_ENT_T_DEVNODE)
> > +		if (is_media_entity_v4l2_subdev(entity))
> >  			ret = iss_pipeline_pm_power_one(entity, change);
> > 
> >  	if (!ret)
> > @@ -471,7 +471,7 @@ static int iss_pipeline_pm_power(struct media_entity
> > *entity, int change)
> > 
> >  	while ((first = media_entity_graph_walk_next(&graph))
> >  	       && first != entity)
> > -		if (media_entity_type(first) != MEDIA_ENT_T_DEVNODE)
> > +		if (is_media_entity_v4l2_subdev(first))
> >  			iss_pipeline_pm_power_one(first, -change);
> > 
> >  	return ret;
> > @@ -590,8 +590,7 @@ static int iss_pipeline_disable(struct iss_pipeline
> > *pipe, break;
> > 
> >  		pad = media_entity_remote_pad(pad);
> > -		if (pad == NULL ||
> > -		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> > +		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
> >  			break;
> > 
> >  		entity = pad->entity;
> > @@ -658,8 +657,7 @@ static int iss_pipeline_enable(struct iss_pipeline
> > *pipe, break;
> > 
> >  		pad = media_entity_remote_pad(pad);
> > -		if (pad == NULL ||
> > -		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> > +		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
> >  			break;
> > 
> >  		entity = pad->entity;
> > diff --git a/drivers/staging/media/omap4iss/iss_video.c
> > b/drivers/staging/media/omap4iss/iss_video.c index
> > 45a3f2d778fc..cbe5783735dc 100644
> > --- a/drivers/staging/media/omap4iss/iss_video.c
> > +++ b/drivers/staging/media/omap4iss/iss_video.c
> > @@ -191,8 +191,7 @@ iss_video_remote_subdev(struct iss_video *video, u32
> > *pad)
> > 
> >  	remote = media_entity_remote_pad(&video->pad);
> > 
> > -	if (remote == NULL ||
> > -	    media_entity_type(remote->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> > +	if (!remote || !is_media_entity_v4l2_subdev(remote->entity))
> >  		return NULL;
> > 
> >  	if (pad)
> > @@ -217,7 +216,7 @@ iss_video_far_end(struct iss_video *video)
> >  		if (entity == &video->video.entity)
> >  			continue;
> > 
> > -		if (media_entity_type(entity) != MEDIA_ENT_T_DEVNODE)
> > +		if (!is_media_entity_v4l2_io(entity))
> >  			continue;
> > 
> >  		far_end = to_iss_video(media_entity_to_video_device(entity));
> 
