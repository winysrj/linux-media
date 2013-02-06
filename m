Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:61680 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab3BFHc0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 02:32:26 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MHS005YIFLPHKR0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Feb 2013 16:32:24 +0900 (KST)
Received: from NOINKIDAE02 ([10.90.8.52])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MHS00081FLZ1W70@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Feb 2013 16:32:24 +0900 (KST)
From: Inki Dae <inki.dae@samsung.com>
To: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	devicetree-discuss@lists.ozlabs.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com,
	kgene.kim@samsung.com, patches@linaro.org,
	'Ajay Kumar' <ajaykumar.rs@samsung.com>
References: <1360128584-23167-1-git-send-email-sachin.kamat@linaro.org>
 <1360128584-23167-2-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1360128584-23167-2-git-send-email-sachin.kamat@linaro.org>
Subject: RE: [PATCH v2 2/2] drm/exynos: Add device tree based discovery support
 for G2D
Date: Wed, 06 Feb 2013 16:32:23 +0900
Message-id: <02a301ce043c$1b12d150$513873f0$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
> Sent: Wednesday, February 06, 2013 2:30 PM
> To: linux-media@vger.kernel.org; dri-devel@lists.freedesktop.org;
> devicetree-discuss@lists.ozlabs.org
> Cc: k.debski@samsung.com; sachin.kamat@linaro.org; inki.dae@samsung.com;
> s.nawrocki@samsung.com; kgene.kim@samsung.com; patches@linaro.org; Ajay
> Kumar
> Subject: [PATCH v2 2/2] drm/exynos: Add device tree based discovery
> support for G2D
> 
> From: Ajay Kumar <ajaykumar.rs@samsung.com>
> 
> This patch adds device tree match table for Exynos G2D controller.
> 
> Signed-off-by: Ajay Kumar <ajaykumar.rs@samsung.com>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
> Patch based on exynos-drm-fixes branch of Inki Dae's tree:
> git://git.kernel.org/pub/scm/linux/kernel/git/daeinki/drm-exynos.git
> 
> Changes since v1:
> Modified the compatible string as per the discussions at [1].
> [1] https://patchwork1.kernel.org/patch/2045821/
> ---
>  drivers/gpu/drm/exynos/exynos_drm_g2d.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_g2d.c
> b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
> index ddcfb5d..0fcfbe4 100644
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
> +	{ .compatible = "samsung,exynos5250-g2d" },

Looks good to me but please add document for it.

To other guys,
And is there anyone who know where this document should be added to?
I'm not sure that the g2d document should be placed in
Documentation/devicetree/bindings/gpu, media, drm/exynos or arm/exynos. At
least, this document should be shared with the g2d hw relevant drivers such
as v4l2 and drm. So is ".../bindings/gpu" proper place?

Thanks,
Inki Dae

> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, exynos_g2d_match);
> +#endif
> +
>  struct platform_driver g2d_driver = {
>  	.probe		= g2d_probe,
>  	.remove		= g2d_remove,
> @@ -1247,5 +1256,6 @@ struct platform_driver g2d_driver = {
>  		.name	= "s5p-g2d",
>  		.owner	= THIS_MODULE,
>  		.pm	= &g2d_pm_ops,
> +		.of_match_table = of_match_ptr(exynos_g2d_match),
>  	},
>  };
> --
> 1.7.4.1

