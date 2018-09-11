Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:40052 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbeIKNw0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 09:52:26 -0400
Date: Tue, 11 Sep 2018 10:53:55 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Paul Kocialkowski <contact@paulk.fr>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com, Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v9 0/9] Cedrus driver for the Allwinner Video Engine,
 using media requests
Message-ID: <20180911085355.bmd6gm24tkuxzdst@flea>
References: <20180906222442.14825-1-contact@paulk.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tnxohcee4xz5pskx"
Content-Disposition: inline
In-Reply-To: <20180906222442.14825-1-contact@paulk.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--tnxohcee4xz5pskx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 07, 2018 at 12:24:33AM +0200, Paul Kocialkowski wrote:
> This is the ninth iteration of the updated Cedrus driver,
> that supports the Video Engine found on most Allwinner SoCs, starting
> with the A10. It was tested on the A13, A20, A33 and H3.
>=20
> The initial version of this driver[0] was originally written and
> submitted by Florent Revest using a previous version of the request API
> that is necessary to provide coherency between controls and the buffers
> they apply to.
>=20
> The driver was adapted to use the latest version of the media request
> API[1], as submitted by Hans Verkuil. Media request API support is a
> hard requirement for the Cedrus driver.
>=20
> The driver itself currently only supports MPEG2 and more codecs will be
> added eventually. The default output frame format provided by the Video
> Engine is a multi-planar tiled YUV format (based on NV12). A specific
> format is introduced in the V4L2 API to describe it. Starting with the
> A33, the Video Engine can also output untiled YUV formats.

Applied the DTS patches, thanks!
Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--tnxohcee4xz5pskx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAluXgqIACgkQ0rTAlCFN
r3Q/EQ//YzqVxVgpNeUPQC1aIPWbTOZVHtAIK14Z7UNUq5c1sAFqnF7Sn7r71jWq
xQ5ePAc+sqtrt6E+v8vJTHmsYTrtjzxXwNGOckz4WNA6nQB1HKhpPeLt5jk1V4PX
kjWZmd+VwFIQkVjWkGPJGQJpqcCVsuhLzqD7cejC6EpRsCLphht2wykN2AWXHPRc
jNh8t8k7paH7Yk4VuJ7FJRGD1oy4pKe0N3F+jrMAsXQQkHbbPKS2BmUap26AV5Z1
Q2NzHYKVXDK8SFDHi7/vL2vytpu6IWRskEheHbC3rpsJDE7KRATmixZ0TYT1BXhC
ExQCv9rt43oButgkNcKCQO+RJh8FDPtFzlY5bzzWqDNiGOW7I7O+mG7kGGVimyYO
WHI0YS+5JlAU2t3d9RH54sCLFuqzDecZMgobgDdPJceQ0IeEPFcFOP1H97UK7pyg
FrLZwOWS7GBJpWcrpytfqxS9IGuKoCLC+x0EoeeFw2QCF4/xgrJoYS1uroLCltmo
2dNnZZqnsb+o7jQjH52iadi7lNODJ83GWrTrW190/UphBY0PoFLXPtTzio5bR6vh
P9JQ82whhzqSXZmDAj2rxxxKYH7esLwBie/yq0rolkA8cBo8zgnF3ZvtgnudJnqm
ZezU0ndsJNvWXkfHBw4+LPJ18n8bU5WpQKEwV2X/YJl2uaa9TcQ=
=Z4X/
-----END PGP SIGNATURE-----

--tnxohcee4xz5pskx--
