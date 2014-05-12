Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bn1on0064.outbound.protection.outlook.com ([157.56.110.64]:9345
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758187AbaELO2J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 May 2014 10:28:09 -0400
Date: Mon, 12 May 2014 22:13:07 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Alexander Shiyan <shc_work@mail.ru>
CC: <linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH] ARM: i.MX: Remove excess symbols ARCH_MX1, ARCH_MX25 and
 MACH_MX27
Message-ID: <20140512141306.GD8330@dragon>
References: <1399798206-17565-1-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1399798206-17565-1-git-send-email-shc_work@mail.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, May 11, 2014 at 12:50:06PM +0400, Alexander Shiyan wrote:
> This patch removes excess symbols ARCH_MX1, ARCH_MX25 and MACH_MX27.
> Instead we use SOC_IMX*.
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  arch/arm/mach-imx/Kconfig                 | 12 ------------
>  arch/arm/mach-imx/devices/Kconfig         |  2 +-
>  drivers/media/platform/soc_camera/Kconfig |  2 +-

We need to either split this file change into another patch or get an
ACK from Mauro or Guennadi.

Shawn

>  3 files changed, 2 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
> index d56eb1a..c28fa7c 100644
> --- a/arch/arm/mach-imx/Kconfig
> +++ b/arch/arm/mach-imx/Kconfig
> @@ -67,18 +67,8 @@ config IMX_HAVE_IOMUX_V1
>  config ARCH_MXC_IOMUX_V3
>  	bool
>  
> -config ARCH_MX1
> -	bool
> -
> -config ARCH_MX25
> -	bool
> -
> -config MACH_MX27
> -	bool
> -
>  config SOC_IMX1
>  	bool
> -	select ARCH_MX1
>  	select CPU_ARM920T
>  	select IMX_HAVE_IOMUX_V1
>  	select MXC_AVIC
> @@ -91,7 +81,6 @@ config SOC_IMX21
>  
>  config SOC_IMX25
>  	bool
> -	select ARCH_MX25
>  	select ARCH_MXC_IOMUX_V3
>  	select CPU_ARM926T
>  	select MXC_AVIC
> @@ -103,7 +92,6 @@ config SOC_IMX27
>  	select ARCH_HAS_OPP
>  	select CPU_ARM926T
>  	select IMX_HAVE_IOMUX_V1
> -	select MACH_MX27
>  	select MXC_AVIC
>  	select PINCTRL_IMX27
>  
> diff --git a/arch/arm/mach-imx/devices/Kconfig b/arch/arm/mach-imx/devices/Kconfig
> index 846c019..1f9d4a6 100644
> --- a/arch/arm/mach-imx/devices/Kconfig
> +++ b/arch/arm/mach-imx/devices/Kconfig
> @@ -1,6 +1,6 @@
>  config IMX_HAVE_PLATFORM_FEC
>  	bool
> -	default y if ARCH_MX25 || SOC_IMX27 || SOC_IMX35 || SOC_IMX51 || SOC_IMX53
> +	default y if SOC_IMX25 || SOC_IMX27 || SOC_IMX35 || SOC_IMX51 || SOC_IMX53
>  
>  config IMX_HAVE_PLATFORM_FLEXCAN
>  	bool
> diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
> index 122e03a..f0ccedd 100644
> --- a/drivers/media/platform/soc_camera/Kconfig
> +++ b/drivers/media/platform/soc_camera/Kconfig
> @@ -63,7 +63,7 @@ config VIDEO_OMAP1
>  
>  config VIDEO_MX2
>  	tristate "i.MX27 Camera Sensor Interface driver"
> -	depends on VIDEO_DEV && SOC_CAMERA && MACH_MX27
> +	depends on VIDEO_DEV && SOC_CAMERA && SOC_IMX27
>  	select VIDEOBUF2_DMA_CONTIG
>  	---help---
>  	  This is a v4l2 driver for the i.MX27 Camera Sensor Interface
> -- 
> 1.8.3.2
> 
