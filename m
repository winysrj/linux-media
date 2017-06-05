Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:52522 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751290AbdFELhV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Jun 2017 07:37:21 -0400
Subject: Re: [PATCH 5/9] [media] s5p-jpeg: Add IOMMU support
To: Thierry Escande <thierry.escande@collabora.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <99347583-b8b7-a7ba-e974-eb1655888b7b@samsung.com>
Date: Mon, 05 Jun 2017 13:37:13 +0200
MIME-version: 1.0
In-reply-to: <1496419376-17099-6-git-send-email-thierry.escande@collabora.com>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <1496419376-17099-1-git-send-email-thierry.escande@collabora.com>
        <1496419376-17099-6-git-send-email-thierry.escande@collabora.com>
        <CGME20170605113718epcas5p3edec0d42b03181649f06ae9b5bbd6a65@epcas5p3.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/02/2017 06:02 PM, Thierry Escande wrote:
> From: Tony K Nadackal <tony.kn@samsung.com>
> 
> This patch adds support for IOMMU s5p-jpeg driver if the Exynos IOMMU
> and ARM DMA IOMMU configurations are supported. The address space is
> created with size limited to 256M and base address set to 0x20000000.

I don't think this patch is needed now, a few things changed in mainline
since v3.8. The mapping is being created automatically now for this single
JPEG CODEC device by the driver core/dma-mapping code AFAICS.
See dma_configure() in drivers/base/dd.c.
I doubt we need a specific CPU address range, but even if we would shouldn't
it be specified through the dma-ranges DT property?

> Signed-off-by: Tony K Nadackal <tony.kn@samsung.com>
> Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
> ---
>   drivers/media/platform/s5p-jpeg/jpeg-core.c | 77 +++++++++++++++++++++++++++++
>   1 file changed, 77 insertions(+)

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

dev->dma_parms seems to be unused.

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

There is no need for this devm_kfree() call.

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

Ditto.

> +		dev->dma_parms = NULL;
> +		arm_iommu_release_mapping(mapping);
> +		mapping = NULL;
> +	}
> +}

>   /*
>    * ============================================================================
>    * Device file operations
> @@ -2816,6 +2882,13 @@ static int s5p_jpeg_probe(struct platform_device *pdev)

> +	ret = jpeg_iommu_init(pdev);

> @@ -2962,6 +3035,10 @@ static int s5p_jpeg_remove(struct platform_device *pdev)

> +	jpeg_iommu_deinit(pdev);

>   	return 0;
>   }

--
Thanks,
Sylwester
