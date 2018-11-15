Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:52271 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725741AbeKPFN1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Nov 2018 00:13:27 -0500
Date: Thu, 15 Nov 2018 20:04:24 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Subject: Re: [PATCH 1/5] dt-bindings: media: Add Allwinner A10 CSI binding
Message-ID: <20181115190424.gpuekifrjli5mu77@flea>
References: <cover.71b0f9855c251f9dc389ee77ee6f0e1fad91fb0b.1542097288.git-series.maxime.ripard@bootlin.com>
 <60494dd4245ab01473d074dc5cd46198a2181614.1542097288.git-series.maxime.ripard@bootlin.com>
 <20181113083855.s5jxrb32ru3myu3t@kekkonen.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="f37e5djwgbgmojp3"
Content-Disposition: inline
In-Reply-To: <20181113083855.s5jxrb32ru3myu3t@kekkonen.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--f37e5djwgbgmojp3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sakari,

On Tue, Nov 13, 2018 at 10:38:55AM +0200, Sakari Ailus wrote:
> > +  - allwinner,has-isp: Whether the CSI controller has an ISP
> > +                       associated to it or not
>=20
> Is the ISP a part of the same device? It sounds like that this is actually
> a different device if it contains an ISP as well, and that should be
> apparent from the compatible string. What do you think?

I guess we can see it as both. It seems to be the exact same register
set, except for the fact that the first instance has that ISP in
addition, and several channels, as you pointed out in your other mail.

What these channels are is not exactly clear. It looks like it's
related to the BT656 interface where you could interleave channel
bytes over the bus. I haven't really looked into it, and it doesn't
look like we have any code (or hardware) able to do that though.

> > +
> > +If allwinner,has-isp is set, an additional "isp" clock is needed,
> > +being a phandle to the clock driving the ISP.
> > +
> > +The CSI node should contain one 'port' child node with one child
> > +'endpoint' node, according to the bindings defined in
> > +Documentation/devicetree/bindings/media/video-interfaces.txt. The
> > +endpoint's bus type must be parallel or BT656.
> > +
> > +Endpoint node properties for CSI
> > +---------------------------------
> > +
> > +- remote-endpoint	: (required) a phandle to the bus receiver's endpoint
> > +			   node
>=20
> Rob's opinion has been (AFAIU) that this is not needed as it's already a
> part of the graph bindings. Unless you want to say that it's required, th=
at
> is --- the graph bindings document it as optional.

Ok, I'll remove it.

> > +- bus-width:		: (required) must be 8
>=20
> If this is the only value the hardware supports, I don't see why you shou=
ld
> specify it here.

Ditto :)

> > +- pclk-sample		: (optional) (default: sample on falling edge)
> > +- hsync-active		: (only required for parallel)
> > +- vsync-active		: (only required for parallel)
> > +
> > +Example:
> > +
> > +csi0: csi@1c09000 {
> > +	compatible =3D "allwinner,sun7i-a20-csi",
> > +		     "allwinner,sun4i-a10-csi";
> > +	reg =3D <0x01c09000 0x1000>;
> > +	interrupts =3D <GIC_SPI 42 IRQ_TYPE_LEVEL_HIGH>;
> > +	clocks =3D <&ccu CLK_AHB_CSI0>, <&ccu CLK_CSI0>,
> > +		 <&ccu CLK_CSI_SCLK>, <&ccu CLK_DRAM_CSI0>;
> > +	clock-names =3D "ahb", "mod", "isp", "ram";
> > +	resets =3D <&ccu RST_CSI0>;
> > +	allwinner,csi-channels =3D <4>;
> > +	allwinner,has-isp;
> > +=09
> > +	port {
> > +		csi_from_ov5640: endpoint {
> > +                        remote-endpoint =3D <&ov5640_to_csi>;
> > +                        bus-width =3D <8>;
> > +                        data-shift =3D <2>;
>=20
> data-shift needs to be documented above if it's relevant for the device.

It's not really related to the CSI device in that case but the sensor,
so I'll just leave it out.

Thanks!
Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--f37e5djwgbgmojp3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCW+3DOAAKCRDj7w1vZxhR
xc4LAP4qWgNQoIyi1KBkxAWejMjR0YpgCrt37hiunZiLN5pvvQEA3uqtaZw6cThN
dk+hiwg40zcrvjhumNSCb7EMzbRjzQk=
=IFrn
-----END PGP SIGNATURE-----

--f37e5djwgbgmojp3--
