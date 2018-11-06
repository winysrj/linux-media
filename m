Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:50118 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387913AbeKFWrc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 17:47:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: niklas.soderlund@ragnatech.se, kieran.bingham@ideasonboard.com,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v4 5/6] media: rcar: rcar-csi2: Update V3M/E3 PHTW tables
Date: Tue, 06 Nov 2018 15:22:29 +0200
Message-ID: <5650007.KMox73GGi6@avalon>
In-Reply-To: <1541501667-28817-6-git-send-email-jacopo+renesas@jmondi.org>
References: <1541501667-28817-1-git-send-email-jacopo+renesas@jmondi.org> <1541501667-28817-6-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for the patch.

On Tuesday, 6 November 2018 12:54:26 EET Jacopo Mondi wrote:
> Update PHTW tables for V3M and E3 SoCs to the latest datasheet release
> (R-Car Series, 3rd Generation manual rev1.00 20181017).
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> 
> ---
> v1 -> v2:
> - Limit the PHTW table to 1125 MBps, according to Laurent's comment

Based on the assumption that the values haven't changed between v1 and v2,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 62 ++++++++++++--------------
>  1 file changed, 31 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c
> b/drivers/media/platform/rcar-vin/rcar-csi2.c index 695686b..99f5b76 100644
> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -152,37 +152,37 @@ static const struct rcsi2_mbps_reg
> phtw_mbps_h3_v3h_m3n[] = { };
> 
>  static const struct rcsi2_mbps_reg phtw_mbps_v3m_e3[] = {
> -	{ .mbps =   80, .reg = 0x00 },
> -	{ .mbps =   90, .reg = 0x20 },
> -	{ .mbps =  100, .reg = 0x40 },
> -	{ .mbps =  110, .reg = 0x02 },
> -	{ .mbps =  130, .reg = 0x22 },
> -	{ .mbps =  140, .reg = 0x42 },
> -	{ .mbps =  150, .reg = 0x04 },
> -	{ .mbps =  170, .reg = 0x24 },
> -	{ .mbps =  180, .reg = 0x44 },
> -	{ .mbps =  200, .reg = 0x06 },
> -	{ .mbps =  220, .reg = 0x26 },
> -	{ .mbps =  240, .reg = 0x46 },
> -	{ .mbps =  250, .reg = 0x08 },
> -	{ .mbps =  270, .reg = 0x28 },
> -	{ .mbps =  300, .reg = 0x0a },
> -	{ .mbps =  330, .reg = 0x2a },
> -	{ .mbps =  360, .reg = 0x4a },
> -	{ .mbps =  400, .reg = 0x0c },
> -	{ .mbps =  450, .reg = 0x2c },
> -	{ .mbps =  500, .reg = 0x0e },
> -	{ .mbps =  550, .reg = 0x2e },
> -	{ .mbps =  600, .reg = 0x10 },
> -	{ .mbps =  650, .reg = 0x30 },
> -	{ .mbps =  700, .reg = 0x12 },
> -	{ .mbps =  750, .reg = 0x32 },
> -	{ .mbps =  800, .reg = 0x52 },
> -	{ .mbps =  850, .reg = 0x72 },
> -	{ .mbps =  900, .reg = 0x14 },
> -	{ .mbps =  950, .reg = 0x34 },
> -	{ .mbps = 1000, .reg = 0x54 },
> -	{ .mbps = 1050, .reg = 0x74 },
> +	{ .mbps =   89, .reg = 0x00 },
> +	{ .mbps =   99, .reg = 0x20 },
> +	{ .mbps =  109, .reg = 0x40 },
> +	{ .mbps =  129, .reg = 0x02 },
> +	{ .mbps =  139, .reg = 0x22 },
> +	{ .mbps =  149, .reg = 0x42 },
> +	{ .mbps =  169, .reg = 0x04 },
> +	{ .mbps =  179, .reg = 0x24 },
> +	{ .mbps =  199, .reg = 0x44 },
> +	{ .mbps =  219, .reg = 0x06 },
> +	{ .mbps =  239, .reg = 0x26 },
> +	{ .mbps =  249, .reg = 0x46 },
> +	{ .mbps =  269, .reg = 0x08 },
> +	{ .mbps =  299, .reg = 0x28 },
> +	{ .mbps =  329, .reg = 0x0a },
> +	{ .mbps =  359, .reg = 0x2a },
> +	{ .mbps =  399, .reg = 0x4a },
> +	{ .mbps =  449, .reg = 0x0c },
> +	{ .mbps =  499, .reg = 0x2c },
> +	{ .mbps =  549, .reg = 0x0e },
> +	{ .mbps =  599, .reg = 0x2e },
> +	{ .mbps =  649, .reg = 0x10 },
> +	{ .mbps =  699, .reg = 0x30 },
> +	{ .mbps =  749, .reg = 0x12 },
> +	{ .mbps =  799, .reg = 0x32 },
> +	{ .mbps =  849, .reg = 0x52 },
> +	{ .mbps =  899, .reg = 0x72 },
> +	{ .mbps =  949, .reg = 0x14 },
> +	{ .mbps =  999, .reg = 0x34 },
> +	{ .mbps = 1049, .reg = 0x54 },
> +	{ .mbps = 1099, .reg = 0x74 },
>  	{ .mbps = 1125, .reg = 0x16 },
>  	{ /* sentinel */ },
>  };


-- 
Regards,

Laurent Pinchart
