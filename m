Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751152AbdJ2XIk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 19:08:40 -0400
Date: Mon, 30 Oct 2017 00:08:37 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v16 32/32] arm: dts: omap3: N9/N950: Add flash references
 to the camera
Message-ID: <20171029230837.vjs4f7wi7tj7q3bc@earth>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
 <20171026075342.5760-33-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jcz4dhtxtkeqmra6"
Content-Disposition: inline
In-Reply-To: <20171026075342.5760-33-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--jcz4dhtxtkeqmra6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 26, 2017 at 10:53:42AM +0300, Sakari Ailus wrote:
> Add flash and indicator LED phandles to the sensor node.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> ---

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

>  arch/arm/boot/dts/omap3-n9.dts       | 1 +
>  arch/arm/boot/dts/omap3-n950-n9.dtsi | 4 ++--
>  arch/arm/boot/dts/omap3-n950.dts     | 1 +
>  3 files changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/omap3-n9.dts b/arch/arm/boot/dts/omap3-n9.=
dts
> index b9e58c536afd..39e35f8b8206 100644
> --- a/arch/arm/boot/dts/omap3-n9.dts
> +++ b/arch/arm/boot/dts/omap3-n9.dts
> @@ -26,6 +26,7 @@
>  		clocks =3D <&isp 0>;
>  		clock-frequency =3D <9600000>;
>  		nokia,nvm-size =3D <(16 * 64)>;
> +		flash-leds =3D <&as3645a_flash &as3645a_indicator>;
>  		port {
>  			smia_1_1: endpoint {
>  				link-frequencies =3D /bits/ 64 <199200000 210000000 499200000>;
> diff --git a/arch/arm/boot/dts/omap3-n950-n9.dtsi b/arch/arm/boot/dts/oma=
p3-n950-n9.dtsi
> index 1b0bd72945f2..12fbb3da5fce 100644
> --- a/arch/arm/boot/dts/omap3-n950-n9.dtsi
> +++ b/arch/arm/boot/dts/omap3-n950-n9.dtsi
> @@ -271,14 +271,14 @@
>  		#size-cells =3D <0>;
>  		reg =3D <0x30>;
>  		compatible =3D "ams,as3645a";
> -		flash@0 {
> +		as3645a_flash: flash@0 {
>  			reg =3D <0x0>;
>  			flash-timeout-us =3D <150000>;
>  			flash-max-microamp =3D <320000>;
>  			led-max-microamp =3D <60000>;
>  			ams,input-max-microamp =3D <1750000>;
>  		};
> -		indicator@1 {
> +		as3645a_indicator: indicator@1 {
>  			reg =3D <0x1>;
>  			led-max-microamp =3D <10000>;
>  		};
> diff --git a/arch/arm/boot/dts/omap3-n950.dts b/arch/arm/boot/dts/omap3-n=
950.dts
> index 646601a3ebd8..c354a1ed1e70 100644
> --- a/arch/arm/boot/dts/omap3-n950.dts
> +++ b/arch/arm/boot/dts/omap3-n950.dts
> @@ -60,6 +60,7 @@
>  		clocks =3D <&isp 0>;
>  		clock-frequency =3D <9600000>;
>  		nokia,nvm-size =3D <(16 * 64)>;
> +		flash-leds =3D <&as3645a_flash &as3645a_indicator>;
>  		port {
>  			smia_1_1: endpoint {
>  				link-frequencies =3D /bits/ 64 <210000000 333600000 398400000>;
> --=20
> 2.11.0
>=20

--jcz4dhtxtkeqmra6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAln2X3QACgkQ2O7X88g7
+pqXXg/7BOTXpAtSXNm5Jmgi3KzC2fGX2eCXAwN/f/xWU+IVJoAean0K7KC0E/te
9d+suSOtsU1S5GSKNy3ejz3SV4uZifVfxRO7HeD+dArMn0bEoRhKhFfnb4LXGWDk
wDTjfQI+Y8FG8y7xUPAJp5DDH/dG62pyxxx6z/rt05tJ3fEkkd0NoITu+M+rM5kk
+3uLK0pbJB0Wep2NwXfy3TQ3iUwdD0/QWbxkpssnrgKpKnTpa6VXvboN1t6J1S6K
Y0+Upw4ft2B3U48t5zDAb3r3GVrRaRKveTzSxH+NA5crTZ4eGB0FKM1xOR/Rudqc
J9bJYGEvXr55aj62SYYk3iFbdwhEnaExb3SurzyeJmyw2tJs7h0BDv09lhQ7gKpi
OzJnC4/xao/YnV9NtUo716dznsS53+Hk95GjGvRCk6OjtHPUrJDHD+xmHo74opI9
H25iTq3zqpbtwa4OCEnOV4Tf+jIMtexo34EFUesHiM9QXNWO5/nTzELaiwH9XhJ/
LnVCptWXKXTZXtYshZHE0mU0/zMguzqcISnUSd3V58R0tshSyupHE9ZwiABQzSsv
bIY/i8ohvqbyyU2fB5k3N0H4D83ySJWG0JJfXfNnjkRnJA/vUiEyT4ee7R4GmlRL
A7MW0NRoWHZrjQrjDfQKlupY2FOqmcsVo1te++M9O1UUUD8GlRc=
=clOP
-----END PGP SIGNATURE-----

--jcz4dhtxtkeqmra6--
