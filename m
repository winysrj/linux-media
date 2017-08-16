Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:56666 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751605AbdHPQGc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 12:06:32 -0400
Date: Wed, 16 Aug 2017 18:06:29 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        linux-iio@vger.kernel.org,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/4] i2c: add helpers to ease DMA handling
Message-ID: <20170816160628.nlthmtgusg3qtkkh@ninjato>
References: <20170718102339.28726-1-wsa+renesas@sang-engineering.com>
 <20170718102339.28726-2-wsa+renesas@sang-engineering.com>
 <CAMuHMdUiVH5FarZLaJ=_aon2LOApoTgH6aZomjS3BgcdCcPY7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nsrjp7y3b3zb64fa"
Content-Disposition: inline
In-Reply-To: <CAMuHMdUiVH5FarZLaJ=_aon2LOApoTgH6aZomjS3BgcdCcPY7Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nsrjp7y3b3zb64fa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Right:
>=20
> drivers/i2c/i2c-core-base.c:2310:15: error: 'i2c_release_bounce_buf'
> undeclared here (not in a function)
>  EXPORT_SYMBOL_GPL(i2c_release_bounce_buf);

Thanks. I am just now working on V4 currently which is a redesign.
I'll write more in an hour or so.


--nsrjp7y3b3zb64fa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlmUbYEACgkQFA3kzBSg
Kba39g//X32uCcGGCEPDlgr0TB3ouPKuyEiPphMokvbPgcxxwlOnZWfsbo5wP2aN
WdiDI99ElKtFO/o4/bD39yvteWVR6Twp3z+kvbqXfUzP/2WMQOb5vU6VhnqmLjyl
0sClEEnfFsmmzJakIx7f+Vbh719MQpR2JM6UZ9SzYZ34fQqfPQRa40bg7zdX4CaU
+6lDv8195SmlSIdLZf0vjo8YAfRUHYd9ptCVeld+Kp9D+rZSugGjOWXyUnZDpjvR
Gq9jf/ZLwWJDl04mIR8kcRtmDJzp7gYMtJua042T7I+qzE3NU86RUGKnbyagB5p+
o+MRouHQjNaBqP9xTfkdqjg1DqHR87KJ299hAOFmzIQMFBjgCjNNf3HkttZij9o9
40HPj2ox45uzCoxJ8wTxEqyxUW+DIKI2fZTE37yGH46MhchKyl2FflpYAHFF+twA
RGuBea1GtBHgghamk94W+lfVKR1Wl+iCCkAZU26mzus0ahH3SvJ/xeHRGFHFDlJ4
LV731GUhReuNJWUjQcRuAepU7/6wUZxwthOgKpyQBdeu0IPCYfPGMD3dnHjorosc
45s7GuEpczxurtbv/r+ldha9bj8MYcRi11N/YRNleQp8HLmazZPu9oMHeXNQp7yi
1zs0o71HwZlKLpur3/ALHH5JLgbuOyPHfN4io2MrLI1oyvLWs30=
=WI+Q
-----END PGP SIGNATURE-----

--nsrjp7y3b3zb64fa--
