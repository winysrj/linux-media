Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58516 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaBXSg6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Feb 2014 13:36:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Phil Edworthy <phil.edworthy@renesas.com>
Cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Valentine Barshak <valentine.barshak@cogentembedded.com>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] media: soc_camera: rcar_vin: Add support for 10-bit YUV cameras
Date: Mon, 24 Feb 2014 19:38:14 +0100
Message-ID: <2516843.7QqJLHtUZT@avalon>
In-Reply-To: <1393256945-12781-1-git-send-email-phil.edworthy@renesas.com>
References: <1393256945-12781-1-git-send-email-phil.edworthy@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Phil,

Thank you for the patch.

On Monday 24 February 2014 15:49:05 Phil Edworthy wrote:
> Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
> ---
>  drivers/media/platform/soc_camera/rcar_vin.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c
> b/drivers/media/platform/soc_camera/rcar_vin.c index 3b1c05a..9929375
> 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -68,6 +68,8 @@
>  #define VNMC_YCAL		(1 << 19)
>  #define VNMC_INF_YUV8_BT656	(0 << 16)
>  #define VNMC_INF_YUV8_BT601	(1 << 16)
> +#define VNMC_INF_YUV10_BT656	(2 << 16)
> +#define VNMC_INF_YUV10_BT601	(3 << 16)
>  #define VNMC_INF_YUV16		(5 << 16)
>  #define VNMC_VUP		(1 << 10)
>  #define VNMC_IM_ODD		(0 << 3)
> @@ -275,6 +277,10 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
>  		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
>  		vnmc |= priv->pdata->flags & RCAR_VIN_BT656 ?
>  			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;

Aren't you missing a break here ?

> +	case V4L2_MBUS_FMT_YUYV10_2X10:
> +		/* BT.656 10bit YCbCr422 or BT.601 10bit YCbCr422 */
> +		vnmc |= priv->pdata->flags & RCAR_VIN_BT656 ?
> +			VNMC_INF_YUV10_BT656 : VNMC_INF_YUV10_BT601;

You should add one here as well. Although not strictly necessary, it would 
help to avoid making the same mistake again.

The rest looks good to me, but I'm not familiar with the hardware, so I'll let 
Valentine have the last word.

>  	default:
>  		break;
>  	}
> @@ -1003,6 +1009,7 @@ static int rcar_vin_get_formats(struct
> soc_camera_device *icd, unsigned int idx, switch (code) {
>  	case V4L2_MBUS_FMT_YUYV8_1X16:
>  	case V4L2_MBUS_FMT_YUYV8_2X8:
> +	case V4L2_MBUS_FMT_YUYV10_2X10:
>  		if (cam->extra_fmt)
>  			break;

-- 
Regards,

Laurent Pinchart

