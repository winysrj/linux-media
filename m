Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:61691 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbaBYNko (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 08:40:44 -0500
Received: by mail-la0-f41.google.com with SMTP id gl10so4232903lab.28
        for <linux-media@vger.kernel.org>; Tue, 25 Feb 2014 05:40:43 -0800 (PST)
Message-ID: <530C9D58.5080909@cogentembedded.com>
Date: Tue, 25 Feb 2014 17:40:40 +0400
From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
MIME-Version: 1.0
To: Phil Edworthy <phil.edworthy@renesas.com>
CC: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Valentine Barshak <valentine.barshak@cogentembedded.com>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v2] media: soc_camera: rcar_vin: Add support for 10-bit
 YUV cameras
References: <2516843.7QqJLHtUZT@avalon> <1393319427-14515-1-git-send-email-phil.edworthy@renesas.com>
In-Reply-To: <1393319427-14515-1-git-send-email-phil.edworthy@renesas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/25/2014 01:10 PM, Phil Edworthy wrote:
> Signed-off-by: Phil Edworthy<phil.edworthy@renesas.com>
Acked-by: Vladimir Barinov<vladimir.barinov@cogentembedded.com>

(Valentine can't do the review atm)

> ---
> v2:
>    - Fix silly mistake with missing break.
>
>   drivers/media/platform/soc_camera/rcar_vin.c |    9 +++++++++
>   1 file changed, 9 insertions(+)
>
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 3b1c05a..702dc47 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -68,6 +68,8 @@
>   #define VNMC_YCAL		(1<<  19)
>   #define VNMC_INF_YUV8_BT656	(0<<  16)
>   #define VNMC_INF_YUV8_BT601	(1<<  16)
> +#define VNMC_INF_YUV10_BT656	(2<<  16)
> +#define VNMC_INF_YUV10_BT601	(3<<  16)
>   #define VNMC_INF_YUV16		(5<<  16)
>   #define VNMC_VUP		(1<<  10)
>   #define VNMC_IM_ODD		(0<<  3)
> @@ -275,6 +277,12 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
>   		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
>   		vnmc |= priv->pdata->flags&  RCAR_VIN_BT656 ?
>   			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
> +		break;
> +	case V4L2_MBUS_FMT_YUYV10_2X10:
> +		/* BT.656 10bit YCbCr422 or BT.601 10bit YCbCr422 */
> +		vnmc |= priv->pdata->flags&  RCAR_VIN_BT656 ?
> +			VNMC_INF_YUV10_BT656 : VNMC_INF_YUV10_BT601;
> +		break;
>   	default:
>   		break;
>   	}
> @@ -1003,6 +1011,7 @@ static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
>   	switch (code) {
>   	case V4L2_MBUS_FMT_YUYV8_1X16:
>   	case V4L2_MBUS_FMT_YUYV8_2X8:
> +	case V4L2_MBUS_FMT_YUYV10_2X10:
>   		if (cam->extra_fmt)
>   			break;
>
Regards,
Vladimir


