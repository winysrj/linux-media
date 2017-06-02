Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:33892 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFBVoP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Jun 2017 17:44:15 -0400
Subject: Re: [PATCH 5/9] [media] s5p-jpeg: Add IOMMU support
To: Thierry Escande <thierry.escande@collabora.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1496419376-17099-1-git-send-email-thierry.escande@collabora.com>
 <1496419376-17099-6-git-send-email-thierry.escande@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
From: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <22caa512-6feb-449c-e6c4-8d647b2d2e8d@gmail.com>
Date: Fri, 2 Jun 2017 23:43:25 +0200
MIME-Version: 1.0
In-Reply-To: <1496419376-17099-6-git-send-email-thierry.escande@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc Marek Szyprowski.

Marek, could you share your opinion about this patch?

On 06/02/2017 06:02 PM, Thierry Escande wrote:
> From: Tony K Nadackal <tony.kn@samsung.com>
> 
> This patch adds support for IOMMU s5p-jpeg driver if the Exynos IOMMU
> and ARM DMA IOMMU configurations are supported. The address space is
> created with size limited to 256M and base address set to 0x20000000.
> 
> Signed-off-by: Tony K Nadackal <tony.kn@samsung.com>
> Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
> ---
>  drivers/media/platform/s5p-jpeg/jpeg-core.c | 77 +++++++++++++++++++++++++++++
>  1 file changed, 77 insertions(+)
> 
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index 770a709..5569b99 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -28,6 +28,14 @@
>  #include <media/v4l2-ioctl.h>
>  #include <media/videobuf2-v4l2.h>
>  #include <media/videobuf2-dma-contig.h>
> +#if defined(CONFIG_EXYNOS_IOMMU) && defined(CONFIG_ARM_DMA_USE_IOMMU)
> +#include <asm/dma-iommu.h>
> +#include <linux/dma-iommu.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/iommu.h>
> +#include <linux/kref.h>
> +#include <linux/of_platform.h>
> +#endif
>  
>  #include "jpeg-core.h"
>  #include "jpeg-hw-s5p.h"
> @@ -35,6 +43,10 @@
>  #include "jpeg-hw-exynos3250.h"
>  #include "jpeg-regs.h"
>  
> +#if defined(CONFIG_EXYNOS_IOMMU) && defined(CONFIG_ARM_DMA_USE_IOMMU)
> +static struct dma_iommu_mapping *mapping;
> +#endif
> +
>  static struct s5p_jpeg_fmt sjpeg_formats[] = {
>  	{
>  		.name		= "JPEG JFIF",
> @@ -956,6 +968,60 @@ static void exynos4_jpeg_parse_q_tbl(struct s5p_jpeg_ctx *ctx)
>  	}
>  }
>  
> +#if defined(CONFIG_EXYNOS_IOMMU) && defined(CONFIG_ARM_DMA_USE_IOMMU)
> +static int jpeg_iommu_init(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	int err;
> +
> +	mapping = arm_iommu_create_mapping(&platform_bus_type, 0x20000000,
> +					   SZ_512M);
> +	if (IS_ERR(mapping)) {
> +		dev_err(dev, "IOMMU mapping failed\n");
> +		return PTR_ERR(mapping);
> +	}
> +
> +	dev->dma_parms = devm_kzalloc(dev, sizeof(*dev->dma_parms), GFP_KERNEL);
> +	if (!dev->dma_parms) {
> +		err = -ENOMEM;
> +		goto error_alloc;
> +	}
> +
> +	err = dma_set_max_seg_size(dev, 0xffffffffu);
> +	if (err)
> +		goto error;
> +
> +	err = arm_iommu_attach_device(dev, mapping);
> +	if (err)
> +		goto error;
> +
> +	return 0;
> +
> +error:
> +	devm_kfree(dev, dev->dma_parms);
> +	dev->dma_parms = NULL;
> +
> +error_alloc:
> +	arm_iommu_release_mapping(mapping);
> +	mapping = NULL;
> +
> +	return err;
> +}
> +
> +static void jpeg_iommu_deinit(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +
> +	if (mapping) {
> +		arm_iommu_detach_device(dev);
> +		devm_kfree(dev, dev->dma_parms);
> +		dev->dma_parms = NULL;
> +		arm_iommu_release_mapping(mapping);
> +		mapping = NULL;
> +	}
> +}
> +#endif
> +
>  /*
>   * ============================================================================
>   * Device file operations
> @@ -2816,6 +2882,13 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
>  	spin_lock_init(&jpeg->slock);
>  	jpeg->dev = &pdev->dev;
>  
> +#if defined(CONFIG_EXYNOS_IOMMU) && defined(CONFIG_ARM_DMA_USE_IOMMU)
> +	ret = jpeg_iommu_init(pdev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "IOMMU Initialization failed\n");
> +		return ret;
> +	}
> +#endif
>  	/* memory-mapped registers */
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  
> @@ -2962,6 +3035,10 @@ static int s5p_jpeg_remove(struct platform_device *pdev)
>  			clk_disable_unprepare(jpeg->clocks[i]);
>  	}
>  
> +#if defined(CONFIG_EXYNOS_IOMMU) && defined(CONFIG_ARM_DMA_USE_IOMMU)
> +	jpeg_iommu_deinit(pdev);
> +#endif
> +
>  	return 0;
>  }
>  
> 

-- 
Best regards,
Jacek Anaszewski
