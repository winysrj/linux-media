Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46521 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729Ab2CEL0Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2012 06:26:25 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com
Subject: Re: [PATCH v4 24/34] omap3isp: Assume media_entity_pipeline_start may fail
Date: Mon, 05 Mar 2012 12:26:44 +0100
Message-ID: <9441857.LdE2qk9Hk2@avalon>
In-Reply-To: <1330709442-16654-24-git-send-email-sakari.ailus@iki.fi>
References: <20120302173219.GA15695@valkosipuli.localdomain> <1330709442-16654-24-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Friday 02 March 2012 19:30:32 Sakari Ailus wrote:
> Since media_entity_pipeline_start() now does link validation, it may
> actually fail. Perform the error handling.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>
> ---
>  drivers/media/video/omap3isp/ispvideo.c |   53
> +++++++++++++++++-------------- 1 files changed, 29 insertions(+), 24
> deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/ispvideo.c
> b/drivers/media/video/omap3isp/ispvideo.c index b0d541b..f2621bc 100644
> --- a/drivers/media/video/omap3isp/ispvideo.c
> +++ b/drivers/media/video/omap3isp/ispvideo.c
> @@ -997,14 +997,16 @@ isp_video_streamon(struct file *file, void *fh, enum
> v4l2_buf_type type) pipe->l3_ick =
> clk_get_rate(video->isp->clock[ISP_CLK_L3_ICK]);
>  	pipe->max_rate = pipe->l3_ick;
> 
> -	media_entity_pipeline_start(&video->video.entity, &pipe->pipe);
> +	ret = media_entity_pipeline_start(&video->video.entity, &pipe->pipe);
> +	if (ret < 0)
> +		goto err_media_entity_pipeline_start;
> 
>  	/* Verify that the currently configured format matches the output of
>  	 * the connected subdev.
>  	 */
>  	ret = isp_video_check_format(video, vfh);
>  	if (ret < 0)
> -		goto error;
> +		goto err_isp_video_check_format;
> 
>  	video->bpl_padding = ret;
>  	video->bpl_value = vfh->format.fmt.pix.bytesperline;
> @@ -1021,7 +1023,7 @@ isp_video_streamon(struct file *file, void *fh, enum
> v4l2_buf_type type) } else {
>  		if (far_end == NULL) {
>  			ret = -EPIPE;
> -			goto error;
> +			goto err_isp_video_check_format;
>  		}
> 
>  		state = ISP_PIPELINE_STREAM_INPUT | ISP_PIPELINE_IDLE_INPUT;
> @@ -1032,7 +1034,7 @@ isp_video_streamon(struct file *file, void *fh, enum
> v4l2_buf_type type) /* Validate the pipeline and update its state. */
>  	ret = isp_video_validate_pipeline(pipe);
>  	if (ret < 0)
> -		goto error;
> +		goto err_isp_video_check_format;
> 
>  	pipe->error = false;
> 
> @@ -1054,7 +1056,7 @@ isp_video_streamon(struct file *file, void *fh, enum
> v4l2_buf_type type)
> 
>  	ret = omap3isp_video_queue_streamon(&vfh->queue);
>  	if (ret < 0)
> -		goto error;
> +		goto err_isp_video_check_format;
> 
>  	/* In sensor-to-memory mode, the stream can be started synchronously
>  	 * to the stream on command. In memory-to-memory mode, it will be
> @@ -1064,32 +1066,35 @@ isp_video_streamon(struct file *file, void *fh, enum
> v4l2_buf_type type) ret = omap3isp_pipeline_set_stream(pipe,
>  					      ISP_PIPELINE_STREAM_CONTINUOUS);
>  		if (ret < 0)
> -			goto error;
> +			goto err_omap3isp_set_stream;
>  		spin_lock_irqsave(&video->queue->irqlock, flags);
>  		if (list_empty(&video->dmaqueue))
>  			video->dmaqueue_flags |= ISP_VIDEO_DMAQUEUE_UNDERRUN;
>  		spin_unlock_irqrestore(&video->queue->irqlock, flags);
>  	}
> 
> -error:
> -	if (ret < 0) {
> -		omap3isp_video_queue_streamoff(&vfh->queue);
> -		media_entity_pipeline_stop(&video->video.entity);
> -		if (video->isp->pdata->set_constraints)
> -			video->isp->pdata->set_constraints(video->isp, false);
> -		/* The DMA queue must be emptied here, otherwise CCDC interrupts
> -		 * that will get triggered the next time the CCDC is powered up
> -		 * will try to access buffers that might have been freed but
> -		 * still present in the DMA queue. This can easily get triggered
> -		 * if the above omap3isp_pipeline_set_stream() call fails on a
> -		 * system with a free-running sensor.
> -		 */
> -		INIT_LIST_HEAD(&video->dmaqueue);
> -		video->queue = NULL;
> -	}
> +	video->streaming = 1;
> +
> +	mutex_unlock(&video->stream_lock);
> +	return 0;
> 
> -	if (!ret)
> -		video->streaming = 1;
> +err_omap3isp_set_stream:
> +	omap3isp_video_queue_streamoff(&vfh->queue);
> +err_isp_video_check_format:
> +	media_entity_pipeline_stop(&video->video.entity);
> +err_media_entity_pipeline_start:

Could you please shorten the labels a bit (err_set_stream, err_check_format 
and err_pipeline_start for instance) ?

> +	if (video->isp->pdata->set_constraints)
> +		video->isp->pdata->set_constraints(video->isp, false);
> +	/* The DMA queue must be emptied here, otherwise CCDC
> +	 * interrupts that will get triggered the next time the CCDC
> +	 * is powered up will try to access buffers that might have
> +	 * been freed but still present in the DMA queue. This can
> +	 * easily get triggered if the above
> +	 * omap3isp_pipeline_set_stream() call fails on a system with
> +	 * a free-running sensor.

Please reindent the text to the 80 columns limits.

> +	 */
> +	INIT_LIST_HEAD(&video->dmaqueue);
> +	video->queue = NULL;
> 
>  	mutex_unlock(&video->stream_lock);
>  	return ret;
-- 
Regards,

Laurent Pinchart

