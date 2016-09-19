Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932221AbcISV2b (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 17:28:31 -0400
Date: Mon, 19 Sep 2016 23:28:24 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 13/17] smiapp: Improve debug messages from frame
 layout reading
Message-ID: <20160919212823.pd46zodubufkjyj2@earth>
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
 <1473938551-14503-14-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="eocg3dgpnwd7lzwj"
Content-Disposition: inline
In-Reply-To: <1473938551-14503-14-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--eocg3dgpnwd7lzwj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 15, 2016 at 02:22:27PM +0300, Sakari Ailus wrote:
> Provide more debugging information on reading the frame layout.
>=20
> [...]
>
> @@ -130,7 +127,7 @@ static int smiapp_read_frame_fmt(struct smiapp_sensor=
 *sensor)
>  			pixels =3D desc & SMIAPP_FRAME_FORMAT_DESC_4_PIXELS_MASK;
>  		} else {
>  			dev_dbg(&client->dev,
> -				"invalid frame format model type %d\n",
> +				"0x8.8x invalid frame format model type %d\n",

0x8.8x doesn't look very interesting ;)

Apart from the '%' the actual argument is also missing.

> [...]

Once that is fixed:

Reviewed-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--eocg3dgpnwd7lzwj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJX4Fh3AAoJENju1/PIO/qakSQP/2l++XadelahUoWJjSgZvq98
LUSRU2wjj/yhByPhJ1cOSiVx8FzGuoFHoG/0laEedhokKCqfXV75yz9g79t1Bcrk
5gnvVeqypQK3ETaXpCTZrPhcC8+YgKmfnOqgTrf0+VQJ7IF387rkoOno+WFL/8Ib
CleP/W8tPwZ2n8MlUrlz45RQuMD/XOPC8w+XOpe/ncLx5zbrxxiuV2CzXio9x3Oj
sFHuKVus5eSnZa+0rjRF2Y9avL3BFGSsPAsP82Co7OH1/kfLn16HqEUOCCoyvaGQ
9eP5UXs4IyNfKaNk42VWnTSyxpC8HeQcTXI7rJSMWTQrWilOf4pjyKOxnPftEvpO
nop/RMcTPcOhLAAs75t++xM4v4PXJUe21ndvhrV6WKhjO9C03peyhXfEUxG7ilTF
Yo+IWDPFK0FIHX0RoVVu6k6hcBdJ16bz+Xd0mWuJiiOW1ibrAPOvAIxpHG99Vfah
rXmfnjuF4aBUsXhKUCUQYtLnoZ4+R3p3cZETe/IBtoj7sGPYOEtSVaDeYWgSqAYa
FCST5t0lvqr0ZNE4Lro09djrZR2/q5sU+mmrLGQZ/CBrzYnvNrh/WwJoiWM07N6s
qXQHJC6GDGylgNulfBmubXeeW2XvcE9T8BW1Lw8zTCVAY9tS3tQFkmXep/efB369
/j4F85k/qjNaZ7AfrlXG
=crb/
-----END PGP SIGNATURE-----

--eocg3dgpnwd7lzwj--
