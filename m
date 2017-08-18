Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:47157 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752293AbdHRHqg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 03:46:36 -0400
Message-ID: <1503042394.7730.3.camel@pengutronix.de>
Subject: Re: [PATCH] [media] mx2_emmaprp: Check for platform_get_irq() error
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>
Date: Fri, 18 Aug 2017 09:46:34 +0200
In-Reply-To: <1503004325-23655-1-git-send-email-festevam@gmail.com>
References: <1503004325-23655-1-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,

On Thu, 2017-08-17 at 18:12 -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@nxp.com>
> 
> platform_get_irq() may fail, so we should better check its return
> value and propagate it in the case of error.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
> ---
>  drivers/media/platform/mx2_emmaprp.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/platform/mx2_emmaprp.c
> b/drivers/media/platform/mx2_emmaprp.c
> index 03e47e0..f90eaa0 100644
> --- a/drivers/media/platform/mx2_emmaprp.c
> +++ b/drivers/media/platform/mx2_emmaprp.c
> @@ -942,6 +942,8 @@ static int emmaprp_probe(struct platform_device
> *pdev)
>  	platform_set_drvdata(pdev, pcdev);
>  
>  	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0)
> +		return irq;
>  	ret = devm_request_irq(&pdev->dev, irq, emmaprp_irq, 0,
>  			       dev_name(&pdev->dev), pcdev);
>  	if (ret)

For IORESOURCE_MEM + devm_ioremap_resource pairs this seems to be a
pattern in the kernel, though.
Does devm_request_irq reliably return an error when irq is negative? If
so, this check would be redundant.

regards
Philipp
