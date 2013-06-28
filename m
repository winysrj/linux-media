Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:57648 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab3F1Jeo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 05:34:44 -0400
Date: Fri, 28 Jun 2013 12:34:06 +0300
From: Felipe Balbi <balbi@ti.com>
To: Jingoo Han <jg1.han@samsung.com>
CC: <linux-arm-kernel@lists.infradead.org>,
	<linux-samsung-soc@vger.kernel.org>,
	"'Kishon Vijay Abraham I'" <kishon@ti.com>,
	<linux-media@vger.kernel.org>,
	"'Kukjin Kim'" <kgene.kim@samsung.com>,
	"'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
	"'Felipe Balbi'" <balbi@ti.com>,
	"'Tomasz Figa'" <t.figa@samsung.com>,
	<devicetree-discuss@lists.ozlabs.org>,
	"'Inki Dae'" <inki.dae@samsung.com>,
	"'Donghwa Lee'" <dh09.lee@samsung.com>,
	"'Kyungmin Park'" <kyungmin.park@samsung.com>,
	"'Jean-Christophe PLAGNIOL-VILLARD'" <plagnioj@jcrosoft.com>,
	<linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH V2 2/3] ARM: dts: Add DP PHY node to exynos5250.dtsi
Message-ID: <20130628093406.GC11297@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <002001ce73cf$721b9d80$5652d880$@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8X7/QrJGcKSMr1RN"
Content-Disposition: inline
In-Reply-To: <002001ce73cf$721b9d80$5652d880$@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--8X7/QrJGcKSMr1RN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 28, 2013 at 04:16:44PM +0900, Jingoo Han wrote:
> Add PHY provider node for the DP PHY.
>=20
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  arch/arm/boot/dts/exynos5250.dtsi |   13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos=
5250.dtsi
> index 41cd625..f7bac75 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -614,6 +614,12 @@
>  		interrupts =3D <0 94 0>;
>  	};
> =20
> +	dp_phy: video-phy@10040720 {
> +		compatible =3D "samsung,exynos5250-dp-video-phy";
> +		reg =3D <0x10040720 4>;
> +		#phy-cells =3D <0>;
> +	};
> +
>  	dp-controller {
>  		compatible =3D "samsung,exynos5-dp";
>  		reg =3D <0x145b0000 0x1000>;
> @@ -623,11 +629,8 @@
>  		clock-names =3D "dp";
>  		#address-cells =3D <1>;
>  		#size-cells =3D <0>;
> -
> -		dptx-phy {
> -			reg =3D <0x10040720>;
> -			samsung,enable-mask =3D <1>;
> -		};
> +		phys =3D <&dp_phy 0>;

phy-cells being 0, means that this would become:

		phys =3D <&dp_phy>;

> +		phy-names =3D "dp";

for the label, I would use something more descriptive such as
'display-port'.

other than that:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--8X7/QrJGcKSMr1RN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRzViOAAoJEIaOsuA1yqREhG4P/3wTpZ6Xk9AcXdJkBPgKJEFK
l4BxatBXxHE9CRcYEfOuuvHiT30zwEWIfAtGsJ9iKhLJ3MlFihHMnDU/SWKQopPJ
l3pyPYnI7dYAbvlbzDtjyFQetyDPJFvTjoN0tqNzuR1nosaKlZsMvomt2XdczVnb
pSSkTIIbZXXW7TR/k8Q6eyIWbkSuxJ54uY1J4pgFaenouDs1/03VmuMYziNYc/lf
5BaPUdoEP7Qb4TkEaG9wV0eFVZkmjV9/Xkkv1J3paUHAakRkRPlKxFndSkIeqvCn
vhPFauLsG0WRBeaTMdm/S5qln/VNHnOzqs9+o6siwY4g84fWg53OhHsu2zo/5AkM
04PuIcRMx45wjfZK9imuxO9tPjpLQp92Fdk0E+ZjQ7qdTkciAnsApoPdb6OhyzQ8
4zymiY8rkU+s8d/CyUETa/vmFetVvHYjPKCxLwA8IB8g/Z24yN5krxE2OLP5ksH/
yboRFCtX6ijGEh0AR0GKVlnsaALOb0sKDS2QCQXIPG1ElPFBMpRhmeQiSW4X2My/
c8XWjhK5bUjibds5Waybira+2FzKjhyw96yAo5Wvvcg1XnQcAYc+pR8SkGjXJnTB
L6muIBM2p27rO/1z4Li2NsVhCtVXbSa9pvV/PU3gwVXmJJqrHNfTi6R+VdqYXRNK
sfXOGObR7+OaNR3ES/uJ
=8+yS
-----END PGP SIGNATURE-----

--8X7/QrJGcKSMr1RN--
