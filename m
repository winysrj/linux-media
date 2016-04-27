Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:34809 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751986AbcD0MIY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2016 08:08:24 -0400
Subject: Re: [PATCH RESEND 2/2] media: set proper max seg size for devices on
 Exynos SoCs
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1461758429-12913-1-git-send-email-m.szyprowski@samsung.com>
 <1461758429-12913-2-git-send-email-m.szyprowski@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5720ABAF.9010004@xs4all.nl>
Date: Wed, 27 Apr 2016 14:08:15 +0200
MIME-Version: 1.0
In-Reply-To: <1461758429-12913-2-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/27/2016 02:00 PM, Marek Szyprowski wrote:
> All multimedia devices found on Exynos SoCs support only contiguous
> buffers, so set DMA max segment size to DMA_BIT_MASK(32) to let memory
> allocator to correctly create contiguous memory mappings.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
> This patch was posted earlier as a part of
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/97316
> thread, but applying it is really needed to get all Exynos multimedia
> drivers working with IOMMU enabled.
> 
> Best regards,
> Marek Szyprowski
> ---
>  drivers/media/platform/exynos-gsc/gsc-core.c  | 1 +
>  drivers/media/platform/exynos4-is/fimc-core.c | 1 +
>  drivers/media/platform/exynos4-is/fimc-is.c   | 1 +
>  drivers/media/platform/exynos4-is/fimc-lite.c | 1 +
>  drivers/media/platform/s5p-g2d/g2d.c          | 1 +
>  drivers/media/platform/s5p-jpeg/jpeg-core.c   | 1 +
>  drivers/media/platform/s5p-mfc/s5p_mfc.c      | 2 ++
>  drivers/media/platform/s5p-tv/mixer_video.c   | 1 +
>  8 files changed, 9 insertions(+)
> 
> diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
> index 9b9e423..4f90be4 100644
> --- a/drivers/media/platform/exynos-gsc/gsc-core.c
> +++ b/drivers/media/platform/exynos-gsc/gsc-core.c
> @@ -1140,6 +1140,7 @@ static int gsc_probe(struct platform_device *pdev)
>  		goto err_m2m;
>  
>  	/* Initialize continious memory allocator */

Typo: continious -> contiguous

Regards,

	Hans


> +	vb2_dma_contig_set_max_seg_size(dev, DMA_BIT_MASK(32));
>  	gsc->alloc_ctx = vb2_dma_contig_init_ctx(dev);
>  	if (IS_ERR(gsc->alloc_ctx)) {
>  		ret = PTR_ERR(gsc->alloc_ctx);
> diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
> index cef2a7f..368e19b 100644
> --- a/drivers/media/platform/exynos4-is/fimc-core.c
> +++ b/drivers/media/platform/exynos4-is/fimc-core.c
> @@ -1019,6 +1019,7 @@ static int fimc_probe(struct platform_device *pdev)
>  	}
>  
>  	/* Initialize contiguous memory allocator */
> +	vb2_dma_contig_set_max_seg_size(dev, DMA_BIT_MASK(32));
>  	fimc->alloc_ctx = vb2_dma_contig_init_ctx(dev);
>  	if (IS_ERR(fimc->alloc_ctx)) {
>  		ret = PTR_ERR(fimc->alloc_ctx);
> diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
> index 979c388..3f50856 100644
> --- a/drivers/media/platform/exynos4-is/fimc-is.c
> +++ b/drivers/media/platform/exynos4-is/fimc-is.c
> @@ -847,6 +847,7 @@ static int fimc_is_probe(struct platform_device *pdev)
>  	if (ret < 0)
>  		goto err_pm;
>  
> +	vb2_dma_contig_set_max_seg_size(dev, DMA_BIT_MASK(32));
>  	is->alloc_ctx = vb2_dma_contig_init_ctx(dev);
>  	if (IS_ERR(is->alloc_ctx)) {
>  		ret = PTR_ERR(is->alloc_ctx);
> diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
> index dc1b929..95841c8 100644
> --- a/drivers/media/platform/exynos4-is/fimc-lite.c
> +++ b/drivers/media/platform/exynos4-is/fimc-lite.c
> @@ -1551,6 +1551,7 @@ static int fimc_lite_probe(struct platform_device *pdev)
>  			goto err_sd;
>  	}
>  
> +	vb2_dma_contig_set_max_seg_size(dev, DMA_BIT_MASK(32));
>  	fimc->alloc_ctx = vb2_dma_contig_init_ctx(dev);
>  	if (IS_ERR(fimc->alloc_ctx)) {
>  		ret = PTR_ERR(fimc->alloc_ctx);
> diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
> index 74bd46c..5048b68 100644
> --- a/drivers/media/platform/s5p-g2d/g2d.c
> +++ b/drivers/media/platform/s5p-g2d/g2d.c
> @@ -681,6 +681,7 @@ static int g2d_probe(struct platform_device *pdev)
>  		goto put_clk_gate;
>  	}
>  
> +	vb2_dma_contig_set_max_seg_size(&pdev->dev, DMA_BIT_MASK(32));
>  	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
>  	if (IS_ERR(dev->alloc_ctx)) {
>  		ret = PTR_ERR(dev->alloc_ctx);
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index c3b13a6..e535ccf 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -2838,6 +2838,7 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
>  		goto device_register_rollback;
>  	}
>  
> +	vb2_dma_contig_set_max_seg_size(&pdev->dev, DMA_BIT_MASK(32));
>  	jpeg->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
>  	if (IS_ERR(jpeg->alloc_ctx)) {
>  		v4l2_err(&jpeg->v4l2_dev, "Failed to init memory allocator\n");
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index 927ab49..ae0bf26 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -1164,11 +1164,13 @@ static int s5p_mfc_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> +	vb2_dma_contig_set_max_seg_size(dev->mem_dev_l, DMA_BIT_MASK(32));
>  	dev->alloc_ctx[0] = vb2_dma_contig_init_ctx(dev->mem_dev_l);
>  	if (IS_ERR(dev->alloc_ctx[0])) {
>  		ret = PTR_ERR(dev->alloc_ctx[0]);
>  		goto err_res;
>  	}
> +	vb2_dma_contig_set_max_seg_size(dev->mem_dev_r, DMA_BIT_MASK(32));
>  	dev->alloc_ctx[1] = vb2_dma_contig_init_ctx(dev->mem_dev_r);
>  	if (IS_ERR(dev->alloc_ctx[1])) {
>  		ret = PTR_ERR(dev->alloc_ctx[1]);
> diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
> index d9e7f03..17d6df7 100644
> --- a/drivers/media/platform/s5p-tv/mixer_video.c
> +++ b/drivers/media/platform/s5p-tv/mixer_video.c
> @@ -80,6 +80,7 @@ int mxr_acquire_video(struct mxr_device *mdev,
>  		goto fail;
>  	}
>  
> +	vb2_dma_contig_set_max_seg_size(mdev->dev, DMA_BIT_MASK(32));
>  	mdev->alloc_ctx = vb2_dma_contig_init_ctx(mdev->dev);
>  	if (IS_ERR(mdev->alloc_ctx)) {
>  		mxr_err(mdev, "could not acquire vb2 allocator\n");
> 
