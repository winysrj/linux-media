Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:42175 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbeGKJMD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jul 2018 05:12:03 -0400
Date: Wed, 11 Jul 2018 11:08:42 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
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
        linux-sunxi <linux-sunxi@googlegroups.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>
Subject: Re: [PATCH v5 11/22] ARM: sun5i: Add support for the C1 SRAM region
 with the SRAM controller
Message-ID: <20180711090842.q3q3lvnuwj52nnjx@flea>
References: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
 <20180710080114.31469-12-paul.kocialkowski@bootlin.com>
 <CAGb2v65swXpLwAo3M9X=MJeVmUrjT=FPFZxp=eCzMrfopqHKjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fvh5gzw54i3rynrk"
Content-Disposition: inline
In-Reply-To: <CAGb2v65swXpLwAo3M9X=MJeVmUrjT=FPFZxp=eCzMrfopqHKjA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--fvh5gzw54i3rynrk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 10, 2018 at 10:56:23PM +0800, Chen-Yu Tsai wrote:
> On Tue, Jul 10, 2018 at 4:01 PM, Paul Kocialkowski
> <paul.kocialkowski@bootlin.com> wrote:
> > From: Maxime Ripard <maxime.ripard@bootlin.com>
> >
> > This adds support for the C1 SRAM region (to be used with the SRAM
> > controller driver) for sun5i-based platforms. The region is shared
> > between the Video Engine and the CPU.
> >
> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>=20
> Reviewed-by: Chen-Yu Tsai <wens@csie.org>
>=20
> But again, see discussion about SRAM compatibles.

I've fixed the SRAM C size (which is 0xd0000 and not 0x80000) and
applied, thanks!
Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--fvh5gzw54i3rynrk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAltFyRkACgkQ0rTAlCFN
r3SN8Q/+IbrK/5h4vviNqCywlxuLaonZMSaHbqHRNgnoonzYg4n+VSmeiOyeRE0K
pVaRh1eTMuBD0DyaiOPO0SMOOI4IWmIwA/5m6qics74qZ7gCD4Up3nKuPlUitdn/
xST/fJtRtriXqnCruDcTRdXcwwABE5VVrTP7krZeZG0wgjWXTbAUlxbIoOu5wk0H
jdmJFpVqSmFOTh/Me9hPZdu8NjI3iosYGrlSXZvbDcGKLjKjKPZmjxpoVxfjMEvA
Lc2o5TBj8xF/jkS89hLqGIG6WkTdA4FE7joPZI6aaGV7GxJjxuV1LalHLJKVWRTd
VHhaAa0eWjKCIfSQae8W1X0nDItMF1zWzBsJXiMQPwVdcbAmxIANgql7a44d5UIE
fG+RENeRRTEqT9/pD8HQJd7NdtFK5Si2PDG6aIUDkJG5vpeHEAvM49fMU1fge7PS
9x8hNJQX2f5neytgLSoE/XbkqXjn6+r3tFUgBxwOlVAUqIIqTOnAr7ndnyAtesl/
9tJC+o9l3iX9kafwiYUK7JDgCv6a4+5/P4AriOUIa/flcMT+l0mF4dKdKvxgQ66n
L4LRlN8xjmeamTN/tebJ82psS42GZDStLfjZJRW7tHvF6uHsBAzrggKbewWSBMQR
Ol+xRbVS0MD+uHuAcLBAlcgKQ9yFL6lmL4mzbg352q2u0KwiZ6M=
=geDY
-----END PGP SIGNATURE-----

--fvh5gzw54i3rynrk--
