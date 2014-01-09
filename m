Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:44253 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433AbaAIIbq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jan 2014 03:31:46 -0500
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	s.nawrocki@samsung.com, posciak@google.com, hverkuil@xs4all.nl,
	m.chehab@samsung.com
Subject: Re: [PATCH v5 3/4] [media] exynos-scaler: Add m2m functionality for
 the SCALER driver
Date: Thu, 09 Jan 2014 09:31:25 +0100
Message-id: <2693737.HeuDsQMSy5@amdc1032>
In-reply-to: <1389238094-19386-4-git-send-email-shaik.ameer@samsung.com>
References: <1389238094-19386-1-git-send-email-shaik.ameer@samsung.com>
 <1389238094-19386-4-git-send-email-shaik.ameer@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,

On Thursday, January 09, 2014 08:58:13 AM Shaik Ameer Basha wrote:
> This patch adds the Makefile and memory to memory (m2m) interface
> functionality for the SCALER driver.
> 
> [arun.kk@samsung.com: fix compilation issues]
> 
> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> ---
>  drivers/media/platform/Kconfig                    |    8 +
>  drivers/media/platform/Makefile                   |    1 +
>  drivers/media/platform/exynos-scaler/Makefile     |    3 +
>  drivers/media/platform/exynos-scaler/scaler-m2m.c |  788 +++++++++++++++++++++

It would be cleaner to add Kconfig + Makefiles in the same patch
that adds core functionality (patch #2) and then switch the order of
patch #2 and patch #3.

>  4 files changed, 800 insertions(+)
>  create mode 100644 drivers/media/platform/exynos-scaler/Makefile
>  create mode 100644 drivers/media/platform/exynos-scaler/scaler-m2m.c
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index b2a4403..aec5b80 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -196,6 +196,14 @@ config VIDEO_SAMSUNG_EXYNOS_GSC
>  	help
>  	  This is a v4l2 driver for Samsung EXYNOS5 SoC G-Scaler.
>  
> +config VIDEO_SAMSUNG_EXYNOS_SCALER
> +	tristate "Samsung Exynos SCALER driver"
> +	depends on OF && VIDEO_DEV && VIDEO_V4L2 && ARCH_EXYNOS5

Please check for EXYNOS5410 and EXYNOS5420 explicitly instead
of checking just for ARCH_EXYNOS5.

Also this config option doesn't need to depend on OF since
the whole EXYNOS support is OF only now.

> +	select VIDEOBUF2_DMA_CONTIG
> +	select V4L2_MEM2MEM_DEV
> +	help
> +	  This is a v4l2 driver for Samsung EXYNOS5410/5420 SoC SCALER.
> +
>  config VIDEO_SH_VEU
>  	tristate "SuperH VEU mem2mem video processing driver"
>  	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

