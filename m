Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56616 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753054AbdE0GzI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 27 May 2017 02:55:08 -0400
Date: Sat, 27 May 2017 08:55:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] ad5820: unregister async sub-device
Message-ID: <20170527065506.GB24739@amd>
References: <1495803648-29261-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XF85m9dhOBO43t/C"
Content-Disposition: inline
In-Reply-To: <1495803648-29261-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--XF85m9dhOBO43t/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2017-05-26 16:00:48, Sakari Ailus wrote:
> The async sub-device was not unregistered in ad5820_remove() as it should
> have been; do it now. Also remove the now-redundant
> v4l2_device_unregister_subdev().
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--XF85m9dhOBO43t/C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkpIsoACgkQMOfwapXb+vKbbQCfWuyZgO9hONnbJADh4Bc9r8No
QVwAoLFkiFxXuK5QbIlthoeZ8UVGc1+K
=RcPV
-----END PGP SIGNATURE-----

--XF85m9dhOBO43t/C--
