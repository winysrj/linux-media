Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44233 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752732AbdFNW2k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 18:28:40 -0400
Date: Thu, 15 Jun 2017 00:28:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, sebastian.reichel@collabora.co.uk,
        robh@kernel.org
Subject: Re: [PATCH 6/8] leds: as3645a: Add LED flash class driver
Message-ID: <20170614222833.GA26406@amd>
References: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
 <1497433639-13101-7-git-send-email-sakari.ailus@linux.intel.com>
 <20170614213941.GC10200@amd>
 <20170614222135.GT12407@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <20170614222135.GT12407@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Thanks for the review!

You are welcome :-).

> On Wed, Jun 14, 2017 at 11:39:41PM +0200, Pavel Machek wrote:
> > Hi!
> >=20
> > > From: Sakari Ailus <sakari.ailus@iki.fi>
> >=20
> > That address no longer works, right?
>=20
> Why wouldn't it work? Or... do you know something I don't? :-)

Aha. I thought I was removing it from source files because it was no
longer working, but maybe I'm misremembering?=20

> > > +static unsigned int as3645a_current_to_reg(struct as3645a *flash, bo=
ol is_flash,
> > > +					   unsigned int ua)
> > > +{
> > > +	struct {
> > > +		unsigned int min;
> > > +		unsigned int max;
> > > +		unsigned int step;
> > > +	} __mms[] =3D {
> > > +		{
> > > +			AS_TORCH_INTENSITY_MIN,
> > > +			flash->cfg.assist_max_ua,
> > > +			AS_TORCH_INTENSITY_STEP
> > > +		},
> > > +		{
> > > +			AS_FLASH_INTENSITY_MIN,
> > > +			flash->cfg.flash_max_ua,
> > > +			AS_FLASH_INTENSITY_STEP
> > > +		},
> > > +	}, *mms =3D &__mms[is_flash];
> > > +
> > > +	if (ua < mms->min)
> > > +		ua =3D mms->min;
> >=20
> > That's some... seriously interesting code. And you are forcing gcc to
> > create quite interesting structure on stack. Would it be easier to do
> > normal if()... without this magic?
> >=20
> > > +	struct v4l2_flash_config cfg =3D {
> > > +		.torch_intensity =3D {
> > > +			.min =3D AS_TORCH_INTENSITY_MIN,
> > > +			.max =3D flash->cfg.assist_max_ua,
> > > +			.step =3D AS_TORCH_INTENSITY_STEP,
> > > +			.val =3D flash->cfg.assist_max_ua,
> > > +		},
> > > +		.indicator_intensity =3D {
> > > +			.min =3D AS_INDICATOR_INTENSITY_MIN,
> > > +			.max =3D flash->cfg.indicator_max_ua,
> > > +			.step =3D AS_INDICATOR_INTENSITY_STEP,
> > > +			.val =3D flash->cfg.indicator_max_ua,
> > > +		},
> > > +	};
> >=20
> > Ugh. And here you have copy of the above struct, + .val. Can it be
> > somehow de-duplicated?
>=20
> The flash_brightness_set callback uses micro-Amps as the unit and the dri=
ver
> needs to convert that to its own specific units. Yeah, there would be
> probably an easier way, too. But that'd likely require changes to the LED
> flash class.

Can as3645a_current_to_reg just access struct v4l2_flash_config so
that it does not have to recreate its look-alike on the fly?

Thanks,
							Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllBuJEACgkQMOfwapXb+vJ+8QCcCsoVaIFQEOd80FhHgMqrySzk
bgwAoI0s1W1JFjJCSMh4f9cGZIQrh0Wt
=yC9s
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
