Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39704 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab3IPQSx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Sep 2013 12:18:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Wei Yongjun <weiyj.lk@gmail.com>, sakari.ailus@iki.fi
Cc: m.chehab@samsung.com, yongjun_wei@trendmicro.com.cn,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] v4l: vsp1: fix error return code in vsp1_video_init()
Date: Mon, 16 Sep 2013 18:18:54 +0200
Message-ID: <1889337.27XRTukMTP@avalon>
In-Reply-To: <CAPgLHd9fXJHqn=c50XY84xdmxC5FhAFqJ3Z5yEZReoOgLRPHbw@mail.gmail.com>
References: <CAPgLHd9fXJHqn=c50XY84xdmxC5FhAFqJ3Z5yEZReoOgLRPHbw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wei,

Thank you for your patch.

On Wednesday 11 September 2013 22:10:24 Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I've taken the patch in my tree and will push it to v3.12.

> ---
>  drivers/media/platform/vsp1/vsp1_video.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c
> b/drivers/media/platform/vsp1/vsp1_video.c index 714c53e..4b0ac07 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -1026,8 +1026,10 @@ int vsp1_video_init(struct vsp1_video *video, struct
> vsp1_entity *rwpf)
> 
>  	/* ... and the buffers queue... */
>  	video->alloc_ctx = vb2_dma_contig_init_ctx(video->vsp1->dev);
> -	if (IS_ERR(video->alloc_ctx))
> +	if (IS_ERR(video->alloc_ctx)) {
> +		ret = PTR_ERR(video->alloc_ctx);
>  		goto error;
> +	}
> 
>  	video->queue.type = video->type;
>  	video->queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
-- 
Regards,

Laurent Pinchart

