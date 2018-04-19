Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:40319 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752854AbeDSO4Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 10:56:25 -0400
Message-ID: <b8d7f6606b880962d23323cb794111580de948ac.camel@bootlin.com>
Subject: Re: [PATCH 6/9] sunxi-cedrus: Add device tree binding document
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Rob Herring <robh@kernel.org>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        "Signed-off-by : Bob Ham" <rah@settrans.net>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Florent Revest <revestflo@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Icenowy Zheng <icenowy@aosc.xyz>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas van Kleef <thomas@vitsch.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Thu, 19 Apr 2018 16:55:10 +0200
In-Reply-To: <20180318124800.7soqh34fxvwjm7pn@rob-hp-laptop>
References: <20180309100933.15922-3-paul.kocialkowski@bootlin.com>
         <20180309101445.16190-4-paul.kocialkowski@bootlin.com>
         <20180318124800.7soqh34fxvwjm7pn@rob-hp-laptop>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-y+arpT7OIZ5LFWnZA2uN"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-y+arpT7OIZ5LFWnZA2uN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, 2018-03-18 at 07:48 -0500, Rob Herring wrote:
> On Fri, Mar 09, 2018 at 11:14:42AM +0100, Paul Kocialkowski wrote:
> > From: Florent Revest <florent.revest@free-electrons.com>
>=20
> "device tree binding document" can all be summarized with the subject=20
> prefix "dt-bindings: media: ".

Will do in v2, thanks.

> Also, email should be updated to @bootlin.com?

I will keep the address @free-electrons.com (since there is no matching
@bootlin.com address). Although that address was broken at the time of
sending v1, it should be a valid redirect nowadays.

> >=20
> > Device Tree bindings for the Allwinner's video engine
> >=20
> > Signed-off-by: Florent Revest <florent.revest@free-electrons.com>
> > ---
> >  .../devicetree/bindings/media/sunxi-cedrus.txt     | 44
> > ++++++++++++++++++++++
> >  1 file changed, 44 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/sunxi-
> > cedrus.txt
> >=20
> > diff --git a/Documentation/devicetree/bindings/media/sunxi-
> > cedrus.txt b/Documentation/devicetree/bindings/media/sunxi-
> > cedrus.txt
> > new file mode 100644
> > index 000000000000..138581113c49
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/sunxi-cedrus.txt
> > @@ -0,0 +1,44 @@
> > +Device-Tree bindings for SUNXI video engine found in sunXi SoC
> > family
> > +
> > +Required properties:
> > +- compatible	    : "allwinner,sun4i-a10-video-engine";
> > +- memory-region     : DMA pool for buffers allocation;
>=20
> Why do you need this linkage? Many drivers use CMA and don't need
> this.

The VPU can only access the first 256 MiB of DRAM, that are DMA-mapped
starting from the DRAM base. This requires specific memory allocation
and handling. I'll add the information in v2.

> > +- clocks	    : list of clock specifiers, corresponding to
> > +		      entries in clock-names property;
> > +- clock-names	    : should contain "ahb", "mod" and "ram"
> > entries;
> > +- resets	    : phandle for reset;
> > +- interrupts	    : should contain VE interrupt number;
> > +- reg		    : should contain register base and length
> > of VE.
> > +
> > +Example:
> > +
> > +reserved-memory {
> > +	#address-cells =3D <1>;
> > +	#size-cells =3D <1>;
> > +	ranges;
> > +
> > +	ve_reserved: cma {
> > +		compatible =3D "shared-dma-pool";
> > +		reg =3D <0x43d00000 0x9000000>;
> > +		no-map;
> > +		linux,cma-default;
> > +	};
> > +};
> > +
> > +video-engine {
> > +	compatible =3D "allwinner,sun4i-a10-video-engine";
> > +	memory-region =3D <&ve_reserved>;
> > +
> > +	clocks =3D <&ahb_gates 32>, <&ccu CLK_VE>,
> > +		 <&dram_gates 0>;
> > +	clock-names =3D "ahb", "mod", "ram";
> > +
> > +	assigned-clocks =3D <&ccu CLK_VE>;
> > +	assigned-clock-rates =3D <320000000>;
>=20
> Not documented.

Will do in v2.

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-y+arpT7OIZ5LFWnZA2uN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlrYrc4ACgkQ3cLmz3+f
v9E6Ogf/f1f6J5mtla35B01CUFcA7QlVM5My+Dle7hi8P9z2YzzxrjmMTv399EQe
oRi8QMXSmULQNTbUaQfUzXQD+5Q6Y5gtfiZlLX8y/NNDkRwhGyJWCUbCMspR/kFn
fria3jo2qTLMnf8R+daBTGO7yTdCq5g8xqKcUJuAim7vWyvQt1r2RKx3fGfKM25P
9oe9nbpup22sexlf3m94SFRobqOePaw32mTfwNvnJ4ch2H9FTpw209mhDwr9RwWT
F2ii5TdIFbl+QX8Z37yuWuQzd1tD+/WJxMNdXNmdp4/LhLi6fxkedLeNFW26Nxbl
r5vHhG01SJwgUFO0Ti9IR1nZdDe4ng==
=NLng
-----END PGP SIGNATURE-----

--=-y+arpT7OIZ5LFWnZA2uN--
