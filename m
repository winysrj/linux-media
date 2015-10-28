Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53407 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932420AbbJ1Baf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2015 21:30:35 -0400
Date: Wed, 28 Oct 2015 10:30:30 +0900
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	javier@osg.samsung.com, hverkuil@xs4all.nl,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH 14/19] v4l: omap3isp: Use media entity enumeration API
Message-ID: <20151028103030.0d4adaab@concha.lan>
In-Reply-To: <1445900510-1398-15-git-send-email-sakari.ailus@iki.fi>
References: <1445900510-1398-1-git-send-email-sakari.ailus@iki.fi>
	<1445900510-1398-15-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 27 Oct 2015 01:01:45 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> From: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/platform/omap3isp/isp.c      | 21 +++++++++++++--------
>  drivers/media/platform/omap3isp/isp.h      |  5 +++--
>  drivers/media/platform/omap3isp/ispccdc.c  |  2 +-
>  drivers/media/platform/omap3isp/ispvideo.c | 20 ++++++++++++++------
>  drivers/media/platform/omap3isp/ispvideo.h |  4 ++--
>  5 files changed, 33 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> index 4a01a36..61c128e 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -896,7 +896,7 @@ static int isp_pipeline_enable(struct isp_pipeline *pipe,
>  	 * starting entities if the pipeline won't start anyway (those entities
>  	 * would then likely fail to stop, making the problem worse).
>  	 */
> -	if (pipe->entities & isp->crashed)
> +	if (media_entity_enum_intersects(&pipe->entities, &isp->crashed))
>  		return -EIO;

If the size of entities/crashed enums is different, it should be
returning an error, I guess, as this would be a driver's problem, and the
graph traversal on OMAP3 would likely be wrong.

