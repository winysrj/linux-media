Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39141 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab3LZOSS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Dec 2013 09:18:18 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Valentine Barshak <valentine.barshak@cogentembedded.com>
Cc: linux-sh@vger.kernel.org, linux-media@vger.kernel.org,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] media: soc_camera: rcar_vin: Add preliminary R-Car M2 support
Date: Thu, 26 Dec 2013 15:18:47 +0100
Message-ID: <1590143.Lfusyumoi4@avalon>
In-Reply-To: <1387830486-10650-1-git-send-email-valentine.barshak@cogentembedded.com>
References: <1387830486-10650-1-git-send-email-valentine.barshak@cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Valentine,

Thank you for the patch.

On Tuesday 24 December 2013 00:28:06 Valentine Barshak wrote:
> This adds R-Car M2 (R8A7791) VIN support.
> 
> Signed-off-by: Valentine Barshak <valentine.barshak@cogentembedded.com>
> ---
>  drivers/media/platform/soc_camera/rcar_vin.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c
> b/drivers/media/platform/soc_camera/rcar_vin.c index 6866bb4..8b79727
> 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -106,6 +106,7 @@
>  #define VIN_MAX_HEIGHT		2048
> 
>  enum chip_id {
> +	RCAR_M2,
>  	RCAR_H2,

What about renaming RCAR_H2 to RCAR_GEN2 instead, and using RCAR_GEN2 for both 
r8a7790 and r8a7791 (but keeping the "r8a7790-vin" and "r8a7791-vin" device 
IDs as you've done below) ? They're identical so far (at least from what's 
implemented in the driver, you might be aware of features specific to the H2 
or M2 that are not yet supported but will be implemented in the near future).

>  	RCAR_H1,
>  	RCAR_M1,
> @@ -302,8 +303,8 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
>  		dmr = 0;
>  		break;
>  	case V4L2_PIX_FMT_RGB32:
> -		if (priv->chip == RCAR_H2 || priv->chip == RCAR_H1 ||
> -		    priv->chip == RCAR_E1) {
> +		if (priv->chip == RCAR_M2 || priv->chip == RCAR_H2 ||
> +		    priv->chip == RCAR_H1 || priv->chip == RCAR_E1) {
>  			dmr = VNDMR_EXRGB;
>  			break;
>  		}
> @@ -1384,6 +1385,7 @@ static struct soc_camera_host_ops rcar_vin_host_ops =
> { };
> 
>  static struct platform_device_id rcar_vin_id_table[] = {
> +	{ "r8a7791-vin",  RCAR_M2 },
>  	{ "r8a7790-vin",  RCAR_H2 },
>  	{ "r8a7779-vin",  RCAR_H1 },
>  	{ "r8a7778-vin",  RCAR_M1 },

-- 
Regards,

Laurent Pinchart

