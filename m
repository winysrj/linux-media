Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54091 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756581AbdIHTQk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 15:16:40 -0400
Date: Fri, 8 Sep 2017 21:16:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 1/1] media: i2c: as3645a: Remove driver
Message-ID: <20170908191638.GT18365@amd>
References: <20170908135140.7733-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vru7fAags9pVPvn5"
Content-Disposition: inline
In-Reply-To: <20170908135140.7733-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--vru7fAags9pVPvn5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2017-09-08 16:51:40, Sakari Ailus wrote:
1;2802;0c> Remove the V4L2 AS3645A sub-device driver in favour of the LED f=
lash class
> driver for the same hardware, drivers/leds/leds-as3645a.c. The latter uses
> the V4L2 flash LED class framework to provide V4L2 sub-device interface.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

Thanks!
								Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--vru7fAags9pVPvn5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlmy7JYACgkQMOfwapXb+vJ1qgCggdF2xOJfslaKFYJkujmYUhH1
9rEAnAjabFi/GoYf+pDhzcXH+mZaPF+z
=MxqL
-----END PGP SIGNATURE-----

--vru7fAags9pVPvn5--
