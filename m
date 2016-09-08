Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36671 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935086AbcIHJFi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 05:05:38 -0400
Received: by mail-wm0-f68.google.com with SMTP id l65so6813711wmf.3
        for <linux-media@vger.kernel.org>; Thu, 08 Sep 2016 02:05:38 -0700 (PDT)
Subject: Re: [PATCH v3 05/10] v4l: fdp1: vb2_queue dev conversion
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org
References: <1473287110-780-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1473287110-780-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org
From: Kieran Bingham <kieran@ksquared.org.uk>
Message-ID: <2a9843be-2357-5807-4199-a0bef123769c@bingham.xyz>
Date: Thu, 8 Sep 2016 10:05:36 +0100
MIME-Version: 1.0
In-Reply-To: <1473287110-780-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/09/16 23:25, Laurent Pinchart wrote:
> From: Geert Uytterhoeven <geert+renesas@glider.be>
> 
>     drivers/media/platform/rcar_fdp1.c:1972:2: warning: initialization from incompatible pointer type
>       .queue_setup  = fdp1_queue_setup,
>       ^
>     drivers/media/platform/rcar_fdp1.c:1972:2: warning: (near initialization for 'fdp1_qops.queue_setup')
>     drivers/media/platform/rcar_fdp1.c: In function 'fdp1_probe':
>     drivers/media/platform/rcar_fdp1.c:2264:2: error: implicit declaration of function 'vb2_dma_contig_init_ctx' [-Werror=implicit-function-declaration]
>       fdp1->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
>       ^
>     drivers/media/platform/rcar_fdp1.c:2264:18: warning: assignment makes pointer from integer without a cast
>       fdp1->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> 		      ^
>     drivers/media/platform/rcar_fdp1.c:2331:2: error: implicit declaration of function 'vb2_dma_contig_cleanup_ctx' [-Werror=implicit-function-declaration]
>       vb2_dma_contig_cleanup_ctx(fdp1->alloc_ctx);
>       ^
> 
> Commit 36c0f8b32c4bd4f6 ("[media] vb2: replace void *alloc_ctxs by
> struct device *alloc_devs") removed the vb2_dma_contig_init_ctx() and
> vb2_dma_contig_cleanup_ctx() functions, and changed the prototype of
> vb2_ops.queue_setup().
> 
> To fix this:
>   - Update the signature of fdp1_queue_setup(),
>   - Convert the FDP1 driver to use the new vb2_queue dev field, cfr.
>     commit 53ddcc683faef8c7 ("[media] media/platform: convert drivers to
>     use the new vb2_queue dev field").
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

This looks like a good fix to me. Tested, and verified as well.

Reviewed-by: Kieran Bingham <kieran@bingham.xyz>

> ---
>  drivers/media/platform/rcar_fdp1.c | 26 ++++++--------------------
>  1 file changed, 6 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
> index c7280183262a..a2587745ca68 100644
> --- a/drivers/media/platform/rcar_fdp1.c
> +++ b/drivers/media/platform/rcar_fdp1.c
> @@ -570,7 +570,6 @@ struct fdp1_dev {
>  	void __iomem		*regs;
>  	unsigned int		irq;
>  	struct device		*dev;
> -	void			*alloc_ctx;
>  
>  	/* Job Queues */
>  	struct fdp1_job		jobs[FDP1_NUMBER_JOBS];
> @@ -1788,7 +1787,8 @@ static const struct v4l2_ioctl_ops fdp1_ioctl_ops = {
>  
>  static int fdp1_queue_setup(struct vb2_queue *vq,
>  				unsigned int *nbuffers, unsigned int *nplanes,
> -				unsigned int sizes[], void *alloc_ctxs[])
> +				unsigned int sizes[],
> +				struct device *alloc_ctxs[])
>  {
>  	struct fdp1_ctx *ctx = vb2_get_drv_priv(vq);
>  	struct fdp1_q_data *q_data;
> @@ -1800,18 +1800,13 @@ static int fdp1_queue_setup(struct vb2_queue *vq,
>  		if (*nplanes > FDP1_MAX_PLANES)
>  			return -EINVAL;
>  
> -		for (i = 0; i < *nplanes; i++)
> -			alloc_ctxs[i] = ctx->fdp1->alloc_ctx;
> -
>  		return 0;
>  	}
>  
>  	*nplanes = q_data->format.num_planes;
>  
> -	for (i = 0; i < *nplanes; i++) {
> +	for (i = 0; i < *nplanes; i++)
>  		sizes[i] = q_data->format.plane_fmt[i].sizeimage;
> -		alloc_ctxs[i] = ctx->fdp1->alloc_ctx;
> -	}
>  
>  	return 0;
>  }
> @@ -1992,6 +1987,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>  	src_vq->mem_ops = &vb2_dma_contig_memops;
>  	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  	src_vq->lock = &ctx->fdp1->dev_mutex;
> +	src_vq->dev = ctx->fdp1->dev;
>  
>  	ret = vb2_queue_init(src_vq);
>  	if (ret)
> @@ -2005,6 +2001,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>  	dst_vq->mem_ops = &vb2_dma_contig_memops;
>  	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  	dst_vq->lock = &ctx->fdp1->dev_mutex;
> +	dst_vq->dev = ctx->fdp1->dev;
>  
>  	return vb2_queue_init(dst_vq);
>  }
> @@ -2260,18 +2257,11 @@ static int fdp1_probe(struct platform_device *pdev)
>  	fdp1->clk_rate = clk_get_rate(clk);
>  	clk_put(clk);
>  
> -	/* Memory allocation contexts */
> -	fdp1->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> -	if (IS_ERR(fdp1->alloc_ctx)) {
> -		v4l2_err(&fdp1->v4l2_dev, "Failed to init memory allocator\n");
> -		return PTR_ERR(fdp1->alloc_ctx);
> -	}
> -
>  	/* V4L2 device registration */
>  	ret = v4l2_device_register(&pdev->dev, &fdp1->v4l2_dev);
>  	if (ret) {
>  		v4l2_err(&fdp1->v4l2_dev, "Failed to register video device\n");
> -		goto vb2_allocator_rollback;
> +		return ret;
>  	}
>  
>  	/* M2M registration */
> @@ -2327,9 +2317,6 @@ release_m2m:
>  unreg_dev:
>  	v4l2_device_unregister(&fdp1->v4l2_dev);
>  
> -vb2_allocator_rollback:
> -	vb2_dma_contig_cleanup_ctx(fdp1->alloc_ctx);
> -
>  	return ret;
>  }
>  
> @@ -2340,7 +2327,6 @@ static int fdp1_remove(struct platform_device *pdev)
>  	v4l2_m2m_release(fdp1->m2m_dev);
>  	video_unregister_device(&fdp1->vfd);
>  	v4l2_device_unregister(&fdp1->v4l2_dev);
> -	vb2_dma_contig_cleanup_ctx(fdp1->alloc_ctx);
>  	pm_runtime_disable(&pdev->dev);
>  
>  	return 0;
> 

-- 
Regards

Kieran Bingham
