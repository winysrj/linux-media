Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44340 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751424AbdILKbp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 06:31:45 -0400
Date: Tue, 12 Sep 2017 12:31:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        sre@kernel.org
Subject: Re: [PATCH v11 21/24] smiapp: Add support for flash and lens devices
Message-ID: <20170912103143.GA27117@amd>
References: <20170912084236.1154-1-sakari.ailus@linux.intel.com>
 <20170912084236.1154-22-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <20170912084236.1154-22-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2017-09-12 11:42:33, Sakari Ailus wrote:
> Parse async sub-devices by using
> v4l2_subdev_fwnode_reference_parse_sensor_common().
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

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlm3t48ACgkQMOfwapXb+vK4egCfeUGe0ocAXGDK5HkjkGvXTL4+
n6oAn05JomZXKrn+EbyR1SuWBqmd7v0U
=SWQq
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
