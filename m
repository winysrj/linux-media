Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:55906 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753956AbeDTHjU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 03:39:20 -0400
Date: Fri, 20 Apr 2018 09:39:08 +0200
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
Message-ID: <20180420073908.nkcbsdxibnzkqski@flea>
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
 <20180419154536.17846-5-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gx2hl7khsqiaus56"
Content-Disposition: inline
In-Reply-To: <20180419154536.17846-5-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--gx2hl7khsqiaus56
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 19, 2018 at 05:45:35PM +0200, Paul Kocialkowski wrote:
> This adds nodes for the Video Engine and the associated reserved memory
> for the Allwinner A20. Up to 96 MiB of memory are dedicated to the VPU.
>=20
> The VPU can only map the first 256 MiB of DRAM, so the reserved memory
> pool has to be located in that area. Following Allwinner's decision in
> downstream software, the last 96 MiB of the first 256 MiB of RAM are
> reserved for this purpose.
>=20
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> ---
>  arch/arm/boot/dts/sun7i-a20.dtsi | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a=
20.dtsi
> index bd0cd3204273..cb6d82065dcf 100644
> --- a/arch/arm/boot/dts/sun7i-a20.dtsi
> +++ b/arch/arm/boot/dts/sun7i-a20.dtsi
> @@ -163,6 +163,20 @@
>  		reg =3D <0x40000000 0x80000000>;
>  	};
> =20
> +	reserved-memory {
> +		#address-cells =3D <1>;
> +		#size-cells =3D <1>;
> +		ranges;
> +
> +		/* Address must be kept in the lower 256 MiBs of DRAM for VE. */
> +		ve_memory: cma@4a000000 {
> +			compatible =3D "shared-dma-pool";
> +			reg =3D <0x4a000000 0x6000000>;
> +			no-map;

I'm not sure why no-map is needed.

And I guess we could use alloc-ranges to make sure the region is in
the proper memory range, instead of hardcoding it.

> +			linux,cma-default;
> +		};
> +	};
> +
>  	timer {
>  		compatible =3D "arm,armv7-timer";
>  		interrupts =3D <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LO=
W)>,
> @@ -451,6 +465,23 @@
>  			};
>  		};
> =20
> +		ve: video-engine@1c0e000 {
> +			compatible =3D "allwinner,sun4i-a10-video-engine";

We should have an A20-specific compatible here, at least, so that we
can deal with any quirk we might find down the road.

> +			reg =3D <0x01c0e000 0x1000>;
> +			memory-region =3D <&ve_memory>;

Since you made the CMA region the default one, you don't need to tie
it to that device in particular (and you can drop it being mandatory
=66rom your binding as well).

> +
> +			clocks =3D <&ccu CLK_AHB_VE>, <&ccu CLK_VE>,
> +				 <&ccu CLK_DRAM_VE>;
> +			clock-names =3D "ahb", "mod", "ram";
> +
> +			assigned-clocks =3D <&ccu CLK_VE>;
> +			assigned-clock-rates =3D <320000000>;

This should be set from within the driver. If it's something that you
absolutely needed for the device to operate, you have no guarantee
that the clock rate won't change at any point in time after the device
probe, so that's not a proper solution.

And if it's not needed and can be adjusted depending on the
framerate/codec/resolution, then it shouldn't be in the DT either.

Don't you also need to map the SRAM on the A20?

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--gx2hl7khsqiaus56
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlrZmRsACgkQ0rTAlCFN
r3R9xg//dFuCF8cj+KUFlzUtLmAW1g2AwbUwXCoICaZgR9ZOzVgTI/GZJCn/wtSG
rJGNID9/YcWQNxKbJFEhl8e9aORyfhLUVAA/+OyF4kyzahHEM/tGCBKN77ccWHPD
uhK3f4tM21y5zOdG5rI7LIhIzhNPVApQHW8pf7vPBZZK4vqq+qs7wzbrnYdcL/EQ
Fg9epdkxT3TIbY/ieQSGL5dxedBIJxbMiGgTfUxwUy0hN1DuUcdJ4vAfZdZzZK7o
DagfxCZ3WQ7kUgW/qZ5+nvKslrNaQtnn27NBS9o4UmomptXX0jtZNHb1Zr+0I3My
REZHgh4PSrUuosTMN/VSnJdDF3SYWYU3wdbc43uBSMLs4dLM7PROXPuZZuloJOdQ
5u4kJCAkBimaPR0TsNeuC5Y1svREXckrw8PJt1rb+RAnINJlJIfwpHfg5nFPaoZo
JIhtRplehmI28YsFchCL9IPjOw+LQPC+CEapB3vi+92s+6myOsIE3Ajb+dal9jDt
9qDRX66G5XpGGRyhIZX+NORYkobT9sdNPTkPrAokwoFOaysHEPfz+/eM6GIZYZvF
FWrV/Z8SVHxfI4nRCfuBZ0qYpvh8UAwh9eHb7dzuxgSoE0dNsSjmazWe5ljxzQOC
Z/5qEl4ms8QO3q3U553ZVAflrreQlRlWwLsu7b4CVTXxyAy+K7M=
=5+ze
-----END PGP SIGNATURE-----

--gx2hl7khsqiaus56--
