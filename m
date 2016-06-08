Return-path: <linux-media-owner@vger.kernel.org>
Received: from dliviu.plus.com ([80.229.23.120]:46804 "EHLO smtp.dudau.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161912AbcFHOfr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jun 2016 10:35:47 -0400
Date: Wed, 8 Jun 2016 15:35:44 +0100
From: Liviu Dudau <liviu@dudau.co.uk>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] media: s5p-mfc: fix error path in driver probe
Message-ID: <20160608143544.GF21784@bart.dudau.co.uk>
References: <20160608103629.GD21784@bart.dudau.co.uk>
 <1465385620-4396-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1465385620-4396-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 08, 2016 at 01:33:40PM +0200, Marek Szyprowski wrote:
> This patch fixes the error path in the driver probe, so in case of
> any failure, the resources are not leaked.
> 
> Reported-by: Liviu Dudau <liviu.dudau@arm.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Looks good to me now! If it is useful:

Acked-by: Liviu Dudau <Liviu.Dudau@arm.com>

> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index 6ee620ee8cd5..1f3a7ee753db 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -1159,7 +1159,10 @@ static int s5p_mfc_probe(struct platform_device *pdev)
>  	dev->variant = mfc_get_drv_data(pdev);
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -
> +	if (res == NULL) {
> +		dev_err(&pdev->dev, "failed to get io resource\n");
> +		return -ENOENT;
> +	}
>  	dev->regs_base = devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(dev->regs_base))
>  		return PTR_ERR(dev->regs_base);
> @@ -1167,15 +1170,14 @@ static int s5p_mfc_probe(struct platform_device *pdev)
>  	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>  	if (res == NULL) {
>  		dev_err(&pdev->dev, "failed to get irq resource\n");
> -		ret = -ENOENT;
> -		goto err_res;
> +		return -ENOENT;
>  	}
>  	dev->irq = res->start;
>  	ret = devm_request_irq(&pdev->dev, dev->irq, s5p_mfc_irq,
>  					0, pdev->name, dev);
>  	if (ret) {
>  		dev_err(&pdev->dev, "Failed to install irq (%d)\n", ret);
> -		goto err_res;
> +		return ret;
>  	}
>  
>  	ret = s5p_mfc_configure_dma_memory(dev);
> @@ -1187,7 +1189,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
>  	ret = s5p_mfc_init_pm(dev);
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "failed to get mfc clock source\n");
> -		return ret;
> +		goto err_dma;
>  	}
>  
>  	vb2_dma_contig_set_max_seg_size(dev->mem_dev_l, DMA_BIT_MASK(32));
> @@ -1301,6 +1303,8 @@ err_mem_init_ctx_1:
>  	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[0]);
>  err_res:
>  	s5p_mfc_final_pm(dev);
> +err_dma:
> +	s5p_mfc_unconfigure_dma_memory(dev);
>  
>  	pr_debug("%s-- with error\n", __func__);
>  	return ret;
> -- 
> 1.9.2
> 

-- 
-------------------
   .oooO
   (   )
    \ (  Oooo.
     \_) (   )
          ) /
         (_/

 One small step
   for me ...
