Return-path: <linux-media-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43848 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590AbaLVMo2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Dec 2014 07:44:28 -0500
Date: Mon, 22 Dec 2014 12:44:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <20141222124411.GK17800@sirena.org.uk>
References: <1419114892-4550-1-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/0P/MvzTfyTu5j9Q"
Content-Disposition: inline
In-Reply-To: <1419114892-4550-1-git-send-email-crope@iki.fi>
Subject: Re: [PATCHv2 1/2] regmap: add configurable lock class key for lockdep
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--/0P/MvzTfyTu5j9Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 21, 2014 at 12:34:51AM +0200, Antti Palosaari wrote:
> Lockdep validator complains recursive locking and deadlock when two
> different regmap instances are called in a nested order, as regmap
> groups locks by default. That happens easily for example when both

I don't know what "regmap groups locks by default" means.

> I2C client and I2C adapter are using regmap. As a solution, add
> configuration option to pass custom lock class key for lockdep
> validator.

Why is this configurable, how would a device know if the system it is in
needs a custom locking class and can safely use one?

--/0P/MvzTfyTu5j9Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmBIbAAoJECTWi3JdVIfQlgEH/2gAPhy2lxOwQuk+8T8KVqgF
45hSaBX6xoHcSqg9vzQlbUXpDUGJAB1/CWni4NZ0jR32GRcntzP4QtdkolLS6SuU
iQhqnSgPz3DTZfjOBvqKwg0UvZxrTJ843t8w6yFfXBxYDaWcMzofXwaHRDPU1mml
XUmFPsSmXv0hFbSc4kgkT6IrrMKw8ZD2gs9h2av0PjeMpw65LAhEaUMpkmPRWiT0
82u8YQ2sBGdUXd3DRPws092Hp6r2PQQeA4ZonL65blebwRE5e9uoUFdblcN87K3g
bWaTUs/lOj6SqFShwW4LDKYsKrLhXjfmnAtPodaeuJWDadPQGqFUTSpZXvamJZM=
=Z9y7
-----END PGP SIGNATURE-----

--/0P/MvzTfyTu5j9Q--
