Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:60472 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbaJPFYZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Oct 2014 01:24:25 -0400
Date: Thu, 16 Oct 2014 07:24:20 +0200
From: Simon Horman <horms@verge.net.au>
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH] media: soc_camera: rcar_vin: Add YUYV capture format
 support
Message-ID: <20141016052419.GH1265@verge.net.au>
References: <1413267878-8222-1-git-send-email-ykaneko0929@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413267878-8222-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[CC Mauro Carvalho Chehab]

On Tue, Oct 14, 2014 at 03:24:38PM +0900, Yoshihiro Kaneko wrote:
> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> 
> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> ---
> 
> This patch is against master branch of linuxtv.org/media_tree.git.
> 
>  drivers/media/platform/soc_camera/rcar_vin.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

Acked-by: Simon Horman <horms+renesas@verge.net.au>

If the series needs reposting to a different CC list -
e.g. including Mauro - please let Kaneko-san or myself know.

> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 7eb4f1e..61c36b0 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -889,6 +889,14 @@ static const struct soc_mbus_pixelfmt rcar_vin_formats[] = {
>  		.layout			= SOC_MBUS_LAYOUT_PLANAR_Y_C,
>  	},
>  	{
> +		.fourcc			= V4L2_PIX_FMT_YUYV,
> +		.name			= "YUYV",
> +		.bits_per_sample	= 16,
> +		.packing		= SOC_MBUS_PACKING_NONE,
> +		.order			= SOC_MBUS_ORDER_LE,
> +		.layout			= SOC_MBUS_LAYOUT_PACKED,
> +	},
> +	{
>  		.fourcc			= V4L2_PIX_FMT_UYVY,
>  		.name			= "UYVY",
>  		.bits_per_sample	= 16,
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
