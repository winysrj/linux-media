Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:54246 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbcCDLCl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2016 06:02:41 -0500
Subject: Re: [PATCH v2] media: platform: Add missing MFD_SYSCON dependency on
 HAS_IOMEM
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	linux-arm-kernel@lists.infradead.org
References: <1457053344-28992-1-git-send-email-k.kozlowski@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <56D96B44.5090307@samsung.com>
Date: Fri, 04 Mar 2016 12:02:28 +0100
MIME-version: 1.0
In-reply-to: <1457053344-28992-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/04/2016 02:02 AM, Krzysztof Kozlowski wrote:
> The MFD_SYSCON depends on HAS_IOMEM so when selecting 
> it avoid unmet direct dependencies.

> diff --git a/drivers/media/platform/exynos4-is/Kconfig 
> b/drivers/media/platform/exynos4-is/Kconfig
> index 57d42c6172c5..c4317b99d257 100644
> --- a/drivers/media/platform/exynos4-is/Kconfig
> +++ b/drivers/media/platform/exynos4-is/Kconfig
> @@ -17,6 +17,7 @@ config VIDEO_S5P_FIMC
>  	tristate "S5P/EXYNOS4 FIMC/CAMIF camera interface driver"
>  	depends on I2C
>  	depends on HAS_DMA
> +	depends on HAS_IOMEM	# For MFD_SYSCON
>  	select VIDEOBUF2_DMA_CONTIG
>  	select V4L2_MEM2MEM_DEV
>  	select MFD_SYSCON

While we are already at it, shouldn't "depends on HAS_IOMEM"
be instead added at the top level entry in this Kconfig file,
i.e. "config VIDEO_SAMSUNG_EXYNOS4_IS" ? For things like
devm_ioremap_resource() depending on HAS_IOMEM and used in all
the sub-drivers, enabled by VIDEO_SAMSUNG_EXYNOS4_IS?

-- 
Thanks,
Sylwester
