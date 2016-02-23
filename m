Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:55421 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbcBWReB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2016 12:34:01 -0500
Date: Tue, 23 Feb 2016 18:33:56 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] soc_camera/mx2_camera.c: move to staging in
 preparation,for removal
In-Reply-To: <56CC8B13.2010104@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1602231833390.17650@axis700.grange>
References: <56CC8B13.2010104@xs4all.nl>
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
>  drivers/media/platform/soc_camera/Kconfig                    |  9 ---------
>  drivers/media/platform/soc_camera/Makefile                   |  1 -
>  drivers/staging/media/Kconfig                                |  2 ++
>  drivers/staging/media/Makefile                               |  1 +
>  drivers/staging/media/mx2/Kconfig                            | 12 ++++++++++++
>  drivers/staging/media/mx2/Makefile                           |  3 +++
>  .../platform/soc_camera => staging/media/mx2}/mx2_camera.c   |  0
>  7 files changed, 18 insertions(+), 10 deletions(-)
>  create mode 100644 drivers/staging/media/mx2/Kconfig
>  create mode 100644 drivers/staging/media/mx2/Makefile
>  rename drivers/{media/platform/soc_camera => staging/media/mx2}/mx2_camera.c (100%)
> 
> diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
> index 954dd36..449ab78 100644
> --- a/drivers/media/platform/soc_camera/Kconfig
> +++ b/drivers/media/platform/soc_camera/Kconfig
> @@ -60,15 +60,6 @@ config VIDEO_SH_MOBILE_CEU
>  	---help---
>  	  This is a v4l2 driver for the SuperH Mobile CEU Interface
> 
> -config VIDEO_MX2
> -	tristate "i.MX27 Camera Sensor Interface driver"
> -	depends on VIDEO_DEV && SOC_CAMERA
> -	depends on SOC_IMX27 || COMPILE_TEST
> -	depends on HAS_DMA
> -	select VIDEOBUF2_DMA_CONTIG
> -	---help---
> -	  This is a v4l2 driver for the i.MX27 Camera Sensor Interface
> -
>  config VIDEO_ATMEL_ISI
>  	tristate "ATMEL Image Sensor Interface (ISI) support"
>  	depends on VIDEO_DEV && SOC_CAMERA
> diff --git a/drivers/media/platform/soc_camera/Makefile b/drivers/media/platform/soc_camera/Makefile
> index bdd7fc9..dad56b9 100644
> --- a/drivers/media/platform/soc_camera/Makefile
> +++ b/drivers/media/platform/soc_camera/Makefile
> @@ -7,7 +7,6 @@ obj-$(CONFIG_SOC_CAMERA_PLATFORM)	+= soc_camera_platform.o
> 
>  # soc-camera host drivers have to be linked after camera drivers
>  obj-$(CONFIG_VIDEO_ATMEL_ISI)		+= atmel-isi.o
> -obj-$(CONFIG_VIDEO_MX2)			+= mx2_camera.o
>  obj-$(CONFIG_VIDEO_MX3)			+= mx3_camera.o
>  obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
>  obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
> diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
> index 382d868..11d62b2 100644
> --- a/drivers/staging/media/Kconfig
> +++ b/drivers/staging/media/Kconfig
> @@ -29,6 +29,8 @@ source "drivers/staging/media/mn88472/Kconfig"
> 
>  source "drivers/staging/media/mn88473/Kconfig"
> 
> +source "drivers/staging/media/mx2/Kconfig"
> +
>  source "drivers/staging/media/omap1/Kconfig"
> 
>  source "drivers/staging/media/omap4iss/Kconfig"
> diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
> index 89d038c..d3ff2d0 100644
> --- a/drivers/staging/media/Makefile
> +++ b/drivers/staging/media/Makefile
> @@ -2,6 +2,7 @@ obj-$(CONFIG_I2C_BCM2048)	+= bcm2048/
>  obj-$(CONFIG_DVB_CXD2099)	+= cxd2099/
>  obj-$(CONFIG_LIRC_STAGING)	+= lirc/
>  obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
> +obj-$(CONFIG_VIDEO_MX2)		+= mx2/
>  obj-$(CONFIG_VIDEO_OMAP1)	+= omap1/
>  obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
>  obj-$(CONFIG_DVB_MN88472)       += mn88472/
> diff --git a/drivers/staging/media/mx2/Kconfig b/drivers/staging/media/mx2/Kconfig
> new file mode 100644
> index 0000000..e080ab9
> --- /dev/null
> +++ b/drivers/staging/media/mx2/Kconfig
> @@ -0,0 +1,12 @@
> +config VIDEO_MX2
> +	tristate "i.MX27 Camera Sensor Interface driver"
> +	depends on VIDEO_DEV && SOC_CAMERA
> +	depends on SOC_IMX27 || COMPILE_TEST
> +	depends on HAS_DMA
> +	select VIDEOBUF2_DMA_CONTIG
> +	---help---
> +	  This is a v4l2 driver for the i.MX27 Camera Sensor Interface
> +
> +	  This driver is deprecated and will be removed soon unless someone
> +	  will start the work to convert this driver to the vb2 framework
> +	  and remove the soc-camera dependency.
> diff --git a/drivers/staging/media/mx2/Makefile b/drivers/staging/media/mx2/Makefile
> new file mode 100644
> index 0000000..fc5b282
> --- /dev/null
> +++ b/drivers/staging/media/mx2/Makefile
> @@ -0,0 +1,3 @@
> +# Makefile for i.MX27 Camera Sensor driver
> +
> +obj-$(CONFIG_VIDEO_MX2) += mx2_camera.o
> diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/staging/media/mx2/mx2_camera.c
> similarity index 100%
> rename from drivers/media/platform/soc_camera/mx2_camera.c
> rename to drivers/staging/media/mx2/mx2_camera.c
> -- 
> 2.7.0
> 
