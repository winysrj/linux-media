Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:60650 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750995AbbEHMqi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 May 2015 08:46:38 -0400
Message-ID: <554CB01B.5080905@xs4all.nl>
Date: Fri, 08 May 2015 14:46:19 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Michal Simek <michal.simek@xilinx.com>,
	=?windows-1252?Q?S=F6ren_Brink?= =?windows-1252?Q?mann?=
	<soren.brinkmann@xilinx.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sekhar Nori <nsekhar@ti.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 10/18] media controller: use macros to check for V4L2
 subdev entities
References: <cover.1431046915.git.mchehab@osg.samsung.com> <d377ff7f5ac1322606cb9375891e94007ef2cecb.1431046915.git.mchehab@osg.samsung.com>
In-Reply-To: <d377ff7f5ac1322606cb9375891e94007ef2cecb.1431046915.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/08/2015 03:12 AM, Mauro Carvalho Chehab wrote:
> Instead of relying on media subtype, use the new macros to detect
> if an entity is a subdev or an A/V DMA entity.
> 
> Please note that most drivers assume that there's just AV_DMA or
> V4L2 subdevs. This is not true anymore, as we've added MC support
> for DVB, and there are plans to add support for ALSA and FB/DRM
> too.
> 
> Ok, on the current pipelines supported by those drivers, just V4L
> stuff are there, but, assuming that some day a pipeline that also
> works with other subsystems will ever added, it is better to add
> explicit checks for the AV_DMA stuff.

So, a lot of what you try to do really can't be done until we have a
properties API. Oddly enough it is not the DVB part that worries me, that
makes sense to me. But the V4L2 part has problems.

To summarize my concerns here:

The DVB (or DTV) entity types map cleanly to specific device nodes that applications
will use to access the functionality, but AV_DMA is just much too vague. I.e.
does it mean this is a V4L2 device? Or an ALSA device? Something else?

Why have a DTV_DEMOD, DTV_DEMUX, etc. but not a MEDIA_ENT_T_V4L2? Such an
entity type clearly indicates a V4L2 device node, which is what an application
needs to know. Whether this entity has DMA (or streaming) functionality I see
as a property of the entity.

I would prefer to see ENT_T_V4L2 and ENT_T_V4L_SUBDEV since this indicates the
crucial information of how this entity should be controlled, and use properties
to indicate the functions of the entity (and possibly the information required
to locate the device nodes, as we discussed in San Jose).

This is consistent with the DTV entities (since each DTV entity has its own
device node and API).

Each entity may have lots of functions, depending on the hardware behind it,
so properties are ideal for that.

Finally, what to do with e.g. a radio device? Since there is no data flow but it
only controls other entities, perhaps we should just list as properties which other
entities are controlled it (i.e. the tuner).

I don't think we can make this right without using properties. We could get away
with it while it was only V4L2 that used this (although it would have been useful
even there), but this is now getting urgent.

