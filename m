Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:50712 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754892AbbHYGgE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 02:36:04 -0400
Message-ID: <55DC0CA5.8040504@xs4all.nl>
Date: Tue, 25 Aug 2015 08:35:17 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v7 03/44] [media] omap3isp: get entity ID using media_entity_id()
References: <cover.1440359643.git.mchehab@osg.samsung.com> <0c7d9114cb585da8f24c6ac9861bed9cd7f5a794.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <0c7d9114cb585da8f24c6ac9861bed9cd7f5a794.1440359643.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/23/2015 10:17 PM, Mauro Carvalho Chehab wrote:
> From: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> X-Patchwork-Delegate: laurent.pinchart@ideasonboard.com
> The struct media_entity does not have an .id field anymore since
> now the entity ID is stored in the embedded struct media_gobj.
> 
> This caused the omap3isp driver fail to build. Fix by using the
> media_entity_id() macro to obtain the entity ID.

Same issue with the commit log as in the previous patch.

After fixing you can add my:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> index 56e683b19a73..e08183f9d0f7 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -975,6 +975,7 @@ static int isp_pipeline_disable(struct isp_pipeline *pipe)
>  	struct v4l2_subdev *subdev;
>  	int failure = 0;
>  	int ret;
> +	u32 id;
>  
>  	/*
>  	 * We need to stop all the modules after CCDC first or they'll
> @@ -1027,8 +1028,10 @@ static int isp_pipeline_disable(struct isp_pipeline *pipe)
>  		if (ret) {
>  			dev_info(isp->dev, "Unable to stop %s\n", subdev->name);
>  			isp->stop_failure = true;
> -			if (subdev == &isp->isp_prev.subdev)
> -				isp->crashed |= 1U << subdev->entity.id;
> +			if (subdev == &isp->isp_prev.subdev) {
> +				id = media_entity_id(&subdev->entity);
> +				isp->crashed |= 1U << id;
> +			}
>  			failure = -ETIMEDOUT;
>  		}
>  	}
> diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
> index 3b10304b580b..d96e3be5e252 100644
> --- a/drivers/media/platform/omap3isp/ispccdc.c
> +++ b/drivers/media/platform/omap3isp/ispccdc.c
> @@ -1608,7 +1608,7 @@ static int ccdc_isr_buffer(struct isp_ccdc_device *ccdc)
>  	/* Wait for the CCDC to become idle. */
>  	if (ccdc_sbl_wait_idle(ccdc, 1000)) {
>  		dev_info(isp->dev, "CCDC won't become idle!\n");
> -		isp->crashed |= 1U << ccdc->subdev.entity.id;
> +		isp->crashed |= 1U << media_entity_id(&ccdc->subdev.entity);
>  		omap3isp_pipeline_cancel_stream(pipe);
>  		return 0;
>  	}
> diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
> index 3094572f8897..6c89dc40df85 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -235,7 +235,7 @@ static int isp_video_get_graph_data(struct isp_video *video,
>  	while ((entity = media_entity_graph_walk_next(&graph))) {
>  		struct isp_video *__video;
>  
> -		pipe->entities |= 1 << entity->id;
> +		pipe->entities |= 1 << media_entity_id(entity);
>  
>  		if (far_end != NULL)
>  			continue;
> @@ -891,6 +891,7 @@ static int isp_video_check_external_subdevs(struct isp_video *video,
>  	struct v4l2_ext_control ctrl;
>  	unsigned int i;
>  	int ret;
> +	u32 id;
>  
>  	/* Memory-to-memory pipelines have no external subdev. */
>  	if (pipe->input != NULL)
> @@ -898,7 +899,7 @@ static int isp_video_check_external_subdevs(struct isp_video *video,
>  
>  	for (i = 0; i < ARRAY_SIZE(ents); i++) {
>  		/* Is the entity part of the pipeline? */
> -		if (!(pipe->entities & (1 << ents[i]->id)))
> +		if (!(pipe->entities & (1 << media_entity_id(ents[i]))))
>  			continue;
>  
>  		/* ISP entities have always sink pad == 0. Find source. */
> @@ -950,7 +951,8 @@ static int isp_video_check_external_subdevs(struct isp_video *video,
>  
>  	pipe->external_rate = ctrl.value64;
>  
> -	if (pipe->entities & (1 << isp->isp_ccdc.subdev.entity.id)) {
> +	id = media_entity_id(&isp->isp_ccdc.subdev.entity);
> +	if (pipe->entities & (1 << id)) {
>  		unsigned int rate = UINT_MAX;
>  		/*
>  		 * Check that maximum allowed CCDC pixel rate isn't
> 

