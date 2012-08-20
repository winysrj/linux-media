Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:53754 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab2HTTcl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Aug 2012 15:32:41 -0400
Date: Mon, 20 Aug 2012 21:32:27 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: no To-header on input <""@googlemail-pop.l.google.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/6] [media] move soc_camera to its own directory
In-Reply-To: <1345486935-18002-2-git-send-email-mchehab@redhat.com>
Message-ID: <Pine.LNX.4.64.1208202130090.20936@axis700.grange>
References: <1345486935-18002-1-git-send-email-mchehab@redhat.com>
 <1345486935-18002-2-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

On Mon, 20 Aug 2012, Mauro Carvalho Chehab wrote:

> That helps to better organize the soc_camera items.
> 
> While here, cleanup Makefiles, removing uneeded include dirs.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/platform/Kconfig                     | 96 +---------------------
>  drivers/media/platform/Makefile                    | 30 +------
>  .../media/platform/{ => soc_camera}/atmel-isi.c    |  0
>  .../media/platform/{ => soc_camera}/mx1_camera.c   |  0
>  .../media/platform/{ => soc_camera}/mx2_camera.c   |  0
>  .../media/platform/{ => soc_camera}/mx3_camera.c   |  0
>  .../media/platform/{ => soc_camera}/omap1_camera.c |  0

>  .../platform/{ => soc_camera}/omap24xxcam-dma.c    |  0
>  .../media/platform/{ => soc_camera}/omap24xxcam.c  |  0
>  .../media/platform/{ => soc_camera}/omap24xxcam.h  |  0

omap24xxcam are not soc-camera drivers.

Thanks
Guennadi


