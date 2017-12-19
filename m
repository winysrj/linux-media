Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:57397 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S938817AbdLSJMU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 04:12:20 -0500
Message-ID: <1513674733.7538.0.camel@pengutronix.de>
Subject: Re: [PATCH]  [media] coda/imx-vdoa: Remove irq member from
 vdoa_data struct
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: mchehab@kernel.org, hansverk@cisco.com,
        linux-media@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>
Date: Tue, 19 Dec 2017 10:12:13 +0100
In-Reply-To: <1513645124-5825-1-git-send-email-festevam@gmail.com>
References: <1513645124-5825-1-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-12-18 at 22:58 -0200, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@nxp.com>
> 
> The 'irq' member of the vdoa_data struct is only used inside probe,
> so there is no need for it. Use a local variable 'ret' instead.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

> ---
>  drivers/media/platform/coda/imx-vdoa.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/coda/imx-vdoa.c b/drivers/media/platform/coda/imx-vdoa.c
> index 8eb3e0c..eec27d3 100644
> --- a/drivers/media/platform/coda/imx-vdoa.c
> +++ b/drivers/media/platform/coda/imx-vdoa.c
> @@ -86,7 +86,6 @@ struct vdoa_data {
>  	struct device		*dev;
>  	struct clk		*vdoa_clk;
>  	void __iomem		*regs;
> -	int			irq;
>  };
>  
>  struct vdoa_q_data {
> @@ -293,6 +292,7 @@ static int vdoa_probe(struct platform_device *pdev)
>  {
>  	struct vdoa_data *vdoa;
>  	struct resource *res;
> +	int ret;
>  
>  	dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
>  
> @@ -316,12 +316,12 @@ static int vdoa_probe(struct platform_device *pdev)
>  	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>  	if (!res)
>  		return -EINVAL;
> -	vdoa->irq = devm_request_threaded_irq(&pdev->dev, res->start, NULL,
> +	ret = devm_request_threaded_irq(&pdev->dev, res->start, NULL,
>  					vdoa_irq_handler, IRQF_ONESHOT,
>  					"vdoa", vdoa);
> -	if (vdoa->irq < 0) {
> +	if (ret < 0) {
>  		dev_err(vdoa->dev, "Failed to get irq\n");
> -		return vdoa->irq;
> +		return ret;
>  	}
>  
>  	platform_set_drvdata(pdev, vdoa);
