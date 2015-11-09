Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45110 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbbKITRr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2015 14:17:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] omap3isp: Move starting the sensor from streamon IOCTL handler to VB2 QOP
Date: Mon, 09 Nov 2015 21:17:57 +0200
Message-ID: <1465641.kaD0S8lILY@avalon>
In-Reply-To: <1411077469-29178-3-git-send-email-sakari.ailus@iki.fi>
References: <1411077469-29178-1-git-send-email-sakari.ailus@iki.fi> <1411077469-29178-3-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Friday 19 September 2014 00:57:48 Sakari Ailus wrote:
> Move the starting of the sensor from the VIDIOC_STREAMON handler to the
> videobuf2 queue op start_streaming. This avoids failing starting the stream
> after vb2_streamon() has already finished.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

> ---
>  drivers/media/platform/omap3isp/ispvideo.c |   49 +++++++++++++++---------
>  1 file changed, 30 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/ispvideo.c
> b/drivers/media/platform/omap3isp/ispvideo.c index bc38c88..b233c8e 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -425,10 +425,40 @@ static void isp_video_buffer_queue(struct vb2_buffer
> *buf) }
>  }
> 
> +static int isp_video_start_streaming(struct vb2_queue *queue,
> +				     unsigned int count)
> +{
> +	struct isp_video_fh *vfh = vb2_get_drv_priv(queue);
> +	struct isp_video *video = vfh->video;
> +	struct isp_pipeline *pipe = to_isp_pipeline(&video->video.entity);
> +	unsigned long flags;
> +	int ret;
> +
> +	/* In sensor-to-memory mode, the stream can be started synchronously
> +	 * to the stream on command. In memory-to-memory mode, it will be
> +	 * started when buffers are queued on both the input and output.
> +	 */
> +	if (pipe->input)
> +		return 0;
> +
> +	ret = omap3isp_pipeline_set_stream(pipe,
> +					   ISP_PIPELINE_STREAM_CONTINUOUS);
> +	if (ret < 0)
> +		return ret;
> +
> +	spin_lock_irqsave(&video->irqlock, flags);
> +	if (list_empty(&video->dmaqueue))
> +		video->dmaqueue_flags |= ISP_VIDEO_DMAQUEUE_UNDERRUN;
> +	spin_unlock_irqrestore(&video->irqlock, flags);
> +
> +	return 0;
> +}
> +
>  static const struct vb2_ops isp_video_queue_ops = {
>  	.queue_setup = isp_video_queue_setup,
>  	.buf_prepare = isp_video_buffer_prepare,
>  	.buf_queue = isp_video_buffer_queue,
> +	.start_streaming = isp_video_start_streaming,
>  };
> 
>  /*
> @@ -1077,28 +1107,9 @@ isp_video_streamon(struct file *file, void *fh, enum
> v4l2_buf_type type) if (ret < 0)
>  		goto err_check_format;
> 
> -	/* In sensor-to-memory mode, the stream can be started synchronously
> -	 * to the stream on command. In memory-to-memory mode, it will be
> -	 * started when buffers are queued on both the input and output.
> -	 */
> -	if (pipe->input == NULL) {
> -		ret = omap3isp_pipeline_set_stream(pipe,
> -					      ISP_PIPELINE_STREAM_CONTINUOUS);
> -		if (ret < 0)
> -			goto err_set_stream;
> -		spin_lock_irqsave(&video->irqlock, flags);
> -		if (list_empty(&video->dmaqueue))
> -			video->dmaqueue_flags |= ISP_VIDEO_DMAQUEUE_UNDERRUN;
> -		spin_unlock_irqrestore(&video->irqlock, flags);
> -	}
> -
>  	mutex_unlock(&video->stream_lock);
>  	return 0;
> 
> -err_set_stream:
> -	mutex_lock(&video->queue_lock);
> -	vb2_streamoff(&vfh->queue, type);
> -	mutex_unlock(&video->queue_lock);
>  err_check_format:
>  	media_entity_pipeline_stop(&video->video.entity);
>  err_pipeline_start:

-- 
Regards,

Laurent Pinchart

