Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:56544
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752588AbdBQTAf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 14:00:35 -0500
Subject: Re: [PATCH 08/15] media: s5p-mfc: Move firmware allocation to DMA
 configure function
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170214075218eucas1p2918abf0dc5cb970183f5a18561050720@eucas1p2.samsung.com>
 <1487058728-16501-9-git-send-email-m.szyprowski@samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Message-ID: <97a33f65-8e79-3b93-2eaf-dba5260411d2@osg.samsung.com>
Date: Fri, 17 Feb 2017 16:00:27 -0300
MIME-Version: 1.0
In-Reply-To: <1487058728-16501-9-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marek,

On 02/14/2017 04:52 AM, Marek Szyprowski wrote:
> To complete DMA memory configuration for MFC device, allocation of the
> firmware buffer is needed, because some parameters are dependant on its base
> address. Till now, this has been handled in the s5p_mfc_alloc_firmware()
> function. This patch moves that logic to s5p_mfc_configure_dma_memory() to
> keep DMA memory related operations in a single place. This way
> s5p_mfc_alloc_firmware() is simplified and does what it name says. The
> other consequence of this change is moving s5p_mfc_alloc_firmware() call
> from the s5p_mfc_probe() function to the s5p_mfc_configure_dma_memory().
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c      | 58 +++++++++++++++++++++------
>  drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c | 31 --------------
>  2 files changed, 45 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index bc1aeb25ebeb..92a88c20b26d 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -1110,6 +1110,10 @@ static struct device *s5p_mfc_alloc_memdev(struct device *dev,
>  static int s5p_mfc_configure_dma_memory(struct s5p_mfc_dev *mfc_dev)
>  {
>  	struct device *dev = &mfc_dev->plat_dev->dev;
> +	void *bank2_virt;
> +	dma_addr_t bank2_dma_addr;
> +	unsigned long align_size = 1 << MFC_BASE_ALIGN_ORDER;
> +	struct s5p_mfc_priv_buf *fw_buf = &mfc_dev->fw_buf;
>  
>  	/*
>  	 * When IOMMU is available, we cannot use the default configuration,
> @@ -1122,14 +1126,21 @@ static int s5p_mfc_configure_dma_memory(struct s5p_mfc_dev *mfc_dev)
>  	if (exynos_is_iommu_available(dev)) {
>  		int ret = exynos_configure_iommu(dev, S5P_MFC_IOMMU_DMA_BASE,
>  						 S5P_MFC_IOMMU_DMA_SIZE);
> -		if (ret == 0) {
> -			mfc_dev->mem_dev[BANK1_CTX] =
> -				mfc_dev->mem_dev[BANK2_CTX] = dev;
> -			vb2_dma_contig_set_max_seg_size(dev,
> -							DMA_BIT_MASK(32));
> +		if (ret)
> +			return ret;
> +
> +		mfc_dev->mem_dev[BANK1_CTX] = mfc_dev->mem_dev[BANK2_CTX] = dev;
> +		ret = s5p_mfc_alloc_firmware(mfc_dev);
> +		if (ret) {
> +			exynos_unconfigure_iommu(dev);
> +			return ret;
>  		}
>  
> -		return ret;
> +		mfc_dev->dma_base[BANK1_CTX] = mfc_dev->fw_buf.dma;
> +		mfc_dev->dma_base[BANK2_CTX] = mfc_dev->fw_buf.dma;

I guess you meant to use fw_buf->dma here? Since otherwise the fw_buf
variable won't be used.

> +		vb2_dma_contig_set_max_seg_size(dev, DMA_BIT_MASK(32));
> +
> +		return 0;
>  	}
>  
>  	/*
> @@ -1147,6 +1158,32 @@ static int s5p_mfc_configure_dma_memory(struct s5p_mfc_dev *mfc_dev)
>  		return -ENODEV;
>  	}
>  
> +	/* Allocate memory for firmware and initialize both banks addresses */
> +	ret = s5p_mfc_alloc_firmware(mfc_dev);
> +	if (ret)

Shouldn't you have to unregister both banks devices here in the error path?

Also, ret is not declared so this patch will cause a compile error, breaking
git bisect-ability.

> +		return ret;
> +
> +	mfc_dev->dma_base[BANK1_CTX] = mfc_dev->fw_buf.dma;

Same comment than before, probably you wanted to use fw_buf->dma here?

The rest of the patch looks good to me. 

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
