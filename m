Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:48355 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387505AbeKFTPc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 14:15:32 -0500
Message-ID: <1541497866.5822.6.camel@pengutronix.de>
Subject: Re: [PATCH v2 3/3] media: imx-pxp: Improve pxp_soft_reset() error
 message
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org
Date: Tue, 06 Nov 2018 10:51:06 +0100
In-Reply-To: <1541450716-25523-3-git-send-email-festevam@gmail.com>
References: <1541450716-25523-1-git-send-email-festevam@gmail.com>
         <1541450716-25523-3-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-11-05 at 18:45 -0200, Fabio Estevam wrote:
> Improve the pxp_soft_reset() error message by moving it to the
> caller function, associating it with a proper device and also
> by displaying the error code.
> 
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> ---
> Changes since v1:
> - Newly introduced in this version
> 
>  drivers/media/platform/imx-pxp.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/imx-pxp.c b/drivers/media/platform/imx-pxp.c
> index b3700b8..1b765c9 100644
> --- a/drivers/media/platform/imx-pxp.c
> +++ b/drivers/media/platform/imx-pxp.c
> @@ -1619,10 +1619,8 @@ static int pxp_soft_reset(struct pxp_dev *dev)
>  
>  	ret = readl_poll_timeout(dev->mmio + HW_PXP_CTRL, val,
>  				 val & BM_PXP_CTRL_CLKGATE, 0, 100);
> -	if (ret < 0) {
> -		pr_err("PXP reset timeout\n");
> +	if (ret < 0)
>  		return ret;
> -	}
>  
>  	writel(BM_PXP_CTRL_SFTRST, dev->mmio + HW_PXP_CTRL_CLR);
>  	writel(BM_PXP_CTRL_CLKGATE, dev->mmio + HW_PXP_CTRL_CLR);
> @@ -1675,8 +1673,10 @@ static int pxp_probe(struct platform_device *pdev)
>  		return ret;
>  
>  	ret = pxp_soft_reset(dev);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "PXP reset timeout: %d\n", ret);
>  		return ret;
> +	}
>  
>  	spin_lock_init(&dev->irqlock);

This should be rebased onto the fixed 2/2 or squashed into it,
but otherwise
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
