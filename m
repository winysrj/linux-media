Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40642 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754951AbdIHMkL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 08:40:11 -0400
Date: Fri, 8 Sep 2017 14:40:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        sre@kernel.org
Subject: Re: [PATCH v8 03/21] v4l: async: Use more intuitive names for
 internal functions
Message-ID: <20170908124010.GO18365@amd>
References: <20170905130553.1332-1-sakari.ailus@linux.intel.com>
 <20170905130553.1332-4-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XVTPT6MZt3zd/C+/"
Content-Disposition: inline
In-Reply-To: <20170905130553.1332-4-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--XVTPT6MZt3zd/C+/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2017-09-05 16:05:35, Sakari Ailus wrote:
> Rename internal functions to make the names of the functions better
> describe what they do.
>=20
> 	Old name			New name
> 	v4l2_async_test_notify	v4l2_async_match_notify
> 	v4l2_async_belongs	v4l2_async_find_match
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--XVTPT6MZt3zd/C+/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlmyj6kACgkQMOfwapXb+vJsAwCgku7G59h8hem9oZana53BkuRr
f8wAnRk6GC4LxGcK/AiCBsYMaQZPhNMM
=ICAd
-----END PGP SIGNATURE-----

--XVTPT6MZt3zd/C+/--
