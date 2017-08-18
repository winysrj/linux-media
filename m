Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:39515 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750739AbdHRHnI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 03:43:08 -0400
Message-ID: <1503042183.7730.1.camel@pengutronix.de>
Subject: Re: [PATCH] [media] coda/imx-vdoa: Check for
 platform_get_resource() error
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: mchehab@kernel.org, hansverk@cisco.com,
        linux-media@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>
Date: Fri, 18 Aug 2017 09:43:03 +0200
In-Reply-To: <1502928847-10464-1-git-send-email-festevam@gmail.com>
References: <1502928847-10464-1-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,

On Wed, 2017-08-16 at 21:14 -0300, Fabio Estevam wrote:
> > From: Fabio Estevam <fabio.estevam@nxp.com>
> 
> platform_get_resource() may fail and in this case a NULL dereference
> will occur.
> 
> Prevent this from happening by returning an error on
> platform_get_resource() failure. 
> 
> Fixes: b0444f18e0b18abce ("[media] coda: add i.MX6 VDOA driver")
> > Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
> ---
>  drivers/media/platform/coda/imx-vdoa.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/platform/coda/imx-vdoa.c b/drivers/media/platform/coda/imx-vdoa.c
> index df9b716..8eb3e0c 100644
> --- a/drivers/media/platform/coda/imx-vdoa.c
> +++ b/drivers/media/platform/coda/imx-vdoa.c
> @@ -314,6 +314,8 @@ static int vdoa_probe(struct platform_device *pdev)
> >  		return PTR_ERR(vdoa->regs);
>  
> >  	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> > +	if (!res)
> > +		return -EINVAL;
> >  	vdoa->irq = devm_request_threaded_irq(&pdev->dev, res->start, NULL,
> >  					vdoa_irq_handler, IRQF_ONESHOT,
> >  					"vdoa", vdoa);

Thank you for the fix! I think it would be better to replace
platform_get_resource with platform_get_irq. Either way,

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
