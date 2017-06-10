Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48840 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751830AbdFJHyG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Jun 2017 03:54:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kbingham@kernel.org>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        geert@glider.be, kieran.bingham@ideasonboard.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH] media: fdp1: Support ES2 platforms
Date: Sat, 10 Jun 2017 10:54:20 +0300
Message-ID: <2460969.iCu4XJLJFm@avalon>
In-Reply-To: <1497028548-24443-1-git-send-email-kbingham@kernel.org>
References: <1497028548-24443-1-git-send-email-kbingham@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Friday 09 Jun 2017 18:15:48 Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> The new Renesas R-Car H3 ES2.0 platforms have an updated hw version
> register. Update the driver accordingly.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/rcar_fdp1.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/media/platform/rcar_fdp1.c
> b/drivers/media/platform/rcar_fdp1.c index 42f25d241edd..50b59995b817
> 100644
> --- a/drivers/media/platform/rcar_fdp1.c
> +++ b/drivers/media/platform/rcar_fdp1.c
> @@ -260,6 +260,7 @@ MODULE_PARM_DESC(debug, "activate debug info");
>  #define FD1_IP_INTDATA			0x0800
>  #define FD1_IP_H3			0x02010101
>  #define FD1_IP_M3W			0x02010202
> +#define FD1_IP_H3_ES2			0x02010203

Following our global policy of treating ES2 as the default, how about renaming 
FDP1_IP_H3 to FDP1_IP_H3_ES1 and adding a new FD1_IP_H3 for ES2 ? The messages 
below should be updated as well.

Apart from that the patch looks good to me, so

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  /* LUTs */
>  #define FD1_LUT_DIF_ADJ			0x1000
> @@ -2365,6 +2366,9 @@ static int fdp1_probe(struct platform_device *pdev)
>  	case FD1_IP_M3W:
>  		dprintk(fdp1, "FDP1 Version R-Car M3-W\n");
>  		break;
> +	case FD1_IP_H3_ES2:
> +		dprintk(fdp1, "FDP1 Version R-Car H3-ES2\n");
> +		break;
>  	default:
>  		dev_err(fdp1->dev, "FDP1 Unidentifiable (0x%08x)\n",
>  				hw_version);

-- 
Regards,

Laurent Pinchart
