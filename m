Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56126 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752549AbdGFKn1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Jul 2017 06:43:27 -0400
Date: Thu, 6 Jul 2017 12:43:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/8] Prepare for CCP2 / CSI-1 support, omap3isp fixes
Message-ID: <20170706104325.GA11297@amd>
References: <20170705230019.5461-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <20170705230019.5461-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Most of these patches have been posted to the list in some form or other
> already but a lot has happened since. Thus reposting. There are more
> patches in my ccp2 branch but they're not quite ready as such, for the
> reasons discussed previously.

I'm using Sakari's ccp2 branch as a basis of camera support for
N900. camera-fw5-6 branch on kernel.org has the code, and it works
rather well.

Yes, there's more work to be done (finishing the support in omap3isp,
connecting focus, flash, all the userland support, ...), but this is
good basis and is ready now.

Thus (for the series)

Acked-by: Pavel Machek <pavel@ucw.cz>
Tested-by: Pavel Machek <pavel@ucw.cz>

Best regards,
								Pavel
							=09
>=20
> Pavel Machek (1):
>   smiapp: add CCP2 support
>=20
> Sakari Ailus (7):
>   dt: bindings: Explicitly specify bus type
>   dt: bindings: Add strobe property for CCP2
>   v4l: fwnode: Call CSI2 bus csi2, not csi
>   v4l: fwnode: Obtain data bus type from FW
>   v4l: Add support for CSI-1 and CCP2 busses
>   omap3isp: Check for valid port in endpoints
>   omap3isp: Destroy CSI-2 phy mutexes in error and module removal


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlleFE0ACgkQMOfwapXb+vIvswCff1LaiXkVyklV+lqeQKpmOesR
spcAn20Y5cokizO0/TnttIXIB2iEKs9O
=yMpG
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
