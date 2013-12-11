Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42936 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab3LKMq0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Dec 2013 07:46:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 06/15] v4l: sh_vou: Enable driver compilation with COMPILE_TEST
Date: Wed, 11 Dec 2013 13:46:38 +0100
Message-ID: <1658704.CLqRDCzrbM@avalon>
In-Reply-To: <1385515117-23664-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1385515117-23664-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1385515117-23664-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Could you please pick this patch up for v3.14 ?

On Wednesday 27 November 2013 02:18:28 Laurent Pinchart wrote:
> This helps increasing build testing coverage.
> 
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Acked-by: Simon Horman <horms@verge.net.au>
> ---
>  drivers/media/platform/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index d7f0249..7f6ea65 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -36,7 +36,8 @@ source "drivers/media/platform/blackfin/Kconfig"
>  config VIDEO_SH_VOU
>  	tristate "SuperH VOU video output driver"
>  	depends on MEDIA_CAMERA_SUPPORT
> -	depends on VIDEO_DEV && ARCH_SHMOBILE && I2C
> +	depends on VIDEO_DEV && I2C
> +	depends on ARCH_SHMOBILE || COMPILE_TEST
>  	select VIDEOBUF_DMA_CONTIG
>  	help
>  	  Support for the Video Output Unit (VOU) on SuperH SoCs.
-- 
Regards,

Laurent Pinchart

