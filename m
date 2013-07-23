Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59855 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab3GWNHf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 09:07:35 -0400
Message-ID: <1374584814.4041.8.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH v3 2/3] [media] coda: Check the return value from
 clk_prepare_enable()
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: k.debski@samsung.com, m.chehab@samsung.com, kernel@pengutronix.de,
	linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Date: Tue, 23 Jul 2013 15:06:54 +0200
In-Reply-To: <1374543502-22678-2-git-send-email-festevam@gmail.com>
References: <1374543502-22678-1-git-send-email-festevam@gmail.com>
	 <1374543502-22678-2-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,

Am Montag, den 22.07.2013, 22:38 -0300 schrieb Fabio Estevam:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> clk_prepare_enable() may fail, so let's check its return value and propagate it
> in the case of error.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
> - Changes since v2:
> - Release the previously acquired resources
> Changes since v1:
> - Add missing 'if'
> 
>  drivers/media/platform/coda.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index ea16c20..5f15aaa 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -1561,14 +1561,27 @@ static int coda_open(struct file *file)
>  	list_add(&ctx->list, &dev->instances);
>  	coda_unlock(ctx);
>  
> -	clk_prepare_enable(dev->clk_per);
> -	clk_prepare_enable(dev->clk_ahb);
> +	ret = clk_prepare_enable(dev->clk_per);
> +	if (ret)
> +		goto err_clk_per;
> +
> +	ret = clk_prepare_enable(dev->clk_ahb);
> +	if (ret)
> +		goto err_clk_ahb;
>  
>  	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "Created instance %d (%p)\n",
>  		 ctx->idx, ctx);
>  
>  	return 0;
>  
> +err_clk_ahb:
> +	clk_disable_unprepare(dev->clk_per);
> +err_clk_per:
> +	coda_lock(ctx);
> +	list_del(&ctx->list);
> +	coda_unlock(ctx);
> +	dma_free_coherent(&dev->plat_dev->dev, CODA_PARA_BUF_SIZE,
> +			  ctx->parabuf.vaddr, ctx->parabuf.paddr);
>  err_dma_alloc:
>  	v4l2_ctrl_handler_free(&ctx->ctrls);
>  err_ctrls_setup:

I still think the list_add() should be moved after the last possible
error case and the lock/list_del/unlock should be removed from the error
path.

regards
Philipp

