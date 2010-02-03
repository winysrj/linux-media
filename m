Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33000 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab0BCH5q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2010 02:57:46 -0500
Message-ID: <4B692C75.80907@infradead.org>
Date: Wed, 03 Feb 2010 05:57:41 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-media@vger.kernel.org, mpagano@gentoo.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: [patch 3/7] drivers/media/video/Kconfig: add VIDEO_DEV dependency
 as needed in drivers/media/video/Kconfig
References: <201002022240.o12MemE3018908@imap1.linux-foundation.org>
In-Reply-To: <201002022240.o12MemE3018908@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

akpm@linux-foundation.org wrote:
> From: Mike Pagano <mpagano@gentoo.org>
> 
> Add VIDEO_DEV as dependency of VIDEO_CAPTURE_DRIVERS and all of the
> devices listed under this setting.
> 
> Signed-off-by: Mike Pagano <mpagano@gentoo.org>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/media/video/Kconfig |   20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff -puN drivers/media/video/Kconfig~drivers-media-video-kconfig-add-video_dev-dependency-as-needed-in-drivers-media-video-kconfig drivers/media/video/Kconfig
> --- a/drivers/media/video/Kconfig~drivers-media-video-kconfig-add-video_dev-dependency-as-needed-in-drivers-media-video-kconfig
> +++ a/drivers/media/video/Kconfig
> @@ -51,14 +51,14 @@ config VIDEO_TUNER
>  
>  menuconfig VIDEO_CAPTURE_DRIVERS
>  	bool "Video capture adapters"
> -	depends on VIDEO_V4L2
> +	depends on VIDEO_V4L2 && VIDEO_DEV

VIDEO_V4L2 is defined as:

config VIDEO_V4L2_COMMON
        tristate
        depends on (I2C || I2C=n) && VIDEO_DEV
        default (I2C || I2C=n) && VIDEO_DEV

config VIDEO_V4L2
        tristate
        depends on VIDEO_DEV && VIDEO_V4L2_COMMON
        default VIDEO_DEV && VIDEO_V4L2_COMMON

As VIDEO_V4L2 already depends on VIDEO_DEV, there's no need to add VIDEO_DEV
for VIDEO_CAPTURE_DRIVERS.

>  	default y
>  	---help---
>  	  Say Y here to enable selecting the video adapters for
>  	  webcams, analog TV, and hybrid analog/digital TV.
>  	  Some of those devices also supports FM radio.
>  
> -if VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2
> +if VIDEO_DEV && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2

Idem.

>  config VIDEO_ADV_DEBUG
>  	bool "Enable advanced debug functionality"
> @@ -500,7 +500,7 @@ endmenu # encoder / decoder chips
>  
>  config DISPLAY_DAVINCI_DM646X_EVM
>  	tristate "DM646x EVM Video Display"
> -	depends on VIDEO_DEV && MACH_DAVINCI_DM6467_EVM
> +	depends on MACH_DAVINCI_DM6467_EVM
>  	select VIDEOBUF_DMA_CONTIG
>  	select VIDEO_DAVINCI_VPIF
>  	select VIDEO_ADV7343
> @@ -513,7 +513,7 @@ config DISPLAY_DAVINCI_DM646X_EVM
>  
>  config CAPTURE_DAVINCI_DM646X_EVM
>  	tristate "DM646x EVM Video Capture"
> -	depends on VIDEO_DEV && MACH_DAVINCI_DM6467_EVM
> +	depends on MACH_DAVINCI_DM6467_EVM
>  	select VIDEOBUF_DMA_CONTIG
>  	select VIDEO_DAVINCI_VPIF
>  	help
> @@ -533,7 +533,7 @@ config VIDEO_DAVINCI_VPIF
>  
>  config VIDEO_VIVI
>  	tristate "Virtual Video Driver"
> -	depends on VIDEO_DEV && VIDEO_V4L2 && !SPARC32 && !SPARC64
> +	depends on VIDEO_V4L2 && !SPARC32 && !SPARC64
>  	select VIDEOBUF_VMALLOC
>  	default n
>  	---help---
> @@ -889,7 +889,7 @@ config MX1_VIDEO
>  
>  config VIDEO_MX1
>  	tristate "i.MX1/i.MXL CMOS Sensor Interface driver"
> -	depends on VIDEO_DEV && ARCH_MX1 && SOC_CAMERA
> +	depends on ARCH_MX1 && SOC_CAMERA
>  	select FIQ
>  	select VIDEOBUF_DMA_CONTIG
>  	select MX1_VIDEO
> @@ -901,7 +901,7 @@ config MX3_VIDEO
>  
>  config VIDEO_MX3
>  	tristate "i.MX3x Camera Sensor Interface driver"
> -	depends on VIDEO_DEV && MX3_IPU && SOC_CAMERA
> +	depends on MX3_IPU && SOC_CAMERA
>  	select VIDEOBUF_DMA_CONTIG
>  	select MX3_VIDEO
>  	---help---
> @@ -909,21 +909,21 @@ config VIDEO_MX3
>  
>  config VIDEO_PXA27x
>  	tristate "PXA27x Quick Capture Interface driver"
> -	depends on VIDEO_DEV && PXA27x && SOC_CAMERA
> +	depends on PXA27x && SOC_CAMERA
>  	select VIDEOBUF_DMA_SG
>  	---help---
>  	  This is a v4l2 driver for the PXA27x Quick Capture Interface
>  
>  config VIDEO_SH_MOBILE_CEU
>  	tristate "SuperH Mobile CEU Interface driver"
> -	depends on VIDEO_DEV && SOC_CAMERA && HAS_DMA && HAVE_CLK
> +	depends on SOC_CAMERA && HAS_DMA && HAVE_CLK
>  	select VIDEOBUF_DMA_CONTIG
>  	---help---
>  	  This is a v4l2 driver for the SuperH Mobile CEU Interface
>  
>  config VIDEO_OMAP2
>  	tristate "OMAP2 Camera Capture Interface driver"
> -	depends on VIDEO_DEV && ARCH_OMAP2
> +	depends on ARCH_OMAP2
>  	select VIDEOBUF_DMA_SG
>  	---help---
>  	  This is a v4l2 driver for the TI OMAP2 camera capture interface

I suspect that it is needed to keep at least some of the above dependencies, since VIDEO_DEV
is tristate. Otherwise, someone may do things like selecting VIDEO_DEV=m, and select 
DISPLAY_DAVINCI_DM646X_EVM=y.

Yet, your proposed patch ringed the bells.

Extra care should be taken with drivers that depend on VIDEO_DEV instead of VIDEO_V4L2, due
to the driver I2C dependencies. If I2C=m and VIDEO_DEV=y, and the driver has any call to an
i2c core code, the driver should not be allowed to be compiled builtin. 

So, if one of the above drivers that depend on VIDEO_DEV has access to i2c, it should
depend, instead, of VIDEO_V4L2 (where the I2C particular case were already addressed).

I suspect that this is the case for soc_camera. So, the above dependencies should be, instead,
VIDEO_V4L2. I'm not sure if all those DaVinci/OMAP drivers require i2c.

Guennadi/Murali,

Could you please double-check?

-- 

Cheers,
Mauro
