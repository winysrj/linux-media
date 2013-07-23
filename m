Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56514 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab3GWND7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 09:03:59 -0400
Message-ID: <1374584596.4041.5.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH v3 1/3] [media] coda: Fix error paths
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: k.debski@samsung.com, m.chehab@samsung.com, kernel@pengutronix.de,
	linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Date: Tue, 23 Jul 2013 15:03:16 +0200
In-Reply-To: <1374543502-22678-1-git-send-email-festevam@gmail.com>
References: <1374543502-22678-1-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,

Am Montag, den 22.07.2013, 22:38 -0300 schrieb Fabio Estevam:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Some resources were not being released in the error path and some were released
> in the incorrect order.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
> Changes since v2:
> - Newly introduced in this series
> 
>  drivers/media/platform/coda.c | 32 ++++++++++++++++++++------------
>  1 file changed, 20 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index df4ada88..ea16c20 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -1514,15 +1514,17 @@ static int coda_open(struct file *file)
>  	int ret = 0;
>  	int idx;
>  
> -	idx = coda_next_free_instance(dev);
> -	if (idx >= CODA_MAX_INSTANCES)
> -		return -EBUSY;
> -	set_bit(idx, &dev->instance_mask);
> -
>  	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
>  	if (!ctx)
>  		return -ENOMEM;
>  
> +	idx = coda_next_free_instance(dev);
> +	if (idx >= CODA_MAX_INSTANCES) {
> +		ret =  -EBUSY;
> +		goto err_coda_max;
> +	}
> +	set_bit(idx, &dev->instance_mask);
> +
>  	v4l2_fh_init(&ctx->fh, video_devdata(file));
>  	file->private_data = &ctx->fh;
>  	v4l2_fh_add(&ctx->fh);
> @@ -1537,12 +1539,12 @@ static int coda_open(struct file *file)
>  
>  		v4l2_err(&dev->v4l2_dev, "%s return error (%d)\n",
>  			 __func__, ret);
> -		goto err;
> +		goto err_ctx_init;
>  	}
>  	ret = coda_ctrls_setup(ctx);
>  	if (ret) {
>  		v4l2_err(&dev->v4l2_dev, "failed to setup coda controls\n");
> -		goto err;
> +		goto err_ctrls_setup;
>  	}
>  
>  	ctx->fh.ctrl_handler = &ctx->ctrls;
> @@ -1552,7 +1554,7 @@ static int coda_open(struct file *file)
>  	if (!ctx->parabuf.vaddr) {
>  		v4l2_err(&dev->v4l2_dev, "failed to allocate parabuf");
>  		ret = -ENOMEM;
> -		goto err;
> +		goto err_dma_alloc;
>  	}
>  
>  	coda_lock(ctx);
> @@ -1567,9 +1569,15 @@ static int coda_open(struct file *file)
>  
>  	return 0;
>  
> -err:
> +err_dma_alloc:
> +	v4l2_ctrl_handler_free(&ctx->ctrls);
> +err_ctrls_setup:
> +	v4l2_m2m_ctx_release(ctx->m2m_ctx);
> +err_ctx_init:
>  	v4l2_fh_del(&ctx->fh);
>  	v4l2_fh_exit(&ctx->fh);
> +	clear_bit(ctx->idx, &dev->instance_mask);
> +err_coda_max:
>  	kfree(ctx);
>  	return ret;
>  }
> @@ -1582,16 +1590,16 @@ static int coda_release(struct file *file)
>  	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "Releasing instance %p\n",
>  		 ctx);
>  
> +	clk_disable_unprepare(dev->clk_ahb);
> +	clk_disable_unprepare(dev->clk_per);
>  	coda_lock(ctx);
>  	list_del(&ctx->list);
>  	coda_unlock(ctx);
>  
>  	dma_free_coherent(&dev->plat_dev->dev, CODA_PARA_BUF_SIZE,
>  		ctx->parabuf.vaddr, ctx->parabuf.paddr);
> -	v4l2_m2m_ctx_release(ctx->m2m_ctx);
>  	v4l2_ctrl_handler_free(&ctx->ctrls);
> -	clk_disable_unprepare(dev->clk_per);
> -	clk_disable_unprepare(dev->clk_ahb);
> +	v4l2_m2m_ctx_release(ctx->m2m_ctx);

the clocks must not be disabled until after v4l2_m2m_ctx_release
returns: this function might wait for the currently running job to
finish.

>  	v4l2_fh_del(&ctx->fh);
>  	v4l2_fh_exit(&ctx->fh);
>  	clear_bit(ctx->idx, &dev->instance_mask);

regards
Philipp

