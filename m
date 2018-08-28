Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:50543 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726975AbeH1Ssg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Aug 2018 14:48:36 -0400
Date: Tue, 28 Aug 2018 16:56:14 +0200
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
Subject: Re: [PATCH v8 4/8] media: platform: Add Cedrus VPU decoder driver
Message-ID: <20180828145614.rovduhq676eag3gz@flea>
References: <20180828073424.30247-1-paul.kocialkowski@bootlin.com>
 <20180828073424.30247-5-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2unr7vok42r5f56p"
Content-Disposition: inline
In-Reply-To: <20180828073424.30247-5-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--2unr7vok42r5f56p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 28, 2018 at 09:34:20AM +0200, Paul Kocialkowski wrote:
> This introduces the Cedrus VPU driver that supports the VPU found in
> Allwinner SoCs, also known as Video Engine. It is implemented through
> a v4l2 m2m decoder device and a media device (used for media requests).
> So far, it only supports MPEG2 decoding.
>=20
> Since this VPU is stateless, synchronization with media requests is
> required in order to ensure consistency between frame headers that
> contain metadata about the frame to process and the raw slice data that
> is used to generate the frame.
>=20
> This driver was made possible thanks to the long-standing effort
> carried out by the linux-sunxi community in the interest of reverse
> engineering, documenting and implementing support for Allwinner VPU.
>=20
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--2unr7vok42r5f56p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAluFYo0ACgkQ0rTAlCFN
r3QJOA/9FoAMH1yDyRaBPYbQVjztJN5W1XFxe8VK6XPyGvoWe3SmdwVIwR+zKnwW
dStsy9NNExPxuNHFHKM30YBYHhd3tV4LSW+LhEQcSDfSNBg77WLrrJeFS4oKNFYL
phemhtdiQntVi/+//eQqAPWfjW/RPMt9akrfXvxdjZFFRDXI0Ag/I0ZS75lrJiyz
bW+7Gh8dKDn+E4X9s/N7ljh2RNSsX6ocgHRZbmfvl4uR4WamxzdB3oT0bowkQy3V
PkukrLoK+pI6kEq2dxNDegf7pF+TenOf5mqL5KCp2W//3vO9OQKchU2C6woD2fOl
NjxwyjF3dZIhAYD6tcp06gf77y6UIhSqTxnNN5LN8U0AA8NspZsDnipmUfr7+Bvf
5nofBiRJNmZ705SnuiToQRgSPaeHh141RldASTTILf7glhg2Q/0Ti+TcEH6Cs+mz
IvAQ95UnkANThua7C2PRQlBhnIRibAw5r8ggBrIZz5uaIGclzqFYZN7Ky3QvNSsQ
QdNpIGyOGgBy3B6GTqGCqkFbaBNbLW/Zqb1e/PiE+ALbJys0KgZX2o48FDeNBDPT
cYRKWAKXgjLwLBgFLNF3bSpfXFf/tUpkag7eXQhGZzCVsQ3kPQ/8Aix2ayFjQa6G
ZlhyooHQEadcNJC3GxQi6UsyCwfhAbfZoUYS11uJzTz/bKKViY4=
=08WM
-----END PGP SIGNATURE-----

--2unr7vok42r5f56p--
