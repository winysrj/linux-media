Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:60616 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751840AbeDSMc4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 08:32:56 -0400
Date: Thu, 19 Apr 2018 14:32:44 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Samuel Bobrowicz <sam@elite-embedded.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: Re: [PATCH v2 00/12] media: ov5640: Misc cleanup and improvements
Message-ID: <20180419123244.tujbrkpazbdyows6@flea>
References: <20180416123701.15901-1-maxime.ripard@bootlin.com>
 <CAFwsNOF6t-AAXr8gEBLnCx2OF-PjAWALhsJRVYHSdnaP9hswWA@mail.gmail.com>
 <20180417160122.rfdlbdafmivgi5cd@flea>
 <CAFwsNOE3aockxFDbPP4B6LDckGrvM5grqcov5wui0aCyuQs4Tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ejouq6yvdsmbemkw"
Content-Disposition: inline
In-Reply-To: <CAFwsNOE3aockxFDbPP4B6LDckGrvM5grqcov5wui0aCyuQs4Tw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ejouq6yvdsmbemkw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

On Wed, Apr 18, 2018 at 04:39:06PM -0700, Samuel Bobrowicz wrote:
> I applied your patches, and they are a big improvement for what I am
> trying to do, but things still aren't working right on my platform.
>=20
> How confident are you that the MIPI mode will work with this version
> of the driver?

Not too confident. Like I said, I did all my tests on a parallel
camera with a scope, so I'm pretty confident for the parallel bus. But
I haven't been able to test the MIPI-CSI side of things and tried to
deduce it from the datasheet.

tl; dr: I might very well be wrong.

> I am having issues that I believe are due to incorrect clock
> generation. Our engineers did some reverse engineering of the clock
> tree themselves, and came up with a slightly different model.  I've
> captured their model in a spreadsheet here:
> https://tinyurl.com/pll-calc . Just modify the register and xclk
> values to see the clocks change. Do your tests disagree with this
> potential model?

At least on the parallel side, it looks fairly similar, so I guess we
can come to an agreement :)

There's just the SCLK2x divider that is no longer in the path to PCLK
but has been replaced with BIT Divider that has the same value, so it
should work as well.

> I'm not sure which model is more correct, but my tests suggest the
> high speed MIPI clock is generated directly off the PLL. This means
> the PLL multiplier you are generating in your algorithm is not high
> enough to satisfy the bandwidth. If this is the case, MIPI mode will
> require a different set of parameters that enable some of the
> downstream dividers, so that the PLL multiplier can be higher while
> the PCLK value still matches the needed rate calculated from the
> resolution.
>=20
> Any thoughts on this before I dive in and start tweaking the algorithm
> in mipi mode?

Like I said, I did that analysis by plugging the camera to a scope and
look at the PCLK generated for various combinations. Your analysis
seems not too far off for the setup I've tested, so I guess this makes
sense. And let me know how it works for MIPI-CSI2 so that I can update
the patches :)

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--ejouq6yvdsmbemkw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlrYjGsACgkQ0rTAlCFN
r3Q8tA/8CYo0ZP1j8O/Ak4lawyiLCqzKHAIvZ+jpynhBYZjqofmQlfvyekb31GgR
MfSqMcbkss/QY/KJO4JrW2SJW59aVroO9BQlGxXmDJZwmvQrMn9jeYTwi4djxJ0h
r+3Hkba1kg99iCEM5OR7hWGZoorWO+6yG6pH4a/kCqlyTAvSfCrykpGwzJ/Zniv1
Q5DVR0G5PU2Xw/ih289eEwYf7/tabd5+/rbOEQItK0gvfOpdZFHc7X9UFrQ7rWKn
8PBVqeSq5bsHfEbqfBxv0c8/nXzqUVgxZHbAUH4aXYKqpgPkl0eTuK0waMMI75Rt
QtRkUm/ak9+00KKhHxxU+ODemHFX4eTHY0IJUyS2YZdSkAlOPxVRFuQkEzycMRjz
LvSDqQdC0YSGCUbnhApYJL0fGxrMRRRax3x1d9FNlaH3obJSFugnuq3Y+9uj8a5z
z+U1VbIKFddL2R9+QBBFldm0Bjmc0txcjEF9RbrmBKmziRgnuEBvpzOQJoW9UL9i
9QkhECnTOXyFAkdyjgEPT+SEppVmpgGslPdlpz4g9FjfrGuJp8/aRU4zLvrfI2vX
MQWHKz4YB7SCFXueCGmdVjT9i6qiIqRmmg9XkQcFbrSm0TvwS9NwC4FX5l6u78w/
nqyHATEnds5p6jE4L4r80H73YGWkr2SiOFD6I80iPwIXhw460cQ=
=UCLv
-----END PGP SIGNATURE-----

--ejouq6yvdsmbemkw--
