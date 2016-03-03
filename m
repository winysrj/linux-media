Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:56130 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752046AbcCCNdN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 08:33:13 -0500
Subject: Re: [PATCH 4/8] media: Rename is_media_entity_v4l2_io to
 is_media_entity_v4l2_video_device
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org
References: <1456844246-18778-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1456844246-18778-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56D83D1F.6020309@xs4all.nl>
Date: Thu, 3 Mar 2016 14:33:19 +0100
MIME-Version: 1.0
In-Reply-To: <1456844246-18778-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/01/16 15:57, Laurent Pinchart wrote:
> All users of is_media_entity_v4l2_io() (the exynos4-is, omap3isp,
> davince_vpfe and omap4iss drivers) use the function to check whether
> entities are video_device instances, either to ensure they can cast the
> entity to a struct video_device, or to count the number of video nodes
> users.
> 
> The purpose of the function is thus to identify whether the media entity
> instance is an instance of the video_device object, not to check whether
> it can perform I/O. Rename it accordingly, we will introduce a more
> specific is_media_entity_v4l2_io() check when needed.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks for the much clearer commit text, that makes it much more understandable
what is going on here.

	Hans

> ---
>  drivers/media/platform/exynos4-is/media-dev.c   | 4 ++--
>  drivers/media/platform/omap3isp/isp.c           | 2 +-
>  drivers/media/platform/omap3isp/ispvideo.c      | 2 +-
>  drivers/staging/media/davinci_vpfe/vpfe_video.c | 2 +-
>  drivers/staging/media/omap4iss/iss.c            | 2 +-
>  drivers/staging/media/omap4iss/iss_video.c      | 2 +-
>  include/media/media-entity.h                    | 4 ++--
>  7 files changed, 9 insertions(+), 9 deletions(-)
> 
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
> 
> diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
> index feb521f28e14..9a377d9dd58a 100644
> --- a/drivers/media/platform/exynos4-is/media-dev.c
> +++ b/drivers/media/platform/exynos4-is/media-dev.c
> @@ -1130,7 +1130,7 @@ static int __fimc_md_modify_pipelines(struct media_entity *entity, bool enable,
>  	media_entity_graph_walk_start(graph, entity);
>  
>  	while ((entity = media_entity_graph_walk_next(graph))) {
> -		if (!is_media_entity_v4l2_io(entity))
> +		if (!is_media_entity_v4l2_video_device(entity))
>  			continue;
>  
>  		ret  = __fimc_md_modify_pipeline(entity, enable);
> @@ -1145,7 +1145,7 @@ err:
>  	media_entity_graph_walk_start(graph, entity_err);
>  
>  	while ((entity_err = media_entity_graph_walk_next(graph))) {
> -		if (!is_media_entity_v4l2_io(entity_err))
> +		if (!is_media_entity_v4l2_video_device(entity_err))
>  			continue;
>  
>  		__fimc_md_modify_pipeline(entity_err, !enable);
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> index f9e5245f26ac..12f07e409f0b 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -691,7 +691,7 @@ static int isp_pipeline_pm_use_count(struct media_entity *entity,
>  	media_entity_graph_walk_start(graph, entity);
>  
>  	while ((entity = media_entity_graph_walk_next(graph))) {
> -		if (is_media_entity_v4l2_io(entity))
> +		if (is_media_entity_v4l2_video_device(entity))
>  			use += entity->use_count;
>  	}
>  
> diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
> index 2aff755ff77c..c4734a5b8886 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -249,7 +249,7 @@ static int isp_video_get_graph_data(struct isp_video *video,
>  		if (entity == &video->video.entity)
>  			continue;
>  
> -		if (!is_media_entity_v4l2_io(entity))
> +		if (!is_media_entity_v4l2_video_device(entity))
>  			continue;
>  
>  		__video = to_isp_video(media_entity_to_video_device(entity));
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> index db49af90217e..7d8fa34f31f3 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> @@ -154,7 +154,7 @@ static int vpfe_prepare_pipeline(struct vpfe_video_device *video)
>  	while ((entity = media_entity_graph_walk_next(&graph))) {
>  		if (entity == &video->video_dev.entity)
>  			continue;
> -		if (!is_media_entity_v4l2_io(entity))
> +		if (!is_media_entity_v4l2_video_device(entity))
>  			continue;
>  		far_end = to_vpfe_video(media_entity_to_video_device(entity));
>  		if (far_end->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
> index 30b473cfb020..d41231521775 100644
> --- a/drivers/staging/media/omap4iss/iss.c
> +++ b/drivers/staging/media/omap4iss/iss.c
> @@ -397,7 +397,7 @@ static int iss_pipeline_pm_use_count(struct media_entity *entity,
>  	media_entity_graph_walk_start(graph, entity);
>  
>  	while ((entity = media_entity_graph_walk_next(graph))) {
> -		if (is_media_entity_v4l2_io(entity))
> +		if (is_media_entity_v4l2_video_device(entity))
>  			use += entity->use_count;
>  	}
>  
> diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
> index 058233a9de67..002d81d4ee45 100644
> --- a/drivers/staging/media/omap4iss/iss_video.c
> +++ b/drivers/staging/media/omap4iss/iss_video.c
> @@ -221,7 +221,7 @@ iss_video_far_end(struct iss_video *video)
>  		if (entity == &video->video.entity)
>  			continue;
>  
> -		if (!is_media_entity_v4l2_io(entity))
> +		if (!is_media_entity_v4l2_video_device(entity))
>  			continue;
>  
>  		far_end = to_iss_video(media_entity_to_video_device(entity));
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index cbd37530f6b8..e5108f052fe2 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -356,14 +356,14 @@ static inline u32 media_gobj_gen_id(enum media_gobj_type type, u64 local_id)
>  }
>  
>  /**
> - * is_media_entity_v4l2_io() - Check if the entity is a video_device
> + * is_media_entity_v4l2_video_device() - Check if the entity is a video_device
>   * @entity:	pointer to entity
>   *
>   * Return: true if the entity is an instance of a video_device object and can
>   * safely be cast to a struct video_device using the container_of() macro, or
>   * false otherwise.
>   */
> -static inline bool is_media_entity_v4l2_io(struct media_entity *entity)
> +static inline bool is_media_entity_v4l2_video_device(struct media_entity *entity)
>  {
>  	return entity && entity->type == MEDIA_ENTITY_TYPE_VIDEO_DEVICE;
>  }
> 
