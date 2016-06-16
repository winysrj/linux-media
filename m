Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50162 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbcFPQzS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 12:55:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
	<niklas.soderlund@ragnatech.se>
Cc: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl, linux-renesas-soc@vger.kernel.org,
	Niklas =?ISO-8859-1?Q?S=F6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: Re: [PATCH 7/8] [media] rcar-vin: enable Gen3
Date: Thu, 16 Jun 2016 19:55:28 +0300
Message-ID: <58668562.0vKzljaCLa@avalon>
In-Reply-To: <1464203409-1279-8-git-send-email-niklas.soderlund@ragnatech.se>
References: <1464203409-1279-1-git-send-email-niklas.soderlund@ragnatech.se> <1464203409-1279-8-git-send-email-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Wednesday 25 May 2016 21:10:08 Niklas Söderlund wrote:
> From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/Kconfig     | 2 +-
>  drivers/media/platform/rcar-vin/rcar-core.c | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/Kconfig
> b/drivers/media/platform/rcar-vin/Kconfig index b2ff2d4..ca3ea91 100644
> --- a/drivers/media/platform/rcar-vin/Kconfig
> +++ b/drivers/media/platform/rcar-vin/Kconfig
> @@ -5,7 +5,7 @@ config VIDEO_RCAR_VIN
>  	select VIDEOBUF2_DMA_CONTIG
>  	---help---
>  	  Support for Renesas R-Car Video Input (VIN) driver.
> -	  Supports R-Car Gen2 SoCs.
> +	  Supports R-Car Gen2 and Gen3 SoCs.
> 
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called rcar-vin.
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index d901ad0..520690c 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -26,6 +26,7 @@
>  #include "rcar-vin.h"
> 
>  static const struct of_device_id rvin_of_id_table[] = {
> +	{ .compatible = "renesas,vin-r8a7795", .data = (void *)RCAR_GEN3 },

This isn't needed with patch 8/8. I'd drop this hunk, and merge the previous 
one into 8/8.

>  	{ .compatible = "renesas,vin-r8a7794", .data = (void *)RCAR_GEN2 },
>  	{ .compatible = "renesas,vin-r8a7793", .data = (void *)RCAR_GEN2 },
>  	{ .compatible = "renesas,vin-r8a7791", .data = (void *)RCAR_GEN2 },

-- 
Regards,

Laurent Pinchart

