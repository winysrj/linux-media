Return-path: <linux-media-owner@vger.kernel.org>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60086 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751284Ab2FTNbv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jun 2012 09:31:51 -0400
Date: Wed, 20 Jun 2012 14:31:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
	javier Martin <javier.martin@vista-silicon.com>,
	fabio.estevam@freescale.com, dirk.behme@googlemail.com,
	r.schwebel@pengutronix.de, kernel@pengutronix.de,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [RFC] Support for 'Coda' video codec IP.
Message-ID: <20120620133148.GP3978@opensource.wolfsonmicro.com>
References: <1340115094-859-1-git-send-email-javier.martin@vista-silicon.com>
 <20120619181717.GE28394@pengutronix.de>
 <CACKLOr1zCp2NfLjBrHjtXpmsFMHqhoHFPpghN=Tyf3YAcyRrYg@mail.gmail.com>
 <20120620090126.GO28394@pengutronix.de>
 <20120620100015.GA30243@sirena.org.uk>
 <20120620130941.GB2253@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fjEAjMKpll6GDq3U"
Content-Disposition: inline
In-Reply-To: <20120620130941.GB2253@S2101-09.ap.freescale.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--fjEAjMKpll6GDq3U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 20, 2012 at 09:09:43PM +0800, Shawn Guo wrote:
> On Wed, Jun 20, 2012 at 11:00:15AM +0100, Mark Brown wrote:
> > The approach a lot of platforms have been taking is that it's OK to keep
> > on maintaining existing boards using board files (especially for trivial
> > things like adding new devices).

> I think that's the approach being taken during the transition to device
> tree.  But it's definitely a desirable thing to remove those board
> files with device tree support at some point, because not having non-DT
> users will ease platform maintenance and new feature adoption a lot
> easier, for example linear irqdomain.

Moving to irqdomain without DT is really very easy, you just need to
select a legacy mapping if a base is provided and otherwise all the code
is identical - it just comes down to a field in platform data and an if
statement.

--fjEAjMKpll6GDq3U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4dABAAoJEBus8iNuMP3dhfoP/RLNCTyUvi6PIkOuGDP8tcfX
70ZzGk3ZIMA44cfTs2EE5p3cXCnfcsU9wjDH+TaDDNJ8BMznK1niLNXIZUH7w1NS
mNgLOssCMHTSM5anW9FbWEAgyvZvod+x5RxI+wjds35vYmpMq4LmbSMhT2EpD6VB
z8GrDku90lgT+A/AKgcTS9rjrFSExE8iM/muE9Hu8idGo3bXB/NC6pWdsbsahzCv
0VsscHJmLX++gIYm6j1h9+goTFPkhL0HCc1SD+oFw+7GaCLIM1hO0Y41wonlTQxW
/7nADr0NzDfOT95JcFbqr1pPRfZuh7mmVBU40MwHrpl3A8EBUlpkQIgQXh4bkAbY
XAd/6RcPj26GzyCPDYohnpjCt4V/qQncQ2v5D2IoT7Slp60HggCzosQuMoxkWJGM
JIf6GY3gwcYPM1MCPOaF+RsUWMWEApUdZNIhrYekXyqTDtQP770XEgFye8G5yoKl
3cs0BeTPfSd2rVSeJ4Zrsk8NdhreROb0k8SWJw3PYUVmBfoIKawQPgJ2ydnWFW3g
Wd6RQIkBAT4emWhs6PuZ+qo6LNDRNzqnCp4cjkaC/Ah/zQZ+7fRuEXYqagI7EUvL
JKMGEuCfTuajKhmrKi27nrcNSm5UA7DPLx6VnDoEWqQ/iAFwXq3y/GM3BRFnmTft
YBHgKi/9zWOnltiSWn+B
=hCfS
-----END PGP SIGNATURE-----

--fjEAjMKpll6GDq3U--
