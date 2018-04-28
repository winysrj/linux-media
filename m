Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:52594 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758550AbeD1RQQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 13:16:16 -0400
Subject: Re: [PATCH v2 2/8] v4l: vsp1: Share the CLU, LIF and LUT set_fmt pad
 operation code
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org
References: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180422223430.16407-3-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <9839f231-f91c-ab54-fdba-f100a98a558d@ideasonboard.com>
Date: Sat, 28 Apr 2018 18:16:11 +0100
MIME-Version: 1.0
In-Reply-To: <20180422223430.16407-3-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="IGTPW4TXrgxZA0MzOg8ZPHxSNOHY3bkG9"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IGTPW4TXrgxZA0MzOg8ZPHxSNOHY3bkG9
Content-Type: multipart/mixed; boundary="KiDc0e9yr43riPj2rxdS4wzfkd4LaNpUT";
 protected-headers="v1"
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org
Message-ID: <9839f231-f91c-ab54-fdba-f100a98a558d@ideasonboard.com>
Subject: Re: [PATCH v2 2/8] v4l: vsp1: Share the CLU, LIF and LUT set_fmt pad
 operation code
References: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180422223430.16407-3-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20180422223430.16407-3-laurent.pinchart+renesas@ideasonboard.com>

--KiDc0e9yr43riPj2rxdS4wzfkd4LaNpUT
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi Laurent,

On 22/04/18 23:34, Laurent Pinchart wrote:
> The implementation of the set_fmt pad operation is identical in the
> three modules. Move it to a generic helper function.
>=20
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.=
com>

Only a minor pair of comments below regarding source/sink pad description=
s.

If it's not convenient/accurate to define these with an enum then don't w=
orry
about it.

Otherwise,

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/vsp1/vsp1_clu.c    | 65 +++++------------------=
----
>  drivers/media/platform/vsp1/vsp1_entity.c | 75 +++++++++++++++++++++++=
++++++++
>  drivers/media/platform/vsp1/vsp1_entity.h |  6 +++
>  drivers/media/platform/vsp1/vsp1_lif.c    | 65 +++++------------------=
----
>  drivers/media/platform/vsp1/vsp1_lut.c    | 65 +++++------------------=
----
>  5 files changed, 116 insertions(+), 160 deletions(-)

That's a nice diffstat :-)


