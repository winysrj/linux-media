Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37564 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935752Ab3FUHag (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 03:30:36 -0400
Message-ID: <1371799814.4320.3.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH RESEND] media: coda: Fix DT-driver data pointer for
 i.MX27
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Shawn Guo <shawn.guo@linaro.org>
Date: Fri, 21 Jun 2013 09:30:14 +0200
In-Reply-To: <1371746796-16123-1-git-send-email-shc_work@mail.ru>
References: <1371746796-16123-1-git-send-email-shc_work@mail.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, den 20.06.2013, 20:46 +0400 schrieb Alexander Shiyan:
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  drivers/media/platform/coda.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index 48b8d7a..1c77781 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -1924,7 +1924,7 @@ MODULE_DEVICE_TABLE(platform, coda_platform_ids);
>  
>  #ifdef CONFIG_OF
>  static const struct of_device_id coda_dt_ids[] = {
> -	{ .compatible = "fsl,imx27-vpu", .data = &coda_platform_ids[CODA_IMX27] },
> +	{ .compatible = "fsl,imx27-vpu", .data = &coda_devdata[CODA_IMX27] },
>  	{ .compatible = "fsl,imx53-vpu", .data = &coda_devdata[CODA_IMX53] },
>  	{ /* sentinel */ }
>  };

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

thanks
Philipp

