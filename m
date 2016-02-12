Return-path: <linux-media-owner@vger.kernel.org>
Received: from 85.76.238.89.in-addr.arpa.manitu.net ([89.238.76.85]:33094 "EHLO
	pokefinder.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbcBLWWP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 17:22:15 -0500
Date: Fri, 12 Feb 2016 23:22:09 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-i2c@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
	Tony Lindgren <tony@atomide.com>
Subject: Re: tvp5150 regression after commit 9f924169c035
Message-ID: <20160212222208.GD1529@katana>
References: <56B204CB.60602@osg.samsung.com>
 <20160208105417.GD2220@tetsubishi>
 <56BE57FC.3020407@osg.samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M38YqGLZlgb6RLPS"
Content-Disposition: inline
In-Reply-To: <56BE57FC.3020407@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--M38YqGLZlgb6RLPS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> I'm adding Tony Lindgren to the cc list as well since he is the OMAP
> maintainer and I see that has struggled lately with runtime PM issues
> so maybe he has more ideas.

Good idea. Did you try his patch which is in my for-current branch
("i2c: omap: Fix PM regression with deferred probe for
pm_runtime_reinit")?


--M38YqGLZlgb6RLPS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWvlsQAAoJEBQN5MwUoCm2lfAP/ibPbFrUBjw11FYq7WHnx3ER
S0pkaLw3pKz5yq6j8xiVKBFaK5bgTXqusLNT8GYe3Mv62VdQj0ii5ibm9Q6EjO73
eN6JNyHdoqFgK7whvL+eFqQY70ZH99H0BLE4EJCwrFI/Mbh6EWtot/IkPEw985OO
D/NrMp36ZxRcqS+feMTzyTzjR8a1jg9rQPhJJM4+jhIi8oFtc5GbFt54jHtTmWk4
/011y391j6bgRx6yVMEJyxpe23bUPOqIiyC7ETrzlgxhgsTeSDFHINDpFtDfezfD
pZQSG7stvq5x4em+NEKcdKlmXSVkP7Q+hppNO7BXFoHBBZZjLM2mr7yB6hKKG2dr
Ug6HS0Nb+wWHYfh6a+pBDEo8rStlSp6kL05aTgQOBSilApzg6bYsqLEn7YS4sHrQ
cdlL32Hu17TgS0+CqfevTl3w5XbuxbWHZu4DssEP5zNVKtMeD5zlbMm0+XWNvwb6
EdJyYH58He1FHLTTwpp7vQnkBsLgjI8SpQn1vnkQC9GAE7oSAtrcizYspKUYv+XJ
utjiTeJtdnM9VEjcJN6Q1FhhHa/am9LPIYJTjk4LO8Dye7Wyf7KL4pNVowENRtOM
Dm9AmJYB3LvKTISFKpg6FnF6fyupF0ISS1j0B2aqDFExIa8nTwOtdUoQ0xtjruyl
Ns21y451F5NZstM6h6g8
=BMRY
-----END PGP SIGNATURE-----

--M38YqGLZlgb6RLPS--
