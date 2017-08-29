Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:46219 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750909AbdH2UWQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 16:22:16 -0400
Date: Tue, 29 Aug 2017 22:22:13 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: julia.lawall@lip6.fr, vz@mleia.com, slemieux.tyco@gmail.com,
        gxt@mprc.pku.edu.cn, mchehab@kernel.org, isely@pobox.com,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c: busses: make i2c_algorithm const
Message-ID: <20170829202213.senab5jhzebku4de@ninjato>
References: <1503072418-6887-1-git-send-email-bhumirks@gmail.com>
 <1503072418-6887-2-git-send-email-bhumirks@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="arnucy7svgqc4irn"
Content-Disposition: inline
In-Reply-To: <1503072418-6887-2-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--arnucy7svgqc4irn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 18, 2017 at 09:36:57PM +0530, Bhumika Goyal wrote:
> Make these const as they are only stored in the algo field of
> i2c_adapter structure, which is const.
>=20
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>

Applied to for-next, thanks!


--arnucy7svgqc4irn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlmlzPUACgkQFA3kzBSg
KbbdKA//amYhb0qzZGyQhNsHl/9/OCp3ZCxEQZFRgkZUpPmflwgTzJDjblb1l+eb
/qT9oO0TyhuWs7CMaSweV7pzUVAd4yiBfAwizQrnHrZ6M2oBnW7aiJjVrcoRopjN
7djcbBd4+VF0MJ+Ye+jnSbaSap/MsKEcTYR6IjBb4PyMOkCTL+SGMzF9s1Jt67Aw
vqEYakAFwo9qpDR1lCNBGPD5T918sxi/1zzPvcmPsKBKVNCw+SyvL9Eqdg53beqq
OhNIFaoSw3Uyl+ZamlNW5Ts5Tul0mX9y3oUTxacVz8ycIiJ1VtIoapFjCCQgRyxC
+aQSuoNnPPIUk0V4tYfyyS5HtRyVw2GhPc7OUjT/dc+7C034m6ClogJyou9crBSq
LuMCklzJfhJDcMz9knYoPUMKyNr+pVSEI1QKThelTUcWNshJN4rbjqh29eWGX8BB
jVuB8XTURqEwS+zROyN9QzYeGaj8AnzO9Djo+Zvmykq0GE84QVy8FASFTESNOUB+
MRxdECfAEuV3ICNHOtpyQkBtg4wgI5gLpc1yu4EGBxY6WfYr9YNaYpxPBLlspeq9
P9gwg7CmZchni96l23OJummKCrpn54eYoh7/HqunqElCY51HRmPRxzc+AQWl3nuL
0NNICxj0SVq/ePyoq56LGrjD6CbzNrlHXgZhiGVXId4lQybw5gY=
=9ttg
-----END PGP SIGNATURE-----

--arnucy7svgqc4irn--
