Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:32981 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751967AbdGSMCs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 08:02:48 -0400
Date: Wed, 19 Jul 2017 14:02:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        jacek.anaszewski@gmail.com, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 2/2] v4l2-flash-led-class: Create separate sub-devices
 for indicators
Message-ID: <20170719120246.GB23510@amd>
References: <20170718184107.10598-1-sakari.ailus@linux.intel.com>
 <20170718184107.10598-3-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XF85m9dhOBO43t/C"
Content-Disposition: inline
In-Reply-To: <20170718184107.10598-3-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--XF85m9dhOBO43t/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2017-07-18 21:41:07, Sakari Ailus wrote:
> The V4L2 flash interface allows controlling multiple LEDs through a single
> sub-devices if, and only if, these LEDs are of different types. This
> approach scales badly for flash controllers that drive multiple flash LEDs
> or for LED specific associations. Essentially, the original assumption of=
 a
> LED driver chip that drives a single flash LED and an indicator LED is no
> longer valid.
>=20
> Address the matter by registering one sub-device per LED.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

Does anything need to be done with drivers/media/i2c/adp1653.c ?

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--XF85m9dhOBO43t/C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllvSmYACgkQMOfwapXb+vLdmwCgt3gvhj4ej88cOSH4naXlYQrx
mNQAn3kQI6JuW+pfiQ65uF0QdL0Bm+FN
=ragz
-----END PGP SIGNATURE-----

--XF85m9dhOBO43t/C--
