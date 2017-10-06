Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49813 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751663AbdJFLVE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Oct 2017 07:21:04 -0400
Date: Fri, 6 Oct 2017 13:21:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, sre@kernel.org
Subject: Re: [PATCH v15 28/32] smiapp: Add support for flash and lens devices
Message-ID: <20171006112102.GC9497@amd>
References: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
 <20171004215051.13385-29-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="t0UkRYy7tHLRMCai"
Content-Disposition: inline
In-Reply-To: <20171004215051.13385-29-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--t0UkRYy7tHLRMCai
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2017-10-05 00:50:47, Sakari Ailus wrote:
> Parse async sub-devices related to the sensor by switching the async
> sub-device registration function.
>=20
> These types devices aren't directly related to the sensor, but are
> nevertheless handled by the smiapp driver due to the relationship of these
> component to the main part of the camera module --- the sensor.
>=20
> This does not yet address providing the user space with information on how
> to associate the sensor or lens devices but the kernel now has the
> necessary information to do that.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--t0UkRYy7tHLRMCai
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlnXZx4ACgkQMOfwapXb+vIPgwCdHBSg/fdMG8cv0705sA0p+MfU
7jQAoJrWaZ4KR2phv9/i8hia6McCHIah
=8Odf
-----END PGP SIGNATURE-----

--t0UkRYy7tHLRMCai--
