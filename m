Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:60630 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091AbcBWRed (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2016 12:34:33 -0500
Date: Tue, 23 Feb 2016 18:34:28 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] soc_camera/mx3_camera.c: move to staging in
 preparation,for removal
In-Reply-To: <56CC8B2E.1050809@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1602231834200.17650@axis700.grange>
References: <56CC8B2E.1050809@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 23 Feb 2016, Hans Verkuil wrote:

> This driver is deprecated: it should become a stand-alone driver
> instead of using the soc-camera framework.
> 
> Unless someone is willing to take this on (unlikely with such
> ancient hardware) it is going to be removed from the kernel
> soon.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
>  drivers/media/platform/soc_camera/Kconfig                 |  9 ---------
>  drivers/media/platform/soc_camera/Makefile                |  1 -
>  drivers/staging/media/Kconfig                             |  2 ++
>  drivers/staging/media/Makefile                            |  1 +
>  drivers/staging/media/mx3/Kconfig                         | 15 +++++++++++++++
>  drivers/staging/media/mx3/Makefile                        |  3 +++
>  .../soc_camera => staging/media/mx3}/mx3_camera.c         |  0
>  7 files changed, 21 insertions(+), 10 deletions(-)
>  create mode 100644 drivers/staging/media/mx3/Kconfig
>  create mode 100644 drivers/staging/media/mx3/Makefile
>  rename drivers/{media/platform/soc_camera => staging/media/mx3}/mx3_camera.c (100%)
> 
> diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
> index 449ab78..292b6e3 100644
> --- a/drivers/media/platform/soc_camera/Kconfig
> +++ b/drivers/media/platform/soc_camera/Kconfig
> @@ -17,15 +17,6 @@ config SOC_CAMERA_PLATFORM
>  	help
>  	  This is a generic SoC camera platform driver, useful for testing
> 
> -config VIDEO_MX3
> -	tristate "i.MX3x Camera Sensor Interface driver"
> -	depends on VIDEO_DEV && MX3_IPU && SOC_CAMERA
> -	depends on MX3_IPU || COMPILE_TEST
> -	depends on HAS_DMA
> -	select VIDEOBUF2_DMA_CONTIG
> -	---help---
> -	  This is a v4l2 driver for the i.MX3x Camera Sensor Interface
> -
>  config VIDEO_PXA27x
>  	tristate "PXA27x Quick Capture Interface driver"
>  	depends on VIDEO_DEV && PXA27x && SOC_CAMERA
> diff --git a/drivers/media/platform/soc_camera/Makefile b/drivers/media/platform/soc_camera/Makefile
> index dad56b9..7ee71ae 100644
> --- a/drivers/media/platform/soc_camera/Makefile
> +++ b/drivers/media/platform/soc_camera/Makefile
> @@ -7,7 +7,6 @@ obj-$(CONFIG_SOC_CAMERA_PLATFORM)	+= soc_camera_platform.o
> 
>  # soc-camera host drivers have to be linked after camera drivers
>  obj-$(CONFIG_VIDEO_ATMEL_ISI)		+= atmel-isi.o
> -obj-$(CONFIG_VIDEO_MX3)			+= mx3_camera.o
>  obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
>  obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
>  obj-$(CONFIG_VIDEO_SH_MOBILE_CSI2)	+= sh_mobile_csi2.o
> diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
> index 11d62b2..be27108 100644
> --- a/drivers/staging/media/Kconfig
> +++ b/drivers/staging/media/Kconfig
> @@ -31,6 +31,8 @@ source "drivers/staging/media/mn88473/Kconfig"
> 
>  source "drivers/staging/media/mx2/Kconfig"
> 
> +source "drivers/staging/media/mx3/Kconfig"
> +
>  source "drivers/staging/media/omap1/Kconfig"
> 
>  source "drivers/staging/media/omap4iss/Kconfig"
> diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
> index d3ff2d0..4861163 100644
> --- a/drivers/staging/media/Makefile
> +++ b/drivers/staging/media/Makefile
> @@ -3,6 +3,7 @@ obj-$(CONFIG_DVB_CXD2099)	+= cxd2099/
>  obj-$(CONFIG_LIRC_STAGING)	+= lirc/
>  obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
>  obj-$(CONFIG_VIDEO_MX2)		+= mx2/
> +obj-$(CONFIG_VIDEO_MX3)		+= mx3/
>  obj-$(CONFIG_VIDEO_OMAP1)	+= omap1/
>  obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
>  obj-$(CONFIG_DVB_MN88472)       += mn88472/
> diff --git a/drivers/staging/media/mx3/Kconfig b/drivers/staging/media/mx3/Kconfig
> new file mode 100644
> index 0000000..595d5fe
> --- /dev/null
> +++ b/drivers/staging/media/mx3/Kconfig
> @@ -0,0 +1,15 @@
> +config VIDEO_MX3
> +	tristate "i.MX3x Camera Sensor Interface driver"
> +	depends on VIDEO_DEV && MX3_IPU && SOC_CAMERA
> +	depends on MX3_IPU || COMPILE_TEST
> +	depends on HAS_DMA
> +	select VIDEOBUF2_DMA_CONTIG
> +	---help---
> +	  This is a v4l2 driver for the i.MX3x Camera Sensor Interface
> +
> +	  This driver is deprecated: it should become a stand-alone driver
> +	  instead of using the soc-camera framework.
> +
> +	  Unless someone is willing to take this on (unlikely with such
> +	  ancient hardware) it is going to be removed from the kernel
> +	  soon.
> diff --git a/drivers/staging/media/mx3/Makefile b/drivers/staging/media/mx3/Makefile
> new file mode 100644
> index 0000000..6d91dcd
> --- /dev/null
> +++ b/drivers/staging/media/mx3/Makefile
> @@ -0,0 +1,3 @@
> +# Makefile for i.MX3x Camera Sensor driver
> +
> +obj-$(CONFIG_VIDEO_MX3) += mx3_camera.o
> diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/staging/media/mx3/mx3_camera.c
> similarity index 100%
> rename from drivers/media/platform/soc_camera/mx3_camera.c
> rename to drivers/staging/media/mx3/mx3_camera.c
> -- 
> 2.7.0
> 
