Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:55860 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751056AbeCINqt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 08:46:49 -0500
Message-ID: <1520603146.15946.4.camel@bootlin.com>
Subject: Re: [linux-sunxi] [PATCH 6/9] sunxi-cedrus: Add device tree binding
 document
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Priit Laes <plaes@plaes.org>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, Icenowy Zheng <icenowy@aosc.xyz>,
        Florent Revest <revestflo@gmail.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Thomas van Kleef <thomas@vitsch.nl>,
        "Signed-off-by : Bob Ham" <rah@settrans.net>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>
Date: Fri, 09 Mar 2018 14:45:46 +0100
In-Reply-To: <20180309133857.GA20392@solar>
References: <20180309100933.15922-3-paul.kocialkowski@bootlin.com>
         <20180309101445.16190-4-paul.kocialkowski@bootlin.com>
         <20180309133857.GA20392@solar>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-jBFEwdL08CFyEyRxDXma"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-jBFEwdL08CFyEyRxDXma
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Thanks for the review!

On Fri, 2018-03-09 at 15:38 +0200, Priit Laes wrote:
> On Fri, Mar 09, 2018 at 11:14:42AM +0100, Paul Kocialkowski wrote:
> > From: Florent Revest <florent.revest@free-electrons.com>
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
>=20
> This should be updated to sunxi-ng clocks:
>=20
> clocks =3D <&ccu CLK_BUS_VE>, <&ccu CLK_VE>, <&ccu CLK_DRAM_VE>;

I will definitely keep that in mind and make the change for the next
revision, thanks!

> > +	clock-names =3D "ahb", "mod", "ram";
> > +
> > +	assigned-clocks =3D <&ccu CLK_VE>;
> > +	assigned-clock-rates =3D <320000000>;
> > +
> > +	resets =3D <&ccu RST_VE>;
> > +
> > +	interrupts =3D <53>;
> > +
> > +	reg =3D <0x01c0e000 4096>;
> > +};
> > --=20
> > 2.16.2
> >=20
> > --=20
> > You received this message because you are subscribed to the Google
> > Groups "linux-sunxi" group.
> > To unsubscribe from this group and stop receiving emails from it,
> > send an email to linux-sunxi+unsubscribe@googlegroups.com.
> > For more options, visit https://groups.google.com/d/optout.
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-jBFEwdL08CFyEyRxDXma
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlqikAoACgkQ3cLmz3+f
v9HzuAf/cGCIRqLDpOtZSF3o4sE1S1meFhiNJLIUc9XDo4MneT3kf1llz9Mu8uoY
8WOd3dWkcQIQRYz4jb1NiNd6XF8Ky0Wx4896k7+riodO9YMNcjzQk5gcHRaZ5ks/
2YpjlfziJVrqvJHbs5zlF8Yov5Eu99Px0qvXCRIulPUkj1c67nOO4X7noKF/b11w
JX628G4zkUskyTgumEhzXXYYaP70YYYTqHFsHxLQRCAK1e/a8VoualH9sWO0mXMI
pICjSMVDK4DNaf2pLJ+W2tM2IP9Qrvdz0t4GiJiu2V+h6z3OIdhqsxTQDbvLS9ao
5RKBcy0FqcHBVFRyvKCTohgYOK57mg==
=7gy8
-----END PGP SIGNATURE-----

--=-jBFEwdL08CFyEyRxDXma--
