Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:49339 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548Ab2EJI4z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 04:56:55 -0400
Received: from epcpsbgm1.samsung.com (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M3S0098SU4X7XS0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 17:56:47 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M3S00HB6U6JXB20@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 17:56:47 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org
Cc: mchehab@infradead.org, kyungmin.park@samsung.com,
	patches@linaro.org
References: <1336631748-25160-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1336631748-25160-1-git-send-email-sachin.kamat@linaro.org>
Subject: RE: [PATCH 1/2] [media] s5p-g2d: Fix NULL pointer warnings in g2d.c
 file
Date: Thu, 10 May 2012 10:56:42 +0200
Message-id: <017301cd2e8a$d4940f50$7dbc2df0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

Thanks for the patch.

Best regards,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


> -----Original Message-----
> From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
> Sent: 10 May 2012 08:36
> To: linux-media@vger.kernel.org
> Cc: mchehab@infradead.org; k.debski@samsung.com;
> kyungmin.park@samsung.com; sachin.kamat@linaro.org; patches@linaro.org
> Subject: [PATCH 1/2] [media] s5p-g2d: Fix NULL pointer warnings in g2d.c
> file
> 
> Fixes the following warnings detected by sparse:
> warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
>  drivers/media/video/s5p-g2d/g2d.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/video/s5p-g2d/g2d.c b/drivers/media/video/s5p-
> g2d/g2d.c
> index 789de74..70bee1c 100644
> --- a/drivers/media/video/s5p-g2d/g2d.c
> +++ b/drivers/media/video/s5p-g2d/g2d.c
> @@ -546,11 +546,11 @@ static void job_abort(void *prv)
>  	struct g2d_dev *dev = ctx->dev;
>  	int ret;
> 
> -	if (dev->curr == 0) /* No job currently running */
> +	if (dev->curr == NULL) /* No job currently running */
>  		return;
> 
>  	ret = wait_event_timeout(dev->irq_queue,
> -		dev->curr == 0,
> +		dev->curr == NULL,
>  		msecs_to_jiffies(G2D_TIMEOUT));
>  }
> 
> @@ -599,19 +599,19 @@ static irqreturn_t g2d_isr(int irq, void *prv)
>  	g2d_clear_int(dev);
>  	clk_disable(dev->gate);
> 
> -	BUG_ON(ctx == 0);
> +	BUG_ON(ctx == NULL);
> 
>  	src = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
>  	dst = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
> 
> -	BUG_ON(src == 0);
> -	BUG_ON(dst == 0);
> +	BUG_ON(src == NULL);
> +	BUG_ON(dst == NULL);
> 
>  	v4l2_m2m_buf_done(src, VB2_BUF_STATE_DONE);
>  	v4l2_m2m_buf_done(dst, VB2_BUF_STATE_DONE);
>  	v4l2_m2m_job_finish(dev->m2m_dev, ctx->m2m_ctx);
> 
> -	dev->curr = 0;
> +	dev->curr = NULL;
>  	wake_up(&dev->irq_queue);
>  	return IRQ_HANDLED;
>  }
> --
> 1.7.4.1

