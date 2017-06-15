Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57731 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752306AbdFOKnN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 06:43:13 -0400
Date: Thu, 15 Jun 2017 12:43:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, sebastian.reichel@collabora.co.uk,
        robh@kernel.org
Subject: Re: [PATCH 6/8] leds: as3645a: Add LED flash class driver
Message-ID: <20170615104309.GA16845@amd>
References: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
 <1497433639-13101-7-git-send-email-sakari.ailus@linux.intel.com>
 <20170614213941.GC10200@amd>
 <20170614222135.GT12407@valkosipuli.retiisi.org.uk>
 <20170614222833.GA26406@amd>
 <20170614224304.GW12407@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <20170614224304.GW12407@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Krasny den!

> > > Thanks for the review!
> >=20
> > You are welcome :-).
> >=20
> > > On Wed, Jun 14, 2017 at 11:39:41PM +0200, Pavel Machek wrote:
> > > > Hi!
> > > >=20
> > > > > From: Sakari Ailus <sakari.ailus@iki.fi>
> > > >=20
> > > > That address no longer works, right?
> > >=20
> > > Why wouldn't it work? Or... do you know something I don't? :-)
> >=20
> > Aha. I thought I was removing it from source files because it was no
> > longer working, but maybe I'm misremembering?=20
>=20
> That was probably my @maxwell.research.nokia.com address. :-) There are no
> occurrences of that in the kernel source anymore.

I guess it probably was someone else using @iki.fi address, and I am
confused.

> > > > > +	struct v4l2_flash_config cfg =3D {
> > > > > +		.torch_intensity =3D {
> > > > > +			.min =3D AS_TORCH_INTENSITY_MIN,
> > > > > +			.max =3D flash->cfg.assist_max_ua,
> > > > > +			.step =3D AS_TORCH_INTENSITY_STEP,
> > > > > +			.val =3D flash->cfg.assist_max_ua,
> > > > > +		},
> > > > > +		.indicator_intensity =3D {
> > > > > +			.min =3D AS_INDICATOR_INTENSITY_MIN,
> > > > > +			.max =3D flash->cfg.indicator_max_ua,
> > > > > +			.step =3D AS_INDICATOR_INTENSITY_STEP,
> > > > > +			.val =3D flash->cfg.indicator_max_ua,
> > > > > +		},
> > > > > +	};
> > > >=20
> > > > Ugh. And here you have copy of the above struct, + .val. Can it be
> > > > somehow de-duplicated?
> > >=20
> > > The flash_brightness_set callback uses micro-Amps as the unit and the=
 driver
> > > needs to convert that to its own specific units. Yeah, there would be
> > > probably an easier way, too. But that'd likely require changes to the=
 LED
> > > flash class.
> >=20
> > Can as3645a_current_to_reg just access struct v4l2_flash_config so
> > that it does not have to recreate its look-alike on the fly?
>=20
> struct v4l2_flash_config is only needed as an argument for
> v4l2_flash_init(). I'll split that into two functions in this occasion,
> it'll be nicer.
>=20
> We now have more or less the same conversion implemented in three or so
> times, there have to be ways to make that easier for drivers. I think that
> could be done later, as well as adding support for checking the flash
> strobe status.

Ok, thanks!
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllCZL0ACgkQMOfwapXb+vJNXwCgtYgv935ZK7uxMJ1EWkQKmTrx
+z4AoJ6gtFJ3En8G2FfcqzdTc0GiX1/N
=N3JL
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
