Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45063 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbdL0VFp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Dec 2017 16:05:45 -0500
Date: Wed, 27 Dec 2017 22:05:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        clayton@craftyguy.net, martijn@brixit.nl,
        sakari.ailus@linux.intel.com,
        Filip =?utf-8?Q?Matijevi=C4=87?= <filip.matijevic.pz@gmail.com>,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Subject: v4.15: camera problems on n900
Message-ID: <20171227210543.GA19719@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

In v4.14, back camera on N900 works. On v4.15-rc1.. it works for few
seconds, but then I get repeated oopses.

On v4.15-rc0.5 (commit ed30b147e1f6e396e70a52dbb6c7d66befedd786),
camera does not start.	 =20

Any ideas what might be wrong there?
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlpECycACgkQMOfwapXb+vI0YgCgqHBLUzffaVs4g5Yz++KAvhYr
bcoAoL+VnfbnBle9IebA96tGPcyWuMnR
=/JnQ
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
