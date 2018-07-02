Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:58992 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752050AbeGBM5J (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jul 2018 08:57:09 -0400
Date: Mon, 2 Jul 2018 14:57:07 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        sam@elite-embedded.com, hugues.fruchet@st.com,
        loic.poulain@linaro.org, daniel@zonque.org,
        linux-media@vger.kernel.org, Jacopo Mondi <jacopo@jmondi.org>
Subject: Re: [PATCH 1/2] media: i2c: ov5640: Re-work MIPI start sequence
Message-ID: <20180702125707.po2akd6p7ezd7g3q@flea>
References: <1530290560-25806-1-git-send-email-jacopo+renesas@jmondi.org>
 <1530290560-25806-2-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="33x5qx3hwrazmqd6"
Content-Disposition: inline
In-Reply-To: <1530290560-25806-2-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--33x5qx3hwrazmqd6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 29, 2018 at 06:42:39PM +0200, Jacopo Mondi wrote:
> From: Jacopo Mondi <jacopo@jmondi.org>
>=20
> Change the MIPI CSI-2 interface startup sequence to the following:
>=20
> Initialization:
> 0x3019 =3D 0x70 : Lane1, Lane2 and clock in LP11 when in 'sleep mode'
> 0x300e =3D 0x58 : 2 lanes mode, power down TX and RX, MIPI CSI-2 off
> 0x4800 =3D 0x20 : Gate clock when not transmitting, LP00 when not transmi=
tting
>=20
> Stream on:
> 0x300e =3D 0x4c : 2 lanes mode, power up TX and enable MIPI
>=20
> Stream off:
> 0x300e =3D 0x58 : 2 lanes mode, power down TX and RX, MIPI CSI-2 off
>=20
> Signed-off-by: Jacopo Mondi <jacopo@jmondi.org>
> ---
>  drivers/media/i2c/ov5640.c | 26 ++++++++++++++++++--------
>  1 file changed, 18 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index 1ecbb7a..465acce 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -259,6 +259,7 @@ static inline struct v4l2_subdev *ctrl_to_sd(struct v=
4l2_ctrl *ctrl)
>  static const struct reg_value ov5640_init_setting_30fps_VGA[] =3D {
>  	{0x3103, 0x11, 0, 0}, {0x3008, 0x82, 0, 5}, {0x3008, 0x42, 0, 0},
>  	{0x3103, 0x03, 0, 0}, {0x3017, 0x00, 0, 0}, {0x3018, 0x00, 0, 0},
> +	{0x3019, 0x70, 0, 0},

I'd really prefer to remove parts of that array, instead of adding
more to that unmaintainable blob.

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--33x5qx3hwrazmqd6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAls6ISIACgkQ0rTAlCFN
r3SeTQ//eh7ZWfpsvXIQjChWB6uIzZ3FDeLNbedpJR7OkbDna8Q9Oe/hz/VsBfXf
UaJCZGpqkua1mYmwUAhlmxKIs6vQkByBXlPAedaXrTo9H1DJWUxunEQ2T3qCf1Q5
3CUxhdLqJLEtZ87zuVpfjEStsAQcUkPcjW4eAgTxqvmYlfXWAC9y3NuyYZVtMj21
t2iSV6wdkLt6HjNR9LitOEo/tj4ubJwXnGIKynnKfAJmsOj2txPJWmQu6OP4uOlW
r6cBc234gBB92GDBHmM51DgWOcOEGhlrL00/VQMeV28AT+5Tnn+odKf3svAkM7+f
/cGkz6vD68tAcstUE+XOBneScxSt2df5dr4FGrO/GTbj4Dt1eTlaaSo4KRsfUQQy
Sswn6aShcXHLi8BxfJzuE+SX0nM2Uxq0CSsUaSThNKJVLWC4yjyOfrysWyRfnFN7
W9cNbGg+Qagw2JieIQSGFuqp4NEjGKEJvU6kX4SjpDcUWmKO0LZkuc53eheD+evB
O+HlrifwsVXLtwkcrNX01cvr2cdERUJI0oO7MwBFby1ZF3JohMb9KR6QGDYpdMMJ
FbaamFvLYW1xWLFB1FuxrLSJ1Ox4UOIPiBRxGgjlDmIraTh3iLevb0I9EEPmfOj+
DMAdzLTW9w2tyFSt1Ql8/DScmrKpnRB7BMu4/K3KA49lCJ3MUyA=
=bFxR
-----END PGP SIGNATURE-----

--33x5qx3hwrazmqd6--
