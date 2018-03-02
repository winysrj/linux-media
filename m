Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52460 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1426022AbeCBJ6Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2018 04:58:24 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v11 22/32] rcar-vin: force default colorspace for media centric mode
Date: Fri, 02 Mar 2018 11:59:14 +0200
Message-ID: <17480633.KWnsIYxeaE@avalon>
In-Reply-To: <20180302015751.25596-23-niklas.soderlund+renesas@ragnatech.se>
References: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se> <20180302015751.25596-23-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 2 March 2018 03:57:41 EET Niklas S=F6derlund wrote:
> When the VIN driver is running in media centric mode (on Gen3) the
> colorspace is not retrieved from the video source instead the user is
> expected to set it as part of the format. There is no way for the VIN
> driver to validated the colorspace requested by user-space, this creates
> a problem where validation tools fail. Until the user requested
> colorspace can be validated lets force it to the driver default.

The problem here is that the V4L2 specification clearly documents the=20
colorspace fields as being set by drivers for capture devices. Using the=20
values supplied by userspace thus wouldn't comply with the API. The API has=
 to=20
be updated to allow us to implement this feature, but until then Hans wants=
=20
the userspace to be set by the driver to a fixed value. Could you update th=
e=20
commit message accordingly, as well as the comment below ?

> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> 8d92710efffa7276..02f3100ed30db63c 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -675,12 +675,24 @@ static const struct v4l2_ioctl_ops rvin_ioctl_ops =
=3D {
>   * V4L2 Media Controller
>   */
>=20
> +static int rvin_mc_try_format(struct rvin_dev *vin, struct v4l2_pix_form=
at
> *pix) +{
> +	/*
> +	 * There is no way to validate the colorspace provided by the
> +	 * user. Until it can be validated force colorspace to the
> +	 * driver default.
> +	 */
> +	pix->colorspace =3D RVIN_DEFAULT_COLORSPACE;

Should you also set the xfer_func, quantization and ycbcr_enc ?

Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

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
> @@ -692,7 +704,7 @@ static int rvin_mc_s_fmt_vid_cap(struct file *file, v=
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
