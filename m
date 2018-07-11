Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:42316 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732319AbeGKJOp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jul 2018 05:14:45 -0400
Date: Wed, 11 Jul 2018 11:11:24 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Marco Franchi <marco.franchi@nxp.com>,
        Icenowy Zheng <icenowy@aosc.io>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Tom Saeger <tom.saeger@oracle.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Benoit Parrot <bparrot@ti.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pawel Osciak <posciak@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>
Subject: Re: [PATCH v5 12/22] ARM: sun7i-a20: Add support for the C1 SRAM
 region with the SRAM controller
Message-ID: <20180711091124.v7jl7m7zm7hplxkx@flea>
References: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
 <20180710080114.31469-13-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rocv2bypgp7ywoj7"
Content-Disposition: inline
In-Reply-To: <20180710080114.31469-13-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--rocv2bypgp7ywoj7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 10, 2018 at 10:01:04AM +0200, Paul Kocialkowski wrote:
> From: Maxime Ripard <maxime.ripard@bootlin.com>
>=20
> This adds support for the C1 SRAM region (to be used with the SRAM
> controller driver) for the A20 platform. The region is shared
> between the Video Engine and the CPU.
>=20
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Fixed the SRAM size and applied.

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--rocv2bypgp7ywoj7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAltFybsACgkQ0rTAlCFN
r3QICQ//elxoP47g2vqdmv5pNOhav+y3/AfO/rdq6mBmCj/uwV9+nhtUYxjuqtuS
Obd1kdbC1ICtY0Sf6sHIIhPobJ87qQR+sjysjRDCvG6Jzz2sSYgAJOGnqjXdFKSp
Oo0RJ3Fxgenie6An8x+aDBpXys6X7RN0qofiPlDYrZ5MksjM8pKkVIA0ZuYHuzhK
5jFnNSW7/GHdtxFalqkdFHxMQJLm+84MhBG+9nHX2CDKtlZ8mEIIqoMwDPB8Ksct
TDQLIZoskLVqkxi64nqheh0AllW0+2qtPTdn4bYNSwn/d6E91zRxzXZ+JW3PUuYC
9ATJm2w+2UCA/Dw/19weAPS2anhWAkmOdfBAjbcdzN/t1YGP15EMV/kgtJv5QOvK
KHVZjG0XfbWveEdmP8AvIy9L9vI6Jlk04Wa/h4QZm65eAEBdMJlaOVPE8ZwLS9FX
WRqM0JuzbaIpuy97sfPuni2RPEjCvJ6GdLXhIIGmRVCFZJ09UDbxP6rbW8L0lmUG
SCJQeJvbfz041UWUJKmnMqv52WV1wbogiIoXWCsh6NptiSYZJPvKWPFQG/x14eLi
DKpLfzh7Bbdi4OwjiLN6+sOdcCrkpIC8uRxNfN6NFPHJoXbwq60QtyrnFFgPunbr
AB2nWOW1CAzZbi+8tsVmHxxuAzf6tbGrvslW+XaZ5ffdNdNkAeY=
=3yJU
-----END PGP SIGNATURE-----

--rocv2bypgp7ywoj7--