Regards,

	Hans

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/platform/exynos4-is/common.c b/drivers/media/platform/exynos4-is/common.c
> index 0eb34ecb8ee4..1f1b9a56e24e 100644
> --- a/drivers/media/platform/exynos4-is/common.c
> +++ b/drivers/media/platform/exynos4-is/common.c
> @@ -22,8 +22,7 @@ struct v4l2_subdev *fimc_find_remote_sensor(struct media_entity *entity)
>  	while (pad->flags & MEDIA_PAD_FL_SINK) {
>  		/* source pad */
>  		pad = media_entity_remote_pad(pad);
> -		if (pad == NULL ||
> -		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +		if (!is_media_entity_v4l2_subdev(pad->entity))
>  			break;
>  
>  		sd = media_entity_to_v4l2_subdev(pad->entity);
> diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
> index cfebf292e15a..545286813414 100644
> --- a/drivers/media/platform/exynos4-is/fimc-capture.c
> +++ b/drivers/media/platform/exynos4-is/fimc-capture.c
> @@ -1141,8 +1141,7 @@ static int fimc_pipeline_validate(struct fimc_dev *fimc)
>  			}
>  		}
>  
> -		if (src_pad == NULL ||
> -		    media_entity_type(src_pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +		if (!is_media_entity_v4l2_subdev(src_pad->entity))
>  			break;
>  
>  		/* Don't call FIMC subdev operation to avoid nested locking */
> @@ -1397,7 +1396,7 @@ static int fimc_link_setup(struct media_entity *entity,
>  	struct fimc_vid_cap *vc = &fimc->vid_cap;
>  	struct v4l2_subdev *sensor;
>  
> -	if (media_entity_type(remote->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +	if (!is_media_entity_v4l2_subdev(remote->entity))
>  		return -EINVAL;
>  
>  	if (WARN_ON(fimc == NULL))
> diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
> index 76b6b4d14616..014d0bad657d 100644
> --- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
> +++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
> @@ -467,8 +467,7 @@ static int isp_video_pipeline_validate(struct fimc_isp *isp)
>  
>  		/* Retrieve format at the source pad */
>  		pad = media_entity_remote_pad(pad);
> -		if (pad == NULL ||
> -		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +		if (!is_media_entity_v4l2_subdev(pad->entity))
>  			break;
>  
>  		sd = media_entity_to_v4l2_subdev(pad->entity);
> diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
> index ca6261a86a5f..4fb53a28eaaa 100644
> --- a/drivers/media/platform/exynos4-is/fimc-lite.c
> +++ b/drivers/media/platform/exynos4-is/fimc-lite.c
> @@ -814,8 +814,7 @@ static int fimc_pipeline_validate(struct fimc_lite *fimc)
>  		}
>  		/* Retrieve format at the source pad */
>  		pad = media_entity_remote_pad(pad);
> -		if (pad == NULL ||
> -		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +		if (!is_media_entity_v4l2_subdev(pad->entity))
>  			break;
>  
>  		sd = media_entity_to_v4l2_subdev(pad->entity);
> @@ -988,7 +987,6 @@ static int fimc_lite_link_setup(struct media_entity *entity,
>  {
>  	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
>  	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
> -	unsigned int remote_ent_type = media_entity_type(remote->entity);
>  	int ret = 0;
>  
>  	if (WARN_ON(fimc == NULL))
> @@ -1000,7 +998,7 @@ static int fimc_lite_link_setup(struct media_entity *entity,
>  
>  	switch (local->index) {
>  	case FLITE_SD_PAD_SINK:
> -		if (remote_ent_type != MEDIA_ENT_T_V4L2_SUBDEV) {
> +		if (!is_media_entity_v4l2_subdev(remote->entity)) {
>  			ret = -EINVAL;
>  			break;
>  		}
> @@ -1018,7 +1016,7 @@ static int fimc_lite_link_setup(struct media_entity *entity,
>  	case FLITE_SD_PAD_SOURCE_DMA:
>  		if (!(flags & MEDIA_LNK_FL_ENABLED))
>  			atomic_set(&fimc->out_path, FIMC_IO_NONE);
> -		else if (remote_ent_type == MEDIA_ENT_T_DEVNODE)
> +		else if (is_media_av_dma(remote->entity))
>  			atomic_set(&fimc->out_path, FIMC_IO_DMA);
>  		else
>  			ret = -EINVAL;
> @@ -1027,7 +1025,7 @@ static int fimc_lite_link_setup(struct media_entity *entity,
>  	case FLITE_SD_PAD_SOURCE_ISP:
>  		if (!(flags & MEDIA_LNK_FL_ENABLED))
>  			atomic_set(&fimc->out_path, FIMC_IO_NONE);
> -		else if (remote_ent_type == MEDIA_ENT_T_V4L2_SUBDEV)
> +		else if (is_media_entity_v4l2_subdev(remote->entity)))
>  			atomic_set(&fimc->out_path, FIMC_IO_ISP);
>  		else
>  			ret = -EINVAL;
> diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
> index f315ef946cd4..e2eba223a544 100644
> --- a/drivers/media/platform/exynos4-is/media-dev.c
> +++ b/drivers/media/platform/exynos4-is/media-dev.c
> @@ -88,8 +88,7 @@ static void fimc_pipeline_prepare(struct fimc_pipeline *p,
>  				break;
>  		}
>  
> -		if (pad == NULL ||
> -		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +		if (!is_media_entity_v4l2_subdev(pad->entity))
>  			break;
>  		sd = media_entity_to_v4l2_subdev(pad->entity);
>  
> @@ -1062,7 +1061,7 @@ static int __fimc_md_modify_pipelines(struct media_entity *entity, bool enable)
>  	media_entity_graph_walk_start(&graph, entity);
>  
>  	while ((entity = media_entity_graph_walk_next(&graph))) {
> -		if (media_entity_type(entity) != MEDIA_ENT_T_DEVNODE)
> +		if (!is_media_entity_av_dma(entity))
>  			continue;
>  
>  		ret  = __fimc_md_modify_pipeline(entity, enable);
> @@ -1076,7 +1075,7 @@ static int __fimc_md_modify_pipelines(struct media_entity *entity, bool enable)
>  	media_entity_graph_walk_start(&graph, entity_err);
>  
>  	while ((entity_err = media_entity_graph_walk_next(&graph))) {
> -		if (media_entity_type(entity_err) != MEDIA_ENT_T_DEVNODE)
> +		if (!is_media_entity_av_dma(entity_err))
>  			continue;
>  
>  		__fimc_md_modify_pipeline(entity_err, !enable);
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> index 18d0a871747f..a194d575573b 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -693,7 +693,7 @@ static int isp_pipeline_pm_use_count(struct media_entity *entity)
>  	media_entity_graph_walk_start(&graph, entity);
>  
>  	while ((entity = media_entity_graph_walk_next(&graph))) {
> -		if (media_entity_type(entity) == MEDIA_ENT_T_DEVNODE)
> +		if (is_media_entity_av_dma(entity))
>  			use += entity->use_count;
>  	}
>  
> @@ -716,7 +716,7 @@ static int isp_pipeline_pm_power_one(struct media_entity *entity, int change)
>  	struct v4l2_subdev *subdev;
>  	int ret;
>  
> -	subdev = media_entity_type(entity) == MEDIA_ENT_T_V4L2_SUBDEV
> +	subdev = is_media_entity_v4l2_subdev(entity))
>  	       ? media_entity_to_v4l2_subdev(entity) : NULL;
>  
>  	if (entity->use_count == 0 && change > 0 && subdev != NULL) {
> @@ -756,7 +756,7 @@ static int isp_pipeline_pm_power(struct media_entity *entity, int change)
>  	media_entity_graph_walk_start(&graph, entity);
>  
>  	while (!ret && (entity = media_entity_graph_walk_next(&graph)))
> -		if (media_entity_type(entity) != MEDIA_ENT_T_DEVNODE)
> +		if (is_media_entity_v4l2_subdev(entity))
>  			ret = isp_pipeline_pm_power_one(entity, change);
>  
>  	if (!ret)
> @@ -766,7 +766,7 @@ static int isp_pipeline_pm_power(struct media_entity *entity, int change)
>  
>  	while ((first = media_entity_graph_walk_next(&graph))
>  	       && first != entity)
> -		if (media_entity_type(first) != MEDIA_ENT_T_DEVNODE)
> +		if (is_media_entity_v4l2_subdev(first))
>  			isp_pipeline_pm_power_one(first, -change);
>  
>  	return ret;
> @@ -899,8 +899,7 @@ static int isp_pipeline_enable(struct isp_pipeline *pipe,
>  			break;
>  
>  		pad = media_entity_remote_pad(pad);
> -		if (pad == NULL ||
> -		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +		if (!is_media_entity_v4l2_subdev(pad->entity))
>  			break;
>  
>  		entity = pad->entity;
> @@ -989,8 +988,7 @@ static int isp_pipeline_disable(struct isp_pipeline *pipe)
>  			break;
>  
>  		pad = media_entity_remote_pad(pad);
> -		if (pad == NULL ||
> -		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +		if (!is_media_entity_v4l2_subdev(pad->entity))
>  			break;
>  
>  		entity = pad->entity;
> diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
> index d285af18df7f..8ff034c42d9c 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -210,8 +210,7 @@ isp_video_remote_subdev(struct isp_video *video, u32 *pad)
>  
>  	remote = media_entity_remote_pad(&video->pad);
>  
> -	if (remote == NULL ||
> -	    media_entity_type(remote->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +	if (!is_media_entity_v4l2_subdev(remote->entity))
>  		return NULL;
>  
>  	if (pad)
> @@ -243,7 +242,7 @@ static int isp_video_get_graph_data(struct isp_video *video,
>  		if (entity == &video->video.entity)
>  			continue;
>  
> -		if (media_entity_type(entity) != MEDIA_ENT_T_DEVNODE)
> +		if (!is_media_entity_av_dma(entity))
>  			continue;
>  
>  		__video = to_isp_video(media_entity_to_video_device(entity));
> @@ -916,7 +915,7 @@ static int isp_video_check_external_subdevs(struct isp_video *video,
>  		return -EINVAL;
>  	}
>  
> -	if (media_entity_type(source) != MEDIA_ENT_T_V4L2_SUBDEV)
> +	if (!is_media_entity_v4l2_subdev(source->entity))
>  		return 0;
>  
>  	pipe->external = media_entity_to_v4l2_subdev(source);
> diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
> index 76e6289a5612..cc11ab37862e 100644
> --- a/drivers/media/platform/s3c-camif/camif-capture.c
> +++ b/drivers/media/platform/s3c-camif/camif-capture.c
> @@ -837,7 +837,7 @@ static int camif_pipeline_validate(struct camif_dev *camif)
>  
>  	/* Retrieve format at the sensor subdev source pad */
>  	pad = media_entity_remote_pad(&camif->pads[0]);
> -	if (!pad || media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +	if (!is_media_entity_v4l2_subdev(pad->entity))
>  		return -EPIPE;
>  
>  	src_fmt.pad = pad->index;
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
> index d91f19a9e1c1..172eaaaf46c8 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -160,8 +160,7 @@ vsp1_video_remote_subdev(struct media_pad *local, u32 *pad)
>  	struct media_pad *remote;
>  
>  	remote = media_entity_remote_pad(local);
> -	if (remote == NULL ||
> -	    media_entity_type(remote->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +	if (!is_media_entity_v4l2_subdev(remote->entity))
>  		return NULL;
>  
>  	if (pad)
> @@ -326,7 +325,7 @@ static int vsp1_pipeline_validate_branch(struct vsp1_pipeline *pipe,
>  			return -EPIPE;
>  
>  		/* We've reached a video node, that shouldn't have happened. */
> -		if (media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +		if (!is_media_entity_v4l2_subdev(pad->entity))
>  			return -EPIPE;
>  
>  		entity = to_vsp1_entity(media_entity_to_v4l2_subdev(pad->entity));
> @@ -423,7 +422,7 @@ static int vsp1_pipeline_validate(struct vsp1_pipeline *pipe,
>  		struct vsp1_rwpf *rwpf;
>  		struct vsp1_entity *e;
>  
> -		if (media_entity_type(entity) != MEDIA_ENT_T_V4L2_SUBDEV) {
> +		if (is_media_entity_av_dma(entity)) {
>  			pipe->num_video++;
>  			continue;
>  		}
> @@ -680,7 +679,7 @@ void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
>  	pad = media_entity_remote_pad(&input->pads[RWPF_PAD_SOURCE]);
>  
>  	while (pad) {
> -		if (media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +		if (!is_media_entity_v4l2_subdev(pad->entity))
>  			break;
>  
>  		entity = to_vsp1_entity(media_entity_to_v4l2_subdev(pad->entity));
> diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
> index 7fa0cc0f08f0..00a440313cb4 100644
> --- a/drivers/media/platform/xilinx/xilinx-dma.c
> +++ b/drivers/media/platform/xilinx/xilinx-dma.c
> @@ -49,8 +49,7 @@ xvip_dma_remote_subdev(struct media_pad *local, u32 *pad)
>  	struct media_pad *remote;
>  
>  	remote = media_entity_remote_pad(local);
> -	if (remote == NULL ||
> -	    media_entity_type(remote->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +	if (!is_media_entity_v4l2_subdev(remote->entity))
>  		return NULL;
>  
>  	if (pad)
> @@ -113,8 +112,7 @@ static int xvip_pipeline_start_stop(struct xvip_pipeline *pipe, bool start)
>  			break;
>  
>  		pad = media_entity_remote_pad(pad);
> -		if (pad == NULL ||
> -		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +		if (!is_media_entity_v4l2_subdev(pad->entity))
>  			break;
>  
>  		entity = pad->entity;
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index 9f8fc8330b3e..66c6d9fd2033 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -526,7 +526,7 @@ static int
>  v4l2_subdev_link_validate_get_format(struct media_pad *pad,
>  				     struct v4l2_subdev_format *fmt)
>  {
> -	if (media_entity_type(pad->entity) == MEDIA_ENT_T_V4L2_SUBDEV) {
> +	if (is_media_entity_v4l2_subdev(pad->entity)) {
>  		struct v4l2_subdev *sd =
>  			media_entity_to_v4l2_subdev(pad->entity);
>  
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> index 06d48d5eb0a0..429bec44d1a3 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> @@ -151,7 +151,7 @@ static void vpfe_prepare_pipeline(struct vpfe_video_device *video)
>  	while ((entity = media_entity_graph_walk_next(&graph))) {
>  		if (entity == &video->video_dev.entity)
>  			continue;
> -		if (media_entity_type(entity) != MEDIA_ENT_T_DEVNODE)
> +		if ((!is_media_entity_av_dma(remote->entity))
>  			continue;
>  		far_end = to_vpfe_video(media_entity_to_video_device(entity));
>  		if (far_end->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> @@ -296,7 +296,7 @@ static int vpfe_pipeline_enable(struct vpfe_pipeline *pipe)
>  	media_entity_graph_walk_start(&graph, entity);
>  	while ((entity = media_entity_graph_walk_next(&graph))) {
>  
> -		if (media_entity_type(entity) == MEDIA_ENT_T_DEVNODE)
> +		if !is_media_entity_v4l2_subdev(entity))
>  			continue;
>  		subdev = media_entity_to_v4l2_subdev(entity);
>  		ret = v4l2_subdev_call(subdev, video, s_stream, 1);
> @@ -337,7 +337,7 @@ static int vpfe_pipeline_disable(struct vpfe_pipeline *pipe)
>  
>  	while ((entity = media_entity_graph_walk_next(&graph))) {
>  
> -		if (media_entity_type(entity) == MEDIA_ENT_T_DEVNODE)
> +		if (!is_media_entity_v4l2_subdev(entity))
>  			continue;
>  		subdev = media_entity_to_v4l2_subdev(entity);
>  		ret = v4l2_subdev_call(subdev, video, s_stream, 0);
> diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
> index e0ad5e520e2d..a9632facfb66 100644
> --- a/drivers/staging/media/omap4iss/iss.c
> +++ b/drivers/staging/media/omap4iss/iss.c
> @@ -396,7 +396,7 @@ static int iss_pipeline_pm_use_count(struct media_entity *entity)
>  	media_entity_graph_walk_start(&graph, entity);
>  
>  	while ((entity = media_entity_graph_walk_next(&graph))) {
> -		if (media_entity_type(entity) == MEDIA_ENT_T_DEVNODE)
> +		if (is_media_entity_av_dma(entity))
>  			use += entity->use_count;
>  	}
>  
> @@ -418,7 +418,7 @@ static int iss_pipeline_pm_power_one(struct media_entity *entity, int change)
>  {
>  	struct v4l2_subdev *subdev;
>  
> -	subdev = media_entity_type(entity) == MEDIA_ENT_T_V4L2_SUBDEV
> +	subdev = is_media_entity_v4l2_subdev(entity))
>  	       ? media_entity_to_v4l2_subdev(entity) : NULL;
>  
>  	if (entity->use_count == 0 && change > 0 && subdev != NULL) {
> @@ -460,7 +460,7 @@ static int iss_pipeline_pm_power(struct media_entity *entity, int change)
>  	media_entity_graph_walk_start(&graph, entity);
>  
>  	while (!ret && (entity = media_entity_graph_walk_next(&graph)))
> -		if (media_entity_type(entity) != MEDIA_ENT_T_DEVNODE)
> +		if (is_media_entity_v4l2_subdev(entity))
>  			ret = iss_pipeline_pm_power_one(entity, change);
>  
>  	if (!ret)
> @@ -470,7 +470,7 @@ static int iss_pipeline_pm_power(struct media_entity *entity, int change)
>  
>  	while ((first = media_entity_graph_walk_next(&graph))
>  	       && first != entity)
> -		if (media_entity_type(first) != MEDIA_ENT_T_DEVNODE)
> +		if (is_media_entity_v4l2_subdev(first))
>  			iss_pipeline_pm_power_one(first, -change);
>  
>  	return ret;
> @@ -589,8 +589,7 @@ static int iss_pipeline_disable(struct iss_pipeline *pipe,
>  			break;
>  
>  		pad = media_entity_remote_pad(pad);
> -		if (pad == NULL ||
> -		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +		if !is_media_entity_v4l2_subdev(pad->entity))
>  			break;
>  
>  		entity = pad->entity;
> @@ -657,8 +656,7 @@ static int iss_pipeline_enable(struct iss_pipeline *pipe,
>  			break;
>  
>  		pad = media_entity_remote_pad(pad);
> -		if (pad == NULL ||
> -		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +		if (!is_media_entity_v4l2_subdev(pad->entity))
>  			break;
>  
>  		entity = pad->entity;
> diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
> index 85c54fedddda..019fcff7217c 100644
> --- a/drivers/staging/media/omap4iss/iss_video.c
> +++ b/drivers/staging/media/omap4iss/iss_video.c
> @@ -191,8 +191,7 @@ iss_video_remote_subdev(struct iss_video *video, u32 *pad)
>  
>  	remote = media_entity_remote_pad(&video->pad);
>  
> -	if (remote == NULL ||
> -	    media_entity_type(remote->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +	if ((!is_media_entity_v4l2_subdev(remote->entity))
>  		return NULL;
>  
>  	if (pad)
> @@ -217,7 +216,7 @@ iss_video_far_end(struct iss_video *video)
>  		if (entity == &video->video.entity)
>  			continue;
>  
> -		if (media_entity_type(entity) != MEDIA_ENT_T_DEVNODE)
> +		if (!is_media_entity_av_dma(entity))
>  			continue;
>  
>  		far_end = to_iss_video(media_entity_to_video_device(entity));
> 

