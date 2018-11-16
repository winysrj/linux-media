Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:40228 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727405AbeKPTxG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Nov 2018 14:53:06 -0500
Date: Fri, 16 Nov 2018 10:41:02 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-sunxi@googlegroups.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH 15/15] arm64: dts: allwinner: a64: Add Video Engine and
 reserved memory node
Message-ID: <20181116094102.6j5xhpptvelxtr6h@flea>
References: <20181115145013.3378-1-paul.kocialkowski@bootlin.com>
 <20181115145013.3378-16-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zta4mcirelbyep65"
Content-Disposition: inline
In-Reply-To: <20181115145013.3378-16-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--zta4mcirelbyep65
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 15, 2018 at 03:50:13PM +0100, Paul Kocialkowski wrote:
> This adds nodes for the Video Engine and the associated reserved memory
> for the A64. Up to 96 MiB of memory are dedicated to the CMA pool.
>=20
> The pool is located at the end of the first 256 MiB of RAM so that the
> VPU can access it. It is unclear whether this is still a hard
> requirement for this platform, but it seems safer that way.
>=20
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> ---
>  arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi | 25 +++++++++++++++++++
>  1 file changed, 25 insertions(+)
>=20
> diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi b/arch/arm64/b=
oot/dts/allwinner/sun50i-a64.dtsi
> index 88b3e9110833..a35a5c9ffbbe 100644
> --- a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
> +++ b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
> @@ -185,6 +185,20 @@
>  			(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
>  	};
> =20
> +	reserved-memory {
> +		#address-cells =3D <1>;
> +		#size-cells =3D <1>;
> +		ranges;
> +
> +		cma_pool: cma@4a000000 {
> +			compatible =3D "shared-dma-pool";
> +			size =3D <0x6000000>;
> +			alloc-ranges =3D <0x4a000000 0x6000000>;

This introduces a DTC warning, since you're using a unit-address, but
don't have a reg register.

I've fixed it in the other DT by renaming that node to
default-pool. You can also drop the label, it's not used anywhere.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--zta4mcirelbyep65
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCW+6QrgAKCRDj7w1vZxhR
xYhCAP9lH8ybHUmO+OKiYNiJnFP+NpRwzjLmReIqAREptX7ITAD+KhT6BKpJ/6k/
sgi9vKvs4YOjlwkJM+1Ib0hMwgRQUQc=
=bLkz
-----END PGP SIGNATURE-----

--zta4mcirelbyep65--
