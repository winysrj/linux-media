Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59374 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756519AbcKCMrx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 Nov 2016 08:47:53 -0400
Date: Thu, 3 Nov 2016 13:47:49 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Rob Herring <robh@kernel.org>
Cc: ivo.g.dimitrov.75@gmail.com, sakari.ailus@iki.fi, sre@kernel.org,
        pali.rohar@gmail.com, linux-media@vger.kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mchehab@osg.samsung.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: et8ek8: add device tree binding documentation
Message-ID: <20161103124749.GA22180@amd>
References: <20161023191706.GA25754@amd>
 <20161030204134.hpmfrnqhd4mg563o@rob-hp-laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <20161030204134.hpmfrnqhd4mg563o@rob-hp-laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > +Mandatory properties
> > +--------------------
> > +
> > +- compatible: "toshiba,et8ek8"
> > +- reg: I2C address (0x3e, or an alternative address)
> > +- vana-supply: Analogue voltage supply (VANA), 2.8 volts
> > +- clocks: External clock to the sensor
> > +- clock-frequency: Frequency of the external clock to the sensor. Came=
ra
> > +  driver will set this frequency on the external clock.
>=20
> This is fine if the frequency is fixed (e.g. an oscillator), but you=20
> should use the clock binding if clocks are programable.

It is fixed. So I assume this can stay as is? Or do you want me to add
"The clock frequency is a pre-determined frequency known to be
suitable to the board." as Sakari suggests?

> > +- reset-gpios: XSHUTDOWN GPIO
>=20
> Please state what the active polarity is.

As in "This gpio will be set to 1 when the chip is powered." ?

Thanks,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgbMfUACgkQMOfwapXb+vLRFQCdFTMF0elT5tSOWocc/9aWOFrL
RFwAnRwMNhbl2WCsFd3ZLyGZ5XaE8bJ6
=neek
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
