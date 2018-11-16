Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:40074 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727398AbeKPTus (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Nov 2018 14:50:48 -0500
Date: Fri, 16 Nov 2018 10:39:04 +0100
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
Subject: Re: [PATCH 08/15] ARM/arm64: sunxi: Move H3/H5 syscon label over to
 soc-specific nodes
Message-ID: <20181116093904.4ikn7ldksrm3mp5d@flea>
References: <20181115145013.3378-1-paul.kocialkowski@bootlin.com>
 <20181115145013.3378-9-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ypdydyzd7tg5dqmr"
Content-Disposition: inline
In-Reply-To: <20181115145013.3378-9-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ypdydyzd7tg5dqmr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 15, 2018 at 03:50:06PM +0100, Paul Kocialkowski wrote:
> Now that we have specific nodes for the H3 and H5 system-controller
> that allow proper access to the EMAC clock configuration register,
> we no longer need a common dummy syscon node.
>=20
> Switch the syscon label over to each platform's dtsi file.
>=20
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> ---
>  arch/arm/boot/dts/sun8i-h3.dtsi              | 2 +-
>  arch/arm/boot/dts/sunxi-h3-h5.dtsi           | 6 ------
>  arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi | 2 +-
>  3 files changed, 2 insertions(+), 8 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/sun8i-h3.dtsi b/arch/arm/boot/dts/sun8i-h3=
=2Edtsi
> index 7157d954fb8c..b337a9282783 100644
> --- a/arch/arm/boot/dts/sun8i-h3.dtsi
> +++ b/arch/arm/boot/dts/sun8i-h3.dtsi
> @@ -134,7 +134,7 @@
>  	};
> =20
>  	soc {
> -		system-control@1c00000 {
> +		syscon: system-control@1c00000 {
>  			compatible =3D "allwinner,sun8i-h3-system-control";
>  			reg =3D <0x01c00000 0x1000>;
>  			#address-cells =3D <1>;
> diff --git a/arch/arm/boot/dts/sunxi-h3-h5.dtsi b/arch/arm/boot/dts/sunxi=
-h3-h5.dtsi
> index 4b1530ebe427..9175ff0fb59a 100644
> --- a/arch/arm/boot/dts/sunxi-h3-h5.dtsi
> +++ b/arch/arm/boot/dts/sunxi-h3-h5.dtsi
> @@ -152,12 +152,6 @@
>  			};
>  		};
> =20
> -		syscon: syscon@1c00000 {
> -			compatible =3D "allwinner,sun8i-h3-system-controller",
> -				"syscon";
> -			reg =3D <0x01c00000 0x1000>;
> -		};
> -

You're also dropping the syscon compatible there. But I'm not sure how
it could work with the H3 EMAC driver that would overwrite the
compatible already.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--ypdydyzd7tg5dqmr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCW+6QOAAKCRDj7w1vZxhR
xVEBAP9w7VNX04IScl8O7/odk/H9hMEi4v1Aest60/fLT6hHNgEAwFdFLIlhGfMp
H40TTqWfkB+Ts5YDCYZF6C8EgG6kYgM=
=LdxL
-----END PGP SIGNATURE-----

--ypdydyzd7tg5dqmr--
