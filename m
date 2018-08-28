Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:50329 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727176AbeH1Src (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Aug 2018 14:47:32 -0400
Date: Tue, 28 Aug 2018 16:55:17 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v8 7/8] ARM: dts: sun8i-a33: Add Video Engine and
 reserved memory nodes
Message-ID: <20180828145517.p2ijrsfu576xwf7t@flea>
References: <20180828073424.30247-1-paul.kocialkowski@bootlin.com>
 <20180828073424.30247-8-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fbdscder4rhklhjs"
Content-Disposition: inline
In-Reply-To: <20180828073424.30247-8-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--fbdscder4rhklhjs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 28, 2018 at 09:34:23AM +0200, Paul Kocialkowski wrote:
> This adds nodes for the Video Engine and the associated reserved memory
> for the A33. Up to 96 MiB of memory are dedicated to the CMA pool.
>=20
> The VPU can only map the first 256 MiB of DRAM, so the reserved memory
> pool has to be located in that area. Following Allwinner's decision in
> downstream software, the last 96 MiB of the first 256 MiB of RAM are
> reserved for this purpose.
>=20
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--fbdscder4rhklhjs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAluFYlQACgkQ0rTAlCFN
r3TMPw//eoo4xqYQREx1gDmx1S9VTiUHhbA/6nKaTcvIkks7WWn7Lt2Ygmaf9c8s
DXFu2i8QUctdlcP0MLO7Tq8+jWkaJ9KVdhERypSQ8bdLxVnKqxCAQFlPkrnZOvIH
9ZdGhMuCdjZn2lFEP9MLoTgj83l54n7Swwv/yhCK1npfLyhrPls3OS2Ea/519aOw
tCdkrZtkGKFq9mF+J1dJ0H9WGaqCQ/wND0H2W//N9FaKg30eqV48oUGLzRAMgY1u
tGmsNTzc3Joa+yLnDlZehbrcmv+yu33frgWtdPB+wBXKftZ129XD32NkaFqou3Yw
l6EYptSSvFxI5UnrirKegts59NP6zRth1xzM2pPjnb2Fm9sY4s/HpQ04T57YhUAq
Kc5VBMU3LWtmoQg6szf6Nws5S8IN23VAW8i3TIof0mNFahgRDUVvdtJDMboUvkna
M6npW9Hf8EDEOjmp1sGFORhoWhiKNVF4duuwkRXMFx4RjCSY3ri4cDEFx/BrKFx2
2zROchTBpR+RVACcQSVtzNWjbrATZidAhafQALWu4DJNV+IYAHF+uRsVIDDJomgI
HsDn/z3OlLaPV25sqh2+Bsw+NJ7O4fkyxMno0R+43LvaeQaNBELdN9riIs4mxhTU
wBMx7Nu7zyNVwDCsIlS3tNmFxYzE0u6GqdmS0UUbaK4IUmmyOVI=
=vYN0
-----END PGP SIGNATURE-----

--fbdscder4rhklhjs--
