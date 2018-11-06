Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:36615 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387505AbeKFTPU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 14:15:20 -0500
Message-ID: <1541497854.5822.5.camel@pengutronix.de>
Subject: Re: [PATCH v2 2/3] media: imx-pxp: Check for pxp_soft_reset() error
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org
Date: Tue, 06 Nov 2018 10:50:54 +0100
In-Reply-To: <1541450716-25523-2-git-send-email-festevam@gmail.com>
References: <1541450716-25523-1-git-send-email-festevam@gmail.com>
         <1541450716-25523-2-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-11-05 at 18:45 -0200, Fabio Estevam wrote:
> pxp_soft_reset() may fail with a timeout, so it is better to propagate
> the error in this case.
> 
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> ---
> Changes since v1:
> - None
> 
>  drivers/media/platform/imx-pxp.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/imx-pxp.c b/drivers/media/platform/imx-pxp.c
> index 27780f1..b3700b8 100644
> --- a/drivers/media/platform/imx-pxp.c
> +++ b/drivers/media/platform/imx-pxp.c
> @@ -1607,7 +1607,7 @@ static const struct v4l2_m2m_ops m2m_ops = {
>  	.job_abort	= pxp_job_abort,
>  };
>  
> -static void pxp_soft_reset(struct pxp_dev *dev)
> +static int pxp_soft_reset(struct pxp_dev *dev)
>  {
>  	int ret;
>  	u32 val;
> @@ -1619,11 +1619,15 @@ static void pxp_soft_reset(struct pxp_dev *dev)
>  
>  	ret = readl_poll_timeout(dev->mmio + HW_PXP_CTRL, val,
>  				 val & BM_PXP_CTRL_CLKGATE, 0, 100);
> -	if (ret < 0)
> +	if (ret < 0) {
>  		pr_err("PXP reset timeout\n");
> +		return ret;
> +	}
>  
>  	writel(BM_PXP_CTRL_SFTRST, dev->mmio + HW_PXP_CTRL_CLR);

I'm not sure if we should clear SFTRST again after a timeout. It
probably doesn't matter as something went wrong anyway and the next
probe will try to clear it again.

>  	writel(BM_PXP_CTRL_CLKGATE, dev->mmio + HW_PXP_CTRL_CLR);

Clearing CLKGATE if it was not set by the SFTRST in time should have no
effect, so we could do this unconditionally as well.

> +
> +	return 0;

So you could just "return ret;" here instead of breaking out above.
I have no preference either way.

>  }
>  
>  static int pxp_probe(struct platform_device *pdev)
> @@ -1670,7 +1674,9 @@ static int pxp_probe(struct platform_device *pdev)
>  	if (ret < 0)
>  		return ret;
>  
> -	pxp_soft_reset(dev);
> +	ret = pxp_soft_reset(dev);
> +	if (ret < 0)
> +		return ret;

This should "goto err_clk;" instead, though. With that changed,

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
