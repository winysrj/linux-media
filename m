Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:41977
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751420AbcKIR5q (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 12:57:46 -0500
Subject: Re: [PATCH 1/2] exynos-gsc: Enable driver on ARCH_EXYNOS
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1478701778-29452-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20161109142950eucas1p28aeab32587655ee249c1eefefcbb408d@eucas1p2.samsung.com>
 <1478701778-29452-2-git-send-email-m.szyprowski@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <9b294d9b-8e02-7732-0fa1-d573cdabffc7@osg.samsung.com>
Date: Wed, 9 Nov 2016 14:49:07 -0300
MIME-Version: 1.0
In-Reply-To: <1478701778-29452-2-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marek,

On 11/09/2016 11:29 AM, Marek Szyprowski wrote:
> This driver can be also used on Exynos5433, which is ARM64-based
> platform, which selects only ARCH_EXYNOS symbol.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/media/platform/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 754edbf1..90ae790 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -266,7 +266,7 @@ config VIDEO_MX2_EMMAPRP
>  config VIDEO_SAMSUNG_EXYNOS_GSC
>  	tristate "Samsung Exynos G-Scaler driver"
>  	depends on VIDEO_DEV && VIDEO_V4L2
> -	depends on ARCH_EXYNOS5 || COMPILE_TEST
> +	depends on ARCH_EXYNOS || COMPILE_TEST
>  	depends on HAS_DMA
>  	select VIDEOBUF2_DMA_CONTIG
>  	select V4L2_MEM2MEM_DEV
> 

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
