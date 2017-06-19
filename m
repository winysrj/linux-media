Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44842 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751897AbdFSJqg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 05:46:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kbingham@kernel.org>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        geert@glider.be, kieran.bingham@ideasonboard.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v2] media: fdp1: Support ES2 platforms
Date: Mon, 19 Jun 2017 12:47:09 +0300
Message-ID: <2726594.YBGsFatGlI@avalon>
In-Reply-To: <1497263416-17930-1-git-send-email-kbingham@kernel.org>
References: <1497263416-17930-1-git-send-email-kbingham@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Monday 12 Jun 2017 11:30:16 Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> The new Renesas R-Car H3 ES2.0 platforms have a new hw version register.
> Update the driver accordingly, defaulting to the new hw revision, and
> differentiating the older revision as ES1
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar_fdp1.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar_fdp1.c
> b/drivers/media/platform/rcar_fdp1.c index 42f25d241edd..159786b052f3
> 100644
> --- a/drivers/media/platform/rcar_fdp1.c
> +++ b/drivers/media/platform/rcar_fdp1.c
> @@ -258,8 +258,9 @@ MODULE_PARM_DESC(debug, "activate debug info");
> 
>  /* Internal Data (HW Version) */
>  #define FD1_IP_INTDATA			0x0800
> -#define FD1_IP_H3			0x02010101
> +#define FD1_IP_H3_ES1			0x02010101
>  #define FD1_IP_M3W			0x02010202
> +#define FD1_IP_H3			0x02010203
> 
>  /* LUTs */
>  #define FD1_LUT_DIF_ADJ			0x1000
> @@ -2359,12 +2360,15 @@ static int fdp1_probe(struct platform_device *pdev)
> 
>  	hw_version = fdp1_read(fdp1, FD1_IP_INTDATA);
>  	switch (hw_version) {
> -	case FD1_IP_H3:
> -		dprintk(fdp1, "FDP1 Version R-Car H3\n");
> +	case FD1_IP_H3_ES1:
> +		dprintk(fdp1, "FDP1 Version R-Car H3 ES1\n");
>  		break;
>  	case FD1_IP_M3W:
>  		dprintk(fdp1, "FDP1 Version R-Car M3-W\n");
>  		break;
> +	case FD1_IP_H3:
> +		dprintk(fdp1, "FDP1 Version R-Car H3\n");
> +		break;
>  	default:
>  		dev_err(fdp1->dev, "FDP1 Unidentifiable (0x%08x)\n",
>  				hw_version);

-- 
Regards,

Laurent Pinchart
