Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:38326 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab3A3Iuo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 03:50:44 -0500
Received: by mail-ea0-f175.google.com with SMTP id d1so556041eab.20
        for <linux-media@vger.kernel.org>; Wed, 30 Jan 2013 00:50:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1359107722-9974-2-git-send-email-sachin.kamat@linaro.org>
References: <1359107722-9974-1-git-send-email-sachin.kamat@linaro.org>
	<1359107722-9974-2-git-send-email-sachin.kamat@linaro.org>
Date: Wed, 30 Jan 2013 17:50:43 +0900
Message-ID: <CAAQKjZNc0xFaoaqtKsLC=Evn60XA5UChtoMLAcgsWqyLNa7ejQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm/exynos: Add device tree based discovery support
 for G2D
From: Inki Dae <inki.dae@samsung.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	devicetree-discuss@lists.ozlabs.org, patches@linaro.org,
	s.nawrocki@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2013/1/25 Sachin Kamat <sachin.kamat@linaro.org>:
> From: Ajay Kumar <ajaykumar.rs@samsung.com>
>
> This patch adds device tree match table for Exynos G2D controller.
>
> Signed-off-by: Ajay Kumar <ajaykumar.rs@samsung.com>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_g2d.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_g2d.c b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
> index ddcfb5d..d24b170 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_g2d.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
> @@ -19,6 +19,7 @@
>  #include <linux/workqueue.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/dma-attrs.h>
> +#include <linux/of.h>
>
>  #include <drm/drmP.h>
>  #include <drm/exynos_drm.h>
> @@ -1240,6 +1241,14 @@ static int g2d_resume(struct device *dev)
>
>  static SIMPLE_DEV_PM_OPS(g2d_pm_ops, g2d_suspend, g2d_resume);
>
> +#ifdef CONFIG_OF
> +static const struct of_device_id exynos_g2d_match[] = {
> +       { .compatible = "samsung,g2d-v41" },

not only Exynos5 and also Exyno4 has the g2d gpu and drm-based g2d
driver shoud support for all Exynos SoCs. How about using
"samsung,exynos5-g2d" instead and adding a new property 'version' to
identify ip version more surely? With this, we could know which SoC
and its g2d ip version. The version property could have '0x14' or
others. And please add descriptions to dt document.

> +       {},
> +};
> +MODULE_DEVICE_TABLE(of, exynos_g2d_match);
> +#endif
> +
>  struct platform_driver g2d_driver = {
>         .probe          = g2d_probe,
>         .remove         = g2d_remove,
> @@ -1247,5 +1256,6 @@ struct platform_driver g2d_driver = {
>                 .name   = "s5p-g2d",
>                 .owner  = THIS_MODULE,
>                 .pm     = &g2d_pm_ops,
> +               .of_match_table = of_match_ptr(exynos_g2d_match),
>         },
>  };
> --
> 1.7.4.1
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
