Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:11381
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751289AbaEYHxB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 May 2014 03:53:01 -0400
Date: Sun, 25 May 2014 15:52:35 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Alexander Shiyan <shc_work@mail.ru>
CC: <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH 2/2] media: mx2_camera: Change Kconfig dependency
Message-ID: <20140525075234.GA13258@dragon>
References: <1400907383-32590-1-git-send-email-shc_work@mail.ru>
 <1400907383-32590-2-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1400907383-32590-2-git-send-email-shc_work@mail.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, May 24, 2014 at 08:56:23AM +0400, Alexander Shiyan wrote:
> This patch change MACH_MX27 dependency to SOC_IMX27 for MX2 camera
> driver, since MACH_MX27 symbol is scheduled for removal.
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>

Acked-by: Shawn Guo <shawn.guo@freescale.com>

> ---
>  drivers/media/platform/soc_camera/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
> index 122e03a..fc62897 100644
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
> 1.8.5.5
> 
