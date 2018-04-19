Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:50418 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751882AbeDSL1J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 07:27:09 -0400
Subject: Re: [PATCH RESEND 3/6] media: omap3isp: Allow it to build with
 COMPILE_TEST
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Jacob Chen <jacob-chen@iotwrt.com>
References: <cover.1524136402.git.mchehab@s-opensource.com>
 <4a5990042cb951771498bdbb79e9e6ca4114942d.1524136402.git.mchehab@s-opensource.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6e4606da-d111-bb0c-9f9f-229088916cec@xs4all.nl>
Date: Thu, 19 Apr 2018 13:27:04 +0200
MIME-Version: 1.0
In-Reply-To: <4a5990042cb951771498bdbb79e9e6ca4114942d.1524136402.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/19/18 13:15, Mauro Carvalho Chehab wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> There aren't much things required for it to build with COMPILE_TEST.
> It just needs to not compile the code that depends on arm-specific
> iommu implementation.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Co-developed-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/platform/Kconfig        | 6 ++----
>  drivers/media/platform/omap3isp/isp.c | 8 ++++++++
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 1ee915b794c0..e3229f7baed1 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -63,12 +63,10 @@ config VIDEO_MUX
>  config VIDEO_OMAP3
>  	tristate "OMAP 3 Camera support"
>  	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
> -	depends on ARCH_OMAP3 || COMPILE_TEST
> -	depends on ARM
> +	depends on (ARCH_OMAP3 && OMAP_IOMMU) || COMPILE_TEST
>  	depends on COMMON_CLK
>  	depends on HAS_DMA && OF
> -	depends on OMAP_IOMMU
> -	select ARM_DMA_USE_IOMMU
> +	select ARM_DMA_USE_IOMMU if OMAP_IOMMU
>  	select VIDEOBUF2_DMA_CONTIG
>  	select MFD_SYSCON
>  	select V4L2_FWNODE
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> index 16c50099cccd..b8c8761a76b6 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -61,7 +61,9 @@
>  #include <linux/sched.h>
>  #include <linux/vmalloc.h>
>  
> +#ifdef CONFIG_ARM_DMA_USE_IOMMU
>  #include <asm/dma-iommu.h>
> +#endif
>  
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-fwnode.h>
> @@ -1938,12 +1940,15 @@ static int isp_initialize_modules(struct isp_device *isp)
>  
>  static void isp_detach_iommu(struct isp_device *isp)
>  {
> +#ifdef CONFIG_ARM_DMA_USE_IOMMU
>  	arm_iommu_release_mapping(isp->mapping);
>  	isp->mapping = NULL;
> +#endif
>  }
>  
>  static int isp_attach_iommu(struct isp_device *isp)
>  {
> +#ifdef CONFIG_ARM_DMA_USE_IOMMU
>  	struct dma_iommu_mapping *mapping;
>  	int ret;
>  
> @@ -1972,6 +1977,9 @@ static int isp_attach_iommu(struct isp_device *isp)
>  error:
>  	isp_detach_iommu(isp);
>  	return ret;
> +#else
> +	return -ENODEV;
> +#endif
>  }
>  
>  /*
> 
