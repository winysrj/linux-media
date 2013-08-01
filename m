Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:56205 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab3HAXUg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Aug 2013 19:20:36 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Vikas Sajjan <vikas.sajjan@linaro.org>
Cc: linux-samsung-soc@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, kgene.kim@samsung.com,
	inki.dae@samsung.com, arun.kk@samsung.com, patches@linaro.org,
	linaro-kernel@lists.linaro.org
Subject: Re: [PATCH] drm/exynos: Add check for IOMMU while passing physically continous memory flag
Date: Fri, 02 Aug 2013 01:20:30 +0200
Message-ID: <5151790.EBRlE0cTxf@flatron>
In-Reply-To: <1375355972-25276-1-git-send-email-vikas.sajjan@linaro.org>
References: <1375355972-25276-1-git-send-email-vikas.sajjan@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikas,

On Thursday 01 of August 2013 16:49:32 Vikas Sajjan wrote:
> While trying to get boot-logo up on exynos5420 SMDK which has eDP panel
> connected with resolution 2560x1600, following error occured even with
> IOMMU enabled:
> [0.880000] [drm:lowlevel_buffer_allocate] *ERROR* failed to allocate
> buffer. [0.890000] [drm] Initialized exynos 1.0.0 20110530 on minor 0
> 
> This patch fixes the issue by adding a check for IOMMU.
> 
> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
> Signed-off-by: Arun Kumar <arun.kk@samsung.com>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_fbdev.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
> b/drivers/gpu/drm/exynos/exynos_drm_fbdev.c index 8e60bd6..2a86666
> 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
> @@ -16,6 +16,7 @@
>  #include <drm/drm_crtc.h>
>  #include <drm/drm_fb_helper.h>
>  #include <drm/drm_crtc_helper.h>
> +#include <drm/exynos_drm.h>
> 
>  #include "exynos_drm_drv.h"
>  #include "exynos_drm_fb.h"
> @@ -143,6 +144,7 @@ static int exynos_drm_fbdev_create(struct
> drm_fb_helper *helper, struct platform_device *pdev = dev->platformdev;
>  	unsigned long size;
>  	int ret;
> +	unsigned int flag;
> 
>  	DRM_DEBUG_KMS("surface width(%d), height(%d) and bpp(%d\n",
>  			sizes->surface_width, sizes->surface_height,
> @@ -166,7 +168,12 @@ static int exynos_drm_fbdev_create(struct
> drm_fb_helper *helper, size = mode_cmd.pitches[0] * mode_cmd.height;
> 
>  	/* 0 means to allocate physically continuous memory */
> -	exynos_gem_obj = exynos_drm_gem_create(dev, 0, size);
> +	if (!is_drm_iommu_supported(dev))
> +		flag = 0;
> +	else
> +		flag = EXYNOS_BO_NONCONTIG;

While noncontig memory might be used for devices that support IOMMU, there 
should be no problem with using contig memory for them, so this seems more 
like masking the original problem rather than tracking it down.

Could you check why the allocation fails when requesting contiguous 
memory?

Best regards,
Tomasz