>  
>  	spin_lock_irqsave(&pipe->lock, flags);
> @@ -989,7 +989,6 @@ static int isp_pipeline_disable(struct isp_pipeline *pipe)
>  	struct v4l2_subdev *subdev;
>  	int failure = 0;
>  	int ret;
> -	u32 id;
>  
>  	/*
>  	 * We need to stop all the modules after CCDC first or they'll
> @@ -1041,10 +1040,9 @@ static int isp_pipeline_disable(struct isp_pipeline *pipe)
>  		if (ret) {
>  			dev_info(isp->dev, "Unable to stop %s\n", subdev->name);
>  			isp->stop_failure = true;
> -			if (subdev == &isp->isp_prev.subdev) {
> -				id = media_entity_id(&subdev->entity);
> -				isp->crashed |= 1U << id;
> -			}
> +			if (subdev == &isp->isp_prev.subdev)
> +				media_entity_enum_set(&isp->crashed,
> +						      &subdev->entity);
>  			failure = -ETIMEDOUT;
>  		}
>  	}
> @@ -1250,7 +1248,7 @@ static int isp_reset(struct isp_device *isp)
>  	}
>  
>  	isp->stop_failure = false;
> -	isp->crashed = 0;
> +	media_entity_enum_zero(&isp->crashed);
>  	return 0;
>  }
>  
> @@ -1661,7 +1659,8 @@ static void __omap3isp_put(struct isp_device *isp, bool save_ctx)
>  		/* Reset the ISP if an entity has failed to stop. This is the
>  		 * only way to recover from such conditions.
>  		 */
> -		if (isp->crashed || isp->stop_failure)
> +		if (!media_entity_enum_empty(&isp->crashed) ||
> +		    isp->stop_failure)
>  			isp_reset(isp);
>  		isp_disable_clocks(isp);
>  	}
> @@ -2201,6 +2200,8 @@ static int isp_remove(struct platform_device *pdev)
>  	isp_detach_iommu(isp);
>  	__omap3isp_put(isp, false);
>  
> +	media_entity_enum_cleanup(&isp->crashed);
> +
>  	return 0;
>  }
>  
> @@ -2348,6 +2349,10 @@ static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
>  	struct isp_bus_cfg *bus;
>  	int ret;
>  
> +	ret = media_entity_enum_init(&isp->crashed, &isp->media_dev);
> +	if (ret)
> +		return ret;
> +
>  	list_for_each_entry(sd, &v4l2_dev->subdevs, list) {
>  		/* Only try to link entities whose interface was set on bound */
>  		if (sd->host_priv) {
> diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
> index b6f81f2..6a1288d 100644
> --- a/drivers/media/platform/omap3isp/isp.h
> +++ b/drivers/media/platform/omap3isp/isp.h
> @@ -17,6 +17,7 @@
>  #ifndef OMAP3_ISP_CORE_H
>  #define OMAP3_ISP_CORE_H
>  
> +#include <media/media-entity.h>
>  #include <media/v4l2-async.h>
>  #include <media/v4l2-device.h>
>  #include <linux/clk-provider.h>
> @@ -152,7 +153,7 @@ struct isp_xclk {
>   * @stat_lock: Spinlock for handling statistics
>   * @isp_mutex: Mutex for serializing requests to ISP.
>   * @stop_failure: Indicates that an entity failed to stop.
> - * @crashed: Bitmask of crashed entities (indexed by entity ID)
> + * @crashed: Crashed entities
>   * @has_context: Context has been saved at least once and can be restored.
>   * @ref_count: Reference count for handling multiple ISP requests.
>   * @cam_ick: Pointer to camera interface clock structure.
> @@ -195,7 +196,7 @@ struct isp_device {
>  	spinlock_t stat_lock;	/* common lock for statistic drivers */
>  	struct mutex isp_mutex;	/* For handling ref_count field */
>  	bool stop_failure;
> -	u32 crashed;
> +	struct media_entity_enum crashed;
>  	int has_context;
>  	int ref_count;
>  	unsigned int autoidle;
> diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
> index f0e530c..80cf550 100644
> --- a/drivers/media/platform/omap3isp/ispccdc.c
> +++ b/drivers/media/platform/omap3isp/ispccdc.c
> @@ -1608,7 +1608,7 @@ static int ccdc_isr_buffer(struct isp_ccdc_device *ccdc)
>  	/* Wait for the CCDC to become idle. */
>  	if (ccdc_sbl_wait_idle(ccdc, 1000)) {
>  		dev_info(isp->dev, "CCDC won't become idle!\n");
> -		isp->crashed |= 1U << media_entity_id(&ccdc->subdev.entity);
> +		media_entity_enum_set(&isp->crashed, &ccdc->subdev.entity);
>  		omap3isp_pipeline_cancel_stream(pipe);
>  		return 0;
>  	}
> diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
> index e68ec2f..579332b 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -241,7 +241,7 @@ static int isp_video_get_graph_data(struct isp_video *video,
>  	while ((entity = media_entity_graph_walk_next(&graph))) {
>  		struct isp_video *__video;
>  
> -		pipe->entities |= 1 << media_entity_id(entity);
> +		media_entity_enum_set(&pipe->entities, entity);
>  
>  		if (far_end != NULL)
>  			continue;
> @@ -899,7 +899,6 @@ static int isp_video_check_external_subdevs(struct isp_video *video,
>  	struct v4l2_ext_control ctrl;
>  	unsigned int i;
>  	int ret;
> -	u32 id;
>  
>  	/* Memory-to-memory pipelines have no external subdev. */
>  	if (pipe->input != NULL)
> @@ -907,7 +906,7 @@ static int isp_video_check_external_subdevs(struct isp_video *video,
>  
>  	for (i = 0; i < ARRAY_SIZE(ents); i++) {
>  		/* Is the entity part of the pipeline? */
> -		if (!(pipe->entities & (1 << media_entity_id(ents[i]))))
> +		if (!media_entity_enum_test(&pipe->entities, ents[i]))
>  			continue;
>  
>  		/* ISP entities have always sink pad == 0. Find source. */
> @@ -959,8 +958,8 @@ static int isp_video_check_external_subdevs(struct isp_video *video,
>  
>  	pipe->external_rate = ctrl.value64;
>  
> -	id = media_entity_id(&isp->isp_ccdc.subdev.entity);
> -	if (pipe->entities & (1 << id)) {
> +	if (media_entity_enum_test(&pipe->entities,
> +				   &isp->isp_ccdc.subdev.entity)) {
>  		unsigned int rate = UINT_MAX;
>  		/*
>  		 * Check that maximum allowed CCDC pixel rate isn't
> @@ -1026,7 +1025,9 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
>  	pipe = video->video.entity.pipe
>  	     ? to_isp_pipeline(&video->video.entity) : &video->pipe;
>  
> -	pipe->entities = 0;
> +	ret = media_entity_enum_init(&pipe->entities, &video->isp->media_dev);
> +	if (ret)
> +		goto err_enum_init;
>  
>  	/* TODO: Implement PM QoS */
>  	pipe->l3_ick = clk_get_rate(video->isp->clock[ISP_CLK_L3_ICK]);
> @@ -1100,6 +1101,9 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
>  	}
>  
>  	mutex_unlock(&video->stream_lock);
> +
> +	media_entity_enum_cleanup(&pipe->entities);
> +
>  	return 0;
>  
>  err_set_stream:
> @@ -1120,7 +1124,11 @@ err_pipeline_start:
>  	INIT_LIST_HEAD(&video->dmaqueue);
>  	video->queue = NULL;
>  
> +	media_entity_enum_cleanup(&pipe->entities);
> +
> +err_enum_init:
>  	mutex_unlock(&video->stream_lock);
> +
>  	return ret;
>  }
>  
> diff --git a/drivers/media/platform/omap3isp/ispvideo.h b/drivers/media/platform/omap3isp/ispvideo.h
> index 6c498ea..9f08492 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.h
> +++ b/drivers/media/platform/omap3isp/ispvideo.h
> @@ -80,7 +80,7 @@ enum isp_pipeline_state {
>   * struct isp_pipeline - An ISP hardware pipeline
>   * @field: The field being processed by the pipeline
>   * @error: A hardware error occurred during capture
> - * @entities: Bitmask of entities in the pipeline (indexed by entity ID)
> + * @entities: Entities in the pipeline
>   */
>  struct isp_pipeline {
>  	struct media_pipeline pipe;
> @@ -89,7 +89,7 @@ struct isp_pipeline {
>  	enum isp_pipeline_stream_state stream_state;
>  	struct isp_video *input;
>  	struct isp_video *output;
> -	u32 entities;
> +	struct media_entity_enum entities;
>  	unsigned long l3_ick;
>  	unsigned int max_rate;
>  	enum v4l2_field field;


-- 

Cheers,
Mauro
