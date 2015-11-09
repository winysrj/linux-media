Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45158 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbbKITnL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2015 14:43:11 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] media: omap3isp: use vb2_buffer_state enum for vb2 buffer state
Date: Mon, 09 Nov 2015 21:43:23 +0200
Message-ID: <22984002.5dNlQKS7t1@avalon>
In-Reply-To: <1424879894-7128-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1424879894-7128-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

Thank you for the patch.

On Wednesday 25 February 2015 15:58:14 Lad Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> use the vb2_buffer_state enum for assigning the state
> of the vb2 buffer, along side making isp_pipeline_state
> state variable local to the block.
> This fixes the following sparse warning as well:
> drivers/media/platform/omap3isp/ispvideo.c:497:35: warning: mixing different
> enum types drivers/media/platform/omap3isp/ispvideo.c:497:35:     int enum
> isp_pipeline_state  versus
> drivers/media/platform/omap3isp/ispvideo.c:497:35:     int enum
> vb2_buffer_state
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

> ---
>  drivers/media/platform/omap3isp/ispvideo.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/ispvideo.c
> b/drivers/media/platform/omap3isp/ispvideo.c index 3fe9047..8cd3a57 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -449,7 +449,7 @@ static const struct vb2_ops isp_video_queue_ops = {
>  struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
>  {
>  	struct isp_pipeline *pipe = to_isp_pipeline(&video->video.entity);
> -	enum isp_pipeline_state state;
> +	enum vb2_buffer_state vb_state;
>  	struct isp_buffer *buf;
>  	unsigned long flags;
>  	struct timespec ts;
> @@ -488,17 +488,19 @@ struct isp_buffer *omap3isp_video_buffer_next(struct
> isp_video *video)
> 
>  	/* Report pipeline errors to userspace on the capture device side. */
>  	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE && pipe->error) {
> -		state = VB2_BUF_STATE_ERROR;
> +		vb_state = VB2_BUF_STATE_ERROR;
>  		pipe->error = false;
>  	} else {
> -		state = VB2_BUF_STATE_DONE;
> +		vb_state = VB2_BUF_STATE_DONE;
>  	}
> 
> -	vb2_buffer_done(&buf->vb, state);
> +	vb2_buffer_done(&buf->vb, vb_state);
> 
>  	spin_lock_irqsave(&video->irqlock, flags);
> 
>  	if (list_empty(&video->dmaqueue)) {
> +		enum isp_pipeline_state state;
> +
>  		spin_unlock_irqrestore(&video->irqlock, flags);
> 
>  		if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)

-- 
Regards,

Laurent Pinchart

