Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48233 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaAWLoF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jan 2014 06:44:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sebastian Reichel <sre@debian.org>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [RFCv2] Device Tree bindings for OMAP3 Camera System
Date: Thu, 23 Jan 2014 12:44:46 +0100
Message-ID: <1550284.gaVFBYq9I9@avalon>
In-Reply-To: <20140123001128.GA12425@earth.universe>
References: <20131103220315.GA11659@earth.universe> <2960230.3bGpm3THhQ@avalon> <20140123001128.GA12425@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5288855.0Skuhf1585"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart5288855.0Skuhf1585
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Hi Sebastian,

On Thursday 23 January 2014 01:11:29 Sebastian Reichel wrote:
> On Wed, Jan 22, 2014 at 11:57:45PM +0100, Laurent Pinchart wrote:
> > [...]
> >=20
> >> camera-switch {
> >>=20
> >>      /*
> >>     =20
> >>       * TODO:
> >>       *  - check if the switching code is generic enough to use a
> >>       *    more generic name like "gpio-camera-switch".
> >=20
> > I think you can use a more generic name. You could probably get som=
e
> > inspiration from the i2c-mux-gpio DT bindings.
>=20
> My main concern is, that the gpio used for switching is also connecte=
d to
> the reset pin of one of the cameras. Maybe that fact can just be negl=
ected,
> though?

I'm not the only one to wish we could change that, but alas! we'll have=
 to=20
live with that stupid hardware design decision :-)

What we want to ensure here is that the two sensors won't be accessed a=
t the=20
same time, as that would lead to errors. This was previously handled by=
=20
callback function to board code, but board code is now going away. The=20=

challenge is to find a way to express the constraints in DT. I'm not su=
re=20
whether that's doable in a generic way, and this might be one of the ra=
re=20
cases where board code is still needed.

Sakari, have you given this a thought ?

=2D-=20
Regards,

Laurent Pinchart

--nextPart5288855.0Skuhf1585
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABAgAGBQJS4QCzAAoJEIkPb2GL7hl14bEH/RwwE2ajQ0m4lQtqzD68sgOL
R1gfj9S851zEl2Axb+7sICL64xxb9yzuwlSEue6KdXKtVNyB0bUpYujfj1Z912Oc
QT9gPjRDebVo+jnS8XqfyvDzisUGuaYtWl0RVhmvDvtyiLEcic0rBpMwsJeedVYm
kFs5jmI4sHYAZnbRsFt4AiGY9sWbJeMuBMmnJH9Q72X9h+O71qay/4f9WppdS9Le
NJQFCnbiC4voBoCbBLFvxaREDxCF+X/ims12njZS2v9pdFwXP6CInDRgAgA9/GRY
gNM9mwvlufDFNs5BWmPf5TvUy/T6ltykqXisan6/8n7wVGp4/saR+nf0bk6Dj9k=
=5V4U
-----END PGP SIGNATURE-----

--nextPart5288855.0Skuhf1585--

