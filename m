Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:50348 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaJFPwL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Oct 2014 11:52:11 -0400
Message-ID: <5432BAA7.4010008@gmail.com>
Date: Mon, 06 Oct 2014 17:52:07 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org
CC: pebolle@tiscali.nl, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] [media] Remove references to non-existent PLAT_S5P symbol
References: <1412609947-8358-1-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1412609947-8358-1-git-send-email-s.nawrocki@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06.10.2014 17:39, Sylwester Nawrocki wrote:
> diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
> index 77c9512..b3b270a 100644
> --- a/drivers/media/platform/exynos4-is/Kconfig
> +++ b/drivers/media/platform/exynos4-is/Kconfig
> @@ -2,7 +2,7 @@
>  config VIDEO_SAMSUNG_EXYNOS4_IS
>  	bool "Samsung S5P/EXYNOS4 SoC series Camera Subsystem driver"
>  	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> -	depends on (PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST)
> +	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
>  	depends on OF && COMMON_CLK
>  	help
>  	  Say Y here to enable camera host interface devices for
> @@ -57,7 +57,7 @@ endif
>  
>  config VIDEO_EXYNOS4_FIMC_IS
>  	tristate "EXYNOS4x12 FIMC-IS (Imaging Subsystem) driver"
> -	depends on HAS_DMA
> +	depends on HAS_DMA && !ARCH_S5PV210

Hmm, does this change really do the intended thing?

Since both S5PV210 and Exynos are multiplatform-aware, now whenever
ARCH_S5PV210 is enabled, it isn't possible to enable
VIDEO_EXYNOS4_FIMC_IS, even though ARCH_EXYNOS can be enabled as well at
the same time.

Best regards,
Tomasz
