Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:47441 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab3BAPgT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 10:36:19 -0500
Received: by mail-la0-f47.google.com with SMTP id fj20so2860918lab.6
        for <linux-media@vger.kernel.org>; Fri, 01 Feb 2013 07:36:17 -0800 (PST)
Received: by mail-lb0-f170.google.com with SMTP id ge1so4703486lbb.15
        for <linux-media@vger.kernel.org>; Fri, 01 Feb 2013 07:36:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1359719989-29628-2-git-send-email-vikas.sajjan@linaro.org>
References: <1359719989-29628-1-git-send-email-vikas.sajjan@linaro.org> <1359719989-29628-2-git-send-email-vikas.sajjan@linaro.org>
From: Sean Paul <seanpaul@chromium.org>
Date: Fri, 1 Feb 2013 10:35:54 -0500
Message-ID: <CAOw6vbLxHFfVQ6WoWL_ZEJsb3yrW1Lv=idh3+WfaBoAi+k3UVQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] video: drm: exynos: Adds display-timing node
 parsing using video helper function
To: Vikas Sajjan <vikas.sajjan@linaro.org>
Cc: dri-devel@lists.freedesktop.org,
	Leelakrishna A <l.krishna@samsung.com>,
	"kgene.kim" <kgene.kim@samsung.com>, s.trumtrar@pengutronix.de,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 1, 2013 at 6:59 AM, Vikas Sajjan <vikas.sajjan@linaro.org> wrote:
> This patch adds display-timing node parsing using video helper function
>
> Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_fimd.c |   39 +++++++++++++++++++++++++++---
>  1 file changed, 35 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> index bf0d9ba..8eee13f 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> @@ -19,6 +19,7 @@
>  #include <linux/clk.h>
>  #include <linux/of_device.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/pinctrl/consumer.h>
>
>  #include <video/samsung_fimd.h>
>  #include <drm/exynos_drm.h>
> @@ -905,16 +906,46 @@ static int __devinit fimd_probe(struct platform_device *pdev)
>         struct exynos_drm_subdrv *subdrv;
>         struct exynos_drm_fimd_pdata *pdata;
>         struct exynos_drm_panel_info *panel;
> +       struct fb_videomode *fbmode;
> +       struct pinctrl *pctrl;
>         struct resource *res;
>         int win;
>         int ret = -EINVAL;
>
>         DRM_DEBUG_KMS("%s\n", __FILE__);
>
> -       pdata = pdev->dev.platform_data;
> -       if (!pdata) {
> -               dev_err(dev, "no platform data specified\n");
> -               return -EINVAL;
> +       if (pdev->dev.of_node) {
> +               pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> +               if (!pdata) {
> +                       DRM_ERROR("memory allocation for pdata failed\n");
> +                       return -ENOMEM;
> +               }
> +
> +               fbmode = devm_kzalloc(dev, sizeof(*fbmode), GFP_KERNEL);
> +               if (!fbmode) {
> +                       DRM_ERROR("memory allocation for fbmode failed\n");
> +                       return -ENOMEM;
> +               }
> +
> +               ret = of_get_fb_videomode(dev->of_node, fbmode, -1);
> +               if (ret) {
> +                       DRM_ERROR("failed to get fb_videomode\n");
> +                       return -EINVAL;

This should probably return ret instead of -EINVAL. It would also be
useful to print ret in the error msg.

> +               }
> +               pdata->panel.timing = (struct fb_videomode) *fbmode;
> +
> +               pctrl = devm_pinctrl_get_select_default(dev);
> +               if (IS_ERR(pctrl)) {
> +                       DRM_ERROR("no pinctrl data provided.\n");
> +                       return -EINVAL;

I think the error message here is misleading. If there's no pinctrl
provided, doesn't get_select_default return NULL? In which case, this
error would never be printed?

I think this behavior is actually desired since there is no pinctrl
for exynos5 and we don't want it to break. However I think your error
should be more along the lines of "pinctrl_get_select_default failed".
You should also print and return PTR_RET(pctrl) instead of EINVAL.

Sean

> +               }
> +
> +       } else {
> +               pdata = pdev->dev.platform_data;
> +               if (!pdata) {
> +                       DRM_ERROR("no platform data specified\n");
> +                       return -EINVAL;
> +               }
>         }
>
>         panel = &pdata->panel;
> --
> 1.7.9.5
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
