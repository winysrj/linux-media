Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54507 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751707AbdIKLRt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 07:17:49 -0400
Date: Mon, 11 Sep 2017 13:17:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-acpi@vger.kernel.org,
        mika.westerberg@intel.com, devicetree@vger.kernel.org,
        sre@kernel.org
Subject: Re: [PATCH v10 19/24] v4l: fwnode: Add convenience function for
 parsing common external refs
Message-ID: <20170911111746.GC28095@amd>
References: <20170911080008.21208-1-sakari.ailus@linux.intel.com>
 <20170911080008.21208-20-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="lCAWRPmW1mITcIfM"
Content-Disposition: inline
In-Reply-To: <20170911080008.21208-20-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--lCAWRPmW1mITcIfM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2017-09-11 11:00:03, Sakari Ailus wrote:
> Add v4l2_fwnode_parse_reference_sensor_common for parsing common
> sensor properties that refer to adjacent devices such as flash or lens
> driver chips.
>=20
> As this is an association only, there's little a regular driver needs to
> know about these devices as such.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-fwnode.c | 35 +++++++++++++++++++++++++++++=
++++++
>  include/media/v4l2-fwnode.h           | 13 +++++++++++++
>  2 files changed, 48 insertions(+)
>=20
> =20
> +/**
> + * v4l2_fwnode_reference_parse_sensor_common - parse common references on
> + *					       sensors for async sub-devices
> + * @dev: the device node the properties of which are parsed for referenc=
es
> + * @notifier: the async notifier where the async subdevs will be added
> + *
> + * Return: 0 on success
> + *	   -ENOMEM if memory allocation failed
> + *	   -EINVAL if property parsing failed
> + */

Returns: would sound more correct to me, but it seems kernel is split
on that.

Acked-by: Pavel Machek <pavel@ucw.cz>
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--lCAWRPmW1mITcIfM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlm2cNoACgkQMOfwapXb+vJgZACcCkVn13IDbgYN+aUCh7kCVYQ+
PjIAmgK5ZOmxTcoJB57+7kr6xAhYFos7
=0Inh
-----END PGP SIGNATURE-----

--lCAWRPmW1mITcIfM--
