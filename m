Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:33149 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab3B1Cgi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 21:36:38 -0500
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MIW00DJNSL1QJI0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 28 Feb 2013 11:36:37 +0900 (KST)
Message-id: <512EC2CC.2090605@samsung.com>
Date: Thu, 28 Feb 2013 11:37:00 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
MIME-version: 1.0
To: Vikas Sajjan <vikas.sajjan@linaro.org>
Cc: dri-devel@lists.freedesktop.org, kgene.kim@samsung.com,
	linaro-dev@lists.linaro.org, patches@linaro.org,
	l.krishna@samsung.com, joshi@samsung.com,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v8 1/2] video: drm: exynos: Add display-timing node parsing
 using video helper function
References: <1361965796-16117-1-git-send-email-vikas.sajjan@linaro.org>
 <1361965796-16117-2-git-send-email-vikas.sajjan@linaro.org>
In-reply-to: <1361965796-16117-2-git-send-email-vikas.sajjan@linaro.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/27/2013 08:49 PM, Vikas Sajjan wrote:
> Add support for parsing the display-timing node using video helper
> function.
>
> The DT node parsing and pinctrl selection is done only if 'dev.of_node'
> exists and the NON-DT logic is still maintained under the 'else' part.
>
> Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
> ---
>   drivers/gpu/drm/exynos/exynos_drm_fimd.c |   25 +++++++++++++++++++++----
>   1 file changed, 21 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> index 9537761..7932dc2 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> @@ -20,6 +20,7 @@
>   #include <linux/of_device.h>
>   #include <linux/pm_runtime.h>
>   
> +#include <video/of_display_timing.h>
>   #include <video/samsung_fimd.h>
>   #include <drm/exynos_drm.h>
>   
> @@ -883,10 +884,26 @@ static int fimd_probe(struct platform_device *pdev)
>   
>   	DRM_DEBUG_KMS("%s\n", __FILE__);
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
> +		ret = of_get_fb_videomode(dev->of_node, &pdata->panel.timing,
> +					OF_USE_NATIVE_MODE);
> +		if (ret) {
> +			DRM_ERROR("failed: of_get_fb_videomode()\n"
> +				"with return value: %d\n", ret);

Could you make this error log to one line?

except this,
Acked-by: Joonyoung Shim <jy0922.shim@samsung.com>

> +			return ret;
> +		}
> +	} else {
> +		pdata = pdev->dev.platform_data;
> +		if (!pdata) {
> +			DRM_ERROR("no platform data specified\n");
> +			return -EINVAL;
> +		}
>   	}
>   
>   	panel = &pdata->panel;

