Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:14477 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758898Ab3BTLPk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Feb 2013 06:15:40 -0500
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MII00HE9N9WEHM0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 20 Feb 2013 20:15:38 +0900 (KST)
Received: from NOINKIDAE02 ([10.90.8.52])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MII00JQPNA2YS60@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 20 Feb 2013 20:15:38 +0900 (KST)
From: Inki Dae <inki.dae@samsung.com>
To: 'Vikas Sajjan' <vikas.sajjan@linaro.org>,
	dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	l.krishna@samsung.com, patches@linaro.org
References: <1360910587-25548-1-git-send-email-vikas.sajjan@linaro.org>
 <1360910587-25548-2-git-send-email-vikas.sajjan@linaro.org>
In-reply-to: <1360910587-25548-2-git-send-email-vikas.sajjan@linaro.org>
Subject: RE: [PATCH v6 1/1] video: drm: exynos: Add display-timing node parsing
 using video helper function
Date: Wed, 20 Feb 2013 20:15:37 +0900
Message-id: <022e01ce0f5b$9c6be3c0$d543ab40$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Vikas Sajjan [mailto:vikas.sajjan@linaro.org]
> Sent: Friday, February 15, 2013 3:43 PM
> To: dri-devel@lists.freedesktop.org
> Cc: linux-media@vger.kernel.org; kgene.kim@samsung.com;
> inki.dae@samsung.com; l.krishna@samsung.com; patches@linaro.org
> Subject: [PATCH v6 1/1] video: drm: exynos: Add display-timing node
> parsing using video helper function
> 
> Add support for parsing the display-timing node using video helper
> function.
> 
> The DT node parsing and pinctrl selection is done only if 'dev.of_node'
> exists and the NON-DT logic is still maintained under the 'else' part.
> 
> Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_fimd.c |   37
> ++++++++++++++++++++++++++----
>  1 file changed, 33 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> index 9537761..8b2c0ff 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> @@ -19,7 +19,9 @@
>  #include <linux/clk.h>
>  #include <linux/of_device.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/pinctrl/consumer.h>
> 
> +#include <video/of_display_timing.h>
>  #include <video/samsung_fimd.h>
>  #include <drm/exynos_drm.h>
> 
> @@ -877,16 +879,43 @@ static int fimd_probe(struct platform_device *pdev)
>  	struct exynos_drm_subdrv *subdrv;
>  	struct exynos_drm_fimd_pdata *pdata;
>  	struct exynos_drm_panel_info *panel;
> +	struct fb_videomode *fbmode;
> +	struct pinctrl *pctrl;
>  	struct resource *res;
>  	int win;
>  	int ret = -EINVAL;
> 
>  	DRM_DEBUG_KMS("%s\n", __FILE__);
> 
> -	pdata = pdev->dev.platform_data;
> -	if (!pdata) {
> -		dev_err(dev, "no platform data specified\n");
> -		return -EINVAL;
> +	if (pdev->dev.of_node) {
> +		pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> +		if (!pdata) {
> +			DRM_ERROR("memory allocation for pdata failed\n");
> +			return -ENOMEM;
> +		}
> +
> +		fbmode = &pdata->panel.timing;
> +		ret = of_get_fb_videomode(dev->of_node, fbmode,
> +					OF_USE_NATIVE_MODE);
> +		if (ret) {
> +			DRM_ERROR("failed: of_get_fb_videomode()\n"
> +				"with return value: %d\n", ret);
> +			return ret;
> +		}
> +
> +		pctrl = devm_pinctrl_get_select_default(dev);

Why does it need pinctrl? and even though needed, I think this should be
separated into another one.

Thanks,
Inki Dae

> +		if (IS_ERR_OR_NULL(pctrl)) {
> +			DRM_ERROR("failed:
> devm_pinctrl_get_select_default()\n"
> +				"with return value: %d\n", PTR_RET(pctrl));
> +			return PTR_RET(pctrl);
> +		}
> +
> +	} else {
> +		pdata = pdev->dev.platform_data;
> +		if (!pdata) {
> +			DRM_ERROR("no platform data specified\n");
> +			return -EINVAL;
> +		}
>  	}
> 
>  	panel = &pdata->panel;
> --
> 1.7.9.5

