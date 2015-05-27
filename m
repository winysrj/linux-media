Return-path: <linux-media-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59308 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbbE0RsZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2015 13:48:25 -0400
Date: Wed, 27 May 2015 18:48:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: vinod.koul@intel.com, tony@atomide.com, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
	dmaengine@vger.kernel.org, linux-serial@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-spi@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Message-ID: <20150527174814.GJ21577@sirena.org.uk>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
 <1432646768-12532-12-git-send-email-peter.ujfalusi@ti.com>
 <20150526152730.GT21577@sirena.org.uk>
 <5565A740.2020707@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="9BaSWpvdCbxAh9tt"
Content-Disposition: inline
In-Reply-To: <5565A740.2020707@ti.com>
Subject: Re: [PATCH 11/13] spi: omap2-mcspi: Support for deferred probing
 when requesting DMA channels
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--9BaSWpvdCbxAh9tt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 27, 2015 at 02:15:12PM +0300, Peter Ujfalusi wrote:

> I have put the maintainers of the relevant subsystems as CC in the commit
> message and sent the series to all of the mailing lists. This series was
> touching 7 subsystems and I thought not spamming every maintainer with all the
> mails might be better.

You need to at least include people on the cover letter, otherwise
they'll have no idea what's going on.

--9BaSWpvdCbxAh9tt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJVZgNeAAoJECTWi3JdVIfQ+fQH/3RUAsyi76DjZZ0jvTPJTYNb
dEmuvdMbEj9fTeutH/6xnbGT95c8tLNOZ8Pmn436SwZJ08AHG+e4SqJ1Xl7Uu58q
DLb6ZCxjGRaLfMqXf6XxWsX4KF3kb5ZBNIK2QH6dqTWb3qptSxGvBhP4hzGEb0fV
FJzPl7QByw+m8e5LQK2mUW0on4ZWOT5/oNPSkWmGcTlTkpQeS1i1ZELcpd0zdsF1
jTQJwoGgvL5lNkuTfw807uB8v/mciRSDv9phV353E4ea6API0YP26k8jftTb2ex3
48E1xb2nzLGb/bt6D3wNO0GzidwQ4heN8J/1zmlLWMbX03UxtT6Pt2BYKGxF11M=
=UYw3
-----END PGP SIGNATURE-----

--9BaSWpvdCbxAh9tt--
