Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41856 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755013AbdIHNSA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 09:18:00 -0400
Date: Fri, 8 Sep 2017 15:17:58 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 3/3] as3645a: Use integer numbers for parsing LEDs
Message-ID: <20170908131758.GQ18365@amd>
References: <20170908124213.18904-1-sakari.ailus@linux.intel.com>
 <20170908124213.18904-4-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="wr1Q/2bz0MCWWNYv"
Content-Disposition: inline
In-Reply-To: <20170908124213.18904-4-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--wr1Q/2bz0MCWWNYv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2017-09-08 15:42:13, Sakari Ailus wrote:
> Use integer numbers for LEDs, 0 is the flash and 1 is the indicator.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Dunno. Old code is shorter, old device tree is shorter, ... IMO both
versions are fine, because the LEDs are really different. Do we have
documentation somewhere saying that reg=3D should be used for this? Are
you doing this for consistency?

Best regards,
									Pavel

>  arch/arm/boot/dts/omap3-n950-n9.dtsi |  8 ++++++--
>  drivers/leds/leds-as3645a.c          | 26 ++++++++++++++++++++++++--


> @@ -267,15 +267,19 @@
>  	clock-frequency =3D <400000>;
> =20
>  	as3645a@30 {
> +		#address-cells =3D <1>;
> +		#size-cells =3D <0>;
>  		reg =3D <0x30>;
>  		compatible =3D "ams,as3645a";
> -		flash {
> +		flash@0 {
> +			reg =3D <0x0>;
>  			flash-timeout-us =3D <150000>;
>  			flash-max-microamp =3D <320000>;
>  			led-max-microamp =3D <60000>;
>  			ams,input-max-microamp =3D <1750000>;
>  		};
> -		indicator {
> +		indicator@1 {
> +			reg =3D <0x1>;
>  			led-max-microamp =3D <10000>;
>  		};
>  	};
> diff --git a/drivers/leds/leds-as3645a.c b/drivers/leds/leds-as3645a.c
> index e3f89c6130d2..605e0c64e974 100644
> --- a/drivers/leds/leds-as3645a.c
> +++ b/drivers/leds/leds-as3645a.c
> @@ -112,6 +112,10 @@
>  #define AS_PEAK_mA_TO_REG(a) \
>  	((min_t(u32, AS_PEAK_mA_MAX, a) - 1250) / 250)
> =20
> +/* LED numbers for Devicetree */
> +#define AS_LED_FLASH				0
> +#define AS_LED_INDICATOR			1
> +
>  enum as_mode {
>  	AS_MODE_EXT_TORCH =3D 0 << AS_CONTROL_MODE_SETTING_SHIFT,
>  	AS_MODE_INDICATOR =3D 1 << AS_CONTROL_MODE_SETTING_SHIFT,
> @@ -491,10 +495,29 @@ static int as3645a_parse_node(struct as3645a *flash,
>  			      struct device_node *node)
>  {
>  	struct as3645a_config *cfg =3D &flash->cfg;
> +	struct device_node *child;
>  	const char *name;
>  	int rval;
> =20
> -	flash->flash_node =3D of_get_child_by_name(node, "flash");
> +	for_each_child_of_node(node, child) {
> +		u32 id =3D 0;
> +
> +		of_property_read_u32(child, "reg", &id);
> +
> +		switch (id) {
> +		case AS_LED_FLASH:
> +			flash->flash_node =3D of_node_get(child);
> +			break;
> +		case AS_LED_INDICATOR:
> +			flash->indicator_node =3D of_node_get(child);
> +			break;
> +		default:
> +			dev_warn(&flash->client->dev,
> +				 "unknown LED %u encountered, ignoring\n", id);
> +			break;
> +		}
> +	}
> +
>  	if (!flash->flash_node) {
>  		dev_err(&flash->client->dev, "can't find flash node\n");
>  		return -ENODEV;
> @@ -538,7 +561,6 @@ static int as3645a_parse_node(struct as3645a *flash,
>  			     &cfg->peak);
>  	cfg->peak =3D AS_PEAK_mA_TO_REG(cfg->peak);
> =20
> -	flash->indicator_node =3D of_get_child_by_name(node, "indicator");
>  	if (!flash->indicator_node) {
>  		dev_warn(&flash->client->dev,
>  			 "can't find indicator node\n");

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--wr1Q/2bz0MCWWNYv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlmymIYACgkQMOfwapXb+vKodwCfSUocpQ1MRsDRqMfoHmf9UG18
/qgAoLZH9MyDxdmzLioVjHvO5RtUcz50
=b4Gk
-----END PGP SIGNATURE-----

--wr1Q/2bz0MCWWNYv--
