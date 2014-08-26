Return-path: <linux-media-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34381 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbaHZRWX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 13:22:23 -0400
Date: Tue, 26 Aug 2014 18:22:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, linaro-kernel@lists.linaro.org
Message-ID: <20140826172208.GM17528@sirena.org.uk>
References: <1409071130-22183-1-git-send-email-broonie@kernel.org>
 <53FCBC25.1090201@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AeiJxYKfOXay7u1k"
Content-Disposition: inline
In-Reply-To: <53FCBC25.1090201@xs4all.nl>
Subject: Re: [PATCH] [media] v4l2-pci-skeleton: Only build if PCI is available
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--AeiJxYKfOXay7u1k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 26, 2014 at 06:56:05PM +0200, Hans Verkuil wrote:
> Against which kernel is this? Documentation/video4linux/Makefile doesn't exist
> in either the mainline kernel or the media_tree git repo.

This is against -next, looks like the bug is in the Documentation
tree...

--AeiJxYKfOXay7u1k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/MI9AAoJELSic+t+oim9lmcP/1IhD0Dqbv9AG88qXJQJswbg
nhN8oy3ypO3KxvYTfWKZTeGtpc1Lt+UT+f9G5wk9kw2p1sl5KXiSB6ZvnmbiaqYT
IS0cFxVpWr5M034BOTrvAvsz9lQs7Fyhi9hZZgiJNweXC4mYQYDj3OLiDt5XMP+i
qSbdZd9j1LfSE1Mw4AG62li1fLqLvf+tQMAnSfOZ4VILXwHzLCVTgiHU9kA+cyTi
eelVvLLYtDScLQTY1R/mQiukDKl0c7UBSUiODdQaktci6f+G1+nQb60qIFLugFW5
HAGrMPIctn/1lPVG9ANGYgCoL+oRtx6RhKOWoWGGD+KLhgbfWSSM29jmxbkwU9gU
WV58eYDw3nKpM2mXYpgOfouKPZwasXDqER/yEtvbSTq7mjYtMiGkWTYbNtAkFcuL
2N7kKIuzdMEZyinvM4ySldY8rc3qq8bFToO9pC2SN6AnTrrlTENZemqaO+K2Z7zI
esiD5J3tLTPAlmxTlkNMaXVodcpa5++ZCX+id435d4iY5Ext5dWEZoz9yATGxMTM
Wy2+ta5YX35+4/xra+Kwm5fVWwXjHkq2UyEtCyaLsvzHh7ocPGHQReT5WQjlKsrL
1fGuJSerYhySp08DD4epXISScQ5fcYrf2lCsYMgphVu6k78miXyeMGDCJ0b5JGHc
eFmv8lAHbEu56jIdcfyl
=SYqK
-----END PGP SIGNATURE-----

--AeiJxYKfOXay7u1k--
