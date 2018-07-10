Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:41888 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932998AbeGJNCt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 09:02:49 -0400
Date: Tue, 10 Jul 2018 15:02:47 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        linux-i2c@vger.kernel.org, Peter Rosin <peda@axentia.se>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH -next v3 1/2] i2c: add SCCB helpers
Message-ID: <20180710130247.grmrxl4srctpyygg@ninjato>
References: <1531150874-4595-1-git-send-email-akinobu.mita@gmail.com>
 <5320256.KVvq6sUnyz@avalon>
 <20180710120747.s7yg36moaw2xsrim@tetsubishi>
 <30027540.g4E5J49NzT@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jv5cd4m6y3lbgcon"
Content-Disposition: inline
In-Reply-To: <30027540.g4E5J49NzT@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--jv5cd4m6y3lbgcon
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> even when not used. I think it will also cause the compiler to emit warni=
ngs=20
> for unused functions. I don't think that's a good idea.

Where is my brown paper bag? :/

> > But if you insist on drivers/i2c/i2c-sccb.c, then it should be a
> > seperate module, I'd think?
>=20
> Given how small the functions are, I wouldn't request that, as it would=
=20
> introduce another Kconfig symbol, but I'm not opposed to such a new modul=
e=20
> either.

OK, let's keep it simple for now and introduce
drivers/i2c/i2c-core-sccb.c and link it into the core module. It can
still be factored out later if the need arises.


--jv5cd4m6y3lbgcon
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAltErnMACgkQFA3kzBSg
KbbTdxAAjLgO10sgxo6bf3sRh5o6ybrsWqkyGYoAzBXDBeB22wQNILQ3bOeK/VK/
eSgOXLRqWxS8HVwUHlNvFKxiew8L+XM0IIwu4WndNK0Owz9YBehzbInsvJUCkA8x
28hHtcp77BnfZ/C2IeYw7mv9aOpi30icVln59ypYu/4IEnwT0cMOM10DYzhGd4aU
NvwgLEIWWs9N/HEMH8wFQGUxR6uOUpSCrDagMMe2A9G/ZqOSvoOXKdNxn3Pgy6+o
iw/lJiSfV5ty39q72RqLJYYFGOfIE7Pq4q9Xkwo/Nd2tHdM2HEKVJG1E/vhYr4cQ
fRo8SRaTcSmeqLpUS7PDloFweR3DGYPqeFnBZMGkjJpwOe4n99aW5loShTkNx/e1
B4AarT2X1aRbWTebP70vuRwXESbbZW9HNsQfjap4ZXdn6VnnsPueFUAvGO1Y5dYO
UR80AM5bts1hEy9005vRADJENFHjRG8j/ACD6uzn4Mbt3fgh1ywULxggmEU38UKG
+5vTmqYA2frSdkvtdGKp2tfic1k7AXJAORxbWMiWz3G9mcqHfOkhwwI68qoq3uYy
65bDHjalwM+snXoeV/bOeb96zMaZoQBCC4IqOUzHLs/EeRuEJVjv9rY/Mefvxrr7
iPgbIDjWhJ2pTeeZu6NclC5zqCqy3XFBxj5YsZtwwgt0VcrwOBo=
=uzr3
-----END PGP SIGNATURE-----

--jv5cd4m6y3lbgcon--
