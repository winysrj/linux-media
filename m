Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:55819 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab3J2FGh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Oct 2013 01:06:37 -0400
Date: Tue, 29 Oct 2013 14:06:35 +0900
From: Simon Horman <horms@verge.net.au>
To: Valentine Barshak <valentine.barshak@cogentembedded.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-sh@vger.kernel.org
Subject: Re: [PATCH] media: rcar_vin: Add preliminary r8a7790 support
Message-ID: <20131029050635.GG20432@verge.net.au>
References: <1380896452-10687-1-git-send-email-valentine.barshak@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380896452-10687-1-git-send-email-valentine.barshak@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 04, 2013 at 06:20:52PM +0400, Valentine Barshak wrote:
> Signed-off-by: Valentine Barshak <valentine.barshak@cogentembedded.com>

This looks entirely sane to me.

Acked-by: Simon Horman <horms+renesas@verge.net.au>

Mauro, would you consider taking this?

> ---
>  drivers/media/platform/soc_camera/rcar_vin.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index d02a7e0..b21f777 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -105,6 +105,7 @@
>  #define VIN_MAX_HEIGHT		2048
>  
>  enum chip_id {
> +	RCAR_H2,
>  	RCAR_H1,
>  	RCAR_M1,
>  	RCAR_E1,
> @@ -300,7 +301,8 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
>  		dmr = 0;
>  		break;
>  	case V4L2_PIX_FMT_RGB32:
> -		if (priv->chip == RCAR_H1 || priv->chip == RCAR_E1) {
> +		if (priv->chip == RCAR_H2 || priv->chip == RCAR_H1 ||
> +		    priv->chip == RCAR_E1) {
>  			dmr = VNDMR_EXRGB;
>  			break;
>  		}
> @@ -1381,6 +1383,7 @@ static struct soc_camera_host_ops rcar_vin_host_ops = {
>  };
>  
>  static struct platform_device_id rcar_vin_id_table[] = {
> +	{ "r8a7790-vin",  RCAR_H2 },
>  	{ "r8a7779-vin",  RCAR_H1 },
>  	{ "r8a7778-vin",  RCAR_M1 },
>  	{ "uPD35004-vin", RCAR_E1 },
> -- 
> 1.8.3.1
> 
