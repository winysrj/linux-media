Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:50141 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750707AbeEDH63 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 03:58:29 -0400
Message-ID: <ce85c790b639bf9101b8c33526bdf149070bcc03.camel@bootlin.com>
Subject: Re: [PATCH v2 08/10] dt-bindings: media: Document bindings for the
 Sunxi-Cedrus VPU driver
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Rob Herring <robh@kernel.org>
Cc: Tomasz Figa <tfiga@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg "
         "Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>, wens@csie.org,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <acourbot@chromium.org>
Date: Fri, 04 May 2018 09:56:20 +0200
In-Reply-To: <20180427030436.3ptrb2ldhtnssipj@rob-hp-laptop>
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
         <20180419154536.17846-4-paul.kocialkowski@bootlin.com>
         <1524153860.3416.9.camel@pengutronix.de>
         <CAAFQd5DT_xjUbZzFOoKk7_duiSZ8Awb1J=0dPEhVTBk0P3gppA@mail.gmail.com>
         <5fa80b1e88ad2a215f51ea3a2b9b62274fa9b1ec.camel@bootlin.com>
         <20180427030436.3ptrb2ldhtnssipj@rob-hp-laptop>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-b/HxHQn6MyZGhNkytJKo"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-b/HxHQn6MyZGhNkytJKo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 2018-04-26 at 22:04 -0500, Rob Herring wrote:
