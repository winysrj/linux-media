Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:48058 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbeGSJYO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jul 2018 05:24:14 -0400
Date: Thu, 19 Jul 2018 10:42:08 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, Peter Rosin <peda@axentia.se>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH -next v4 2/3] media: ov772x: use SCCB regmap
Message-ID: <20180719084208.4zdwt4vzcop4hve7@ninjato>
References: <1531756070-8560-1-git-send-email-akinobu.mita@gmail.com>
 <1531756070-8560-3-git-send-email-akinobu.mita@gmail.com>
 <20180719074736.GA6784@w540>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xqqiw3duga2s5vfo"
Content-Disposition: inline
In-Reply-To: <20180719074736.GA6784@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--xqqiw3duga2s5vfo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > -static int ov772x_mask_set(struct i2c_client *client, u8  command, u8 =
 mask,
> > -			   u8  set)
> > -{
> > -	s32 val =3D ov772x_read(client, command);
> > -
> > -	if (val < 0)
> > -		return val;
> > -
> > -	val &=3D ~mask;
> > -	val |=3D set & mask;
> > -
> > -	return ov772x_write(client, command, val);
> > -}
> > -
>=20
> If I were you I would have kept these functions and wrapped the regmap
> operations there. This is not an issue though if you prefer it this
> way :)

I have suggested this way. It is not a show stopper issue, but I still
like this version better.


--xqqiw3duga2s5vfo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAltQTtwACgkQFA3kzBSg
KbZm3hAAls6hfbYwOifr2nw8YSVbwvRvWoJCrCVAPSWRjj97xNGAe21G1dXK3yU3
7jlwJbm96jA7YZWdPkxJUxha37b5fThlFVHZ7nNFlivied42SIySrGZGUKH02yNV
a409+mGUGe5PAvGwO0/v7snWT5jmuRi84o5PUMUC/jLAOtHONEbOrgz81L3YBgpq
bcjJFy5ZkoWZXbZk3AhEEWCC4rcBIw3pWhLm57/sI/Q+FiqO+a8io02qHhjF7/eS
G62GBO09Ces+xtaIdmcaGzIP+4JvGy0nEjy6JmKWy0E6ryg1DI02X8lJVKFVpW9z
0IXS0PriwXzq6uWgh7qbP8R7oCPtXi2LEedJWc9IBWk3VOoQGkszbHwCakSb9tEA
3xSl+/W0pWVS6o1wWDQJpRPLzY2Hkfdp1CKth5oITsPCLyB36XnRAaVEqbeQ5FmX
FdLbo7CXLyilZwazuyAYN/15+CbglKbNtAZUZMdgn7jvtN4LHUUFivIp7WAHRGUZ
0m/4JKcEDxFajrPwl9BDaDgUB9l7B1GwnkhcI+RYsJHMxFD/Hz5Sc+DNgUE2cb37
hfGuCp5W77b7EC6vyPaj5gzdY6Q+OXPSwBPjjhUVS4mpla7XL/kMW/neGZzN3Gnh
95NhY9twI4pEjGx/j1J6Fk23UNrk5MCpUmCXb4epIwDtkMKWZCY=
=e06+
-----END PGP SIGNATURE-----

--xqqiw3duga2s5vfo--
