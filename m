Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:49489 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab3B0TW0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 14:22:26 -0500
Received: by mail-qa0-f49.google.com with SMTP id o13so756772qaj.15
        for <linux-media@vger.kernel.org>; Wed, 27 Feb 2013 11:22:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1361965796-16117-2-git-send-email-vikas.sajjan@linaro.org>
References: <1361965796-16117-1-git-send-email-vikas.sajjan@linaro.org> <1361965796-16117-2-git-send-email-vikas.sajjan@linaro.org>
From: =?ISO-8859-1?Q?St=E9phane_Marchesin?=
	<stephane.marchesin@gmail.com>
Date: Wed, 27 Feb 2013 11:21:46 -0800
Message-ID: <CACP_E+JkXNQ2DYecSgfCc6UJvmuo9-Afju9DwYK5Sh0ffvCs7g@mail.gmail.com>
Subject: Re: [PATCH v8 1/2] video: drm: exynos: Add display-timing node
 parsing using video helper function
To: Vikas Sajjan <vikas.sajjan@linaro.org>
Cc: dri-devel@lists.freedesktop.org, kgene.kim@samsung.com,
	linaro-dev@lists.linaro.org, patches@linaro.org,
	l.krishna@samsung.com, joshi@samsung.com,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 27, 2013 at 3:49 AM, Vikas Sajjan <vikas.sajjan@linaro.org> wrote:
> Add support for parsing the display-timing node using video helper
> function.
>
> The DT node parsing and pinctrl selection is done only if 'dev.of_node'
> exists and the NON-DT logic is still maintained under the 'else' part.
>
> Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_fimd.c |   25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> index 9537761..7932dc2 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> @@ -20,6 +20,7 @@
>  #include <linux/of_device.h>
>  #include <linux/pm_runtime.h>
>
> +#include <video/of_display_timing.h>
>  #include <video/samsung_fimd.h>
>  #include <drm/exynos_drm.h>
>
> @@ -883,10 +884,26 @@ static int fimd_probe(struct platform_device *pdev)
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
> +               ret = of_get_fb_videomode(dev->of_node, &pdata->panel.timing,
> +                                       OF_USE_NATIVE_MODE);
> +               if (ret) {
> +                       DRM_ERROR("failed: of_get_fb_videomode()\n"
> +                               "with return value: %d\n", ret);
> +                       return ret;

Here I think you leak pdata in the error path.

Stéphane

> +               }
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
