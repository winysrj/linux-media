Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55168 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758179Ab2CGXuT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2012 18:50:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: Re: [PATCH v5.1 25/35] omap3isp: Collect entities that are part of the pipeline
Date: Thu, 08 Mar 2012 00:50:38 +0100
Message-ID: <1912567.UNqMTnFDpO@avalon>
In-Reply-To: <1331140976-5087-1-git-send-email-sakari.ailus@iki.fi>
References: <20120307172051.GC1476@valkosipuli.localdomain> <1331140976-5087-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Wednesday 07 March 2012 19:22:56 Sakari Ailus wrote:
> Collect entities which are part of the pipeline into a single bit mask.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/video/omap3isp/ispvideo.c |   48
> ++++++++++++++++--------------- drivers/media/video/omap3isp/ispvideo.h |  
>  2 +
>  2 files changed, 27 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/ispvideo.c
> b/drivers/media/video/omap3isp/ispvideo.c index d34f690..7411076 100644
> --- a/drivers/media/video/omap3isp/ispvideo.c
> +++ b/drivers/media/video/omap3isp/ispvideo.c
> @@ -255,8 +255,9 @@ isp_video_remote_subdev(struct isp_video *video, u32
> *pad) }
> 
>  /* Return a pointer to the ISP video instance at the far end of the
> pipeline. */ -static struct isp_video *
> -isp_video_far_end(struct isp_video *video)
> +static int isp_video_get_graph_data(struct isp_video *video,
> +				    struct isp_pipeline *pipe,
> +				    enum isp_pipeline_state *state)
>  {
>  	struct media_entity_graph graph;
>  	struct media_entity *entity = &video->video.entity;
> @@ -267,6 +268,8 @@ isp_video_far_end(struct isp_video *video)
>  	media_entity_graph_walk_start(&graph, entity);
> 
>  	while ((entity = media_entity_graph_walk_next(&graph))) {
> +		pipe->entities |= 1 << entity->id;
> +
>  		if (entity == &video->video.entity)
>  			continue;
> 

The loop will stop as soon as it find a video node at the other end of the 
pipeline. As media_entity_graph_walk_next() doesn't guarantee any graph search 
order, you should avoid stopping the loop before having walked all entities, 
otherwise you could miss some.

Something like

        while ((entity = media_entity_graph_walk_next(&graph))) {
                struct isp_video *node;

                pipe->entities |= 1 << entity->id;

                if (entity == &video->video.entity)
                        continue;

                if (media_entity_type(entity) != MEDIA_ENT_T_DEVNODE)
                        continue;

                node = to_isp_video(media_entity_to_video_device(entity));
                if (node->type != video->type)
                        far_end = node;
        }

should do (feel free to rename node to something else, I have little 
imagination so late at night).

> @@ -281,7 +284,21 @@ isp_video_far_end(struct isp_video *video)
>  	}
> 
>  	mutex_unlock(&mdev->graph_mutex);
> -	return far_end;
> +
> +	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +		*state = ISP_PIPELINE_STREAM_OUTPUT | ISP_PIPELINE_IDLE_OUTPUT;
> +		pipe->input = far_end;
> +		pipe->output = video;
> +	} else {
> +		if (far_end == NULL)
> +			return -EPIPE;
> +
> +		*state = ISP_PIPELINE_STREAM_INPUT | ISP_PIPELINE_IDLE_INPUT;
> +		pipe->input = video;
> +		pipe->output = far_end;
> +	}
> +
> +	return 0;
>  }
> 
>  /*
> @@ -972,7 +989,6 @@ isp_video_streamon(struct file *file, void *fh, enum
> v4l2_buf_type type) struct isp_video *video = video_drvdata(file);
>  	enum isp_pipeline_state state;
>  	struct isp_pipeline *pipe;
> -	struct isp_video *far_end;
>  	unsigned long flags;
>  	int ret;
> 
> @@ -992,6 +1008,8 @@ isp_video_streamon(struct file *file, void *fh, enum
> v4l2_buf_type type) pipe = video->video.entity.pipe
>  	     ? to_isp_pipeline(&video->video.entity) : &video->pipe;
> 
> +	pipe->entities = 0;
> +
>  	if (video->isp->pdata->set_constraints)
>  		video->isp->pdata->set_constraints(video->isp, true);
>  	pipe->l3_ick = clk_get_rate(video->isp->clock[ISP_CLK_L3_ICK]);
> @@ -1011,25 +1029,9 @@ isp_video_streamon(struct file *file, void *fh, enum
> v4l2_buf_type type) video->bpl_padding = ret;
>  	video->bpl_value = vfh->format.fmt.pix.bytesperline;
> 
> -	/* Find the ISP video node connected at the far end of the pipeline and
> -	 * update the pipeline.
> -	 */
> -	far_end = isp_video_far_end(video);
> -
> -	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> -		state = ISP_PIPELINE_STREAM_OUTPUT | ISP_PIPELINE_IDLE_OUTPUT;
> -		pipe->input = far_end;
> -		pipe->output = video;
> -	} else {
> -		if (far_end == NULL) {
> -			ret = -EPIPE;
> -			goto err_check_format;
> -		}
> -
> -		state = ISP_PIPELINE_STREAM_INPUT | ISP_PIPELINE_IDLE_INPUT;
> -		pipe->input = video;
> -		pipe->output = far_end;
> -	}
> +	ret = isp_video_get_graph_data(video, pipe, &state);
> +	if (ret < 0)
> +		goto err_check_format;
> 
>  	/* Validate the pipeline and update its state. */
>  	ret = isp_video_validate_pipeline(pipe);
> diff --git a/drivers/media/video/omap3isp/ispvideo.h
> b/drivers/media/video/omap3isp/ispvideo.h index d91bdb91..c9187cb 100644
> --- a/drivers/media/video/omap3isp/ispvideo.h
> +++ b/drivers/media/video/omap3isp/ispvideo.h
> @@ -88,6 +88,7 @@ enum isp_pipeline_state {
>  /*
>   * struct isp_pipeline - An ISP hardware pipeline
>   * @error: A hardware error occurred during capture
> + * @entities: Bitmask of entities in the pipeline (indexed by entity ID)
>   */
>  struct isp_pipeline {
>  	struct media_pipeline pipe;
> @@ -96,6 +97,7 @@ struct isp_pipeline {
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

