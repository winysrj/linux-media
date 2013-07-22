Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54322 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab3GVIKr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jul 2013 04:10:47 -0400
Message-ID: <1374480608.4355.6.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH 2/2] [media] coda: No need to check the return value of
 platform_get_resource()
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: k.debski@samsung.com, m.chehab@samsung.com, kernel@pengutronix.de,
	linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Date: Mon, 22 Jul 2013 10:10:08 +0200
In-Reply-To: <1374346129-12907-2-git-send-email-festevam@gmail.com>
References: <1374346129-12907-1-git-send-email-festevam@gmail.com>
	 <1374346129-12907-2-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Samstag, den 20.07.2013, 15:48 -0300 schrieb Fabio Estevam:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> When using devm_ioremap_resource(), we do not need to check the return value of
> platform_get_resource(), so just remove it.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/media/platform/coda.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index dd76228..236385f 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -2038,11 +2038,6 @@ static int coda_probe(struct platform_device *pdev)
>  
>  	/* Get  memory for physical registers */
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (res == NULL) {
> -		dev_err(&pdev->dev, "failed to get memory region resource\n");
> -		return -ENOENT;
> -	}
> -
>  	dev->regs_base = devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(dev->regs_base))
>  		return PTR_ERR(dev->regs_base);

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

