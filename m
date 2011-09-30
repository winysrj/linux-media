Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508Ab1I3LWN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 07:22:13 -0400
Message-ID: <4E85A661.3080203@redhat.com>
Date: Fri, 30 Sep 2011 08:22:09 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 4/7] V4L menu: move all platform drivers to the
 bottom of the menu.
References: <1317373276-5818-1-git-send-email-hverkuil@xs4all.nl> <b06b3886212bb34b018a04e35fe460991425f865.1317372990.git.hans.verkuil@cisco.com>
In-Reply-To: <b06b3886212bb34b018a04e35fe460991425f865.1317372990.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 30-09-2011 06:01, Hans Verkuil escreveu:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 

>From the patch subject: V4L menu: move all platform drivers to the bottom of the menu.

It is clear to me that we're analizing drivers by the bus type.

IMO, what we should do is to arrange the driver as:

menuconfig VIDEO_USB
	bool "USB drivers"
...
menuconfig VIDEO_PCI
	bool "PCI drivers"
...
menuconfig VIDEO_PLATFORM
	bool "Platform drivers"
...
menuconfig VIDEO_ISA_PARPORT
	bool "Isa and Parallel port drivers"

This as a big advantage of the current way, as it helps people to discard drivers
that they will never need:

1) people with modern Desktop PC can just disable VIDEO_PLATFORM and VIDEO_ISA_PARPORT;
2) people with embedded SoC hardware can disable VIDEO_USB, VIDEO_PCI and VIDEO_ISA_PARPORT;
3) people with tablets (and similar stuff) can disable VIDEO_ISA_PARPORT and VIDEO_PCI.

So, things will be easier for the ones that are compiling the kernel, or preparing
distributions.

