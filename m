Return-path: <linux-media-owner@vger.kernel.org>
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:49146 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755817AbeDWQwX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 12:52:23 -0400
Date: Mon, 23 Apr 2018 17:52:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Tim Harvey <tharvey@gateworks.com>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux-ALSA <alsa-devel@alsa-project.org>,
        linux-kernel@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3][RESEND] media: i2c: tda1997: replace codec to
 component
Message-ID: <20180423165213.GL19834@sirena.org.uk>
References: <87in8ibrql.wl%kuninori.morimoto.gx@renesas.com>
 <CAJ+vNU0mykhkMNNrN=Zsrj0_pv=XAkGiiQkXehQ4EWBkMDAv7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="j3olVFx0FsM75XyV"
Content-Disposition: inline
In-Reply-To: <CAJ+vNU0mykhkMNNrN=Zsrj0_pv=XAkGiiQkXehQ4EWBkMDAv7w@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--j3olVFx0FsM75XyV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 23, 2018 at 09:44:17AM -0700, Tim Harvey wrote:

> Could you add some detail to the commit explaining why we need to
> replace codec to component? I don't really know what that means.
> Please refer to a commit if the ASoC API is changing in some way we
> need to catch up with.

This is a big transition in the ASoC API which is nearing completion -
this driver is one of the last users of the CODEC struct, we've (well,
mainly Morimoto-san) been migrating things away from it to the more
general purpose component.  There's no one commit to point at really as
the two have coexisted for a while and we won't be able to finally
remove the CODEC struct until all the drivers have transitioned away.

--j3olVFx0FsM75XyV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlreDzwACgkQJNaLcl1U
h9CzuQf/XTA4TBCShZRcP3dqce97snUUGdPY5Fg1PGcBp+xBKuvkQKLhe5iHy35e
kIqtbo2Ha2R9uFIJNnlZOcYzgCtFtmtI4Q3ezLFxXSMudRtkTifvxA11Yi13WBTL
Es1KQlJa7S2fGQSZHM2A2TD/othnmD7iIE4R3wlvSdJ4dbte4x4SJNmLBRnJtDCt
1SPMLmIh3kzQaU7zOqdm31roaHT/2j08HyB1VttyqJ520sIEXcAuw79b4NnzdeH2
DDiVBJh4++sOSa4LvIYlXf74Tr6li0gO5hmkeZj83GORA/Cgw/tSmGW08RjpK2YP
4vV0Jl+ZA45c4+b8uIzyQWVRERA1Cw==
=BeVd
-----END PGP SIGNATURE-----

--j3olVFx0FsM75XyV--
