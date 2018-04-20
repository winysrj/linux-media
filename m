Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:54932 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753539AbeDTHXq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 03:23:46 -0400
Message-ID: <5fa80b1e88ad2a215f51ea3a2b9b62274fa9b1ec.camel@bootlin.com>
Subject: Re: [PATCH v2 08/10] dt-bindings: media: Document bindings for the
 Sunxi-Cedrus VPU driver
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Tomasz Figa <tfiga@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg "
         "Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>, wens@csie.org,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <acourbot@chromium.org>
Date: Fri, 20 Apr 2018 09:22:20 +0200
In-Reply-To: <CAAFQd5DT_xjUbZzFOoKk7_duiSZ8Awb1J=0dPEhVTBk0P3gppA@mail.gmail.com>
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
         <20180419154536.17846-4-paul.kocialkowski@bootlin.com>
         <1524153860.3416.9.camel@pengutronix.de>
         <CAAFQd5DT_xjUbZzFOoKk7_duiSZ8Awb1J=0dPEhVTBk0P3gppA@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-9FZvfMmIQIhuBv3NJwWK"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-9FZvfMmIQIhuBv3NJwWK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi and thanks for the review,

On Fri, 2018-04-20 at 01:31 +0000, Tomasz Figa wrote:
> Hi Paul, Philipp,
>=20
> On Fri, Apr 20, 2018 at 1:04 AM Philipp Zabel <p.zabel@pengutronix.de>
> wrote:
>=20
> > Hi Paul,
> > On Thu, 2018-04-19 at 17:45 +0200, Paul Kocialkowski wrote:
> > > This adds a device-tree binding document that specifies the
> > > properties
> > > used by the Sunxi-Cedurs VPU driver, as well as examples.
> > >=20
> > > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> > > ---
> > >  .../devicetree/bindings/media/sunxi-cedrus.txt     | 50
>=20
> ++++++++++++++++++++++
> > >  1 file changed, 50 insertions(+)
> > >  create mode 100644
>=20
> Documentation/devicetree/bindings/media/sunxi-cedrus.txt
> > >=20
> > > diff --git a/Documentation/devicetree/bindings/media/sunxi-
> > > cedrus.txt
>=20
> b/Documentation/devicetree/bindings/media/sunxi-cedrus.txt
> > > new file mode 100644
> > > index 000000000000..71ad3f9c3352
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/media/sunxi-cedrus.txt
> > > @@ -0,0 +1,50 @@
> > > +Device-tree bindings for the VPU found in Allwinner SoCs,
> > > referred to
>=20
> as the
> > > +Video Engine (VE) in Allwinner literature.
> > > +
> > > +The VPU can only access the first 256 MiB of DRAM, that are DMA-
> > > mapped
>=20
> starting
> > > +from the DRAM base. This requires specific memory allocation and
>=20
> handling.
>=20
> And no IOMMU? Brings back memories.

Exactly, no IOMMU so we don't have much choice but cope with that
hardware limitation...

> > > +
> > > +Required properties:
> > > +- compatible         : "allwinner,sun4i-a10-video-engine";
> > > +- memory-region         : DMA pool for buffers allocation;
> > > +- clocks             : list of clock specifiers, corresponding to
>=20
> entries in
> > > +                          the clock-names property;
> > > +- clock-names                : should contain "ahb", "mod" and
> > > "ram"
>=20
> entries;
> > > +- assigned-clocks       : list of clocks assigned to the VE;
> > > +- assigned-clocks-rates : list of clock rates for the clocks
> > > assigned
>=20
> to the VE;
> > > +- resets             : phandle for reset;
> > > +- interrupts         : should contain VE interrupt number;
> > > +- reg                        : should contain register base and
> > > length
>=20
> of VE.
> > > +
> > > +Example:
> > > +
> > > +reserved-memory {
> > > +     #address-cells =3D <1>;
> > > +     #size-cells =3D <1>;
> > > +     ranges;
> > > +
> > > +     /* Address must be kept in the lower 256 MiBs of DRAM for
> > > VE. */
> > > +     ve_memory: cma@4a000000 {
> > > +             compatible =3D "shared-dma-pool";
> > > +             reg =3D <0x4a000000 0x6000000>;
> > > +             no-map;
> > > +             linux,cma-default;
> > > +     };
> > > +};
> > > +
> > > +video-engine@1c0e000 {
> > This is not really required by any specification, and not as common
> > as
> > gpu@..., but could this reasonably be called "vpu@1c0e000" to follow
> > somewhat-common practice?
>=20
> AFAIR the name is supposed to be somewhat readable for someone that
> doesn't know the hardware. To me, "video-engine" sounds more obvious
> than "vpu", but we actually use "codec" already, in case of MFC and
> JPEG codec on Exynos. If encode/decode is the only functionality of
> this block, I'd personally go with "codec". If it can do other things,
> e.g. scaling/rotation without encode/decode, I'd probably call it
> "video-processor".

I agree that the term VPU is more commonly associated with video
decoding, while video engine could mean a number of things.

The reason I went with "video-engine" here (while still presenting the
driver as a VPU driver) is that Video Engine is the term used in
Allwinner's litterature. Other nodes in Allwinner device-trees generally
stick to these terms (for instance, we have "display-engine" nodes).
This also makes it easier to find the matching parts in the
documentation.

Cheers,

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-9FZvfMmIQIhuBv3NJwWK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlrZlSwACgkQ3cLmz3+f
v9Hy3ggAnk4HQUzPACB7k5/RwBMiSycikYulTkmhVcK+LnVj5b9Mq2z83uyPj0pp
TdeyYi4zNHQYPrEFoK+s45leqrfJUaI4Nr24qJAVz5tia7zgFnKrW12KoPeOO2vI
ijcAEy2dypRajYxjUxW3KqRwbomJcpTbNHAb0JQBP60FuWlq3hjfsaH/DRr66AzP
gvCg/o2L9Cosd/mmWupmdwH92zWNMrS5r7f+XyouKaoxZuUm3QJXVttBtGxx/XXE
hBtgj+2BFYgeN5shsXCO0kasjcJC3TkQyxhfd/BrrMxvbRDhOogeBJXGe/mlY1Xu
JIjjIGANMCsARw9Uyeyh/Kc/ktwi5Q==
=OpZH
-----END PGP SIGNATURE-----

--=-9FZvfMmIQIhuBv3NJwWK--