>  .../media/platform/{ => soc_camera}/pxa_camera.c   |  0
>  .../{ => soc_camera}/sh_mobile_ceu_camera.c        |  0
>  .../platform/{ => soc_camera}/sh_mobile_csi2.c     |  0
>  .../media/platform/{ => soc_camera}/soc_camera.c   |  0
>  .../{ => soc_camera}/soc_camera_platform.c         |  0
>  .../media/platform/{ => soc_camera}/soc_mediabus.c |  0
>  16 files changed, 5 insertions(+), 121 deletions(-)
>  rename drivers/media/platform/{ => soc_camera}/atmel-isi.c (100%)
>  rename drivers/media/platform/{ => soc_camera}/mx1_camera.c (100%)
>  rename drivers/media/platform/{ => soc_camera}/mx2_camera.c (100%)
>  rename drivers/media/platform/{ => soc_camera}/mx3_camera.c (100%)
>  rename drivers/media/platform/{ => soc_camera}/omap1_camera.c (100%)
>  rename drivers/media/platform/{ => soc_camera}/omap24xxcam-dma.c (100%)
>  rename drivers/media/platform/{ => soc_camera}/omap24xxcam.c (100%)
>  rename drivers/media/platform/{ => soc_camera}/omap24xxcam.h (100%)
>  rename drivers/media/platform/{ => soc_camera}/pxa_camera.c (100%)
>  rename drivers/media/platform/{ => soc_camera}/sh_mobile_ceu_camera.c (100%)
>  rename drivers/media/platform/{ => soc_camera}/sh_mobile_csi2.c (100%)
>  rename drivers/media/platform/{ => soc_camera}/soc_camera.c (100%)
>  rename drivers/media/platform/{ => soc_camera}/soc_camera_platform.c (100%)
>  rename drivers/media/platform/{ => soc_camera}/soc_mediabus.c (100%)
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index e1959a8..39da25b 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -117,101 +117,7 @@ config VIDEO_OMAP3_DEBUG
>  	---help---
>  	  Enable debug messages on OMAP 3 camera controller driver.
>  
> -config SOC_CAMERA
> -	tristate "SoC camera support"
> -	depends on VIDEO_V4L2 && HAS_DMA && I2C
> -	select VIDEOBUF_GEN
> -	select VIDEOBUF2_CORE
> -	help
> -	  SoC Camera is a common API to several cameras, not connecting
> -	  over a bus like PCI or USB. For example some i2c camera connected
> -	  directly to the data bus of an SoC.
> -
> -
> -config SOC_CAMERA_PLATFORM
> -	tristate "platform camera support"
> -	depends on SOC_CAMERA
> -	help
> -	  This is a generic SoC camera platform driver, useful for testing
> -
> -config MX1_VIDEO
> -	bool
> -
> -config VIDEO_MX1
> -	tristate "i.MX1/i.MXL CMOS Sensor Interface driver"
> -	depends on VIDEO_DEV && ARCH_MX1 && SOC_CAMERA
> -	select FIQ
> -	select VIDEOBUF_DMA_CONTIG
> -	select MX1_VIDEO
> -	---help---
> -	  This is a v4l2 driver for the i.MX1/i.MXL CMOS Sensor Interface
> -
> -config MX3_VIDEO
> -	bool
> -
> -config VIDEO_MX3
> -	tristate "i.MX3x Camera Sensor Interface driver"
> -	depends on VIDEO_DEV && MX3_IPU && SOC_CAMERA
> -	select VIDEOBUF2_DMA_CONTIG
> -	select MX3_VIDEO
> -	---help---
> -	  This is a v4l2 driver for the i.MX3x Camera Sensor Interface
> -
> -config VIDEO_PXA27x
> -	tristate "PXA27x Quick Capture Interface driver"
> -	depends on VIDEO_DEV && PXA27x && SOC_CAMERA
> -	select VIDEOBUF_DMA_SG
> -	---help---
> -	  This is a v4l2 driver for the PXA27x Quick Capture Interface
> -
> -config VIDEO_SH_MOBILE_CSI2
> -	tristate "SuperH Mobile MIPI CSI-2 Interface driver"
> -	depends on VIDEO_DEV && SOC_CAMERA && HAVE_CLK
> -	---help---
> -	  This is a v4l2 driver for the SuperH MIPI CSI-2 Interface
> -
> -config VIDEO_SH_MOBILE_CEU
> -	tristate "SuperH Mobile CEU Interface driver"
> -	depends on VIDEO_DEV && SOC_CAMERA && HAS_DMA && HAVE_CLK
> -	select VIDEOBUF2_DMA_CONTIG
> -	---help---
> -	  This is a v4l2 driver for the SuperH Mobile CEU Interface
> -
> -config VIDEO_OMAP1
> -	tristate "OMAP1 Camera Interface driver"
> -	depends on VIDEO_DEV && ARCH_OMAP1 && SOC_CAMERA
> -	select VIDEOBUF_DMA_CONTIG
> -	select VIDEOBUF_DMA_SG
> -	---help---
> -	  This is a v4l2 driver for the TI OMAP1 camera interface
> -
> -config VIDEO_OMAP2
> -	tristate "OMAP2 Camera Capture Interface driver"
> -	depends on VIDEO_DEV && ARCH_OMAP2
> -	select VIDEOBUF_DMA_SG
> -	---help---
> -	  This is a v4l2 driver for the TI OMAP2 camera capture interface
> -
> -config VIDEO_MX2_HOSTSUPPORT
> -	bool
> -
> -config VIDEO_MX2
> -	tristate "i.MX27/i.MX25 Camera Sensor Interface driver"
> -	depends on VIDEO_DEV && SOC_CAMERA && (MACH_MX27 || (ARCH_MX25 && BROKEN))
> -	select VIDEOBUF2_DMA_CONTIG
> -	select VIDEO_MX2_HOSTSUPPORT
> -	---help---
> -	  This is a v4l2 driver for the i.MX27 and the i.MX25 Camera Sensor
> -	  Interface
> -
> -config VIDEO_ATMEL_ISI
> -	tristate "ATMEL Image Sensor Interface (ISI) support"
> -	depends on VIDEO_DEV && SOC_CAMERA && ARCH_AT91
> -	select VIDEOBUF2_DMA_CONTIG
> -	---help---
> -	  This module makes the ATMEL Image Sensor Interface available
> -	  as a v4l2 device.
> -
> +source "drivers/media/platform/soc_camera/Kconfig"
>  source "drivers/media/platform/s5p-fimc/Kconfig"
>  source "drivers/media/platform/s5p-tv/Kconfig"
>  
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index b3effdc..27eb7ad 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -5,41 +5,24 @@
>  omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
>  
>  obj-$(CONFIG_VIDEO_VINO) += indycam.o
> -
>  obj-$(CONFIG_VIDEO_VINO) += vino.o
> -obj-$(CONFIG_VIDEO_TIMBERDALE)	+= timblogiw.o
> -
>  
> +obj-$(CONFIG_VIDEO_TIMBERDALE)	+= timblogiw.o
>  obj-$(CONFIG_VIDEO_M32R_AR_M64278) += arv.o
>  
> -
> +obj-$(CONFIG_VIDEO_VIA_CAMERA) += via-camera.o
>  obj-$(CONFIG_VIDEO_CAFE_CCIC) += marvell-ccic/
>  obj-$(CONFIG_VIDEO_MMP_CAMERA) += marvell-ccic/
>  
> -obj-$(CONFIG_VIDEO_VIA_CAMERA) += via-camera.o
> -
>  obj-$(CONFIG_VIDEO_OMAP3)	+= omap3isp/
>  
>  obj-$(CONFIG_VIDEO_VIU) += fsl-viu.o
>  obj-$(CONFIG_VIDEO_VIVI) += vivi.o
> -obj-$(CONFIG_VIDEO_MEM2MEM_TESTDEV) += mem2mem_testdev.o
>  
> -
> -obj-$(CONFIG_VIDEO_OMAP2)		+= omap2cam.o
> -obj-$(CONFIG_SOC_CAMERA)		+= soc_camera.o soc_mediabus.o
> -obj-$(CONFIG_SOC_CAMERA_PLATFORM)	+= soc_camera_platform.o
> -# soc-camera host drivers have to be linked after camera drivers
> -obj-$(CONFIG_VIDEO_MX1)			+= mx1_camera.o
> -obj-$(CONFIG_VIDEO_MX2)			+= mx2_camera.o
> -obj-$(CONFIG_VIDEO_MX3)			+= mx3_camera.o
> -obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
> -obj-$(CONFIG_VIDEO_SH_MOBILE_CSI2)	+= sh_mobile_csi2.o
> -obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
> -obj-$(CONFIG_VIDEO_OMAP1)		+= omap1_camera.o
> -obj-$(CONFIG_VIDEO_ATMEL_ISI)		+= atmel-isi.o
> +obj-$(CONFIG_VIDEO_MEM2MEM_TESTDEV) += mem2mem_testdev.o
>  
>  obj-$(CONFIG_VIDEO_MX2_EMMAPRP)		+= mx2_emmaprp.o
> -obj-$(CONFIG_VIDEO_CODA) 			+= coda.o
> +obj-$(CONFIG_VIDEO_CODA) 		+= coda.o
>  
>  obj-$(CONFIG_VIDEO_MEM2MEM_DEINTERLACE)	+= m2m-deinterlace.o
>  
> @@ -59,8 +42,3 @@ obj-$(CONFIG_VIDEO_SH_VOU)		+= sh_vou.o
>  obj-y	+= davinci/
>  
>  obj-$(CONFIG_ARCH_OMAP)	+= omap/
> -
> -ccflags-y += -I$(srctree)/drivers/media/dvb-core
> -ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
> -ccflags-y += -I$(srctree)/drivers/media/tuners
> -ccflags-y += -I$(srctree)/drivers/media/i2c/soc_camera
> diff --git a/drivers/media/platform/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
> similarity index 100%
> rename from drivers/media/platform/atmel-isi.c
> rename to drivers/media/platform/soc_camera/atmel-isi.c
> diff --git a/drivers/media/platform/mx1_camera.c b/drivers/media/platform/soc_camera/mx1_camera.c
> similarity index 100%
> rename from drivers/media/platform/mx1_camera.c
> rename to drivers/media/platform/soc_camera/mx1_camera.c
> diff --git a/drivers/media/platform/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
> similarity index 100%
> rename from drivers/media/platform/mx2_camera.c
> rename to drivers/media/platform/soc_camera/mx2_camera.c
> diff --git a/drivers/media/platform/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
> similarity index 100%
> rename from drivers/media/platform/mx3_camera.c
> rename to drivers/media/platform/soc_camera/mx3_camera.c
> diff --git a/drivers/media/platform/omap1_camera.c b/drivers/media/platform/soc_camera/omap1_camera.c
> similarity index 100%
> rename from drivers/media/platform/omap1_camera.c
> rename to drivers/media/platform/soc_camera/omap1_camera.c
> diff --git a/drivers/media/platform/omap24xxcam-dma.c b/drivers/media/platform/soc_camera/omap24xxcam-dma.c
> similarity index 100%
> rename from drivers/media/platform/omap24xxcam-dma.c
> rename to drivers/media/platform/soc_camera/omap24xxcam-dma.c
> diff --git a/drivers/media/platform/omap24xxcam.c b/drivers/media/platform/soc_camera/omap24xxcam.c
> similarity index 100%
> rename from drivers/media/platform/omap24xxcam.c
> rename to drivers/media/platform/soc_camera/omap24xxcam.c
> diff --git a/drivers/media/platform/omap24xxcam.h b/drivers/media/platform/soc_camera/omap24xxcam.h
> similarity index 100%
> rename from drivers/media/platform/omap24xxcam.h
> rename to drivers/media/platform/soc_camera/omap24xxcam.h
> diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
> similarity index 100%
> rename from drivers/media/platform/pxa_camera.c
> rename to drivers/media/platform/soc_camera/pxa_camera.c
> diff --git a/drivers/media/platform/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
> similarity index 100%
> rename from drivers/media/platform/sh_mobile_ceu_camera.c
> rename to drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
> diff --git a/drivers/media/platform/sh_mobile_csi2.c b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
> similarity index 100%
> rename from drivers/media/platform/sh_mobile_csi2.c
> rename to drivers/media/platform/soc_camera/sh_mobile_csi2.c
> diff --git a/drivers/media/platform/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> similarity index 100%
> rename from drivers/media/platform/soc_camera.c
> rename to drivers/media/platform/soc_camera/soc_camera.c
> diff --git a/drivers/media/platform/soc_camera_platform.c b/drivers/media/platform/soc_camera/soc_camera_platform.c
> similarity index 100%
> rename from drivers/media/platform/soc_camera_platform.c
> rename to drivers/media/platform/soc_camera/soc_camera_platform.c
> diff --git a/drivers/media/platform/soc_mediabus.c b/drivers/media/platform/soc_camera/soc_mediabus.c
> similarity index 100%
> rename from drivers/media/platform/soc_mediabus.c
> rename to drivers/media/platform/soc_camera/soc_mediabus.c
> -- 
> 1.7.11.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
