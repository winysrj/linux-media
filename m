Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52489 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751221AbdIPHEh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Sep 2017 03:04:37 -0400
Date: Sat, 16 Sep 2017 09:04:31 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        devicetree@vger.kernel.org, sre@kernel.org
Subject: Re: [PATCH v13 06/25] omap3isp: Use generic parser for parsing
 fwnode endpoints
Message-ID: <20170916070431.GA8257@amd>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com>
 <20170915141724.23124-7-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <20170915141724.23124-7-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Instead of using driver implementation, use
> v4l2_async_notifier_parse_fwnode_endpoints() to parse the fwnode endpoints
> of the device.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Patches at least up to here look fine o me.

We are at version 13 of the series... Is merge of the series expected
anytimme soon?

If not, can we at least merge patches up to here, so that less stuff
is retransmitted over and over?

Thanks,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlm8zP8ACgkQMOfwapXb+vIXPgCgobzSQMs7Sp8DBUq3/VmwOvKz
EewAmwVRyOhJG6tOrP4dj3T1S8sxDBL5
=98tm
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
