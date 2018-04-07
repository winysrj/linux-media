Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45545 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751447AbeDGNbh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 7 Apr 2018 09:31:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Subject: Re: [PATCH v2 02/19] media: omap3isp: allow it to build with COMPILE_TEST
Date: Sat, 07 Apr 2018 16:31:35 +0300
Message-ID: <18135667.qKsSxlhKAa@avalon>
In-Reply-To: <f618981fec34acc5eee211b34a0018752634af9c.1522959716.git.mchehab@s-opensource.com>
References: <cover.1522959716.git.mchehab@s-opensource.com> <f618981fec34acc5eee211b34a0018752634af9c.1522959716.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Thursday, 5 April 2018 23:29:29 EEST Mauro Carvalho Chehab wrote:
> There aren't much things required for it to build with COMPILE_TEST.
> It just needs to provide stub for an arm-dependent include.
> 
> Let's replicate the same solution used by ipmmu-vmsa, in order
> to allow building omap3 with COMPILE_TEST.
> 
> The actual logic here came from this driver:
> 
>    drivers/iommu/ipmmu-vmsa.c
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/platform/Kconfig        | 8 ++++----
>  drivers/media/platform/omap3isp/isp.c | 7 +++++++
>  2 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index c7a1cf8a1b01..03c9dfeb7781 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -62,12 +62,12 @@ config VIDEO_MUX
> 
>  config VIDEO_OMAP3
>  	tristate "OMAP 3 Camera support"
> -	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
> +	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
>  	depends on HAS_DMA && OF
> -	depends on OMAP_IOMMU
> -	select ARM_DMA_USE_IOMMU
> +	depends on ((ARCH_OMAP3 && OMAP_IOMMU) || COMPILE_TEST)
> +	select ARM_DMA_USE_IOMMU if OMAP_IOMMU
>  	select VIDEOBUF2_DMA_CONTIG
> -	select MFD_SYSCON
> +	select MFD_SYSCON if ARCH_OMAP3

Is this needed ? Can't MFD_SYSCON be selected on non-ARM platforms ?

>  	select V4L2_FWNODE
>  	---help---
>  	  Driver for an OMAP 3 camera controller.
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index 8eb000e3d8fd..2a11a709aa4f
> 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -61,7 +61,14 @@
>  #include <linux/sched.h>
>  #include <linux/vmalloc.h>
> 
> +#if defined(CONFIG_ARM) && !defined(CONFIG_IOMMU_DMA)
>  #include <asm/dma-iommu.h>
> +#else
> +#define arm_iommu_create_mapping(...)	NULL
> +#define arm_iommu_attach_device(...)	-ENODEV
> +#define arm_iommu_release_mapping(...)	do {} while (0)
> +#define arm_iommu_detach_device(...)	do {} while (0)
> +#endif
> 
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-fwnode.h>

As just commented on in a reply to v1 I still don't think this is a proper 
solution. I'm all for extending compile-test coverage, but I don't believe we 
need to make all drivers compile on every platform. ARM is certainly a 
mainstream-enough platform nowadays to be worth having the media tree compiled 
for.

-- 
Regards,

Laurent Pinchart
