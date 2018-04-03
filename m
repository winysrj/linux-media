Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42757 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753824AbeDCWLd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Apr 2018 18:11:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v13 17/33] rcar-vin: cache video standard
Date: Wed, 04 Apr 2018 01:11:41 +0300
Message-ID: <2169799.4QuVgQcVPN@avalon>
In-Reply-To: <20180326214456.6655-18-niklas.soderlund+renesas@ragnatech.se>
References: <20180326214456.6655-1-niklas.soderlund+renesas@ragnatech.se> <20180326214456.6655-18-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Tuesday, 27 March 2018 00:44:40 EEST Niklas S=F6derlund wrote:
> At stream on time the driver should not query the subdevice for which
> standard are used. Instead it should be cached when userspace sets the
> standard and used at stream on time.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-core.c |  6 ++++++
>  drivers/media/platform/rcar-vin/rcar-dma.c  |  7 ++-----
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 10 ++++++++--
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  2 ++
>  4 files changed, 18 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index
> be49d8968f0a0cef..8c251687e81b345b 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -96,6 +96,12 @@ static int rvin_digital_subdevice_attach(struct rvin_d=
ev
> *vin, if (ret < 0 && ret !=3D -ENOIOCTLCMD && ret !=3D -ENODEV)
>  		return ret;
>=20
> +	/* Read standard */
> +	vin->std =3D V4L2_STD_UNKNOWN;
> +	ret =3D v4l2_subdev_call(subdev, video, g_std, &vin->std);
> +	if (ret < 0 && ret !=3D -ENOIOCTLCMD)
> +		return ret;
> +
>  	/* Add the controls */
>  	ret =3D v4l2_ctrl_handler_init(&vin->ctrl_handler, 16);
>  	if (ret < 0)
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> b/drivers/media/platform/rcar-vin/rcar-dma.c index
> 9233924e5b52de5f..79f4074b931b5aeb 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -592,7 +592,6 @@ void rvin_crop_scale_comp(struct rvin_dev *vin)
>  static int rvin_setup(struct rvin_dev *vin)
>  {
>  	u32 vnmc, dmr, dmr2, interrupts;
> -	v4l2_std_id std;
>  	bool progressive =3D false, output_is_yuv =3D false, input_is_yuv =3D f=
alse;
>=20
>  	switch (vin->format.field) {
> @@ -606,10 +605,8 @@ static int rvin_setup(struct rvin_dev *vin)
>  		/* Default to TB */
>  		vnmc =3D VNMC_IM_FULL;
>  		/* Use BT if video standard can be read and is 60 Hz format */
> -		if (!v4l2_subdev_call(vin_to_source(vin), video, g_std, &std)) {
> -			if (std & V4L2_STD_525_60)
> -				vnmc =3D VNMC_IM_FULL | VNMC_FOC;
> -		}
> +		if (vin->std & V4L2_STD_525_60)
> +			vnmc =3D VNMC_IM_FULL | VNMC_FOC;
>  		break;
>  	case V4L2_FIELD_INTERLACED_TB:
>  		vnmc =3D VNMC_IM_FULL;
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> c4be0bcb8b16f941..43370c57d4b6239a 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -477,6 +477,8 @@ static int rvin_s_std(struct file *file, void *priv,
> v4l2_std_id a) if (ret < 0)
>  		return ret;
>=20
> +	vin->std =3D a;
> +
>  	/* Changing the standard will change the width/height */
>  	return rvin_reset_format(vin);
>  }
> @@ -484,9 +486,13 @@ static int rvin_s_std(struct file *file, void *priv,
> v4l2_std_id a) static int rvin_g_std(struct file *file, void *priv,
> v4l2_std_id *a) {
>  	struct rvin_dev *vin =3D video_drvdata(file);
> -	struct v4l2_subdev *sd =3D vin_to_source(vin);
>=20
> -	return v4l2_subdev_call(sd, video, g_std, a);
> +	if (v4l2_subdev_has_op(vin_to_source(vin), pad, dv_timings_cap))
> +		return -ENOIOCTLCMD;
> +
> +	*a =3D vin->std;
> +
> +	return 0;
>  }
>=20
>  static int rvin_subscribe_event(struct v4l2_fh *fh,
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> e940366d7e8d0e76..06cec4f8e5ffaf2b 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -118,6 +118,7 @@ struct rvin_info {
>   * @crop:		active cropping
>   * @compose:		active composing
>   * @source:		active size of the video source
> + * @std:		active video standard of the video source
>   */
>  struct rvin_dev {
>  	struct device *dev;
> @@ -146,6 +147,7 @@ struct rvin_dev {
>  	struct v4l2_rect crop;
>  	struct v4l2_rect compose;
>  	struct v4l2_rect source;
> +	v4l2_std_id std;
>  };
>=20
>  #define vin_to_source(vin)		((vin)->digital->subdev)


=2D-=20
Regards,

Laurent Pinchart
