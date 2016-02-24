Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37510 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbcBXGBQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2016 01:01:16 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Simon Horman <horms+renesas@verge.net.au>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] media: platform: rcar_jpu, sh_vou, vsp1: Use ARCH_RENESAS
Date: Wed, 24 Feb 2016 08:01:14 +0200
Message-ID: <3147644.epaEbgJTgL@avalon>
In-Reply-To: <1456280542-13113-1-git-send-email-horms+renesas@verge.net.au>
References: <1456280542-13113-1-git-send-email-horms+renesas@verge.net.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Simon,

Thank you for the patch.

On Wednesday 24 February 2016 11:22:22 Simon Horman wrote:
> Make use of ARCH_RENESAS in place of ARCH_SHMOBILE.
> 
> This is part of an ongoing process to migrate from ARCH_SHMOBILE to
> ARCH_RENESAS the motivation for which being that RENESAS seems to be a more
> appropriate name than SHMOBILE for the majority of Renesas ARM based SoCs.
> 
> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/Kconfig | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
>  Based on media_tree/master
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 201f5c296a95..662c029400de 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -37,7 +37,7 @@ config VIDEO_SH_VOU
>  	tristate "SuperH VOU video output driver"
>  	depends on MEDIA_CAMERA_SUPPORT
>  	depends on VIDEO_DEV && I2C && HAS_DMA
> -	depends on ARCH_SHMOBILE || COMPILE_TEST
> +	depends on ARCH_RENESAS || COMPILE_TEST
>  	select VIDEOBUF2_DMA_CONTIG
>  	help
>  	  Support for the Video Output Unit (VOU) on SuperH SoCs.
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

