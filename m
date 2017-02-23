Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:35145 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751199AbdBWVnG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Feb 2017 16:43:06 -0500
MIME-Version: 1.0
In-Reply-To: <1487058728-16501-15-git-send-email-m.szyprowski@samsung.com>
References: <CGME20170214075221eucas1p1c0acfa79289ebff6306c01e47c3e83a7@eucas1p1.samsung.com>
 <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com> <1487058728-16501-15-git-send-email-m.szyprowski@samsung.com>
From: Shuah Khan <shuahkhan@gmail.com>
Date: Thu, 23 Feb 2017 14:43:05 -0700
Message-ID: <CAKocOOO+JLD7pcL2A-8adi1hwDjw55Y2jMQ3Ki6oVTWdSn1W+A@mail.gmail.com>
Subject: Re: [PATCH 14/15] media: s5p-mfc: Use preallocated block allocator
 always for MFC v6+
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>, shuahkh@osg.samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 14, 2017 at 12:52 AM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> It turned out that all versions of MFC v6+ hardware doesn't have a strict
> requirement for ALL buffers to be allocated on higher addresses than the
> firmware base like it was documented for MFC v5. This requirement is true
> only for the device and per-context buffers. All video data buffers can be
> allocated anywhere for all MFC v6+ versions. Basing on this fact, the
> special DMA configuration based on two reserved memory regions is not
> really needed for MFC v6+ devices, because the memory requirements for the
> firmware, device and per-context buffers can be fulfilled by the simple
> probe-time pre-allocated block allocator instroduced in previous patch.
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
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Hi Marek,

This patch breaks display manager. exynos_drm_gem_create() isn't happy.
dmesg and console are flooded with

odroid login: [  209.170566] [drm:exynos_drm_gem_create] *ERROR* failed to allo.
[  212.173222] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
[  215.354790] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
[  218.736464] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
[  221.837128] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
[  226.284827] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
[  229.242498] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
[  232.063150] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
[  235.799993] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
[  239.472061] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
[  242.567465] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
[  246.500541] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
[  249.996018] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
[  253.837272] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
[  257.048782] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
[  260.084819] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
[  263.448611] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
[  266.271074] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
[  269.011558] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
[  272.039066] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
[  275.404938] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
[  278.339033] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
[  281.274751] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
[  284.641202] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
[  287.461039] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
[  291.062011] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
[  294.746870] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
[  298.246570] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.

I don't think this is an acceptable behavior. It is a regression.

thanks,
-- Shuah

> ---
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
>         memory regions, first is for "left" mfc memory bus interfaces,
>         second if for the "right" mfc memory bus, used when no SYSMMU
> -       support is available
> +       support is available; used only by MFC v5 present in Exynos4 SoCs
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
>         struct device *dev = &mfc_dev->plat_dev->dev;
> -       unsigned long mem_size = SZ_8M;
> +       unsigned long mem_size = SZ_4M;
>         unsigned int bitmap_size;
>
> +       if (IS_ENABLED(CONFIG_DMA_CMA) || exynos_is_iommu_available(dev))
> +               mem_size = SZ_8M;
> +
>         if (mfc_mem_size)
>                 mem_size = memparse(mfc_mem_size, NULL);
>
> @@ -1240,7 +1243,7 @@ static int s5p_mfc_configure_dma_memory(struct s5p_mfc_dev *mfc_dev)
>  {
>         struct device *dev = &mfc_dev->plat_dev->dev;
>
> -       if (exynos_is_iommu_available(dev))
> +       if (exynos_is_iommu_available(dev) || !IS_TWOPORT(mfc_dev))
>                 return s5p_mfc_configure_common_memory(mfc_dev);
>         else
>                 return s5p_mfc_configure_2port_memory(mfc_dev);
> @@ -1251,7 +1254,7 @@ static void s5p_mfc_unconfigure_dma_memory(struct s5p_mfc_dev *mfc_dev)
>         struct device *dev = &mfc_dev->plat_dev->dev;
>
>         s5p_mfc_release_firmware(mfc_dev);
> -       if (exynos_is_iommu_available(dev))
> +       if (exynos_is_iommu_available(dev) || !IS_TWOPORT(mfc_dev))
>                 s5p_mfc_unconfigure_common_memory(mfc_dev);
>         else
>                 s5p_mfc_unconfigure_2port_memory(mfc_dev);
> --
> 1.9.1
>
