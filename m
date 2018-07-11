Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:41540 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbeGKI6g (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jul 2018 04:58:36 -0400
Date: Wed, 11 Jul 2018 10:55:17 +0200
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
Subject: Re: [PATCH v5 05/22] dt-bindings: sram: sunxi: Populate valid
 sections compatibles
Message-ID: <20180711085517.myjn5ttiwqiolobz@flea>
References: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
 <20180710080114.31469-6-paul.kocialkowski@bootlin.com>
 <CAGb2v64Na1Mq0=-z5Haq=sgggRPHNHVZ-6fFczxb3EESAzZ=XA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4x5rkbvkq66mckhl"
Content-Disposition: inline
In-Reply-To: <CAGb2v64Na1Mq0=-z5Haq=sgggRPHNHVZ-6fFczxb3EESAzZ=XA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--4x5rkbvkq66mckhl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 10, 2018 at 10:47:07PM +0800, Chen-Yu Tsai wrote:
> On Tue, Jul 10, 2018 at 4:00 PM, Paul Kocialkowski
> <paul.kocialkowski@bootlin.com> wrote:
> > This adds a list of valid SRAM sections compatibles for the A13, A20,
> > A23 and H3 platforms. Per-platform compatibles are introduced for the
> > SRAM sections of these platforms, with the A10 compatibles also listed
> > as valid when applicable.
> >
> > In particular, compatibles for the C1 SRAM section are introduced.
>=20
> You should probably mention that this is not an exhaustive list. In
> particular, the C2 and C3 (sun5i) mappings are still missing.
>=20
> >
> > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> > ---
> >  .../devicetree/bindings/sram/sunxi-sram.txt   | 25 +++++++++++++++++++
> >  1 file changed, 25 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/sram/sunxi-sram.txt b/Do=
cumentation/devicetree/bindings/sram/sunxi-sram.txt
> > index 156a02ab6b54..07c53c5214a0 100644
> > --- a/Documentation/devicetree/bindings/sram/sunxi-sram.txt
> > +++ b/Documentation/devicetree/bindings/sram/sunxi-sram.txt
> > @@ -32,8 +32,33 @@ once again the representation described in the mmio-=
sram binding.
> >
> >  The valid sections compatible for A10 are:
> >      - allwinner,sun4i-a10-sram-a3-a4
> > +    - allwinner,sun4i-a10-sram-c1
> >      - allwinner,sun4i-a10-sram-d
> >
> > +The valid sections compatible for A13 are:
> > +    - allwinner,sun5i-a13-sram-a3-a4
> > +    - allwinner,sun4i-a10-sram-a3-a4
> > +    - allwinner,sun5i-a13-sram-c1
> > +    - allwinner,sun4i-a10-sram-c1
> > +    - allwinner,sun5i-a13-sram-d
> > +    - allwinner,sun4i-a10-sram-d
> > +
> > +The valid sections compatible for A20 are:
> > +    - allwinner,sun7i-a20-sram-a3-a4
> > +    - allwinner,sun4i-a10-sram-a3-a4
> > +    - allwinner,sun7i-a20-sram-c1
> > +    - allwinner,sun4i-a10-sram-c1
> > +    - allwinner,sun7i-a20-sram-d
> > +    - allwinner,sun4i-a10-sram-d
> > +
> > +The valid sections compatible for A23/A33 are:
> > +    - allwinner,sun8i-a23-sram-c1
> > +    - allwinner,sun4i-a10-sram-c1
> > +
> > +The valid sections compatible for H3 are:
> > +    - allwinner,sun8i-h3-sram-c1
> > +    - allwinner,sun4i-a10-sram-c1
>=20
> I'm not quite sure why we want to list these... I think it makes more sen=
se
> to just have the SoC specific compatible. They are tied to the controls
> after all. Maybe Rob has a different opinion?

We had that discussion not so long ago, and the outcome was to list
the SoC specific and the fallback compatibles on the same line. I've
amended the patch to do so and applied.

(and added the mention of the C2 and C3 SRAMs as you suggested)

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--4x5rkbvkq66mckhl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAltFxfQACgkQ0rTAlCFN
r3Tyig//VvvkaNDStwST2xmuMuiwXX/uMwSgYyvU97azlGWDwVrYmWRPohGw4SHk
Ctta2Re24CViAK/KWlagk852PcUgpSmGOPWwjKKvkmJ5J6Pce5uCuWsRxOBga7tA
fHcM5zMCuaPd7SQmaz/J+8sXlD0Z0YHuG/MNjpKvs4Rp1GuXWOAe+XmidtatWvgP
ZwNHYHkO9ZpVgff+eftm5sXCLBHhqcRP1sWFmmfiu6VJCIv/VcFPWbBBXX7efxDU
N/KHGsr3jf34gGe3XLo+Xcm9lvwdwHQyB2yRpxAS65AbpsM3YzzcsIrkCdhWTxjo
x/ZvfMVeUYnUWRFdmyqyvSWLRX+B6TPcuTHgl2IwXaoLMeIHVOw0af6dnHx9PwN4
17fJp1iFTgEH4+KJRQC3reSSOK528jWp3j3/60Hmbigfgeq21U6QKaQduhHRLimG
yXnUqIME991dVJfMRsm+H6qIROVllyq7fOFYN0SK+yKnTudj+xVq6FXfwyGMPS5K
3vluGn1+ZCLRFLVYa1VCHj1GpfHOj7SSpz+9EiyuW+7mx58IR0Ip4Z8fYe/5Yk5b
4Udj8ZaC8V0kj7d8ZDh8ztb8O1y45vu+m1wiUOTnj+mZoe+JZoh9cg8jGUsyh3it
hQNtelN3DVQ+HKxriLiGeI5bFqJn/BsdSf4n7KhbRREi38uFK9k=
=4XM2
-----END PGP SIGNATURE-----

--4x5rkbvkq66mckhl--
