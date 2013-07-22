Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54299 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025Ab3GVIKd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jul 2013 04:10:33 -0400
Message-ID: <1374480589.4355.4.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH v2 1/2] [media] coda: Check the return value from
 clk_prepare_enable()
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: k.debski@samsung.com, m.chehab@samsung.com, kernel@pengutronix.de,
	linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Date: Mon, 22 Jul 2013 10:09:49 +0200
In-Reply-To: <1374347441-15662-1-git-send-email-festevam@gmail.com>
References: <1374347441-15662-1-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,

Am Samstag, den 20.07.2013, 16:10 -0300 schrieb Fabio Estevam:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> clk_prepare_enable() may fail, so let's check its return value and propagate it
> in the case of error.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
>
> ---
> Changes since v1:
> - Add missing 'if'
> 
>  drivers/media/platform/coda.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index df4ada88..486db30 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -1559,14 +1559,21 @@ static int coda_open(struct file *file)
>  	list_add(&ctx->list, &dev->instances);
>  	coda_unlock(ctx);

Now this list_add is not reverted in the error path, ...

>  
> -	clk_prepare_enable(dev->clk_per);
> -	clk_prepare_enable(dev->clk_ahb);
> +	ret = clk_prepare_enable(dev->clk_per);
> +	if (ret)
> +		goto err;
> +
> +	ret = clk_prepare_enable(dev->clk_ahb);
> +	if (ret)
> +		goto err_clk_ahb;

... better move it down here.

>  	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "Created instance %d (%p)\n",
>  		 ctx->idx, ctx);
>  
>  	return 0;
>  
> +err_clk_ahb:
> +	clk_disable_unprepare(dev->clk_per);
>  err:
>  	v4l2_fh_del(&ctx->fh);
>  	v4l2_fh_exit(&ctx->fh);

regards
Philipp

