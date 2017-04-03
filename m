Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:48498 "EHLO mail.zeus03.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752270AbdDCK1Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Apr 2017 06:27:25 -0400
Date: Mon, 3 Apr 2017 12:27:23 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Peter Rosin <peda@axentia.se>
Cc: linux-kernel@vger.kernel.org,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-i2c@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 0/9] Unify i2c_mux_add_adapter error reporting
Message-ID: <20170403102722.GB2750@katana>
References: <1491208718-32068-1-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CUfgB8w4ZwR/yMy5"
Content-Disposition: inline
In-Reply-To: <1491208718-32068-1-git-send-email-peda@axentia.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--CUfgB8w4ZwR/yMy5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 03, 2017 at 10:38:29AM +0200, Peter Rosin wrote:
> Hi!
>=20
> Many users of the i2c_mux_add_adapter interface log a message
> on failure, but the function already logs such a message. One
> or two of those users actually add more information than already
> provided by the central failure message.
>=20
> So, first fix the central error reporting to provide as much
> information as any current user, and then remove the surplus
> error reporting at the call sites.

Yes, I like.

Reviewed-by: Wolfram Sang <wsa@the-dreams.de>


--CUfgB8w4ZwR/yMy5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJY4iOKAAoJEBQN5MwUoCm2wg0P/3JCuM7Z98JlCLi1IsO64z+z
mR+FRXYt+yHhH+RRNxJyCSD8O4nf/EietPa0WofCtLJ3c2ARZ0CWKqGcn1qngdY6
sbIW4C0L4Q7xiPp0UblgiUDCMCtCRe+FXEMVyLR6577uTGA4LkK4JoIhjgO4KGTF
4hwXyzBmQb/jgU4oQ6PrVFy5WqM1Xe4hFUoO0FyAvdNDcbsa4F9Ro7MreZjGXa8I
fsrATdx+Mlgp4gB9iN5JTKP1dOMmv5a3HeM+KuG6bHuP40Li3RwCZUNlK52S/oDQ
hvMshqK43PJPlvpq/GperEe8m0N1j6WfeGfPzwmEvhXsmAsYGS2kl8fcplcryG4t
A+Q0ivfRD2D/x9ElHI9VUnqXi+RrtXJeJd7o9sVKTbQz5xowwIRwHyF9YmA7BE0U
7PzazArDZBxDLK+jxCBq5NchLSf6E1OETBy+tlE0dk/wwUf84hiF/fXkbAEceNlI
i2KM27EOilE4Mt4nScUycw92vEZN9h0uVrcvIAjyzle1GxDNe8rVTowf7YFPVRkN
rVVhJrfdOhB43FBgvPaY5TZXTrFQhcPlgjMLSI8ZurU9CGcLrcEK8EYnUIFDLVuQ
KX+ybgdJo1/LybV7dWKYB6fd0PqVB7S+7zynXP5l+ukAXRmgCDcwuaziQJgcrmF9
M+9wQ6P9OnJG+Qd/VBW6
=/LhN
-----END PGP SIGNATURE-----

--CUfgB8w4ZwR/yMy5--
