Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52697 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750909AbdIPHNG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Sep 2017 03:13:06 -0400
Date: Sat, 16 Sep 2017 09:13:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        devicetree@vger.kernel.org, sre@kernel.org
Subject: Re: [PATCH v13 11/25] v4l: async: Introduce helpers for calling
 async ops callbacks
Message-ID: <20170916071302.GB8257@amd>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com>
 <20170915141724.23124-12-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3uo+9/B/ebqu+fSQ"
Content-Disposition: inline
In-Reply-To: <20170915141724.23124-12-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--3uo+9/B/ebqu+fSQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2017-09-15 17:17:10, Sakari Ailus wrote:
> Add three helper functions to call async operations callbacks. Besides
> simplifying callbacks, this allows async notifiers to have no ops set,
> i.e. it can be left NULL.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

I'd remove "_call" from these names; they are long enough already and
do not add much. But either way is okay.

Acked-by: Pavel Machek <pavel@ucw.cz>

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--3uo+9/B/ebqu+fSQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlm8zv4ACgkQMOfwapXb+vL9UACfQRnKrLsypfTcEhx6BMMrVJ0x
OxQAoLzneLVZgt0k/2o41SSR39M/PmPA
=5VKf
-----END PGP SIGNATURE-----

--3uo+9/B/ebqu+fSQ--
