Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49837 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751934AbdJFLVV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Oct 2017 07:21:21 -0400
Date: Fri, 6 Oct 2017 13:21:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, sre@kernel.org
Subject: Re: [PATCH v15 29/32] et8ek8: Add support for flash and lens devices
Message-ID: <20171006112118.GD9497@amd>
References: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
 <20171004215051.13385-30-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="sXc4Kmr5FA7axrvy"
Content-Disposition: inline
In-Reply-To: <20171004215051.13385-30-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--sXc4Kmr5FA7axrvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2017-10-05 00:50:48, Sakari Ailus wrote:
> Parse async sub-devices related to the sensor by switching the async
> sub-device registration function.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--sXc4Kmr5FA7axrvy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlnXZy4ACgkQMOfwapXb+vKrIgCfZiJiqS4LeRrTlF1DBZCylZGj
o0IAoIte+9OBP5t10YKD9WuJQUv5VWWJ
=/VCQ
-----END PGP SIGNATURE-----

--sXc4Kmr5FA7axrvy--
