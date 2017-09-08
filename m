Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40576 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753645AbdIHMjP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 08:39:15 -0400
Date: Fri, 8 Sep 2017 14:39:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        sre@kernel.org
Subject: Re: [PATCH v8 01/21] v4l: fwnode: Move KernelDoc documentation to
 the header
Message-ID: <20170908123914.GN18365@amd>
References: <20170905130553.1332-1-sakari.ailus@linux.intel.com>
 <20170905130553.1332-2-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vDEbda84Uy/oId5W"
Content-Disposition: inline
In-Reply-To: <20170905130553.1332-2-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--vDEbda84Uy/oId5W
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2017-09-05 16:05:33, Sakari Ailus wrote:
> In V4L2 the practice is to have the KernelDoc documentation in the header
> and not in .c source code files. This consequientally makes the V4L2
> fwnode function documentation part of the Media documentation build.
>=20
> Also correct the link related function and argument naming in
> documentation.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.se>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--vDEbda84Uy/oId5W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlmyj3IACgkQMOfwapXb+vKVZQCeNYuNhpjpg6+J5bBwhwhDahjs
UNQAnjxsYtZ4TT+omtGn+j/PzljFBkAB
=WhPU
-----END PGP SIGNATURE-----

--vDEbda84Uy/oId5W--
