Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40530 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbcCYHen (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 03:34:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Simon Horman <horms+renesas@verge.net.au>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 repost] media: platform: rcar_jpu, vsp1: Use ARCH_RENESAS
Date: Fri, 25 Mar 2016 09:34:42 +0200
Message-ID: <2074694.MndprWQbmU@avalon>
In-Reply-To: <20160325014645.GA31681@verge.net.au>
References: <20160325014645.GA31681@verge.net.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Simon,

On Friday 25 Mar 2016 10:46:45 Simon Horman wrote:
> Make use of ARCH_RENESAS in place of ARCH_SHMOBILE.
> 
> This is part of an ongoing process to migrate from ARCH_SHMOBILE to
> ARCH_RENESAS the motivation for which being that RENESAS seems to be a more
> appropriate name than SHMOBILE for the majority of Renesas ARM based SoCs.
> 
> Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
> ---
> Mauro, please consider applying this patch.

I'll send a large pull request to Mauro for v4.7, I'll include this patch in 
it.

> Based on media-tree/master
> 
> v3
> * Update subject to not refer to sh_vou
> * Added acks from Laurent Pinchart and Hans Verkuil
> 
> v2
> * Do not update VIDEO_SH_VOU to use ARCH_RENESAS as this is
>   used by some SH-based platforms and is not used by any ARM-based platforms
> so a dependency on ARCH_SHMOBILE is correct for that driver
> * Added Geert Uytterhoeven's Ack
> ---
>  drivers/media/platform/Kconfig | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 201f5c296a95..84e041c0a70e 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -238,7 +238,7 @@ config VIDEO_SH_VEU
>  config VIDEO_RENESAS_JPU
>  	tristate "Renesas JPEG Processing Unit"
>  	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
> -	depends on ARCH_SHMOBILE || COMPILE_TEST
> +	depends on ARCH_RENESAS || COMPILE_TEST
>  	select VIDEOBUF2_DMA_CONTIG
>  	select V4L2_MEM2MEM_DEV
>  	---help---
> @@ -250,7 +250,7 @@ config VIDEO_RENESAS_JPU
>  config VIDEO_RENESAS_VSP1
>  	tristate "Renesas VSP1 Video Processing Engine"
>  	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
> -	depends on (ARCH_SHMOBILE && OF) || COMPILE_TEST
> +	depends on (ARCH_RENESAS && OF) || COMPILE_TEST
>  	select VIDEOBUF2_DMA_CONTIG
>  	---help---
>  	  This is a V4L2 driver for the Renesas VSP1 video processing engine.

-- 
Regards,

Laurent Pinchart

