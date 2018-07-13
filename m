Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:45110 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbeGMHuK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jul 2018 03:50:10 -0400
Date: Fri, 13 Jul 2018 09:36:43 +0200
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] v4l: rcar_fdp1: Enable compilation on Gen2 platforms
Message-ID: <20180713073642.zhvduzgdryon4iqc@verge.net.au>
References: <20180711142332.4324-1-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180711142332.4324-1-geert+renesas@glider.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 11, 2018 at 04:23:32PM +0200, Geert Uytterhoeven wrote:
> From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> 
> Commit 1d3897143815 ("[media] v4l: rcar_fdp1: add FCP dependency") fixed
> a compilation breakage when the optional VIDEO_RENESAS_FCP dependency is
> compiled as a module while the rcar_fdp1 driver is built in. As a side
> effect it disabled compilation on Gen2 by disallowing the valid
> combination ARCH_RENESAS && !VIDEO_RENESAS_FCP. Fix it by handling the
> dependency the same way the vsp1 driver did in commit 199946731fa4
> ("[media] vsp1: clarify FCP dependency").
> 
> Fixes: 1d3897143815 ("[media] v4l: rcar_fdp1: add FCP dependency")
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Simon Horman <horms+renesas@verge.net.au>

> ---
>  drivers/media/platform/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 210b44a457eb66f0..84cb97eccb2a52bc 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -385,7 +385,7 @@ config VIDEO_RENESAS_FDP1
>  	tristate "Renesas Fine Display Processor"
>  	depends on VIDEO_DEV && VIDEO_V4L2
>  	depends on ARCH_RENESAS || COMPILE_TEST
> -	depends on (!ARCH_RENESAS && !VIDEO_RENESAS_FCP) || VIDEO_RENESAS_FCP
> +	depends on (!ARM64 && !VIDEO_RENESAS_FCP) || VIDEO_RENESAS_FCP
>  	select VIDEOBUF2_DMA_CONTIG
>  	select V4L2_MEM2MEM_DEV
>  	---help---
> -- 
> 2.17.1
> 
