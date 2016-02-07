Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:58042 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893AbcBGNuF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Feb 2016 08:50:05 -0500
Date: Sun, 7 Feb 2016 14:49:52 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>
cc: linux-media@vger.kernel.org, Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH v5] media: soc_camera: rcar_vin: Add ARGB8888 caputre
 format support
In-Reply-To: <1453652009-4291-1-git-send-email-ykaneko0929@gmail.com>
Message-ID: <Pine.LNX.4.64.1602071449170.11458@axis700.grange>
References: <1453652009-4291-1-git-send-email-ykaneko0929@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kaneko-san,

On Mon, 25 Jan 2016, Yoshihiro Kaneko wrote:

> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> 
> This patch adds ARGB8888 capture format support for R-Car Gen3.
> 
> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>

Thanks for the patch. I'll queue it for 4.6.

Guennadi

> ---
> 
> This patch is based on the for-4.6-1 branch of Guennadi's v4l-dvb tree.
> 
> v5 [Yoshihiro Kaneko]
> * As suggested by Guennadi Liakhovetski
>   rcar_vin_setup():
>     - add a common error handler instead of a falling through to the
>       default case.
> * compile tested only
> 
> v4 [Yoshihiro Kaneko]
> * As suggested by Sergei Shtylyov
>   - revised an error message.
> 
> v3 [Yoshihiro Kaneko]
> * rebased to for-4.6-1 branch of Guennadi's tree.
> 
> v2 [Yoshihiro Kaneko]
> * As suggested by Sergei Shtylyov
>   - fix the coding style of the braces.
> 
>  drivers/media/platform/soc_camera/rcar_vin.c | 39 +++++++++++++++++++++-------
>  1 file changed, 29 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index dc75a80..3b8edf4 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -124,7 +124,7 @@
>  #define VNDMR_EXRGB		(1 << 8)
>  #define VNDMR_BPSM		(1 << 4)
>  #define VNDMR_DTMD_YCSEP	(1 << 1)
> -#define VNDMR_DTMD_ARGB1555	(1 << 0)
> +#define VNDMR_DTMD_ARGB		(1 << 0)
>  
>  /* Video n Data Mode Register 2 bits */
>  #define VNDMR2_VPS		(1 << 30)
> @@ -643,21 +643,26 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
>  		output_is_yuv = true;
>  		break;
>  	case V4L2_PIX_FMT_RGB555X:
> -		dmr = VNDMR_DTMD_ARGB1555;
> +		dmr = VNDMR_DTMD_ARGB;
>  		break;
>  	case V4L2_PIX_FMT_RGB565:
>  		dmr = 0;
>  		break;
>  	case V4L2_PIX_FMT_RGB32:
> -		if (priv->chip == RCAR_GEN2 || priv->chip == RCAR_H1 ||
> -		    priv->chip == RCAR_E1) {
> -			dmr = VNDMR_EXRGB;
> -			break;
> -		}
> +		if (priv->chip != RCAR_GEN2 && priv->chip != RCAR_H1 &&
> +		    priv->chip != RCAR_E1)
> +			goto e_format;
> +
> +		dmr = VNDMR_EXRGB;
> +		break;
> +	case V4L2_PIX_FMT_ARGB32:
> +		if (priv->chip != RCAR_GEN3)
> +			goto e_format;
> +
> +		dmr = VNDMR_EXRGB | VNDMR_DTMD_ARGB;
> +		break;
>  	default:
> -		dev_warn(icd->parent, "Invalid fourcc format (0x%x)\n",
> -			 icd->current_fmt->host_fmt->fourcc);
> -		return -EINVAL;
> +		goto e_format;
>  	}
>  
>  	/* Always update on field change */
> @@ -679,6 +684,11 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
>  	iowrite32(vnmc | VNMC_ME, priv->base + VNMC_REG);
>  
>  	return 0;
> +
> +e_format:
> +	dev_warn(icd->parent, "Invalid fourcc format (0x%x)\n",
> +		 icd->current_fmt->host_fmt->fourcc);
> +	return -EINVAL;
>  }
>  
>  static void rcar_vin_capture(struct rcar_vin_priv *priv)
> @@ -1304,6 +1314,14 @@ static const struct soc_mbus_pixelfmt rcar_vin_formats[] = {
>  		.order			= SOC_MBUS_ORDER_LE,
>  		.layout			= SOC_MBUS_LAYOUT_PACKED,
>  	},
> +	{
> +		.fourcc			= V4L2_PIX_FMT_ARGB32,
> +		.name			= "ARGB8888",
> +		.bits_per_sample	= 32,
> +		.packing		= SOC_MBUS_PACKING_NONE,
> +		.order			= SOC_MBUS_ORDER_LE,
> +		.layout			= SOC_MBUS_LAYOUT_PACKED,
> +	},
>  };
>  
>  static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
> @@ -1611,6 +1629,7 @@ static int rcar_vin_set_fmt(struct soc_camera_device *icd,
>  	case V4L2_PIX_FMT_RGB32:
>  		can_scale = priv->chip != RCAR_E1;
>  		break;
> +	case V4L2_PIX_FMT_ARGB32:
>  	case V4L2_PIX_FMT_UYVY:
>  	case V4L2_PIX_FMT_YUYV:
>  	case V4L2_PIX_FMT_RGB565:
> -- 
> 1.9.1
> 
