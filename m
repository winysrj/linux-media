Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:54381 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387438AbeKFTNV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 14:13:21 -0500
Message-ID: <1541497735.5822.3.camel@pengutronix.de>
Subject: Re: [PATCH v2 1/3] media: imx-pxp: Check the return value from
 clk_prepare_enable()
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org
Date: Tue, 06 Nov 2018 10:48:55 +0100
In-Reply-To: <1541450716-25523-1-git-send-email-festevam@gmail.com>
References: <1541450716-25523-1-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,

thank you for the fixes!

On Mon, 2018-11-05 at 18:45 -0200, Fabio Estevam wrote:
> clk_prepare_enable() may fail, so we should better check its return value
> and propagate it in the case of error.
> 
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> ---
> Changes since v1:
> - Properly enumerate the series
> 
>  drivers/media/platform/imx-pxp.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/imx-pxp.c b/drivers/media/platform/imx-pxp.c
> index b76cd0e..27780f1 100644
> --- a/drivers/media/platform/imx-pxp.c
> +++ b/drivers/media/platform/imx-pxp.c
> @@ -1666,7 +1666,10 @@ static int pxp_probe(struct platform_device *pdev)
>  		return ret;
>  	}
>  
> -	clk_prepare_enable(dev->clk);
> +	ret = clk_prepare_enable(dev->clk);
> +	if (ret < 0)
> +		return ret;
> +
>  	pxp_soft_reset(dev);
>  
>  	spin_lock_init(&dev->irqlock);

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
