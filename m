Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57050
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932757AbdBQVNP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 16:13:15 -0500
Subject: Re: [PATCH 14/15] media: s5p-mfc: Use preallocated block allocator
 always for MFC v6+
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170214075221eucas1p1c0acfa79289ebff6306c01e47c3e83a7@eucas1p1.samsung.com>
 <1487058728-16501-15-git-send-email-m.szyprowski@samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Message-ID: <99bd8023-2d89-c1f5-5554-ad3de82f1372@osg.samsung.com>
Date: Fri, 17 Feb 2017 18:13:06 -0300
MIME-Version: 1.0
In-Reply-To: <1487058728-16501-15-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marek,

On 02/14/2017 04:52 AM, Marek Szyprowski wrote:
> It turned out that all versions of MFC v6+ hardware doesn't have a strict
> requirement for ALL buffers to be allocated on higher addresses than the
> firmware base like it was documented for MFC v5. This requirement is true
> only for the device and per-context buffers. All video data buffers can be
> allocated anywhere for all MFC v6+ versions. Basing on this fact, the
> special DMA configuration based on two reserved memory regions is not
> really needed for MFC v6+ devices, because the memory requirements for the
> firmware, device and per-context buffers can be fulfilled by the simple
> probe-time pre-allocated block allocator instroduced in previous patch.

s/instroduced/introduced

> 
> This patch enables support for such pre-allocated block based allocator
> always for MFC v6+ devices. Due to the limitations of the memory management
> subsystem the largest supported size of the pre-allocated buffer when no
> CMA (Contiguous Memory Allocator) is enabled is 4MiB.
> 
> This patch also removes the requirement to provide two reserved memory
> regions for MFC v6+ devices in device tree. Now the driver is fully
> functional without them.
>

Great!

> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---

The patch looks good to me though and it works on my tests,
I've just one comment below.

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>

>  Documentation/devicetree/bindings/media/s5p-mfc.txt | 2 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc.c            | 9 ++++++---
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/s5p-mfc.txt b/Documentation/devicetree/bindings/media/s5p-mfc.txt
> index 2c901286d818..d3404b5d4d17 100644
> --- a/Documentation/devicetree/bindings/media/s5p-mfc.txt
> +++ b/Documentation/devicetree/bindings/media/s5p-mfc.txt
> @@ -28,7 +28,7 @@ Optional properties:
>    - memory-region : from reserved memory binding: phandles to two reserved
>  	memory regions, first is for "left" mfc memory bus interfaces,
>  	second if for the "right" mfc memory bus, used when no SYSMMU
> -	support is available
> +	support is available; used only by MFC v5 present in Exynos4 SoCs
>  
>  Obsolete properties:
>    - samsung,mfc-r, samsung,mfc-l : support removed, please use memory-region
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index 8fc6fe4ba087..36f0aec2a1b3 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -1178,9 +1178,12 @@ static void s5p_mfc_unconfigure_2port_memory(struct s5p_mfc_dev *mfc_dev)
>  static int s5p_mfc_configure_common_memory(struct s5p_mfc_dev *mfc_dev)
>  {
>  	struct device *dev = &mfc_dev->plat_dev->dev;
> -	unsigned long mem_size = SZ_8M;
> +	unsigned long mem_size = SZ_4M;
>  	unsigned int bitmap_size;
>  
> +	if (IS_ENABLED(CONFIG_DMA_CMA) || exynos_is_iommu_available(dev))
> +		mem_size = SZ_8M;
> +
>  	if (mfc_mem_size)
>  		mem_size = memparse(mfc_mem_size, NULL);
> 

The driver allows the user to set mem_size > SZ_4M using the s5p_mfc.mem
parameter even when CMA ins't enabled and IOMMU isn't available. Maybe it
should fail early instead and notify the user what's missing?

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
