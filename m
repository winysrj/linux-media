Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:35642 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaJ0Hlb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Oct 2014 03:41:31 -0400
Date: Mon, 27 Oct 2014 16:41:28 +0900
From: Simon Horman <horms@verge.net.au>
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH v2] media: soc_camera: rcar_vin: Enable VSYNC field
 toggle mode
Message-ID: <20141027074127.GI21182@verge.net.au>
References: <1413950736-8230-1-git-send-email-ykaneko0929@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413950736-8230-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 22, 2014 at 01:05:36PM +0900, Yoshihiro Kaneko wrote:
> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> 
> By applying this patch, it sets to VSYNC field toggle mode not only
> at the time of progressive mode but at the time of an interlace mode.
> 
> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>

Acked-by: Simon Horman <horms+renesas@verge.net.au>

Guennadi, could you consider this patch when you get a chance?

> ---
> 
> This patch is against master branch of linuxtv.org/media_tree.git.
> 
> v2 [Yoshihiro Kaneko]
> * improve the macro definition for the VLV field
> 
>  drivers/media/platform/soc_camera/rcar_vin.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 9300076..beaf8e5 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -107,6 +107,7 @@
>  #define VNDMR2_VPS		(1 << 30)
>  #define VNDMR2_HPS		(1 << 29)
>  #define VNDMR2_FTEV		(1 << 17)
> +#define VNDMR2_VLV(n)		((n & 0xf) << 12)
>  
>  #define VIN_MAX_WIDTH		2048
>  #define VIN_MAX_HEIGHT		2048
> @@ -827,7 +828,7 @@ static int rcar_vin_set_bus_param(struct soc_camera_device *icd)
>  	if (ret < 0 && ret != -ENOIOCTLCMD)
>  		return ret;
>  
> -	val = priv->field == V4L2_FIELD_NONE ? VNDMR2_FTEV : 0;
> +	val = VNDMR2_FTEV | VNDMR2_VLV(1);
>  	if (!(common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
>  		val |= VNDMR2_VPS;
>  	if (!(common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
> -- 
> 1.9.1
> 
