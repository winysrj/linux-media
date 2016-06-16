Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50168 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbcFPQzf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 12:55:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
	<niklas.soderlund@ragnatech.se>
Cc: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl, linux-renesas-soc@vger.kernel.org,
	Niklas =?ISO-8859-1?Q?S=F6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: Re: [PATCH 8/8] [media] rcar-vin: add Gen2 and Gen3 fallback compatibility strings
Date: Thu, 16 Jun 2016 19:55:45 +0300
Message-ID: <1936185.UPrUXuTa67@avalon>
In-Reply-To: <1464203409-1279-9-git-send-email-niklas.soderlund@ragnatech.se>
References: <1464203409-1279-1-git-send-email-niklas.soderlund@ragnatech.se> <1464203409-1279-9-git-send-email-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Wednesday 25 May 2016 21:10:09 Niklas Söderlund wrote:
> From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
> These are present in the soc-camera version of this driver and it's time
> to add them to this driver as well.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index 520690c..87041db 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -33,6 +33,8 @@ static const struct of_device_id rvin_of_id_table[] = {
>  	{ .compatible = "renesas,vin-r8a7790", .data = (void *)RCAR_GEN2 },
>  	{ .compatible = "renesas,vin-r8a7779", .data = (void *)RCAR_H1 },
>  	{ .compatible = "renesas,vin-r8a7778", .data = (void *)RCAR_M1 },
> +	{ .compatible = "renesas,rcar-gen3-vin", .data = (void *)RCAR_GEN3 },
> +	{ .compatible = "renesas,rcar-gen2-vin", .data = (void *)RCAR_GEN2 },
>  	{ },
>  };
>  MODULE_DEVICE_TABLE(of, rvin_of_id_table);

-- 
Regards,

Laurent Pinchart

