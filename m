Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43260 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752372AbdFNVjo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 17:39:44 -0400
Date: Wed, 14 Jun 2017 23:39:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, sebastian.reichel@collabora.co.uk,
        robh@kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 6/8] leds: as3645a: Add LED flash class driver
Message-ID: <20170614213941.GC10200@amd>
References: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
 <1497433639-13101-7-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="w7PDEPdKQumQfZlR"
Content-Disposition: inline
In-Reply-To: <1497433639-13101-7-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--w7PDEPdKQumQfZlR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Sakari Ailus <sakari.ailus@iki.fi>

That address no longer works, right?

> Add a LED flash class driver for the as3654a flash controller. A V4L2 fla=
sh
> driver for it already exists (drivers/media/i2c/as3645a.c), and this driv=
er
> is based on that.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> + * Based on drivers/media/i2c/as3645a.c.
> + *
> + * Contact: Sakari Ailus <sakari.ailus@iki.fi>

So I believe it should not be here.

> +/*
> + * as3645a_set_config - Set flash configuration registers
> + * @flash: The flash
> + *

/** for linuxdoc?=20

> +	struct as3645a *flash =3D fled_to_as3645a(fled);
> +	int rval;
> +
> +	/* NOTE: reading register clear fault status */

clears.

> +static unsigned int as3645a_current_to_reg(struct as3645a *flash, bool i=
s_flash,
> +					   unsigned int ua)
> +{
> +	struct {
> +		unsigned int min;
> +		unsigned int max;
> +		unsigned int step;
> +	} __mms[] =3D {
> +		{
> +			AS_TORCH_INTENSITY_MIN,
> +			flash->cfg.assist_max_ua,
> +			AS_TORCH_INTENSITY_STEP
> +		},
> +		{
> +			AS_FLASH_INTENSITY_MIN,
> +			flash->cfg.flash_max_ua,
> +			AS_FLASH_INTENSITY_STEP
> +		},
> +	}, *mms =3D &__mms[is_flash];
> +
> +	if (ua < mms->min)
> +		ua =3D mms->min;

That's some... seriously interesting code. And you are forcing gcc to
create quite interesting structure on stack. Would it be easier to do
normal if()... without this magic?

> +	struct v4l2_flash_config cfg =3D {
> +		.torch_intensity =3D {
> +			.min =3D AS_TORCH_INTENSITY_MIN,
> +			.max =3D flash->cfg.assist_max_ua,
> +			.step =3D AS_TORCH_INTENSITY_STEP,
> +			.val =3D flash->cfg.assist_max_ua,
> +		},
> +		.indicator_intensity =3D {
> +			.min =3D AS_INDICATOR_INTENSITY_MIN,
> +			.max =3D flash->cfg.indicator_max_ua,
> +			.step =3D AS_INDICATOR_INTENSITY_STEP,
> +			.val =3D flash->cfg.indicator_max_ua,
> +		},
> +	};

Ugh. And here you have copy of the above struct, + .val. Can it be
somehow de-duplicated?

Thanks,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--w7PDEPdKQumQfZlR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllBrR0ACgkQMOfwapXb+vKLXQCfR+tvSBp4kY3dlPDYmF9g3//B
dlgAoIA87/cHb8hv8V74+0QwtZvP1W7O
=0ZJ9
-----END PGP SIGNATURE-----

--w7PDEPdKQumQfZlR--
