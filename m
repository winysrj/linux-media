Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36486 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102AbaGQMTV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 08:19:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Peter Meerwald <pmeerw@pmeerw.net>
Cc: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] media:platform: OMAP3 camera support needs VIDEOBUF2_DMA_CONTIG
Date: Thu, 17 Jul 2014 14:19:27 +0200
Message-ID: <3044366.fg7nMOhZ3L@avalon>
In-Reply-To: <1404460307-6434-1-git-send-email-pmeerw@pmeerw.net>
References: <1404460307-6434-1-git-send-email-pmeerw@pmeerw.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Peter,

Thank you for the patch.

On Friday 04 July 2014 09:51:47 Peter Meerwald wrote:
> drivers/built-in.o: In function `isp_video_open':
> /src/linux/drivers/media/platform/omap3isp/ispvideo.c:1253: undefined
> reference to `vb2_dma_contig_memops' drivers/built-in.o: In function
> `omap3isp_video_init':
> /src/linux/drivers/media/platform/omap3isp/ispvideo.c:1344: undefined
> reference to `vb2_dma_contig_init_ctx'
> /src/linux/drivers/media/platform/omap3isp/ispvideo.c:1350: undefined
> reference to `vb2_dma_contig_cleanup_ctx' drivers/built-in.o: In function
> `omap3isp_video_cleanup':
> /src/linux/drivers/media/platform/omap3isp/ispvideo.c:1381: undefined
> reference to `vb2_dma_contig_cleanup_ctx' make: *** [vmlinux] Error 1
> 
> Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree, with the "select VIDEOBUF2_DMA_CONTIG" and "select 
OMAP_IOMMU" lines swapped below to keep them alphabetically sorted.

> ---
> 
> not sure if this is the right way to fix, at least my kernel compiles
> 
>  drivers/media/platform/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 8108c69..e1ff228 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -95,6 +95,7 @@ config VIDEO_OMAP3
>  	tristate "OMAP 3 Camera support"
>  	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
>  	select ARM_DMA_USE_IOMMU
> +	select VIDEOBUF2_DMA_CONTIG
>  	select OMAP_IOMMU
>  	---help---
>  	  Driver for an OMAP 3 camera controller.

-- 
Regards,

Laurent Pinchart

