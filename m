Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:43944 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbbFWXtc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2015 19:49:32 -0400
Date: Wed, 24 Jun 2015 08:49:29 +0900
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH] [media] rcar_vin: Remove obsolete r8a779x-vin
 platform_device_id entries
Message-ID: <20150623234928.GE9988@verge.net.au>
References: <1435064383-11589-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1435064383-11589-1-git-send-email-geert+renesas@glider.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 23, 2015 at 02:59:43PM +0200, Geert Uytterhoeven wrote:
> Since commit a483dcbfa21f919c ("ARM: shmobile: lager: Remove legacy
> board support"), R-Car Gen2 SoCs are only supported in generic DT-only
> ARM multi-platform builds.  The driver doesn't need to match platform
> devices by name anymore, hence remove the corresponding
> platform_device_id entry.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Acked-by: Simon Horman <horms+renesas@verge.net.au>

> ---
>  drivers/media/platform/soc_camera/rcar_vin.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index db7700b0af7cd569..ef784d311253b142 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -1834,8 +1834,6 @@ MODULE_DEVICE_TABLE(of, rcar_vin_of_table);
>  #endif
>  
>  static struct platform_device_id rcar_vin_id_table[] = {
> -	{ "r8a7791-vin",  RCAR_GEN2 },
> -	{ "r8a7790-vin",  RCAR_GEN2 },
>  	{ "r8a7779-vin",  RCAR_H1 },
>  	{ "r8a7778-vin",  RCAR_M1 },
>  	{ "uPD35004-vin", RCAR_E1 },
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
