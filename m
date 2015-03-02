Return-path: <linux-media-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:32790 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401AbbCBR3e (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2015 12:29:34 -0500
Date: Mon, 2 Mar 2015 17:29:07 +0000
From: Mark Brown <broonie@kernel.org>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Message-ID: <20150302172907.GY21293@sirena.org.uk>
References: <20150302170538.GQ8656@n2100.arm.linux.org.uk>
 <E1YSTnc-0001Jo-1U@rmk-PC.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="dGUfJcSsJTvAEs5v"
Content-Disposition: inline
In-Reply-To: <E1YSTnc-0001Jo-1U@rmk-PC.arm.linux.org.uk>
Subject: Re: [PATCH 06/10] ASOC: migor: use clkdev_create()
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--dGUfJcSsJTvAEs5v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 02, 2015 at 05:06:32PM +0000, Russell King wrote:
> clkdev_create() is a shorter way to write clkdev_alloc() followed by
> clkdev_add().  Use this instead.

Acked-by: Mark Brown <broonie@kernel.org>

--dGUfJcSsJTvAEs5v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJU9J3iAAoJECTWi3JdVIfQ7BoH/R5IM/IP7qrjaa1F2hR+Sbe2
ONWg9C8xFm9DDPGnc5ZN9U785DvRVyrTXcC+08+nm0E1eTfEGzPR7lLs5T/QxmBx
1MEu/RYlNId1kegXtSOhzlq3p/QHaysXIJMsfguCRfWhBdtFDbHgkQ0t0rZ/o1MU
IqrP4m2RIFa8C9WARqD03mlEG19jlxLQ888+BJGD38yjbDTQX0qm2wokWfAfAti6
QWPjI/GhqxlVUN6Yig3xo7xNXvW/cqopxEW9rVbgT0dYbA53AmQFYkGQUWSi+fFp
9xRMVl5pYvfp2H3X16rQQk7v0N6inmvecqfNf6sRjfjpW2b6XbxFbKNzaxFZWds=
=m9hq
-----END PGP SIGNATURE-----

--dGUfJcSsJTvAEs5v--
