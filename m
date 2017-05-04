Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42244 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752400AbdEDWBh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 May 2017 18:01:37 -0400
Date: Fri, 5 May 2017 00:01:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [RFC 0/3] Document bindings for camera modules and associated
 flash devices
Message-ID: <20170504220134.GA15551@amd>
References: <1493720749-31509-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <1493720749-31509-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This RFC patchset documents properties commonly required by camera modules
> and associated camera flash devices.
>=20
> The camera module is essentially a package consisting of an image sensor,
> a lens, possibly a voice coil to move the lens and a number of other
> things that at least the drivers need not to know of. All the devices in a
> camera module are declared separately in the system and as such the fact
> that they come in a single package isn't generally very useful to driver
> software.
>=20
> I'm sending the set as RFC as there's no driver implementation, and a
> dependency to the V4L2 async changes:
>=20
> <URL:http://www.spinics.net/lists/linux-media/msg114915.html>

For the series,

Acked-by: Pavel Machek <pavel@ucw.cz>

In 3/3, I'd avoid using strange characters in the changelog. Just
write it as I2C... If someone ever tries to grep the changelogs, this
could bite them.

Thanks,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkLpL4ACgkQMOfwapXb+vK1KgCeJDunO3aub0fKSYL+U/4LT+Ub
njcAn0JO8cgIqaLpr7j1/+ccQahBioEM
=8ZRh
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
