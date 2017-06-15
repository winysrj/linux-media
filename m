Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44583 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750777AbdFOKPl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 06:15:41 -0400
Date: Thu, 15 Jun 2017 12:15:37 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, robh@kernel.org, pavel@ucw.cz,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 8/8] arm: dts: omap3: N9/N950: Add AS3645A camera flash
Message-ID: <20170615101537.wbahrypnwcd5jkdn@earth>
References: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
 <1497433639-13101-9-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6365dckl7rmwu6rx"
Content-Disposition: inline
In-Reply-To: <1497433639-13101-9-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--6365dckl7rmwu6rx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 14, 2017 at 12:47:19PM +0300, Sakari Ailus wrote:
> From: Sakari Ailus <sakari.ailus@iki.fi>
>=20
> Add the as3645a flash controller to the DT source as well as the flash
> property with the as3645a device phandle to the sensor DT node.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

> ---
>  arch/arm/boot/dts/omap3-n9.dts       |  1 +
>  arch/arm/boot/dts/omap3-n950-n9.dtsi | 14 ++++++++++++++
>  arch/arm/boot/dts/omap3-n950.dts     |  1 +
>  3 files changed, 16 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/omap3-n9.dts b/arch/arm/boot/dts/omap3-n9.=
dts
> index b9e58c5..f95e7b1 100644
> --- a/arch/arm/boot/dts/omap3-n9.dts
> +++ b/arch/arm/boot/dts/omap3-n9.dts
> @@ -26,6 +26,7 @@
>  		clocks =3D <&isp 0>;
>  		clock-frequency =3D <9600000>;
>  		nokia,nvm-size =3D <(16 * 64)>;
> +		flash =3D <&as3645a>;
>  		port {
>  			smia_1_1: endpoint {
>  				link-frequencies =3D /bits/ 64 <199200000 210000000 499200000>;
> diff --git a/arch/arm/boot/dts/omap3-n950-n9.dtsi b/arch/arm/boot/dts/oma=
p3-n950-n9.dtsi
> index df3366f..8bd6673 100644
> --- a/arch/arm/boot/dts/omap3-n950-n9.dtsi
> +++ b/arch/arm/boot/dts/omap3-n950-n9.dtsi
> @@ -265,6 +265,20 @@
> =20
>  &i2c2 {
>  	clock-frequency =3D <400000>;
> +
> +	as3645a: flash@30 {
> +		reg =3D <0x30>;
> +		compatible =3D "ams,as3645a";
> +		flash {
> +			flash-timeout-us =3D <150000>;
> +			flash-max-microamp =3D <320000>;
> +			led-max-microamp =3D <60000>;
> +			peak-current-limit =3D <1750000>;
> +		};
> +		indicator {
> +			led-max-microamp =3D <10000>;
> +		};
> +	};
>  };
> =20
>  &i2c3 {
> diff --git a/arch/arm/boot/dts/omap3-n950.dts b/arch/arm/boot/dts/omap3-n=
950.dts
> index 646601a..8fca038 100644
> --- a/arch/arm/boot/dts/omap3-n950.dts
> +++ b/arch/arm/boot/dts/omap3-n950.dts
> @@ -60,6 +60,7 @@
>  		clocks =3D <&isp 0>;
>  		clock-frequency =3D <9600000>;
>  		nokia,nvm-size =3D <(16 * 64)>;
> +		flash =3D <&as3645a>;
>  		port {
>  			smia_1_1: endpoint {
>  				link-frequencies =3D /bits/ 64 <210000000 333600000 398400000>;
> --=20
> 2.1.4
>=20

--6365dckl7rmwu6rx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAllCXkMACgkQ2O7X88g7
+pqnsA/+L/KlOTqWCbU1yc8OLzEIYXdZwFJirbiADe+ah3oNBFtw+gXEBPW49ZN5
D8bB9YgfPCcauzulew7yGCY8Hc6XFpbyOC4w4RDwIH5cWzT1GvsSzAArunmH+gvV
fqrLxjCaIqR39nWyGIwZm0Xy239Lh8nG23hMHL4+Wc2nW6tl96rx6e9AUK6pbnFu
YwfehnztmW4ZOn4FeAHXN4DIW7pfA+ptYput+alO/5T+1qU8rLWtZQz6WTztnuW4
+RWOuPTc2cZr/jugd+dJUqUXdXUf5ZD86u5oOhaAizuHna0+JtfM/qlTvh2cG6+3
jt+nuSLDwELNKqktKz66kdwarxr++3anlOd9hO6ClP6vMvkMqBE5yABfLn50Ux8c
F6dhbLt/o7hYa6ctdAhvAKsqhC58p7RwhEQ5Qw+rpkBU0FU2cv98gP0shvwAqn4i
qlFvwi35qse7Sa18qY0mnKIoQ7+j2W1PHlE4Mq0O60CQCb03vHmRtgP98AwUnbYp
JnNZjCX/sd7t5i9C6c6mfMHhciOmup6DboSAOjJpgFj3b+/j2TxRIUN4maWNAzq8
3Bs59mGyX/8vcMj5mCbeZ1kiNDaq6SIdJF7PUAq+m7GGeAeEY/bbrCKkAo9fc8kU
Tc5FThvDtYT/gD5eoyul1YvowdQmAFYqcD92qz4hsxmyEERue3s=
=EgCU
-----END PGP SIGNATURE-----

--6365dckl7rmwu6rx--
