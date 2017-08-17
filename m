Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49572 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752632AbdHQVio (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Aug 2017 17:38:44 -0400
Date: Thu, 17 Aug 2017 23:38:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] et8ek8: Decrease stack usage
Message-ID: <20170817213842.GA13909@amd>
References: <1502868825-4531-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
In-Reply-To: <1502868825-4531-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2017-08-16 10:33:45, Sakari Ailus wrote:
> The et8ek8 driver combines I=B2C register writes to a single array that it
> passes to i2c_transfer(). The maximum number of writes is 48 at once,
> decrease it to 8 and make more transfers if needed, thus avoiding a
> warning on stack usage.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Pavel: this is just compile tested. Could you test it on N900, please?

(More than 1 et8ek8 device makes static bad idea).

Acked-by: Pavel Machek <pavel@ucw.cz>
Tested-by: Pavel Machek <pavel@ucw.cz>

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlmWDOIACgkQMOfwapXb+vLBsACfdc0+swlMNvwwBVlO1fZGkoBa
bfsAn2tdrgIiln0iDvxwJKzCW8shDSJt
=PNcx
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
