Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56815 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751537AbcKGKgw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2016 05:36:52 -0500
Date: Mon, 7 Nov 2016 11:36:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Rob Herring <robh@kernel.org>, ivo.g.dimitrov.75@gmail.com,
        sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mchehab@osg.samsung.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: et8ek8: add device tree binding documentation
Message-ID: <20161107103648.GA5326@amd>
References: <20161023191706.GA25754@amd>
 <20161030204134.hpmfrnqhd4mg563o@rob-hp-laptop>
 <20161103124749.GA22180@amd>
 <20161103222014.GI3217@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <20161103222014.GI3217@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2016-11-04 00:20:14, Sakari Ailus wrote:
> Hi Pavel and Rob,
>=20
> On Thu, Nov 03, 2016 at 01:47:49PM +0100, Pavel Machek wrote:
> > Hi!
> >=20
> > > > +Mandatory properties
> > > > +--------------------
> > > > +
> > > > +- compatible: "toshiba,et8ek8"
> > > > +- reg: I2C address (0x3e, or an alternative address)
> > > > +- vana-supply: Analogue voltage supply (VANA), 2.8 volts
> > > > +- clocks: External clock to the sensor
> > > > +- clock-frequency: Frequency of the external clock to the sensor. =
Camera
> > > > +  driver will set this frequency on the external clock.
> > >=20
> > > This is fine if the frequency is fixed (e.g. an oscillator), but you=
=20
> > > should use the clock binding if clocks are programable.
> >=20
> > It is fixed. So I assume this can stay as is? Or do you want me to add
> > "The clock frequency is a pre-determined frequency known to be
> > suitable to the board." as Sakari suggests?

Rob?
								Pavel

> > > > +- reset-gpios: XSHUTDOWN GPIO
> > >=20
> > > Please state what the active polarity is.
> >=20
> > As in "This gpio will be set to 1 when the chip is powered." ?
>=20
> How about:
>=20
> "The XSHUTDOWN signal is active high. The sensor is in hardware standby
> mode when the signal is in low state."
>=20
> These bindings start looking more precise than the smiapp ones. :-)
>=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlggWUAACgkQMOfwapXb+vLiEwCdH7WwBwuaU+W+vkyxV0rgCAW0
SFQAoJobgzgs8G1P1rq7cJoo5gO0rMpK
=PtQ4
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