>=20
> diff --git a/drivers/media/platform/vsp1/vsp1_clu.c b/drivers/media/pla=
tform/vsp1/vsp1_clu.c
> index 9626b6308585..96a448e1504c 100644
> --- a/drivers/media/platform/vsp1/vsp1_clu.c
> +++ b/drivers/media/platform/vsp1/vsp1_clu.c
> @@ -114,18 +114,18 @@ static const struct v4l2_ctrl_config clu_mode_con=
trol =3D {
>   * V4L2 Subdevice Pad Operations
>   */
> =20
> +static const unsigned int clu_codes[] =3D {
> +	MEDIA_BUS_FMT_ARGB8888_1X32,
> +	MEDIA_BUS_FMT_AHSV8888_1X32,
> +	MEDIA_BUS_FMT_AYUV8_1X32,
> +};
> +
>  static int clu_enum_mbus_code(struct v4l2_subdev *subdev,
>  			      struct v4l2_subdev_pad_config *cfg,
>  			      struct v4l2_subdev_mbus_code_enum *code)
>  {
> -	static const unsigned int codes[] =3D {
> -		MEDIA_BUS_FMT_ARGB8888_1X32,
> -		MEDIA_BUS_FMT_AHSV8888_1X32,
> -		MEDIA_BUS_FMT_AYUV8_1X32,
> -	};
> -
> -	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, codes,
> -					  ARRAY_SIZE(codes));
> +	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, clu_codes,
> +					  ARRAY_SIZE(clu_codes));
>  }
> =20
>  static int clu_enum_frame_size(struct v4l2_subdev *subdev,
> @@ -141,51 +141,10 @@ static int clu_set_format(struct v4l2_subdev *sub=
dev,
>  			  struct v4l2_subdev_pad_config *cfg,
>  			  struct v4l2_subdev_format *fmt)
>  {
> -	struct vsp1_clu *clu =3D to_clu(subdev);
> -	struct v4l2_subdev_pad_config *config;
> -	struct v4l2_mbus_framefmt *format;
> -	int ret =3D 0;
> -
> -	mutex_lock(&clu->entity.lock);
> -
> -	config =3D vsp1_entity_get_pad_config(&clu->entity, cfg, fmt->which);=

> -	if (!config) {
> -		ret =3D -EINVAL;
> -		goto done;
> -	}
> -
> -	/* Default to YUV if the requested format is not supported. */
> -	if (fmt->format.code !=3D MEDIA_BUS_FMT_ARGB8888_1X32 &&
> -	    fmt->format.code !=3D MEDIA_BUS_FMT_AHSV8888_1X32 &&
> -	    fmt->format.code !=3D MEDIA_BUS_FMT_AYUV8_1X32)
> -		fmt->format.code =3D MEDIA_BUS_FMT_AYUV8_1X32;
> -
> -	format =3D vsp1_entity_get_pad_format(&clu->entity, config, fmt->pad)=
;
> -
> -	if (fmt->pad =3D=3D CLU_PAD_SOURCE) {
> -		/* The CLU output format can't be modified. */
> -		fmt->format =3D *format;
> -		goto done;
> -	}
> -
> -	format->code =3D fmt->format.code;
> -	format->width =3D clamp_t(unsigned int, fmt->format.width,
> -				CLU_MIN_SIZE, CLU_MAX_SIZE);
> -	format->height =3D clamp_t(unsigned int, fmt->format.height,
> -				 CLU_MIN_SIZE, CLU_MAX_SIZE);
> -	format->field =3D V4L2_FIELD_NONE;
> -	format->colorspace =3D V4L2_COLORSPACE_SRGB;
> -
> -	fmt->format =3D *format;
> -
> -	/* Propagate the format to the source pad. */
> -	format =3D vsp1_entity_get_pad_format(&clu->entity, config,
> -					    CLU_PAD_SOURCE);
> -	*format =3D fmt->format;
> -
> -done:
> -	mutex_unlock(&clu->entity.lock);
> -	return ret;
> +	return vsp1_subdev_set_pad_format(subdev, cfg, fmt, clu_codes,
> +					  ARRAY_SIZE(clu_codes),
> +					  CLU_MIN_SIZE, CLU_MIN_SIZE,
> +					  CLU_MAX_SIZE, CLU_MAX_SIZE);
>  }
> =20
>  /* -------------------------------------------------------------------=
----------
> diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/=
platform/vsp1/vsp1_entity.c
> index 72354caf5746..239df047efd0 100644
> --- a/drivers/media/platform/vsp1/vsp1_entity.c
> +++ b/drivers/media/platform/vsp1/vsp1_entity.c
> @@ -307,6 +307,81 @@ int vsp1_subdev_enum_frame_size(struct v4l2_subdev=
 *subdev,
>  	return ret;
>  }
> =20
> +/*
> + * vsp1_subdev_set_pad_format - Subdev pad set_fmt handler
> + * @subdev: V4L2 subdevice
> + * @cfg: V4L2 subdev pad configuration
> + * @fmt: V4L2 subdev format
> + * @codes: Array of supported media bus codes
> + * @ncodes: Number of supported media bus codes
> + * @min_width: Minimum image width
> + * @min_height: Minimum image height
> + * @max_width: Maximum image width
> + * @max_height: Maximum image height
> + *
> + * This function implements the subdev set_fmt pad operation for entit=
ies that
> + * do not support scaling or cropping. It defaults to the first suppli=
ed media
> + * bus code if the requested code isn't supported, clamps the size to =
the
> + * supplied minimum and maximum, and propagates the sink pad format to=
 the
> + * source pad.
> + */
> +int vsp1_subdev_set_pad_format(struct v4l2_subdev *subdev,
> +			       struct v4l2_subdev_pad_config *cfg,
> +			       struct v4l2_subdev_format *fmt,
> +			       const unsigned int *codes, unsigned int ncodes,
> +			       unsigned int min_width, unsigned int min_height,
> +			       unsigned int max_width, unsigned int max_height)
> +{
> +	struct vsp1_entity *entity =3D to_vsp1_entity(subdev);
> +	struct v4l2_subdev_pad_config *config;
> +	struct v4l2_mbus_framefmt *format;
> +	unsigned int i;
> +	int ret =3D 0;
> +
> +	mutex_lock(&entity->lock);
> +
> +	config =3D vsp1_entity_get_pad_config(entity, cfg, fmt->which);
> +	if (!config) {
> +		ret =3D -EINVAL;
> +		goto done;
> +	}
> +
> +	format =3D vsp1_entity_get_pad_format(entity, config, fmt->pad);
> +
> +	if (fmt->pad !=3D 0) {

I guess we don't have any clear way to say !=3D *_PAD_SINK here do we ..

> +		/* The output format can't be modified. */
> +		fmt->format =3D *format;
> +		goto done;
> +	}
> +
> +	/*
> +	 * Default to the first media bus code if the requested format is not=

> +	 * supported.
> +	 */
> +	for (i =3D 0; i < ncodes; ++i) {
> +		if (fmt->format.code =3D=3D codes[i])
> +			break;
> +	}
> +
> +	format->code =3D i < ncodes ? codes[i] : codes[0];
> +	format->width =3D clamp_t(unsigned int, fmt->format.width,
> +				min_width, max_width);
> +	format->height =3D clamp_t(unsigned int, fmt->format.height,
> +				 min_height, max_height);
> +	format->field =3D V4L2_FIELD_NONE;
> +	format->colorspace =3D V4L2_COLORSPACE_SRGB;
> +
> +	fmt->format =3D *format;
> +
> +	/* Propagate the format to the source pad. */
> +	format =3D vsp1_entity_get_pad_format(entity, config, 1);

If we can guarantee that ENTITY_PAD_SINK =3D=3D 0 and ENTITY_PAD_SOURCE =3D=
=3D 1, can we
put those into an enum ?


> +	*format =3D fmt->format;
> +
> +done:
> +	mutex_unlock(&entity->lock);
> +	return ret;
> +}
> +
>  /* -------------------------------------------------------------------=
----------
>   * Media Operations
>   */
> diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/=
platform/vsp1/vsp1_entity.h
> index fb20a1578f3b..0839a62cfa71 100644
> --- a/drivers/media/platform/vsp1/vsp1_entity.h
> +++ b/drivers/media/platform/vsp1/vsp1_entity.h
> @@ -160,6 +160,12 @@ struct media_pad *vsp1_entity_remote_pad(struct me=
dia_pad *pad);
>  int vsp1_subdev_get_pad_format(struct v4l2_subdev *subdev,
>  			       struct v4l2_subdev_pad_config *cfg,
>  			       struct v4l2_subdev_format *fmt);
> +int vsp1_subdev_set_pad_format(struct v4l2_subdev *subdev,
> +			       struct v4l2_subdev_pad_config *cfg,
> +			       struct v4l2_subdev_format *fmt,
> +			       const unsigned int *codes, unsigned int ncodes,
> +			       unsigned int min_width, unsigned int min_height,
> +			       unsigned int max_width, unsigned int max_height);
>  int vsp1_subdev_enum_mbus_code(struct v4l2_subdev *subdev,
>  			       struct v4l2_subdev_pad_config *cfg,
>  			       struct v4l2_subdev_mbus_code_enum *code,
> diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/pla=
tform/vsp1/vsp1_lif.c
> index b20b842f06ba..fbdd5715f829 100644
> --- a/drivers/media/platform/vsp1/vsp1_lif.c
> +++ b/drivers/media/platform/vsp1/vsp1_lif.c
> @@ -33,17 +33,17 @@ static inline void vsp1_lif_write(struct vsp1_lif *=
lif, struct vsp1_dl_list *dl,
>   * V4L2 Subdevice Operations
>   */
> =20
> +static const unsigned int lif_codes[] =3D {
> +	MEDIA_BUS_FMT_ARGB8888_1X32,
> +	MEDIA_BUS_FMT_AYUV8_1X32,
> +};
> +
>  static int lif_enum_mbus_code(struct v4l2_subdev *subdev,
>  			      struct v4l2_subdev_pad_config *cfg,
>  			      struct v4l2_subdev_mbus_code_enum *code)
>  {
> -	static const unsigned int codes[] =3D {
> -		MEDIA_BUS_FMT_ARGB8888_1X32,
> -		MEDIA_BUS_FMT_AYUV8_1X32,
> -	};
> -
> -	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, codes,
> -					  ARRAY_SIZE(codes));
> +	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, lif_codes,
> +					  ARRAY_SIZE(lif_codes));
>  }
> =20
>  static int lif_enum_frame_size(struct v4l2_subdev *subdev,
> @@ -59,53 +59,10 @@ static int lif_set_format(struct v4l2_subdev *subde=
v,
>  			  struct v4l2_subdev_pad_config *cfg,
>  			  struct v4l2_subdev_format *fmt)
>  {
> -	struct vsp1_lif *lif =3D to_lif(subdev);
> -	struct v4l2_subdev_pad_config *config;
> -	struct v4l2_mbus_framefmt *format;
> -	int ret =3D 0;
> -
> -	mutex_lock(&lif->entity.lock);
> -
> -	config =3D vsp1_entity_get_pad_config(&lif->entity, cfg, fmt->which);=

> -	if (!config) {
> -		ret =3D -EINVAL;
> -		goto done;
> -	}
> -
> -	/* Default to YUV if the requested format is not supported. */
> -	if (fmt->format.code !=3D MEDIA_BUS_FMT_ARGB8888_1X32 &&
> -	    fmt->format.code !=3D MEDIA_BUS_FMT_AYUV8_1X32)
> -		fmt->format.code =3D MEDIA_BUS_FMT_AYUV8_1X32;
> -
> -	format =3D vsp1_entity_get_pad_format(&lif->entity, config, fmt->pad)=
;
> -
> -	if (fmt->pad =3D=3D LIF_PAD_SOURCE) {
> -		/*
> -		 * The LIF source format is always identical to its sink
> -		 * format.
> -		 */
> -		fmt->format =3D *format;
> -		goto done;
> -	}
> -
> -	format->code =3D fmt->format.code;
> -	format->width =3D clamp_t(unsigned int, fmt->format.width,
> -				LIF_MIN_SIZE, LIF_MAX_SIZE);
> -	format->height =3D clamp_t(unsigned int, fmt->format.height,
> -				 LIF_MIN_SIZE, LIF_MAX_SIZE);
> -	format->field =3D V4L2_FIELD_NONE;
> -	format->colorspace =3D V4L2_COLORSPACE_SRGB;
> -
> -	fmt->format =3D *format;
> -
> -	/* Propagate the format to the source pad. */
> -	format =3D vsp1_entity_get_pad_format(&lif->entity, config,
> -					    LIF_PAD_SOURCE);
> -	*format =3D fmt->format;
> -
> -done:
> -	mutex_unlock(&lif->entity.lock);
> -	return ret;
> +	return vsp1_subdev_set_pad_format(subdev, cfg, fmt, lif_codes,
> +					  ARRAY_SIZE(lif_codes),
> +					  LIF_MIN_SIZE, LIF_MIN_SIZE,
> +					  LIF_MAX_SIZE, LIF_MAX_SIZE);
>  }
> =20
>  static const struct v4l2_subdev_pad_ops lif_pad_ops =3D {
> diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/pla=
tform/vsp1/vsp1_lut.c
> index 7bdabb311c6c..f2e48a02ca7d 100644
> --- a/drivers/media/platform/vsp1/vsp1_lut.c
> +++ b/drivers/media/platform/vsp1/vsp1_lut.c
> @@ -90,18 +90,18 @@ static const struct v4l2_ctrl_config lut_table_cont=
rol =3D {
>   * V4L2 Subdevice Pad Operations
>   */
> =20
> +static const unsigned int lut_codes[] =3D {
> +	MEDIA_BUS_FMT_ARGB8888_1X32,
> +	MEDIA_BUS_FMT_AHSV8888_1X32,
> +	MEDIA_BUS_FMT_AYUV8_1X32,
> +};
> +
>  static int lut_enum_mbus_code(struct v4l2_subdev *subdev,
>  			      struct v4l2_subdev_pad_config *cfg,
>  			      struct v4l2_subdev_mbus_code_enum *code)
>  {
> -	static const unsigned int codes[] =3D {
> -		MEDIA_BUS_FMT_ARGB8888_1X32,
> -		MEDIA_BUS_FMT_AHSV8888_1X32,
> -		MEDIA_BUS_FMT_AYUV8_1X32,
> -	};
> -
> -	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, codes,
> -					  ARRAY_SIZE(codes));
> +	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, lut_codes,
> +					  ARRAY_SIZE(lut_codes));
>  }
> =20
>  static int lut_enum_frame_size(struct v4l2_subdev *subdev,
> @@ -117,51 +117,10 @@ static int lut_set_format(struct v4l2_subdev *sub=
dev,
>  			  struct v4l2_subdev_pad_config *cfg,
>  			  struct v4l2_subdev_format *fmt)
>  {
> -	struct vsp1_lut *lut =3D to_lut(subdev);
> -	struct v4l2_subdev_pad_config *config;
> -	struct v4l2_mbus_framefmt *format;
> -	int ret =3D 0;
> -
> -	mutex_lock(&lut->entity.lock);
> -
> -	config =3D vsp1_entity_get_pad_config(&lut->entity, cfg, fmt->which);=

> -	if (!config) {
> -		ret =3D -EINVAL;
> -		goto done;
> -	}
> -
> -	/* Default to YUV if the requested format is not supported. */
> -	if (fmt->format.code !=3D MEDIA_BUS_FMT_ARGB8888_1X32 &&
> -	    fmt->format.code !=3D MEDIA_BUS_FMT_AHSV8888_1X32 &&
> -	    fmt->format.code !=3D MEDIA_BUS_FMT_AYUV8_1X32)
> -		fmt->format.code =3D MEDIA_BUS_FMT_AYUV8_1X32;
> -
> -	format =3D vsp1_entity_get_pad_format(&lut->entity, config, fmt->pad)=
;
> -
> -	if (fmt->pad =3D=3D LUT_PAD_SOURCE) {
> -		/* The LUT output format can't be modified. */
> -		fmt->format =3D *format;
> -		goto done;
> -	}
> -
> -	format->code =3D fmt->format.code;
> -	format->width =3D clamp_t(unsigned int, fmt->format.width,
> -				LUT_MIN_SIZE, LUT_MAX_SIZE);
> -	format->height =3D clamp_t(unsigned int, fmt->format.height,
> -				 LUT_MIN_SIZE, LUT_MAX_SIZE);
> -	format->field =3D V4L2_FIELD_NONE;
> -	format->colorspace =3D V4L2_COLORSPACE_SRGB;
> -
> -	fmt->format =3D *format;
> -
> -	/* Propagate the format to the source pad. */
> -	format =3D vsp1_entity_get_pad_format(&lut->entity, config,
> -					    LUT_PAD_SOURCE);
> -	*format =3D fmt->format;
> -
> -done:
> -	mutex_unlock(&lut->entity.lock);
> -	return ret;
> +	return vsp1_subdev_set_pad_format(subdev, cfg, fmt, lut_codes,
> +					  ARRAY_SIZE(lut_codes),
> +					  LUT_MIN_SIZE, LUT_MIN_SIZE,
> +					  LUT_MAX_SIZE, LUT_MAX_SIZE);
>  }
> =20
>  /* -------------------------------------------------------------------=
----------
>=20


--KiDc0e9yr43riPj2rxdS4wzfkd4LaNpUT--

--IGTPW4TXrgxZA0MzOg8ZPHxSNOHY3bkG9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEkC3XmD+9KP3jctR6oR5GchCkYf0FAlrkrFsACgkQoR5GchCk
Yf2KhQ//Yo0L+mHQ6X+sVZrAqvTw02m5VP4J2Y/NOxKAUhztyoXOtqUz9DGw3LuW
QjuzsWzUem6zh4IV/20ao1w8R/5dADM5p1wV/+LNvaLNm48pe7WCGARUfGzmkApD
L+oYCoYj4nYM3Ul09sLvynWH7ia+tJrC/lc01cIKyD7s4uJBcnlejeojv5es+F9T
zlWZLlVxmyC4PLekgfkGmq6sm524cQ8M/9GSYZzp6RIaeoMJRB91I6g8fHjKQOLF
EVQlaqRy2lFggDcW/JRaL5phslwYSt1HRBx8BWqaDtyPErBBTPHhoL0Dam/VL0lr
B+LU6RVGbQdzGs1bWdUnh1DhX6bYAejLX9nQKY37oFBgVoLWNHGR3aJuoSnRBx2L
fwmFypHToUDWyijc9Ba7a649Y3MkE8L0f0S2d557A7s4oLuczqAc8VVsJ5rx9tvJ
grh3E7KGKdOaxd1VEZWUaKYu5pfLbVHxlHcO06/w5fnvy5D+s9mGZnLBUmnx2iAS
CbPK+bpT8U53X+Jbk7yvYdjFvhnEzn+/ZGFK3IyNtd0mCmMJJbr96TnqDTeam0Vq
OfIi2VX6wcb5FidtIRiIz4hE03xQRMoTsq5ROhLuJaofCMovsNxo2crvmJ52RwpW
td2hMd+/4lKs9JzXKJJ3XR4V5Mvn5M6DeuI9H49JsHbdrZUBA7M=
=ug/N
-----END PGP SIGNATURE-----

--IGTPW4TXrgxZA0MzOg8ZPHxSNOHY3bkG9--
