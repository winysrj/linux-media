Return-path: <linux-media-owner@vger.kernel.org>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35307 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756459Ab2FTO1f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jun 2012 10:27:35 -0400
Date: Wed, 20 Jun 2012 15:27:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
	javier Martin <javier.martin@vista-silicon.com>,
	fabio.estevam@freescale.com, dirk.behme@googlemail.com,
	r.schwebel@pengutronix.de, kernel@pengutronix.de,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [RFC] Support for 'Coda' video codec IP.
Message-ID: <20120620142733.GQ3978@opensource.wolfsonmicro.com>
References: <1340115094-859-1-git-send-email-javier.martin@vista-silicon.com>
 <20120619181717.GE28394@pengutronix.de>
 <CACKLOr1zCp2NfLjBrHjtXpmsFMHqhoHFPpghN=Tyf3YAcyRrYg@mail.gmail.com>
 <20120620090126.GO28394@pengutronix.de>
 <20120620100015.GA30243@sirena.org.uk>
 <20120620130941.GB2253@S2101-09.ap.freescale.net>
 <20120620133148.GP3978@opensource.wolfsonmicro.com>
 <20120620135633.GA2513@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aNvCJ41Feu8IgPyB"
Content-Disposition: inline
In-Reply-To: <20120620135633.GA2513@S2101-09.ap.freescale.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--aNvCJ41Feu8IgPyB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 20, 2012 at 09:56:37PM +0800, Shawn Guo wrote:
> On Wed, Jun 20, 2012 at 02:31:48PM +0100, Mark Brown wrote:

> > Moving to irqdomain without DT is really very easy, you just need to
> > select a legacy mapping if a base is provided and otherwise all the code
> > is identical - it just comes down to a field in platform data and an if
> > statement.

> Yeah, but I guess what I'm saying is *linear* irqdomain.

Sure, but like I say the only code change required for keeping platform
data working is the three lines or so required to change to a legacy
mapping if you've got an irq_base.  All my development systems currently
use linear domains for several of the IRQ domains on a totally non-DT
system.

--aNvCJ41Feu8IgPyB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4d1hAAoJEBus8iNuMP3dFmYQAIwq9dnpARPXcJiL9RwP3T1Z
zgwHNLMS+fw5+o3dqBX8z70LhDcq+Zp1Bduy6rZfFTOAfWDMiigNcTJWwyAEOY7B
P4A15A/mQ6Hp6MVYVBDo+ZUR4aR4A1a3NKFkpTvP3R9Avlk23meEX/odVhN/0aHp
KbYhkIsQ/QQcmv1Lv1Lfcn5oy+Qj6ZgEHuSFy18DrD9+JlHWQE5nMzDWX2+4RKRl
yqjWGHXJYDPr0/HR/bTEuZHkjOh8EX9ocCS/p0hbMzaynmkxhGDdm9DeykAY26EN
PAbFhq6+L/WY7RBtJ7L9MnE2WFPcoiSjFD8PQIucB7ipljeh0ZvHKa9UqR3IzKwo
IRrOq+P5I/xdGl3TVYHGr+06lJUBTc3aAFv1GN1WQ8V4LVEPTkoZsfto3Eaf015Z
F6InNDNa4Rfoa3nAJ4hr7Bh36aEEAtD6vo2Z4sjuQEYTM1Up9Tu73PREPqSnWwKy
zVT2v/Z70tgNawnY8f1izV4Hvg3jN5IwvSZ53oMgeDUliGw0RrZhflV4np/32MR8
SVG9usIZAEkkYdpSWTCOJcN9JluG75mIpPa4vvl93k+0/iSW9GtdwFaHT+7iiRM/
Jcyu36UE7oQm3knj81jbfQ4RxLsEH/5JNOhX3+eUJrCn5hgE5jNI05SUaVcvfI1z
klVYOsOC2Et3z6la5dPZ
=ECmb
-----END PGP SIGNATURE-----

--aNvCJ41Feu8IgPyB--
