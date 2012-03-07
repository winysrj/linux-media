Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58965 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab2CGKen (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2012 05:34:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: Re: [PATCH v5 25/35] omap3isp: Collect entities that are part of the pipeline
Date: Wed, 07 Mar 2012 11:35:02 +0100
Message-ID: <3330510.TBBu7RATHi@avalon>
In-Reply-To: <1331051596-8261-25-git-send-email-sakari.ailus@iki.fi>
References: <20120306163239.GN1075@valkosipuli.localdomain> <1331051596-8261-25-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Tuesday 06 March 2012 18:33:06 Sakari Ailus wrote:
> Collect entities which are part of the pipeline into a single bit mask.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/video/omap3isp/ispvideo.c |    9 +++++++++
>  drivers/media/video/omap3isp/ispvideo.h |    1 +
>  2 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/ispvideo.c
> b/drivers/media/video/omap3isp/ispvideo.c index d34f690..4bc9cca 100644
> --- a/drivers/media/video/omap3isp/ispvideo.c
> +++ b/drivers/media/video/omap3isp/ispvideo.c
> @@ -970,6 +970,8 @@ isp_video_streamon(struct file *file, void *fh, enum
> v4l2_buf_type type) {
>  	struct isp_video_fh *vfh = to_isp_video_fh(fh);
>  	struct isp_video *video = video_drvdata(file);
> +	struct media_entity_graph graph;
> +	struct media_entity *entity;
>  	enum isp_pipeline_state state;
>  	struct isp_pipeline *pipe;
>  	struct isp_video *far_end;
> @@ -992,6 +994,8 @@ isp_video_streamon(struct file *file, void *fh, enum
> v4l2_buf_type type) pipe = video->video.entity.pipe
>  	     ? to_isp_pipeline(&video->video.entity) : &video->pipe;
> 
> +	pipe->entities = 0;
> +

This could be move right before the graph walk code below to keep both parts 
together. However, pipe->entities would then be invalid (instead of always 0) 
in the link validation operations. That can be considered as an issue, so I'm 
fine if you prefer leaving this assignment here.

>  	if (video->isp->pdata->set_constraints)
>  		video->isp->pdata->set_constraints(video->isp, true);
>  	pipe->l3_ick = clk_get_rate(video->isp->clock[ISP_CLK_L3_ICK]);
> @@ -1001,6 +1005,11 @@ isp_video_streamon(struct file *file, void *fh, enum
> v4l2_buf_type type) if (ret < 0)
>  		goto err_pipeline_start;
> 
> +	entity = &video->video.entity;
> +	media_entity_graph_walk_start(&graph, entity);
> +	while ((entity = media_entity_graph_walk_next(&graph)))
> +		pipe->entities |= 1 << entity->id;
> +

To avoid walking the graph one more time, what about moving this to 
isp_video_far_end() where we already walk the graph (and moving the 
isp_video_far_end() call earlier in this function) ? You could possible rename 
isp_video_far_end() to something a bit more in line with its new purpose then.

>  	/* Verify that the currently configured format matches the output of
>  	 * the connected subdev.
>  	 */
> diff --git a/drivers/media/video/omap3isp/ispvideo.h
> b/drivers/media/video/omap3isp/ispvideo.h index d91bdb91..0423c9d 100644
> --- a/drivers/media/video/omap3isp/ispvideo.h
> +++ b/drivers/media/video/omap3isp/ispvideo.h
> @@ -96,6 +96,7 @@ struct isp_pipeline {
>  	enum isp_pipeline_stream_state stream_state;
>  	struct isp_video *input;
>  	struct isp_video *output;
> +	u32 entities;
>  	unsigned long l3_ick;
>  	unsigned int max_rate;
>  	atomic_t frame_number;

-- 
Regards,

Laurent Pinchart

