Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59170 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbbHUUpU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 16:45:20 -0400
Date: Fri, 21 Aug 2015 17:45:15 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@iki.fi
Subject: Re: [PATCH] v4l: omap3isp: Enable driver compilation with
 COMPILE_TEST
Message-ID: <20150821174515.360b87e9@recife.lan>
In-Reply-To: <1440180557-28180-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1440180557-28180-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 21 Aug 2015 21:09:17 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> The omap3isp driver can't be compiled on non-ARM platforms but has no
> compile-time dependency on OMAP. Drop the OMAP dependency when
> COMPILE_TEST is set.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/platform/Kconfig | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 484038185ae3..95f0f6e6bbc8 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -85,7 +85,9 @@ config VIDEO_M32R_AR_M64278
>  
>  config VIDEO_OMAP3
>  	tristate "OMAP 3 Camera support"
> -	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
> +	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
> +	depends on ARCH_OMAP3 || COMPILE_TEST
> +	depends on ARM
>  	depends on HAS_DMA && OF
>  	depends on OMAP_IOMMU
>  	select ARM_DMA_USE_IOMMU

Sorry, but this doesn't make sense.

We can only add COMPILE_TEST after getting rid of those
	depends on OMAP_IOMMU
  	select ARM_DMA_USE_IOMMU

The COMPILE_TEST flag was added to support building drivers with
allyesconfig/allmodconfig for all archs. Selecting a sub-arch
specific configuration doesn't help at all (or make any difference,
as if such subarch is already selected, a make allmodconfig/allyesconfig
will build the driver anyway).

One of the main reasons why this is interesting is to support the
Coverity Scan community license, used by the Kernel janitors. This
tool runs only on x86.

Regards,
Mauro
