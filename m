Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42666 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752813AbeDCVkO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Apr 2018 17:40:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v13 23/33] rcar-vin: force default colorspace for media centric mode
Date: Wed, 04 Apr 2018 00:40:23 +0300
Message-ID: <3928384.BQ7mG5EcqE@avalon>
In-Reply-To: <20180326214456.6655-24-niklas.soderlund+renesas@ragnatech.se>
References: <20180326214456.6655-1-niklas.soderlund+renesas@ragnatech.se> <20180326214456.6655-24-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Tuesday, 27 March 2018 00:44:46 EEST Niklas S=F6derlund wrote:
> The V4L2 specification clearly documents the colorspace fields as being
> set by drivers for capture devices. Using the values supplied by
> userspace thus wouldn't comply with the API. Until the API is updated to
> allow for userspace to set these Hans wants the fields to be set by the
> driver to fixed values.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> 2280535ca981993f..ea0759a645e49490 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -664,12 +664,29 @@ static const struct v4l2_ioctl_ops rvin_ioctl_ops =
=3D {
>   * V4L2 Media Controller
>   */
>=20
> +static int rvin_mc_try_format(struct rvin_dev *vin, struct v4l2_pix_form=
at
> *pix) +{
> +	/*
> +	 * The V4L2 specification clearly documents the colorspace fields
> +	 * as being set by drivers for capture devices. Using the values
> +	 * supplied by userspace thus wouldn't comply with the API. Until
> +	 * the API is updated force fixed vaules.
> +	 */
> +	pix->colorspace =3D RVIN_DEFAULT_COLORSPACE;
> +	pix->xfer_func =3D V4L2_MAP_XFER_FUNC_DEFAULT(pix->colorspace);
> +	pix->ycbcr_enc =3D V4L2_MAP_YCBCR_ENC_DEFAULT(pix->colorspace);
> +	pix->quantization =3D V4L2_MAP_QUANTIZATION_DEFAULT(true, pix->colorspa=
ce,
> +							  pix->ycbcr_enc);
> +
> +	return rvin_format_align(vin, pix);
> +}
> +
>  static int rvin_mc_try_fmt_vid_cap(struct file *file, void *priv,
>  				   struct v4l2_format *f)
>  {
>  	struct rvin_dev *vin =3D video_drvdata(file);
>=20
> -	return rvin_format_align(vin, &f->fmt.pix);
> +	return rvin_mc_try_format(vin, &f->fmt.pix);
>  }
>=20
>  static int rvin_mc_s_fmt_vid_cap(struct file *file, void *priv,
> @@ -681,7 +698,7 @@ static int rvin_mc_s_fmt_vid_cap(struct file *file, v=
oid
> *priv, if (vb2_is_busy(&vin->queue))
>  		return -EBUSY;
>=20
> -	ret =3D rvin_format_align(vin, &f->fmt.pix);
> +	ret =3D rvin_mc_try_format(vin, &f->fmt.pix);
>  	if (ret)
>  		return ret;


=2D-=20
Regards,

Laurent Pinchart
