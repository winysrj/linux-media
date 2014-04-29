Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33811 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515AbaD2Ql7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Apr 2014 12:41:59 -0400
Message-ID: <1398789715.3428.14.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 2/2] [media] coda: Propagate the correct error on
 devm_request_threaded_irq()
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: m.chehab@samsung.com, linux-media@vger.kernel.org
Date: Tue, 29 Apr 2014 18:41:55 +0200
In-Reply-To: <1398704252-6256-2-git-send-email-fabio.estevam@freescale.com>
References: <1398704252-6256-1-git-send-email-fabio.estevam@freescale.com>
	 <1398704252-6256-2-git-send-email-fabio.estevam@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 28.04.2014, 13:57 -0300 schrieb Fabio Estevam:
> If devm_request_threaded_irq() fails, we should better propagate the real error.
> 
> Also, print out the error code in the dev_err message.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Both look fine to me.
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

2/2 trivially conflicts with "[PATCH] media: coda: Use full device name
for request_irq()" by Alexander Shiyan.

> ---
>  drivers/media/platform/coda.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index ba7cb3f..1360b91 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -3234,10 +3234,11 @@ static int coda_probe(struct platform_device *pdev)
>  		return irq;
>  	}
>  
> -	if (devm_request_threaded_irq(&pdev->dev, irq, NULL, coda_irq_handler,
> -		IRQF_ONESHOT, CODA_NAME, dev) < 0) {
> -		dev_err(&pdev->dev, "failed to request irq\n");
> -		return -ENOENT;
> +	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL, coda_irq_handler,
> +					IRQF_ONESHOT, CODA_NAME, dev);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "failed to request irq: %d\n", ret);
> +		return ret;
>  	}
>  
>  	/* Get IRAM pool from device tree or platform data */

regards
Philipp