> On Fri, Apr 20, 2018 at 09:22:20AM +0200, Paul Kocialkowski wrote:
> > Hi and thanks for the review,
> >=20
> > On Fri, 2018-04-20 at 01:31 +0000, Tomasz Figa wrote:
> > > Hi Paul, Philipp,
> > >=20
> > > On Fri, Apr 20, 2018 at 1:04 AM Philipp Zabel <p.zabel@pengutronix
> > > .de>
> > > wrote:
> > >=20
> > > > Hi Paul,
> > > > On Thu, 2018-04-19 at 17:45 +0200, Paul Kocialkowski wrote:
> > > > > This adds a device-tree binding document that specifies the
> > > > > properties
> > > > > used by the Sunxi-Cedurs VPU driver, as well as examples.
> > > > >=20
> > > > > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.co
> > > > > m>
> > > > > ---
> > > > >  .../devicetree/bindings/media/sunxi-cedrus.txt     | 50
> > >=20
> > > ++++++++++++++++++++++
> > > > >  1 file changed, 50 insertions(+)
> > > > >  create mode 100644
> > >=20
> > > Documentation/devicetree/bindings/media/sunxi-cedrus.txt
> > > > >=20
> > > > > diff --git a/Documentation/devicetree/bindings/media/sunxi-
> > > > > cedrus.txt
> > >=20
> > > b/Documentation/devicetree/bindings/media/sunxi-cedrus.txt
> > > > > new file mode 100644
> > > > > index 000000000000..71ad3f9c3352
> > > > > --- /dev/null
> > > > > +++ b/Documentation/devicetree/bindings/media/sunxi-cedrus.txt
> > > > > @@ -0,0 +1,50 @@
> > > > > +Device-tree bindings for the VPU found in Allwinner SoCs,
> > > > > referred to
> > >=20
> > > as the
> > > > > +Video Engine (VE) in Allwinner literature.
> > > > > +
> > > > > +The VPU can only access the first 256 MiB of DRAM, that are
> > > > > DMA-
> > > > > mapped
> > >=20
> > > starting
> > > > > +from the DRAM base. This requires specific memory allocation
> > > > > and
> > >=20
> > > handling.
> > >=20
> > > And no IOMMU? Brings back memories.
> >=20
> > Exactly, no IOMMU so we don't have much choice but cope with that
> > hardware limitation...
> >=20
> > > > > +
> > > > > +Required properties:
> > > > > +- compatible         : "allwinner,sun4i-a10-video-engine";
> > > > > +- memory-region         : DMA pool for buffers allocation;
> > > > > +- clocks             : list of clock specifiers,
> > > > > corresponding to
> > >=20
> > > entries in
> > > > > +                          the clock-names property;
> > > > > +- clock-names                : should contain "ahb", "mod"
> > > > > and
> > > > > "ram"
> > >=20
> > > entries;
> > > > > +- assigned-clocks       : list of clocks assigned to the VE;
> > > > > +- assigned-clocks-rates : list of clock rates for the clocks
> > > > > assigned
> > >=20
> > > to the VE;
> > > > > +- resets             : phandle for reset;
> > > > > +- interrupts         : should contain VE interrupt number;
> > > > > +- reg                        : should contain register base
> > > > > and
> > > > > length
> > >=20
> > > of VE.
> > > > > +
> > > > > +Example:
> > > > > +
> > > > > +reserved-memory {
> > > > > +     #address-cells =3D <1>;
> > > > > +     #size-cells =3D <1>;
> > > > > +     ranges;
> > > > > +
> > > > > +     /* Address must be kept in the lower 256 MiBs of DRAM
> > > > > for
> > > > > VE. */
> > > > > +     ve_memory: cma@4a000000 {
> > > > > +             compatible =3D "shared-dma-pool";
> > > > > +             reg =3D <0x4a000000 0x6000000>;
> > > > > +             no-map;
> > > > > +             linux,cma-default;
> > > > > +     };
> > > > > +};
> > > > > +
> > > > > +video-engine@1c0e000 {
> > > >=20
> > > > This is not really required by any specification, and not as
> > > > common
> > > > as
> > > > gpu@..., but could this reasonably be called "vpu@1c0e000" to
> > > > follow
> > > > somewhat-common practice?
> > >=20
> > > AFAIR the name is supposed to be somewhat readable for someone
> > > that
> > > doesn't know the hardware. To me, "video-engine" sounds more
> > > obvious
> > > than "vpu", but we actually use "codec" already, in case of MFC
> > > and
> > > JPEG codec on Exynos. If encode/decode is the only functionality
> > > of
> > > this block, I'd personally go with "codec". If it can do other
> > > things,
> > > e.g. scaling/rotation without encode/decode, I'd probably call it
> > > "video-processor".
> >=20
> > I agree that the term VPU is more commonly associated with video
> > decoding, while video engine could mean a number of things.
> >=20
> > The reason I went with "video-engine" here (while still presenting
> > the
> > driver as a VPU driver) is that Video Engine is the term used in
> > Allwinner's litterature. Other nodes in Allwinner device-trees
> > generally
> > stick to these terms (for instance, we have "display-engine" nodes).
> > This also makes it easier to find the matching parts in the
> > documentation.
>=20
> 'video-codec' is what is defined in the DT spec.

Is that an actively-enforced guideline or a suggestion? I'd like to keep
video-engine just to stick with the technical documentation wording and
my personal taste is also to prefer vpu over video-codec (in terms of
clarity/straightforwardness) as a second choice.

Still, if the choice isn't up to me, we can go with video-codec (or
vpu).

Cheers,

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-b/HxHQn6MyZGhNkytJKo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlrsEiQACgkQ3cLmz3+f
v9E79gf/TOaR+bQQFevAdm0ib4NhBuRzUx3VuTMs2eWeaxoSJ/6oHXfqmq2w8DOp
lWW7dGt8q7/Q3yvx1MnoVBWJZFepwrJB9IPiZ05R/wkKCgkPaIkpE2Yc4C18ykby
eX2gnwyfiMuVvMdAmDRYAoWV1VZHVlPbLyUtR2r8JMXxKIR6WYJDYeB2tnzlB3zD
iq/n12jFw8o8tayGFDUgL0H6y9CL/5ZM77vI1MSM08uHrkvm3YhBCFKLdrCZLkei
5+1CzRvzZdy252eTNAGVbg8O6FO4G6cAmT4C7haZFkVAEPCWKo4geZSTOqlio331
6gvUMRKGbw8PhzOX7yJrW0FzW1n3+g==
=x0aN
-----END PGP SIGNATURE-----

--=-b/HxHQn6MyZGhNkytJKo--
