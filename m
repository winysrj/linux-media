Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:52946 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750707AbeEDItQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 04:49:16 -0400
Message-ID: <e8cd340605ab4db8ebf2888a4fce645e8bc481d0.camel@bootlin.com>
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
Date: Fri, 04 May 2018 10:47:44 +0200
In-Reply-To: <20180504084008.h6p4brari3xrbv6l@flea>
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
         <20180419154536.17846-5-paul.kocialkowski@bootlin.com>
         <20180420073908.nkcbsdxibnzkqski@flea>
         <82057e2f734137a3902d9313c228b01ceb345ee7.camel@bootlin.com>
         <20180504084008.h6p4brari3xrbv6l@flea>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-z6uOXkhlZI6BuzvAQsoF"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-z6uOXkhlZI6BuzvAQsoF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 2018-05-04 at 10:40 +0200, Maxime Ripard wrote:
> On Fri, May 04, 2018 at 09:49:16AM +0200, Paul Kocialkowski wrote:
> > > > +	reserved-memory {
> > > > +		#address-cells =3D <1>;
> > > > +		#size-cells =3D <1>;
> > > > +		ranges;
> > > > +
> > > > +		/* Address must be kept in the lower 256 MiBs
> > > > of
> > > > DRAM for VE. */
> > > > +		ve_memory: cma@4a000000 {
> > > > +			compatible =3D "shared-dma-pool";
> > > > +			reg =3D <0x4a000000 0x6000000>;
> > > > +			no-map;
> > >=20
> > > I'm not sure why no-map is needed.
> >=20
> > In fact, having no-map here would lead to reserving the area as
> > cache-
> > coherent instead of contiguous and thus prevented dmabuf support.
> > Replacing it by "resuable" allows proper CMA reservation.
> >=20
> > > And I guess we could use alloc-ranges to make sure the region is
> > > in
> > > the proper memory range, instead of hardcoding it.
> >=20
> > As far as I could understand from the documentation, "alloc-ranges"
> > is
> > used for dynamic allocation while only "reg" is used for static
> > allocation. We are currently going with static allocation and thus
> > reserve the whole 96 MiB. Is using dynamic allocation instead
> > desirable
> > here?
>=20
> I guess we could turn the question backward. Why do we need a static
> allocation? This isn't a buffer that is always allocated on the same
> area, but rather that we have a range available. So our constraint is
> on the range, nothing else.

That makes sense, I will give it a shot with a range then.

> > > > +			reg =3D <0x01c0e000 0x1000>;
> > > > +			memory-region =3D <&ve_memory>;
> > >=20
> > > Since you made the CMA region the default one, you don't need to
> > > tie
> > > it to that device in particular (and you can drop it being
> > > mandatory
> > > from your binding as well).
> >=20
> > What if another driver (or the system) claims memory from that zone
> > and
> > that the reserved memory ends up not being available for the VPU
> > anymore?
> >=20
> > Acccording to the reserved-memory documentation, the reusable
> > property
> > (that we need for dmabuf) puts a limitation that the device driver
> > owning the region must be able to reclaim it back.
> >=20
> > How does that work out if the CMA region is not tied to a driver in
> > particular?
>=20
> I'm not sure to get what you're saying. You have the property
> linux,cma-default in your reserved region, so the behaviour you
> described is what you explicitly asked for.

My point is that I don't see how the driver can claim back (part of) the
reserved area if the area is not explicitly attached to it.

Or is that mechanism made in a way that all drivers wishing to use the
reserved memory area can claim it back from the system, but there is no
priority (other than first-come first-served) for which drivers claims
it back in case two want to use the same reserved region (in a scenario
where there isn't enough memory to allow both drivers)?

> > > > +
> > > > +			clocks =3D <&ccu CLK_AHB_VE>, <&ccu
> > > > CLK_VE>,
> > > > +				 <&ccu CLK_DRAM_VE>;
> > > > +			clock-names =3D "ahb", "mod", "ram";
> > > > +
> > > > +			assigned-clocks =3D <&ccu CLK_VE>;
> > > > +			assigned-clock-rates =3D <320000000>;
> > >=20
> > > This should be set from within the driver. If it's something that
> > > you
> > > absolutely needed for the device to operate, you have no guarantee
> > > that the clock rate won't change at any point in time after the
> > > device
> > > probe, so that's not a proper solution.
> > >=20
> > > And if it's not needed and can be adjusted depending on the
> > > framerate/codec/resolution, then it shouldn't be in the DT either.
> >=20
> > Yes, that makes sense.
> >=20
> > > Don't you also need to map the SRAM on the A20?
> >=20
> > That's a good point, there is currently no syscon handle for A20
> > (and
> > also A13). Maybe SRAM is muxed to the VE by default so it "just
> > works"?=20
> >=20
> > I'll investigate on this side, also keeping in mind that the actual
> > solution is to use the SRAM controller driver (but that won't make
> > it to
> > v3).
>=20
> The SRAM driver is available on the A20, so you should really use that
> instead of a syscon.

The SRAM driver is indeed available for the A20, but still lacks support
for the VE in particular as far as I can see.

Cheers,

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-z6uOXkhlZI6BuzvAQsoF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlrsHjAACgkQ3cLmz3+f
v9H8Zgf6AwC3Bwuq4+XtcRrJty5Kyv/H7bcxUAk16imyQDGM2aEo44tQwLZmvhaR
WX/X50zEsQsbXnJUB/4LR1vu+h1cIcumYbrZNCeQFwx4aCYBn8hnepEUTlHu3cU2
qUHs7s2UenQoPxHF4RoDVjU1ofFo5rTzWsmRQtL59TOx1Y/sAVGVyM4KyiZBQza2
eBzQEcPLaoxGI2c+xEYdXQXQmo0Q0tjrHIV9EjcsNorGBCx9myG3rA5ZJwcXopcG
NhCz7wmtNyXuFqMK+1/GjM1eVaH8ba9it9YYiQLjxQ9u+R4zZtGHcLmnq3yHOzNs
GQ+pId1jBlMOvXfR4ueZBne2KeS1lQ==
=drh9
-----END PGP SIGNATURE-----

--=-z6uOXkhlZI6BuzvAQsoF--
