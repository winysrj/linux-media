Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:51030 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726465AbeGRNA3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jul 2018 09:00:29 -0400
Date: Wed, 18 Jul 2018 14:22:47 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Jacopo Mondi <jacopo@jmondi.org>
Cc: mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        sam@elite-embedded.com, jagan@amarulasolutions.com,
        festevam@gmail.com, pza@pengutronix.de,
        steve_longerbeam@mentor.com, hugues.fruchet@st.com,
        loic.poulain@linaro.org, daniel@zonque.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] media: ov5640: Fix timings setup code
Message-ID: <20180718122247.hpesu5sclolcfhfj@flea>
References: <1531912743-24767-1-git-send-email-jacopo@jmondi.org>
 <1531912743-24767-2-git-send-email-jacopo@jmondi.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="r72lywkuai6ow53h"
Content-Disposition: inline
In-Reply-To: <1531912743-24767-2-git-send-email-jacopo@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--r72lywkuai6ow53h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 18, 2018 at 01:19:02PM +0200, Jacopo Mondi wrote:
> As of:
> commit 476dec012f4c ("media: ov5640: Add horizontal and vertical totals")
> the timings parameters gets programmed separately from the static register
> values array.
>=20
> When changing capture mode, the vertical and horizontal totals gets inspe=
cted
> by the set_mode_exposure_calc() functions, and only later programmed with=
 the
> new values. This means exposure, light banding filter and shutter gain are
> calculated using the previous timings, and are thus not correct.
>=20
> Fix this by programming timings right after the static register value tab=
le
> has been sent to the sensor in the ov5640_load_regs() function.
>=20
> Fixes: 476dec012f4c ("media: ov5640: Add horizontal and vertical totals")
> Signed-off-by: Samuel Bobrowicz <sam@elite-embedded.com>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> Signed-off-by: Jacopo Mondi <jacopo@jmondi.org>
>=20
> ---
> This fix has been circulating around for quite some time now, in Maxime c=
lock
> tree patches, in Sam dropbox patches and in my latest MIPI fixes patches.
> While the rest of the series have not yet been accepted, there is general
> consensus this is an actual fix that has to be collected.
>=20
> I've slightly modified Sam's and Maxime's version I previously sent,
> programming timings directly in ov5640_load_regs() function.
> You can find Sam's previous version here:
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg131654.html
> and mine here, with an additional change that aimed to fix MIPI mode, whi=
ch
> I've left out in this version:
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg133422.html
>=20
> Sam, Maxime, I took the liberty of taking your Signed-off-by from the pre=
vious
> patch, as this was spotted by you first. Is this ok with you?

Yep, thanks!
Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--r72lywkuai6ow53h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAltPMRYACgkQ0rTAlCFN
r3RV3RAAmy3z2dlP6lj58X//+2ZXxtcpYNCcvTIsa3A4tIbBGBqhrsf9BwUErou8
jLhQGe9+gnitTSvRkLM7pSWDH2GCY5YCcQITFhkkX8cVq062KmKezOpASv6Y5u3l
bGxamgWLsGKsS0UZ8MJjVmYd7Rxg8dCmN1a1kKtCldZEdtPjAqiNkFC8cGldAeiy
PBsnZ7hPgEN0APeo+1gZN7FhoD/LZBUzEsCzbXA0hnIK1aif8W1ucDaQVQaCNJ+X
qlPPL27pm1wltjCO1xlcYBY9r0SsRLK6ROhh7TJNAtVYShCgHu21kam/M9KxDvJO
vY1dF4qMvjyVpiVsmfGIzEESxaUYxfBqCr9UV5LsWrQglMFOQgExcmu14xDo4h8h
0D8WAFQQI0aW2ni/K84BYX91YsWUquifZSJvNPVnagdgIqsrvkV4Ft9uA2o3V6zR
Lg59fTIsx5cYm2greInbd7ZxTKVIPfB+JV0m+hlFywdfcPERPxV+BfheQDyJJjHR
w4CDL19IRI1+WqXH0ttYpt3W4eXIS1VI0sv/ahIntLRuwimSFkROp41jOvbllpju
h7aVSeZp6hhMELj8zYNkr5pGCYQ2TQD0ikv99vfWbdWjhFN8W1K3p4wGspm8i6R4
qXC2vTsEoRZMl9dJT8yE/ezii45cN6J2heWEmo+fFvzMxNysOYo=
=gGcm
-----END PGP SIGNATURE-----

--r72lywkuai6ow53h--
