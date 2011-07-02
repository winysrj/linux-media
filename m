Return-path: <mchehab@pedra>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41481 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab1GBIHo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jul 2011 04:07:44 -0400
Date: Sat, 2 Jul 2011 10:07:41 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] [media] gspca/zc3xx: add usb_id for HP Premium Starter
 Cam
Message-ID: <20110702080741.GA5578@pengutronix.de>
References: <1308140202-14854-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <1308140202-14854-1-git-send-email-w.sang@pengutronix.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 15, 2011 at 02:16:42PM +0200, Wolfram Sang wrote:
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> ---

Ping. Who is picking this up? Anything to be done on my side?

>=20
> Fixes https://bugzilla.kernel.org/show_bug.cgi?id=3D13479
>=20
>  drivers/media/video/gspca/zc3xx.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/media/video/gspca/zc3xx.c b/drivers/media/video/gspc=
a/zc3xx.c
> index 61cdd56..dbbab48 100644
> --- a/drivers/media/video/gspca/zc3xx.c
> +++ b/drivers/media/video/gspca/zc3xx.c
> @@ -6970,6 +6970,7 @@ static const struct sd_desc sd_desc =3D {
>  };
> =20
>  static const struct usb_device_id device_table[] =3D {
> +	{USB_DEVICE(0x03f0, 0x1b07)},
>  	{USB_DEVICE(0x041e, 0x041e)},
>  	{USB_DEVICE(0x041e, 0x4017)},
>  	{USB_DEVICE(0x041e, 0x401c), .driver_info =3D SENSOR_PAS106},
> --=20
> 1.7.2.5
>=20

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4O0c0ACgkQD27XaX1/VRsj1ACfTm+FmGqVGoLrXt/y1rxoeg2/
Tp0An00EpKJ9ulqlwtXxHXjZTbzN9rlS
=TM0R
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
