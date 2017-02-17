Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:56788
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934613AbdBQUEv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 15:04:51 -0500
Subject: Re: [PATCH 11/15] media: s5p-mfc: Split variant DMA memory
 configuration into separate functions
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170214075219eucas1p193de247c3127167d68a2cca922e83fb3@eucas1p1.samsung.com>
 <1487058728-16501-12-git-send-email-m.szyprowski@samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Message-ID: <fc726a1a-b1f3-0301-2432-f568eeeeec5d@osg.samsung.com>
Date: Fri, 17 Feb 2017 17:04:43 -0300
MIME-Version: 1.0
In-Reply-To: <1487058728-16501-12-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marek,

On 02/14/2017 04:52 AM, Marek Szyprowski wrote:
> Move code for DMA memory configuration with IOMMU into separate function
> to make it easier to compare what is being done in each case.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c | 102 ++++++++++++++++++-------------
>  1 file changed, 61 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index 92a88c20b26d..a18740c81c55 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -1107,41 +1107,13 @@ static struct device *s5p_mfc_alloc_memdev(struct device *dev,
>  	return NULL;
>  }
>  
> -static int s5p_mfc_configure_dma_memory(struct s5p_mfc_dev *mfc_dev)
> +static int s5p_mfc_configure_2port_memory(struct s5p_mfc_dev *mfc_dev)
>  {
>  	struct device *dev = &mfc_dev->plat_dev->dev;
>  	void *bank2_virt;
>  	dma_addr_t bank2_dma_addr;
>  	unsigned long align_size = 1 << MFC_BASE_ALIGN_ORDER;
> -	struct s5p_mfc_priv_buf *fw_buf = &mfc_dev->fw_buf;
> -
> -	/*
> -	 * When IOMMU is available, we cannot use the default configuration,
> -	 * because of MFC firmware requirements: address space limited to
> -	 * 256M and non-zero default start address.
> -	 * This is still simplified, not optimal configuration, but for now
> -	 * IOMMU core doesn't allow to configure device's IOMMUs channel
> -	 * separately.
> -	 */
> -	if (exynos_is_iommu_available(dev)) {
> -		int ret = exynos_configure_iommu(dev, S5P_MFC_IOMMU_DMA_BASE,
> -						 S5P_MFC_IOMMU_DMA_SIZE);
> -		if (ret)
> -			return ret;
> -
> -		mfc_dev->mem_dev[BANK1_CTX] = mfc_dev->mem_dev[BANK2_CTX] = dev;
> -		ret = s5p_mfc_alloc_firmware(mfc_dev);
> -		if (ret) {
> -			exynos_unconfigure_iommu(dev);
> -			return ret;
> -		}
> -
> -		mfc_dev->dma_base[BANK1_CTX] = mfc_dev->fw_buf.dma;
> -		mfc_dev->dma_base[BANK2_CTX] = mfc_dev->fw_buf.dma;
> -		vb2_dma_contig_set_max_seg_size(dev, DMA_BIT_MASK(32));
> -
> -		return 0;
> -	}
> +	int ret;

This should be declared in patch 8/15.

>  
>  	/*
>  	 * Create and initialize virtual devices for accessing
> @@ -1188,26 +1160,74 @@ static int s5p_mfc_configure_dma_memory(struct s5p_mfc_dev *mfc_dev)
>  					DMA_BIT_MASK(32));
>  	vb2_dma_contig_set_max_seg_size(mfc_dev->mem_dev[BANK2_CTX],
>  					DMA_BIT_MASK(32));
> -

This seems to be an unrelated change.

The rest looks good to me.

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
