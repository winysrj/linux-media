Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:17004 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab2K1KNV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 05:13:21 -0500
Received: from eusync1.samsung.com (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ME700D180F19P50@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 Nov 2012 10:13:49 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0ME700MHI0E0RM70@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 Nov 2012 10:13:18 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>, patches@linaro.org
References: <1353671443-2978-1-git-send-email-sachin.kamat@linaro.org>
 <1353671443-2978-5-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1353671443-2978-5-git-send-email-sachin.kamat@linaro.org>
Subject: RE: [PATCH 4/6] [media] s5p-g2d: Use devm_clk_get APIs.
Date: Wed, 28 Nov 2012 11:13:09 +0100
Message-id: <008001cdcd50$f998f080$eccad180$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

The comments from Sylwester also apply to the patches you have sent to MFC
and G2D.

I don't see the benefit of switching to devm_clk_get(), it does some
allocations and hence uses more resources. Leaving that aside there is no
support for devm_clk_prepare and I would rather wait until it is included in
the kernel.

Best wishes,
-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Sachin Kamat
> Sent: Friday, November 23, 2012 12:51 PM
> To: linux-media@vger.kernel.org
> Cc: s.nawrocki@samsung.com; sachin.kamat@linaro.org;
> patches@linaro.org; Kamil Debski
> Subject: [PATCH 4/6] [media] s5p-g2d: Use devm_clk_get APIs.
> 
> devm_clk_get() is device managed function and makes error handling
> and exit code a bit simpler.
> 
> Cc: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/media/platform/s5p-g2d/g2d.c |   14 ++++----------
>  1 files changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-g2d/g2d.c
> b/drivers/media/platform/s5p-g2d/g2d.c
> index 1bfbc32..77819d3 100644
> --- a/drivers/media/platform/s5p-g2d/g2d.c
> +++ b/drivers/media/platform/s5p-g2d/g2d.c
> @@ -714,7 +714,7 @@ static int g2d_probe(struct platform_device *pdev)
>  			return -ENOENT;
>  	}
> 
> -	dev->clk = clk_get(&pdev->dev, "sclk_fimg2d");
> +	dev->clk = devm_clk_get(&pdev->dev, "sclk_fimg2d");
>  	if (IS_ERR_OR_NULL(dev->clk)) {
>  		dev_err(&pdev->dev, "failed to get g2d clock\n");
>  		return -ENXIO;
> @@ -726,7 +726,7 @@ static int g2d_probe(struct platform_device *pdev)
>  		goto put_clk;
>  	}
> 
> -	dev->gate = clk_get(&pdev->dev, "fimg2d");
> +	dev->gate = devm_clk_get(&pdev->dev, "fimg2d");
>  	if (IS_ERR_OR_NULL(dev->gate)) {
>  		dev_err(&pdev->dev, "failed to get g2d clock gate\n");
>  		ret = -ENXIO;
> @@ -736,7 +736,7 @@ static int g2d_probe(struct platform_device *pdev)
>  	ret = clk_prepare(dev->gate);
>  	if (ret) {
>  		dev_err(&pdev->dev, "failed to prepare g2d clock gate\n");
> -		goto put_clk_gate;
> +		goto unprep_clk;
>  	}
> 
>  	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> @@ -752,7 +752,7 @@ static int g2d_probe(struct platform_device *pdev)
>  						0, pdev->name, dev);
>  	if (ret) {
>  		dev_err(&pdev->dev, "failed to install IRQ\n");
> -		goto put_clk_gate;
> +		goto unprep_clk;
>  	}
> 
>  	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> @@ -804,13 +804,9 @@ alloc_ctx_cleanup:
>  	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
>  unprep_clk_gate:
>  	clk_unprepare(dev->gate);
> -put_clk_gate:
> -	clk_put(dev->gate);
>  unprep_clk:
>  	clk_unprepare(dev->clk);
>  put_clk:
> -	clk_put(dev->clk);
> -
>  	return ret;
>  }
> 
> @@ -824,9 +820,7 @@ static int g2d_remove(struct platform_device *pdev)
>  	v4l2_device_unregister(&dev->v4l2_dev);
>  	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
>  	clk_unprepare(dev->gate);
> -	clk_put(dev->gate);
>  	clk_unprepare(dev->clk);
> -	clk_put(dev->clk);
>  	return 0;
>  }
> 
> --
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


