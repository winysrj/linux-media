Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36152 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529AbbDPQ3k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2015 12:29:40 -0400
Date: Thu, 16 Apr 2015 18:29:06 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-leds@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v8 1/1] media: i2c/adp1653: Devicetree support for adp1653
Message-ID: <20150416162905.GA3181@earth>
References: <1429141034-29237-1-git-send-email-sakari.ailus@iki.fi>
 <20150416052442.GA31095@earth>
 <20150416055817.GA2749@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <20150416055817.GA2749@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pavel,

On Thu, Apr 16, 2015 at 07:58:18AM +0200, Pavel Machek wrote:
> On Thu 2015-04-16 07:24:42, Sebastian Reichel wrote:
> > Hi Sakari,
> >=20
> > Since this driver won't make it into 4.1 anyways, I have one more
> > comment:
>=20
> Like this driver did not receive enough bikesheding.

You should become more restrained with this argument if
you want it to be taken seriously by me in the future...

> > > +	} else {
> > > +		gpiod_set_value(flash->platform_data->enable_gpio, on);
> > > +		if (on)
> > > +			/* Some delay is apparently required. */
> > > +			udelay(20);
> > > +	}
> >=20
> > I suggest to remove the power callback from platform data. Instead
> > you can require to setup a gpiod lookup table in the boardcode, if
> > platform data based initialization is used (see for example si4713
> > initialization in board-rx51-periphals.c).
> >=20
> > This will reduce complexity in the driver and should be fairly easy
> > to implement, since there is no adp1653 platform code user in the
> > mainline kernel anyways.
>=20
> I'd hate to break out of tree users for very little gain.

This normally happens as the kernel progresses. If you want your
driver not to break, you should sent it upstream and maintain it.
Also the only out-of-tree user I know is the Nokia N900 (which has
already broken camera subsystem). Note that the required out of tree
changes to use the platform code with gpiod interface are actually
quite small and if you really care about it, they could actually be
done *in kernel*.

Note that many drivers are updated to use new kernel APIs together
with the DT changes - especially those, which haven't been updated
for quite some time.

So let's have a look at the advantages of removing the power gpio:

 + gpio handling is always done in the driver, making code
   easier to read
 + less loc in the driver, making it easier to read
 + less loc in the boardcode (no gpio requesting/releasing)
 + less branching in driver code - easier testing coverage
 - out of tree users will break

So basically its code quality vs minor out-of-tree breakage.

-- Sebastian

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJVL+NPAAoJENju1/PIO/qaCkgP+wRFedHH49l4MJkEoo9itGAP
+7y4otju5bFsuPJCGUAOwpsmIRrNqkz2F8Rb2kKVkuwSnnFhv9ltkuR077b1WjCT
9R9rE7jiiLLDOkjmQTd70q/TEigDDu7w2Apk5WoNHYtPIG9gtAMlZiW0x/WL2JzO
05e7Kf8AX0+gkp3tDc6autji+INAiVEHPrQ/L3R0ohVWJxKv5992znGF/iCnb1uP
/3i+glksApTHesMlfRkNaEndlOgZ/u9dKBO0gH8xQToTzNvZgLPL4Ims1ExkC3kd
cg/h26h7YIRI47oebrIcCYGvOv+f1Ioxd0dim0ngUmHSycVU/bSncRcDRC0rSBkD
zBeTFv6od9/wDKjMvpqgzukm0cD4G3UGT9mB9qGG9LCpxd6ytJ49p4dNJbFs63bj
pjgtiWeY4CZ90PUPg+U4TBYxhLjaQ3ikjgPbv5x9ObYpblJiDXjfc5cdBGxnP+45
zXlJChgLcPBPT/zvp04hZRDg3tDcJV3h4zlf234gSO8vpyAS1y4v5cSmRVSuC0Cu
M2cEsq49+0OiytDBHVoS7Uclxp+WrsM0Cd3PeHuP1E/gby4BA0EGsGbc3MWz1cDi
fm5nQZa5t0SS8x2dTAs8IC9uYtx2+ntN7IEijTaI03u1qeZ6w7+zuVAAmKn/8oHe
uEKImql8BtlxuWzSLUKc
=gzfH
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
