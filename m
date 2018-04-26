Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:33178 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752991AbeDZXLh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 19:11:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] rcar-vin: add support for MEDIA_BUS_FMT_UYVY8_1X16
Date: Fri, 27 Apr 2018 02:11:50 +0300
Message-ID: <1685701.LDGfZvZMSR@avalon>
In-Reply-To: <20180424234607.22867-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180424234607.22867-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Wednesday, 25 April 2018 02:46:07 EEST Niklas S=F6derlund wrote:
> By setting VNMC_YCAL rcar-vin can support input video in
> MEDIA_BUS_FMT_UYVY8_1X16 format.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 1 +
>  drivers/media/platform/rcar-vin/rcar-dma.c  | 5 +++++
>  2 files changed, 6 insertions(+)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index
> 55b745ac86a5884d..7bc2774a11232362 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -404,6 +404,7 @@ static int rvin_digital_subdevice_attach(struct rvin_=
dev
> *vin, code.index++;
>  		switch (code.code) {
>  		case MEDIA_BUS_FMT_YUYV8_1X16:
> +		case MEDIA_BUS_FMT_UYVY8_1X16:
>  		case MEDIA_BUS_FMT_UYVY8_2X8:
>  		case MEDIA_BUS_FMT_UYVY10_2X10:
>  		case MEDIA_BUS_FMT_RGB888_1X24:
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> b/drivers/media/platform/rcar-vin/rcar-dma.c index
> 4a3a195e7f59047c..ac07f99e3516a620 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -653,6 +653,10 @@ static int rvin_setup(struct rvin_dev *vin)
>  		vnmc |=3D VNMC_INF_YUV16;
>  		input_is_yuv =3D true;
>  		break;
> +	case MEDIA_BUS_FMT_UYVY8_1X16:
> +		vnmc |=3D VNMC_INF_YUV16 | VNMC_YCAL;
> +		input_is_yuv =3D true;
> +		break;
>  	case MEDIA_BUS_FMT_UYVY8_2X8:
>  		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
>  		vnmc |=3D vin->mbus_cfg.type =3D=3D V4L2_MBUS_BT656 ?
> @@ -1009,6 +1013,7 @@ static int rvin_mc_validate_format(struct rvin_dev
> *vin, struct v4l2_subdev *sd,
>=20
>  	switch (fmt.format.code) {
>  	case MEDIA_BUS_FMT_YUYV8_1X16:
> +	case MEDIA_BUS_FMT_UYVY8_1X16:
>  	case MEDIA_BUS_FMT_UYVY8_2X8:
>  	case MEDIA_BUS_FMT_UYVY10_2X10:
>  	case MEDIA_BUS_FMT_RGB888_1X24:


=2D-=20
Regards,

Laurent Pinchart
