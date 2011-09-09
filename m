Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60122 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933166Ab1IIJdR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2011 05:33:17 -0400
Date: Fri, 9 Sep 2011 11:33:15 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Jean-Francois Moine <moinejf@free.fr>
Subject: Re: [PATCH V2] gspca/zc3xx: add usb_id for HP Premium Starter Cam
Message-ID: <20110909093315.GI1912@pengutronix.de>
References: <20110702105537.50d0e1df@tele>
 <1309608120-7314-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BghK6+krpKHjj+jk"
Content-Disposition: inline
In-Reply-To: <1309608120-7314-1-git-send-email-w.sang@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--BghK6+krpKHjj+jk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 02, 2011 at 02:02:00PM +0200, Wolfram Sang wrote:
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Jean-Francois Moine <moinejf@free.fr>
> ---

Ping. I can't find it in the git-repos on linuxtv.org?

>=20
> V2: added entry in documentation
>=20
>  Documentation/video4linux/gspca.txt |    1 +
>  drivers/media/video/gspca/zc3xx.c   |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/Documentation/video4linux/gspca.txt b/Documentation/video4li=
nux/gspca.txt
> index 5bfa9a7..b3d5f75 100644
> --- a/Documentation/video4linux/gspca.txt
> +++ b/Documentation/video4linux/gspca.txt
> @@ -8,6 +8,7 @@ xxxx		vend:prod
>  ----
>  spca501		0000:0000	MystFromOri Unknown Camera
>  spca508		0130:0130	Clone Digital Webcam 11043
> +zc3xx		03f0:1b07	HP Premium Starter Cam
>  m5602		0402:5602	ALi Video Camera Controller
>  spca501		040a:0002	Kodak DVC-325
>  spca500		040a:0300	Kodak EZ200
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

--BghK6+krpKHjj+jk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk5p3VsACgkQD27XaX1/VRvSGQCgtCaRiJnN0C6+Gr5yNVzDmVHO
7FYAnAuWZH6vgeyMwTO0jhEXuiTk0ivi
=C+mZ
-----END PGP SIGNATURE-----

--BghK6+krpKHjj+jk--
