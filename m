Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:57686 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322Ab3BODU0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Feb 2013 22:20:26 -0500
Received: by mail-wg0-f52.google.com with SMTP id 12so2374402wgh.31
        for <linux-media@vger.kernel.org>; Thu, 14 Feb 2013 19:20:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1360124655-22902-2-git-send-email-vikas.sajjan@linaro.org>
References: <1360124655-22902-1-git-send-email-vikas.sajjan@linaro.org>
	<1360124655-22902-2-git-send-email-vikas.sajjan@linaro.org>
Date: Fri, 15 Feb 2013 12:20:24 +0900
Message-ID: <CAAQKjZNoY2cXXc2b3AUiU0mmUKqgOd4MA_CjUe+tr0H4WN1htg@mail.gmail.com>
Subject: Re: [PATCH v5 1/1] video: drm: exynos: Add display-timing node
 parsing using video helper function
From: Inki Dae <inki.dae@samsung.com>
To: Vikas Sajjan <vikas.sajjan@linaro.org>
Cc: dri-devel@lists.freedesktop.org, l.krishna@samsung.com,
	kgene.kim@samsung.com, paulepanter@users.sourceforge.net,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2013/2/6 Vikas Sajjan <vikas.sajjan@linaro.org>:
> Add support for parsing the display-timing node using video helper
> function.
>
> The DT node parsing and pinctrl selection is done only if 'dev.of_node'
> exists and the NON-DT logic is still maintained under the 'else' part.
>
> Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_fimd.c |   41 +++++++++++++++++++++++++++---
>  1 file changed, 37 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> index bf0d9ba..978e866 100644
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
> @@ -905,16 +906,48 @@ static int __devinit fimd_probe(struct platform_device *pdev)
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

It doesn't need to allocate fbmode.

> +
> +               ret = of_get_fb_videomode(dev->of_node, fbmode, -1);

What is -1? use OF_USE_NATIVE_MODE instead including
"of_display_timing.h" and just change the above code like below,

                   fbmode = &pdata->panel.timing;
                   ret = of_get_fb_videomode(dev->of_node, fbmode,
OF_USE_NATIVE_MODE);

> +               if (ret) {
> +                       DRM_ERROR("failed: of_get_fb_videomode()\n"
> +                               "with return value: %d\n", ret);
> +                       return ret;
> +               }
> +               pdata->panel.timing = (struct fb_videomode) *fbmode;

remove the above line.

> +
> +               pctrl = devm_pinctrl_get_select_default(dev);
> +               if (IS_ERR_OR_NULL(pctrl)) {
> +                       DRM_ERROR("failed: devm_pinctrl_get_select_default()\n"
> +                               "with return value: %d\n", PTR_RET(pctrl));
> +                       return PTR_RET(pctrl);
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
