Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48530 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757293AbdIIJIw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Sep 2017 05:08:52 -0400
Date: Sat, 9 Sep 2017 11:08:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-acpi@vger.kernel.org,
        mika.westerberg@intel.com, devicetree@vger.kernel.org,
        sre@kernel.org
Subject: Re: [PATCH v9 15/24] dt: bindings: Add a binding for flash LED
 devices associated to a sensor
Message-ID: <20170909090850.GH27428@amd>
References: <20170908131235.30294-1-sakari.ailus@linux.intel.com>
 <20170908131822.31020-11-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="AzNpbZlgThVzWita"
Content-Disposition: inline
In-Reply-To: <20170908131822.31020-11-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--AzNpbZlgThVzWita
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2017-09-08 16:18:13, Sakari Ailus wrote:
> Camera flash drivers (and LEDs) are separate from the sensor devices in
> DT. In order to make an association between the two, provide the
> association information to the software.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Rob Herring <robh@kernel.org>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--AzNpbZlgThVzWita
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlmzr6IACgkQMOfwapXb+vJqegCfYg+i244gOmBvqevedtYrJvCV
NvkAoLWvUY+Geyjcmaa/DbARRpbFSaTF
=2cTx
-----END PGP SIGNATURE-----

--AzNpbZlgThVzWita--
