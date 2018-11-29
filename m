Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:34349 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726766AbeK2ToE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Nov 2018 14:44:04 -0500
Message-ID: <41b39e603db7eb068dd9f4542d37c1f5f07ba1c0.camel@bootlin.com>
Subject: Re: [PATCH] media: v4l: Fix MPEG-2 slice Intra DC Precision
 validation
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Jonas Karlman <jonas@kwiboo.se>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Date: Thu, 29 Nov 2018 09:39:15 +0100
In-Reply-To: <AM0PR03MB46764B5CB90B17825C56DFFFACD60@AM0PR03MB4676.eurprd03.prod.outlook.com>
References: <AM0PR03MB46764B5CB90B17825C56DFFFACD60@AM0PR03MB4676.eurprd03.prod.outlook.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-SweGNEz9sQH5vT+vZWq+"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-SweGNEz9sQH5vT+vZWq+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, 2018-11-25 at 15:21 +0000, Jonas Karlman wrote:
> intra_dc_precision is a 2-bit integer [1]
> allow use of all valid options, 8 - 11 bits precision
>=20
> [1] ISO/IEC 13818-2 Table 6-13

Thanks for this patch, this is definitely a mistake from my side here!

> Fixes: c27bb30e7b6d ("media: v4l: Add definitions for MPEG-2 slice format=
 and metadata")
> Signed-off-by: Jonas Karlman <jonas@kwiboo.se>

Acked-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Cheers,

Paul

> ---
>=20
>  drivers/media/v4l2-core/v4l2-ctrls.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-co=
re/v4l2-ctrls.c
> index 5f2b033a7a42..129a986fa7e1 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1636,7 +1636,8 @@ static int std_validate(const struct v4l2_ctrl *ctr=
l, u32 idx,
>  		switch (p_mpeg2_slice_params->picture.intra_dc_precision) {
>  		case 0: /* 8 bits */
>  		case 1: /* 9 bits */
> -		case 11: /* 11 bits */
> +		case 2: /* 10 bits */
> +		case 3: /* 11 bits */
>  			break;
>  		default:
>  			return -EINVAL;
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-SweGNEz9sQH5vT+vZWq+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlv/pbMACgkQ3cLmz3+f
v9HFqwf6AzYrrKCqzWqu/baN/TlCE+TCB06su234j89/QHoZENfQ59dEY3I79YuN
IY0abi7RMz5QD1pR5Zouks+NRsvwTQMYiO2y15XSUCrAJaG9xl4ZcUB43kvtAIkK
2HS6PgMAxmuT1NbIQ5VLtrAisbZIf2g4jQULUwMuf+a5DY0S4X7PFqHMLFCeSjBl
VamoR9IzwURP+04qULVAOoKsu12dH6+fo2PS4FG4AK/rnh8/hhcgq9+XC9l7aNfN
8Af9iUBTycB+jstbX5i8uMtMGHOGHlSm2VBQ620Ha6jKImhWwCzPeLMslU6mXV48
EQTlGFc5AYg1CgMERzjo/QDibApEDQ==
=Axt0
-----END PGP SIGNATURE-----

--=-SweGNEz9sQH5vT+vZWq+--
