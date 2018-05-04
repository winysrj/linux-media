Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:49853 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751403AbeEDHus (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 03:50:48 -0400
Message-ID: <82057e2f734137a3902d9313c228b01ceb345ee7.camel@bootlin.com>
Subject: Re: [PATCH v2 09/10] ARM: dts: sun7i-a20: Add Video Engine and
 reserved memory nodes
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>
Date: Fri, 04 May 2018 09:49:16 +0200
In-Reply-To: <20180420073908.nkcbsdxibnzkqski@flea>
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
         <20180419154536.17846-5-paul.kocialkowski@bootlin.com>
         <20180420073908.nkcbsdxibnzkqski@flea>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Ou7PoX3TY+MPVqw7G5RG"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-Ou7PoX3TY+MPVqw7G5RG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 2018-04-20 at 09:39 +0200, Maxime Ripard wrote:
> On Thu, Apr 19, 2018 at 05:45:35PM +0200, Paul Kocialkowski wrote:
> > This adds nodes for the Video Engine and the associated reserved
> > memory
> > for the Allwinner A20. Up to 96 MiB of memory are dedicated to the
> > VPU.
> >=20
> > The VPU can only map the first 256 MiB of DRAM, so the reserved
> > memory
> > pool has to be located in that area. Following Allwinner's decision
> > in
> > downstream software, the last 96 MiB of the first 256 MiB of RAM are
> > reserved for this purpose.
> >=20
> > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> > ---
> >  arch/arm/boot/dts/sun7i-a20.dtsi | 31
> > +++++++++++++++++++++++++++++++
> >  1 file changed, 31 insertions(+)
> >=20
> > diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi
> > b/arch/arm/boot/dts/sun7i-a20.dtsi
> > index bd0cd3204273..cb6d82065dcf 100644
> > --- a/arch/arm/boot/dts/sun7i-a20.dtsi
> > +++ b/arch/arm/boot/dts/sun7i-a20.dtsi
> > @@ -163,6 +163,20 @@
> >  		reg =3D <0x40000000 0x80000000>;
> >  	};
> > =20
> > +	reserved-memory {
> > +		#address-cells =3D <1>;
> > +		#size-cells =3D <1>;
> > +		ranges;
> > +
> > +		/* Address must be kept in the lower 256 MiBs of
> > DRAM for VE. */
> > +		ve_memory: cma@4a000000 {
> > +			compatible =3D "shared-dma-pool";
> > +			reg =3D <0x4a000000 0x6000000>;
> > +			no-map;
>=20
> I'm not sure why no-map is needed.

In fact, having no-map here would lead to reserving the area as cache-
coherent instead of contiguous and thus prevented dmabuf support.
Replacing it by "resuable" allows proper CMA reservation.

> And I guess we could use alloc-ranges to make sure the region is in
> the proper memory range, instead of hardcoding it.

As far as I could understand from the documentation, "alloc-ranges" is
used for dynamic allocation while only "reg" is used for static
allocation. We are currently going with static allocation and thus
reserve the whole 96 MiB. Is using dynamic allocation instead desirable
here?

> > +			linux,cma-default;
> > +		};
> > +	};
> > +
> >  	timer {
> >  		compatible =3D "arm,armv7-timer";
> >  		interrupts =3D <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(4) |
> > IRQ_TYPE_LEVEL_LOW)>,
> > @@ -451,6 +465,23 @@
> >  			};
> >  		};
> > =20
> > +		ve: video-engine@1c0e000 {
> > +			compatible =3D "allwinner,sun4i-a10-video-
> > engine";
>=20
> We should have an A20-specific compatible here, at least, so that we
> can deal with any quirk we might find down the road.

Yes that's a very good point.

> > +			reg =3D <0x01c0e000 0x1000>;
> > +			memory-region =3D <&ve_memory>;
>=20
> Since you made the CMA region the default one, you don't need to tie
> it to that device in particular (and you can drop it being mandatory
> from your binding as well).

What if another driver (or the system) claims memory from that zone and
that the reserved memory ends up not being available for the VPU
anymore?

Acccording to the reserved-memory documentation, the reusable property
(that we need for dmabuf) puts a limitation that the device driver
owning the region must be able to reclaim it back.

How does that work out if the CMA region is not tied to a driver in
particular?

> > +
> > +			clocks =3D <&ccu CLK_AHB_VE>, <&ccu CLK_VE>,
> > +				 <&ccu CLK_DRAM_VE>;
> > +			clock-names =3D "ahb", "mod", "ram";
> > +
> > +			assigned-clocks =3D <&ccu CLK_VE>;
> > +			assigned-clock-rates =3D <320000000>;
>=20
> This should be set from within the driver. If it's something that you
> absolutely needed for the device to operate, you have no guarantee
> that the clock rate won't change at any point in time after the device
> probe, so that's not a proper solution.
>=20
> And if it's not needed and can be adjusted depending on the
> framerate/codec/resolution, then it shouldn't be in the DT either.

Yes, that makes sense.

> Don't you also need to map the SRAM on the A20?

That's a good point, there is currently no syscon handle for A20 (and
also A13). Maybe SRAM is muxed to the VE by default so it "just works"?=20

I'll investigate on this side, also keeping in mind that the actual
solution is to use the SRAM controller driver (but that won't make it to
v3).

Cheers and thanks for the review!

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-Ou7PoX3TY+MPVqw7G5RG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlrsEHwACgkQ3cLmz3+f
v9GuaQf/QMOI/oUgcV0qLmh0CK8rKQVGPT+TH9ZK8E3X9cggGcTBAT3rH4EUgOXm
rAABPSHXM5y1d1S6gfMDPZmUd4TMUX2G79QKBoe8O8IJ3xVqES5m9Z9tanRptDB4
fS4iOzoyeXgAAMKnkCS8Oa4vWe2s6zTKhzIgP6ttQgRpxnJ851xir2tBfPJe4Bjs
MCsD87PWd9Ix4ddTG9rnRysxJovph5/j5jMnUk5WoZUwMipq5U91vQmnHNczF16m
6PQmHp93Bv7tROmlU/IRPx+0Ynbi8U7sNFBIxVsHNev5RWupfQJUIqqqqQV9mMWQ
9QYTlvXbawcI9Xx8XF5PFZfL+k4jbQ==
=9wxS
-----END PGP SIGNATURE-----

--=-Ou7PoX3TY+MPVqw7G5RG--
