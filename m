Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:53108 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753382AbeD1RWu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 13:22:50 -0400
Subject: Re: [PATCH v2 3/8] v4l: vsp1: Reset the crop and compose rectangles
 in the set_fmt helper
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org
References: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180422223430.16407-4-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <def74407-03a7-338f-fcaa-d9b4b21ed4bb@ideasonboard.com>
Date: Sat, 28 Apr 2018 18:22:46 +0100
MIME-Version: 1.0
In-Reply-To: <20180422223430.16407-4-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="l0ODmEAIcMb2594JNtll3DxFiTLD5VYSS"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--l0ODmEAIcMb2594JNtll3DxFiTLD5VYSS
Content-Type: multipart/mixed; boundary="oASLy8PY4hnLiJiK3h6qiJZF3SYwVTZoI";
 protected-headers="v1"
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org
Message-ID: <def74407-03a7-338f-fcaa-d9b4b21ed4bb@ideasonboard.com>
Subject: Re: [PATCH v2 3/8] v4l: vsp1: Reset the crop and compose rectangles
 in the set_fmt helper
References: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180422223430.16407-4-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20180422223430.16407-4-laurent.pinchart+renesas@ideasonboard.com>

--oASLy8PY4hnLiJiK3h6qiJZF3SYwVTZoI
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi Laurent,

On 22/04/18 23:34, Laurent Pinchart wrote:
> To make vsp1_subdev_set_pad_format() usable by entities that support
> selection rectangles, we need to reset the crop and compose rectangles
> when setting the format on the sink pad. Do so and replace the custom
> set_fmt implementation of the histogram code by a call to
> vsp1_subdev_set_pad_format().
>=20
> Resetting the crop and compose rectangles for entities that don't
> support crop and compose has no adverse effect as the rectangles are
> ignored anyway.
>=20
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.=
com>

