Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:48481 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932534AbeFUJd5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 05:33:57 -0400
Message-ID: <4fcfed23bfae158699c23329f92d6f2e968dc062.camel@bootlin.com>
Subject: Re: [PATCH 4/9] media: cedrus: make engine type more generic
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>, hans.verkuil@cisco.com,
        acourbot@chromium.org, sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: tfiga@chromium.org, posciak@chromium.org,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Date: Thu, 21 Jun 2018 11:33:44 +0200
In-Reply-To: <20180613140714.1686-5-maxime.ripard@bootlin.com>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
         <20180613140714.1686-5-maxime.ripard@bootlin.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-7wU1Tez5FhraT+rPcUE/"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-7wU1Tez5FhraT+rPcUE/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 2018-06-13 at 16:07 +0200, Maxime Ripard wrote:
> The sunxi_cedrus_engine enum actually enumerates pretty much the codecs t=
o
> use (or we can easily infer the codec engine from the codec).
>=20
> Since we will need the codec type as well in some later refactoring, make
> that structure more useful by just enumerating the codec, and converting
> the existing users.

With the comment below taken in account, this is:

Acked-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h | 6 ++++++
>  drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c     | 6 +++---
>  drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.h     | 6 +-----
>  drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c  | 2 +-
>  4 files changed, 11 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h b/=
drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> index b1ed1c8cb130..a5f83c452006 100644
> --- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> @@ -61,6 +61,12 @@ struct sunxi_cedrus_run {
>  	};
>  };
> =20
> +enum sunxi_cedrus_codec {

Feel free to rename to cedrus_codec when rebasing on top of the latest
patchset introducing the driver.

Cheers,

Paul

> +	SUNXI_CEDRUS_CODEC_MPEG2,
> +
> +	SUNXI_CEDRUS_CODEC_LAST,
> +};
> +
>  struct sunxi_cedrus_ctx {
>  	struct v4l2_fh fh;
>  	struct sunxi_cedrus_dev	*dev;
> diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c b/driv=
ers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c
> index fc688a5c1ea3..bb46a01214e0 100644
> --- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c
> +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c
> @@ -41,7 +41,7 @@
>  #define SYSCON_SRAM_C1_MAP_VE	0x7fffffff
> =20
>  int sunxi_cedrus_engine_enable(struct sunxi_cedrus_dev *dev,
> -			       enum sunxi_cedrus_engine engine)
> +			       enum sunxi_cedrus_codec codec)
>  {
>  	u32 reg =3D 0;
> =20
> @@ -53,8 +53,8 @@ int sunxi_cedrus_engine_enable(struct sunxi_cedrus_dev =
*dev,
> =20
>  	reg |=3D VE_CTRL_CACHE_BUS_BW_128;
> =20
> -	switch (engine) {
> -	case SUNXI_CEDRUS_ENGINE_MPEG:
> +	switch (codec) {
> +	case SUNXI_CEDRUS_CODEC_MPEG2:
>  		reg |=3D VE_CTRL_DEC_MODE_MPEG;
>  		break;
> =20
> diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.h b/driv=
ers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.h
> index 34f3fae462a8..3236c80bfcf4 100644
> --- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.h
> +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.h
> @@ -23,12 +23,8 @@
>  #ifndef _SUNXI_CEDRUS_HW_H_
>  #define _SUNXI_CEDRUS_HW_H_
> =20
> -enum sunxi_cedrus_engine {
> -	SUNXI_CEDRUS_ENGINE_MPEG,
> -};
> -
>  int sunxi_cedrus_engine_enable(struct sunxi_cedrus_dev *dev,
> -			       enum sunxi_cedrus_engine engine);
> +			       enum sunxi_cedrus_codec codec);
>  void sunxi_cedrus_engine_disable(struct sunxi_cedrus_dev *dev);
> =20
>  int sunxi_cedrus_hw_probe(struct sunxi_cedrus_dev *dev);
> diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c b/d=
rivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c
> index 5be3e3b9ceef..85e6fc2fbdb2 100644
> --- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c
> +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.c
> @@ -83,7 +83,7 @@ void sunxi_cedrus_mpeg2_setup(struct sunxi_cedrus_ctx *=
ctx,
>  	}
> =20
>  	/* Activate MPEG engine. */
> -	sunxi_cedrus_engine_enable(dev, SUNXI_CEDRUS_ENGINE_MPEG);
> +	sunxi_cedrus_engine_enable(dev, SUNXI_CEDRUS_CODEC_MPEG2);
> =20
>  	/* Set quantization matrices. */
>  	for (i =3D 0; i < 64; i++) {
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-7wU1Tez5FhraT+rPcUE/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlsrcPgACgkQ3cLmz3+f
v9GxTwf/TJCCcwCC3Rv2+rY85tD/+4wVMDu1JncGIkjS04EpWaDeHeO3SBgPU7Dr
9O8/rNPsujLDshuzU1dMFg0DATVfi/gC8TidPgKZRlzjzvKDijLKHpF6xbULHHQZ
t+u47yVw6LJnsLNiMCoe4lV+cryd8VH1qWNkC+KxBXFO7pnHPwlNou0LFbQr02oI
ZlKmqXCLOSqZxAigIfnTIWhrWdtv0Fq6d2YixXoFxlsB4idOyEtvCmT+TOXAwlTt
oem23/JJfZ7RgbOc/DMFoOkITN8fEggA3VnVkURd/7Iv85pQ9y40qwWc1DUtaS5H
9p0wDDf/RdeWFXvQUJP1q0eJVwrSPA==
=5Sa5
-----END PGP SIGNATURE-----

--=-7wU1Tez5FhraT+rPcUE/--
