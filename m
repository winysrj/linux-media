Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:48807 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab3HEONO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 10:13:14 -0400
MIME-Version: 1.0
In-Reply-To: <1375695882-16004-1-git-send-email-vikas.sajjan@linaro.org>
References: <1375695882-16004-1-git-send-email-vikas.sajjan@linaro.org>
Date: Mon, 5 Aug 2013 10:13:13 -0400
Message-ID: <CAF6AEGt4FzWOk+8XWZfptwrNf=obCO7oCrZm0S_tUAN7kDSjTA@mail.gmail.com>
Subject: Re: [PATCH V2] drm/exynos: Add fallback option to get non physically
 continous memory for fb
From: Rob Clark <robdclark@gmail.com>
To: Vikas Sajjan <vikas.sajjan@linaro.org>
Cc: linux-samsung-soc@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, kgene.kim@samsung.com,
	inki.dae@samsung.com, s.nawrocki@samsung.com,
	m.szyprowski@samsung.com, tomasz.figa@gmail.com,
	arun.kk@samsung.com, patches@linaro.org,
	linaro-kernel@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 5, 2013 at 5:44 AM, Vikas Sajjan <vikas.sajjan@linaro.org> wrote:
> While trying to get boot-logo up on exynos5420 SMDK which has eDP panel
> connected with resolution 2560x1600, following error occured even with
> IOMMU enabled:
> [0.880000] [drm:lowlevel_buffer_allocate] *ERROR* failed to allocate buffer.
> [0.890000] [drm] Initialized exynos 1.0.0 20110530 on minor 0
>
> To address the case where physically continous memory MAY NOT be a
> mandatory requirement for fb, the patch adds a feature to get non physically
> continous memory for fb if IOMMU is supported and if CONTIG memory allocation
> fails.


Reviewed-by: Rob Clark <robdclark@gmail.com>

>
> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
> Signed-off-by: Arun Kumar <arun.kk@samsung.com>
> ---
> changes since v1:
>          - Modified to add the fallback patch if CONTIG alloc fails as suggested
>          by Rob Clark robdclark@gmail.com and Tomasz Figa <tomasz.figa@gmail.com>.
>
>          - changed the commit message.
> ---
>  drivers/gpu/drm/exynos/exynos_drm_fbdev.c |   19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fbdev.c b/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
> index 8e60bd6..9a4b886 100644
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
> @@ -165,11 +166,21 @@ static int exynos_drm_fbdev_create(struct drm_fb_helper *helper,
>
>         size = mode_cmd.pitches[0] * mode_cmd.height;
>
> -       /* 0 means to allocate physically continuous memory */
> -       exynos_gem_obj = exynos_drm_gem_create(dev, 0, size);
> +       exynos_gem_obj = exynos_drm_gem_create(dev, EXYNOS_BO_CONTIG, size);
>         if (IS_ERR(exynos_gem_obj)) {
> -               ret = PTR_ERR(exynos_gem_obj);
> -               goto err_release_framebuffer;
> +               /*
> +                * If IOMMU is supported then try to get buffer from
> +                * non-continous memory area
> +                */
> +               if (is_drm_iommu_supported(dev))
> +                       exynos_gem_obj = exynos_drm_gem_create(dev,
> +                                               EXYNOS_BO_NONCONTIG, size);
> +               if (IS_ERR(exynos_gem_obj)) {
> +                       ret = PTR_ERR(exynos_gem_obj);
> +                       goto err_release_framebuffer;
> +               }
> +               dev_warn(&pdev->dev, "exynos_gem_obj for FB is allocated with\n"
> +                               "non physically continuous memory\n");
>         }
>
>         exynos_fbdev->exynos_gem_obj = exynos_gem_obj;
> --
> 1.7.9.5
>
