Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48751 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757293AbdIIJQa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Sep 2017 05:16:30 -0400
Date: Sat, 9 Sep 2017 11:16:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-acpi@vger.kernel.org,
        mika.westerberg@intel.com, devicetree@vger.kernel.org,
        sre@kernel.org
Subject: Re: [PATCH v9 08/24] omap3isp: Fix check for our own sub-devices
Message-ID: <20170909091628.GK27428@amd>
References: <20170908131235.30294-1-sakari.ailus@linux.intel.com>
 <20170908131822.31020-4-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Ucgz5Oc/kKURWzXs"
Content-Disposition: inline
In-Reply-To: <20170908131822.31020-4-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Ucgz5Oc/kKURWzXs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2017-09-08 16:18:06, Sakari Ailus wrote:
> We only want to link sub-devices that were bound to the async notifier the
> isp driver registered but there may be other sub-devices in the
> v4l2_device as well. Check for the correct async notifier.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--Ucgz5Oc/kKURWzXs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlmzsWwACgkQMOfwapXb+vI3TACfU1crsmQMoLZpU4sQoL7WPatN
6p0An34dlRzaDZ6cFNxu2L8RSXVaVtuI
=Kwu/
-----END PGP SIGNATURE-----

--Ucgz5Oc/kKURWzXs--
