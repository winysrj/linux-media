Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:47862 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbcCYCRo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 22:17:44 -0400
Date: Fri, 25 Mar 2016 11:17:38 +0900
From: Simon Horman <horms@verge.net.au>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v2] media: rcar_vin: Use ARCH_RENESAS
Message-ID: <20160325021738.GD31681@verge.net.au>
References: <1457399035-14527-1-git-send-email-horms+renesas@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1457399035-14527-1-git-send-email-horms+renesas@verge.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 08, 2016 at 10:03:55AM +0900, Simon Horman wrote:
> Make use of ARCH_RENESAS in place of ARCH_SHMOBILE.
> 
> This is part of an ongoing process to migrate from ARCH_SHMOBILE to
> ARCH_RENESAS the motivation for which being that RENESAS seems to be a more
> appropriate name than SHMOBILE for the majority of Renesas ARM based SoCs.
> 
> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>

Hi Guennadi,

I am wondering if you could consider applying this patch.

Thanks!

> ---
> Based on media-tree/next

The above should have been media-tree/master

> 
> v2
> * Break out of a (slightly) larger patch
> ---
>  drivers/media/platform/soc_camera/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
> index 355298989dd8..08db3b040bbe 100644
> --- a/drivers/media/platform/soc_camera/Kconfig
> +++ b/drivers/media/platform/soc_camera/Kconfig
> @@ -28,7 +28,7 @@ config VIDEO_PXA27x
>  config VIDEO_RCAR_VIN
>  	tristate "R-Car Video Input (VIN) support"
>  	depends on VIDEO_DEV && SOC_CAMERA
> -	depends on ARCH_SHMOBILE || COMPILE_TEST
> +	depends on ARCH_RENESAS || COMPILE_TEST
>  	depends on HAS_DMA
>  	select VIDEOBUF2_DMA_CONTIG
>  	select SOC_CAMERA_SCALE_CROP
> -- 
> 2.1.4
> 
