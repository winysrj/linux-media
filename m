Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:41904 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750949AbbFLGcG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 02:32:06 -0400
Message-ID: <557A7CDB.1010306@xs4all.nl>
Date: Fri, 12 Jun 2015 08:31:55 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
CC: guennadi liakhovetski <g.liakhovetski@gmx.de>,
	sergei shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 02/15] media: soc_camera: rcar_vin: Add BT.709 24-bit
 RGB888 input support
References: <1433340002-1691-1-git-send-email-william.towle@codethink.co.uk> <1433340002-1691-3-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1433340002-1691-3-git-send-email-william.towle@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/03/2015 03:59 PM, William Towle wrote:
> This adds V4L2_MBUS_FMT_RGB888_1X24 input format support
> which is used by the ADV7612 chip.
> 
> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> 
> Modified to use MEDIA_BUS_FMT_* constants
> 
> Signed-off-by: William Towle <william.towle@codethink.co.uk>
> Reviewed-by: Rob Taylor <rob.taylor@codethink.co.uk>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/platform/soc_camera/rcar_vin.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index db7700b..16352a8 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -98,6 +98,7 @@
>  #define VNMC_INF_YUV10_BT656	(2 << 16)
>  #define VNMC_INF_YUV10_BT601	(3 << 16)
>  #define VNMC_INF_YUV16		(5 << 16)
> +#define VNMC_INF_RGB888		(6 << 16)
>  #define VNMC_VUP		(1 << 10)
>  #define VNMC_IM_ODD		(0 << 3)
>  #define VNMC_IM_ODD_EVEN	(1 << 3)
> @@ -589,7 +590,7 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
>  	struct soc_camera_device *icd = priv->ici.icd;
>  	struct rcar_vin_cam *cam = icd->host_priv;
>  	u32 vnmc, dmr, interrupts;
> -	bool progressive = false, output_is_yuv = false;
> +	bool progressive = false, output_is_yuv = false, input_is_yuv = false;
>  
>  	switch (priv->field) {
>  	case V4L2_FIELD_TOP:
> @@ -623,16 +624,22 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
>  	case MEDIA_BUS_FMT_YUYV8_1X16:
>  		/* BT.601/BT.1358 16bit YCbCr422 */
>  		vnmc |= VNMC_INF_YUV16;
> +		input_is_yuv = true;
>  		break;
>  	case MEDIA_BUS_FMT_YUYV8_2X8:
>  		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
>  		vnmc |= priv->pdata_flags & RCAR_VIN_BT656 ?
>  			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
> +		input_is_yuv = true;
> +		break;
> +	case MEDIA_BUS_FMT_RGB888_1X24:
> +		vnmc |= VNMC_INF_RGB888;
>  		break;
>  	case MEDIA_BUS_FMT_YUYV10_2X10:
>  		/* BT.656 10bit YCbCr422 or BT.601 10bit YCbCr422 */
>  		vnmc |= priv->pdata_flags & RCAR_VIN_BT656 ?
>  			VNMC_INF_YUV10_BT656 : VNMC_INF_YUV10_BT601;
> +		input_is_yuv = true;
>  		break;
>  	default:
>  		break;
> @@ -676,7 +683,7 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
>  	vnmc |= VNMC_VUP;
>  
>  	/* If input and output use the same colorspace, use bypass mode */
> -	if (output_is_yuv)
> +	if (input_is_yuv == output_is_yuv)
>  		vnmc |= VNMC_BPS;
>  
>  	/* progressive or interlaced mode */
> @@ -1423,6 +1430,7 @@ static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
>  	case MEDIA_BUS_FMT_YUYV8_1X16:
>  	case MEDIA_BUS_FMT_YUYV8_2X8:
>  	case MEDIA_BUS_FMT_YUYV10_2X10:
> +	case MEDIA_BUS_FMT_RGB888_1X24:
>  		if (cam->extra_fmt)
>  			break;
>  
> 

