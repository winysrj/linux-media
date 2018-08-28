Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:50455 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726975AbeH1SsJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Aug 2018 14:48:09 -0400
Date: Tue, 28 Aug 2018 16:55:54 +0200
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
Subject: Re: [PATCH v8 5/8] ARM: dts: sun5i: Add Video Engine and reserved
 memory nodes
Message-ID: <20180828145554.vj3kewgdr7owxgn4@flea>
References: <20180828073424.30247-1-paul.kocialkowski@bootlin.com>
 <20180828073424.30247-6-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="e7ywqriiswgh6hjv"
Content-Disposition: inline
In-Reply-To: <20180828073424.30247-6-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--e7ywqriiswgh6hjv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 28, 2018 at 09:34:21AM +0200, Paul Kocialkowski wrote:
> This adds nodes for the Video Engine and the associated reserved memory
> for sun5i-based platforms. Up to 96 MiB of memory are dedicated to the
> CMA pool.
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

--e7ywqriiswgh6hjv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAluFYnkACgkQ0rTAlCFN
r3Svkw/+Mz7I4ofIU/zEqWp7wQJL4CaL4whSEPvKJnMvDHIiGEx82KmhxaMCwoZc
K2iEQ+26XFtqG5AaYiITThUAGgyrdbu0XXQS2rSErtEfdO4RIg+DBlUwIP8Etpi9
QVUyqzQFeweuMMSz8L8szb6FxRYIZ45QK+l5TbR/zIKQzIFAJpcvPe4olcSxjglS
ukUUmgzbBVIrOngTcgz7dHsKSQulC29fEdAfQUcplH4EZHebYx4WbDPs74BhoEw1
pFEfUJu2bzERt4JIce7k1W6fKztBoPsgzvMHyEhpxgTLeYK/tBoOqZo8cgFxvJJc
2wngvLKchdn+zhd05ST2V7YPcJmQkghNW/zJ/XLfxTcLyWQZfIVyP+q0Ud0Mfvnt
4+fV2yQJxqYba+I0FBAjuwY5NyVLD4g+pZw8Y1/zpmL7uZxVRVrbOmJB8jleaToS
6qhN70OvFGMgP+0k1R+40HIVue+6paLRqP1CE6dCl90+9KlUFj/TxOSAjZf7AQCp
LCwO95yg3VoPrm6ySa7JO49ymxZbZ/kJ3PR0yw5jLp9J4NuGYyCzcPWQCFyIxgmR
PzBfYU7JRJJ2ZCkzOqwo51JW409iiutT9us3iruWFNa2wE+pTnjoirdIURx6Rdal
kB/RggEw6mPjWdta5ev3til5psayXOFLO3pnsTYa2ws4GWoa8E0=
=VXdI
-----END PGP SIGNATURE-----

--e7ywqriiswgh6hjv--
