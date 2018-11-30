Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:46308 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726616AbeK3Tzp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 14:55:45 -0500
Date: Fri, 30 Nov 2018 09:47:08 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] media: sun6i: Separate H3 compatible from A31
Message-ID: <20181130084708.rbggq5y3f2c5w7vu@flea>
References: <20181130075849.16941-1-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="l27y7yu4kizrcwqt"
Content-Disposition: inline
In-Reply-To: <20181130075849.16941-1-wens@csie.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--l27y7yu4kizrcwqt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 30, 2018 at 03:58:43PM +0800, Chen-Yu Tsai wrote:
> The CSI (camera sensor interface) controller found on the H3 (and H5)
> is a reduced version of the one found on the A31. It only has 1 channel,
> instead of 4 channels supporting time-multiplexed BT.656 on the A31.
> Since the H3 is a reduced version, it cannot "fallback" to a compatible
> that implements more features than it supports.
>=20
> This series separates support for the H3 variant from the A31 variant.
>=20
> Patches 1 ~ 3 separate H3 CSI from A31 CSI in the bindings, driver, and
> device tree, respectively.
>=20
> Patch 4 adds a pinmux setting for the MCLK (master clock). Some camera
> sensors use the master clock from the SoC instead of a standalone
> crystal.
>=20
> Patches 5 and 6 are examples of using a camera sensor with an SBC.
> Since the modules are detachable, these changes should not be merged.
> They should be implemented as overlays instead.
>=20
> Please have a look.
>=20
> In addition, I found that the first frame captured seems to always be
> incomplete, with either parts cropped, out of position, or missing
> color components.

For the first 4 patches,
Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--l27y7yu4kizrcwqt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXAD5DAAKCRDj7w1vZxhR
xauvAP4issrQ4ZQs2FKhnrnSC1e5aHrpRt9yMYST6XBEX3tNIwD/WUtRUNxlN5GK
gwcfuhO9WrkqAxQhilUqJ4LX5m69qwA=
=ng2d
-----END PGP SIGNATURE-----

--l27y7yu4kizrcwqt--
