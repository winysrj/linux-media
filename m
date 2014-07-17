Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36565 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbaGQMe4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 08:34:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] [RFC] [media] omap3isp: try to fix dependencies
Date: Thu, 17 Jul 2014 14:35:02 +0200
Message-ID: <2725974.cX7okUBUol@avalon>
In-Reply-To: <46586956.hxqoJOmDbk@wuerfel>
References: <46586956.hxqoJOmDbk@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

Sorry for the late reply.

On Friday 13 June 2014 14:02:01 Arnd Bergmann wrote:
> commit 2a0a5472af5c ("omap3isp: Use the ARM DMA IOMMU-aware operations")
> brought the omap3isp driver closer to using standard APIs, but also
> introduced two problems:
> 
> a) it selects a particular IOMMU driver for no good reason. This just
>    causes hard to track dependency chains, in my case breaking an
>    experimental patch set that tries to reenable !MMU support on ARM
>    multiplatform kernels. Since the driver doesn't have a dependency
>    on the actual IOMMU implementation (other than sitting on the same
>    SoC), this changes the 'select OMAP_IOMMU' to a generic 'depends on
>    IOMMU_API' that reflects the actual usage.

That sounds good to me.

> b) The driver incorrectly calls into low-level helpers designed to
>    be used by the IOMMU implementation:
>    arm_iommu_{create,attach,release}_mapping.

I agree with you, and that's my plan, but I haven't been able to fix the 
problem yet. It's somewhere on my (too big) to-do list.

Please note that, while the problem hasn't been introduced by commit 
2a0a5472af5c, the driver was in an even worse shape before that, as it called 
in the OMAP IOMMU driver directly.

>    I'm not fixing this here, but adding a FIXME and a dependency on
>    ARM_DMA_USE_IOMMU. I believe the correct solution is to move the calls
>    into the omap iommu driver that currently doesn't have them, and change
>    the isp driver to call generic functions.

OMAP_IOMMU doesn't select ARM_DMA_USE_IOMMU :-/ That should be fixed first, 
otherwise the OMAP3 ISP driver won't be available at all.

> In addition, this also adds the missing 'select VIDEOBUF2_DMA_CONTIG'
> that is needed since fbac1400bd1 ("[media] omap3isp: Move to videobuf2")

That's already fixed in my tree, so I'll skip that part.

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> ----
> 
> Hi Laurent,
> 
> Could you have a look at this? It's possible I'm missing something
> important here, but this is what I currently need to get randconfig
> builds to use the omap3isp driver.
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 8108c69..15bf61b 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -94,8 +94,9 @@ config VIDEO_M32R_AR_M64278
>  config VIDEO_OMAP3
>  	tristate "OMAP 3 Camera support"
>  	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
> -	select ARM_DMA_USE_IOMMU
> -	select OMAP_IOMMU
> +	depends on ARM_DMA_USE_IOMMU # FIXME: use iommu API instead of low-level
> ARM calls +	depends on IOMMU_API
> +	select VIDEOBUF2_DMA_CONTIG
>  	---help---
>  	  Driver for an OMAP 3 camera controller.

-- 
Regards,

Laurent Pinchart

