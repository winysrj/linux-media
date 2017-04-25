Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36577 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758162AbdDYTQB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 15:16:01 -0400
Subject: Re: [PATCH] [media] s5p-jpeg: fix recursive spinlock acquisition
To: Alexandre Courbot <acourbot@chromium.org>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <20170425061943.717-1-acourbot@chromium.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <14d0d257-a5c3-222e-137d-4991482c6fb4@gmail.com>
Date: Tue, 25 Apr 2017 21:15:15 +0200
MIME-Version: 1.0
In-Reply-To: <20170425061943.717-1-acourbot@chromium.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alexandre,

Thanks for the patch.

On 04/25/2017 08:19 AM, Alexandre Courbot wrote:
> v4l2_m2m_job_finish(), which is called from the interrupt handler with
> slock acquired, can call the device_run() hook immediately if another
> context was in the queue. This hook also acquires slock, resulting in
> a deadlock for this scenario.
> 
> Fix this by releasing slock right before calling v4l2_m2m_job_finish().
> This is safe to do as the state of the hardware cannot change before
> v4l2_m2m_job_finish() is called anyway.
> 
> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> ---
>  drivers/media/platform/s5p-jpeg/jpeg-core.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index 52dc7941db65..223b4379929e 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -2642,13 +2642,13 @@ static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
>  	if (curr_ctx->mode == S5P_JPEG_ENCODE)
>  		vb2_set_plane_payload(&dst_buf->vb2_buf, 0, payload_size);
>  	v4l2_m2m_buf_done(dst_buf, state);
> -	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
>  
>  	curr_ctx->subsampling = s5p_jpeg_get_subsampling_mode(jpeg->regs);
>  	spin_unlock(&jpeg->slock);
>  
>  	s5p_jpeg_clear_int(jpeg->regs);
>  
> +	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
>  	return IRQ_HANDLED;
>  }
>  
> @@ -2707,11 +2707,12 @@ static irqreturn_t exynos4_jpeg_irq(int irq, void *priv)
>  		v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_ERROR);
>  	}
>  
> -	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
>  	if (jpeg->variant->version == SJPEG_EXYNOS4)
>  		curr_ctx->subsampling = exynos4_jpeg_get_frame_fmt(jpeg->regs);
>  
>  	spin_unlock(&jpeg->slock);
> +
> +	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
>  	return IRQ_HANDLED;
>  }
>  
> @@ -2770,10 +2771,15 @@ static irqreturn_t exynos3250_jpeg_irq(int irq, void *dev_id)
>  	if (curr_ctx->mode == S5P_JPEG_ENCODE)
>  		vb2_set_plane_payload(&dst_buf->vb2_buf, 0, payload_size);
>  	v4l2_m2m_buf_done(dst_buf, state);
> -	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
>  
>  	curr_ctx->subsampling =
>  			exynos3250_jpeg_get_subsampling_mode(jpeg->regs);
> +
> +	spin_unlock(&jpeg->slock);
> +
> +	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->fh.m2m_ctx);
> +	return IRQ_HANDLED;
> +
>  exit_unlock:
>  	spin_unlock(&jpeg->slock);
>  	return IRQ_HANDLED;
> 

Acked-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>

Just out of curiosity - could you share how you discovered the problem -
by some static checkers or trying to use the driver?

-- 
Best regards,
Jacek Anaszewski
