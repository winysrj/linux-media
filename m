Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:46294 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751691AbdH2UaN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 16:30:13 -0400
Date: Tue, 29 Aug 2017 22:30:11 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: julia.lawall@lip6.fr, jacmet@sunsite.dk, jglauber@cavium.com,
        david.daney@cavium.com, hans.verkuil@cisco.com, mchehab@kernel.org,
        awalls@md.metrocast.net, serjk@netup.ru, aospan@netup.ru,
        isely@pobox.com, ezequiel@vanguardiasur.com.ar,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 3/4] [media] radio-usb-si4713: make i2c_adapter const
Message-ID: <20170829203011.bguvpfhwy25tunik@ninjato>
References: <1503138855-585-1-git-send-email-bhumirks@gmail.com>
 <1503138855-585-4-git-send-email-bhumirks@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2mnm2vy4juijtydi"
Content-Disposition: inline
In-Reply-To: <1503138855-585-4-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--2mnm2vy4juijtydi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 19, 2017 at 04:04:14PM +0530, Bhumika Goyal wrote:
> Make this const as it is only used in a copy operation.
> Done using Coccinelle
>=20
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>

Acked-by: Wolfram Sang <wsa@the-dreams.de>


--2mnm2vy4juijtydi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlmlztMACgkQFA3kzBSg
KbZy/g/9GlBfjDDFLf7ggm474cJSylnCHfo15KFIkekoyydf6WLMMgdQjtRJHfYx
GvnEPh9DKM6vqw0jojZilJKwkk3GCYaqCUA19Z67TUyvM4b7ybvc+c/UNZXKbEqb
a1x41eYKujCqb6nlLQ8N2u7/qBEyRomyYxp3ajETs2V+TGKPdcPLhOmV/7R4sVAa
jrO/98vhKSL+3gMVISJZwOuckMTSdDJB53mtUXOzdAbVUgz8wEEOHFnad1ei0EUl
v4buCjn/FmeMEyVo/dExXAVtJN5CYk1TbV8EwsrNKsU+9mHkM/Pq38nWessJ/KmN
sxwshm7eBK5KWhf+Z7rib3WZsCJbRyiHMMDx83EHd5DFNpLXF94kbPAOgz9z9o3X
wvx0xZvrKvzmn4JXofTe9zWN29UM3uS1hBRGAnntWojd89bZVHBnKcgOGIk/ny6V
voGJ2mo6WN6A/mOiF5mdjxa/PwAPl6t08wXSDDZOoYW+xCvmEgHV0Vdxr3mou1vx
6BCsEZ8cmw2o51jRAx1DXQ7F3f468AULEcdS1S13WdQ1UUJP9w/YFyv7xAcV5Nbv
4oFHoJ5xBgtvd+LhwahJnygT8Zk71JsFquEUOGdTJMhnKLyyIzr5TgrWdRulZD3j
e6lIzytfHPE8s6llja0AxvxWqkgRfgHxM3d5MqmMJgvU9KOB/aE=
=XawK
-----END PGP SIGNATURE-----

--2mnm2vy4juijtydi--