Regards,
Mauro

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/video/Kconfig |  106 ++++++++++++++++++++++---------------------
>  1 files changed, 55 insertions(+), 51 deletions(-)
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index fafc9ba..07d31d4 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -646,25 +646,6 @@ config USB_S2255
>  
>  endif # V4L_USB_DRIVERS
>  
> -config VIDEO_SH_VOU
> -	tristate "SuperH VOU video output driver"
> -	depends on VIDEO_DEV && ARCH_SHMOBILE
> -	select VIDEOBUF_DMA_CONTIG
> -	help
> -	  Support for the Video Output Unit (VOU) on SuperH SoCs.
> -
> -config VIDEO_VIU
> -	tristate "Freescale VIU Video Driver"
> -	depends on VIDEO_V4L2 && PPC_MPC512x
> -	select VIDEOBUF_DMA_CONTIG
> -	default y
> -	---help---
> -	  Support for Freescale VIU video driver. This device captures
> -	  video data, or overlays video on DIU frame buffer.
> -
> -	  Say Y here if you want to enable VIU device on MPC5121e Rev2+.
> -	  In doubt, say N.
> -
>  config VIDEO_VIVI
>  	tristate "Virtual Video Driver"
>  	depends on VIDEO_DEV && VIDEO_V4L2 && !SPARC32 && !SPARC64
> @@ -679,20 +660,8 @@ config VIDEO_VIVI
>  	  Say Y here if you want to test video apps or debug V4L devices.
>  	  In doubt, say N.
>  
> -source "drivers/media/video/davinci/Kconfig"
> -
> -source "drivers/media/video/omap/Kconfig"
> -
>  source "drivers/media/video/bt8xx/Kconfig"
>  
> -config VIDEO_VINO
> -	tristate "SGI Vino Video For Linux"
> -	depends on I2C && SGI_IP22 && VIDEO_V4L2
> -	select VIDEO_SAA7191 if VIDEO_HELPER_CHIPS_AUTO
> -	help
> -	  Say Y here to build in support for the Vino video input system found
> -	  on SGI Indy machines.
> -
>  source "drivers/media/video/zoran/Kconfig"
>  
>  config VIDEO_MEYE
> @@ -711,16 +680,6 @@ config VIDEO_MEYE
>  
>  source "drivers/media/video/saa7134/Kconfig"
>  
> -config VIDEO_TIMBERDALE
> -	tristate "Support for timberdale Video In/LogiWIN"
> -	depends on VIDEO_V4L2 && I2C && DMADEVICES
> -	select DMA_ENGINE
> -	select TIMB_DMA
> -	select VIDEO_ADV7180
> -	select VIDEOBUF_DMA_CONTIG
> -	---help---
> -	  Add support for the Video In peripherial of the timberdale FPGA.
> -
>  source "drivers/media/video/cx88/Kconfig"
>  
>  source "drivers/media/video/cx23885/Kconfig"
> @@ -735,6 +694,61 @@ source "drivers/media/video/saa7164/Kconfig"
>  
>  source "drivers/media/video/marvell-ccic/Kconfig"
>  
> +config VIDEO_VIA_CAMERA
> +	tristate "VIAFB camera controller support"
> +	depends on FB_VIA
> +	select VIDEOBUF_DMA_SG
> +	select VIDEO_OV7670
> +	help
> +	   Driver support for the integrated camera controller in VIA
> +	   Chrome9 chipsets.  Currently only tested on OLPC xo-1.5 systems
> +	   with ov7670 sensors.
> +
> +#
> +# Platform multimedia device configuration
> +#
> +
> +source "drivers/media/video/davinci/Kconfig"
> +
> +source "drivers/media/video/omap/Kconfig"
> +
> +config VIDEO_SH_VOU
> +	tristate "SuperH VOU video output driver"
> +	depends on VIDEO_DEV && ARCH_SHMOBILE
> +	select VIDEOBUF_DMA_CONTIG
> +	help
> +	  Support for the Video Output Unit (VOU) on SuperH SoCs.
> +
> +config VIDEO_VIU
> +	tristate "Freescale VIU Video Driver"
> +	depends on VIDEO_V4L2 && PPC_MPC512x
> +	select VIDEOBUF_DMA_CONTIG
> +	default y
> +	---help---
> +	  Support for Freescale VIU video driver. This device captures
> +	  video data, or overlays video on DIU frame buffer.
> +
> +	  Say Y here if you want to enable VIU device on MPC5121e Rev2+.
> +	  In doubt, say N.
> +
> +config VIDEO_TIMBERDALE
> +	tristate "Support for timberdale Video In/LogiWIN"
> +	depends on VIDEO_V4L2 && I2C && DMADEVICES
> +	select DMA_ENGINE
> +	select TIMB_DMA
> +	select VIDEO_ADV7180
> +	select VIDEOBUF_DMA_CONTIG
> +	---help---
> +	  Add support for the Video In peripherial of the timberdale FPGA.
> +
> +config VIDEO_VINO
> +	tristate "SGI Vino Video For Linux"
> +	depends on I2C && SGI_IP22 && VIDEO_V4L2
> +	select VIDEO_SAA7191 if VIDEO_HELPER_CHIPS_AUTO
> +	help
> +	  Say Y here to build in support for the Vino video input system found
> +	  on SGI Indy machines.
> +
>  config VIDEO_M32R_AR
>  	tristate "AR devices"
>  	depends on M32R && VIDEO_V4L2
> @@ -754,16 +768,6 @@ config VIDEO_M32R_AR_M64278
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called arv.
>  
> -config VIDEO_VIA_CAMERA
> -	tristate "VIAFB camera controller support"
> -	depends on FB_VIA
> -	select VIDEOBUF_DMA_SG
> -	select VIDEO_OV7670
> -	help
> -	   Driver support for the integrated camera controller in VIA
> -	   Chrome9 chipsets.  Currently only tested on OLPC xo-1.5 systems
> -	   with ov7670 sensors.
> -
>  config VIDEO_OMAP3
>  	tristate "OMAP 3 Camera support (EXPERIMENTAL)"
>  	select OMAP_IOMMU

