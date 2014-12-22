Return-path: <linux-media-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44078 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067AbaLVPc2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Dec 2014 10:32:28 -0500
Date: Mon, 22 Dec 2014 15:32:03 +0000
From: Mark Brown <broonie@kernel.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <20141222153203.GZ17800@sirena.org.uk>
References: <1419114892-4550-1-git-send-email-crope@iki.fi>
 <20141222124411.GK17800@sirena.org.uk>
 <549814BB.3040808@iki.fi>
 <20141222133142.GM17800@sirena.org.uk>
 <20141222122319.4eefacb3@concha.lan.sisa.samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ix2jQZQ3wXOip0b1"
Content-Disposition: inline
In-Reply-To: <20141222122319.4eefacb3@concha.lan.sisa.samsung.com>
Subject: Re: [PATCHv2 1/2] regmap: add configurable lock class key for lockdep
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Ix2jQZQ3wXOip0b1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 22, 2014 at 12:23:19PM -0200, Mauro Carvalho Chehab wrote:

> What this patch does is to offer a way for drivers B and C to define
> different mutex groups (e. g. different mutex "IDs") that will teach
> the lockdep code to threat regmap mutex on drivers B and C as different
> mutexes.

> I hope the above explanation helps.

No, not really - even the best explanation on the mailing list isn't
going to make the commit clearer (something like this needs to be at
least clear in the commit log and ideally the code) and it'd be much
better if the interface were improved so it's obvious that users are
doing the right thing when they use it.

--Ix2jQZQ3wXOip0b1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmDlyAAoJECTWi3JdVIfQNN4H/j4cKHgqK4WxWpGRwY0fXPSE
2mIjU+uD8GqOdyfNtz61TiR+HEOsYEZXfFLGNhaNrSbGT4se0N1OFXEmQxh997IK
vYuqFVm3gF9S5UtXojlayg5sqi6iY96sZRMOui1jZeNuni2YDE/k4LqIdSXGA7Ap
JHOhE+tXo0Ivlgw5Ac50gof1dwsyqS0wQo805c228G9wk/yAcV47EC7bkh/IxCTj
3Uyi8cO4n2BILZ0+YnYExxZDfAJn6skx2eFc8y2CF7yqyBAcrLaPpT8NruU9UlnR
Bg9hBCqmk86+B6EtSq7vUUc7B663bqvmwZopkE4LeOI8QveWu3igI5VXc9UtAaQ=
=nxue
-----END PGP SIGNATURE-----

--Ix2jQZQ3wXOip0b1--
