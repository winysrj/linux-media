Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36142 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751166AbdIIScn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Sep 2017 14:32:43 -0400
Date: Sat, 9 Sep 2017 20:32:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-acpi@vger.kernel.org,
        mika.westerberg@intel.com, devicetree@vger.kernel.org,
        sre@kernel.org
Subject: Re: [PATCH v9 24/24] arm: dts: omap3: N9/N950: Add flash references
 to the camera
Message-ID: <20170909183240.GA15397@amd>
References: <20170908131235.30294-1-sakari.ailus@linux.intel.com>
 <20170908131822.31020-20-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <20170908131822.31020-20-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Add flash and indicator LED phandles to the sensor node.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

I'm adding similar support to et8ek8 and wonder.. why don't you also
add support for autofocus? Driver not yet available?

Thanks,
							Pavel
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

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlm0M8gACgkQMOfwapXb+vIvZQCfate7l5DVw3yuBkMxAzasFiS3
fE8AoJKmlEnPsw/DqFrOArXFG6qVcieC
=ASCE
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
