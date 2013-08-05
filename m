Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:18450 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab3HEOUS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 10:20:18 -0400
From: Tomasz Figa <t.figa@samsung.com>
To: Vikas Sajjan <vikas.sajjan@linaro.org>
Cc: linux-samsung-soc@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, kgene.kim@samsung.com,
	inki.dae@samsung.com, s.nawrocki@samsung.com,
	m.szyprowski@samsung.com, tomasz.figa@gmail.com,
	robdclark@gmail.com, arun.kk@samsung.com, patches@linaro.org,
	linaro-kernel@lists.linaro.org
Subject: Re: [PATCH V2] drm/exynos: Add fallback option to get non physically
 continous memory for fb
Date: Mon, 05 Aug 2013 16:20:15 +0200
Message-id: <1755621.zBhZbpqAGX@amdc1227>
In-reply-to: <1375695882-16004-1-git-send-email-vikas.sajjan@linaro.org>
References: <1375695882-16004-1-git-send-email-vikas.sajjan@linaro.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 05 of August 2013 15:14:42 Vikas Sajjan wrote:
> While trying to get boot-logo up on exynos5420 SMDK which has eDP panel
> connected with resolution 2560x1600, following error occured even with
> IOMMU enabled:
> [0.880000] [drm:lowlevel_buffer_allocate] *ERROR* failed to allocate
> buffer. [0.890000] [drm] Initialized exynos 1.0.0 20110530 on minor 0
> 
> To address the case where physically continous memory MAY NOT be a
> mandatory requirement for fb, the patch adds a feature to get non
> physically continous memory for fb if IOMMU is supported and if CONTIG
> memory allocation fails.
> 
> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
> Signed-off-by: Arun Kumar <arun.kk@samsung.com>
> ---
> changes since v1:
> 	 - Modified to add the fallback patch if CONTIG alloc fails as suggested
> by Rob Clark robdclark@gmail.com and Tomasz Figa
> <tomasz.figa@gmail.com>.
> 
> 	 - changed the commit message.
> ---
>  drivers/gpu/drm/exynos/exynos_drm_fbdev.c |   19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
> b/drivers/gpu/drm/exynos/exynos_drm_fbdev.c index 8e60bd6..9a4b886
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
> @@ -165,11 +166,21 @@ static int exynos_drm_fbdev_create(struct
> drm_fb_helper *helper,
> 
>  	size = mode_cmd.pitches[0] * mode_cmd.height;
> 
> -	/* 0 means to allocate physically continuous memory */
> -	exynos_gem_obj = exynos_drm_gem_create(dev, 0, size);
> +	exynos_gem_obj = exynos_drm_gem_create(dev, EXYNOS_BO_CONTIG, size);

You can put the fallback here like this:
	if (IS_ERR(exynos_gem_obj) && is_drm_iommu_supported(dev)) {
		/*
		 * If IOMMU is supported then try to get buffer from
		 * non-continous memory area
		 */
		dev_warn(&pdev->dev, "contiguous FB allocation failed, falling back to non-contiguous\n");
		exynos_gem_obj = exynos_drm_gem_create(dev,
										EXYNOS_BO_NONCONTIG, size);
	}

>  	if (IS_ERR(exynos_gem_obj)) {
> -		ret = PTR_ERR(exynos_gem_obj);
> -		goto err_release_framebuffer;

And then you can leave this original check untouched, reducing the
diffstat and unnecessary code indentation.

> +		/*
> +		 * If IOMMU is supported then try to get buffer from
> +		 * non-continous memory area
> +		 */
> +		if (is_drm_iommu_supported(dev))
> +			exynos_gem_obj = exynos_drm_gem_create(dev,
> +						EXYNOS_BO_NONCONTIG, size);
> +		if (IS_ERR(exynos_gem_obj)) {
> +			ret = PTR_ERR(exynos_gem_obj);
> +			goto err_release_framebuffer;
> +		}
> +		dev_warn(&pdev->dev, "exynos_gem_obj for FB is allocated with\n"
> +				"non physically continuous memory\n");

Please don't split messages into multiple lines, because this makes
grepping for them harder (and checkpatch complains).

Best regards,
Tomasz

