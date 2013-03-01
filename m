Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:65217 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab3CAJdV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2013 04:33:21 -0500
Received: by mail-we0-f182.google.com with SMTP id t57so2323919wey.41
        for <linux-media@vger.kernel.org>; Fri, 01 Mar 2013 01:33:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1362116080-20063-3-git-send-email-vikas.sajjan@linaro.org>
References: <1362116080-20063-1-git-send-email-vikas.sajjan@linaro.org>
	<1362116080-20063-3-git-send-email-vikas.sajjan@linaro.org>
Date: Fri, 1 Mar 2013 15:03:19 +0530
Message-ID: <CAGm_ybjtwN_XnaFye7dbq5CdsWKw+kA98P=0pmiwSarG9XY=ZQ@mail.gmail.com>
Subject: Re: [PATCH v10 2/2] video: drm: exynos: Add pinctrl support to fimd
From: Vikas Sajjan <sajjan.linux@gmail.com>
To: Vikas Sajjan <vikas.sajjan@linaro.org>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	kgene.kim@samsung.com, inki.dae@samsung.com, l.krishna@samsung.com,
	jy0922.shim@samsung.com, sylvester.nawrocki@gmail.com,
	Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

On Fri, Mar 1, 2013 at 11:04 AM, Vikas Sajjan <vikas.sajjan@linaro.org> wrote:
> Adds support for pinctrl to drm fimd
>
> Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_fimd.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> index e323cf9..c00aa4a 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> @@ -19,6 +19,7 @@
>  #include <linux/clk.h>
>  #include <linux/of_device.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/pinctrl/consumer.h>
>
>  #include <video/of_display_timing.h>
>  #include <video/samsung_fimd.h>
> @@ -879,6 +880,7 @@ static int fimd_probe(struct platform_device *pdev)
>         struct exynos_drm_fimd_pdata *pdata;
>         struct exynos_drm_panel_info *panel;
>         struct resource *res;
> +       struct pinctrl *pctrl;
>         int win;
>         int ret = -EINVAL;
>
> @@ -897,6 +899,13 @@ static int fimd_probe(struct platform_device *pdev)
>                         DRM_ERROR("failed: of_get_fb_videomode() : %d\n", ret);
>                         return ret;
>                 }
> +               pctrl = devm_pinctrl_get_select_default(dev);

This patch is abandoned, as the device core will do this for you as of commit
ab78029ecc347debbd737f06688d788bd9d60c1d
"drivers/pinctrl: grab default handles from device core"

> +               if (IS_ERR(pctrl)) {
> +                       DRM_ERROR("failed: devm_pinctrl_get_select_default():\n"
> +                               "%d\n", PTR_RET(pctrl));
> +                       return PTR_ERR(pctrl);
> +               }
> +
>         } else {
>                 pdata = pdev->dev.platform_data;
>                 if (!pdata) {
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
