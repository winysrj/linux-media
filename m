Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33793 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756883AbaD2Qkj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Apr 2014 12:40:39 -0400
Message-ID: <1398789637.3428.12.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH] media: coda: Use full device name for request_irq()
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Date: Tue, 29 Apr 2014 18:40:37 +0200
In-Reply-To: <1398503686-21102-1-git-send-email-shc_work@mail.ru>
References: <1398503686-21102-1-git-send-email-shc_work@mail.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Samstag, den 26.04.2014, 13:14 +0400 schrieb Alexander Shiyan:
> This will help to debug driver, allows us to see the full name of
> the device through /proc/interrupts.
> 
>            CPU0
> ...
>  69:          0  mxc-avic  53  10023000.coda
> ...
>
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

> ---
>  drivers/media/platform/coda.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index 3e5199e..11023b1 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -3235,7 +3235,7 @@ static int coda_probe(struct platform_device *pdev)
>  	}
>  
>  	if (devm_request_threaded_irq(&pdev->dev, irq, NULL, coda_irq_handler,
> -		IRQF_ONESHOT, CODA_NAME, dev) < 0) {
> +		IRQF_ONESHOT, dev_name(&pdev->dev), dev) < 0) {
>  		dev_err(&pdev->dev, "failed to request irq\n");
>  		return -ENOENT;
>  	}

regards
Philipp

