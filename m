Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39560 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752877AbdFQMRr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Jun 2017 08:17:47 -0400
Date: Sat, 17 Jun 2017 14:17:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, sebastian.reichel@collabora.co.uk,
        robh@kernel.org
Subject: Re: [PATCH 7/8] smiapp: Add support for flash, lens and EEPROM
 devices
Message-ID: <20170617121744.GA419@amd>
References: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
 <1497433639-13101-8-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <1497433639-13101-8-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> These types devices aren't directly related to the sensor, but are
> nevertheless handled by the smiapp driver due to the relationship of these
> component to the main part of the camera module --- the sensor.
>=20
> Additionally, for the async sub-device registration to work, the notifier
> containing matching fwnodes will need to be registered. This is natural to
> perform in a sensor driver as well.
>=20
> This does not yet address providing the user space with information on how
> to associate the sensor, lens or EEPROM devices but the kernel now has the
> necessary information to do that.

> -static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
> +static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev,
> +						   struct smiapp_sensor *sensor)
>  {
> +	static const char *props[] =3D { "flash", "lens", "eeprom" };
>  	struct smiapp_hwconfig *hwcfg;

Binding says "lens-focus" but this uses just "lens". I prefer
lens-focus, because we may also have lens-aperture...

Thanks,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllFHegACgkQMOfwapXb+vK1mwCfWbnNXbcbXqHDr+9Qb9zJ294F
flsAnRoU1uDmbmCFepIRdw0lKKgh6aO2
=vLpH
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
