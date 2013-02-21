Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:27491 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab3BUHFf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Feb 2013 02:05:35 -0500
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MIK00G5O6D5AXT0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 21 Feb 2013 16:05:34 +0900 (KST)
Received: from [10.90.51.60] by mmp2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MIK00LHC6DAI3K0@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 21 Feb 2013 16:05:34 +0900 (KST)
Message-id: <5125C74F.3000705@samsung.com>
Date: Thu, 21 Feb 2013 16:05:51 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
MIME-version: 1.0
To: Vikas Sajjan <vikas.sajjan@linaro.org>
Cc: dri-devel@lists.freedesktop.org, l.krishna@samsung.com,
	kgene.kim@samsung.com, linux-media@vger.kernel.org
Subject: Re: [PATCH v7 2/2] video: drm: exynos: Add pinctrl support to fimd
References: <1361423512-2882-1-git-send-email-vikas.sajjan@linaro.org>
 <1361423512-2882-3-git-send-email-vikas.sajjan@linaro.org>
In-reply-to: <1361423512-2882-3-git-send-email-vikas.sajjan@linaro.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 02/21/2013 02:11 PM, Vikas Sajjan wrote:
> Adds support for pinctrl to drm fimd.
>
> Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
> ---
>   drivers/gpu/drm/exynos/exynos_drm_fimd.c |    9 +++++++++
>   1 file changed, 9 insertions(+)
>
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> index f80cf68..878b134 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> @@ -19,6 +19,7 @@
>   #include <linux/clk.h>
>   #include <linux/of_device.h>
>   #include <linux/pm_runtime.h>
> +#include <linux/pinctrl/consumer.h>
>   
>   #include <video/of_display_timing.h>
>   #include <video/samsung_fimd.h>
> @@ -879,6 +880,7 @@ static int fimd_probe(struct platform_device *pdev)
>   	struct exynos_drm_fimd_pdata *pdata;
>   	struct exynos_drm_panel_info *panel;
>   	struct fb_videomode *fbmode;
> +	struct pinctrl *pctrl;
>   	struct resource *res;
>   	int win;
>   	int ret = -EINVAL;
> @@ -900,6 +902,13 @@ static int fimd_probe(struct platform_device *pdev)
>   				"with return value: %d\n", ret);
>   			return ret;
>   		}
> +		pctrl = devm_pinctrl_get_select_default(dev);
> +		if (IS_ERR_OR_NULL(pctrl)) {
> +			DRM_ERROR("failed: devm_pinctrl_get_select_default()\n"
> +				"with return value: %d\n", PTR_RET(pctrl));
> +			return PTR_RET(pctrl);
> +		}

I think pinctrl isn't related with dt then it doesn't need to be in "if 
(pdev->dev.of_node)".

> +

Blank.

>   	} else {
>   		pdata = pdev->dev.platform_data;
>   		if (!pdata) {