This one looks fairly straight forward.

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/vsp1/vsp1_entity.c | 16 +++++++++
>  drivers/media/platform/vsp1/vsp1_histo.c  | 59 +++--------------------=
--------
>  2 files changed, 20 insertions(+), 55 deletions(-)
>=20
> diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/=
platform/vsp1/vsp1_entity.c
> index 239df047efd0..181a583aecad 100644
> --- a/drivers/media/platform/vsp1/vsp1_entity.c
> +++ b/drivers/media/platform/vsp1/vsp1_entity.c
> @@ -335,6 +335,7 @@ int vsp1_subdev_set_pad_format(struct v4l2_subdev *=
subdev,
>  	struct vsp1_entity *entity =3D to_vsp1_entity(subdev);
>  	struct v4l2_subdev_pad_config *config;
>  	struct v4l2_mbus_framefmt *format;
> +	struct v4l2_rect *selection;
>  	unsigned int i;
>  	int ret =3D 0;
> =20
> @@ -377,6 +378,21 @@ int vsp1_subdev_set_pad_format(struct v4l2_subdev =
*subdev,
>  	format =3D vsp1_entity_get_pad_format(entity, config, 1);
>  	*format =3D fmt->format;
> =20
> +	/* Reset the crop and compose rectangles */
> +	selection =3D vsp1_entity_get_pad_selection(entity, config, fmt->pad,=

> +						  V4L2_SEL_TGT_CROP);
> +	selection->left =3D 0;
> +	selection->top =3D 0;
> +	selection->width =3D format->width;
> +	selection->height =3D format->height;
> +
> +	selection =3D vsp1_entity_get_pad_selection(entity, config, fmt->pad,=

> +						  V4L2_SEL_TGT_COMPOSE);
> +	selection->left =3D 0;
> +	selection->top =3D 0;
> +	selection->width =3D format->width;
> +	selection->height =3D format->height;
> +
>  done:
>  	mutex_unlock(&entity->lock);
>  	return ret;
> diff --git a/drivers/media/platform/vsp1/vsp1_histo.c b/drivers/media/p=
latform/vsp1/vsp1_histo.c
> index 029181c1fb61..5e15c8ff88d9 100644
> --- a/drivers/media/platform/vsp1/vsp1_histo.c
> +++ b/drivers/media/platform/vsp1/vsp1_histo.c
> @@ -389,65 +389,14 @@ static int histo_set_format(struct v4l2_subdev *s=
ubdev,
>  			    struct v4l2_subdev_format *fmt)
>  {
>  	struct vsp1_histogram *histo =3D subdev_to_histo(subdev);
> -	struct v4l2_subdev_pad_config *config;
> -	struct v4l2_mbus_framefmt *format;
> -	struct v4l2_rect *selection;
> -	unsigned int i;
> -	int ret =3D 0;
> =20
>  	if (fmt->pad !=3D HISTO_PAD_SINK)
>  		return histo_get_format(subdev, cfg, fmt);
> =20
> -	mutex_lock(&histo->entity.lock);
> -
> -	config =3D vsp1_entity_get_pad_config(&histo->entity, cfg, fmt->which=
);
> -	if (!config) {
> -		ret =3D -EINVAL;
> -		goto done;
> -	}
> -
> -	/*
> -	 * Default to the first format if the requested format is not
> -	 * supported.
> -	 */
> -	for (i =3D 0; i < histo->num_formats; ++i) {
> -		if (fmt->format.code =3D=3D histo->formats[i])
> -			break;
> -	}
> -	if (i =3D=3D histo->num_formats)
> -		fmt->format.code =3D histo->formats[0];
> -
> -	format =3D vsp1_entity_get_pad_format(&histo->entity, config, fmt->pa=
d);
> -
> -	format->code =3D fmt->format.code;
> -	format->width =3D clamp_t(unsigned int, fmt->format.width,
> -				HISTO_MIN_SIZE, HISTO_MAX_SIZE);
> -	format->height =3D clamp_t(unsigned int, fmt->format.height,
> -				 HISTO_MIN_SIZE, HISTO_MAX_SIZE);
> -	format->field =3D V4L2_FIELD_NONE;
> -	format->colorspace =3D V4L2_COLORSPACE_SRGB;
> -
> -	fmt->format =3D *format;
> -
> -	/* Reset the crop and compose rectangles */
> -	selection =3D vsp1_entity_get_pad_selection(&histo->entity, config,
> -						  fmt->pad, V4L2_SEL_TGT_CROP);
> -	selection->left =3D 0;
> -	selection->top =3D 0;
> -	selection->width =3D format->width;
> -	selection->height =3D format->height;
> -
> -	selection =3D vsp1_entity_get_pad_selection(&histo->entity, config,
> -						  fmt->pad,
> -						  V4L2_SEL_TGT_COMPOSE);
> -	selection->left =3D 0;
> -	selection->top =3D 0;
> -	selection->width =3D format->width;
> -	selection->height =3D format->height;
> -
> -done:
> -	mutex_unlock(&histo->entity.lock);
> -	return ret;
> +	return vsp1_subdev_set_pad_format(subdev, cfg, fmt,
> +					  histo->formats, histo->num_formats,
> +					  HISTO_MIN_SIZE, HISTO_MIN_SIZE,
> +					  HISTO_MAX_SIZE, HISTO_MAX_SIZE);
>  }
> =20
>  static const struct v4l2_subdev_pad_ops histo_pad_ops =3D {
>=20


--oASLy8PY4hnLiJiK3h6qiJZF3SYwVTZoI--

--l0ODmEAIcMb2594JNtll3DxFiTLD5VYSS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEkC3XmD+9KP3jctR6oR5GchCkYf0FAlrkreYACgkQoR5GchCk
Yf3wPw/9G4YvArDo/ob8aUMt9yGzjzqaGwQPzDX6xV21fJmv7TkNhq9ag+225ygY
9kjrMMd0b6EDIYJjYAzIphqXGNq0I21Kew9dXP1h8zXCSp/FZYDVy0swbboZH17+
WPcQvPUHJ0H+OZI75H1cL6s/G0ICU6KXIJCjv+VUF5wH36InJxAwNtnFrDCLRme2
4bK/m+suhujfixoKrKygfoTy3FC65uN3S/5Dpcte93/eFV/x6hRGMVeX0wZLDvwq
4+k2zvWEd+ZFRSgV0RzvL7XgKaZi1yemvudRd526F9/ZRhtr2qXev4YBgmzhYhgB
YI8++zfFO5EdcYS9SJ5ntivtYuUt+TGotAI7nExLJYIjtx34L+rvmU5EJLVaEqxK
Y2z8yerhPe2pE86QkVAe3XKXWiQki/8Pl2/M+M1MkQ1JpxgUGGYKwP74WHB3UVVY
nkIPHhnucRKRou45B6vqCqOJihAdNuOXg3yx0u+Ze/Pn0h+nypq/Vcjo5RvyK4qC
Vn4aV+tJLfIkjkSHXwmiO/bFI7cMjG8weBtQxxukSZU/DtAlcz//6LHPp1tOFnps
UxavzkVKGi80hvohqkiB0oHCUCWuo9QVP0e/4DswtSx5JmL0AmN+7YHXFin2bSey
GpyjswEJ5+znmGYTTZtsJNG/EM0LVIj6yROq/ZFzxz5+fgikMCk=
=sr2Z
-----END PGP SIGNATURE-----

--l0ODmEAIcMb2594JNtll3DxFiTLD5VYSS--
