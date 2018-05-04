Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:52620 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751551AbeEDIk1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 04:40:27 -0400
Date: Fri, 4 May 2018 10:40:08 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
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
Subject: Re: [PATCH v2 09/10] ARM: dts: sun7i-a20: Add Video Engine and
 reserved memory nodes
Message-ID: <20180504084008.h6p4brari3xrbv6l@flea>
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
 <20180419154536.17846-5-paul.kocialkowski@bootlin.com>
 <20180420073908.nkcbsdxibnzkqski@flea>
 <82057e2f734137a3902d9313c228b01ceb345ee7.camel@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="54sv25q3qjyzu2lb"
Content-Disposition: inline
In-Reply-To: <82057e2f734137a3902d9313c228b01ceb345ee7.camel@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--54sv25q3qjyzu2lb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 04, 2018 at 09:49:16AM +0200, Paul Kocialkowski wrote:
> > > +	reserved-memory {
> > > +		#address-cells =3D <1>;
> > > +		#size-cells =3D <1>;
> > > +		ranges;
> > > +
> > > +		/* Address must be kept in the lower 256 MiBs of
> > > DRAM for VE. */
> > > +		ve_memory: cma@4a000000 {
> > > +			compatible =3D "shared-dma-pool";
> > > +			reg =3D <0x4a000000 0x6000000>;
> > > +			no-map;
> >=20
> > I'm not sure why no-map is needed.
>=20
> In fact, having no-map here would lead to reserving the area as cache-
> coherent instead of contiguous and thus prevented dmabuf support.
> Replacing it by "resuable" allows proper CMA reservation.
>=20
> > And I guess we could use alloc-ranges to make sure the region is in
> > the proper memory range, instead of hardcoding it.
>=20
> As far as I could understand from the documentation, "alloc-ranges" is
> used for dynamic allocation while only "reg" is used for static
> allocation. We are currently going with static allocation and thus
> reserve the whole 96 MiB. Is using dynamic allocation instead desirable
> here?

I guess we could turn the question backward. Why do we need a static
allocation? This isn't a buffer that is always allocated on the same
area, but rather that we have a range available. So our constraint is
on the range, nothing else.

> > > +			reg =3D <0x01c0e000 0x1000>;
> > > +			memory-region =3D <&ve_memory>;
> >=20
> > Since you made the CMA region the default one, you don't need to tie
> > it to that device in particular (and you can drop it being mandatory
> > from your binding as well).
>=20
> What if another driver (or the system) claims memory from that zone and
> that the reserved memory ends up not being available for the VPU
> anymore?
>=20
> Acccording to the reserved-memory documentation, the reusable property
> (that we need for dmabuf) puts a limitation that the device driver
> owning the region must be able to reclaim it back.
>=20
> How does that work out if the CMA region is not tied to a driver in
> particular?

I'm not sure to get what you're saying. You have the property
linux,cma-default in your reserved region, so the behaviour you
described is what you explicitly asked for.

>=20
> > > +
> > > +			clocks =3D <&ccu CLK_AHB_VE>, <&ccu CLK_VE>,
> > > +				 <&ccu CLK_DRAM_VE>;
> > > +			clock-names =3D "ahb", "mod", "ram";
> > > +
> > > +			assigned-clocks =3D <&ccu CLK_VE>;
> > > +			assigned-clock-rates =3D <320000000>;
> >=20
> > This should be set from within the driver. If it's something that you
> > absolutely needed for the device to operate, you have no guarantee
> > that the clock rate won't change at any point in time after the device
> > probe, so that's not a proper solution.
> >=20
> > And if it's not needed and can be adjusted depending on the
> > framerate/codec/resolution, then it shouldn't be in the DT either.
>=20
> Yes, that makes sense.
>=20
> > Don't you also need to map the SRAM on the A20?
>=20
> That's a good point, there is currently no syscon handle for A20 (and
> also A13). Maybe SRAM is muxed to the VE by default so it "just works"?=
=20
>=20
> I'll investigate on this side, also keeping in mind that the actual
> solution is to use the SRAM controller driver (but that won't make it to
> v3).

The SRAM driver is available on the A20, so you should really use that
instead of a syscon.

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--54sv25q3qjyzu2lb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlrsHGgACgkQ0rTAlCFN
r3SWDg/+Im6ItEaIACJLbnNoFjw+1xFOaFJk+2PrTIHXnFJl6zxS1kIlUjDt7vt+
gQucM8JCg5gB4baUxuAmTVHOHH0htJiqnFjChqD691hqeChbW/qMZvSBwvdNgQNL
/mtSGR1Ozzq6yYyk0T7Qqfzpjce4HdDc1/u/QY0vPwYRqMAKPGL1QJZ68A2wGRG7
LhJSFiR6A2Mw6FlnCrG0bDQ2oJBGl2hDeTrBUG9k8Qn9uqewk5NrNJHjEUtYDi06
8XZ1JZ6tn2urM53v51dfKZ93lMDbv0+jKn6p7UjrqMTP8uQNgf7vD6Wjw2Cqs1is
YUTLrrOpFfJ8txMbpwHgbBTVMmzT1MyUy32mmJ4Feng9HClpkVhSTqjGp41urThk
cmC1f6Kk3JQVOdN6j8WWQ4JA1Hqyq3uAJao7ak7Th94USG/cTIGsLnoXHyOxVI+k
Pa9lETQdU8N88vo6gJrDXiOECz87yhZu4bREgeRDuQ9OjhEPnCGAJEgtXY36i83+
MErVMvetAytzx0tnQggn6NFb0EniAnM6+LD1JqjQZ7waqF8aBbkXNB+kHccyzywC
h/9X3+srJz7tx5wTfGfOX2tURRpVHqB4hxjIIlqyodLGuasxmSj5l9SgzunXFcl6
t44s64B6AEo0gJtJ6YtuRDx3v/c6GvkGToZjJMGdCXLlYzsibXs=
=XMKw
-----END PGP SIGNATURE-----

--54sv25q3qjyzu2lb--
